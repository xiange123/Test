//
//  CityViewController.h
//  jindianyou
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityViewController : UIViewController

@property (nonatomic,copy) void(^block)(NSString *str);

@end
