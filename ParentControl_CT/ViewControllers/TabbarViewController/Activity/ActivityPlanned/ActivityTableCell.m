//
//  ActivityTableCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//
/*
#import "ActivityTableCell.h"

@implementation ActivityTableCell

@synthesize subjectLabel;

@synthesize startLabel;
@synthesize endLabel;
@synthesize repeatLabel;

@synthesize startTimeLabel;
@synthesize endTimeLabel;
@synthesize repeatTimeLabel;

@synthesize daysArray;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        subjectLabel=[[UILabel alloc]init];
        [self.contentView addSubview:subjectLabel];
        [[PC_DataManager sharedManager]getWidthHeight];
        self.backgroundColor=appBackgroundColor;//[UIColor colorWithRed:218.0f/255 green:231.0f/255 blue:232.0f/255 alpha:1]
        daysArray=[[NSMutableArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];
        for(int i=0;i<daysArray.count;i++)
        {
            UIButton  *dayButton=[UIButton buttonWithType:UIButtonTypeSystem];
            [dayButton setTitle:[daysArray objectAtIndex:i] forState:UIControlStateNormal];
            [dayButton setTitleColor:activityHeading2FontCode forState:UIControlStateNormal];
            dayButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
            [dayButton setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"weekGray.png")] forState:UIControlStateNormal];            [daysArray replaceObjectAtIndex:i withObject:dayButton];
            //  [dayButton addTarget:self action:@selector(datePickerCalHide) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:dayButton];
        }
        
        
    }
    return self;
}

-(void)addSubjectCredential:(NSString*)statusString
{
    
    CGSize displayValueSize = [statusString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    subjectLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f*ScreenHeightFactor];
    subjectLabel.text=statusString;
    subjectLabel.frame=CGRectMake(cellPadding,0,displayValueSize.width,displayValueSize.height);
    subjectLabel.center=CGPointMake(subjectLabel.center.x,self.frame.size.height/2);
    subjectLabel.textColor=[UIColor darkGrayColor];
    [subjectLabel sizeToFit];
   

}

-(void)scheduleActivity:(NSMutableDictionary*)statusDict
{
    
    subjectLabel.font=[UIFont fontWithName:RobotoRegular size:15.0f*ScreenHeightFactor];
    subjectLabel.text=[statusDict objectForKey:@"Desc"];
    subjectLabel.frame=CGRectMake(ScreenWidthFactor*10,ScreenHeightFactor*10,ScreenWidthFactor*300,ScreenHeightFactor*30);
    subjectLabel.center=CGPointMake(screenWidth*.5,subjectLabel.center.y);
    subjectLabel.textAlignment=NSTextAlignmentCenter;
    subjectLabel.textColor=[UIColor lightGrayColor];
    
}


-(void)addSubject:(NSString *)sub withDaysArray:(NSMutableArray*)daysPlannedArray withScreenWd:(float)screenWidth1 screenHt:(float)screenHeight1
{
 
    
    CGSize displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*ScreenFactor]}];
    subjectLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
    subjectLabel.text=sub;
    subjectLabel.frame=CGRectMake(cellPadding,0,ScreenWidthFactor*120,displayValueSize.height);
    subjectLabel.center=CGPointMake(subjectLabel.center.x,ScreenHeightFactor*25);
    subjectLabel.textColor=cellTextColor;
    
    
    
  //  [subjectLabel sizeToFit];
    
//    
//    NSDate *today=[NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"E"];
//    NSString *currentDate=[formatter stringFromDate:today];
//    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    
    int day=0;
    int xx;
    if(screenWidth>700)
    {
       xx=ScreenWidthFactor*150-cellPadding;
    }
    else
    {
        xx=ScreenWidthFactor*150;
    }
    
    for(UIButton *dayButton in daysArray)
    {
        [self resetColor:[daysArray objectAtIndex:day]];
        dayButton.frame=CGRectMake(xx,ScreenHeightFactor*23,ScreenWidthFactor*20,ScreenWidthFactor*20);
        dayButton.center=CGPointMake(dayButton.center.x, ScreenHeightFactor*25);

       
        if((weekday-1)==day)
        {
            [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [dayButton setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"weekLightBlue.png")] forState:UIControlStateNormal];
        }
       else if([[daysPlannedArray objectAtIndex:day] isEqualToString:@"1"])
        {
           [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             [dayButton setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"weekBlue.png")] forState:UIControlStateNormal];
        }
//        else
//        {
//            dayButton.tintColor=activityHeading1FontCode;
//        }
         //        dayButton.layer.cornerRadius = dayButton.frame.size.width/2;
//        dayButton.layer.borderWidth = 0.5f;
//        dayButton.layer.borderColor = [UIColor whiteColor].CGColor;
//        dayButton.clipsToBounds = YES;
        [dayButton setUserInteractionEnabled:NO];// allTargets=[self.superview becomeFirstResponder];
        day++;
        if(screenWidth>700)
        {
            xx+=dayButton.frame.size.width+5*ScreenWidthFactor;
        }
        else
        {
        xx+=dayButton.frame.size.width+2*ScreenWidthFactor;
        }
    }

    
//    for(int day=0; day<7; day++)
//    {
//        UIButton  *dayButton=[UIButton buttonWithType:UIButtonTypeSystem];
//        [dayButton setTitle:[daysArray objectAtIndex:day] forState:UIControlStateNormal];
//        dayButton.tintColor=[UIColor blackColor];
//        dayButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
//        dayButton.frame=CGRectMake(0,0,self.frame.size.width*.075,self.frame.size.width*.075);
//        dayButton.center=CGPointMake((day+4)*.087*self.frame.size.width, self.frame.size.height/2);
//        if([[daysPlannedArray objectAtIndex:day] isEqualToString:@"1"])
//        {
//            dayButton.backgroundColor=radiobuttonSelectionColor;
//        }
//        else
//        {
//            dayButton.backgroundColor=radiobuttonBgColor;
//        }
//        // dayButton.titleLabel.text=[daysArray objectAtIndex:day];
//        dayButton.layer.cornerRadius = dayButton.frame.size.width/2;
//        dayButton.layer.borderWidth = 0.5f;
//        dayButton.layer.borderColor = [UIColor whiteColor].CGColor;
//        dayButton.clipsToBounds = YES;
//        
//        
//        //  [dayButton addTarget:self action:@selector(datePickerCalHide) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:dayButton];
//    }
    
}

-(void)resetColor:(UIButton*)button
{
    [button setTitleColor:[[UIColor blackColor]colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"weekGray.png")] forState:UIControlStateNormal];
}



@end
 */
//
//  ActivityTableCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ActivityTableCell.h"

@implementation ActivityTableCell

//@synthesize subjectLabel;

@synthesize startLabel;
@synthesize endLabel;
@synthesize repeatLabel;
@synthesize subjectLabel;
@synthesize startTimeLabel;
@synthesize endTimeLabel;
@synthesize repeatTimeLabel;

@synthesize spclImg;
@synthesize privateImg;
@synthesize ValidImg;
@synthesize daysArray;
@synthesize daysPlannedArray;

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
        subjectLabel=[[UILabel alloc]init];
        daysArray=[[NSMutableArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];
        for(int i=0;i<daysArray.count;i++)
        {
            UIButton  *dayButton=[UIButton buttonWithType:UIButtonTypeSystem];
            [dayButton setTitle:[daysArray objectAtIndex:i] forState:UIControlStateNormal];
            [dayButton setTitleColor:activityHeading2FontCode forState:UIControlStateNormal];
            dayButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
            [dayButton setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"weekGray.png")] forState:UIControlStateNormal];            [daysArray replaceObjectAtIndex:i withObject:dayButton];
            //  [dayButton addTarget:self action:@selector(datePickerCalHide) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:dayButton];
        }
        
        
        startLabel=[[UILabel alloc]init];
        
        daysPlannedArray=[[NSMutableArray alloc]init];
        spclImg=[[UIImageView alloc]init];
        privateImg=[[UIImageView alloc]init];
        ValidImg=[[UIImageView alloc]init];
        
        [self.contentView addSubview:subjectLabel];
        [self.contentView addSubview:startLabel];
        [self.contentView addSubview:spclImg];
        [self.contentView addSubview:privateImg];
        [self.contentView addSubview:ValidImg];
        
        
        [self setBackgroundColor:appBackgroundColor];
    }
    
    return self;
}

//-(void)addActivity:(NSString *)sub withDaysArray:(NSMutableArray*)daysPlannedArray startOn:(NSString*)startTime endOn:(NSString*)endTime repaetFor:(NSString*)repeatTime withScreenWd:(float)screenWidth screenHt:(float)screenHeight
//{
//    [subjectLabel removeFromSuperview];
//    [daysArray removeAllObjects];
//    [startTimeLabel removeFromSuperview];
//    [endTimeLabel removeFromSuperview];
//    [repeatTimeLabel removeFromSuperview];
//    daysArray=nil;

//    self.backgroundColor=appBackgroundColor;

-(void)addActivity:(NSMutableDictionary *)activityDict
{
    int xx;
    int day=0;
    
    NSString *sub=[activityDict objectForKey:@"ActivityName"];
    CGSize displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*ScreenFactor]}];
    subjectLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
    subjectLabel.text=sub;
    subjectLabel.frame=CGRectMake(cellPadding,0,ScreenWidthFactor*200,displayValueSize.height);
    subjectLabel.center=CGPointMake(subjectLabel.center.x,ScreenHeightFactor*23);
    subjectLabel.textColor=cellTextColor;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    
    xx=cellPadding;
    daysPlannedArray=[activityDict objectForKey:@"repeat"];
    for(UIButton *dayButton in daysArray)
    {
        [self resetColor:[daysArray objectAtIndex:day]];
        dayButton.frame=CGRectMake(xx,ScreenHeightFactor*23,ScreenWidthFactor*20,ScreenWidthFactor*20);
        dayButton.center=CGPointMake(dayButton.center.x, ScreenHeightFactor*57);
        
//        if((weekday-1)==day)
//        {
//            [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [dayButton setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"weekBlue.png")] forState:UIControlStateNormal];
//        }
         if([[daysPlannedArray objectAtIndex:day] isEqualToString:@"1"])
        {
            [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [dayButton setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"weekBlue.png")] forState:UIControlStateNormal];
        }
        [dayButton setUserInteractionEnabled:NO];// allTargets=[self.superview becomeFirstResponder];
        day++;
        if(screenWidth>700)
        {
            xx+=dayButton.frame.size.width+5*ScreenWidthFactor;
        }
        else
        {
            xx+=dayButton.frame.size.width+2*ScreenWidthFactor;
        }
    }
    
    UIButton *btn=[daysArray lastObject];
    
//    startLabel.text= [NSString stringWithFormat:@"%@ - %@ ", [activityDict objectForKey:@"StartTime"],[activityDict objectForKey:@"EndTime"]];
//    displayValueSize = [startLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12*ScreenFactor]}];
//    startLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
//    startLabel.frame=CGRectMake(12*ScreenWidthFactor,btn.frame.size.height+20*ScreenHeightFactor,displayValueSize.width,displayValueSize.height);
//    startLabel.center=CGPointMake(screenWidth-startLabel.frame.size.width/2-cellPadding,btn.center.y);
//    startLabel.textColor=activityHeading2FontCode;
//    startLabel.textAlignment=NSTextAlignmentRight;
    
    
    if([[activityDict objectForKey:@"IsVerified"] isEqualToString:@"0"])
    {
//        ValidImg.frame=CGRectMake(0, 0, ScreenWidthFactor*20, ScreenWidthFactor*20);
//        ValidImg.image=[UIImage imageNamed:isiPhoneiPad(@"verified.png")];
//        ValidImg.layer.cornerRadius = ValidImg.frame.size.width/2;
//        ValidImg.layer.borderWidth = 0.5f;
//        ValidImg.layer.borderColor = [UIColor clearColor].CGColor;
//        ValidImg.clipsToBounds = YES;
//    }
//    else
//    {
        ValidImg.frame=CGRectMake(0, 0, ScreenWidthFactor*20, ScreenWidthFactor*20);
        ValidImg.image=[UIImage imageNamed:isiPhoneiPad(@"nonverified.png")];
        ValidImg.layer.cornerRadius = spclImg.frame.size.width/2;
        ValidImg.layer.borderWidth = 0.5f;
        ValidImg.layer.borderColor = [UIColor clearColor].CGColor;
        ValidImg.clipsToBounds = YES;
        ValidImg.alpha=1.0;
    }
    ValidImg.center=CGPointMake(screenWidth-ValidImg.frame.size.width/2-cellPadding, subjectLabel.center.y);
    
    xx=ValidImg.frame.origin.x;
    if(screenWidth>700)
    {
        xx=xx-5*ScreenWidthFactor;
    }
    else
    {
        xx=xx-2*ScreenWidthFactor;
    }
    
    
    // btn=[daysArray objectAtIndex:daysArray.count-2];
   /* if([[activityDict objectForKey:@"IsPrivate"] isEqualToString:@"1"])
    {
        privateImg.frame=CGRectMake(0, 0, ScreenWidthFactor*20, ScreenWidthFactor*20);
        privateImg.image=[UIImage imageNamed:isiPhoneiPad(@"private.png")];
        privateImg.layer.cornerRadius = privateImg.frame.size.width/2;
        privateImg.layer.borderWidth = 0.5f;
        privateImg.layer.borderColor = [UIColor clearColor].CGColor;
        privateImg.clipsToBounds = YES;
        privateImg.alpha=1.0;
        privateImg.center=CGPointMake(xx-privateImg.frame.size.width/2, subjectLabel.center.y);
        xx=privateImg.frame.origin.x;
        if(screenWidth>700)
        {
            xx=xx-5*ScreenWidthFactor;
        }
        else
        {
            xx=xx-2*ScreenWidthFactor;
        }
        
        btn=[daysArray objectAtIndex:daysArray.count-3];
    }*/
    // need to change
    
    if([[activityDict objectForKey:@"IsSpecial"]isEqualToString:@"1"])
    {
        spclImg.frame=CGRectMake(0, 0, ScreenWidthFactor*20, ScreenWidthFactor*20);
        spclImg.image=[UIImage imageNamed:isiPhoneiPad(@"exam.png")];
        spclImg.layer.cornerRadius = spclImg.frame.size.width/2;
        spclImg.layer.borderWidth = 0.5f;
        spclImg.layer.borderColor = [UIColor clearColor].CGColor;
        spclImg.center=CGPointMake(xx-spclImg.frame.size.width/2, subjectLabel.center.y);
        spclImg.clipsToBounds = YES;
        spclImg.alpha=1.0;
    }
    
    
    
}

-(void)resetColor:(UIButton*)button
{
    [button setTitleColor:[[UIColor blackColor]colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"weekGray.png")] forState:UIControlStateNormal];
    privateImg.alpha=0.0;
    spclImg.alpha=0.0;
    ValidImg.alpha=0.0;
    
}


-(void)scheduleActivity:(NSMutableDictionary*)subDict
{
    for(UIButton *dayButton in daysArray)
    {
        [self resetColor:dayButton];
    }
    
    //CGSize displayValueSize = [[subDict objectForKey:@"Desc"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    subjectLabel.font=[UIFont fontWithName:RobotoRegular size:15.0f];
    subjectLabel.text=[subDict objectForKey:@"Desc"];
    subjectLabel.frame=CGRectMake(screenWidth*.05,screenHeight*.035,screenWidth*.9,screenHeight*.08);
    subjectLabel.center=CGPointMake(screenWidth*.5,subjectLabel.center.y);
    subjectLabel.textAlignment=NSTextAlignmentCenter;
    subjectLabel.textColor=[UIColor lightGrayColor];
}

@end


