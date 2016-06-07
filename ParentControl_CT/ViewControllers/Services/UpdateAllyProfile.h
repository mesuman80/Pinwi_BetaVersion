//
//  LoginService.h
//  XmlParser
//
//  Created by Veenus Chhabra on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//

#import "UrlConnection.h"

@interface UpdateAllyProfile :  UrlConnection<UrlConnectionDelegate>


-(void)initService:(NSDictionary *)dictionary;


@end
