//
//  ClusterDetailViewController.h
//  ParentControl_CT
//
//  Created by Sakshi on 18/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"
#import "RedLabelView.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"

@interface ClusterDetailViewController : UIViewController<UrlConnectionDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) ChildProfileObject *childObject;
@property (nonatomic,strong) RedLabelView *label;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,weak) UISearchController *connectionSearchController;
@property (nonatomic,weak) NSString *filterString;
@property (nonatomic,strong) NSMutableArray *activitiListData;
@property (nonatomic,strong) UISearchBar *searchBar;
@property NSMutableArray *searchResult;
@property NSString *nameToBeSearch;
@property (nonatomic,strong) HeaderView *headerView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property TabBarViewController *tabBarCtrl;
@property (nonatomic,strong) ShowActivityLoadingView *loaderView;
//@property (strong, nonatomic) UIPageViewController *pageController;
@property int yy;
@property int yCord, xCord;
@property int scrollXX;
@property int initialY;
@property int reduceYY;
@property NSMutableArray *ChildNameArray;
@property NSString *childName;
@property NSInteger childID;
@property NSInteger clusterId;
@property CGFloat cellHeight;
@property NSString *stripViewTitle;
@property NSString *clusterDetails;
@property NSInteger segmentControlIndex;
@property NSInteger activityID;
@property (nonatomic,strong) NSString *activityName;


-(void)childNameLabel;
-(void)loadData;
-(void)addLoaderView;
-(void)removeLoaderView;
-(void)drawUiWithHead;
-(void)drawHeaderView;
-(void)addStripView:(NSString*)title clusterDetail:(NSString*)clusterDetail;

@end
