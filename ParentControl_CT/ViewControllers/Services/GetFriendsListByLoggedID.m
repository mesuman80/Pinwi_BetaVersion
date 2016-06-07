//
//  GetFriendsListByLoggedID.m
//  ParentControl_CT
//
//  Created by Sakshi on 26/02/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "GetFriendsListByLoggedID.h"
#import "Constant.h"

@implementation GetFriendsListByLoggedID

-(void)initService:(NSDictionary *)dictionary
{
    
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetFriendsListByLoggedID xmlns=\"http://tempuri.org/\">\n" ];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",PiniWiWsPswd]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<LoggedID>%@</LoggedID>\n",[dictionary valueForKey:@"LoggedID"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<PageIndex>%@</PageIndex>\n",[dictionary valueForKey:@"PageIndex"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<NumberOfRows>%@</NumberOfRows>",[dictionary valueForKey:@"NumberOfRows"]]];
    
    soapMessage = [soapMessage stringByAppendingString:@"</GetFriendsListByLoggedID>\n</soap:Body>\n</soap:Envelope>\n"];
    NSLog(@"Soap Message %@",soapMessage);
    
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/GetFriendsListByLoggedID" forHTTPHeaderField:@"SOAPAction"];
    [soapRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [soapRequest setHTTPMethod:@"POST"];
    [soapRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [self openUrlWithRequest:soapRequest];
}



-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"GetFriendsListByLoggedID connectionDidFinishLoadingData");
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
    NSLog(@"GetFriendsListByLoggedID error message %@",errorMessage);
    
}


@end
