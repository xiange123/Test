//
//  CollectionViewCell.m
//  jindianyou
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CollectionViewCell.h"
#import "TableViewCell.h"
#import "Header.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Model3.h"

@implementation CollectionViewCell
{
    NSMutableArray *_dataArray;
    NSString *_url;
    NSString *_urlString;
    MJRefreshHeaderView *_headView;
    MJRefreshFooterView *_footView;
    int _page;
}



-(void)setTemp:(int)temp
{
    _temp = temp;
//    NSLog(@"temp==%d",temp);
    [_dataArray removeAllObjects];

    if (_temp == 0)
    {
//        NSLog(@"000,%@",_city);

        _url = NEAR;
        _urlString = NEAR_NEXT;
        _city = @"";
        
        [self loadDataFromNet];
    }
    if (_temp == 1)
    {
//        NSLog(@"111,%@",_city);

        _url = GUONEI;
        _urlString = GUONEI_NEXT;

        [self loadDataFromNet];
    }
    if (_temp == 2)
    {
//        NSLog(@"222");
   
        _url = GUOWAI;
        _urlString = GUOWAI_NEXT;

        [self loadDataFromNet];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _dataArray = [NSMutableArray new];
        _page = 1;
        _city = @"";
    }
    return self;
}

-(void)awakeFromNib
{
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    
    _headView = [MJRefreshHeaderView new];
    _footView = [MJRefreshFooterView new];
    
    _headView.delegate = self;
    _footView.delegate = self;
    
    _headView.scrollView = _tableView;
    _footView.scrollView = _tableView;
}

-(void)loadDataFromNet
{
    
    NSURL *url = [NSURL URLWithString:_url];
    
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:url];
    
    requset.HTTPMethod = @"POST";
    
    NSString *postStr = [NSString stringWithFormat:_urlString,_page,_city];
    
    NSData *data = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    requset.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:requset queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError)
        {
            NSLog(@"connectionError==%@",connectionError);
        }else
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *array = dic[@"data"];
            
            for (NSDictionary *dic in array)
            {
                Model3 *model = [Model3 new];
                
                model.city_name = dic[@"city_name"];
                model.level = dic[@"level"];
                model.market_price = dic[@"market_price"];
                model.product_pic = dic[@"product_pic"];
                model.sales_price = dic[@"sales_price"];
                model.scenic_name = dic[@"scenic_name"];
//                if (_temp == 1)
//                {
//                    NSLog(@"%@",model);
//                }
                
                [_dataArray addObject:model];
            }
            
            [_headView endRefreshing];
            [_footView endRefreshing];
            
            [_tableView reloadData];

        }
    }];
}

#pragma mark - MJRefreshBaseViewDelegate

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    if (refreshView == _headView)
    {
        [_dataArray removeAllObjects];
        
    }else if (refreshView == _footView)
    {
        _page++;
    }
    
    [self loadDataFromNet];
    
    [_tableView reloadData];

}

-(void)dealloc
{
    [_headView free];
    [_footView free];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    Model3 *model = _dataArray[indexPath.row];
    
    cell.city.text = model.city_name;
    cell.name.text = model.scenic_name;
    cell.sales_price.text = model.sales_price;
    cell.market_price.text = model.market_price;
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.product_pic]];

    return cell;
}


@end
