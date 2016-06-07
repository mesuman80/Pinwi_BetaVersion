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
    
   UIView *viewBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.width)];
    [viewBack setBackgroundColor:[UIColor clearColor]];
    

    UIImageView *flowerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"Flower_pinwii.png")]];
    [flowerImage setFrame:CGRectMake(0,0,flowerImage.frame.size.width*1.2,flowerImage.frame.size.width*1.2)];
    [flowerImage setUserInteractionEnabled:YES];
    
    [flowerImage setCenter:CGPointMake(self.frame.size.width/2.0f+10,self.frame.size.height/2.0f)];
     [viewBack setCenter:CGPointMake(self.frame.size.width/2.0f,self.frame.size.height/2.0f)];
     [self addSubview:flowerImage];
    [self addSubview:viewBack];
    [viewBack addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtFlower:)]];
   
}
-(void)touchAtFlower:(id)sender
{
    if(_delegate){ [self.delegate touchAtPinwiWheel];}
}

@end
