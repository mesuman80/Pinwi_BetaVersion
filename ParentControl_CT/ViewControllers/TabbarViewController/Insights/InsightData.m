//
//  InsightData.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 13/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InsightData.h"

static InsightData *insightSharedData;
@implementation InsightData
+(InsightData *)insightData
{
    if(!insightSharedData)
    {
        insightSharedData  = [[InsightData alloc]init];
    }
    return insightSharedData;
}
-(id)init
{
    if(self = [super init])
    {
        return self;
    }
    return nil;
}
-(void)updateConnectionArray:(UrlConnection *)connection isRemove:(BOOL)isRemove isAllRemove:(BOOL)isAllRemove
{
    if(isAllRemove)
    {
        for(UrlConnection *connection1 in _connectionArray)
        {
            [connection1 stopConnection];
        }
        [_connectionArray removeAllObjects];
    }
    else if(isRemove)
    {
        [connection stopConnection];
        [_connectionArray removeObject:connection];
    }
    else
    {
        if(!_connectionArray)
        {
            _connectionArray = [[NSMutableArray alloc]init];
        }
        
        [_connectionArray addObject:connection];
    }
    
}
@end
