//
//  WishListTableViewCell.m
//  ParentControl_CT
//
//  Created by Tripta Garg on 16/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "WishListTableViewCell.h"
#import "PC_DataManager.h"

@implementation WishListTableViewCell
{
    UIImageView *cellImageView;
    UILabel *subjectNameLabel;
    UILabel *countLabel;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        cellImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [cellImageView setImage:nil];
        [self.contentView addSubview:cellImageView];
        
        
        subjectNameLabel = [[UILabel alloc] init];
        subjectNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
        subjectNameLabel.textColor=textBlueColor;
        [subjectNameLabel sizeToFit];
        [self.contentView addSubview:subjectNameLabel];
        
        countLabel = [[UILabel alloc] init];
        countLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
        [self.contentView addSubview:countLabel];
        
        
    }
    return self;
}

-(void)addWishList:(NSString*)subjectName childCount:(NSString*)childrenCount cellHeight:(CGFloat)cellHeight isScheduled:(BOOL)isScheduled
{
    
    CGSize displayValueSize = [subjectName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
        subjectNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    subjectNameLabel.text=subjectName;
    
    subjectNameLabel.frame=CGRectMake(10*ScreenWidthFactor,ScreenHeightFactor,displayValueSize.width,displayValueSize.height);
    if(isScheduled)
    {
        subjectNameLabel.textColor= textBlueColor;
    }
    else
    {
        subjectNameLabel.textColor= [UIColor grayColor];
    }
    [subjectNameLabel sizeToFit];
    
    countLabel.textColor=[UIColor blackColor];
    NSString *str1 =  @"Children doing this : ";
    NSString *str2 = [NSString stringWithFormat:@"%@",childrenCount];
    NSString *childCount = [str1 stringByAppendingString:str2];
    
     NSMutableAttributedString  *attString1 = [self getAttributedString:childCount from:str1.length toLength:childCount.length - str1.length];
     countLabel.attributedText=attString1;
    
    CGSize displayValueSize1 = [attString1.string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    countLabel.font=[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor];
   
    countLabel.frame=CGRectMake(ScreenWidthFactor*10 ,subjectNameLabel.frame.size.height + subjectNameLabel.frame.origin.y + 3*ScreenHeightFactor ,displayValueSize1.width,displayValueSize1.height);
   
   if(screenWidth>700)
   {
        cellImageView.image=[UIImage imageNamed:@"wishlist-icon-ipad.png"];
        
    }
    else if(screenWidth>700)
    {
        cellImageView.image=[UIImage imageNamed:@"wishlist-icon-iPhone6.png"];
    }
    else
    {
        cellImageView.image=[UIImage imageNamed:@"wishlist-icon-iPhone5.png"];
    }

    cellImageView.frame=CGRectMake(screenWidth - 50*ScreenWidthFactor, ScreenHeightFactor, ScreenHeightFactor*20, ScreenHeightFactor*20);
    cellImageView.center = CGPointMake(cellImageView.center.x, self.frame.size.height/2);
    
}

-(void)addActivityList:(NSString*)subjectName childCount:(NSString*)childrenCount cellHeight:(CGFloat)cellHeight isScheduled:(BOOL)isScheduled isWished:(BOOL)isWished
{
    
    CGSize displayValueSize = [subjectName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    subjectNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    subjectNameLabel.text=subjectName;
    
    subjectNameLabel.frame=CGRectMake(10*ScreenWidthFactor,ScreenHeightFactor,displayValueSize.width,displayValueSize.height);
    
    if(isScheduled)
    {
        subjectNameLabel.textColor= [[UIColor grayColor]colorWithAlphaComponent:0.5 ];
    }
    else
    {
        subjectNameLabel.textColor= textBlueColor;
    }
    [subjectNameLabel sizeToFit];
    
    countLabel.textColor=[UIColor grayColor];
    NSString *str1 =  @"Children doing this: ";
    NSString *str2 = [NSString stringWithFormat:@"%@",childrenCount];
    NSString *childCount = [str1 stringByAppendingString:str2];
    
    NSMutableAttributedString  *attString1 = [self getAttributedString:childCount from:str1.length toLength:childCount.length - str1.length];
    countLabel.attributedText=attString1;
    
    CGSize displayValueSize1 = [attString1.string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    countLabel.font=[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor];
    
    countLabel.frame=CGRectMake(ScreenWidthFactor*10 ,subjectNameLabel.frame.size.height + subjectNameLabel.frame.origin.y + 3*ScreenHeightFactor ,displayValueSize1.width,displayValueSize1.height);
    if (isWished) {
        if(screenWidth>700)
        {
            cellImageView.image=[UIImage imageNamed:@"wishlist-icon-ipad.png"];
            
        }
        else if(screenWidth>700)
        {
            cellImageView.image=[UIImage imageNamed:@"wishlist-icon-iPhone6.png"];
        }
        else
        {
            cellImageView.image=[UIImage imageNamed:@"wishlist-icon-iPhone5.png"];
        }
        
        cellImageView.frame=CGRectMake(screenWidth - 50*ScreenWidthFactor, ScreenHeightFactor, ScreenHeightFactor*20, ScreenHeightFactor*20);
        cellImageView.center = CGPointMake(cellImageView.center.x, self.frame.size.height/2);
    }
    else{
        //cellImageView = nil;

        [cellImageView removeFromSuperview];

    }
   
}


-(NSMutableAttributedString *)getAttributedString:(NSString *)title from:(NSUInteger )loc toLength:(NSUInteger )len
{
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:title];
    [attString addAttribute:NSForegroundColorAttributeName
                      value:textBlueColor
                      range:NSMakeRange(loc, len)];
    
    return attString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
