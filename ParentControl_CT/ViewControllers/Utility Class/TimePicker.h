//
//  TimePicker.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelDoneToolBar.h"


@protocol PickerProtocol <NSObject>

-(void)doneTouched:(NSString*)value withTag:(int)tagVal;
-(void)cancelTouched;

@end

@interface TimePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate,ToolBarDelegate>

@property id<PickerProtocol>pickerDelegate;
@property UITextField *textField;
@property NSMutableDictionary *autoDict;
-(void)pickerView:(NSString*)pickerType;

@end
