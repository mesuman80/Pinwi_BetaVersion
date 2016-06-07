//
//  LogoutView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 12/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeaturedProtocol <NSObject>

-(void)logoutClicked;
-(void)mainMenuClicked;
-(void)cancelClicked;

@end


@interface LogoutView : UIView<UIActionSheetDelegate>
@property id<FeaturedProtocol>logoutDelegate;

@end
