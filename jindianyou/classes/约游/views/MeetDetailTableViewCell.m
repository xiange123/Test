//
//  MeetDetailTableViewCell.m
//  jindianyou
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MeetDetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation MeetDetailTableViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        self.model = [Model4 new];
    }
    return self;
}

//cell内容赋值
-(void)setModel:(Model4 *)model
{
    if (model.imgViewPath.length == 0)
    {
        self.imgView.image = [UIImage imageNamed:@"defultUserImage.png"];
    }
    
    [self.imgView setImageWithURL:[NSURL URLWithString:model.imgViewPath]];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 25;
    
    self.nameLabel.text = model.name;
    self.timeLabel.text = model.time;
    self.talkLabel.text = model.detail;
    self.zanLabel.text = model.zan;
    self.sayLabel.text = model.say;
    
    int i = [model.sexImagePath intValue];
    if (i==0)
    {
        self.sexImageView.image = [UIImage imageNamed:@"身边-女-拷贝.png"];
        
        self.myView.backgroundColor = [UIColor colorWithRed:160/255.0 green:59/255.0 blue:60/255.0 alpha:0.8];
        
    }else if (i==1)
    {
        self.sexImageView.image = [UIImage imageNamed:@"身边-男-拷贝-3.png"];
        
        self.myView.backgroundColor = [UIColor colorWithRed:63/255.0 green:172/255.0 blue:250/255.0 alpha:1.0];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
