//
//  TimePicker.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelDoneToolBar.h"
#import "GetAutolockTime.h"
#import "PC_DataManager.h"

@protocol autolockProtocol <NSObject>

-(void)autoLock:(NSMutableDictionary*)autoDictData;

@end
@interface AutoLockPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate,ToolBarDelegate,UrlConnectionDelegate>
@property id<autolockProtocol>autoDelegate;
@property UITextField *textField;
@property NSMutableDictionary *autoDict;
-(void)pickerView:(NSString*)pickerType;
-(void)getAutolocktime;

@end
