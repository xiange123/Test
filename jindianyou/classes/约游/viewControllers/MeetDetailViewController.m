//
//  MeetDetailViewController.m
//  jindianyou
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MeetDetailViewController.h"
#import "StailHeadView.h"
#import "UIImageView+AFNetworking.h"
#import "MeetDetailTableViewCell.h"
#import "Header.h"
#import "MJRefresh.h"

@interface MeetDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSMutableArray *_dataArray;
    MJRefreshHeaderView *_headView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeetDetailViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _dataArray = [NSMutableArray new];
        _headView = [MJRefreshHeaderView new];
        _headView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _headView.scrollView = _tableView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"MeetDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"MeetDetailTableViewCell"];
    
    [self setHeadView];
    
    [self loadDataFromNet];
}

-(void)loadDataFromNet
{
//    NSLog(@"%@",self.ID);
    NSURL *url = [NSURL URLWithString:YUENI_DETAIL];
    
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:url];
    
    requset.HTTPMethod = @"POST";
    
    NSString *postStr = [NSString stringWithFormat:YUENI_DETAIL_NEXT,self.model.ID];
    
    NSData *data = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    requset.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:requset queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError)
        {
            NSLog(@"connectionError==%@",connectionError);
        }else
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"%@",dic);
            
            [_dataArray removeAllObjects];
            
            NSArray *array = dic[@"data"];
            
            for (NSDictionary *dic in array)
            {
                Model4 *model = [Model4 new];
                
                model.imgViewPath = dic[@"photo"];
                model.name = dic[@"member_name"];
                model.time = dic[@"message_date"];
                model.detail = dic[@"message_content"];
                model.zan = dic[@"praise_amount"];
                model.say = dic[@"reply_amount"];
                model.sexImagePath = dic[@"member_sex"];
                
                [_dataArray addObject:model];
            }
            
            [_headView endRefreshing];
            
            [_tableView reloadData];
        }
    }];
}

//设置表头
-(void)setHeadView
{
    StailHeadView *view = [[NSBundle mainBundle]loadNibNamed:@"StailHeadView" owner:self options:0][0];

    view.nameLabel.text = self.model.name;
    view.destLabel.text = self.model.dest;
    view.timeLabel.text = self.model.time;
    view.detailLabel.text = self.model.detail;
    view.ageLabel.text = self.model.age;
    [view.imgView setImageWithURL:[NSURL URLWithString:self.model.imgViewPath]];
    
    view.imgView.layer.masksToBounds = YES;
    view.imgView.layer.cornerRadius = 25;
    
    if ([self.model.sexImagePath intValue] == 0)
    {
        view.sexImageView.image = [UIImage imageNamed:@"身边-女-拷贝.png"];
        
        view.myView.backgroundColor = [UIColor colorWithRed:160/255.0 green:59/255.0 blue:60/255.0 alpha:0.8];
    }else if ([self.model.sexImagePath intValue] == 1)
    {
        view.sexImageView.image = [UIImage imageNamed:@"身边-男-拷贝-3.png"];
        
        view.myView.backgroundColor = [UIColor colorWithRed:63/255.0 green:172/255.0 blue:250/255.0 alpha:1.0];
    }
    
    _tableView.tableHeaderView = view;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - MJRefreshBaseViewDelegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadDataFromNet];
}

-(void)dealloc
{
    [_headView free];
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
    
    MeetDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetDetailTableViewCell"];
    Model4 *model = _dataArray[indexPath.row];
    
    cell.model = model;

    return cell;
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
