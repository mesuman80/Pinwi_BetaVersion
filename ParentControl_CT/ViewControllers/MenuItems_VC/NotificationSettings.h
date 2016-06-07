//
//  NotificationSettings.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 10/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetListOfAllys.h"


@interface NotificationSettings :  UIViewController<UITableViewDataSource,UITableViewDelegate,UrlConnectionDelegate,UISearchControllerDelegate,UISearchBarDelegate>

@property UITableView *notificationTable;


@end
