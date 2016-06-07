//
//  StripView.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 10/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StripViewInfoprotocol;

@interface StripView : UIView
@property id<StripViewInfoprotocol>stripInfoDelegate;
@property UILabel *StripLabel;
@property UIImageView *infoImage;
-(void)drawStrip:(NSString *)title color:(UIColor *)color;
-(void)drawInfoIcon;
@end

@protocol StripViewInfoprotocol <NSObject>

-(void)stripInfoBtnTouch:(StripView*)stripView;

@end