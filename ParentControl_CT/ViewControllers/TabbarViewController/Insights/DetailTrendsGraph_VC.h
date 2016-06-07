//
//  ViewController.h
//  LineGraph
//
//  Created by Yogesh Gupta on 03/09/15.
//  Copyright (c) 2015 Yogesh Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNLineChart.h"

@class ChildProfileObject;
@class TabBarViewController;

@interface DetailTrendsGraph_VC : UIViewController<PNChartDelegate>
@property ChildProfileObject *childObj;
@property PNLineChart * lineChart;
@property NSDictionary *dataDict;
@property TabBarViewController *tabBarCtrl;
@end

