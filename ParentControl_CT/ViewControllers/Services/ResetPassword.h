//
//  ForgetPassword.h
//  ParentControl_CT
//
//  Created by Priyanka on 13/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface ResetPassword : UrlConnection<UrlConnectionDelegate>

-(void)initService:(NSDictionary *)dictionary;


@end
