//
//  WhoIsDoingThisViewController.h
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

@interface WhoIsDoingThisViewController : UIViewController<UrlConnectionDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) ChildProfileObject *childObject;
@property (nonatomic,strong) RedLabelView *label;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *whoIsDoingThisData;
@property (nonatomic,strong) HeaderView *headerView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property TabBarViewController *tabBarCtrl;
@property (nonatomic,strong) ShowActivityLoadingView *loaderView;
@property int yy;
@property int yCord, xCord;
@property int scrollXX;
@property int initialY;
@property int reduceYY;
@property NSString *childName;
@property CGFloat cellHeight;
@property NSString *stripViewTitle;
@property NSInteger activityId;

-(void)childNameLabel;
-(void)loadData;
-(void)addLoaderView;
-(void)removeLoaderView;
-(void)drawUiWithHead;
-(void)drawHeaderView;
-(void)addStripView:(NSString*)title;

@end
