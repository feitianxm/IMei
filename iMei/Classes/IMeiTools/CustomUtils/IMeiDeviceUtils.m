//
//  DeviceUtils.m
//  IMeiApp
//
//  Created by Chengfei Liang on 16/5/27.
//  Copyright © 2016年 i美. All rights reserved.
//

#import "IMeiDeviceUtils.h"
#import "IMeiKeyChainUtils.h"
#import "IMeiDataPathService.h"
#import "NSObject+SBJSON.h"

//Get IP 需要导入的库文件

#import <ifaddrs.h>

#import <arpa/inet.h>


//Get MAC 需要导入的库文件

#include <sys/socket.h> // Per msqr

#include <sys/sysctl.h>

#include <net/if.h>

#include <net/if_dl.h>


@implementation DeviceUtils

/**
 * @brief 获取当前设备Name.
 * @return 返回当前设备Name
 */
+ (NSString*)currentDeviceName
{
    return [[UIDevice currentDevice] name];
}


/**
 * @brief 获取当前设备Model.
 * @return 返回当前设备Model
 */
+ (NSString*)currentDeviceModel
{
    return [[UIDevice currentDevice] model];
}

/**
 * @brief 获取当前设备SystemName.
 * @return 返回当前设备SystemName
 */
+ (NSString*)currentDeviceSystemName
{
    return [[UIDevice currentDevice] systemName];
}

/**
 * @brief 获取当前设备SystemVersion.
 * @return 返回当前设备SystemVersion
 */
+ (NSString*)currentDeviceSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (long long)longDiskSpace
{
    @try {
        // Set up variables
        long long DiskSpace = 0L;
        NSError *Error = nil;
        NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&Error];
        
        // Get the file attributes of the home directory assuming no errors
        if (Error == nil) {
            // Get the size of the filesystem
            DiskSpace = [[FileAttributes objectForKey:NSFileSystemSize] longLongValue];
        } else {
            // Error, return nil
            return -1;
        }
        
        // Check to make sure it's a valid size
        if (DiskSpace <= 0)
        {
            // Invalid size
            return -1;
        }
        
        // Successful
        return DiskSpace;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

/**
 * @brief 获取当前设备TotalMemoryDouble.
 * @return 返回当前设备TotalMemoryDouble
 */
+ (double)currentDeviceTotalMemoryDouble
{
    long long Space = [self longDiskSpace];
    
    if (Space <= 0)
    {
        return 0;
    }
    
    double NumberBytes = 1.0 * Space;
    double TotalGB = NumberBytes/(1024*1024*1024);
    
    if ( TotalGB <= 0)
    {
        return 0;
    }
    
    return (TotalGB*100000000);
}

/**
 * @brief 获取当前设备TotalMemory.
 * @return 返回当前设备TotalMemory
 */
+ (NSString*)currentDeviceTotalMemory
{
    return [NSString stringWithFormat:@"%.2f", [self currentDeviceTotalMemoryDouble]];
}

/**
 * @brief 获取当前设备Resolution.
 * @return 返回当前设备Resolution
 */
+ (NSString*)currentDeviceResolution
{
    UIScreen *MainScreen = [UIScreen mainScreen];
    
    CGSize Size = [MainScreen bounds].size;
    
    CGFloat scale = [MainScreen scale];
    
    int screenWidth = Size.width * scale;
    
    int screenHeight = Size.height * scale;
    
    return [NSString stringWithFormat:@"%d*%d", screenWidth, screenHeight];
}

/**
 * @brief 获取当前设备类型.
 * @return iphone/ipad
 */
+ (BOOL)currentDeviceIsPhone
{
    NSString *devType = [[UIDevice currentDevice] model];
    
    if ( [devType isEqualToString:@"iPhone"])
    {
        return YES;
    }
    
    return NO;
}


/**
 * @brief 获取当前设备是否越狱.
 * @return 越狱返回YES,不越狱返回NO
 */
+ (BOOL)currentDeviceIsBreak
{
    BOOL cydia = NO;
    BOOL binBash = NO;
    NSString *filePath = @"/Applications/Cydia.app";
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        cydia = YES;
    }
    
    FILE * f = fopen("/bin/bash", "r");
    
    if (f != NULL)
    {
        binBash = YES;
    }
    
    fclose(f);
    
    if (cydia || binBash)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


/**
 * @brief 获取当前app uuid.
 * @return 当前app uuid
 */
+ (NSString*)currentAppUUID
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}


/**
 * @brief 获取当前app标识.
 * @return 当前app标识:com.xxx.xxx
 */
+ (NSString*)currentAppIdentifier
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

/**
 * @brief 获取当前应用版本号.
 * @return 当前当前应用版本号:1.0.0
 */
+ (NSString*)currentAppVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}


/**
 * @brief 获取当前app登录的当前用户.
 * @return 当前appapp登录的当前用户
 */
+ (NSString*)currentAppLoadUserName
{
//    return [LVUserDefaultUtil shareInstance].strTheAppUserName;
    return nil;
}


/**
 * @brief 获取当前app 用户文件夹路径.
 * @return 当前appapp 用户文件夹路径
 */
+ (NSString*)currentAppUserPath:(NSString*)strUserName
{
    if ( [strUserName length] == 0)
    {
        return nil;
    }
    
    return [ [IMeiDataPathService pathForConfigFileOfUser:strUserName] stringByAppendingPathComponent:strUserName];
}


#pragma mark IP
/**
 *  @Author, 15-03-24 09:07:06
 *
 *  Get IP Address
 *
 *  #import <ifaddrs.h>
 *
 *  #import <arpa/inet.h>
 *
 *  @return
 */

+ (NSString *)getIPAddress
{
    
    NSString *address = @"error";
    
    struct ifaddrs *interfaces = NULL;
    
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) {
        
        // Loop through linked list of interfaces
        
        temp_addr = interfaces;
        
        while(temp_addr != NULL) {
            
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                
                // Check if interface is en0 which is the wifi connection on the iPhone
                
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    
                    // Get NSString from C String
                    
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
        
    }
    
    // Free memory
    
    freeifaddrs(interfaces);
    
    return address;
}

+ (NSString *)getMacAddress
{
    int mib[6];
    
    size_t len;
    
    char *buf;
    
    unsigned char *ptr;
    
    struct if_msghdr *ifm;
    
    struct sockaddr_dl *sdl;
    
    
    mib[0] = CTL_NET;
    
    mib[1] = AF_ROUTE;
    
    mib[2] = 0;
    
    mib[3] = AF_LINK;
    
    mib[4] = NET_RT_IFLIST;
    
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        
        printf("Error: if_nametoindex error/n");
        
        return NULL;
        
    }
    
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        
        printf("Error: sysctl, take 1/n");
        
        return NULL;
        
    }
    
    if ((buf = malloc(len)) == NULL) {
        
        printf("Could not allocate memory. error!/n");
        
        return NULL;
        
    }
    
    
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        
        printf("Error: sysctl, take 2");
        
        return NULL;
        
    }
    
    
    ifm = (struct if_msghdr *)buf;
    
    sdl = (struct sockaddr_dl *)(ifm + 1);
    
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}

//获取设备UUID信息
+ (NSString*)getDeviceUUID
{
    NSString * uuidString = (NSString *) [IMeiKeyChainUtils load:LGS_KeyChain_UUID_Key];
    
    //首次执行该方法时，uuid为空
    if ([uuidString isEqualToString:@""] || !uuidString)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
         [IMeiKeyChainUtils save:LGS_KeyChain_UUID_Key data:uuidString];
        
    }
    //IMLOG(@"uuidString strUUID=>%@", uuidString);
    return uuidString;
}


//获得设备型号
//+ (NSString *)getDeviceModel
//{
//    int mib[2];
//    size_t len;
//    char *machine;
//    
//    mib[0] = CTL_HW;
//    mib[1] = HW_MACHINE;
//    sysctl(mib, 2, NULL, &len, NULL, 0);
//    machine = malloc(len);
//    sysctl(mib, 2, machine, &len, NULL, 0);
//    
//    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
//    free(machine);
//    
//    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
//    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
//    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
//    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
//    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
//    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
//    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
//    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
//    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
//    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
//    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
//    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
//    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
//    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6Plus";
//    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
//    
//    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
//    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
//    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
//    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
//    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
//    
//    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
//    
//    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
//    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
//    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
//    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
//    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
//    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
//    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
//    
//    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
//    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
//    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
//    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
//    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
//    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
//    
//    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
//    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
//    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
//    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
//    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
//    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
//    
//    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
//    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
//    return platform;
//}


+ (NSString*)getDeviceJsonInfoWithUserName:(NSString*)userName
{
    NSString *strusername = userName;
    NSString *strbrand = @"Apple";
    NSString *itotalmemory = [self currentDeviceTotalMemory];
    NSString *iroot = [self currentDeviceIsBreak] ? @"1" : @"0";
    NSString *idevvest = @"2";  //2：私人设备    1：公共设备
    NSString *strcpuname = @"";
    NSString *strresolution = [NSString stringWithFormat:@"%d*%d", (int)SCREEN_WIDTH_FIT, (int)SCREEN_HEIGHT_FIT];
    NSString *strosname = @"iOS";
    NSString *strkernelver = @"";
    NSString *idevtype = (DEVICE_TYPE == DEVICE_IPAD || DEVICE_TYPE == DEVICE_IPAD_PRO ? @"2" : @"1");           //LGS_Device_Type;
    NSString *strbluemac = @"";
    NSString *strwifimac = @""; //[self getMacAddress];
    NSString *strosversion = [self currentDeviceSystemVersion];
    NSString *strphonenumber = @"";
    NSString *strdevname = [self currentDeviceName];
    NSString *strdevmodel = [self currentDeviceModel];
    NSString *uidmobiledevid = [self getDeviceUUID];
    
    NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:strusername, @"strusername",
                             strbrand, @"strbrand",
                             itotalmemory, @"itotalmemory",
                             iroot, @"iroot",
                             idevvest, @"idevvest",
                             strcpuname, @"strcpuname",
                             strresolution, @"strresolution",
                             strosname, @"strosname",
                             strkernelver, @"strkernelver",
                             idevtype, @"idevtype",
                             strbluemac, @"strbluemac",
                             strwifimac, @"strwifimac",
                             strosversion, @"strosversion",
                             strphonenumber, @"strphonenumber",
                             strdevname, @"strdevname",
                             strdevmodel, @"strdevmodel",
                             uidmobiledevid, @"uidmobiledevid",
                             nil];
    
    return [tempDic JSONRepresentation];
}

@end
