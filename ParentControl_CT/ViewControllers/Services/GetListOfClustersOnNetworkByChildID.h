//
//  GetListOfClustersOnNetworkByChildID.h
//  ParentControl_CT
//
//  Created by Sakshi on 18/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetListOfClustersOnNetworkByChildID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
