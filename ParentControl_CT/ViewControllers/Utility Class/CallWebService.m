//
//  CallWebService.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 27/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CallWebService.h"

@implementation CallWebService{
    NSURLConnection *urlConnection;
    NSData *myData;
}



-(void)postData:(NSDictionary *)dictionary url:(NSString *)url
{
    // NSString *postStr=[NSString stringWithFormat:@"%@",@""];
    NSLog(@"value of Post Str=%@",url);
    myData = [[NSMutableData alloc] initWithLength:0];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"Value of Json Dictionary=%@",dictionary);
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    if(jsonData)
    {
        NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        urlConnection=connection;
        if(!connection)
        {
            NSLog(@"Connection Failed");
        }
        else
        {
            NSLog(@"connection Success");
        }
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"the response is: \n %@",response);
    //[connection cancel];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)imageData
{
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"THE connection error is: %@",error);
    
    [self.webServiceDelegate connectionError:@"Please Check the Internet Connection."];
//    UIAlertView *reportAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please Check the Internet Connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [reportAlert show];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
//    UIAlertView *reportAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Thanks for your report. It will be reviewed. Your help to keep Pintel safe for all members is appreciated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [reportAlert show];
    [self.webServiceDelegate connectionCompleted];
    
    NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"Value of Search Dictionary=%@",dictionary);
}



@end
