//
//  ActivityData.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 21/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ActivityData.h"

@implementation ActivityData



@synthesize parentId;
@synthesize childId;
@synthesize category;
@synthesize subCategory;
@synthesize activityId;
@synthesize activityType;
@synthesize activityName;
@synthesize acitivityNotes;
@synthesize isMarkPrivate;
@synthesize isMarkSpecial;
@synthesize informAllyArray;
@synthesize Date;
@synthesize startTime;
@synthesize endTime;
@synthesize repeatActivityArray;

-(id)init
{
    if(self=[super init])
    {
        informAllyArray=[[NSMutableArray alloc]init];
        repeatActivityArray=[[NSMutableArray alloc]init];
        
        parentId=@"";
        childId=@"";
        activityType=@"";
        category=@"";
        subCategory=@"";
        activityId=@"";
        activityName=@"";
        acitivityNotes=@"";
        startTime=@"";
        endTime=@"";
        Date=@"";

        return self;
    }
    
    return nil;
}

//-(void)addNewActivity
//{
//    
//}




@end
