//
//  ChildProfileObject.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 24/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ChildProfileObject.h"

@implementation ChildProfileObject


@synthesize child_ID;
@synthesize parent_ID;
@synthesize firstName;
@synthesize lastName;
@synthesize nick_Name;
@synthesize dob;
@synthesize gender;
@synthesize school_Name;
@synthesize school_ID;
@synthesize passcode;
@synthesize autolock_Time;
@synthesize autolock_ID;
@synthesize profile_pic;
@synthesize earnedPts;
@synthesize pendingPts;


-(id)init
{
    if(self = [super init])
    {
        
        firstName=@"test";
        lastName=@"test1 ";
        
        //name=child_ID=parent_ID=nick_Name=gender=school_Name=created_By=modified_By=@"";
        NSLog(@"child obj created  %@", firstName);
        return self;
       
    }
   return nil;
}

@end
