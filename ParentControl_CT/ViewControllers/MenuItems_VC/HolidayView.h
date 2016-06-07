//
//  HolidayView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 09/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildProfileObject.h"

@class ShowActivityLoadingView;



@protocol HolidayViewDelegate ;
@interface HolidayView : UIView
-(void)drawUI:(CGFloat)originy;
-(void)viewWillAppear;
@property ShowActivityLoadingView *showActivityLoadingView;
@property UIButton *selectButton ;
@property UIButton *undoButton ;
@property (nonatomic, weak) ChildProfileObject *childProfileObject;
@property (nonatomic, strong) id<HolidayViewDelegate>delegate;
@end


@protocol HolidayViewDelegate <NSObject>
-(void)goTOController:(BOOL)isTouchEnable description:(NSString *)description;
@end