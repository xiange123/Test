//
//  MainViewController.m
//  jindianyou
//
//  Created by qianfeng on 15/9/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MainViewController.h"
#import "HeadView.h"
#import "AFNetworking.h"
#import "Header.h"
#import "UIImageView+AFNetworking.h"
#import "TableViewCell1.h"
#import "TableViewCell2.h"
#import "TableViewCell3.h"
#import "TableViewCell4.h"
#import "TableViewCell5.h"
#import "view.h"
#import "Model.h"
#import "ResultViewController.h"
#import "MJRefresh.h"
#import "ResultViewController1.h"
#import "MeetDetailViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MJRefreshBaseViewDelegate>
{
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSMutableArray *_dataArray3;
    NSMutableArray *_dataArray4;
    NSMutableArray *_dataArray5;
    NSTimer *_timer;
    HeadView *_view;
    int _count;//计数器
    MJRefreshHeaderView *_headView;
    NSMutableArray *_dataArray6;//小景推荐和超值推荐跳转详情页面 传递数据

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//tabbar 按钮
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;

@end

@implementation MainViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _dataArray1 = [NSMutableArray new];
        _dataArray2 = [NSMutableArray new];
        _dataArray3 = [NSMutableArray new];
        _dataArray4 = [NSMutableArray new];
        _dataArray5 = [NSMutableArray new];
        _dataArray6 = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _headView = [MJRefreshHeaderView new];
    _headView.delegate = self;
    _headView.scrollView = _tableView;
    
    _button1.selected = YES;
    
    [self loadDataFromNet];
    
    [self registerCell];
    
}

//注册cell
-(void)registerCell
{
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell1" bundle:nil] forCellReuseIdentifier:@"TableViewCell1"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell2" bundle:nil]
     forCellReuseIdentifier:@"TableViewCell2"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell3" bundle:nil] forCellReuseIdentifier:@"TableViewCell3"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell4" bundle:nil] forCellReuseIdentifier:@"TableViewCell4"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell5" bundle:nil] forCellReuseIdentifier:@"TableViewCell5"];
}

//获取数据
-(void)loadDataFromNet
{
    [[AFHTTPRequestOperationManager manager] GET:HOME parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_dataArray1 removeAllObjects];
        [_dataArray2 removeAllObjects];
        [_dataArray3 removeAllObjects];
        [_dataArray4 removeAllObjects];
        [_dataArray5 removeAllObjects];
        
//        NSLog(@"responseObject==%@",responseObject);
        //数据1
        NSArray *arr = responseObject[@"advert_link_data"];
        for (NSDictionary *dic in arr)
        {
            NSString *url = dic[@"advert_pic"];
            
            [_dataArray1 addObject:url];
        }
        //数据2
        NSArray *arr1 = responseObject[@"top_theme_data"];
        Model *model = [[Model alloc]init];
        
        [model.array addObjectsFromArray:arr1];
        
        [_dataArray2 addObject:model];
        //数据3
        NSDictionary *dic = responseObject[@"rendezvous_data"];
        Model *model1 = [[Model alloc]init];
        
        [model1.dic addEntriesFromDictionary:dic];
        
        [_dataArray3 addObject:model1];
        
        //数据4
        NSDictionary *dic1 = responseObject[@"onway_data"];
        Model *model2 = [[Model alloc]init];
        
        [model2.dic addEntriesFromDictionary:dic1];
        
        [_dataArray4 addObject:model2];
        
        //数据5
        NSArray *arr4 = responseObject[@"guides_data"];
        for (NSDictionary *dic in arr4)
        {
            Model *model = [Model new];
            
            model.title = dic[@"guides_name"];
            model.url = dic[@"guides_pic"];
            model.ID = dic[@"guides_id"];
            [_dataArray5 addObject:model];
        }
        
        [_headView endRefreshing];
        
        [_tableView reloadData];
        
        [self setHeadView];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error==%@",error);
        
    }];
}

//设置表头
-(void)setHeadView
{
    _view = [[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:self options:0][0];
    _view.frame = CGRectMake(0, 20, self.view.frame.size.width, 150);
    
    _view.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*5, 0);
    
    _view.scrollView.pagingEnabled = YES;
    
    _view.scrollView.showsHorizontalScrollIndicator = NO;
    
    _view.scrollView.delegate = self;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    for (int i=0; i<5; i++)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, width, _view.frame.size.height)];

        [imgView setImageWithURL:[NSURL URLWithString:_dataArray1[i]]];
        
         imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        [_view.scrollView addSubview:imgView];
    }
    
    _tableView.tableHeaderView = _view;
    
    _view.scrollView.tag = 100;
    _view.page.tag = 101;
    
    [self time];
    
    _count = 0;
    _view.page.currentPage = _count;
}

//定时器
-(void)time
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getOut:) userInfo:_view.scrollView repeats:YES];
    
    //将定时器设置更高等级
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)getOut:(NSTimer *)timer
{
    _count ++;
    //取得NSTimer所带的参数
    UIScrollView *scroll = timer.userInfo;
    
    if (_count >=5)
    {
        _count = 0;
        //瞬间回到起点,解决晃一下的问题
        scroll.contentOffset = CGPointMake(0, 0);
    }
    //再从起点开始跑
    [scroll setContentOffset:CGPointMake(_count *self.view.frame.size.width, 0) animated:YES];
    
    
    UIPageControl *page = (UIPageControl *)[_view viewWithTag:101];
    page.currentPage = _count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button1:(id)sender
{
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = NO;
    _button5.selected = NO;
    
    UIButton *button = sender;
    
    button.selected = YES;
}

- (IBAction)button2:(id)sender
{
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = NO;
    _button5.selected = NO;
    
    UIButton *button = sender;
    
    button.selected = YES;
}

- (IBAction)button3:(id)sender
{
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = NO;
    _button5.selected = NO;
    
    UIButton *button = sender;
    
    button.selected = YES;
}

- (IBAction)buttom4:(id)sender
{
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = NO;
    _button5.selected = NO;
    
    UIButton *button = sender;
    
    button.selected = YES;
}

- (IBAction)button5:(id)sender
{
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    _button4.selected = NO;
    _button5.selected = NO;
    
    UIButton *button = sender;
    
    button.selected = YES;
}

-(void)dealloc
{
    [_headView free];
}

//小景推荐和超值推荐图片手势
-(void)come:(UITapGestureRecognizer *)tap
{
    ResultViewController1 *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController1"];
    
    UIImageView *imageView = (UIImageView *)tap.view;
    
    int temp = imageView.tag-100;
    
    Model *model = _dataArray6[temp];
    
    view.url = model.url;
    view.name = model.title;
    
    [self presentViewController:view animated:NO completion:nil];
}

#pragma mark -MJRefreshBaseViewDelegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    [self loadDataFromNet];
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100)
    {
        if ([_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

//滑动scroollView,UIPageControl跟随变化
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //取到当前图片的位置
    int index = scrollView.contentOffset.x/self.view.frame.size.width;
    
    //将位置设置给UIPageControl,来实现联动
    
    UIPageControl *page =(UIPageControl *) [_view viewWithTag:101];
    page.currentPage = index;
    
    if (scrollView.tag == 100)
    {
        [self time];
    }

}

#pragma mark - UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4)
    {
        return _dataArray5.count;
    }
    if (section == 0 || section ==3)
    {
        return _dataArray2.count;
    }
    if (section == 1)
    {
        return _dataArray3.count;
    }
    if (section == 2)
    {
        return _dataArray4.count;
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
    TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell1"];
    
        Model *model = _dataArray2[indexPath.row];
        NSArray *array = model.array;
        
        cell.label1.text = array[0][@"theme_name"];
        [cell.imageVIew1 setImageWithURL:[NSURL URLWithString:array[0][@"theme_pic"]]];
        cell.label2.text = array[1][@"theme_name"];
        [cell.imageView2 setImageWithURL:[NSURL URLWithString:array[1][@"theme_pic"]]];
        cell.label3.text = array[2][@"theme_name"];
        [cell.imageView3 setImageWithURL:[NSURL URLWithString:array[2][@"theme_pic"]]];
        cell.label4.text = array[3][@"theme_name"];
        [cell.iamgeView4 setImageWithURL:[NSURL URLWithString:array[3][@"theme_pic"]]];
        
        NSArray *arr = @[cell.imageVIew1,cell.imageView2,cell.imageView3,cell.iamgeView4];
        
        for (int i =0; i<4; i++)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(come:)];
            
            UIImageView *imageView = arr[i];
            
            imageView.tag = 100+i;
            
            [imageView addGestureRecognizer:tap];
            
             //跳转页面传递数据
            Model *model1 = [Model new];
            model1.title = array[i][@"theme_name"];
            model1.url = array[i][@"action"];
            
            [_dataArray6 addObject:model1];
        }
        
        return cell;
        
    }else if(indexPath.section == 1)
    {
    
    TableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell2"];
        
        Model *model = _dataArray3[indexPath.row];
        
        cell.label1.text = model.dic[@"destination"];
        cell.label2.text = model.dic[@"member_name"];
        cell.label3.text = [NSString stringWithFormat:@"%@人已报名",model.dic[@"signup_amount"]];
        cell.label4.text = model.dic[@"rendezvous_content"];
        
        [cell.imgView1 setImageWithURL:[NSURL URLWithString:model.dic[@"photo"]]];
        [cell.imgView2 setImageWithURL:[NSURL URLWithString:model.dic[@"member_photo"]]];

        return cell;
        
    }else if (indexPath.section == 2)
    {
        TableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell3"];
        
        Model *model = _dataArray4[indexPath.row];
        
        cell.nameLabel.text = model.dic[@"member_name"];
        cell.timeLabel.text = model.dic[@"create_date"];
        cell.sayLabel.text = model.dic[@"message_content"];
        
        [cell.imgView setImageWithURL:[NSURL URLWithString:model.dic[@"member_photo"]]];
        cell.imgView.layer.masksToBounds = YES;
        cell.imgView.layer.cornerRadius = 20;
        
        return cell;
    }
    else if(indexPath.section == 3)
    {
        
    TableViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell4"];
       
        Model *model = _dataArray2[indexPath.row];
        NSArray *array = model.array;
        
        cell.label1.text = array[4][@"theme_name"];
        [cell.imgView1 setImageWithURL:[NSURL URLWithString:array[4][@"theme_pic"]]];
        cell.label2.text = array[5][@"theme_name"];
        [cell.imgView2 setImageWithURL:[NSURL URLWithString:array[5][@"theme_pic"]]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(come:)];
        
        [cell.imgView1 addGestureRecognizer:tap];
        cell.imgView1.tag = 104;
        cell.imgView2.tag = 105;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(come:)];
        
        [cell.imgView2 addGestureRecognizer:tap1];
        
        Model *model1 = [Model new];
        model1.title = array[4][@"theme_name"];
        model1.url = array[4][@"action"];
        [_dataArray6 addObject:model1];
        
        Model *model2 = [Model new];
        model2.title = array[5][@"theme_name"];
        model2.url = array[5][@"action"];
        [_dataArray6 addObject:model2];
        
        return cell;
        
    }else if(indexPath.section == 4)
    {
        TableViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell5"];
        
        Model *model = _dataArray5[indexPath.row];
        
        cell.titleLabel.text = model.title;
        
        [cell.imgView setImageWithURL:[NSURL URLWithString:model.url]];
        
        return cell;
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 180;
    }
    else if(indexPath.section == 1)
    {
        return 120;
    }
    else if(indexPath.section == 2)
    {
        return 120;
        
    }else if(indexPath.section == 3)
    {
        return 90;
        
    }else if(indexPath.section == 4)
    {
        return 90;
    }
    
    return 120;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    view *view = [[NSBundle mainBundle]loadNibNamed:@"view" owner:self options:0][0];
    
    if (section == 0)
    {
        view.label.text = @"小景推荐";
    }else if(section == 1)
    {
        view.label.text = @"约游";
    }else if(section == 2)
    {
        view.label.text = @"在路上";
    }else if (section == 3)
    {
        view.label.text = @"超值推荐";
    }else if (section == 4)
    {
        view.label.text = @"锦囊";
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4)
    {
        ResultViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
        
        Model *model = _dataArray5[indexPath.row];
        
        view.ID = model.ID;
        
        [self presentViewController:view animated:NO completion:nil];
    }
    if (indexPath.section == 1)
    {
        MeetDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetDetailViewController"];
        
        Model *model = _dataArray3[indexPath.row];
        
        view.ID = model.dic[@"rendezvous_id"];
        
//        NSLog(@"%@",view.ID);
        
        [self presentViewController:view animated:NO completion:nil];
    }
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
