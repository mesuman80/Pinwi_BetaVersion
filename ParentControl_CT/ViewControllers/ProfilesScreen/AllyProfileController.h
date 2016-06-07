//
//  AllyProfileController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 04/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ImageUpload.h"
#import "CreateAllyProfile.h"
#import "CustomToolBar.h"
#import "AccessProfileViewController.h"
#import "UpdateAllyProfile.h"
#import "Constant.h"

@interface AllyProfileController : UIViewController<PhotoCaptureDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UrlConnectionDelegate,CustomToolBarDelegate,UITextFieldDelegate>

@property NSString *parentClassName;
@property int allyIndex;


@end
