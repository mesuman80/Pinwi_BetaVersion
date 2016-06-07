//
//  PinWiRightSideButton.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 15/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "PinWiRightSideButton.h"
#import "PC_DataManager.h"

@implementation PinWiRightSideButton
-(void)drawRightHandButton
{
    UIImageView *flowerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"Flower_pinwii.png")]];
    [flowerImage setFrame:CGRectMake(0,0,self.frame.size.width-20,self.frame.size.height-20)];
    [flowerImage setUserInteractionEnabled:YES];
    [flowerImage setCenter:CGPointMake(self.frame.size.width/2.0f,self.frame.size.height/2.0f)];
    [flowerImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtFlower:)]];
    [self addSubview:flowerImage];
}
-(void)touchAtFlower:(id)sender
{
    if(_delegate){ [self.delegate touchAtPinwiWheel];}
}

@end
