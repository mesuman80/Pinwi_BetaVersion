//
//  InsightView.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 06/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "NotificationView.h"
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
#import "GetNotificationListByParentID.h"
#import "ShowActivityLoadingView.h"
#import "InsightData.h"
#import "NotificationViewItem.h"
#import "NotificationDetail_VC.h"

@interface NotificationView() <UrlConnectionDelegate,NotificationProtocol>

@end

@implementation NotificationView
{
    UIScrollView *scrollView;
    int yy;
    int yCord;
    UILabel *dateLabel;
    ShowActivityLoadingView *loaderView;
     RedLabelView *label;
}
@synthesize rootviewController;
#pragma mark Intiliase Specific Function
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor=appBackgroundColor;
        return self;
    }
    return nil;
}

#pragma mark DrawUISpecificFunction
-(void)drawChildName
{
    
   
    if(screenWidth>700)
    {
        label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
        //label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:self.childObj.nick_Name];
        //label.center=CGPointMake(screenWidth/2,label.frame.size.height/2+10*ScreenHeightFactor);
    }
    else
    {
        label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];

        //        label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:self.childObj.nick_Name];
        //label.center=CGPointMake(screenWidth/2,label.frame.size.height/2);
    }
    
    [self addSubview:label];
    
    yy += label.frame.size.height + label.frame.origin.y+ ScreenHeightFactor*10;
    
   // [self drawScrollView];
    
}


#pragma mark ScrollViewSpecificFunction
-(void)drawScrollView
{
    
    if(label|| scrollView)
    {
        [label removeFromSuperview];
        label=nil;
        [scrollView removeFromSuperview];
        scrollView =nil;
    }
    
    
    [self drawChildName];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.frame.size.width, self.frame.size.height-yy+3*ScreenHeightFactor)];
    [scrollView setPagingEnabled:NO];
    [scrollView setScrollEnabled:NO];
    [scrollView setBackgroundColor:appBackgroundColor];
    [self addSubview:scrollView];

    
    yCord+=20*ScreenFactor;
    //  reduceYY +=(subscribeView.frame.size.height + initialY);
    
    [self getNotofications];
    
    [scrollView setContentSize:CGSizeMake(0, yy)];
}

-(void)drawUI:(NSArray*)array
{

    NSDictionary *dict1=[array firstObject];
    if([[dict1 objectForKey:@"ErrorDesc"]isEqualToString:@"No Notification found."])
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"No new notifications" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
       UILabel *label1=[[UILabel alloc]init];
        label1.numberOfLines=0;
        label1.lineBreakMode=YES;
        NSString *str=@"You have no notifications at the moment.";
        label1.textAlignment=NSTextAlignmentCenter;
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:35*ScreenHeightFactor]}];
        label1.font=[UIFont fontWithName:RobotoBold size:11*ScreenHeightFactor];
        label1.text=str;
        label1.frame=CGRectMake(cellPadding,yCord,screenWidth-2*cellPadding,size.height);
        label1.textColor=[UIColor lightGrayColor];
        label1.center=CGPointMake(screenWidth/2,scrollView.frame.size.height*.4);
        [scrollView addSubview:label1];
        
        return;
    }
    yCord=10*ScreenHeightFactor;;
    [[PC_DataManager sharedManager]NotificationList];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, yCord-1*ScreenHeightFactor, self.frame.size.width, 1*ScreenHeightFactor)];
    [lineView setBackgroundColor:cellBlackColor_2];
    [scrollView addSubview:lineView];
    for(NSDictionary *dict in array)
    {
        NotificationViewItem *notification=[[NotificationViewItem alloc]initWithFrame:CGRectMake(0, yCord, screenWidth, ScreenHeightFactor*70)];
        [notification setChildObject:self.childObj];
        [notification setNotificationDelegate:self];
        [notification drawUI:dict];
        [scrollView addSubview:notification];
    
        yCord+=notification.frame.size.height;
    }
    if(yCord>screenHeight-yy)
    {
        [scrollView setScrollEnabled:YES];
        [scrollView setContentSize:CGSizeMake(0, yCord)];
    }
}
#pragma mark notificationDelegate
-(void)notificationTouch:(NotificationViewItem *)notification
{
    NotificationDetail_VC *notiDetail=[[NotificationDetail_VC alloc]init];
    notiDetail.dataDict=notification.dataDict;
    notiDetail.childObj=notification.childObject;
    
    
    NSLog(@"vc  %@", self.rootviewController);
    
    [self.rootviewController.navigationController pushViewController:notiDetail animated:YES];
}


#pragma mark connection Specific Function
-(void)getNotofications
{
    NSArray *array=[[PC_DataManager sharedManager].serviceDictionary objectForKey:[NSString stringWithFormat:@"PinWiGetNotificationListByParentID"]];
    
    if(array)
    {
        [self drawUI:array];
    }
    else
    {
        GetNotificationListByParentID *interestTraits= [[GetNotificationListByParentID alloc]init];
        [interestTraits setDelegate:self];
        [interestTraits setServiceName:PinWiGetNotificationListByParentID];
        [interestTraits initService:@{@"ParentID":[PC_DataManager sharedManager].parentObjectInstance.parentId}];
        [self addLoaderView];
        [[InsightData insightData]updateConnectionArray:interestTraits isRemove:NO isAllRemove:NO];
    }
}
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    if([connection.serviceName isEqualToString:PinWiGetNotificationListByParentID])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetNotificationListByParentIDResponse resultKey:PinWiGetNotificationListByParentIDResult];
        NSLog(@"Value of Dict =%@",dict);
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)dict;
            [self drawUI:array];
            
            [[PC_DataManager sharedManager].serviceDictionary setObject:array forKey:[NSString stringWithFormat:@"PinWiGetNotificationListByParentID"]];
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


@end
