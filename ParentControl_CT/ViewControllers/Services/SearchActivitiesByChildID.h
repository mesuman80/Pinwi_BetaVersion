//
//  SearchActivitiesByChildID.h
//  ParentControl_CT
//
//  Created by Sakshi on 19/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface SearchActivitiesByChildID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
