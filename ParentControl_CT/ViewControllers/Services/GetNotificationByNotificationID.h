//
//  GetCityListService.h
//  XmlParser
//
//  Created by Yogesh Gupta on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//


#import "UrlConnection.h"




@interface GetNotificationByNotificationID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;
@end
