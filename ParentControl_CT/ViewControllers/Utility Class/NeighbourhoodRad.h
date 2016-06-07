//
//  TimePicker.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelDoneToolBar.h"
#import "GetNeighbourhoodRadius.h"
#import "PC_DataManager.h"

@protocol neighbourProtocol <NSObject>

-(void)neighbourRad:(NSMutableDictionary*)neighbourDictData;

@end
@interface NeighbourhoodRad : UIView<UIPickerViewDataSource,UIPickerViewDelegate,ToolBarDelegate,UrlConnectionDelegate>
@property id<neighbourProtocol>neibourRadDelegate;
@property UITextField *textField;
@property NSMutableDictionary *autoDict;
-(void)pickerView:(NSString*)pickerType;
-(void)getAutolocktime;

@end
