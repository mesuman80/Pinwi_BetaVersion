//
//  CuetomToolBar.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 11/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomToolBarDelegate;
@interface CustomToolBar : UIToolbar
-(void)addToolBar;
@property UITextField *textField;
@property id <CustomToolBarDelegate> customDelgate;
@end
@protocol CustomToolBarDelegate <NSObject>
-(void)touchAtCancelButton:(CustomToolBar *)cancelDoneToolBar;
-(void)touchAtDoneButton:(CustomToolBar *)cancelDoneToolBar;

@end

