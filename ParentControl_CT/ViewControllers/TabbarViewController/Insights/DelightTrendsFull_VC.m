//
//  DelightTrendsFull_VC.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 01/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "DelightTrendsFull_VC.h"
#import "HeaderView.h"
#import "PC_DataManager.h"
#import "Constant.h"
#import "DelightTrendsItemView.h"
#import "RedLabelView.h"
#import "StripView.h"
#import "DetailTrendsGraph_VC.h"
#import "GetDelightTraitsByChildIDOnInsight.h"

@interface DelightTrendsFull_VC ()<HeaderViewProtocol, DelightTrendsProtocol,UrlConnectionDelegate>

@end

@implementation DelightTrendsFull_VC
{
    HeaderView *headerView;
    UIScrollView *scrollView;
    int yy;
    int initialY;
    //    UIButton *backButton;
    //    UIView *viewBack;
    //    UIGestureRecognizer *gestureRecognizer;
    NSMutableArray *activityArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
    [self.view setBackgroundColor:appBackgroundColor];
    activityArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.title=@"Insights";
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self drawHeaderView];
    [self drawUi];
     [self.tabBarCtlr.tabBar setSelectedImageTintColor:[UIColor redColor]];
    //[self drawHeaderView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //  [viewBack removeGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [headerView setCentreImgName:@"insightHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Insights" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        //[self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
         yy+=headerView.frame.size.height+10*ScreenHeightFactor;
    }
   // yy+=headerView.frame.size.height+10*ScreenHeightFactor;
}
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark drawUI
-(void)drawUi
{
    
    if(!scrollView)
    {
        //yy = 64+20*ScreenFactor;
        
        RedLabelView *label;
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:self.childObj.nick_Name];
            label.center=CGPointMake(ScreenWidthFactor*320/2,yy+label.frame.size.height/2+20*ScreenHeightFactor);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:self.childObj.nick_Name];
            label.center=CGPointMake(ScreenWidthFactor*320/2,yy+label.frame.size.height/2+10*ScreenHeightFactor);
        }
        
        [self.view addSubview:label];
        yy+=label.frame.size.height+30*ScreenHeightFactor;
        

        StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0, yy, self.view.frame.size.width,30*ScreenHeightFactor)];
        [stripView drawStrip:@"Delight Trends" color:activityHeading1Code];
        [self.view addSubview:stripView];
        
        yy += stripView.frame.size.height;

        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:NO];
        [scrollView setScrollEnabled:NO];
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:scrollView];
        
        
//        NSArray *array=[[PC_DataManager sharedManager].serviceDictionary objectForKey:[NSString stringWithFormat:@"PinWiGetDelightTraitsByChildIDOnInsight-%@",self.childObj.child_ID]];
        
        GetDelightTraitsByChildIDOnInsight *getDelightTraitsByChildIDOnInsight = [[GetDelightTraitsByChildIDOnInsight alloc]init];
        [getDelightTraitsByChildIDOnInsight setServiceName:@"PinWiGetDelightTraitsByChildIDOnInsight"];
        
        [getDelightTraitsByChildIDOnInsight initService:@{
                                                         @"ChildID":[NSString stringWithFormat:@"%@",self.childObj.child_ID]
                                                        }];
        
        [getDelightTraitsByChildIDOnInsight setDelegate:self];
        

    }
}

-(void)addDetails{
    
    int yCord=5*ScreenHeightFactor;
    
    for(int i=0; i<activityArray.count; i++)
    {
        DelightTrendsItemView *delightTrends = [[DelightTrendsItemView alloc]initWithFrame:CGRectMake(0,yCord, self.view.frame.size.width,40*ScreenHeightFactor)];
        [delightTrends setBackgroundColor:[UIColor whiteColor]];
        [delightTrends setDelightTrendDelegate:self];
        [delightTrends drawUI:[activityArray objectAtIndex:i]];
        [scrollView addSubview:delightTrends];
        yCord +=delightTrends.frame.size.height;
    }
    yy+=yCord;
    if(yCord>scrollView.frame.size.height)
    {
        [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, yy)];
        [scrollView setScrollEnabled:YES];
    }

}


-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    NSLog(@"GetDelightTraitsByChildIDOnInsight error message %@",errorMessage);
    
    if ([connection.serviceName isEqualToString:@"PinWiGetDelightTraitsByChildIDOnInsight"]) {
        NSLog(@"PinWiGetDelightTraitsByChildIDOnInsight error message %@",errorMessage);
    }
    
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    [activityArray removeAllObjects];
   
    NSDictionary *dict;
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:@"PinWiGetDelightTraitsByChildIDOnInsight"]) {
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetDelightTraitsByChildIDOnInsightResponse" resultKey:@"GetDelightTraitsByChildIDOnInsightResult"];
        
        if (!dict) {
            return;
        }
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [activityArray addObject:dictionary];
                }];
    
                NSLog(@"GetDelightTraitsByChildIDOnInsight data: %@",dict);
            }
            [self addDetails];
        
    }
}
    
    
}



#pragma mark Delight Trend
-(void)delightTrendtouched:(DelightTrendsItemView *)delight
{
    DetailTrendsGraph_VC *detail=[[DetailTrendsGraph_VC alloc]init];
    [detail setChildObj:self.childObj];
    [detail setTabBarCtrl:self.tabBarCtlr];
    [detail setDataDict:delight.dataDict];
    [self.navigationController pushViewController:detail animated:YES];
}



#pragma mark MENU BUTTON DELEGATE
-(void)getMenuTouches
{
//    [self touchAtPinwiWheel];
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
