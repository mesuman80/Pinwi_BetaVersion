//
//  GetCityListService.m
//  XmlParser
//
//  Created by Yogesh Gupta on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//
#import "Constant.h"
#import "DeleteAllyByAllyID.h"

@implementation DeleteAllyByAllyID

-(void)initService:(NSDictionary *)dictionary
{
   
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<DeleteAllyByAllyID xmlns=\"http://tempuri.org/\">\n" ];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",@"appconnect@$2015"]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<AllyID>%@</AllyID>\n",[dictionary objectForKey:@"AllyID"]]];
    
    soapMessage = [soapMessage stringByAppendingString:@"</DeleteAllyByAllyID>\n</soap:Body>\n</soap:Envelope>\n"];
    
    NSLog(@"soapmessage:%@",soapMessage);
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    soapRequest.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/DeleteAllyByAllyID" forHTTPHeaderField:@"SOAPAction"];
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
