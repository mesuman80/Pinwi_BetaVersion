//
//  GetCountryListService.h
//  ParentControl_CT
//
//  Created by Priyanka on 24/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetAllyTypes : UrlConnection<UrlConnectionDelegate>


-(void)initService:(NSDictionary *)dictionary;
@end
