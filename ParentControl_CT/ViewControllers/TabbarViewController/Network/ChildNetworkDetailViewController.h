//
//  ChildNetworkDetailViewController.h
//  ParentControl_CT
//
//  Created by Sakshi on 08/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StripView.h"
#import "TabBarViewController.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "ShowActivityLoadingView.h"

@interface ChildNetworkDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)  UITableView *table;
@property (nonatomic, strong)  StripView *stripView;
@property (nonatomic, strong)  NSMutableArray *ChildConnectionDetailArray;
@property (nonatomic, weak)  TabBarViewController *tabBarCtrl;
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
@property (nonatomic, strong) UIView *childDetailView;
@property UIImageView *profileImage;
@property UILabel *parentName;
@property UIButton *statusButton;
@property UILabel *cityNameLabel;
@property int childId;
@property NSString *childName;
@property NSInteger numberOfConnections;
@property int loggedId;

@end
