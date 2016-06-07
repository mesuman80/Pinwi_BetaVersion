//
//  SubjectDetailCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 22/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

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
        
        cellName=[[UILabel alloc]init];
        cellDescName=[[UILabel alloc]init];
        cellImage=[[UIImageView alloc]init];
        cellButton=[[UIButton alloc]init];
        
        [self.contentView addSubview:cellName];
        [self.contentView addSubview:cellDescName];
        [self.contentView addSubview:cellImage];
        [self.contentView addSubview:cellButton];
        
    }
    return self;
}


-(void)generateCell:(NSMutableDictionary*)dictionary
{
    NSString *type=[dictionary objectForKey:@"Type"];
    NSString *text=[dictionary objectForKey:@"Text"];
    
    CGSize displayValueSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    cellName.font=[UIFont fontWithName:RobotoRegular size:15.0f];
    cellName.text=text;
    cellName.frame=CGRectMake(12,8,displayValueSize.width,displayValueSize.height);
    
    if([type isEqualToString:@"HeadOne"])
    {
        
        //  subjectLabel.center=CGPointMake(subjectLabel.center.x,self.frame.size.height/2);
        self.contentView.backgroundColor=activityHeading1Code;
        cellName.textColor=activityHeading1FontCode;
        [cellName sizeToFit];
        

    }
    
    if([type isEqualToString:@"HeadTwo"])
    {
        self.contentView.backgroundColor=activityHeading2Code;
        cellName.textColor=activityHeading2FontCode;
        [cellName sizeToFit];
    }
    
    if([type isEqualToString:@"CheckMark"])
    {
        self.contentView.backgroundColor=appBackgroundColor;
        cellName.textColor=ActivityDaysColor;
        //[self setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cellName sizeToFit];
    }
    
    if([type isEqualToString:@"DetailDisclosure"])
    {
        cellName.textColor=ActivityDaysColor;
        [cellName sizeToFit];
    }
    
    if([type isEqualToString:@"Toggle"])
    {
        self.contentView.backgroundColor=appBackgroundColor;
        cellName.textColor=activityHeading1FontCode;
        [cellName sizeToFit];
    }
    
    if([type isEqualToString:@"NoteView"])
    {
        self.contentView.backgroundColor=appBackgroundColor;
        cellName.textColor=activityHeading2FontCode;
        [cellName sizeToFit];
        
        cellButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [cellButton setTitle:@"FINISH" forState:UIControlStateNormal];
        cellButton.tintColor=radiobuttonSelectionColor;
        cellButton.backgroundColor=[UIColor clearColor];
        [cellButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        cellButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.018*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
        [cellButton sizeToFit];
        cellButton.layer.borderWidth=1.0;
        cellButton.layer.borderColor=radiobuttonSelectionColor.CGColor;
        cellButton.frame=CGRectMake(0, 0, screenWidth*.7, screenHeight*.07);
        cellButton.center=CGPointMake(screenWidth/2, 150);
        // [cellButton addTarget:self action:@selector(customBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cellButton];
       
    }
    
    if([type isEqualToString:@"GreenButton"])
    {
        
        cellButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [cellButton setTitle:@"FINISH" forState:UIControlStateNormal];
        cellButton.tintColor=radiobuttonSelectionColor;
        cellButton.backgroundColor=[UIColor clearColor];
        [cellButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        cellButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.018*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
        [cellButton sizeToFit];
        cellButton.layer.borderWidth=1.0;
        cellButton.layer.borderColor=radiobuttonSelectionColor.CGColor;
        cellButton.center=CGPointMake(screenWidth/2, 200);
        // [cellButton addTarget:self action:@selector(customBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cellButton];

//        self.backgroundColor=activityHeading1Code;
//        cellName.textColor=activityHeading1FontCode;
//        [cellName sizeToFit];
    }
    
    if([type isEqualToString:@"BlueClearButton"])
    {
//        self.backgroundColor=activityHeading1Code;
//        cellName.textColor=activityHeading1FontCode;
//        [cellName sizeToFit];
    }
    
    if([type isEqualToString:@"ExamDate"])
    {
        cellName.textColor=activityHeading1FontCode;
        cellName.frame=CGRectMake(35,15,displayValueSize.width,displayValueSize.height);
        [cellName sizeToFit];
        cellImage.image = [UIImage imageNamed:isiPhoneiPad(@"calendar.png")];
        cellImage.frame=CGRectMake(320-35,5,30,30);
        
        self.imageView.image=[UIImage imageNamed:isiPhoneiPad(@"exam.png")];
        [self.imageView setFrame:CGRectMake(5,5,30,30)];
        
    }
    
    
}



@end
