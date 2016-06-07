//
//  SendFriendRequest.h
//  ParentControl_CT
//
//  Created by Sakshi on 10/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface SendFriendRequest : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
