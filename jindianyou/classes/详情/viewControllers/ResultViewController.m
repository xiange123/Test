//
//  ResultViewController.m
//  jindianyou
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ResultViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Header.h"

@interface ResultViewController ()

@end

//旅游攻略详情
@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDataFromNet];
}

-(void)loadDataFromNet
{
    NSURL *url = [NSURL URLWithString:DETAIL];
    
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:url];
    
    requset.HTTPMethod = @"POST";
    
    NSString *postStr = [NSString stringWithFormat:DETAIL_NEXT,_ID];
    
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
            
            NSDictionary *dic1 = dic[@"data"];
            
                
            NSArray *arr = dic1[@"guidesDetails"];
//             = [arr firstObject][@"guidesContent"];
            self.titleLabel.text = dic1[@"guidesName"];
            NSString *str = dic1[@"updDate"];
            NSRange range = [str rangeOfString:@" "];
            self.timeLabel.text = [str substringToIndex:range.location];
            
            [_webView loadHTMLString:[arr firstObject][@"guidesContent"] baseURL:nil];
            
            [self.imgView setImageWithURL:[NSURL URLWithString:dic1[@"guidesPic"]]];
       
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
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
