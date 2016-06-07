//
//  ProfileSetUpViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 2/25/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ImageUpload.h"
#import "AddPassCode.h"

#import "CustomToolBar.h"
#import "AllyProfileController.h"
#import "Constant.h"
#import "ParentProfileObject.h"

@interface ProfileSetUpViewController : UIViewController<UITextFieldDelegate,FBLoginViewDelegate,FBGraphUser,FBRequestConnectionDelegate,FBRequestDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,AddPassCodeDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property(strong, nonatomic) UIButton *radiobutton1;
@property(strong, nonatomic) UIButton *radiobutton2;
@property NSString *parentClassName;
@property ParentProfileObject *parentObject;

-(void)radioButtonSelected:(id)sender;

@end
