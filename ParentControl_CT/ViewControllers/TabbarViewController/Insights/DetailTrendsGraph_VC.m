//
//  ViewController.m
//  LineGraph
//
//  Created by Yogesh Gupta on 03/09/15.
//  Copyright (c) 2015 Yogesh Gupta. All rights reserved.
//

#import "DetailTrendsGraph_VC.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "HeaderView.h"
#import "RedLabelView.h"
#import "StripView.h"
#import "PNColor.h"
#import "GetDelightTraitsByActivity.h"
#import "ShowActivityLoadingView.h"
#import "InsightData.h"



#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define PNFreshGreen    [UIColor colorWithRed:77.0 / 255.0 green:196.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]
#define PNTwitterColor  [UIColor colorWithRed:0.0 / 255.0 green:171.0 / 255.0 blue:243.0 / 255.0 alpha:1.0]
@interface DetailTrendsGraph_VC ()<HeaderViewProtocol,UrlConnectionDelegate>

@end

@implementation DetailTrendsGraph_VC
{
HeaderView *headerView;
UIScrollView *scrollView;
int yy;
    ShowActivityLoadingView *loaderView;
//    UIButton *backButton;
//    UIView *viewBack;
//    UIGestureRecognizer *gestureRecognizer;
}
@synthesize dataDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
    [self.view setBackgroundColor:appBackgroundColor];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.title=@"Insights";
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self drawHeaderView];
    [self delightTraitsByActivity];
    [self.tabBarCtrl.tabBar setSelectedImageTintColor:[UIColor redColor]];
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
-(void)drawUi:(NSArray*)array
{
    
    NSDictionary *dictArr=(NSDictionary*)[array firstObject];
    if([[dictArr objectForKey:@"ErrorDesc"]isEqualToString:@"No Record found."])
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Insufficient Data" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
        return;
    }
    
    NSMutableArray *point=[[NSMutableArray alloc]init];
    NSMutableArray *actDate=[[NSMutableArray alloc]init];

    
for(NSDictionary *resultDict in array)
{
    [point addObject:[resultDict objectForKey:@"Rating"]];
    [actDate addObject:[resultDict objectForKey:@"ActivityDate"]];
}

    
    
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
        
        
        StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0, yy, self.view.frame.size.width,25*ScreenHeightFactor)];
        [stripView drawStrip:[dataDict objectForKey:@"Name"] color:activityHeading1Code];
        [self.view addSubview:stripView];
        
        yy += stripView.frame.size.height;
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:NO];
        [scrollView setScrollEnabled:NO];
        [scrollView setBounces:NO];
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:scrollView];
        
        if(screenWidth>700)
        {
        if(actDate.count>=8)
        {
            [scrollView setContentSize:CGSizeMake(self.view.frame.size.width* (actDate.count / 8), scrollView.contentSize.height)];
            [scrollView setScrollEnabled:YES];
        }
        }
        else
        {
            if(actDate.count>4)
            {
                [scrollView setContentSize:CGSizeMake(self.view.frame.size.width* (actDate.count / 4), scrollView.contentSize.height)];
                [scrollView setScrollEnabled:YES];
            }
        }
        
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 10*ScreenHeightFactor,scrollView.contentSize.width, scrollView.frame.size.height-55*ScreenHeightFactor)];
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.backgroundColor = [UIColor clearColor];
        [self.lineChart setXLabels:[actDate mutableCopy]];//@[@"3",@"6",@"9",@"12",@"15",@"18",@"21",@"24",@"27",@"30"]];
    self.lineChart.showCoordinateAxis = YES;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    self.lineChart.yFixedValueMax = 10.0;
    self.lineChart.yFixedValueMin = 1.0;
    
    [self.lineChart setYLabels:@[
                                 @"1",
                                 @"2",
                                 @"3",
                                 @"4",
                                 @"5",
                                 @"6",
                                 @"7",
                                 @"8",
                                 @"9",@"10"
                                 ]
     ];
    
        
       // [self.lineChart setYLabels:[actDate mutableCopy]];
    // Line Chart #1
        NSArray * data01Array = point ;//@[@60.1, @160.1, @100.5, @200.1, @126.4, @0.0, @30.7, @186.2, @127.2, @176.2,];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"Alpha";
    data01.color = PNTwitterColor;
    //data01.alpha = 0.3f;
    data01.itemCount = data01Array.count;
        data01.inflexionPointStyle = PNLineChartPointStyleCircle;//PNLineChartPointStyleTriangle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart #2
    NSArray * data02Array = @[@0.0, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.dataTitle = @"Beta";
    data02.color =PNRed;
    data02.alpha = 0.5f;
    data02.itemCount = data02Array.count;
    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01];
    [self.lineChart strokeChart];
    self.lineChart.delegate = self;
    
    
    [scrollView addSubview:self.lineChart];
    
    self.lineChart.legendStyle = PNLegendItemStyleStacked;
    self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    self.lineChart.legendFontColor = [UIColor redColor];
    
    UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
    [legend setFrame:CGRectMake(30, 340, legend.frame.size.width, legend.frame.size.width)];
   // [scrollView addSubview:legend];
       // if(screenWidth<700)
            [self drawdummyYaxis];
}
}
#pragma mark duumy yaxis
-(void)drawdummyYaxis
{
    
    UIView *viewLine;
if(screenWidth>700)
{
     viewLine=[[UIView alloc]initWithFrame:CGRectMake(0,yy+10*ScreenHeightFactor,20*ScreenWidthFactor, self.view.frame.size.height-yy-55*ScreenHeightFactor)];
}
else{
    viewLine=[[UIView alloc]initWithFrame:CGRectMake(0,yy+10*ScreenHeightFactor,42.5*ScreenWidthFactor, self.view.frame.size.height-yy-55*ScreenHeightFactor)];}
    viewLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewLine];
    
    PNLineChart *lineChart1;
    lineChart1= [[PNLineChart alloc] initWithFrame:CGRectMake(0,yy+10*ScreenHeightFactor,50*ScreenWidthFactor, self.view.frame.size.height-yy-55*ScreenHeightFactor)];
    if(screenWidth>700)
    {
        lineChart1= [[PNLineChart alloc] initWithFrame:CGRectMake(0,yy+10*ScreenHeightFactor,25*ScreenWidthFactor, self.view.frame.size.height-yy-55*ScreenHeightFactor)];
    }
    lineChart1.yLabelFormat = @"%1.1f";
  //  [lineChart1 setXLabels:@[@"0"]];
    lineChart1.showXaxis=YES;
    lineChart1.showCoordinateAxis = YES;
    lineChart1.backgroundColor = [UIColor clearColor];
        //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    lineChart1.yFixedValueMax = 10.0;
    lineChart1.yFixedValueMin = 1.0;
    
    [lineChart1 setYLabels:@[
                                 @"1",
                                 @"2",
                                 @"3",
                                 @"4",
                                 @"5",
                                 @"6",
                                 @"7",
                                 @"8",
                                 @"9",@"10"
                                 ]
     ];
    [self.view addSubview:lineChart1];
}

#pragma mark MENU BUTTON DELEGATE
-(void)getMenuTouches
{
    //[self touchAtPinwiWheel];
}



#pragma mark service call
-(void)delightTraitsByActivity
{
    NSArray *array=[[PC_DataManager sharedManager].serviceDictionary objectForKey:[NSString stringWithFormat:@"PinWiGetDelightTraitsByActivity-%@-%@",self.childObj.child_ID,[dataDict objectForKey:@"Name"]]];
    
    if(array)
    {
        [self drawUi:array];
    }
    else
    {
        GetDelightTraitsByActivity *interestTraits= [[GetDelightTraitsByActivity alloc]init];
        [interestTraits setDelegate:self];
        [interestTraits setServiceName:PinWiGetDelightTraitsByActivity];
        [interestTraits initService:@{
                                      @"ChildID":_childObj.child_ID,
                                      @"ActivityID":[dataDict objectForKey:@"ActivityID"]
                                      }];
        [self addLoaderView];
        [[InsightData insightData]updateConnectionArray:interestTraits isRemove:NO isAllRemove:NO];
    }
}
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    if([connection.serviceName isEqualToString:PinWiGetDelightTraitsByActivity])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetDelightTraitsByActivityResponse resultKey:PinWiGetDelightTraitsByActivityResult];
        NSLog(@"Value of Dict =%@",dict);
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)dict;
            [self drawUi:array];
            
            [[PC_DataManager sharedManager].serviceDictionary setObject:array forKey:[NSString stringWithFormat:@"PinWiGetInterestTraitsByChildIDOnInsight-%@-%@",self.childObj.child_ID,[dataDict objectForKey:@"Name"]]];
        }
        [[InsightData insightData]updateConnectionArray:connection isRemove:YES isAllRemove:NO];
        [self removeLoaderView];
    }
}
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    [[InsightData insightData]updateConnectionArray:connection isRemove:YES isAllRemove:NO];
    [self removeLoaderView];
}
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0,yy,scrollView.frame.size.width,scrollView.frame.size.height-yy)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [scrollView addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}


@end
