//
//  GetPointsInfoByChildID.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 26/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetPointsInfoByChildID : UrlConnection<UrlConnectionDelegate>
-(void)initService:(NSDictionary *)dictionary;
@end
