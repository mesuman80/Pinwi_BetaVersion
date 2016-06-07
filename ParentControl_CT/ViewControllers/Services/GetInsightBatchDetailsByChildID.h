//
//  GetInsightBatchDetailsByChildID.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetInsightBatchDetailsByChildID : UrlConnection<UrlConnectionDelegate>
-(void)initService:(NSDictionary *)dictionary;


@end
