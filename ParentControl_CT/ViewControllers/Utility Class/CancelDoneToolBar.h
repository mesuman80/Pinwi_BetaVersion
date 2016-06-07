//
//  CancelDoneToolBar.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 08/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolBarDelegate;
@interface CancelDoneToolBar : UIView
-(id)initWithFrame:(CGRect)frame andTextField:(UITextField*)txtfld;
-(void)drawButtons;
@property id <ToolBarDelegate> delegate;
@property UIButton *cancelButton, *doneButton;
@end
@protocol ToolBarDelegate <NSObject>
-(void)touchAtCancelButton:(CancelDoneToolBar *)cancelDoneToolBar;
-(void)touchAtDoneButton:(CancelDoneToolBar *)cancelDoneToolBar;
@end