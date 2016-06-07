//
//  ForgotPasscode.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface RecoverPasscode : UrlConnection<UrlConnectionDelegate>


-(void)initService:(NSDictionary *)dictionary;

@end
