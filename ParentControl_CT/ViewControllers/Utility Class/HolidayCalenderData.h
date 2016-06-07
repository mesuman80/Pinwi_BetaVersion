//
//  HolidayCalenderData.h
//  ParentControl_CT
//
//  Created by Yogesh on 10/01/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolidayCalenderData : NSObject
+(instancetype)sharedInstance;
@property (nonatomic, weak) NSDate *startDate;
@property (nonatomic, weak) NSDate *endDate;

@end
