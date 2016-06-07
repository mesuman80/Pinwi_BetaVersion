//
//  GetWishListsByChildID.h
//  ParentControl_CT
//
//  Created by Sakshi on 15/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetWishListsByChildID : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;

@end
