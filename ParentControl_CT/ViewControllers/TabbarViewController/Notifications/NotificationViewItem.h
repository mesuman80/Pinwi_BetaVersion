//
//  NotificationViewItem.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 25/09/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChildProfileObject;
@protocol NotificationProtocol;

@interface NotificationViewItem : UIView
-(void)drawUI:(NSDictionary*)dict;
@property id<NotificationProtocol>notificationDelegate;
@property NSDictionary *dataDict;
@property ChildProfileObject *childObject;
@end

@protocol NotificationProtocol <NSObject>

-(void)notificationTouch:(NotificationViewItem*)notification;

@end