//
//  GetListOfPinWiNetworksByLoggedID.m
//  ParentControl_CT
//
//  Created by Sakshi on 08/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "GetListOfPinWiNetworksByLoggedID.h"
#import "Constant.h"

@implementation GetListOfPinWiNetworksByLoggedID

-(void)initService:(NSDictionary *)dictionary
{
    
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetListOfPinWiNetworksByLoggedID xmlns=\"http://tempuri.org/\">\n" ];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",PiniWiWsPswd]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<LoggedID>%ld</LoggedID>\n",[[dictionary valueForKey:@"LoggedID"] integerValue]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ChildID>%ld</ChildID>\n",[[dictionary valueForKey:@"ChildID"] integerValue]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<PageIndex>%ld</PageIndex>\n",[[dictionary valueForKey:@"PageIndex"] integerValue]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<NumberOfRows>%d</NumberOfRows>",[[dictionary valueForKey:@"NumberOfRows"] integerValue]]];
    
    soapMessage = [soapMessage stringByAppendingString:@"</GetListOfPinWiNetworksByLoggedID>\n</soap:Body>\n</soap:Envelope>\n"];
    NSLog(@"Soap Message %@",soapMessage);
    
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/GetListOfPinWiNetworksByLoggedID" forHTTPHeaderField:@"SOAPAction"];
    [soapRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [soapRequest setHTTPMethod:@"POST"];
    [soapRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [self openUrlWithRequest:soapRequest];
}



-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"GetListOfPinWiNetworksByLoggedID connectionDidFinishLoadingData");
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
    NSLog(@"GetListOfPinWiNetworksByLoggedID error message %@",errorMessage);
    
}


@end
