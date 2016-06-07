//
//  ActivityTableCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ScheduledAllyCell.h"

@implementation ScheduledAllyCell

//@synthesize subjectLabel;

@synthesize nameLabel,dateLabel,timeLabel,pickDropLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        nameLabel=[[UILabel alloc]init];
        dateLabel=[[UILabel alloc]init];
        timeLabel=[[UILabel alloc]init];
        pickDropLabel=[[UILabel alloc]init];
        
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:timeLabel];
        [self.contentView addSubview:pickDropLabel];
    }
    
    return self;
}

-(void)listingOfAlly:(AllyProfileObject*)allyObj
{
    int xx=cellPadding;
    NSString *sub=[allyObj firstName];
    CGSize displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*ScreenFactor]}];
    nameLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
    nameLabel.text=sub;
    nameLabel.frame=CGRectMake(xx,0,ScreenWidthFactor*200,displayValueSize.height);
    nameLabel.center=CGPointMake(nameLabel.center.x,ScreenHeightFactor*23);
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.textColor=cellBlackColor_7;
    
    if([allyObj.pickUp isEqualToString:@"1"])
    {
        sub=@"Pick";
    }
    else
    {
        sub=@"Drop";
    }
    displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*ScreenFactor]}];
    pickDropLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
    pickDropLabel.text=sub;
    pickDropLabel.frame=CGRectMake(xx,self.frame.size.height-displayValueSize.height,ScreenWidthFactor*200,displayValueSize.height);
   
    
    NSLog(@"%f",self.frame.size.height);
    
    if(screenWidth>700)
    {
     pickDropLabel.center=CGPointMake(nameLabel.center.x,73*ScreenHeightFactor-pickDropLabel.frame.size.height/2-5*ScreenHeightFactor);
    }
    else
    {
        pickDropLabel.center=CGPointMake(nameLabel.center.x,63*ScreenHeightFactor-pickDropLabel.frame.size.height/2-5*ScreenHeightFactor);
    }
    pickDropLabel.textAlignment=NSTextAlignmentLeft;
    pickDropLabel.textColor=cellBlackColor_7;
    
    xx+=nameLabel.frame.size.width;
    sub=[allyObj activityDate];
    displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*ScreenFactor]}];
    dateLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
    dateLabel.text=sub;
    dateLabel.frame=CGRectMake(xx,0,screenWidth-xx,displayValueSize.height);
    dateLabel.center=CGPointMake(screenWidth-cellPadding-dateLabel.frame.size.width/2,ScreenHeightFactor*23);
    dateLabel.textAlignment=NSTextAlignmentRight;
    dateLabel.textColor=placeHolderReg;
    
    sub=[allyObj activityTime];
    displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*ScreenFactor]}];
    timeLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
    timeLabel.text=sub;
    timeLabel.frame=CGRectMake(xx,self.frame.size.height-displayValueSize.height,screenWidth-xx,displayValueSize.height);
    timeLabel.center=CGPointMake(screenWidth-cellPadding-timeLabel.frame.size.width/2,pickDropLabel.center.y);
    timeLabel.textAlignment=NSTextAlignmentRight;
    timeLabel.textColor=placeHolderReg;
}

@end
