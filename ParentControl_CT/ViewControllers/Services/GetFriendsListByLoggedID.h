//
//  GetFriendsListByLoggedID.h
//  ParentControl_CT
//
//  Created by Sakshi on 26/02/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetFriendsListByLoggedID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
