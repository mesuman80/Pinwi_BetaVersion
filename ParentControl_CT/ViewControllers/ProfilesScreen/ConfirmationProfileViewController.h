//
//  ConfirmationProfileViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 09/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "SendConfirmationCodeToMail.h"
#import "CheckConfirmationCodeByParentID.h"
#import "OverLayView.h"
#import "ChildProfileController.h"

@interface ConfirmationProfileViewController : UIViewController<UITextFieldDelegate,UrlConnectionDelegate,SendConfirmationCodeDelegate,OverLayProtocol,UIAlertViewDelegate>
{
    UIButton *checkbox;
}





@end
