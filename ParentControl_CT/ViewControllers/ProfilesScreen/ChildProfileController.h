//
//  ChildProfileController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 25/02/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "AddPassCode.h"
#import "ImageUpload.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UrlConnection.h"
#import "CreateChildProfile.h"
#import "GetAutolockTime.h"
#import "Constant.h"
#import "UpdateChildProfile.h"

@interface ChildProfileController : UIViewController<UITextFieldDelegate,PhotoCaptureDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UrlConnectionDelegate,UINavigationControllerDelegate>


@property(strong, nonatomic) UIButton *radiobutton1;
@property(strong, nonatomic) UIButton *radiobutton2;

-(void)radioButtonSelected:(id)sender;

@property NSString *parentClassName;
@property int *childIndex;
@property NSString *rootViewController;
@property BOOL isComingFromNetwork;

@end
