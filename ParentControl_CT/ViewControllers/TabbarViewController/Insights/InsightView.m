//
//  InsightView.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 06/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InsightView.h"
#import "ChildProfileObject.h"
#import "Constant.h"
#import "RedLabelView.h"
#import "PC_DataManager.h"
#import "QualityBadgingView.h"
#import "InterestTraitsView.h"
#import "DelightTrendsView.h"
#import "PointsSummaryView.h"
#import "SubscribeButtonView.h"
#import "InterestPatternView.h"
#import "InsightsBenefit_VC.h"
#import "InsightsInformationView.h"
#import "InsightReportActiveStatus.h"
#import "InsightData.h"
#import "ShowActivityLoadingView.h"
#import "InsightsStaticView.h"

@interface InsightView() <SubscribeButtonViewDelegate,QualityBadgeProtocol,InformationProtocol>

@end

@implementation InsightView
{
    UIScrollView *scrollView;
    int yy;
    UILabel *dateLabel;
    SubscribeButtonView *subscribeView;
    ShowActivityLoadingView *loaderView;
    InsightsInformationView *informationView;
}

#pragma mark Intiliase Specific Function
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
    
        return self;
    }
    return nil;
}

#pragma mark DrawUISpecificFunction
-(void)drawUI:(ChildProfileObject *)childObj
{
    if(![childObj.lastName isEqualToString:@"(null)"])
    {
        NSLog(@"childObj.lastName = %@",childObj.lastName);
       [self drawChildName:[NSString stringWithFormat:@"%@",childObj.nick_Name]];
    }
    else
    {
         [self drawChildName:childObj.nick_Name];
    }
    [self setChildObj:childObj];
    [self getInsightsStatus];
    //[self drawScrollView:childObj];
    
}
-(void)drawChildName:(NSString *)childName
{
//    if(childName.length>6)
//    {
//        childName = [childName substringToIndex:5];
//        childName = [childName stringByAppendingString:@".."];
//    }
    
    RedLabelView *label;
    if(screenWidth>700)
    {
       label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:childName];
        label.center=CGPointMake(screenWidth/2,label.frame.size.height/2+10*ScreenHeightFactor);
    }
    else
    {
        label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:childName];
        label.center=CGPointMake(screenWidth/2,label.frame.size.height/2);
    }
    
    [self addSubview:label];
    
    NSDate *currentDate  = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd MMM, yyyy"];
    NSString *dateString = [dateFormat stringFromDate:currentDate];
    dateString= [NSString stringWithFormat:@"Report as on %@",dateString];
    dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    dateLabel.text = dateString;//[NSString stringWithFormat:@"Report as on %@",dateString];
    dateLabel.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    dateLabel.font = [UIFont fontWithName:RobotoRegular size:7.0f*ScreenFactor];
    CGSize dateLabelSize = [dateLabel.text sizeWithAttributes:@{NSFontAttributeName:dateLabel.font}];
   // [dateLabel setFrame:CGRectMake(0,0, dateLabelSize.width, dateLabelSize.height+2*ScreenHeightFactor)];
    
//    if(screenWidth>700)
//    {
         [dateLabel setFrame:CGRectMake(0,0, dateLabelSize.width+3*ScreenWidthFactor, dateLabelSize.height+2*ScreenHeightFactor)];
      
//    }
    [dateLabel setCenter:CGPointMake(self.frame.size.width*.8f,label.center.y)];
    [dateLabel setAlpha:0.0f];
    
    [self addSubview:dateLabel];
    
    yy += label.frame.size.height + label.frame.origin.y + ScreenHeightFactor*10;

}
#pragma mark URL Connections
-(void)getInsightsStatus
{
    NSString *insightStatusStr=[NSString stringWithFormat:@"%@-%@",PinWiInsightReportActiveStatus,self.childObj.child_ID];
    NSDictionary *dict=[[PC_DataManager sharedManager].serviceDictionary objectForKey:insightStatusStr];
    if(dict)
    {
        [self drawScrollView:dict];
    }
    else
    {
        InsightReportActiveStatus *insightsAct=[[InsightReportActiveStatus alloc]init];
        [insightsAct initService:@{
                                   @"ParentID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                   @"ChildID":self.childObj.child_ID
                                   }];
        [insightsAct setDelegate:(id)self];
        [insightsAct setServiceName:PinWiInsightReportActiveStatus];
        [self addLoaderView];
        [[InsightData insightData]updateConnectionArray:insightsAct isRemove:NO isAllRemove:NO];
    }
}
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    if([connection.serviceName isEqualToString:PinWiInsightReportActiveStatus])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiInsightReportActiveStatusResponse resultKey:PinWiInsightReportActiveStatusResult];
        NSLog(@"Value of Dict =%@",dict);
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)dict;
            NSDictionary *data = [array firstObject];
            [self drawScrollView:data];
            NSString *insightStatusStr=[NSString stringWithFormat:@"%@-%@",PinWiInsightReportActiveStatus,self.childObj.child_ID];
            [[PC_DataManager sharedManager].serviceDictionary setObject:data forKey:insightStatusStr];
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

#pragma mark Loader View
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


#pragma mark ScrollViewSpecificFunction
-(void)drawScrollView:(NSDictionary *)data
{
    if([[NSString stringWithFormat:@"%@",[data objectForKey:@"Status"]]isEqualToString:@"0"])
    {
        InsightsStaticView *staticView=[[InsightsStaticView alloc]initWithFrame:CGRectMake(0,yy, self.frame.size.width, self.frame.size.height-yy+3*ScreenHeightFactor)];
        [staticView drawStaticUI];
        [self addSubview:staticView];
    }
    else
    {
     scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.frame.size.width, self.frame.size.height-yy+3*ScreenHeightFactor)];
     [scrollView setPagingEnabled:NO];
     [self addSubview:scrollView];
    
     yy = 0;
    
    QualityBadgingView *badgeView = [[QualityBadgingView alloc]initWithFrame:CGRectMake(0,yy,scrollView.frame.size.width,170*ScreenHeightFactor)];
    [badgeView setQualityBadgeDelegate:self];
    [badgeView setChildProfileObj:self.childObj];
    [badgeView setDateLabel:dateLabel];
    [badgeView setUserInteractionEnabled:YES];
    [badgeView setBackgroundColor:[UIColor whiteColor]];
    [badgeView drawUi];
    [scrollView addSubview:badgeView];
    
    yy +=badgeView.frame.size.height;
    
    InterestTraitsView *interestTraitsView = [[InterestTraitsView alloc]initWithFrame:CGRectMake(0,yy,scrollView.frame.size.width,300*ScreenHeightFactor)];
    [interestTraitsView setInterestTraitdelegate:(id)self];
    [interestTraitsView setRootViewController:self.rootViewController];
    [interestTraitsView setChildObj:self.childObj];
    [interestTraitsView setTabBarCtlr:self.tabBarCtlr];
    [interestTraitsView setBackgroundColor:[UIColor whiteColor]];
    [interestTraitsView drawUi];
    [scrollView addSubview:interestTraitsView];
    
    yy +=interestTraitsView.frame.size.height;
    
  /*  InterestPatternView *interestPatternView = [[InterestPatternView alloc]initWithFrame:CGRectMake(0,yy,scrollView.frame.size.width,201*ScreenFactor)];
    [interestPatternView setChildObj:childObj];
    [interestPatternView setBackgroundColor:[UIColor whiteColor]];
    [interestPatternView drawUi];
    [scrollView addSubview:interestPatternView];
    
    yy +=interestPatternView.frame.size.height;*/
    
    DelightTrendsView *delightTrends = [[DelightTrendsView alloc]initWithFrame:CGRectMake(0,yy,scrollView.frame.size.width,300*ScreenHeightFactor)];
    [delightTrends setDelightTrendDelegate:(id)self];
    [delightTrends setChildObj:self.childObj];
    [delightTrends setRootViewController:self.rootViewController];
    [delightTrends setBackgroundColor:[UIColor whiteColor]];
    [delightTrends setTabBarCtlr:self.tabBarCtlr];
    [delightTrends drawUi];
    [scrollView addSubview:delightTrends];
    yy +=delightTrends.frame.size.height;
    
    PointsSummaryView *pointSummary = [[PointsSummaryView alloc]initWithFrame:CGRectMake(0,yy,scrollView.frame.size.width,200*ScreenHeightFactor)];
    [pointSummary setPointsSummaryDelegate:(id)self];
    [pointSummary setChildObj:self.childObj];
    [pointSummary setBackgroundColor:[UIColor whiteColor]];
    [pointSummary drawUi];
    [scrollView addSubview:pointSummary];
        
     yy +=pointSummary.frame.size.height;
    
        if(screenWidth>700)
        {
             yy +=pointSummary.frame.size.height*.2;
        }
    
//        subscribeView = [[SubscribeButtonView alloc]initWithFrame:CGRectMake(0,yy,scrollView.frame.size.width,ScreenHeightFactor*100)];
//        [subscribeView setDelegate:self];
//        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
//        [dictionary setValue:@"Interested in more Insights?" forKey:@"labelStr"];
//        [dictionary setValue:@"Subscribe Now" forKey:@"buttonStr"];
//        [subscribeView drawUI:dictionary];
//        [subscribeView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewContentModeBottom];
//        [scrollView addSubview:subscribeView];
//    
//    if(screenWidth>700)
//    {
//        yy+=subscribeView.frame.size.height*1.39f;
//    }
//    else
//    {
//        yy+=subscribeView.frame.size.height;
//    }
        //  reduceYY +=(subscribeView.frame.size.height + initialY);
    

    
    [scrollView setContentSize:CGSizeMake(0, yy)];
    }
}


-(void)touchAtSubscribe:(SubscribeButtonView *)subscribeButton
{
//
//    InsightsBenefit_VC *insightBenefit=[[InsightsBenefit_VC alloc]init];
//    [insightBenefit setChildObj:self.childObj];
//    [insightBenefit setTabBarCtlr:self.tabBarCtlr];
//   // [insightBenefit setDataDictionary:interestCell.dataDict];
//    // delightView.hidesBottomBarWhenPushed=YES;
//    [self.rootViewController.navigationController pushViewController:insightBenefit animated:YES];

}

-(void)stripInfoBtnTouch:(NSString*)head andIndex:(int)tagNumber
{
    scrollView.alpha=0.1;
    scrollView.userInteractionEnabled=NO;
    switch (tagNumber) {
        case 0:
        case 1:
            informationView=[[InsightsInformationView alloc]initWithFrame:CGRectMake(cellPadding*2, ScreenHeightFactor*100, screenWidth-cellPadding*4, ScreenHeightFactor*250)];
            break;
            
        case 2:
            informationView=[[InsightsInformationView alloc]initWithFrame:CGRectMake(cellPadding*2, ScreenHeightFactor*100, screenWidth-cellPadding*4, ScreenHeightFactor*180)];
            break;
        
        case 3:
            informationView=[[InsightsInformationView alloc]initWithFrame:CGRectMake(cellPadding*2, ScreenHeightFactor*100, screenWidth-cellPadding*4, ScreenHeightFactor*270)];
            break;
        
        default:
            informationView=[[InsightsInformationView alloc]initWithFrame:CGRectMake(cellPadding*2, ScreenHeightFactor*100, screenWidth-cellPadding*4, ScreenHeightFactor*250)];
            break;
    }
    
    informationView.infoDeledgate=self;
    [informationView drawUi:head andIndex:tagNumber];
    [self addSubview:informationView];
}
-(void)removeInformationView
{
    [informationView removeFromSuperview];
    [scrollView setAlpha:1.0];
    [scrollView setUserInteractionEnabled:YES];
}


@end
