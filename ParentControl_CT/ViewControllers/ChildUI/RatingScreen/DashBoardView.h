//
//  DashBoardView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 30/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "Sound.h"

@protocol DashBoardProtocol;

@interface DashBoardView : UIView<UrlConnectionDelegate>
@property id<DashBoardProtocol>dashBoardDelegate;
@property NSDictionary *activityDashBoardDict;
@property NSString *dayString;
@property Sound *soundObj;
-(id)initWithFrame:(CGRect)frame andDict:(NSDictionary *)dictionary WithDay:(NSString*)day;

@end

@protocol DashBoardProtocol <NSObject>
-(void)RateAgainCellTouched:(DashBoardView*)dashBoard;
-(void)callDelegate:(id)sender;
@end