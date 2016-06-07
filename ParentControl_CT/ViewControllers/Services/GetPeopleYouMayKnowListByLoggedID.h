//
//  GetPeopleYouMayKnowListByLoggedID.h
//  ParentControl_CT
//
//  Created by Sakshi on 02/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetPeopleYouMayKnowListByLoggedID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
