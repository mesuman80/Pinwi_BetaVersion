 //
//  LoginService.m
//  XmlParser
//
//  Created by Veenus Chhabra on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//
#import "Constant.h"
#import "UpdateChildProfile.h"

@implementation UpdateChildProfile

-(void)initService:(NSDictionary *)dictionary
{
    
    
    
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<UpdateChildProfile xmlns=\"http://tempuri.org/\">\n" ];
                            
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",@"appconnect@$2015"]];


//     soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ParentID>%@</ParentID>\n",
//                                                          [ NSString stringWithFormat:@"%@", [dictionary valueForKey:@"ParentID"] ]]];
//     soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Name>%@</Name>\n",[dictionary valueForKey:@"Name"]]];
//    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<NickName>%@</NickName>\n",[dictionary valueForKey:@"NickName"]]];
//    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<DateOfBirth>%@</DateOfBirth>\n",[dictionary valueForKey:@"DateOfBirth"]]];
//    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Gender>%@</Gender>\n",[dictionary valueForKey:@"Gender"]]];
//    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<SchoolName>%@</SchoolName>\n",[dictionary valueForKey:@"SchoolName"]]];
//    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Passcode>%@</Passcode>\n",[dictionary valueForKey:@"Passcode"]]];
//    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<AutolockTime>%@</AutolockTime>\n",[dictionary valueForKey:@"AutolockTime"]]];
//    

    
    



    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ParentID>%@</ParentID>\n",
                                                        [ NSString stringWithFormat:@"%@", [dictionary valueForKey:@"ParentID"] ]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ChildID>%@</ChildID>\n",
                                                        [ NSString stringWithFormat:@"%@", [dictionary valueForKey:@"ChildID"] ]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ProfileImage>%@</ProfileImage>\n",[dictionary valueForKey:@"ProfileImage"]]];

    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<FirstName>%@</FirstName>\n",[dictionary valueForKey:@"FirstName"]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<LastName>%@</LastName>\n",[dictionary valueForKey:@"LastName"]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<NickName>%@</NickName>\n",[dictionary valueForKey:@"NickName"]]];
     soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<DateOfBirth>%@</DateOfBirth>\n",[dictionary valueForKey:@"DateOfBirth"]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Gender>%@</Gender>\n",[dictionary valueForKey:@"Gender"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<SchoolName>%@</SchoolName>\n",[dictionary valueForKey:@"SchoolName"]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Passcode>%@</Passcode>\n",[dictionary valueForKey:@"Passcode"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<AutolockTime>%@</AutolockTime>\n",[dictionary valueForKey:@"AutolockTime"]]];
    
     soapMessage = [soapMessage stringByAppendingString:@"</UpdateChildProfile>\n</soap:Body>\n</soap:Envelope>\n"];
    
    
    NSLog(@"Soap Message %@",soapMessage);
    
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/UpdateChildProfile" forHTTPHeaderField:@"SOAPAction"];
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
