//
//  NetworkDetailView.h
//  ParentControl_CT
//
//  Created by Sakshi on 24/02/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"
#import "NetworkViewController.h"
#import "GetFriendsListByLoggedID.h"
#import "NetworkTableViewCell.h"

@interface NetworkDetailView : UIView<UrlConnectionDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate, removeFriendDelegate>

@property NetworkViewController *networkViewController;

-(id)initWithRootController:(NetworkViewController *)rootViewController andChildData:(ChildProfileObject*)childObj;
-(void)loadData;
-(void)selectedSegmentView:(UISegmentedControl *)paramSender;
-(void)inviteFriendsButtonTouched: (UIButton*)sender;
-(void)profileIconButtonTouched:(UIButton*)sender;

@end
