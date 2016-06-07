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

@protocol CityListDelegate<NSObject>
-(void)selectedCity:(NSString*)citySelected andId:(NSString*)cityIdSelected;
@end

@interface CityTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,UrlConnectionDelegate>


@property id<CityListDelegate>cityListDelegate;
@end
