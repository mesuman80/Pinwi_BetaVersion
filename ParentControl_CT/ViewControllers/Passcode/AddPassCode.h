//
//  AddPassCode.h
//  Pin_Tel
//
//  Created by Veenus Chhabra on 06/11/14.
//  Copyright (c) 2014 mvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTHKeychainUtils.h"
#import "PC_DataManager.h"
#import "PPPinPadViewController.h"
#import "RecoverPasscode.h"

@protocol AddPassCodeDelegate <NSObject>
-(void)passCodeSuccess;
-(void)passCodeSetUp:(NSString*)pscode;
-(void)cancelBtnTouched;
-(void)forgotPasscode;



@end


@interface AddPassCode : UIViewController<UITextFieldDelegate,NSURLConnectionDelegate,UrlConnectionDelegate>

@property id<AddPassCodeDelegate>passcodeDelegate;

-(id)initwithEnablePswd:(BOOL)enablePswd changePswd:(BOOL)chngpswd deletePswd:(BOOL)delPswd key:(NSString*)key;

@property (nonatomic, strong) UITextField *passcodeTextField;
@property (nonatomic, strong) UITextField *firstDigitTextField;
@property (nonatomic, strong) UITextField *secondDigitTextField;
@property (nonatomic, strong) UITextField *thirdDigitTextField;
@property (nonatomic, strong) UITextField *fourthDigitTextField;

@property UIView *animatingView;
@property NSString *parentClass;

@end
BOOL doesPassWdExits;
BOOL enterNewPsWd;
BOOL changePswd;
BOOL enterMailId;
BOOL removePsWd;
BOOL forgotPswdBool;
