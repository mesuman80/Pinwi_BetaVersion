//
//  GetCityListService.m
//  XmlParser
//
//  Created by Yogesh Gupta on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//


#import "GetChildAfterSchoolActiviesByDay.h"
#import "Constant.h"


@implementation GetChildAfterSchoolActiviesByDay

-(void)initService:(NSDictionary *)dictionary
{
   
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetChildAfterSchoolActiviesByDay xmlns=\"http://tempuri.org/\">\n" ];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",@"appconnect@$2015"]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ChildID>%@</ChildID>\n",[dictionary objectForKey:@"ChildID"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<DaysAgo>%@</DaysAgo>\n",[dictionary objectForKey:@"DaysAgo"]]];
    
    soapMessage = [soapMessage stringByAppendingString:@"</GetChildAfterSchoolActiviesByDay>\n</soap:Body>\n</soap:Envelope>\n"];
    
    
    NSLog(@"Soap Message %@",soapMessage);
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/GetChildAfterSchoolActiviesByDay" forHTTPHeaderField:@"SOAPAction"];
    [soapRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [soapRequest setHTTPMethod:@"POST"];
    [soapRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [self openUrlWithRequest:soapRequest];
    
    
   

}




-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"%@",dictionary);
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
}


@end
