//
//  ScreenInfo.m
//  ChatApplication
//
//  Created by veenus on 26/02/14.
//  Copyright (c) 2014 mvn. All rights reserved.
//

#import "ScreenInfo.h"

@implementation ScreenInfo
{
    
}
+(float)getScreenWidth
{
    float screenWid=[[UIScreen mainScreen]bounds].size.width;
    return screenWid;
}
+(float)getScreenHeight
{
    float screenHt=[[UIScreen mainScreen]bounds].size.height;
    return screenHt;
}

@end
