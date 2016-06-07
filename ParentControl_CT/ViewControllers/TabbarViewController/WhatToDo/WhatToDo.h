//
//  NetworkViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBarViewController;

@interface WhatToDo : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property TabBarViewController *tabBarCtrl;
@property (nonatomic,strong) NSMutableArray *whatToDoObjectArray;
@property (strong, nonatomic) UIPageViewController *pageController;
@end
