//
//  SubjectCalenderTableCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AfterSchoolTableViewCell.h"

@implementation AfterSchoolTableViewCell
{
    
}

- (void)awakeFromNib {
    // Initialization code
}
@synthesize subjectLabel;

@synthesize startLabel;
@synthesize endLabel;
@synthesize repeatLabel;

@synthesize startTimeLabel;
@synthesize endTimeLabel;
@synthesize repeatTimeLabel;

@synthesize daysArray;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)addActivity:(NSString *)sub withDaysArray:(NSMutableArray*)daysPlannedArray startOn:(NSString*)startTime endOn:(NSString*)endTime repaetFor:(NSString*)repeatTime withScreenWd:(float)screenWidth screenHt:(float)screenHeight
{
    [subjectLabel removeFromSuperview];
    [daysArray removeAllObjects];
    daysArray=nil;
    
    
    subjectLabel=[[UILabel alloc]init];
    daysArray=[[NSMutableArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"Th",@"F",@"S", nil];
    
    CGSize displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    subjectLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f];
    subjectLabel.text=sub;
    subjectLabel.frame=CGRectMake(self.frame.size.width*.05,0,displayValueSize.width,displayValueSize.height);
    subjectLabel.center=CGPointMake(subjectLabel.center.x,self.frame.size.height/2);
    subjectLabel.textColor=[UIColor darkGrayColor];
    [subjectLabel sizeToFit];
    [self.contentView addSubview:subjectLabel];
    
    
    for(int day=0; day<daysPlannedArray.count; day++)
    {
        UIButton  *dayButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [dayButton setTitle:[daysArray objectAtIndex:day] forState:UIControlStateNormal];
        dayButton.tintColor=[UIColor blackColor];
        dayButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
        dayButton.frame=CGRectMake(0,0,self.frame.size.width*.075,self.frame.size.width*.075);
        dayButton.center=CGPointMake((day+4)*.09*self.frame.size.width, self.frame.size.height/2);
        if([[daysPlannedArray objectAtIndex:day] isEqualToString:@"1"])
        {
            dayButton.backgroundColor=radiobuttonSelectionColor;
        }
        else
        {
            dayButton.backgroundColor=radiobuttonBgColor;
        }
        // dayButton.titleLabel.text=[daysArray objectAtIndex:day];
        dayButton.layer.cornerRadius = dayButton.frame.size.width/2;
        dayButton.layer.borderWidth = 0.5f;
        dayButton.layer.borderColor = [UIColor whiteColor].CGColor;
        dayButton.clipsToBounds = YES;
        
        
        //  [dayButton addTarget:self action:@selector(datePickerCalHide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dayButton];
    }
    
    displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    startLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f];
    startLabel.text=sub;
    startLabel.frame=CGRectMake(self.frame.size.width*.05,self.frame.size.height*.1,displayValueSize.width,displayValueSize.height);
    startLabel.center=CGPointMake(startLabel.center.x,self.center.y);
    startLabel.textColor=[UIColor darkGrayColor];
    [startLabel sizeToFit];
    [self addSubview:startLabel];
    
    displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    endLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f];
    endLabel.text=sub;
    endLabel.frame=CGRectMake(self.frame.size.width*.05,self.frame.size.height*.15,displayValueSize.width,displayValueSize.height);
    endLabel.center=CGPointMake(endLabel.center.x,self.frame.size.height/2);
    endLabel.textColor=[UIColor darkGrayColor];
    [endLabel sizeToFit];
    [self addSubview:endLabel];
   
    displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    repeatLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f];
    repeatLabel.text=sub;
    repeatLabel.frame=CGRectMake(self.frame.size.width*.05,self.frame.size.height*.2,displayValueSize.width,displayValueSize.height);
    repeatLabel.center=CGPointMake(repeatLabel.center.x,self.frame.size.height/2);
    repeatLabel.textColor=[UIColor darkGrayColor];
    [repeatLabel sizeToFit];
    [self addSubview:repeatLabel];
    
    
    displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    startTimeLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f];
    startTimeLabel.text=sub;
    startTimeLabel.frame=CGRectMake(self.frame.size.width-displayValueSize.width-10,self.frame.size.height*.1,displayValueSize.width,displayValueSize.height);
    startTimeLabel.center=CGPointMake(startTimeLabel.center.x,self.frame.size.height/2);
    startTimeLabel.textColor=[UIColor darkGrayColor];
    [startTimeLabel sizeToFit];
    [self addSubview:startTimeLabel];
    
    displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    endTimeLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f];
    endTimeLabel.text=sub;
    endTimeLabel.frame=CGRectMake(self.frame.size.width-displayValueSize.width-10,self.frame.size.height*.15,displayValueSize.width,displayValueSize.height);
    endTimeLabel.center=CGPointMake(endTimeLabel.center.x,self.frame.size.height/2);
    endTimeLabel.textColor=[UIColor darkGrayColor];
    [endTimeLabel sizeToFit];
    [self addSubview:endTimeLabel];
    
    displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    repeatTimeLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f];
    repeatTimeLabel.text=sub;
    repeatTimeLabel.frame=CGRectMake(self.frame.size.width-displayValueSize.width-10,self.frame.size.height*.2,displayValueSize.width,displayValueSize.height);
    repeatTimeLabel.center=CGPointMake(repeatTimeLabel.center.x,self.frame.size.height/2);
    repeatTimeLabel.textColor=[UIColor darkGrayColor];
    [repeatTimeLabel sizeToFit];
    [self addSubview:repeatTimeLabel];
    
}


@end
