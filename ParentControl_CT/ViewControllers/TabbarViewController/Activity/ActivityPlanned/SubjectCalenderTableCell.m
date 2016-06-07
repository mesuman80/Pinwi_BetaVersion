//
//  SubjectCalenderTableCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "SubjectCalenderTableCell.h"

@implementation SubjectCalenderTableCell
{
    
}

- (void)awakeFromNib {
    // Initialization code
}
@synthesize subjectLabel;
@synthesize daysArray;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor= appBackgroundColor;
    
    // Configure the view for the selected state
}

-(void)addSubject:(NSString *)sub withDaysArray:(NSMutableArray*)daysPlannedArray withScreenWd:(float)screenWidth screenHt:(float)screenHeight
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
    [self addSubview:subjectLabel];
    
    
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
    
}


@end

