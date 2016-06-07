//
//  WhatToDoTableViewCell.h
//  ParentControl_CT
//
//  Created by Sakshi on 18/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhatToDoTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *clusterNameLabel;
@property (nonatomic,strong) UILabel *numberOfActivityLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel *childNameLabel;
@property (nonatomic,strong) UILabel *parentNameLabel;
@property (nonatomic,strong) UIImageView *profileImage;
@property (nonatomic,strong) UIImage *cellImage;
@property  CGSize displayValueSize;

-(void)displayClusterList:(NSString*)clusterName activityCount:(NSInteger)count cellHeight:(CGFloat)cellHeight;
-(void)displayWhoIsDoThisList:(UIImage*)image childName:(NSString*)childName parentName:(NSString*)ParentName cellHeight:(CGFloat)cellHeight;

@end
