//
//  ConnectionBaseClass.h
//  XmlParser
//
//  Created by Yogesh Gupta on 22/04/15.
//  Copyright (c) 2015 CoreSolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLReader.h"
@protocol UrlConnectionDelegate ;
@interface UrlConnection : NSObject<NSXMLParserDelegate>
{
    NSMutableData *myData;
    NSURLConnection *urlConnection;
    NSDictionary *servicesDictionary;
   
   
}
@property id<UrlConnectionDelegate>delegate;
@property NSIndexPath *indexPath;
@property NSString *serviceName;
@property (nonatomic , strong) NSMutableArray *calenderArray;


//@property NSString *serviceName;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property NSString *childId;
-(void)stopConnection;
-(void)openUrlWithRequest:(NSMutableURLRequest *)request;
-(void)showAlertMessage:(NSString *)title message:(NSString *)message;
-(NSDictionary *)getJsonWithXmlDictionary:(NSDictionary *)dictionary ResponseKey:(NSString *)responseKey resultKey:(NSString *)resultKey;
@end
@protocol UrlConnectionDelegate <NSObject>
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection;
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection;
@end