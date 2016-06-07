//
//  WhatToDoDetailViewController.h
//  ParentControl_CT
//
//  Created by Sakshi on 07/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"
#import "RedLabelView.h"
#import "ShowActivityLoadingView.h"
#import "WhatToDo.h"
#import "WhatToDoTableViewCell.h"


@interface WhatToDoDetailViewController : UIViewController<UrlConnectionDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) WhatToDo *whatToDoController;
@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@property (nonatomic,weak) WhatToDo *rootController;
@property (nonatomic,weak) ChildProfileObject *childObject;
@property (nonatomic,strong) RedLabelView *label;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIImageView *noActivityImageView;
@property (nonatomic,strong) UILabel *noActivityLabel;
@property (nonatomic,strong) NSMutableArray *conncetionsData;
@property (nonatomic,strong) ShowActivityLoadingView *loaderView;
@property (nonatomic,strong) UIButton *wishlistButton;

@property NSString *
clusterName;
@property int yy;
@property CGFloat cellHeight;
@property CGFloat headerHeight;
@property NSMutableArray *searchResult;
@property NSString *nameToBeSearch;
@property (assign, nonatomic) NSInteger index;


-(id)init:(NSInteger)index;
-(void)childNameLabel;
-(void)loadData;
-(void)setSegmentControler;
-(void)selectedSegmentView:(UISegmentedControl *)paramSender;
-(void)addLoaderView;
-(void)removeLoaderView;
-(void)addWishlistButton;
-(void)wishlistButtonTouched:(UIButton*)sender;
-(void)getDataFromWebService:(NSInteger )pageIndex;
-(void)setUpForNoActivity:(NSString*)errorDecs;
-(void)removeNoActivitySetUp;

@end
