//
//  GetListOfPendingRequestsByLoggedID.h
//  ParentControl_CT
//
//  Created by Sakshi on 11/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetListOfPendingRequestsByLoggedID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
