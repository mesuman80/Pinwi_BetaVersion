//
//  WhatToDoDetailViewController.m
//  ParentControl_CT
//
//  Created by Sakshi on 07/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "WhatToDoDetailViewController.h"
#import "GetListOfClustersOnRecommendedByChildID.h"
#import "GetListOfClustersOnNetworkByChildID.h"
#import "GetListOfClustersOnExploreByChildID.h"
#import "ClusterDetailViewController.h"
#import "WishListViewController.h"

@interface WhatToDoDetailViewController ()

@end

@implementation WhatToDoDetailViewController
{
    NSInteger pageIndex;
    NSInteger lastIndex;
    NSInteger totalCount;
    NSMutableArray *totalArray;
    UILabel *noSearchResultLabel;
    BOOL isScrolling;
    UIView *headingView;
}

@synthesize whatToDoController,segmentedControl,rootController,headerHeight;
@synthesize childObject,label,table,noActivityImageView;
@synthesize noActivityLabel,conncetionsData,loaderView,wishlistButton;
@synthesize yy,cellHeight,searchResult,nameToBeSearch,clusterName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PC_DataManager sharedManager]getWidthHeight];
    conncetionsData = [[NSMutableArray alloc] init];
    totalArray = [[NSMutableArray alloc]init];
    
    childObject = [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:self.index];
//    for(ChildProfileObject *obj in [PC_DataManager sharedManager].parentObjectInstance.childrenProfiles) {
//        NSLog(@"object Name =%@",obj.nick_Name);
//    }
   // NSLog(@"Child Profile  =%@",[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles);
    [self childNameLabel];
    [self setSegmentControler];
    [self addWishlistButton];
  //  [self drawTableHeader];
    
    if (screenWidth>700) {
        cellHeight  =  120;
        headerHeight = 100;
    }
    else{
        if (screenWidth>320) {
            cellHeight = 80;
            headerHeight = 80;
        }
        else{
        cellHeight = 60;
        headerHeight = 100;
        }
    }
    [self.view setBackgroundColor:appBackgroundColor];
    
    // Do any additional setup after loading the view.
}

-(id)init:(NSInteger)index
{
    if(self =[super init])
    {
      return self;
    }
   
    return nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     pageIndex = 0;
    [totalArray removeAllObjects];
    totalCount = 0;
    isScrolling = NO;
     [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self loadData];
    
}

-(void)loadData
{
   
    [self getDataFromWebService];
}

#pragma mark child
-(void)childNameLabel
{
    if(!label)
    {
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:childObject.nick_Name];
            label.center=CGPointMake(screenWidth/2,20);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:childObject.nick_Name];
            label.center=CGPointMake(screenWidth/2,15);
        }
        
        [self.view addSubview:label];
        yy+=label.frame.origin.y+label.frame.size.height+20;
    }
}

-(void)drawTableHeader
{
    UILabel *headingLabel = [[UILabel alloc] init];
   
    
    headingLabel.textAlignment = NSTextAlignmentLeft;
   
    if (segmentedControl.selectedSegmentIndex == 0) {
        headingLabel.text = @"Nurture interests that exhilarate this child with these clusters of activities.";
    }
    if (segmentedControl.selectedSegmentIndex == 1) {
        headingLabel.text = @"View clusters of activities popular amongst children in this child’s network.";
    }
    if (segmentedControl.selectedSegmentIndex == 2) {
        headingLabel.text = @"Help this child explore new interests with these clusters of activities.";
    }
     [headingLabel setFont:[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor]];

   headingLabel.numberOfLines = 0;
    headingView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidthFactor*10,segmentedControl.frame.origin.y+segmentedControl.frame.size.height+10, screenWidth - 20*ScreenWidthFactor , 50*ScreenHeightFactor)];
    headingView.center = CGPointMake(screenWidth/2, headingView.center.y);
    headingView.backgroundColor = activityHeading1Code;

    
    if (screenWidth>320) {
        headingLabel.frame = CGRectMake(5*ScreenWidthFactor, 1, headingView.frame.size.width - 12*ScreenWidthFactor, headingView.frame.size.height );
        headingLabel.center = CGPointMake(headingLabel.center.x, headingLabel.center.y);
    }
    else{
        headingLabel.frame = CGRectMake(5*ScreenWidthFactor, 1, headingView.frame.size.width -12*ScreenWidthFactor , headingView.frame.size.height );
        headingLabel.center = CGPointMake(headingLabel.center.x, headingLabel.center.y);
   }
    //[headingLabel setLayoutMargins:UIEdgeInsetsMake(5, 0, 5, 0)];
       headingLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:headingView];
    [headingView addSubview:headingLabel];
   
    
 //   yy += headingView.frame.size.height +15*ScreenHeightFactor;
    

}

-(void)setSegmentControler{
    
    if(!segmentedControl)
    {
        //  [searchResult removeAllObjects];
        NSArray *itemArray = [NSArray arrayWithObjects: @"Recommended",@"Network",@"Explore", nil];
        segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        if (screenWidth>700) {
            segmentedControl.frame = CGRectMake(10*ScreenWidthFactor,yy+ScreenHeightFactor*15, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*30);                                                               //set the size and placement
            segmentedControl.center = CGPointMake(screenWidth/2,yy+ScreenHeightFactor*15);
        }
        else{
            segmentedControl.frame = CGRectMake(10*ScreenWidthFactor,yy+ScreenHeightFactor*15, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*30);                                                              //set the size and placement
            segmentedControl.center = CGPointMake(screenWidth/2,yy+ScreenHeightFactor*15);
        }
        //segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.backgroundColor=[UIColor clearColor];
        segmentedControl.tintColor = radiobuttonSelectionColor;
        segmentedControl.layer.cornerRadius = 0.0f;
        
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,
                                    radiobuttonSelectionColor, NSForegroundColorAttributeName, nil];
        
        [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [segmentedControl setSelectedSegmentIndex:0];
        segmentedControl.segmentedControlStyle = UISegmentedControlSegmentLeft;
        [segmentedControl addTarget:self
                             action:@selector(selectedSegmentView:)
                   forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segmentedControl];
        yy+= segmentedControl.frame.size.height + 5*ScreenHeightFactor;
    }
}


#pragma mark segment click implementation
-(void)selectedSegmentView:(UISegmentedControl *)paramSender{
    [totalArray removeAllObjects];
    totalCount = 0;
    if(segmentedControl.selectedSegmentIndex==0)    //// Recommendation
    {
        
        [self addLoaderView];
        
        GetListOfClustersOnRecommendedByChildID *getListOfClustersOnRecommendedByChildID = [[GetListOfClustersOnRecommendedByChildID alloc] init];
        [getListOfClustersOnRecommendedByChildID setServiceName:@"PinWiGetListOfClustersOnRecommendedByChildID"];
        [getListOfClustersOnRecommendedByChildID initService:@{
                                                               @"ChildID":[NSString stringWithFormat:@"%@",childObject.child_ID],
                                                               @"PageIndex":@"1",
                                                               @"NumberOfRows":@"5"
                                                               }];
        
        [getListOfClustersOnRecommendedByChildID setDelegate:self];
        
        
    }
    else if (segmentedControl.selectedSegmentIndex==1)  /// Network
    {
        
        [self addLoaderView];
        
        GetListOfClustersOnNetworkByChildID *getListOfClustersOnNetworkByChildID = [[GetListOfClustersOnNetworkByChildID alloc] init];
        [getListOfClustersOnNetworkByChildID setServiceName:@"PinWiGetListOfClustersOnNetworkByChildID"];
        [getListOfClustersOnNetworkByChildID initService:@{
                                                               @"ChildID":[NSString stringWithFormat:@"%@",childObject.child_ID],
                                                               @"PageIndex":@"1",
                                                               @"NumberOfRows":@"5"
                                                               }];
        
        [getListOfClustersOnNetworkByChildID setDelegate:self];
        
    }
    
    else if (segmentedControl.selectedSegmentIndex==2)  /// Explore
    {
        
        [self addLoaderView];
        GetListOfClustersOnExploreByChildID *getListOfClustersOnExploreByChildID = [[GetListOfClustersOnExploreByChildID alloc] init];
        [getListOfClustersOnExploreByChildID setServiceName:@"PinWiGetListOfClustersOnExploreByChildID"];
        [getListOfClustersOnExploreByChildID initService:@{
                                                           @"ChildID":[NSString stringWithFormat:@"%@",childObject.child_ID],
                                                           @"PageIndex":@"1",
                                                           @"NumberOfRows":@"5"
                                                           }];
        
        [getListOfClustersOnExploreByChildID setDelegate:self];
        
        
    }
    
}


-(void)addWishlistButton{
    if(!wishlistButton)
    {
        wishlistButton = [[UIButton alloc] init];
        UIImage *buttonImage;
        
        if(screenWidth>700)
        {
            wishlistButton.frame =CGRectMake(ScreenWidthFactor*285,ScreenHeightFactor*10, ScreenWidthFactor*18, ScreenHeightFactor*20);
            wishlistButton.center=CGPointMake(screenWidth-wishlistButton.frame.size.width/2-cellPadding, ScreenHeightFactor*10);
            buttonImage = [UIImage imageNamed:@"wishlist-iPad.png"];
            [wishlistButton setImage:buttonImage forState:UIControlStateNormal];
            
        }
        else
        {
            wishlistButton.frame =CGRectMake(ScreenWidthFactor*275,ScreenHeightFactor*12, ScreenHeightFactor*25, ScreenHeightFactor*25);
            wishlistButton.center=CGPointMake(screenWidth-wishlistButton.frame.size.width/2-cellPadding,ScreenHeightFactor*12);
            
            if (screenWidth>320) {
                 buttonImage = [UIImage imageNamed:@"wishlist-iPhone6.png"];
            }else{
                 buttonImage = [UIImage imageNamed:@"wishlist-iPhone5.png"];
            }
            
            [wishlistButton setImage:buttonImage forState:UIControlStateNormal];
        }
        
        wishlistButton.layer.cornerRadius = wishlistButton.frame.size.width/2;
        wishlistButton.layer.cornerRadius = wishlistButton.frame.size.height /2;
        wishlistButton.layer.masksToBounds = YES;
        wishlistButton.contentMode=UIViewContentModeScaleAspectFill;
        [wishlistButton addTarget:self action:@selector(wishlistButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:wishlistButton];
    }
    
}

-(void)wishlistButtonTouched:(UIButton*)sender{

    WishListViewController *wishListViewController = [[WishListViewController alloc] init];
    wishListViewController.childName = childObject.nick_Name;
    wishListViewController.childID = [childObject.child_ID integerValue];
    wishListViewController.childObject = childObject;
    [self.navigationController pushViewController:wishListViewController animated:YES];
}



#pragma mark WebServices related Functions
-(void)getDataFromWebService{
    pageIndex ++;

    if(segmentedControl.selectedSegmentIndex==0)    //// Recommendation
    {
//        [self addLoaderView];
        
        GetListOfClustersOnRecommendedByChildID *getListOfClustersOnRecommendedByChildID = [[GetListOfClustersOnRecommendedByChildID alloc] init];
        [getListOfClustersOnRecommendedByChildID setServiceName:@"PinWiGetListOfClustersOnRecommendedByChildID"];
        [getListOfClustersOnRecommendedByChildID initService:@{
                                                               @"ChildID":[NSString stringWithFormat:@"%@",childObject.child_ID],
                                                               @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],//@"1",
                                                               @"NumberOfRows":@"5"
                                                               }];
        
        [getListOfClustersOnRecommendedByChildID setDelegate:self];
        
        
    }
    else if (segmentedControl.selectedSegmentIndex==1)  /// Network
    {
//        [self addLoaderView];
        
        GetListOfClustersOnNetworkByChildID *getListOfClustersOnNetworkByChildID = [[GetListOfClustersOnNetworkByChildID alloc] init];
        [getListOfClustersOnNetworkByChildID setServiceName:@"PinWiGetListOfClustersOnNetworkByChildID"];
        [getListOfClustersOnNetworkByChildID initService:@{
                                                           @"ChildID":[NSString stringWithFormat:@"%@",childObject.child_ID],
                                                           @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],//@"1",
                                                           @"NumberOfRows":@"5"
                                                           }];
        
        [getListOfClustersOnNetworkByChildID setDelegate:self];
        
    }
    
    else if (segmentedControl.selectedSegmentIndex==2)  /// Explore
    {
//        [self addLoaderView];
        GetListOfClustersOnExploreByChildID *getListOfClustersOnExploreByChildID = [[GetListOfClustersOnExploreByChildID alloc] init];
        [getListOfClustersOnExploreByChildID setServiceName:@"PinWiGetListOfClustersOnExploreByChildID"];
        [getListOfClustersOnExploreByChildID initService:@{
                                                           @"ChildID":[NSString stringWithFormat:@"%@",childObject.child_ID],
                                                           @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],//@"1",
                                                           @"NumberOfRows":@"5"
                                                           }];
        
        [getListOfClustersOnExploreByChildID setDelegate:self];
        
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UITableViewCell *cell in [table visibleCells])
    {
        lastIndex  = [table indexPathForCell:cell].row;
        
    }
    if( lastIndex+1 == totalCount && totalCount!=0 && totalCount>=5 && !isScrolling)
    {
        //NSInteger pageIndex = (totalCount / 5) + 1;
        isScrolling = YES;
        [self getDataFromWebService];
        
    }
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:@"PinWiGetListOfClustersOnRecommendedByChildID"]) {
        NSLog(@"PinWiGetListOfClustersOnRecommendedByChildID error message %@",errorMessage);
    }
    if ([connection.serviceName isEqualToString:@"PinWiGetListOfClustersOnNetworkByChildID"]) {
        NSLog(@"PinWiGetListOfClustersOnNetworkByChildID error message %@",errorMessage);
    }
    if ([connection.serviceName isEqualToString:@"PinWiGetListOfClustersOnExploreByChildID"]) {
        NSLog(@"PinWiGetListOfClustersOnExploreByChildID error message %@",errorMessage);
    }
     pageIndex--;
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    isScrolling = NO;
    NSDictionary *dict;
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:@"PinWiGetListOfClustersOnRecommendedByChildID"])
    {
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetListOfClustersOnRecommendedByChildIDResponse" resultKey:@"GetListOfClustersOnRecommendedByChildIDResult"];
        
        [conncetionsData removeAllObjects];
        [table removeFromSuperview];
        [self removeNoActivitySetUp];
        NSArray *array = (NSArray*)dict;
        NSDictionary *errorDictionary = [array firstObject];
        NSString *erroDesc = [errorDictionary valueForKey:@"ErrorDesc"];
        
        //[dict valueForKey:@"ErrorDesc"];
        
        if (!dict) {
           //[self setUpForNoActivity:erroDesc];
            if(totalCount<=0)
            {
                [self drawTableHeader];
                [self setUpForNoActivity:erroDesc];
                
                
            }
            else
            {
                [self drawTableHeader];
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
            }
            pageIndex--;

        }
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            
            if([dictionary valueForKey:@"ErrorDesc"]) {
                if(totalCount<=0)
                {
                    [self drawTableHeader];
                    [self setUpForNoActivity:erroDesc];
                    

                }
                else
                {
                    [self drawTableHeader];
                    [self addTableView];
                    int index = (int)totalCount-5;
                    if (index>0) {
                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        
                    }
                }
                pageIndex--;
            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [conncetionsData addObject:dictionary];
                    [totalArray addObject:dictionary];
                }];
                totalCount = totalArray.count;
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
                NSLog(@"Recommended tab data : %@",dict);
                [self drawTableHeader];
                [self addTableView];
            }
            
        }
        
        [self removeLoaderView];
    }
    
    if ([connection.serviceName isEqualToString:@"PinWiGetListOfClustersOnNetworkByChildID"])
    {
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetListOfClustersOnNetworkByChildIDResponse" resultKey:@"GetListOfClustersOnNetworkByChildIDResult"];
        
        [conncetionsData removeAllObjects];
        [table removeFromSuperview];
        [self removeNoActivitySetUp];
        NSArray *array = (NSArray*)dict;
        NSDictionary *errorDictionary = [array firstObject];
        NSString *erroDesc = [errorDictionary valueForKey:@"ErrorDesc"];
        //[dict valueForKey:@"ErrorDesc"];
        
        if (!dict) {
//            [self setUpForNoActivity:erroDesc];
//             pageIndex--;
            if(totalCount<=0)
            {
                [self drawTableHeader];
                [self setUpForNoActivity:erroDesc];
                
                
            }
            else
            {   [self drawTableHeader];
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
            }
            pageIndex--;
        }
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            
            if([dictionary valueForKey:@"ErrorDesc"]) {
                //[self setUpForNoActivity:erroDesc];
                if(totalCount<=0)
                {
                    [self drawTableHeader];
                    [self setUpForNoActivity:erroDesc];
                    
                    
                }
                else
                {
                    [self drawTableHeader];
                    [self drawTableHeader];
                    [self addTableView];
                    int index = (int)totalCount-5;
                    if (index>0) {
                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        
                    }
                }
                pageIndex--;

            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [conncetionsData addObject:dictionary];
                    [totalArray addObject:dictionary];
                }];
                 totalCount = totalArray.count;
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
                NSLog(@"Recommended tab data : %@",dict);
                [self drawTableHeader];
                [self addTableView];
            }
            
        }
        
        [self removeLoaderView];
    }

    if ([connection.serviceName isEqualToString:@"PinWiGetListOfClustersOnExploreByChildID"])
    {
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetListOfClustersOnExploreByChildIDResponse" resultKey:@"GetListOfClustersOnExploreByChildIDResult"];
        
        [conncetionsData removeAllObjects];
        [table removeFromSuperview];
        [self removeNoActivitySetUp];
        NSArray *array = (NSArray*)dict;
        NSDictionary *errorDictionary = [array firstObject];
        NSString *erroDesc = [errorDictionary valueForKey:@"ErrorDesc"];
        //[dict valueForKey:@"ErrorDesc"];
        
        if (!dict) {
           // [self setUpForNoActivity:erroDesc];
            if(totalCount<=0)
            {
                [self drawTableHeader];
                [self setUpForNoActivity:erroDesc];
                
                
            }
            else
            {
                [self drawTableHeader];
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
            }
            pageIndex--;

        }
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            
            if([dictionary valueForKey:@"ErrorDesc"]) {
//                [self setUpForNoActivity:erroDesc];
//                 pageIndex--;
                
                if(totalCount<=0)
                {
                   // [self setUpForNoActivity:erroDesc];
                    if(totalCount<=0)
                    {
                        [self drawTableHeader];
                        [self setUpForNoActivity:erroDesc];
                        
                        
                    }
                    else
                    {
                        [self drawTableHeader];
                        [self addTableView];
                        int index = (int)totalCount-5;
                        if (index>0) {
                            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                         atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                        }else{
                            
                        }
                    }
                    pageIndex--;

                    
                    
                }
                else
                {
                    [self drawTableHeader];
                    [self addTableView];
                    int index = (int)totalCount-5;
                    if (index>0) {
                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        
                    }
                }
                pageIndex--;

            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [conncetionsData addObject:dictionary];
                    [totalArray addObject:dictionary];
                }];
               totalCount = totalArray.count;
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
                NSLog(@"Recommended tab data : %@",dict);
                [self drawTableHeader];
                [self addTableView];
            }
            
        }
        
        [self removeLoaderView];
    }

    
}

-(void)addTableView {
    
    if (screenWidth>700) {
        table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy+headingView.frame.size.height +15*ScreenHeightFactor, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*365)];
        table.center = CGPointMake(screenWidth/2,table.center.y);
        table.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    }
    else{
        table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy+headingView.frame.size.height +15*ScreenHeightFactor, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*380)];
        table.center = CGPointMake(screenWidth/2,table.center.y);
        if (screenWidth>320) {
            table.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
        }else{
            table.contentInset = UIEdgeInsetsMake(0, 0, 90, 0);
        }
    }
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    table.backgroundColor = appBackgroundColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
 
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return totalArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return headerHeight;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *customHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0, screenWidth- ScreenWidthFactor*20,headerHeight)];
//    UILabel *headingLabel = [[UILabel alloc] init];
//    if (screenWidth>320) {
//        headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, customHeaderView.frame.size.width-20, customHeaderView.frame.size.height-10)];
//        headingLabel.center = CGPointMake(customHeaderView.frame.size.width/2, customHeaderView.frame.size.height/2);
//    }
//    else{
//        headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, customHeaderView.frame.size.width-20, customHeaderView.frame.size.height)];
//        headingLabel.center = CGPointMake(customHeaderView.frame.size.width/2, customHeaderView.frame.size.height/2);
//    }
//   
//    headingLabel.textAlignment = NSTextAlignmentLeft;
//    headingLabel.numberOfLines = 4;
//    if (segmentedControl.selectedSegmentIndex == 0) {
//        headingLabel.text = @"Nurture interests that exhilarate this child with these clusters of activities.";
//    }
//    if (segmentedControl.selectedSegmentIndex == 1) {
//        headingLabel.text = @"View clusters of activities popular amongst children in this child’s network.";
//    }
//    if (segmentedControl.selectedSegmentIndex == 2) {
//        headingLabel.text = @"Help this child explore new interests with these clusters of activities.";
//    }
//    customHeaderView.backgroundColor = activityHeading1Code;
//    [customHeaderView addSubview:headingLabel];
//    
//    return customHeaderView;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"Cell";
    
    WhatToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[WhatToDoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = nil;

    
     dict = [totalArray objectAtIndex:indexPath.row];
     clusterName = [dict objectForKey:@"ClusterName"];
    cell.backgroundColor = appBackgroundColor;
    
    [cell displayClusterList:[dict objectForKey:@"ClusterName"] activityCount:[[dict objectForKey:@"ActivityCount"] integerValue] cellHeight:cellHeight];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row is = %ld",(long)indexPath.row);
    NSDictionary *dict = [totalArray objectAtIndex:indexPath.row];
    
    NSInteger num = [[dict objectForKey:@"ClusterID"] integerValue];
    NSString *str = [dict objectForKey:@"ClusterName"];
   
    str = [str stringByAppendingString:@" - "];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"ActivityCount"]]];
    
    ClusterDetailViewController *clusterDetailViewController = [[ClusterDetailViewController alloc] init];
    clusterDetailViewController.childName = childObject.nick_Name;
    clusterDetailViewController.childID = [childObject.child_ID integerValue];
    clusterDetailViewController.clusterId = num;
    clusterDetailViewController.childObject = childObject;
    if (segmentedControl.selectedSegmentIndex == 0) {
        clusterDetailViewController.stripViewTitle = @"Recommended Activities";
        clusterDetailViewController.segmentControlIndex = 0;
    }
    if (segmentedControl.selectedSegmentIndex == 1) {
        clusterDetailViewController.stripViewTitle = @"Network Activities";
        clusterDetailViewController.segmentControlIndex = 1;
    }
    if (segmentedControl.selectedSegmentIndex == 2) {
        clusterDetailViewController.stripViewTitle = @"Explore Activities";
        clusterDetailViewController.segmentControlIndex = 2;
    }
    clusterDetailViewController.clusterDetails = str;
    
    [self.navigationController pushViewController:clusterDetailViewController animated:YES];
}

-(void)setUpForNoActivity:(NSString*)errorDecs{
    
    [table removeFromSuperview];
    
    if (screenWidth>700) {
        noActivityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2,ScreenHeightFactor*180, screenWidth- ScreenWidthFactor*250, ScreenHeightFactor*50)];
        noActivityImageView.center = CGPointMake(screenWidth/2, screenHeight/2 - noActivityImageView.frame.size.height*2);
    }
    else{
        noActivityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2,ScreenHeightFactor*180, screenWidth- ScreenWidthFactor*260, ScreenHeightFactor*40)];
        noActivityImageView.center = CGPointMake(screenWidth/2, screenHeight/2 - noActivityImageView.frame.size.height*2);
    }
   
    
    if (screenWidth>700) {
        noActivityImageView.image = [UIImage imageNamed:@"what-to-do-iPad.png"];
    }
    else{
        if (screenWidth>320) {
            noActivityImageView.image = [UIImage imageNamed:@"what-to-do-iPhone6.png"];
        }else{
        noActivityImageView.image = [UIImage imageNamed:@"what-to-do-iPhone5.png"];
        }
    }
    [self.view addSubview:noActivityImageView];
    
    
    noActivityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,noActivityImageView.frame.size.height + noActivityImageView.frame.origin.y + 5*ScreenHeightFactor, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*50)];
    noActivityLabel.numberOfLines=2;
    noActivityLabel.center = CGPointMake(screenWidth/2, noActivityLabel.center.y);
    [noActivityLabel setFont:[UIFont fontWithName:RobotoLight size:13*ScreenHeightFactor]];
    noActivityLabel.textAlignment = NSTextAlignmentCenter;
    noActivityLabel.textColor = [UIColor grayColor];
    noActivityLabel.text = [NSString stringWithFormat:@"%@",errorDecs];
    NSLog(@"error description : %@",errorDecs);
    
    [self.view addSubview:noActivityLabel];
}

-(void)removeNoActivitySetUp{
    [noActivityImageView removeFromSuperview];
    [noActivityLabel removeFromSuperview];
    
}


-(void)addLoaderView {
    if (screenWidth>700) {
        loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0,yy-segmentedControl.frame.size.height-ScreenHeightFactor*70,self.view.frame.size.width, self.view.frame.size.height)];
    }
    else{
        loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0,yy-segmentedControl.frame.size.height-ScreenHeightFactor*70
                                                                            
                                                                            ,self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
    
}



-(void)removeLoaderView {
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
