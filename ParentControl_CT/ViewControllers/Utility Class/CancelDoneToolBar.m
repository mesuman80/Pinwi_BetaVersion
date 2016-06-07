//
//  CancelDoneToolBar.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 08/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CancelDoneToolBar.h"
#import "Constant.h"

@implementation CancelDoneToolBar
{
   
    UITextField *numberTextField;
}

@synthesize cancelButton, doneButton;
-(id)initWithFrame:(CGRect)frame andTextField:(UITextField*)txtfld
{
    if(self=[super initWithFrame:frame])
    {
        numberTextField=txtfld;
        return self;
    }
    return nil;
}


-(void)drawButtons
{
   cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setFrame:CGRectMake(cellPaddingReg, 0,self.frame.size.height, self.frame.size.height)];
    [cancelButton.titleLabel setTextColor:placeHolderReg];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:RobotoRegular size:8*ScreenFactor]];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    //[cancelButton sizeToFit];
    [cancelButton addTarget:self action:@selector(cancelNumberPad) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    
    doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setFrame:CGRectMake(self.frame.size.width-cancelButton.frame.size.width/2-cellPaddingReg, 0,self.frame.size.height-4*ScreenHeightFactor, self.frame.size.height)];
    [doneButton.titleLabel setTextColor:placeHolderReg];
    [doneButton.titleLabel setFont:[UIFont fontWithName:RobotoRegular size:8*ScreenFactor]];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    //[doneButton sizeToFit];
    [doneButton setCenter:CGPointMake(self.frame.size.width-doneButton.frame.size.width/2-cellPaddingReg, doneButton.center.y)];
    [doneButton addTarget:self action:@selector(doneWithNumberPad) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
    
    

}

-(void)cancelNumberPad{
    if(self.delegate)[self.delegate touchAtCancelButton:self];
}

-(void)doneWithNumberPad
{
    if(self.delegate)[self.delegate touchAtDoneButton:self];

}




//-(void)drawButtons
//{
//    cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
//    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
//    cancelButton.tintColor=[UIColor darkGrayColor];
//    cancelButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f];
//    [cancelButton sizeToFit];
//    cancelButton.frame=CGRectMake(0,0,self.bounds.size.width*.3, self.bounds.size.height*.1);
//    [cancelButton addTarget:self action:@selector(cancelTouched) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:cancelButton];
//
//    doneButton=[UIButton buttonWithType:UIButtonTypeSystem];
//    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
//    doneButton.tintColor=[UIColor darkGrayColor];
//    doneButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f];
//    doneButton.frame=CGRectMake(self.bounds.size.width-cancelButton.frame.size.width,0,self.bounds.size.width*.3,self.bounds.size.height*.1);
//    [doneButton addTarget:self action:@selector(doneTouched) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:doneButton];
//}
//
//-(void)cancelTouched
//{
//    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         
//                         self.center=CGPointMake(0, [[UIScreen mainScreen]bounds].size.height);
//                         
//                     }
//                     completion:^(BOOL finished){
//                         
//                     }];
//
//}
//
//-(void)doneTouched
//{
//    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         
//                         self.center=CGPointMake(0, [[UIScreen mainScreen]bounds].size.height);
//                         
//                     }
//                     completion:^(BOOL finished){
//                         
//                     }];
//
//}


@end
