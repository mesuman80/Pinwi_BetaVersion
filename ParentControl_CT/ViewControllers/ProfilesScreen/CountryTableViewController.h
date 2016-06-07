//
//  CountryTableViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 28/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "UrlConnection.h"


@protocol CountryListDelegate<NSObject>
-(void)selectedCountry:(NSString*)countrySelected andId:(NSString*)countryIdSelected;

@end
@interface CountryTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UrlConnectionDelegate>

@property id<CountryListDelegate>countryListDelegate;

@end
