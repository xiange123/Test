//
//  TabBarController.m
//  jindianyou
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "TabBarController.h"
#import "Masonry.h"
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.hidden = YES;
    
    _customBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, 320, 44)];
    
    _customBar.image = [UIImage imageNamed:@"tabbar.png"];
    //打开手势,这样按钮才能点
    _customBar.userInteractionEnabled = YES;
    [self.view addSubview:_customBar];
    
    [_customBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.right.equalTo(self.view.mas_right).offset(0);
        
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        
        make.left.equalTo(self.view.mas_left).offset(0);
        
        make.height.equalTo(@44);
    }];
    
    NSArray *array = @[@"主页.png",@"攻略.png",@"预订.png",@"约游.png",@"我的.png"];
    
    NSArray *array1 = @[@"主页选中状态.png",@"攻略-选中状态.png",@"预订选中状态.png",@"约游选中状态.png",@"我的-选中状态.png"];
    
    NSArray *array2 = @[@"首页",@"攻略",@"景点",@"约游",@"我的"];
    
    CGFloat x = self.view.frame.size.width/5.0;
    
    //在_customBar上放置4个按钮
    for (int i=0; i<5; i++)
    {
        //UIButtonTypeSystem 使用这种模式,按钮图片会自动加上蓝色背景
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*64, 0, 64, 44);
        //设置正常图片
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        //设置选中图片
        [button setImage:[UIImage imageNamed:array1[i]] forState:UIControlStateSelected];
        
        [button setTitle:array2[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:138/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        
        button.titleEdgeInsets = UIEdgeInsetsMake(25, 0, 0, 15);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 15, 0);
        
        
        //打tag
        button.tag = 100+i;
        
        //添加事件
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_customBar addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).offset(i*x);
            
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
            
            make.width.equalTo(@(64));
            
            make.height.equalTo(@44);
        }];
    }
    
}

- (void)buttonClick:(UIButton *)button
{
    //将所有按钮的selected置NO
    for (int i=0; i<5; i++)
    {
        UIButton *b = (UIButton *)[_customBar viewWithTag:100+i];
        b.selected = NO;
    }
    
    //改变选中按钮的状态
    button.selected = YES;
    
    //修改tabbarcontroller的选中项.这样就能切到对应的视图控制器
    self.selectedIndex = button.tag - 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
