//
//  InsightData.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 13/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlConnection.h"
@interface InsightData : NSObject
+(InsightData *)insightData;
-(void)updateConnectionArray:(UrlConnection *)connection isRemove:(BOOL)isRemove isAllRemove:(BOOL)isAllRemove;
@property NSMutableArray *connectionArray;
@end
