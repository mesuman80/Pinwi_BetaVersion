//
//  ChildSubjectRating.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 25/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ChildSubjectRating.h"

@implementation ChildSubjectRating

-(void)updateRating:(NSDictionary *)dictionary rating:(NSString *)rate
{
    _name = [dictionary valueForKey:@"Name"];
    _dayId = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"DayID"] ];
    _activityID = [dictionary valueForKey:@"ActivityID"];
    _rating = rate;
}

@end
