//
//  Model.h
//  jindianyou
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) NSMutableDictionary *dic;
@property (nonatomic,copy) NSString *ID;


@end
