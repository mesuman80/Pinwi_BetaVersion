//
//  SupportView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "SupportView.h"
#import "Constant.h"

@implementation SupportView
{
    UILabel *label;
    UITextView *textDesc;
}

-(id)initWithFrame:(CGRect)frame withSupportNo:(int)supportNo
{
    if(self==[super initWithFrame:frame])
    {
        [self renderElements:supportNo];
        self.frame=frame;
    }
    return self;
}

-(void)renderElements:(int)supportNo
{
    label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*.2)];
    label.text=[NSString stringWithFormat:@"Support %i",supportNo];
    label.font=[UIFont fontWithName:RobotoRegular size:14*ScreenHeightFactor];
    label.textAlignment=NSTextAlignmentNatural;
    label.textColor=cellBlackColor_7;
    [self addSubview:label];
    
    textDesc=[[UITextView alloc]initWithFrame:CGRectMake(0,self.frame.size.height*.2, self.frame.size.width, self.frame.size.height-self.frame.size.height*.2)];
    [textDesc setText:@"Support 1 description.."];
    textDesc.font=[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor];
    textDesc.textAlignment=NSTextAlignmentNatural;
    label.textColor=[UIColor blackColor];
    [textDesc resignFirstResponder];
    [self addSubview:textDesc];
}


@end

