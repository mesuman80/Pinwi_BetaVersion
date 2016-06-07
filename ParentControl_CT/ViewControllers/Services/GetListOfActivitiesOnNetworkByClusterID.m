//
//  GetListOfActivitiesOnNetworkByClusterID.m
//  ParentControl_CT
//
//  Created by Sakshi on 18/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "GetListOfActivitiesOnNetworkByClusterID.h"
#import "Constant.h"

@implementation GetListOfActivitiesOnNetworkByClusterID

-(void)initService:(NSDictionary *)dictionary
{
    
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<GetListOfActivitiesOnNetworkByClusterID xmlns=\"http://tempuri.org/\">\n" ];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",PiniWiWsPswd]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ChildID>%li</ChildID>\n",[[dictionary valueForKey:@"ChildID"] integerValue]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ClusterID>%li</ClusterID>\n",[[dictionary valueForKey:@"ClusterID"] integerValue]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<PageIndex>%li</PageIndex>\n",[[dictionary valueForKey:@"PageIndex"] integerValue]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<NumberOfRows>%li</NumberOfRows>",[[dictionary valueForKey:@"NumberOfRows"] integerValue]]];
    
    soapMessage = [soapMessage stringByAppendingString:@"</GetListOfActivitiesOnNetworkByClusterID>\n</soap:Body>\n</soap:Envelope>\n"];
    NSLog(@"Soap Message %@",soapMessage);
    
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/GetListOfActivitiesOnNetworkByClusterID" forHTTPHeaderField:@"SOAPAction"];
    [soapRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [soapRequest setHTTPMethod:@"POST"];
    [soapRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [self openUrlWithRequest:soapRequest];
}



-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"GetListOfActivitiesOnNetworkByClusterID connectionDidFinishLoadingData");
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
    NSLog(@"GetListOfActivitiesOnNetworkByClusterID error message %@",errorMessage);
    
}


@end
