//
//  MeetTableViewCell.m
//  jindianyou
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MeetTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation MeetTableViewCell

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
    [self.imgView setImageWithURL:[NSURL URLWithString:model.imgViewPath]];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 25;
    
    self.nameLabel.text = model.name;
    self.destLabel.text = model.dest;
    self.timeLabel.text = model.time;
    self.detail.text = model.detail;
    self.peopleLabel.text = [NSString stringWithFormat:@"%@人约游",model.people];
    self.zanLabel.text = model.zan;
    self.sayLabel.text = model.say;
    self.ageLabel.text = model.age;
    
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
