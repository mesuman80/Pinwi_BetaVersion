//
//  ImageUpload.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 17/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


@protocol PhotoCaptureDelegate<NSObject>
@optional
-(void)doneButton:(NSData *)imageData;
-(void)cancel;
-(void)cancelButton:(UIImagePickerController *)pickerController;

@end

@interface ImageUpload: UIViewController<UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,retain)id<PhotoCaptureDelegate>delegate;

@end
