//
//  ParentProfileObject.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 24/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ParentProfileObject.h"

@implementation ParentProfileObject

@synthesize autoLockTime;
@synthesize autoLockID;
@synthesize city;
@synthesize cityID;
//@synthesize confirmationCode;
@synthesize contactNo;
@synthesize country;
@synthesize countryID;
@synthesize deviceId;
@synthesize deviceToken;
@synthesize dob;
@synthesize emailAdd;
@synthesize flatBuilding;
@synthesize image;
@synthesize firstName;
@synthesize lastName;
@synthesize neighourRad;
@synthesize neighourID;
@synthesize parentId;
@synthesize passcode;
@synthesize passwd;
@synthesize relation;
@synthesize childrenProfiles;
@synthesize allyProfiles;
@synthesize googleAddress;
@synthesize latitude;
@synthesize longitute;
@synthesize streetLocality;
@synthesize gender;

-(id)init
{
    if(self = [super init])
    {
        
        allyProfiles=[[NSMutableArray alloc]init];
        childrenProfiles=[[NSMutableArray alloc]init];
        
        parentId=firstName=lastName=emailAdd=city=flatBuilding=country=relation=googleAddress=latitude=longitute=image=passcode=autoLockTime=cityID=countryID=@"";
        NSLog(@" in parent object constructor");;
        return self;
    }
    return nil;
}

-(void)addNewChildToParent:(ChildProfileObject*)obj
{
    NSLog(@" in parent object constructor  %i", [obj isKindOfClass:[ChildProfileObject class]]);;
     NSLog(@" in parent object constructor  %@", obj);;
    
}


-(void)addNewChild:(ChildProfileObject *)childObj
{
    if(!childrenProfiles){
        childrenProfiles = [[NSMutableArray alloc] initWithObjects:childObj, nil];
    }else{
        [childrenProfiles addObject:childObj];
    }
}

-(void)addnewAlly:(AllyProfileObject*)allyObj
{
    if(!allyProfiles){
        allyProfiles = [[NSMutableArray alloc] initWithObjects:allyObj, nil];
    }else{
        [allyProfiles addObject:allyObj];
    }

}


@end
