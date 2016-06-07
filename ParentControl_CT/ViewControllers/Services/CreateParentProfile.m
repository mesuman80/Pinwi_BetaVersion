//
//  LoginService.m
//  XmlParser
//
//  Created by Veenus Chhabra on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//
#import "Constant.h"
#import "CreateParentProfile.h"

@implementation CreateParentProfile

-(void)initService:(NSDictionary *)dictionary
{
    
    
    
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<CreateParentProfile xmlns=\"http://tempuri.org/\">\n" ];
                            
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",PiniWiWsPswd]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<DeviceID>%@</DeviceID>\n",[dictionary valueForKey:@"DeviceID"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<DeviceToken>%@</DeviceToken>\n",[dictionary valueForKey:@"DeviceToken"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<FirstName>%@</FirstName>\n",[dictionary valueForKey:@"FirstName"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<LastName>%@</LastName>\n",[dictionary valueForKey:@"LastName"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ProfileImage>%@</ProfileImage>\n",[dictionary valueForKey:@"ProfileImage"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<EmailAddress>%@</EmailAddress>\n",[dictionary valueForKey:@"EmailAddress"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Password>%@</Password>\n",[dictionary valueForKey:@"Password"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<DateOfBirth>%@</DateOfBirth>\n",[dictionary valueForKey:@"DateOfBirth"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Relation>%@</Relation>\n",[dictionary valueForKey:@"Relation"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Gender>%@</Gender>\n",[dictionary valueForKey:@"Gender"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Contact>%@</Contact>\n",[dictionary valueForKey:@"Contact"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Passcode>%@</Passcode>\n",[dictionary valueForKey:@"Passcode"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<AutolockTime>%@</AutolockTime>\n",[dictionary valueForKey:@"AutolockTime"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<FlatNoBuilding>%@</FlatNoBuilding>\n",[dictionary valueForKey:@"FlatNoBuilding"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<StreetLocality>%@</StreetLocality>\n",[dictionary valueForKey:@"StreetLocality"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<City>%@</City>\n",[dictionary valueForKey:@"City"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Country>%@</Country>\n",[dictionary valueForKey:@"Country"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<GoogleMapAddress>%@</GoogleMapAddress>\n",[dictionary valueForKey:@"GoogleMapAddress"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Longitude>%@</Longitude>\n",[dictionary valueForKey:@"Longitude"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Latitude>%@</Latitude>\n",[dictionary valueForKey:@"Latitude"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<NeighbourhoodRadius>%@</NeighbourhoodRadius>\n",[dictionary valueForKey:@"NeighbourhoodRad"]]];
    
    soapMessage = [soapMessage stringByAppendingString:@"</CreateParentProfile>\n</soap:Body>\n</soap:Envelope>\n"];
    
    NSLog(@"Soap Message %@",soapMessage);
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/CreateParentProfile" forHTTPHeaderField:@"SOAPAction"];
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
