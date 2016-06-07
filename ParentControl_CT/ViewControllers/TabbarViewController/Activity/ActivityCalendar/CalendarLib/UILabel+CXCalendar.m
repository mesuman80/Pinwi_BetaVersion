//
//  UILabel+CXCalendar.m
//  Calendar
//
//  Created by Vladimir Grichina on 09.06.13.
//  Copyright (c) 2013 Componentix. All rights reserved.
//

#import "UILabel+CXCalendar.h"
#import "PC_DataManager.h"
#import "Constant.h"

@implementation UILabel (CXCalendar)

- (void)cx_setTextAttributes:(NSDictionary *)attrs
{
    if (attrs[UITextAttributeFont]) {
        self.font = attrs[UITextAttributeFont];
    }
    if (attrs[UITextAttributeTextColor]) {
        if(screenWidth>700)
        {
        self.font=[UIFont fontWithName:RobotoLight size:20*ScreenHeightFactor];
        }
        else
        {
            self.font=[UIFont fontWithName:RobotoLight size:16*ScreenHeightFactor];
        }
        self.textColor = attrs[UITextAttributeTextColor];
        
    }
    if (attrs[UITextAttributeTextShadowColor]) {
        self.shadowColor = attrs[UITextAttributeTextShadowColor];
    }
    if (attrs[UITextAttributeTextShadowOffset]) {
        self.shadowOffset = [attrs[UITextAttributeTextShadowOffset] CGSizeValue];
    }
}

@end
