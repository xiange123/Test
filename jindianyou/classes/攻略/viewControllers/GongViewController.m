//
//  GongViewController.m
//  jindianyou
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "GongViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Header.h"
#import "CityViewController.h"
#import "GongCell.h"
#import "Model1.h"
#import "MJRefresh.h"
#import "ResultViewController.h"

@interface GongViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    NSMutableArray *_dataArray;
    int _Page;
    MJRefreshFooterView *_footView;
    MJRefreshHeaderView *_headView;
    BOOL _isDragDown;
}
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@end

@implementation GongViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _dataArray = [NSMutableArray new];
        _Page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _city = _button.titleLabel.text;
    
    _headView = [MJRefreshHeaderView new];
    _footView = [MJRefreshFooterView new];
    
    _headView.scrollView = _tableVIew;
    _footView.scrollView = _tableVIew;
    
    _headView.delegate = self;
    _footView.delegate = self;

    
    [_tableVIew registerNib:[UINib nibWithNibName:@"GongCell" bundle:nil] forCellReuseIdentifier:@"GongCell"];
    
    [self loadDataFromNet];
    
}

-(void)loadData
{
    
    if (_isDragDown)
    {
        [_dataArray removeAllObjects];
    }
    
    [self loadDataFromNet];
    
    [_tableVIew reloadData];
    
}

- (IBAction)city:(id)sender
{
    CityViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"CityViewController"];
    
    [self presentViewController:view animated:NO completion:nil];
}

//加载数据内容
-(void)loadDataFromNet
{
    NSURL *url = [NSURL URLWithString:GONGLEI];
    
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:url];
    
    requset.HTTPMethod = @"POST";
    
    NSString *postStr = [NSString stringWithFormat:GONGLEI_NEXT,_city,_Page];
    
    NSData *data = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    requset.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:requset queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError)
        {
            NSLog(@"connectionError==%@",connectionError);
        }else
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"dic===%@",dic);
            
            NSArray *arr = dic[@"data"];
            
            for (NSDictionary *dic in arr)
            {
                Model1 *model = [Model1 new];
                
                model.name = dic[@"cityName"];
                model.imagePath = dic[@"guidesPic"];
                model.tail = dic[@"guidesName"];
                model.ID = dic[@"guidesId"];
                
                [_dataArray addObject:model];
            }
            
            [_footView endRefreshing];
            [_headView endRefreshing];
            
            [_tableVIew reloadData];
            
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_headView free];
    [_footView free];
}

#pragma mark -MJRefreshBaseViewDelegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _headView)
    {
        _isDragDown = YES;
        _Page = 1;
    }else
    {
        _isDragDown = NO;
        _Page++;
    }
    
    [self loadData];
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
    
    GongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GongCell"];
    
    Model1 *model = _dataArray[indexPath.row];
    
    cell.cityLabel.text = model.name;
    cell.tailLabel.text = model.tail;
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imagePath]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
    
    Model1 *model = _dataArray[indexPath.row];
    view.ID = model.ID;
    
    [self presentViewController:view animated:NO completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    CityViewController *view = segue.destinationViewController;
    
    view.block = ^(NSString *str){
        
        _city = str;
    
        [_button setTitle:str forState:UIControlStateNormal];
        
        [_dataArray removeAllObjects];
        
        [self loadDataFromNet];
    };
}


@end
