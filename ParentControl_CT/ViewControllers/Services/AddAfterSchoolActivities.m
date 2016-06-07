//
//  LoginService.m
//  XmlParser
//
//  Created by Veenus Chhabra on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//
#import "Constant.h"
#import "AddAfterSchoolActivities.h"

@implementation AddAfterSchoolActivities

-(void)initService:(NSDictionary *)dictionary
{
    
    
    
    NSString *soapMessage =[NSString stringWithFormat:
                            @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body>\n"
                            "<AddAfterSchoolActivities xmlns=\"http://tempuri.org/\">\n" ];
                            
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wsid>%@</wsid>\n",PinWiWsID]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<wspwd>%@</wspwd>\n",@"appconnect@$2015"]];

    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ActivityID>%@</ActivityID>\n",
                                                        [ NSString stringWithFormat:@"%@", [dictionary valueForKey:@"ActivityID"] ]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ChildID>%@</ChildID>\n",
                                                        [ NSString stringWithFormat:@"%@", [dictionary valueForKey:@"ChildID"] ]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Remarks>%@</Remarks>\n",
                                                        [ NSString stringWithFormat:@"%@", [dictionary valueForKey:@"Remarks"] ]]];

    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ExamDate>%@</ExamDate>\n",[dictionary valueForKey:@"ExamDate"]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<StartDate>%@</StartDate>\n",[dictionary valueForKey:@"StartDate"]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<StartTime>%@</StartTime>\n",[dictionary valueForKey:@"StartTime"]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<EndTime>%@</EndTime>\n",[dictionary valueForKey:@"EndTime"]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Enddate>%@</Enddate>\n",
                                                        [ NSString stringWithFormat:@"%@", [dictionary valueForKey:@"Enddate"] ]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ActivityDays>%@</ActivityDays>\n",
                                                        [ NSString stringWithFormat:@"%@", [dictionary valueForKey:@"ActivityDays"] ]]];
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<IsSpecial>%@</IsSpecial>\n",
                                                        [ NSString stringWithFormat:@"%@", [dictionary valueForKey:@"IsSpecial"] ]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<IsPrivate>%@</IsPrivate>\n",[dictionary valueForKey:@"IsPrivate"]]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<SpecialDate>%@</SpecialDate>\n",[dictionary valueForKey:@"SpecialDate"]]];
    
     soapMessage = [soapMessage stringByAppendingString:@"</AddAfterSchoolActivities>\n</soap:Body>\n</soap:Envelope>\n"];
    

    
    NSLog(@"Soap Message %@",soapMessage);
    
    
    NSURL *url = [NSURL URLWithString:PinWiWebServiceUrlScheme];
    NSMutableURLRequest *soapRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [soapRequest addValue: @"beta.convergenttec.com" forHTTPHeaderField:@"HOST"];
    [soapRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soapRequest addValue: @"http://tempuri.org/AddAfterSchoolActivities" forHTTPHeaderField:@"SOAPAction"];
    [soapRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [soapRequest setHTTPMethod:@"POST"];
    [soapRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [self openUrlWithRequest:soapRequest];
}



-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"result given: %@",dictionary);
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
    
    
}


@end
