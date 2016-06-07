//
//  GetChildDetailsByChildID.h
//  ParentControl_CT
//
//  Created by Sakshi on 07/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetChildDetailsByChildID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
