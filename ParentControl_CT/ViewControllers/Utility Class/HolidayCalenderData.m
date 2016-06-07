//
//  HolidayCalenderData.m
//  ParentControl_CT
//
//  Created by Yogesh on 10/01/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "HolidayCalenderData.h"

@implementation HolidayCalenderData
+(instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


@end
