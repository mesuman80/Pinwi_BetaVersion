//
//  ChildProfileEntity.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 03/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ParentProfileEntity;

@interface ChildProfileEntity : NSManagedObject

@property (nonatomic, retain) NSString * autolock_Time;
@property (nonatomic, retain) NSString * autolockID;
@property (nonatomic, retain) NSString * child_ID;
@property (nonatomic, retain) NSString * dob;
@property (nonatomic, retain) NSString * earnedPts;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * nick_Name;
@property (nonatomic, retain) NSString * parent_ID;
@property (nonatomic, retain) NSString * passcode;
@property (nonatomic, retain) NSString * pendingPts;
@property (nonatomic, retain) NSString * profile_pic;
@property (nonatomic, retain) NSString * school_Name;
@property (nonatomic, retain) NSString * school_ID;
@property (nonatomic, retain) ParentProfileEntity *childProfile;

@end
