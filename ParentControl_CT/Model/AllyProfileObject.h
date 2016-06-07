//
//  AllyProfileObject.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 24/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllyProfileObject : NSObject

@property (nonatomic, retain) NSString * ally_ID;
@property (nonatomic, retain) NSString * parent_ID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * relationship;
@property (nonatomic, retain) NSString * relationship_ID;
@property (nonatomic, retain) NSString * emailAdd;
@property (nonatomic, retain) NSString * contact_no;
@property (nonatomic, retain) NSString * profilePic;

@property (nonatomic, retain) NSString * child_ID;
@property (nonatomic, retain) NSString * activity_ID;
@property (nonatomic, retain) NSString * activityDate;
@property (nonatomic, retain) NSString * activityTime;
@property (nonatomic, retain) NSString * pickUp;
@property (nonatomic, retain) NSString * drop;
@property (nonatomic, retain) NSString * remarks;
@property (nonatomic, retain) NSString * notifyMode;

@end
