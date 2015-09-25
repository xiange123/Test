//
//  Model.m
//  jindianyou
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Model.h"

@implementation Model

-(instancetype)init
{
    if (self = [super init])
    {
        _array = [NSMutableArray new];
        _dic = [NSMutableDictionary new];
    }
    
    return self;
}

@end
