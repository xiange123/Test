//
//  CollectionViewCell.h
//  jindianyou
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"


@interface CollectionViewCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int temp;
@property (nonatomic,copy) NSString *city;

@end
