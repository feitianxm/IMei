//
//  IMeiLocalDBService.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/23.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiLocalDBService.h"
#import "IMeiDataPathService.h"

@interface IMeiLocalDBService ()
{
    NSFileManager           *fileManager;
    NSMutableDictionary     *oldFieldDictionary;    //旧的数据库字段信息
}

@end

@implementation IMeiLocalDBService


static IMeiLocalDBService *instance = nil;

+ (id)shareLocalDBService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)releaseLocalDBService
{
    instance = nil;
}

- (id)init
{
    if (self = [super init]) {
        isDBOpen = NO;
        fileManager = [NSFileManager defaultManager];
        oldFieldDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - DB打开及关闭
//在打开DB连接时先判断DB文件是否存在且能打开
- (BOOL)isCanOpen
{
    NSString *filePath = [IMeiDataPathService pathForDataBaseFile];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //如果文件不存在，则不必要打开，直接返回打开失败
        //打开的工作将交由后面的open方法来做
        return FALSE;
    }
    
    if (sqlite3_open([filePath UTF8String], &dataBase) != SQLITE_OK) {
        //如果在文件存在的情况下还是打开不成功，则表示这个文件可能已经损坏，将这个文件删除并返回否
        //再次打开的工作将交由后面的open方法来做
        sqlite3_close(dataBase);
        [fileManager removeItemAtPath:filePath error:nil];
        return FALSE;
    }
    return TRUE;
}

//打开DataBase
- (BOOL)openDataBase
{
    if (isDBOpen == TRUE) {
        return TRUE;
    }
    
    NSString *filePath =  [IMeiDataPathService pathForDataBaseFile];
    
    if(sqlite3_open([filePath UTF8String],&dataBase) != SQLITE_OK){
        sqlite3_close(dataBase);
        return FALSE;
    }
    
    char *errorMsg;
    
    //设备id表
    NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS tbl_devsign(strdevsign text);";
    if (sqlite3_exec(dataBase, [sqlStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(dataBase);
        return FALSE;
    }
    
    //主机信息表
    sqlStr = @"CREATE TABLE IF NOT EXISTS tbl_hostinfo(strhostip text,strhostport text);";
    if (sqlite3_exec(dataBase, [sqlStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(dataBase);
        return FALSE;
    }
    
    //消息列表
    sqlStr = @"CREATE TABLE IF NOT EXISTS tbl_messageinfo(uidmessageid text,strtitle text,strcontent text,dttime timestamp,ireaded int);";
    if (sqlite3_exec(dataBase, [sqlStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(dataBase);
        return FALSE;
    }
    
    //安全扫描
    sqlStr = @"CREATE TABLE IF NOT EXISTS tbl_virusbaseinfo(uidvirusid varchar (48) not null, strfeaturecode varchar (512) null, strapppackage varchar (512) null, ivirustype int null, constraint pk_virusbaseinfo primary key (uidvirusid));";
    if (sqlite3_exec(dataBase, [sqlStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(dataBase);
        return FALSE;
    }
    
    //违规信息
    sqlStr = @"CREATE TABLE IF NOT EXISTS tbl_illegalinfo(uidrecordid varchar (48) not null,strusername varchar (48) not null, icheckitem int,isubtype int,irepairtype int,ichecktype int, strdesc text,strinfo text,dttime timestamp, iupload int, constraint pk_virusbaseinfo primary key (uidrecordid));";
    if (sqlite3_exec(dataBase, [sqlStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(dataBase);
        return FALSE;
    }
    
    //应用流量信息表
    sqlStr = @"CREATE TABLE IF NOT EXISTS tbl_appflowinfo(uidrecordid varchar (48) not null,strusername varchar (48) not null,strpackname varchar (128),strappname varchar (48),appuid varchar (48),dttime timestamp,iwififlow int,imobileflow int,itotalflow int,iupload int,isystemapp int,constraint pk_appflowinfo primary key (uidrecordid));";
    if (sqlite3_exec(dataBase, [sqlStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(dataBase);
        return FALSE;
    }
    
    //流量统计表
    sqlStr = @"CREATE TABLE IF NOT EXISTS tbl_flowtotal(uidrecordid varchar (48) not null,strusername varchar (48) not null,dttime timestamp,iwififlow long,imobileflow long,itotalflow long,iupload int,constraint pk_flowinfo primary key (uidrecordid));";
    if (sqlite3_exec(dataBase, [sqlStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(dataBase);
        return FALSE;
    }
    
    isDBOpen = TRUE;
    return TRUE;
}

//更新数据库
- (BOOL)updateDataBase
{
    if (isDBOpen != TRUE) {
        return false;
    }
//    if(updateVersion<22){//小于22版本的都只做一次升级
//        instance.addTables("tbl_illegalinfo", "create table if not exists tbl_illegalinfo (uidrecordid varchar (48) not null,strusername varchar (48) not null, icheckitem int,isubtype int,irepairtype int,ichecktype int, strdesc text,strinfo text,dttime timestamp, iupload int, constraint pk_virusbaseinfo primary key (uidrecordid));");
//        updateVersion = 22;
//    }
//    if(updateVersion==22&&updateVersion<newVersion){
//        instance.addTables("tbl_appflowinfo", "create table if not exists tbl_appflowinfo(uidrecordid varchar (48) not null,strusername varchar (48) not null,strpackname varchar (128),strappname varchar (48),dttime timestamp,iwififlow int,imobileflow int,itotalflow int,iupload int,constraint pk_appflowinfo primary key (uidrecordid));");
//        updateVersion = 23;
//    }
//    if(updateVersion==23&&updateVersion<newVersion){
//        instance.addTables("tbl_flowtotal", "create table if not exists tbl_flowtotal(uidrecordid varchar (48) not null,strusername varchar (48) not null,dttime timestamp,iwififlow int,imobileflow int,itotalflow int,iupload int,constraint pk_flowtotal primary key (uidrecordid));");
//        instance.addColumn("tbl_flowinfo", "isystemapp", "int");
//        instance.addColumn("tbl_flowinfo", "appuid", "varchar (48)");
//        updateVersion = 24;
//    }
    
    return true;
}

//关闭DataBase
- (void)closeDataBase
{
//    //IMLOG(@"closeDataBase...");
    if (dataBase != nil) {
        sqlite3_close(dataBase);
    }
    isDBOpen = NO;
}

//更新DataBase
- (BOOL)updateTableWithTableName:(NSString*)tableName
{
    BOOL oldResult = [self getOldFieldsWithTableName:tableName];
    //IMLOG(@"updateTableWithTableName oldResult=>%d", oldResult);
    if (!oldResult) {
        //如果取不到旧列，则返回否
        return FALSE;
    }
#warning 需要判断具体的数据库表进行更新
    
    NSArray *newFieldArray = [NSArray arrayWithObjects:@"USERID",
                              @"USERNAME", @"DIRECTION", @"CONTENT", @"TIMETAG",
                              @"MYID", @"SENDTYPE", @"TIMESPAN", @"UNREADFLAG", nil];
    for (NSString *newFieldName in newFieldArray) {
        BOOL updatedFlag = [[oldFieldDictionary objectForKey:newFieldName] boolValue];
        if (!updatedFlag) {
            //升级数据库的相应字段
            NSString *alterSqlStr = nil;
            if ([newFieldName isEqualToString:@"MYID"]) {
                alterSqlStr = @"alter table MESSAGE add MYID INTEGER;";
            }
            if ([newFieldName isEqualToString:@"SENDTYPE"]) {
                alterSqlStr = @"alter table MESSAGE add SENDTYPE INTEGER;";
            }
            if ([newFieldName isEqualToString:@"TIMESPAN"]) {
                alterSqlStr = @"alter table MESSAGE add TIMESPAN INTEGER;";
            }
            if ([newFieldName isEqualToString:@"UNREADFLAG"]) {
                alterSqlStr = @"alter table MESSAGE add UNREADFLAG INTEGER;";
            }
            if (alterSqlStr) {
                //正式执行数据库脚本
                char *errorMsg;
                if (sqlite3_exec(dataBase, [alterSqlStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
                    sqlite3_close(dataBase);
                }
            }
        }
    }
    return TRUE;
}

//获取旧的数据库表字段信息
- (BOOL)getOldFieldsWithTableName:(NSString*)tableName
{
    NSString *sqlStr = [NSString stringWithFormat:@"PRAGMA table_info(%@)", tableName]; //@"PRAGMA table_info(MESSAGE)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
        return NO;
    }
    
    [oldFieldDictionary removeAllObjects];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        NSString *fieldName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
        [oldFieldDictionary setObject:[NSNumber numberWithBool:TRUE] forKey:fieldName];
    }
    return YES;
}


#pragma mark - 内存释放
- (void)dealloc
{
    //IMLOG(@"IMeiLocalDBService dealloc...");
    [self closeDataBase];
}

@end
