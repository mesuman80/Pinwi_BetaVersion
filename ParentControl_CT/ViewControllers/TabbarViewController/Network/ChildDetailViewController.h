//
//  ChildDetailViewController.h
//  ParentControl_CT
//
//  Created by Sakshi on 07/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StripView.h"
#import "TabBarViewController.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "ShowActivityLoadingView.h"

@interface ChildDetailViewController : UIViewController

@property (nonatomic, strong)  StripView *stripView;
@property (nonatomic, strong)  StripView *stripView1;
@property (nonatomic, strong)  UIView *childDetailView;
//@property (nonatomic, strong)  UIView *exhilaratorView;
//@property (nonatomic, strong)  UIView *noExhilaratorView;
@property (nonatomic, strong)  NSMutableArray *childDetailArray;
@property (nonatomic, strong)  NSMutableArray *friendsChildDetailArray;
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
@property int ChildId;
@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) UILabel *childName;
@property (nonatomic, strong) UILabel *parentName;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *siblingLabel;
@property (nonatomic, strong) UILabel *familyConnectionLabel;
@property (nonatomic, strong) UIButton *statusButton;
@property (nonatomic, strong) NSMutableArray *exhiliratorDetailArray;
@property NSString *childName1;
@property CGRect frame;

-(void)arrowButtonTouched:(UIButton*)sender;

@end
