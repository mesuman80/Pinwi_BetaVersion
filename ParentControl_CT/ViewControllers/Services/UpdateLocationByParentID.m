//
//  LoginService.m
//  XmlParser
//
//  Created by Veenus Chhabra on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//
#import "Constant.h"
#import "UpdateLocationByParentID.h"

@implementation UpdateLocationByParentID

-(void)initService:(NSDictionary *)dictionary
{
    
    
    
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<UpdateLocationByParentID xmlns=\"http://tempuri.org/\">\n" ];
                            
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",@"appconnect@$2015"]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ParentID>%@</ParentID>\n",[dictionary valueForKey:@"ParentID"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<FlatNoBuilding>%@</FlatNoBuilding>\n",[dictionary valueForKey:@"FlatNoBuilding"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<StreetLocality>%@</StreetLocality>\n",[dictionary valueForKey:@"StreetLocality"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<City>%@</City>\n",[dictionary valueForKey:@"City"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Country>%@</Country>\n",[dictionary valueForKey:@"Country"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<GoogleMapAddress>%@</GoogleMapAddress>\n",[dictionary valueForKey:@"GoogleMapAddress"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Longitude>%@</Longitude>\n",[dictionary valueForKey:@"Longitude"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Latitude>%@</Latitude>\n",[dictionary valueForKey:@"Latitude"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<NeighbourhoodRadius>%@</NeighbourhoodRadius>\n",[dictionary valueForKey:@"NeighbourhoodRad"]]];
    
    soapMessage = [soapMessage stringByAppendingString:@"</UpdateLocationByParentID>\n</soap:Body>\n</soap:Envelope>\n"];
    
    NSLog(@"Soap Message %@",soapMessage);
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/UpdateLocationByParentID" forHTTPHeaderField:@"SOAPAction"];
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
