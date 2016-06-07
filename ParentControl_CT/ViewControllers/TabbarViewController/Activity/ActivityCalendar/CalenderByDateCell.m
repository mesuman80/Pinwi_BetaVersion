//
//  ActivityTableCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CalenderByDateCell.h"

@implementation CalenderByDateCell

@synthesize subjectLabel;

@synthesize startLabel;
@synthesize endLabel;
@synthesize repeatLabel;

@synthesize startTimeLabel;
@synthesize endTimeLabel;
@synthesize repeatTimeLabel;

@synthesize daysArray;
@synthesize daysPlannedArray;

@synthesize spclImg;
@synthesize privateImg;
@synthesize ValidImg;


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
        startLabel=[[UILabel alloc]init];
        self.backgroundColor=appBackgroundColor;
        daysArray=[[NSMutableArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];
        
        for(int i=0;i<daysArray.count;i++)
        {
            UIButton  *dayButton=[UIButton buttonWithType:UIButtonTypeSystem];
            [dayButton setTitle:[daysArray objectAtIndex:i] forState:UIControlStateNormal];
            dayButton.tintColor=[UIColor blackColor];
            dayButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
           // dayButton.frame=CGRectMake(0,0,screenWidth*.075,screenWidth*.075);
            // dayButton.titleLabel.text=[daysArray objectAtIndex:day];
            
            [daysArray replaceObjectAtIndex:i withObject:dayButton];
            //  [dayButton addTarget:self action:@selector(datePickerCalHide) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:dayButton];
        }
        
        spclImg=[[UIImageView alloc]init];
        privateImg=[[UIImageView alloc]init];
        ValidImg=[[UIImageView alloc]init];
        
        [self.contentView addSubview:spclImg];
        [self.contentView addSubview:privateImg];
        [self.contentView addSubview:ValidImg];
        
        [self.contentView addSubview:subjectLabel];
        [self.contentView addSubview:startLabel];
        
    }
    return self;
}


-(void)addSubject:(NSDictionary *)subDictionary
{
    //NSDictionary *subDict=[subDictionary objectForKey:@"Data"];
    
    NSString *sub=[subDictionary objectForKey:@"Name"];
    CGSize displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*ScreenFactor]}];
    subjectLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
    subjectLabel.text=sub;
    subjectLabel.frame=CGRectMake(cellPadding,0,ScreenWidthFactor*200,displayValueSize.height);
    subjectLabel.center=CGPointMake(subjectLabel.center.x,ScreenHeightFactor*25);
    subjectLabel.textColor=cellTextColor;

    //[subjectLabel sizeToFit];

    int day=0;
   daysPlannedArray=[subDictionary objectForKey:@"repeat"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    
    int  xx=cellPadding;
//    if(screenWidth>700)
//    {
//    xx=ScreenWidthFactor*150-cellPadding;
//    }
//    else
//    {
//        xx=ScreenWidthFactor*150;
//    }
    
    for(UIButton *dayButton in daysArray)
    {
        [self resetColor:[daysArray objectAtIndex:day]];
        dayButton.frame=CGRectMake(xx,ScreenHeightFactor*23,ScreenWidthFactor*20,ScreenWidthFactor*20);
        dayButton.center=CGPointMake(dayButton.center.x, ScreenHeightFactor*57);
        
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
    
    xx=screenWidth-cellPadding;
    if([[subDictionary objectForKey:@"IsVerified"] isEqualToString:@"False"])
    {
        ValidImg.frame=CGRectMake(0, 0, ScreenWidthFactor*20, ScreenWidthFactor*20);
        ValidImg.image=[UIImage imageNamed:isiPhoneiPad(@"nonverified.png")];
        ValidImg.layer.cornerRadius = spclImg.frame.size.width/2;
        ValidImg.layer.borderWidth = 0.5f;
        ValidImg.layer.borderColor = [UIColor clearColor].CGColor;
        ValidImg.clipsToBounds = YES;
        ValidImg.alpha=1.0;
        ValidImg.center=CGPointMake(screenWidth-ValidImg.frame.size.width/2-cellPadding, subjectLabel.center.y);
        
        xx-=ValidImg.frame.size.width;
        if(screenWidth>700)
        {
            xx=xx-5*ScreenWidthFactor;
        }
        else
        {
            xx=xx-2*ScreenWidthFactor;
        }
    }
    
    
    // btn=[daysArray objectAtIndex:daysArray.count-2];
    
    
    
    UIButton *btn=[daysArray lastObject];
    
    if([[subDictionary objectForKey:@"Type"] isEqualToString:@"After School"])
    {
        startLabel.text= [NSString stringWithFormat:@"%@ - %@ ",[subDictionary objectForKey:@"StartTime"],[subDictionary objectForKey:@"EndTime"]];
        displayValueSize = [startLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f*ScreenFactor]}];
        startLabel.font=[UIFont fontWithName:RobotoRegular size:9.0f*ScreenFactor];
        if(screenWidth>700)
        {
            startLabel.font=[UIFont fontWithName:RobotoRegular size:9.0f*ScreenFactor];
        }
        [startLabel sizeToFit];
        startLabel.frame=CGRectMake(screenWidth*.05,subjectLabel.frame.size.height+0.06*screenHeight,displayValueSize.width,displayValueSize.height);
        startLabel.center=CGPointMake(screenWidth-startLabel.frame.size.width/2-cellPadding,btn.center.y);
        //startLabel.center=CGPointMake(startLabel.center.x,self.center.y);
        startLabel.textAlignment=NSTextAlignmentRight;
        startLabel.textColor=activityHeading2FontCode;//[UIColor darkGrayColor];
        
        if([[subDictionary objectForKey:@"IsPrivate"] isEqualToString:@"True"])
        {
            privateImg.frame=CGRectMake(0, 0, ScreenWidthFactor*20, ScreenWidthFactor*20);
            privateImg.image=[UIImage imageNamed:isiPhoneiPad(@"private.png")];
            privateImg.layer.cornerRadius = privateImg.frame.size.width/2;
            privateImg.layer.borderWidth = 0.5f;
            privateImg.layer.borderColor = [UIColor clearColor].CGColor;
            privateImg.clipsToBounds = YES;
            privateImg.alpha=1.0;
            privateImg.center=CGPointMake(xx-privateImg.frame.size.width/2, subjectLabel.center.y);
            xx-=privateImg.frame.size.width;
            if(screenWidth>700)
            {
                xx=xx-5*ScreenWidthFactor;
            }
            else
            {
                xx=xx-2*ScreenWidthFactor;
            }
            
            btn=[daysArray objectAtIndex:daysArray.count-3];
        }
        // need to change
        
        if([[subDictionary objectForKey:@"IsSpecial"]isEqualToString:@"True"])
        {
            spclImg.frame=CGRectMake(0, 0, ScreenWidthFactor*20, ScreenWidthFactor*20);
            spclImg.center=CGPointMake(btn.center.x, startLabel.center.y);
            spclImg.image=[UIImage imageNamed:isiPhoneiPad(@"special.png")];
            spclImg.layer.cornerRadius = spclImg.frame.size.width/2;
            spclImg.layer.borderWidth = 0.5f;
            spclImg.layer.borderColor = [UIColor clearColor].CGColor;
            spclImg.center=CGPointMake(xx-spclImg.frame.size.width/2, subjectLabel.center.y);
            spclImg.clipsToBounds = YES;
            spclImg.alpha=1.0;
        }

    }
}

-(void)addActivityHeading:(NSDictionary*)subDict
{
  //  NSDictionary *subDict=[subDictionary objectForKey:@"NoActivity"];
  
    CGSize displayValueSize = [[subDict objectForKey:@"NoActivity"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    subjectLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    subjectLabel.text=[subDict objectForKey:@"NoActivity"];
    subjectLabel.frame=CGRectMake(screenWidth*.05,screenHeight*.01,screenWidth*.9,screenHeight*.08);
    subjectLabel.center=CGPointMake(screenWidth*.5,subjectLabel.center.y);
    subjectLabel.textAlignment=NSTextAlignmentCenter;
    subjectLabel.textColor=[UIColor lightGrayColor];
    subjectLabel.numberOfLines=2;
}


-(void)resetColor:(UIButton*)button
{
    [button setTitleColor:[[UIColor blackColor]colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"weekGray.png")] forState:UIControlStateNormal];
    privateImg.alpha=0.0;
    spclImg.alpha=0.0;
    ValidImg.alpha=0.0;
}


@end
