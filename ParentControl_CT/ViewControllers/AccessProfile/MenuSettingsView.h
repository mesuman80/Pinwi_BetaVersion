//
//  MenuSettingsView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 01/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "RequestAddOnVersion.h"

@interface MenuSettingsView : UITableView<UITableViewDelegate, UITableViewDataSource,UrlConnectionDelegate>
-(id)initWithFrame:(CGRect)frame andViewCtrl:(UIViewController*)rootViewCtrl;

@property UIViewController *rootViewController;
@property NSString *parentClass;

@end
