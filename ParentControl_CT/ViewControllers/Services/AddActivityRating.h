//
//  AddActivityRating.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 25/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface AddActivityRating : UrlConnection<UrlConnectionDelegate>
-(void)initService:(NSDictionary *)dictionary;
@end
