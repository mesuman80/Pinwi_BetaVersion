//
//  ChildEarningPendingPoints.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 26/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@protocol ChildEarningPendingPointsDelegate ;
@interface ChildEarningPendingPoints : UIView
-(void)drawUIWithData:(NSString *)points withString:(NSString *)pointType andTextLabel:(NSString*)textString;
@property id<ChildEarningPendingPointsDelegate>delegate;
@end
@protocol ChildEarningPendingPointsDelegate <NSObject>
-(void)touchAtCell:(ChildEarningPendingPoints *)audioUi;
@end