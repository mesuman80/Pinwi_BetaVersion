//
//  PinWiRightSideButton.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 15/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PinWiRightSideButtonDelegate;
@interface PinWiRightSideButton : UIView
-(void)drawRightHandButton;
@property id<PinWiRightSideButtonDelegate>delegate;
@end
@protocol PinWiRightSideButtonDelegate<NSObject>
-(void)touchAtPinwiWheel;

@end
