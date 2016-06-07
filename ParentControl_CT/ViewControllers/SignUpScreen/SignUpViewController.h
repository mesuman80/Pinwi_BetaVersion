//
//  ViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 2/23/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "TTTAttributedLabel.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "FaceBookFriendsViewController.h"
#import <GooglePlus/GooglePlus.h>
#import "ParentViewProfile.h"
#import "TabBarViewController.h"
#import "UrlConnection.h"
#import "AccessProfileViewController.h"
#import "WelcomeScreenViewController.h"
#import "ConfirmationProfileViewController.h"
#import "CheckDeviceIDExists.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate,TTTAttributedLabelDelegate,GPPSignInDelegate, UrlConnectionDelegate, UIAlertViewDelegate>
{
UIButton *checkbox;
}
-(void)checkboxSelected:(id)sender;
-(void)isDeviceTokenExist:(BOOL)isExist;
-(void)checkDeviceToken:(NSString *)string;
@end