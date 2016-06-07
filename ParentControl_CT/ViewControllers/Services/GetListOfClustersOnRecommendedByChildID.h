//
//  GetListOfClustersOnRecommendedByChildID.h
//  ParentControl_CT
//
//  Created by Sakshi on 14/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetListOfClustersOnRecommendedByChildID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
