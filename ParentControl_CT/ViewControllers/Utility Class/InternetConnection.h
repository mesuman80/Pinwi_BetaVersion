//
//  InternetConnection.h
//  Pin_Tel
//
//  Created by MVN-Mac2 on 04/06/14.
//  Copyright (c) 2014 mvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@protocol InternetConnectionDelegate <NSObject>
-(void)isInternetConnection:(BOOL)connection;

@end



@interface InternetConnection : NSObject
{
    @public BOOL isConnectionDown;
    
}

@property id<InternetConnectionDelegate>delegate;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property BOOL isInternetConnection;
+(InternetConnection *)sharedInstance;
-(void)removeObserver;
-(BOOL) connectionStatus;


@end
InternetConnection *connectionInstance;
