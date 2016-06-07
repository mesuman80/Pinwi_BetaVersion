//
//  WhoIsDoingThisViewController.m
//  ParentControl_CT
//
//  Created by Sakshi on 18/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "WhoIsDoingThisViewController.h"
#import "GetWishListsByChildID.h"
#import "StripView.h"
#import "WhatToDoTableViewCell.h"
#import "GetChildsDetailsOnRecommendedByActivityID.h"
#import "WhatToDoTableViewCell.h"
#import "ChildDetailViewController.h"

@interface WhoIsDoingThisViewController ()<HeaderViewProtocol,UIScrollViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@end

@implementation WhoIsDoingThisViewController
{
    UIImageView *noActivityImageView;
    UILabel *noSearchResultLabel;
    NSInteger pageIndex;
    NSInteger lastIndex;
    NSInteger totalCount;
    NSMutableArray *totalArray;
    BOOL isScrolling;

}

@synthesize childObject,label,whoIsDoingThisData,stripViewTitle;
@synthesize headerView,cellHeight,loaderView,activityId;
@synthesize scrollView,yy,yCord,xCord,scrollXX,initialY,reduceYY;
@synthesize tabBarCtrl,childName,table;

- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
    [self.view setBackgroundColor:appBackgroundColor];
    
    if (screenWidth>700) {
        cellHeight  =  120;
    }
    else{
        cellHeight = 80;
    }
    whoIsDoingThisData = [[NSMutableArray alloc] init];
     totalArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    reduceYY =0;
    pageIndex = 0;
    [totalArray removeAllObjects];
    totalCount = 0;
    isScrolling = NO;

    self.navigationController.navigationBarHidden=YES;
    [self drawUiWithHead];
    [self drawHeaderView];
    [self loadData];
    
    [self.tabBarCtrl.tabBar setSelectedImageTintColor:[UIColor purpleColor]];
}

-(void)loadData{
    [self childNameLabel];
    [self addStripView:stripViewTitle];
    [self getDataFromWebservice];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark drawUI
-(void)drawUiWithHead
{
    
    if(!scrollView)
    {
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:NO];
        [scrollView setScrollEnabled:NO];
        [scrollView setBackgroundColor:appBackgroundColor];
        [self.view addSubview:scrollView];
        
        yCord+=20*ScreenHeightFactor;
        
        //       [self  drawLabelWithText:@"Coming Soon" andColor:[UIColor darkGrayColor] andFont:[UIFont fontWithName:RobotoLight size:9*ScreenFactor]];
        
        yCord+=20*ScreenHeightFactor;
        
    }
    
    [self.view setBackgroundColor:appBackgroundColor];
}

#pragma mark headerViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setCentreImgName:@"whatToDoHeader.png"];
        //[headerView setRightType:@"Menu"];
        [headerView drawHeaderViewWithTitle:@"What To Do" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+25*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+22*ScreenHeightFactor;
            
        }
    }
    
}

#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark drawing implmentation

-(void)childNameLabel
{
    if(!label) {
        if(screenWidth>700) {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:childName];
            label.center=CGPointMake(screenWidth/2,label.center.y);
        }
        else {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:childName];
            label.center=CGPointMake(screenWidth/2,label.center.y);
        }
        [self.view addSubview:label];
        yy += label.frame.size.height + 20*ScreenHeightFactor;
    }
}

-(void)addStripView:(NSString*)title{
    
    StripView *stripView1 = [[StripView alloc] initWithFrame:CGRectMake(0, yy, screenWidth, ScreenHeightFactor*30)];
    [stripView1 drawStrip:title color:[UIColor grayColor]];
    [self.view addSubview:stripView1];
    
    
    StripView *stripView2 = [[StripView alloc] initWithFrame:CGRectMake(0, stripView1.frame.origin.y+stripView1.frame.size.height, screenWidth, ScreenHeightFactor*30)];
    [stripView2 drawStrip:@"WHO IS DOING THIS?" color:[UIColor grayColor]];
    stripView2.backgroundColor = [UIColor grayColor];
    stripView2.alpha = 0.4;
    [self.view addSubview:stripView2];
    
    yy += stripView2.frame.origin.y+stripView2.frame.size.height+10;
}

-(void)getDataFromWebservice{
    [self addLoaderView];
    pageIndex ++;
        GetChildsDetailsOnRecommendedByActivityID *getChildsDetailsOnRecommendedByActivityID = [[GetChildsDetailsOnRecommendedByActivityID alloc] init];
        [getChildsDetailsOnRecommendedByActivityID setServiceName:@"PinWiGetChildsDetailsOnRecommendedByActivityID"];
        [getChildsDetailsOnRecommendedByActivityID initService:@{
                                                                   @"ActivityID":[NSString stringWithFormat:@"%li",(long)activityId],
                                                                   @"PageIndex": [NSString stringWithFormat:@"%ld",(long)pageIndex],//@"1",
                                                                   @"NumberOfRows":@"5"
                                                                   }];
        
        [getChildsDetailsOnRecommendedByActivityID setDelegate:self];
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    [self removeLoaderView];
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:@"PinWiGetChildsDetailsOnRecommendedByActivityID"]) {
        NSLog(@"PinWiGetChildsDetailsOnRecommendedByActivityID error message %@",errorMessage);
    }
    pageIndex --;
   
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary *dict;
    isScrolling = NO;
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    [self removeLoaderView];
    dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetChildsDetailsOnRecommendedByActivityIDResponse" resultKey:@"GetChildsDetailsOnRecommendedByActivityIDResult"];
    
    [whoIsDoingThisData removeAllObjects];
    [table removeFromSuperview];
    NSArray *array = (NSArray*)dict;
    NSDictionary *errorDictionary = [array firstObject];
    NSString *erroDesc = [errorDictionary valueForKey:@"ErrorDesc"];
    //[dict valueForKey:@"ErrorDesc"];
    
    if (!dict) {
        NSLog(@"error description %@",erroDesc);
       // [self setUpForNoActivity:erroDesc];
        if(totalCount<=0)
        {
            [self setUpForNoActivity:erroDesc];
            
            
        }
        else
        {
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
            NSLog(@"error description %@",erroDesc);
           // [self setUpForNoActivity:erroDesc];
            if(totalCount<=0)
            {
                [self setUpForNoActivity:erroDesc];
                
                
            }
            else
            {
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
            }

            pageIndex --;
        }
        else{
            [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                [whoIsDoingThisData addObject:dictionary];
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
            NSLog(@"Recommended tab data : %@",dict);
            [self addTableView];
        }
        
    }
    
    [self removeLoaderView];
    
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
        [self getDataFromWebservice];
        
    }
    
}


-(void)addTableView {
    
    if (screenWidth>700) {
        table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy, screenWidth, ScreenHeightFactor*365)];
        table.center = CGPointMake(screenWidth/2,screenHeight/2+160);
        table.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    }
    else{
        table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy, screenWidth, ScreenHeightFactor*380)];
        table.center = CGPointMake(screenWidth/2,screenHeight/2+100);
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
    
    yy += table.frame.origin.y+table.frame.size.height+20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return totalArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"Cell";
    WhatToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WhatToDoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //cell.removeFriendDelegate = self;
    NSDictionary *dict= nil;
    
    dict = [totalArray objectAtIndex:indexPath.row];
    UIImage *img = nil;
    NSString *profileImageStr = [dict objectForKey:@"ProfileImage"];
    
    if (profileImageStr == (id)[NSNull null] || profileImageStr.length == 0 ) {
        img =  [UIImage imageNamed:@"childDefaultImage-568h@2x.png"];
    }
    else {
        img=[[PC_DataManager sharedManager] decodeImage:profileImageStr];
    }
    cell.backgroundColor = appBackgroundColor;
    [cell displayWhoIsDoThisList:img childName:[dict objectForKey:@"ChildName"] parentName:[dict objectForKey:@"ParentName"] cellHeight:cellHeight];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict=[totalArray objectAtIndex:indexPath.row];
    
    ChildDetailViewController *childDetailViewController = [[ChildDetailViewController alloc] init];
    NSNumber* num = [dict objectForKey:@"ChildID"];
    int fnum = [num intValue];
    
    childDetailViewController.ChildId = *(&(fnum));
    [self.navigationController pushViewController:childDetailViewController animated:YES ];
}

-(void)addLoaderView {
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0,screenWidth, screenHeight)];
    loaderView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
    
}

-(void)removeLoaderView {
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}

-(void)setUpForNoActivity:(NSString*)errorDecs{
    
    table.alpha = 0.0f;
    if(!noActivityImageView)
    {
        if (screenWidth>700) {
            noActivityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2,ScreenHeightFactor*180, screenWidth- ScreenWidthFactor*220, ScreenHeightFactor*50)];
            noActivityImageView.center = CGPointMake(screenWidth/2, screenHeight/2 + noActivityImageView.frame.size.height/2 + ScreenHeightFactor);
        }
        else{
            noActivityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2,ScreenHeightFactor*180, screenWidth- ScreenWidthFactor*260, ScreenHeightFactor*40)];
            noActivityImageView.center = CGPointMake(screenWidth/2, screenHeight/2 + noActivityImageView.frame.size.height/2 + ScreenHeightFactor);
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
    }
    if(!noSearchResultLabel)
    {
        noSearchResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,noActivityImageView.frame.size.height + noActivityImageView.frame.origin.y + 5*ScreenHeightFactor, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*30)];
        noSearchResultLabel.center = CGPointMake(screenWidth/2, noSearchResultLabel.center.y);
        [noSearchResultLabel setFont:[UIFont fontWithName:RobotoLight size:10*ScreenHeightFactor]];
        noSearchResultLabel.textAlignment = NSTextAlignmentCenter;
        noSearchResultLabel.textColor = [UIColor blackColor];
        noSearchResultLabel.text = [NSString stringWithFormat:@"%@",errorDecs];
        NSLog(@"error description : %@",errorDecs);
        
        [self.view addSubview:noSearchResultLabel];
        
    }
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
