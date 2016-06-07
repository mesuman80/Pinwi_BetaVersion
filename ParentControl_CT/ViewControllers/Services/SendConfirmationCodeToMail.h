//
//  LoginService.h
//  XmlParser
//
//  Created by Veenus Chhabra on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//



#import "UrlConnection.h"
@protocol SendConfirmationCodeDelegate <NSObject>

-(void)confirmationCode:(NSString*)code;

@end


@interface SendConfirmationCodeToMail :  UrlConnection<UrlConnectionDelegate>
@property id<SendConfirmationCodeDelegate> sendConfirmationDelegate;

-(void)initService:(NSDictionary *)dictionary;


@end
