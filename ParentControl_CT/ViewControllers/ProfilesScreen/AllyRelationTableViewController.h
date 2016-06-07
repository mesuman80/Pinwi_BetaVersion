//
//  CityTableViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 28/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "UrlConnection.h"

@protocol  AllyListDelegate<NSObject>
-(void)selectedRel:(NSString*)relSelected andId:(NSString*)relIdSelected;
@end

@interface AllyRelationTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,UrlConnectionDelegate>


@property id<AllyListDelegate>allyListDelegate;
@end
