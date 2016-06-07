//
//  DashBoardImageView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "DashBoardView.h" 


@protocol PointsCalProtocol <NSObject>

-(void)rateAgain;

@end

@interface DashBoardImageView : UIView
@property id<PointsCalProtocol>delegate;
- (id)initWithFrame:(CGRect)frame andDate:(NSString *)dateString andStatus:(int)statusIndex;

@end
