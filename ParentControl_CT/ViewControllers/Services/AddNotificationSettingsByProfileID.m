//
//  GetCityListService.m
//  XmlParser
//
//  Created by Yogesh Gupta on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//

#import "AddNotificationSettingsByProfileID.h"
#import "Constant.h"


@implementation AddNotificationSettingsByProfileID

-(void)initService:(NSDictionary *)dictionary
{
   
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<AddNotificationSettingsByProfileID xmlns=\"http://tempuri.org/\">\n" ];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",@"appconnect@$2015"]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ProfileID>%@</ProfileID>\n",[dictionary objectForKey:@"ProfileID"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<NotificationType>%@</NotificationType>\n",[dictionary objectForKey:@"NotificationType"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Status>%@</Status>\n",[dictionary objectForKey:@"Status"]]];
    soapMessage = [soapMessage stringByAppendingString:@"</AddNotificationSettingsByProfileID>\n</soap:Body>\n</soap:Envelope>\n"];
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/AddNotificationSettingsByProfileID" forHTTPHeaderField:@"SOAPAction"];
    [soapRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [soapRequest setHTTPMethod:@"POST"];
    [soapRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [self openUrlWithRequest:soapRequest];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
}


@end
