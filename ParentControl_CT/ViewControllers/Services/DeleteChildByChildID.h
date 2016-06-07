//
//  GetCityListService.h
//  XmlParser
//
//  Created by Yogesh Gupta on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//


#import "UrlConnection.h"




@interface DeleteChildByChildID : UrlConnection<UrlConnectionDelegate>

-(void)getCityList;
-(void)initService:(NSDictionary *)dictionary;

@end
