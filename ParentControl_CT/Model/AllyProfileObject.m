//
//  AllyProfileObject.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 24/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AllyProfileObject.h"

@implementation AllyProfileObject

@synthesize ally_ID;
@synthesize parent_ID;
@synthesize firstName;
@synthesize lastName;
@synthesize relationship;
@synthesize emailAdd;
@synthesize contact_no;
@synthesize relationship_ID;

@synthesize child_ID;
@synthesize activity_ID;
@synthesize pickUp;
@synthesize drop;
@synthesize remarks;
@synthesize activityDate;
@synthesize activityTime;
@synthesize notifyMode;

-(id)init
{
    if(self = [super init])
    {
        
        ally_ID=parent_ID=relationship=contact_no=emailAdd=firstName=lastName=@" ";
        
        //name=child_ID=parent_ID=nick_Name=gender=school_Name=created_By=modified_By=@"";
        NSLog(@"child obj created  %@", firstName);
        return self;
        
    }
    return nil;
}


@end
