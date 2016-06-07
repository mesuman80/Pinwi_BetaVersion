//
//  SubscribeButtonView.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SubscribeButtonViewDelegate ;
@interface SubscribeButtonView : UIView
-(void)drawUI:(NSDictionary *)dataDictionary;
@property id<SubscribeButtonViewDelegate>delegate;
@end
@protocol SubscribeButtonViewDelegate <NSObject>
-(void)touchAtSubscribe:(SubscribeButtonView *)subscribeButton;
@end