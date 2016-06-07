//
//  SupportView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "TutorialView.h"
#import "Constant.h"
#import "PC_DataManager.h"
@implementation TutorialView
{
    UIImageView *tutImg;
    UILabel *label;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame withTutorialNo:(int)tutNo andImg:(UIImage*)image
{
    if(self==[super initWithFrame:frame])
    {
        [self renderElements:tutNo andImg:image];
        self.frame=frame;
    }
    return self;
}

-(void)renderElements:(int)tutNo andImg:(UIImage*)img
{
    tutImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    tutImg.image=img;
    [self addSubview:tutImg];
    
    [[PC_DataManager sharedManager]TutorialImages];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(tutImg.frame.size.width+10*ScreenHeightFactor, 0, self.frame.size.width-10*ScreenHeightFactor, self.frame.size.height)];
    label.text=[tutorialNameListArray  objectAtIndex:tutNo-1];
    label.font=[UIFont fontWithName:RobotoRegular size:15.0f*ScreenHeightFactor];
    label.textAlignment=NSTextAlignmentNatural;
    label.textColor=activityHeading1FontCode;
    [self addSubview:label];
}




@end

