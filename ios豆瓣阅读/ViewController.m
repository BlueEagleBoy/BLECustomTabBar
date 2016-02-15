//
//  ViewController.m
//  ios豆瓣阅读
//
//  Created by BlueEagleBoy on 16/2/15.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"
#define BLETableViewIdentifier @"cell_id"

//状态栏的高度
#define BLEStatusHeight [UIApplication sharedApplication].statusBarFrame.size.height
//导航栏的高度
#define BLENavigationBarHeight self.navigationController.navigationBar.frame.size.height
//tabBar的高度
#define BLETabBarHeight 44
//tabBar的开始位置
#define BLETabBarBeginY BLENavigationBarHeight + BLEStatusHeight
//tabBar的结束位置
#define BLETabBarEndY BLENavigationBarHeight - BLENavigationBarHeight + BLEStatusHeight
//屏宽
#define BLESCREENWIDTH [UIScreen mainScreen].bounds.size.width


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, assign)CGFloat tabBarFrameY;
@property (nonatomic, weak)UIView *tabBar;
@property (nonatomic, assign)CGFloat lastScrollOffsetY;



@end

@implementation ViewController


- (void)viewDidLoad {

    
    [super viewDidLoad];
    //定义一个tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    //注册cell
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BLETableViewIdentifier];
    
    //定义一个tabBar
    UIView *tabBar = [[UIView alloc]initWithFrame:CGRectMake(0, BLETabBarBeginY,BLESCREENWIDTH , BLETabBarHeight)];
    tabBar.backgroundColor = [UIColor redColor];
    [self.view addSubview:tabBar];
    self.tabBar = tabBar;
    
    // 设置tabbar的上次位移与scroll的开始位移一致
    self.lastScrollOffsetY = - BLETabBarBeginY;
    

}

#pragma mark tableView的datasoure方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BLETableViewIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    
    return cell;
}

#pragma mark scrollView的delegate方法
//设置开始状态的位置
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (!self.tabBar.hidden) {
        
        self.tabBarFrameY = BLETabBarBeginY;
 
    }else {
        
        self.tabBarFrameY = BLETabBarEndY;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    CGFloat delta = BLENavigationBarHeight + BLEStatusHeight - self.tabBar.y;
    
    CGFloat endStatus;
    
    if (delta <= BLETabBarHeight * 0.5 ) {
        
        endStatus = BLETabBarBeginY;
        
    }else {
       
        endStatus = BLETabBarEndY;
        
    }
    
    //在拖拽结束的时候根据tabbar的y值判断 是到哪个最终状态上
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tabBar.y = endStatus;
        
    } completion:^(BOOL finished) {
        
        if (endStatus == BLETabBarEndY) {
            
            self.tabBar.hidden = YES;
        }
    }];
  
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollDelta = scrollView.contentOffset.y - self.lastScrollOffsetY;
    
    self.lastScrollOffsetY = scrollView.contentOffset.y;
    
    self.tabBar.y = self.tabBar.y - scrollDelta;
    
    //判断tabBar的y值是否超越了指定的tabbar的BLETabBarBeginY和BLETabBarEndY范围
    if (self.tabBar.y >= BLETabBarBeginY) {
        
        self.tabBar.y = BLETabBarBeginY;
        
    }else if(self.tabBar.y <= BLETabBarEndY){
        
        self.tabBar.y = BLETabBarEndY;
        //隐藏tabBar
        self.tabBar.hidden = YES;
        
    }else {
        self.tabBar.hidden = NO;
    }

}







@end
