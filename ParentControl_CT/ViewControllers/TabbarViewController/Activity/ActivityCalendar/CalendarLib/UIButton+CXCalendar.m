//
//  UIButton+CXCalendar.m
//  Calendar
//
//  Created by Vladimir Grichina on 09.06.13.
//  Copyright (c) 2013 Componentix. All rights reserved.
//

#import "UIButton+CXCalendar.h"
#import "PC_DataManager.h"
#import "Constant.h"

@implementation UIButton (CXCalendar)

- (void)cx_setTitleTextAttributes:(NSDictionary *)attrs forState:(UIControlState)state
{
    if (attrs[UITextAttributeFont]) {
       // self.titleLabel.font=[UIFont boldSystemFontOfSize:20*ScreenHeightFactor];
        self.titleLabel.font = attrs[UITextAttributeFont];
    }
    if (attrs[UITextAttributeTextShadowOffset]) {
        self.titleLabel.shadowOffset = [attrs[UITextAttributeTextShadowOffset] CGSizeValue];
    }
    if (attrs[UITextAttributeTextColor]) {
        
        if(screenWidth>700)
        {
        self.titleLabel.font=[UIFont fontWithName:RobotoLight size:20*ScreenHeightFactor];
        }
        else
        {
            self.titleLabel.font=[UIFont fontWithName:RobotoLight size:16*ScreenHeightFactor];
        }
        [self setTitleColor:attrs[UITextAttributeTextColor] forState:state];
    }
    if (attrs[UITextAttributeTextShadowColor]) {
        [self setTitleShadowColor:attrs[UITextAttributeTextShadowColor] forState:state];
    }
}

@end
