//
//  PlayViewController.m
//  jindianyou
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PlayViewController.h"
#import "MeetViewController.h"
@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)meet:(id)sender
{
    MeetViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetViewController"];
    
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
