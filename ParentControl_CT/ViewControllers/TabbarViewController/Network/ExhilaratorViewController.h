//
//  ExhilaratorViewController.h
//  ParentControl_CT
//
//  Created by Sakshi on 07/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChildProfileObject;
@class TabBarViewController;
#import "TabBarViewController.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "StripView.h"
#import "ShowActivityLoadingView.h"

@interface ExhilaratorViewController : UIViewController

@property (nonatomic, strong)  StripView *stripView;
@property (nonatomic, strong)  NSMutableArray *childDetailArray;
@property (nonatomic, weak)    TabBarViewController *tabBarCtrl;
@property (nonatomic, strong)  RedLabelView *label;
@property (nonatomic, strong)  HeaderView *headerView;
@property (nonatomic, strong)  UIScrollView *scrollView;
@property int yy;
@property int yCord, xCord;
@property UIPageControl *pageControl;
@property int pageControlHeight;
@property (nonatomic, strong)  UIView *loadElementView;
@property (nonatomic, strong)  ShowActivityLoadingView *loaderView;
@property CGFloat cellHeight;
@property CGFloat headerHeight;
@property NSDictionary *dataDictionary;
@property int tagVal;
@property NSString *childName;


@end
