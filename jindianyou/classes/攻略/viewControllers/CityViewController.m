//
//  CityViewController.m
//  jindianyou
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CityViewController.h"
#import "Header.h"
#import "Model1.h"
#import "GongViewController.h"

@interface CityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    int _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CityViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _dataArray = [NSMutableArray new];
        _page = 0;
    }
    return self;
}

//设置索引字体颜色
-(void)viewDidLayoutSubviews
{
        [super viewDidLayoutSubviews];
        //设置导航字体颜色、字体、背景色
        for (UIView* subview in [self.tableView subviews])
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewIndex")])
            {
                [subview performSelector:@selector(setIndexColor:) withObject:[UIColor blackColor]];
            }
        }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDataFromNet];
}

-(void)loadDataFromNet
{
    NSURL *url = [NSURL URLWithString:CITY];
    
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:url];
    
    requset.HTTPMethod = @"POST";
    
    NSString *postStr = [NSString stringWithFormat:CITY_NEXT,_page];
    
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
            
            [_dataArray removeAllObjects];
            
            for (NSDictionary *dic in arr)
            {
                Model1 *model = [[Model1 alloc]init];
                
                model.array = dic[@"cityList"];
                
                [_dataArray addObject:model];
            }
            
            [_tableView reloadData];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)china:(id)sender
{
    _page = 0;
    
    [self loadDataFromNet];
}
- (IBAction)foreign:(id)sender
{
    _page = 1;
    
    [self loadDataFromNet];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Model1 *model = _dataArray[section];
    
    return model.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    Model1 *model = _dataArray[indexPath.section];
    
    cell.textLabel.text = model.array[indexPath.row][@"showName"];
    
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"];
    
    NSArray *array1 = @[@"B",@"J",@"P",@"S"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, 100, 20)];
    
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    
    if (_page == 0)
    {
        label.text = array[section];
    }else
    {
        label.text = array1[section];
    }
    
    [view addSubview:label];
    
    view.backgroundColor = [UIColor grayColor];
    
    return view;
}

//返回索引数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_page == 0)
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        //返回A-Z
        for (int i = 'A'; i<='Z'; i++)
        {
            //将ascII转字符串
            NSString *str = [NSString stringWithFormat:@"%c",i];
            [array addObject:str];
        }
        //索引是和组数对应的.
        //如果索引个数大于组的个数,那么后面的索引无效.
        return array;
    }else
    {
        NSArray *array = @[@"B",@"J",@"P",@"S"];
        
        return array;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Model1 *model = _dataArray[indexPath.section];
    
    NSString *str = model.array[indexPath.row][@"showName"];
    
    NSRange range = [str rangeOfString:@"("];
    
    if (range.location == NSNotFound)
    {
        self.block(str);
        
    }else
    {
        NSString *str1 = [str substringToIndex:range.location];
        
        self.block(str1);
    }

    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
    
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
