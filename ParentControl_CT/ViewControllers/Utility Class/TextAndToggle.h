//
//  TextAndToggle.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 24/09/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ToggleProtocol;

@interface TextAndToggle : UIView
@property id<ToggleProtocol>toggleDelegate;
@property UISwitch *toggleSwitch;
-(void)drawUi:(NSString *)labeltext textcolor:(UIColor*)color font:(UIFont*)textfont;
@end

@protocol ToggleProtocol <NSObject>

-(void)toggleButtonTouched:(BOOL)isToggleOn;

@end