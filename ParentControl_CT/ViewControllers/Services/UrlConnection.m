//
//  ConnectionBaseClass.m
//  XmlParser
//
//  Created by Yogesh Gupta on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//

#import "UrlConnection.h"
#import <UIKit/UIKit.h>
#import "InternetConnection.h"
#import "Constant.h"

@implementation UrlConnection
-(id)init
{
    if(self = [super init])
    {
        myData = [[NSMutableData alloc]init];
       
        
        return self;
    }
    return nil;
}
-(void)openUrlWithRequest:(NSMutableURLRequest *)request
{
    //if([[InternetConnection sharedInstance]connectionStatus])
    //{
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [request setTimeoutInterval:40.0f];
        urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
   // }
//    else
//    {
//        [self showAlertMessage:@"Alert" message:@"Please check your internet connection"];
//    }
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [myData setLength: 0];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger code = [httpResponse statusCode];
    NSLog(@"Description :%@",response);//[NSHTTPURLResponse localizedStringForStatusCode:code]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if(code!=200)[self showAlertMessage:@"Alert" message:[NSHTTPURLResponse localizedStringForStatusCode:code]];
    else NSLog(@"Success");
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [myData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([self.serviceName isEqualToString:@"getAfterSchoolActivitiesByChildID"])
    {
        
    }
    [self showAlertMessage:@"Alert" message:error.localizedDescription];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{


    NSString *theXML = [[NSString alloc] initWithBytes: [myData mutableBytes] length:[myData length] encoding:NSUTF8StringEncoding];
    self.xmlParser = [[NSXMLParser alloc] initWithData: myData];
    [self.xmlParser setDelegate: self];
    [self.xmlParser setShouldResolveExternalEntities: YES];
    [self.xmlParser parse];
    NSError *parseError = nil;
    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:theXML error:&parseError];
    NSDictionary *soapEnvelopeDictionary = [xmlDictionary valueForKey:@"soap:Envelope"];
    NSDictionary *soapBody = [soapEnvelopeDictionary valueForKey:@"soap:Body"];
    if(self.delegate)[self.delegate connectionDidFinishLoadingData:soapBody withService:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    
    
}

-(void)showAlertMessage:(NSString *)title message:(NSString *)message
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(self.delegate)[self.delegate connectionFailedWithError:message withService:self];
    
    [urlConnection cancel];
    urlConnection = nil;
    
//    if([message isEqualToString:@"The request timed out."])
//    {
//        return;
//    }
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
   
    NSLog(@"error in service %@",self.serviceName);
}

-(NSDictionary *)getJsonWithXmlDictionary:(NSDictionary *)dictionary ResponseKey:(NSString *)responseKey resultKey:(NSString *)resultKey
{
    //serviceName=responseKey;
    NSDictionary *getCityListResponse = [dictionary valueForKey:responseKey];
    NSDictionary *getCityResult =  [getCityListResponse valueForKey:resultKey];
    NSString *textStr= [getCityResult valueForKey:@"text"];
    NSArray *textStrArray = [textStr componentsSeparatedByString:@"["];
    NSString *errorCode  = [textStrArray objectAtIndex:1];
   
    if ([errorCode length] > 0)
    {
//        if([_serviceName isEqualToString:PinWiAddHolidaysByChildID]){
//             errorCode = [errorCode substringToIndex:[errorCode length] - 3];
//        }
//        else{
            errorCode = [errorCode substringToIndex:[errorCode length] - 1];
        //}
     
    }
   
    NSData *data = [errorCode dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *errorCodeDict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    errorCode = [errorCodeDict valueForKey:@"ErrorCode"];
    if([errorCode isEqualToString:@"0"])
    {
       // NSString *errorDesc = [errorCodeDict valueForKey:@"ErrorDesc"];
//        if(errorDesc)
//        {
//            
//        }
//        else
//        {
            NSString *resultString = [textStrArray lastObject];
            if ([resultString length] > 0)resultString = [NSString stringWithFormat:@"[%@",resultString];
            NSData *resultData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *resultError = nil;
            NSDictionary *resultDictionary  = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingAllowFragments error:&resultError];
            NSLog(@"SUCCESS in service %@",self.serviceName);
             return resultDictionary;

        //}
        
       // return nil;
    }
    else{
        
         NSString *description=[errorCodeDict valueForKey:@"ErrorDesc"];
         if(!description)
         {
            description = @"Oops Something Went Wrong!";
             return nil;
         }
        if([responseKey isEqualToString:@"CheckConfirmationCodeByParentIDResponse"])
        {
            [self showAlertMessage:@"Confirmation" message:description];
            return nil;
        }
        [self showAlertMessage:@"Alert" message:description];
         return nil;
    }
    return nil;
}
-(void)stopConnection
{
    [urlConnection cancel];
}

@end
