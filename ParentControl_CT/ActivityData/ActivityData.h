//
//  ActivityData.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 21/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityData : NSObject

@property NSString *parentId;
@property NSString *activityType;
@property NSString *childId;
@property NSString *category;
@property NSString *subCategory;
@property NSString *activityId;
@property NSString *activityName;
@property NSString *Date;
@property NSString *startTime;
@property NSString *endTime;
@property NSMutableArray *repeatActivityArray;
@property BOOL isMarkSpecial;
@property BOOL isMarkPrivate;
@property NSMutableArray *informAllyArray;
@property NSString *acitivityNotes;

@end
