//
//  MeetViewController.m
//  jindianyou
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MeetViewController.h"
#import "MeetTableViewCell.h"
#import "Model4.h"
#import "Header.h"
#import "MJRefresh.h"
#import "MeetDetailViewController.h"

@interface MeetViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    NSMutableArray *_dataArray;
    MJRefreshFooterView *_footView;
    MJRefreshHeaderView *_headView;
    NSString *_ID;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeetViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _dataArray = [NSMutableArray new];
        _ID = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_tableView registerNib:[UINib nibWithNibName:@"MeetTableViewCell" bundle:nil] forCellReuseIdentifier:@"MeetTableViewCell"];
    
    _headView = [MJRefreshHeaderView new];
    _footView = [MJRefreshFooterView new];
    _headView.delegate = self;
    _footView.delegate = self;
    
    _headView.scrollView = _tableView;
    _footView.scrollView = _tableView;
    
    [self loadDataFromNet];
}

-(void)loadDataFromNet
{
    NSURL *url = [NSURL URLWithString:YUENI];
    
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:url];
    
    requset.HTTPMethod = @"POST";
    
    NSString *postStr = [NSString stringWithFormat:YUENI_NEXT,_ID];
    
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
                Model4 *model = [Model4 new];
                
                model.imgViewPath = dic[@"photo"];
                model.name = dic[@"member_name"];
                model.dest = dic[@"destination"];
                model.time = dic[@"start_date"];
                model.detail = dic[@"rendezvous_content"];
                model.people = dic[@"signup_amount"];
                model.zan = dic[@"praise_amount"];
                model.say = dic[@"comment_amount"];
                model.sexImagePath = dic[@"sex"];
                model.age = dic[@"age"];
                model.ID = dic[@"rendezvous_id"];
                
                [_dataArray addObject:model];
            }
            
            [_headView endRefreshing];
            [_footView endRefreshing];
            
            [_tableView reloadData];
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

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - MJRefreshBaseViewDelegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _headView)
    {
        
        [_dataArray removeAllObjects];
        
        _ID = @"";
        
    }else if (refreshView == _footView)
    {
        
       Model4 *model = [_dataArray lastObject];
        _ID = model.ID;
        
    }
    
    [self loadDataFromNet];
    
    [_tableView reloadData];
    
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
    
    MeetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetTableViewCell"];
    
    Model4 *model = _dataArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetDetailViewController"];
    
    Model4 *model = _dataArray[indexPath.row];
    
    view.model = model;
    
    [self presentViewController:view animated:NO completion:nil];
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
