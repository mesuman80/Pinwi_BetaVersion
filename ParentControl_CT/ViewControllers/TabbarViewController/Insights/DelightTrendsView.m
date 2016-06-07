//
//  DelightTrendsView.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "DelightTrendsView.h"
#import "StripView.h"
#import "Constant.h"
#import "ShowActivityLoadingView.h"
#import "DelightTrendsItemView.h"
#import "InsightData.h"
#import "PC_DataManager.h"
#import "DelightTrendsFull_VC.h"
#import "DetailTrendsGraph_VC.h"


@interface DelightTrendsItemView()<DelightTrendsProtocol,StripViewInfoprotocol>

@end

@implementation DelightTrendsView
{
    ShowActivityLoadingView *loaderView;
    int yy ;
    int yCoordinate;
    int heightCalculate;
}

-(void)drawUi
{
    
    StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,25*ScreenHeightFactor)];
    [stripView drawStrip:@"Delight Trends" color:[UIColor clearColor]];
    [stripView drawInfoIcon];
    [stripView setStripInfoDelegate:self];
    [self addSubview:stripView];
    yy = stripView.frame.size.height;
    [self delightTrends];
   
}
-(void)subjectRating:(NSArray *)dataArray
{
    int i =0;
    yCoordinate = yy+5*ScreenHeightFactor;
    if(dataArray.count<5)
    {
       heightCalculate = ((self.frame.size.height-yCoordinate-(6*(2*ScreenHeightFactor)))/dataArray.count+1);
    }
    else
    {
         heightCalculate = ((self.frame.size.height-yCoordinate-(5*(2*ScreenHeightFactor)))/6);
    }
   
    //yCoordinate+=10*ScreenFactor;
    for(NSDictionary *dictionary in dataArray)
    {
        if(i<5)
        {
            DelightTrendsItemView *dview = [[DelightTrendsItemView alloc]initWithFrame:CGRectMake(0,yCoordinate,self.frame.size.width,heightCalculate)];
            [dview setDelightTrendDelegate:(id)self];
            [dview drawUI:dictionary];
            [self addSubview:dview];
            yCoordinate += dview.frame.size.height+(2*ScreenHeightFactor);
        }
        i++;
    }
 
    [self moreActivitySetup:CGRectMake(0,yCoordinate,self.frame.size.width,heightCalculate) withArray:dataArray];
}

#pragma mark MoreActiviyRelatedFunction
-(void)moreActivitySetup:(CGRect)rect withArray:(NSArray *)arr
{
    MoreActivitiesInsight *view = [[MoreActivitiesInsight alloc]initWithFrame:rect];
    [view setInsightArray:arr];
    [view setDelegate:self];
    [view drawUI];
    [self addSubview:view];
}
-(void)touchBegan:(MoreActivitiesInsight *)moreActivityInsight
{
    NSLog(@"touchAtInsight MoreActivities");
    DelightTrendsFull_VC *delightView=[[DelightTrendsFull_VC alloc]init];
    [delightView setChildObj:self.childObj];
    [delightView setTabBarCtlr:self.tabBarCtlr];
   // delightView.hidesBottomBarWhenPushed=YES;
    [self.rootViewController.navigationController pushViewController:delightView animated:YES];
}


#pragma mark connection Specific Function
-(void)delightTrends
{
    NSArray *array=[[PC_DataManager sharedManager].serviceDictionary objectForKey:[NSString stringWithFormat:@"PinWiGetDelightTraitsByChildIDOnInsight-%@",self.childObj.child_ID]];
    
    if(array)
    {
         [self subjectRating:array];
    }
    else
    {
        GetDelightTraitsByChildIDOnInsight *delightTrends1= [[GetDelightTraitsByChildIDOnInsight alloc]init];
        [delightTrends1 setDelegate:self];
        [delightTrends1 setServiceName:PinWiGetDelightTraitsByChildIDOnInsight];
        [delightTrends1 initService:@{@"ChildID":_childObj.child_ID}];
        [self addLoaderView];
        [[InsightData insightData]updateConnectionArray:delightTrends1 isRemove:NO isAllRemove:NO];
    }
    
}
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    if([connection.serviceName isEqualToString:PinWiGetDelightTraitsByChildIDOnInsight])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetDelightTraitsByChildIDOnInsightResponse resultKey:PinWiGetDelightTraitsByChildIDOnInsightResult];
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)dict;
            NSLog(@"Value of %@",array);
            [self subjectRating:array];
            
            [[PC_DataManager sharedManager].serviceDictionary setObject:array forKey:[NSString stringWithFormat:@"PinWiGetDelightTraitsByChildIDOnInsight-%@",self.childObj.child_ID]];
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
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0,yy,self.frame.size.width,self.frame.size.height-yy)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}

#pragma mark Delight Trend
-(void)delightTrendtouched:(DelightTrendsItemView *)delight
{
    delight.alpha=1.0;
    DetailTrendsGraph_VC *detail=[[DetailTrendsGraph_VC alloc]init];
    [detail setChildObj:self.childObj];
    [detail setTabBarCtrl:self.tabBarCtlr];
    detail.dataDict=delight.dataDict;
    [self.rootViewController.navigationController pushViewController:detail animated:YES];
}

#pragma Strip information Delegate
-(void)stripInfoBtnTouch:(StripView *)stripView
{
    if(self.delightTrendDelegate)
    {
    [self.delightTrendDelegate stripInfoBtnTouch:@"Delight Trends" andIndex:2];
    }
}

@end
