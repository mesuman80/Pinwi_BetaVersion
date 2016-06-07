//
//  ParentProfileEntity.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 03/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AllyProfileEntity, ChildProfileEntity;

@interface ParentProfileEntity : NSManagedObject

@property (nonatomic, retain) NSString * autolockID;
@property (nonatomic, retain) NSString * autoLockTime;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * cityId;
@property (nonatomic, retain) NSString * contactNo;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * countryId;
@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) NSString * dob;
@property (nonatomic, retain) NSString * emailAdd;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * flatNum;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * googleMapAdd;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * neighbourID;
@property (nonatomic, retain) NSString * neighbourRad;
@property (nonatomic, retain) NSString * parentID;
@property (nonatomic, retain) NSString * passcode;
@property (nonatomic, retain) NSString * passwd;
@property (nonatomic, retain) NSString * relation;
@property (nonatomic, retain) NSString * streetLocality;
@property (nonatomic, retain) NSOrderedSet *allyProfiles;
@property (nonatomic, retain) NSOrderedSet *childrenProfiles;
@end

@interface ParentProfileEntity (CoreDataGeneratedAccessors)

- (void)insertObject:(AllyProfileEntity *)value inAllyProfilesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAllyProfilesAtIndex:(NSUInteger)idx;
- (void)insertAllyProfiles:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAllyProfilesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAllyProfilesAtIndex:(NSUInteger)idx withObject:(AllyProfileEntity *)value;
- (void)replaceAllyProfilesAtIndexes:(NSIndexSet *)indexes withAllyProfiles:(NSArray *)values;
- (void)addAllyProfilesObject:(AllyProfileEntity *)value;
- (void)removeAllyProfilesObject:(AllyProfileEntity *)value;
- (void)addAllyProfiles:(NSOrderedSet *)values;
- (void)removeAllyProfiles:(NSOrderedSet *)values;
- (void)insertObject:(ChildProfileEntity *)value inChildrenProfilesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenProfilesAtIndex:(NSUInteger)idx;
- (void)insertChildrenProfiles:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenProfilesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenProfilesAtIndex:(NSUInteger)idx withObject:(ChildProfileEntity *)value;
- (void)replaceChildrenProfilesAtIndexes:(NSIndexSet *)indexes withChildrenProfiles:(NSArray *)values;
- (void)addChildrenProfilesObject:(ChildProfileEntity *)value;
- (void)removeChildrenProfilesObject:(ChildProfileEntity *)value;
- (void)addChildrenProfiles:(NSOrderedSet *)values;
- (void)removeChildrenProfiles:(NSOrderedSet *)values;
@end
