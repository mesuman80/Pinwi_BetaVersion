//
//  LoginService.m
//  XmlParser
//
//  Created by Veenus Chhabra on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//
#import "Constant.h"
#import "CheckConfirmationCodeByParentID.h"

@implementation CheckConfirmationCodeByParentID

-(void)initService:(NSDictionary *)dictionary
{
    
    
    
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<CheckConfirmationCodeByParentID xmlns=\"http://tempuri.org/\">\n" ];
                            
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",@"appconnect@$2015"]];

    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ParentID>%@</ParentID>\n",
                                                        [ NSString stringWithFormat:@"%@", [dictionary valueForKey:@"ParentID"] ]]];

    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ConfirmationCode>%@</ConfirmationCode>\n",[dictionary valueForKey:@"ConfirmationCode"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<EmailAddress>%@</EmailAddress>\n",[dictionary valueForKey:@"EmailAddress"]]];
    
     soapMessage = [soapMessage stringByAppendingString:@"</CheckConfirmationCodeByParentID>\n</soap:Body>\n</soap:Envelope>\n"];
    
    
    NSLog(@"Soap Message %@",soapMessage);
    
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/CheckConfirmationCodeByParentID" forHTTPHeaderField:@"SOAPAction"];
    [soapRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [soapRequest setHTTPMethod:@"POST"];
    [soapRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [self openUrlWithRequest:soapRequest];
}



-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"confrimation code: %@",dictionary);
   
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
    
    
}


@end
