//
//  GetListOfPendingRequestsByLoggedID.m
//  ParentControl_CT
//
//  Created by Sakshi on 11/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "GetListOfPendingRequestsByLoggedID.h"
#import "Constant.h"

@implementation GetListOfPendingRequestsByLoggedID

-(void)initService:(NSDictionary *)dictionary
{
    
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetListOfPendingRequestsByLoggedID xmlns=\"http://tempuri.org/\">\n" ];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",PiniWiWsPswd]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<LoggedID>%li</LoggedID>\n",[[dictionary valueForKey:@"LoggedID"] integerValue]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<PageIndex>%li</PageIndex>\n",[[dictionary valueForKey:@"PageIndex"] integerValue]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<NumberOfRows>%li</NumberOfRows>",[[dictionary valueForKey:@"NumberOfRows"] integerValue]]];
    
    soapMessage = [soapMessage stringByAppendingString:@"</GetListOfPendingRequestsByLoggedID>\n</soap:Body>\n</soap:Envelope>\n"];
    NSLog(@"Soap Message %@",soapMessage);
    
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/GetListOfPendingRequestsByLoggedID" forHTTPHeaderField:@"SOAPAction"];
    [soapRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [soapRequest setHTTPMethod:@"POST"];
    [soapRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [self openUrlWithRequest:soapRequest];
}



-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"GetListOfPendingRequestsByLoggedID connectionDidFinishLoadingData");
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
    NSLog(@"GetListOfPendingRequestsByLoggedID error message %@",errorMessage);
    
}


@end
