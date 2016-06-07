//
//  ChildSubjectRating.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 25/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildSubjectRating : NSObject
-(void)updateRating:(NSDictionary *)dictionary rating:(NSString *)rate;
@property NSString *activityID;
@property NSString *name;
@property NSString *dayId;
@property NSString *rating;
@end
