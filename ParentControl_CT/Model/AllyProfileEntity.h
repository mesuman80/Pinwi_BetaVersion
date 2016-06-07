//
//  AllyProfileEntity.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 03/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ParentProfileEntity;

@interface AllyProfileEntity : NSManagedObject

@property (nonatomic, retain) NSString * ally_ID;
@property (nonatomic, retain) NSString * contact_no;
@property (nonatomic, retain) NSString * emailAdd;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * parent_ID;
@property (nonatomic, retain) NSString * profilePic;
@property (nonatomic, retain) NSString * relationship;
@property (nonatomic, retain) NSString * relationship_ID;
@property (nonatomic, retain) ParentProfileEntity *alloyProfile;

@end
