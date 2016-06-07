//
//  SupportView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "Sound.h"

@class ChildProfileObject;
@protocol TutorialProtocol <NSObject>

-(void)SkipTouched;

@end

@interface TutorialPlayView : UIViewController
@property id<TutorialProtocol>delegate;
@property BOOL isSoundPlaying;
@property int loadIndexVal;
@property NSArray *imgLoadArr;
@property NSString *tutorialName;
@property int statusCountIndex;
@property BOOL autoSkip;
@property ChildProfileObject *child;
@end
