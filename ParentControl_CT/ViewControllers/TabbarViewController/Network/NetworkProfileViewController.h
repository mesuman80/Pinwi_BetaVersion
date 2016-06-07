//
//  NetworkProfileViewController.h
//  ParentControl_CT
//
//  Created by Sakshi on 03/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"
#import "StripView.h"


@interface NetworkProfileViewController : UIViewController<UrlConnectionDelegate,UITableViewDataSource,UITableViewDelegate>

@property TabBarViewController *tabBarCtrl;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) UILabel *parentName;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UIView *parentDetailView;
@property (nonatomic, strong) StripView *stripView;
@property NSInteger index;

-(void)networkButtonTapped:(UIButton*)sender;


@end
