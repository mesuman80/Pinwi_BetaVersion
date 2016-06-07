//
//  InternetConnection.m
//  Pin_Tel
//
//  Created by MVN-Mac2 on 04/06/14.
//  Copyright (c) 2014 mvn. All rights reserved.
//

#import "InternetConnection.h"
#import "Reachability.h"

@implementation InternetConnection

{
    BOOL isConnected;;
}
@synthesize delegate;



+(InternetConnection *)sharedInstance
{
    if(connectionInstance==nil)
    {
        connectionInstance=[[InternetConnection alloc]init];
    }
    return connectionInstance;
}

-(id)init
{
    if(self=[super init])
    {
        isConnected= NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        NSString *remoteHostName = @"www.apple.com";
        self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [self.hostReachability startNotifier];
        
        
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        
        
        self.wifiReachability = [Reachability reachabilityForLocalWiFi];
        [self.wifiReachability startNotifier];

    }
    return self;
}

-(void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
  	if (reachability == self.internetReachability)
	{
		[self checkConnection:reachability];
	}
    
	if (reachability == self.wifiReachability)
	{
		[self checkConnection:reachability];
	}
}
-(void)checkConnection:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL netAvailable = [reachability connectionRequired];
    switch (netStatus)
    {
        case NotReachable:
        {
            netAvailable = NO;
            break;
        }
            
        case ReachableViaWWAN:
        {
            netAvailable= YES;
            break;
        }
        case ReachableViaWiFi:
        {
            netAvailable=YES;
            break;
        }
    }
    
    if (netAvailable)
    {
       isConnected=YES;
    }
    else
    {
       isConnected=NO;
    }
    [self sendStatus:isConnected];
}

-(BOOL) connectionStatus
{
    return  isConnected;
}

-(void)sendStatus:(BOOL)isConnected1
{
    self.isInternetConnection = isConnected1;
    if(delegate)
    {
        [delegate isInternetConnection:isConnected1];
    }
}
-(void)removeObserver
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)dealloc
{
    [self removeObserver];
}



@end
