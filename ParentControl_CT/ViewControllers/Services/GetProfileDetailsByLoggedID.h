//
//  GetProfileDetailsByLoggedID.h
//  ParentControl_CT
//
//  Created by Sakshi on 03/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetProfileDetailsByLoggedID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
