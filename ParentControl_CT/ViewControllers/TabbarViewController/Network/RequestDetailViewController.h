//
//  RequestDetailViewController.h
//  ParentControl_CT
//
//  Created by Sakshi on 10/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StripView.h"
#import "TabBarViewController.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "ShowActivityLoadingView.h"

@interface RequestDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak)  NSString *FriendID;
@property (nonatomic, weak)  NSString *FriendName;
@property (nonatomic, strong)  UITableView *table;
@property (nonatomic, strong)  StripView *stripView;
@property (nonatomic, strong)  NSMutableArray *friendsDetailArray;
@property (nonatomic, strong)  NSMutableArray *friendsChildDetailArray;
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
@property UIImage *cellImage;
@property NSInteger friendshipStatus;


@end
