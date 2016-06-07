//
//  WhatToDoTableViewCell.m
//  ParentControl_CT
//
//  Created by Sakshi on 18/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "WhatToDoTableViewCell.h"
#import "PC_DataManager.h"
#import "ImageView.h"

@implementation WhatToDoTableViewCell

@synthesize clusterNameLabel,numberOfActivityLabel,countLabel;
@synthesize childNameLabel,parentNameLabel,profileImage,cellImage;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        clusterNameLabel = [[UILabel alloc] init];
        clusterNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
        clusterNameLabel.textColor=[UIColor blackColor];
        [clusterNameLabel sizeToFit];
        [self.contentView addSubview:clusterNameLabel];
        
        numberOfActivityLabel = [[UILabel alloc] init];
        numberOfActivityLabel.font=[UIFont fontWithName:RobotoRegular size:14*ScreenHeightFactor];
        [self.contentView addSubview:numberOfActivityLabel];
        numberOfActivityLabel.textColor = [UIColor grayColor];
        
        countLabel = [[UILabel alloc] init];
        countLabel.font=[UIFont fontWithName:RobotoRegular size:14*ScreenHeightFactor];
        [self.contentView addSubview:countLabel];
        countLabel.textColor = textBlueColor;
        
        childNameLabel = [[UILabel alloc] init];
        childNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
        [self.contentView addSubview:childNameLabel];
        [childNameLabel sizeToFit];
        childNameLabel.textColor = textBlueColor;
        
        parentNameLabel = [[UILabel alloc] init];
        parentNameLabel.font=[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor];
        [self.contentView addSubview:parentNameLabel];
        [parentNameLabel sizeToFit];
        parentNameLabel.textColor = [UIColor grayColor];
        
        profileImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [profileImage setImage:nil];
        profileImage.layer.masksToBounds = YES;
        profileImage.layer.borderWidth = 0;
        profileImage.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:profileImage];
        
        [profileImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImage:)];
        [profileImage addGestureRecognizer:gestureRecognizer];
        
    }
    return self;
}

-(void)resetData
{
    clusterNameLabel.alpha=0.0;
    numberOfActivityLabel.alpha=0.0;
    countLabel.alpha = 0.0;
    childNameLabel.alpha = 0.0;
    parentNameLabel.alpha = 0.0;
}

-(void)resetDataShow
{
    clusterNameLabel.alpha=1.0;
    numberOfActivityLabel.alpha=1.0;
    countLabel.alpha = 1.0;
    childNameLabel.alpha = 1.0;
    parentNameLabel.alpha = 1.0;
}

-(void)displayClusterList:(NSString*)clusterName activityCount:(NSInteger)count cellHeight:(CGFloat)cellHeight{
    
    [self resetData];
    
    CGSize displayValueSize = [clusterName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    clusterNameLabel.frame=CGRectMake(10*ScreenWidthFactor,ScreenHeightFactor,displayValueSize.width,displayValueSize.height);
    clusterNameLabel.text = clusterName;
    clusterNameLabel.textAlignment = NSTextAlignmentLeft;
    
    numberOfActivityLabel.frame=CGRectMake(ScreenWidthFactor*10 ,clusterNameLabel.frame.size.height + clusterNameLabel.frame.origin.y + 3*ScreenHeightFactor ,ScreenWidthFactor*70,displayValueSize.height);
    numberOfActivityLabel.text = @"Activities: ";
    
    
    countLabel.frame=CGRectMake(ScreenWidthFactor*5+numberOfActivityLabel.frame.size.width ,clusterNameLabel.frame.size.height + clusterNameLabel.frame.origin.y + 3*ScreenHeightFactor ,displayValueSize.width-20,displayValueSize.height);
    countLabel.textAlignment = NSTextAlignmentLeft;
    countLabel.text = [NSString stringWithFormat:@"%li",(long)count];
    
    
    [self resetDataShow];
}

-(void)displayWhoIsDoThisList:(UIImage*)image childName:(NSString*)childName parentName:(NSString*)ParentName cellHeight:(CGFloat)cellHeight{
    [self resetData];
    cellImage  = image;
    CGSize displayValueSize = [childName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    profileImage.frame=CGRectMake(cellPadding/2, ScreenHeightFactor, ScreenHeightFactor*48, ScreenHeightFactor*48);
    [profileImage setImage:image];
    profileImage.center=CGPointMake(profileImage.center.x,cellHeight/2);
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;

    
    childNameLabel.text=childName;
    if (screenWidth>700) {
        childNameLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor,displayValueSize.width,displayValueSize.height);
        childNameLabel.center=CGPointMake(childNameLabel.center.x,ScreenHeightFactor*20);
    }
    else{
        childNameLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*30,displayValueSize.width,displayValueSize.height);
        childNameLabel.center=CGPointMake(childNameLabel.center.x,ScreenHeightFactor*30);
    }
    
    
    NSString *str = @"Parent: ";
    str = [str stringByAppendingString:ParentName];
    parentNameLabel.text=str;
    if (screenWidth>700) {
        parentNameLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*3,ScreenWidthFactor*200,displayValueSize.height);
        parentNameLabel.center=CGPointMake(parentNameLabel.center.x,ScreenHeightFactor*40);
    }
    else{
        parentNameLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*50,ScreenWidthFactor*200,displayValueSize.height);
        parentNameLabel.center=CGPointMake(parentNameLabel.center.x,ScreenHeightFactor*50);
    }
    
    [self resetDataShow];
}

-(void)touchImage:(id)sender {
    
    
    ImageView *imageView  =[[ImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [imageView drawImage:cellImage];
    
    AppDelegate *appDelegate  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate window]addSubview:imageView];
    [imageView setAlpha:0.0f];
    
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        //[imageView setFrame:[UIScreen mainScreen].bounds];
        [imageView setAlpha:1.0f];
    }completion:^(BOOL finished){
        
    }];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
