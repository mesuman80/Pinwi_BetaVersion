//
//  GetListOfPinWiNetworksByLoggedID.h
//  ParentControl_CT
//
//  Created by Sakshi on 08/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetListOfPinWiNetworksByLoggedID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
