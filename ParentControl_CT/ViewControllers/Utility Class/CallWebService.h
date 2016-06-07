//
//  CallWebService.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 27/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CallWebSreviceDelegate <NSObject>


-(void)connectionError:(NSString *)string;
-(void)connectionCompleted;

@end




@interface CallWebService : NSObject
@property id<CallWebSreviceDelegate>webServiceDelegate;

@end
