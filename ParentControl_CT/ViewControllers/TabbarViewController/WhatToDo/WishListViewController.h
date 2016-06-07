//
//  WishListViewController.h
//  ParentControl_CT
//
//  Created by Sakshi on 15/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"
#import "RedLabelView.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"

@interface WishListViewController : UIViewController<UrlConnectionDelegate,UITableViewDataSource,UITableViewDelegate,UIPageViewControllerDataSource>

@property (nonatomic,weak) ChildProfileObject *childObject;
@property (nonatomic,strong) RedLabelView *label;
@property (nonatomic,weak) UITableView *table;
@property (nonatomic,weak) UISearchController *connectionSearchController;
@property (nonatomic,weak) NSString *filterString;
@property (nonatomic,strong) UISearchBar *searchBar;
@property NSMutableArray *searchResult;
@property NSString *nameToBeSearch;
@property (nonatomic,strong) HeaderView *headerView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton *continueButton;
@property TabBarViewController *tabBarCtrl;
@property (nonatomic,strong) NSMutableArray *whatToDoObjectArray;
@property (strong, nonatomic) UIPageViewController *pageController;
@property int yy;
@property int yCord, xCord;
@property int scrollXX;
@property int initialY;
@property int reduceYY;
@property NSMutableArray *ChildNameArray;
@property NSString *childName;
@property NSInteger childID;
@property NSString  *activityName;
@property NSInteger activityId;


-(void)childNameLabel;
-(void)loadData;
-(void)addLoaderView;
-(void)removeLoaderView;
-(void)drawUiWithHead;
-(void)drawHeaderView;

@end
