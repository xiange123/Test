//
//  SceneryViewController.m
//  jindianyou
//
//  Created by qianfeng on 15/9/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SceneryViewController.h"
#import "CollectionViewCell.h"
#import "Model3.h"
#import "AFNetworking.h"
#import "Header.h"
#import "CityViewController.h"

@interface SceneryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    int _temp;
}
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (weak, nonatomic) IBOutlet UIButton *city;



@end

@implementation SceneryViewController

//初始布局
-(void)viewDidLayoutSubviews
{
    _button2.selected = YES;
    
    CGRect frame = _view1.frame;
    CGFloat height = frame.origin.y;
    frame.origin = CGPointMake(self.view.frame.size.width/3, height);
    _view1.frame = frame;
    
    _collectionView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _city1 = @"";
    
    
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
    
    UIButton *button = sender;
    
    button.selected = YES;
    
    CGRect frame = _view1.frame;
    CGFloat height = frame.origin.y;
    frame.origin = CGPointMake(0, height);
    _view1.frame = frame;
    
    _collectionView.contentOffset = CGPointMake(0, 0);
    _city1 = @"";
    
    [_collectionView reloadData];
}

- (IBAction)button2:(id)sender
{
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    
    UIButton *button = sender;
    
    button.selected = YES;
    
    CGRect frame = _view1.frame;
    CGFloat height = frame.origin.y;
    frame.origin = CGPointMake(self.view.frame.size.width/3, height);
    _view1.frame = frame;
    
    _collectionView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    _city1 = @"";
    
    [_city setTitle:@"全部" forState:UIControlStateNormal];
    
    [_collectionView reloadData];
}

- (IBAction)button3:(id)sender
{
    _city1 = @"首尔";
    
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    
    UIButton *button = sender;
    
    button.selected = YES;
    
    CGRect frame = _view1.frame;
    CGFloat height = frame.origin.y;
    frame.origin = CGPointMake(2*self.view.frame.size.width/3, height);
    _view1.frame = frame;
    
    _collectionView.contentOffset = CGPointMake(2*self.view.frame.size.width, 0);

    
    [_collectionView reloadData];
}

- (IBAction)city:(id)sender
{
    CityViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"CityViewController"];
    view.block = ^(NSString *str){
        
        _city1 = str;
        
        [_city setTitle:str forState:UIControlStateNormal];
        
        [_collectionView reloadData];
    
    };
    
    [self presentViewController:view animated:NO completion:nil];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.city = _city1;

    _temp = indexPath.row;
    cell.temp = indexPath.row;
    
//    NSLog(@"444");
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int i = scrollView.contentOffset.x/self.view.frame.size.width;
    
    CGRect frame = _view1.frame;
    CGFloat height = frame.origin.y;
    frame.origin = CGPointMake(i*self.view.frame.size.width/3, height);
    _view1.frame = frame;
    
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    
    switch (i)
    {
        case 0:
            _button1.selected = YES;
            break;
        case 1:
            _button2.selected = YES;
            break;
        case 2:
            _button3.selected = YES;
            break;
            
        default:
            break;
    }
    
//    [_collectionView reloadData];

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
