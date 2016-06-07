//
//  ActivityElementList.m
//  CircleAnim
//
//  Created by Suman Bhattacharyya on 20/04/15.
//  Copyright (c) 2015 Suman Bhattacharyya. All rights reserved.
//

#import "ActivityElementList.h"

@implementation ActivityElementList

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


{
    
    
   
    
}

@synthesize subjectName, subjectTitle;


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
        
        [[PC_DataManager sharedManager]getWidthHeight];
         
        UIView *view1= [[UIView alloc]initWithFrame:CGRectMake(screenWidth*.02,0, screenWidth*.12, screenWidth*.12)];
        view1.backgroundColor=radiobuttonSelectionColor;
        [self addSubview:view1];
        
        
        subjectTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0, screenWidth*.12, screenWidth*.12)];
        subjectTitle.textColor= [UIColor whiteColor];
        [subjectTitle setFont:[UIFont fontWithName:RobotoLight size:30]];
        subjectTitle.textAlignment=NSTextAlignmentCenter;
        [view1 addSubview:subjectTitle];
        
        UIView *view2= [[UIView alloc]initWithFrame:CGRectMake(screenWidth*.17,0, screenWidth*.7,  screenWidth*.12)];
        view2.backgroundColor= [UIColor clearColor];
        view2.layer.borderWidth=1.0f;
        view2.layer.borderColor=radiobuttonSelectionColor.CGColor;
        [view2 setUserInteractionEnabled:YES];
        [self addSubview:view2];

        
        subjectName= [[UILabel alloc] initWithFrame:CGRectMake(0,0,  screenWidth*.7,  screenWidth*.12)];
        subjectName.textColor= [UIColor blackColor];
        [subjectName setFont:[UIFont fontWithName:RobotoLight size:30]];
         subjectName.textAlignment=NSTextAlignmentCenter;
        [view2 addSubview:subjectName];
        
//        subjectTitle.text= @"M";
//        subjectName.text= @"Maths";
        
        
        
    }
    return self;
}


@end
