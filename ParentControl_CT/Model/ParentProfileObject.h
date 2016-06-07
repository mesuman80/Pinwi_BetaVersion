//
//  ParentProfileObject.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 24/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildProfileObject.h"
#import "AllyProfileObject.h"

@interface ParentProfileObject : NSObject
@property (nonatomic, retain) NSString  * autoLockTime;
@property (nonatomic, retain) NSString  * autoLockID;
@property (nonatomic, retain) NSString  * city;
@property (nonatomic, retain) NSString  * cityID;
@property (nonatomic, retain) NSString  * contactNo;
@property (nonatomic, retain) NSString  * country;
@property (nonatomic, retain) NSString  * countryID;
@property (nonatomic, retain) NSString  * deviceId;
@property (nonatomic, retain) NSString  * deviceToken;
@property (nonatomic, retain) NSString  * dob;
@property (nonatomic, retain) NSString  * emailAdd;
@property (nonatomic, retain) NSString  * flatBuilding;
@property (nonatomic, retain) NSString  * streetLocality;
@property (nonatomic, retain) NSString  * image;
@property (nonatomic, retain) NSString  * firstName;
@property (nonatomic, retain) NSString  * lastName;
@property (nonatomic, retain) NSString  * neighourRad;
@property (nonatomic, retain) NSString  * neighourID;
@property (nonatomic, retain) NSString  * parentId;
@property (nonatomic, retain) NSString  * passcode;
@property (nonatomic, retain) NSString  * passwd;
@property (nonatomic, retain) NSString  * relation;
@property (nonatomic, retain) NSString  * googleAddress;
@property (nonatomic, retain) NSString  * latitude;
@property (nonatomic, retain) NSString  * longitute;
@property (nonatomic, retain) NSString  * gender;
//@property (nonatomic, retain) NSString  * longitute;
@property (nonatomic, retain) NSMutableArray *childrenProfiles;
@property (nonatomic, retain) NSMutableArray *allyProfiles;
-(void)addNewChildToParent:(ChildProfileObject*)obj;
-(void)addNewChild:(ChildProfileObject*)childObj;
-(void)addnewAlly:(AllyProfileObject*)allyDict;
@end

