//
//  IMeiTabBarViewController.m
//  iMei
//
//  Created by Chengfei Liang on 2018/8/3.
//  Copyright © 2018年 Chengfei Liang. All rights reserved.
//

#import "IMeiTabBarViewController.h"
#import "IMeiOneViewController.h"
#import "IMeiTwoViewController.h"
#import "IMeiThreeViewController.h"
#import "IMeiFourViewController.h"
#import "IMeiCenterViewController.h"
#import "IMeiTabBarView.h"


@interface IMeiTabBarViewController () <IMeiTabBarViewDelegate>

@property (nonatomic, strong)IMeiTabBarView *tabBarView;
/**
 *  记录上次点击按钮的索引
 */
@property (nonatomic, assign) NSUInteger lastIndex;

@end

@implementation IMeiTabBarViewController


#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [self createSubViewControllers];
    [super viewDidLoad];
    
}

- (void)dealloc
{
    IMLOG(@"IMeiTabBarViewController dealloc...");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - customMethods
- (void)createSubViewControllers
{
    IMLOG(@"createSubViewControllers...");
    //Tabar栏模块普通态icon图
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:
                              [UIImage imageNamed:@"tab_buddy_nor.png"],
                              [UIImage imageNamed:@"tab_me_nor.png"],
                              [UIImage imageNamed:@"tab_qworld_nor.png"],
                              [UIImage imageNamed:@"tab_recent_nor.png"], nil];
    
    //Tabar栏模块选中态icon图
    NSMutableArray *selectedArray = [[NSMutableArray alloc]initWithObjects:
                                     [UIImage imageNamed:@"tab_buddy_press.png"],
                                     [UIImage imageNamed:@"tab_me_press.png"],
                                     [UIImage imageNamed:@"tab_qworld_press.png"],
                                     [UIImage imageNamed:@"tab_recent_press.png"], nil];
    
    NSMutableArray * titles = [[NSMutableArray alloc]initWithObjects:@"首页",@"消息",@"发现",@"个人", nil];
    
    IMeiOneViewController *oneVc = [[IMeiOneViewController alloc]init];
    IMeiTwoViewController *twoVc = [[IMeiTwoViewController alloc]init];
    IMeiThreeViewController *threeVc = [[IMeiThreeViewController alloc]init];
    IMeiFourViewController *fourVc = [[IMeiFourViewController alloc]init];
    IMeiCenterViewController *centerVc = [[IMeiCenterViewController alloc]init];
    
//    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:twoVc];
//    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:threeVc];
    
    
    self.tabBarView = [[IMeiTabBarView alloc] initWithItemSelectedImages:selectedArray
                                                            normalImages:array
                                                                  titles:titles];
    self.showCenterItem = YES;
    self.centerItemImage = [UIImage imageNamed:@"btn_release.png"];
    self.viewControllers = @[oneVc, twoVc, threeVc, fourVc];
    self.textColor = [UIColor redColor];
    [self tabBarBadgeValue:345 item:2];
    [self tabBarBadgeValue:3 item:1];
    
    self.centerViewController = centerVc;
    
    self.tabBarView.backgroundColor = [UIColor whiteColor];
    self.tabBarView.delegate = self;
    [self.view addSubview:self.tabBarView];
    self.tabBarView.itemSelectedIndex = 0;

}


-(void)tabBarBadgeValue:(NSUInteger)value item:(NSInteger)index
{
    [self.tabBarView tabBarBadgeValue:value item:index];
}


#pragma mark - 初始化数据
-(void)setShowCenterItem:(BOOL)showCenterItem
{
    _showCenterItem = showCenterItem;
    self.tabBarView.showCenter = _showCenterItem;
}

-(void)setCenterItemImage:(UIImage *)centerItemImage
{
    _centerItemImage = centerItemImage;
    self.tabBarView.centerImage = centerItemImage;
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.tabBarView.textColor = _textColor;
}

-(void)setSelectedItem:(NSInteger)selectedItem
{
    _selectedItem = selectedItem;
    self.selectedIndex = _selectedItem;
    self.tabBarView.itemSelectedIndex = _selectedItem;
}

-(void)setXm_centerViewController:(UIViewController *)im_centerViewController
{
    _centerViewController = im_centerViewController;
}


#pragma mark - IMeiTabBarViewDelegate
-(void)tabBarViewSelectedItem:(NSInteger)index
{
    self.lastIndex = index;
    self.selectedIndex = index;
}

-(void)tabBarViewCenterItemClick:(UIButton *)button
{
    [self presentViewController:_centerViewController animated:YES completion:nil];
}

#pragma mark - 共有方法
-(void)showCenterViewController:(BOOL)show animated:(BOOL)animated
{
    if (show)
    {
        [self presentViewController:_centerViewController animated:animated completion:nil];
        return;
    }
    [self imTabBarHidden:NO animated:YES];
    [self dismissViewControllerAnimated:animated completion:nil];
}

-(void)imTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    
    NSTimeInterval duration;
    
    animated == YES ? duration = 0.24:0;
    
    [UIView animateWithDuration:duration animations:^{
        if (hidden) {
            self.tabBarView.frame = CGRectMake(0, SCREEN_HEIGHT_FIT + 50, SCREEN_WIDTH_FIT, 49);
        }else{
            self.tabBarView.frame = CGRectMake(0, SCREEN_HEIGHT_FIT-49, SCREEN_WIDTH_FIT, 49);
        }
    } completion:^(BOOL finished) {
        
    }];
}


@end
