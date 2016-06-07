//
//  PointsSummaryView.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "PointsSummaryView.h"
#import "StripView.h"
#import "PNPieChart.h"
#import "PNPieChartDataItem.h"
#import "Constant.h"
#import "PointSummaryViewItem.h"
#import "ShowActivityLoadingView.h"
#import "InsightData.h"
#import "PC_DataManager.h"

@interface PointsSummaryView() <StripViewInfoprotocol>

@end

@implementation PointsSummaryView
{
    int yy;
    ShowActivityLoadingView *loaderView;
    
}
-(void)drawUi
{
    StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,ScreenHeightFactor*25)];
    [stripView drawStrip:@"Points Summary" color:[UIColor clearColor]];
    [stripView drawInfoIcon];
    [stripView setStripInfoDelegate:self];
    [self addSubview:stripView];
    yy += stripView.frame.size.height;
    [self pointInfoService];
    //[self drawCircle:nil];
}

-(void)drawCircle:(NSDictionary *)dict
{
    int total = ([[dict valueForKey:@"EarnedPoints"]intValue]+[[dict valueForKey:@"LostPoints"]floatValue]+[[dict valueForKey:@"PendingPoints"]floatValue]);
//    int earnedPercentValue=[[dict valueForKey:@"EarnedPoints"]floatValue]/total;
//    int lostPercentValue=[[dict valueForKey:@"LostPoints"]floatValue]/total;
//    int pendingPercentValue=[[dict valueForKey:@"PendingPoints"]floatValue]/total;
    
    
    UIColor *greenColor = [UIColor colorWithRed:109.0/255.0f green:155.0f/255.0f blue:57.0/255.0f alpha:1.0f];
    
    UIColor *redColor = [UIColor colorWithRed:255.0/255.0f green:0.0f/255.0f blue:0.0/255.0f alpha:1.0f];
    
    UIColor *orangeColor = [UIColor colorWithRed:255.0/255.0f green:179.0f/255.0f blue:1.0/255.0f alpha:1.0f];
    
    if(total==0)
    {
        total=1;
    }
    float eP=[[dict valueForKey:@"EarnedPoints"]floatValue]*100;
    float lP=[[dict valueForKey:@"LostPoints"]floatValue]*100;
    float pP=[[dict valueForKey:@"PendingPoints"]floatValue]*100;
    
//    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:eP/total color:greenColor],
//                       [PNPieChartDataItem dataItemWithValue:lP/total color:redColor],
//                       [PNPieChartDataItem dataItemWithValue:pP/total color:orangeColor],
//
//    ];
    NSMutableArray *items=[[NSMutableArray alloc]init];
    if(eP==0 && lP==0 && pP==0)
    {
     [items addObject:[PNPieChartDataItem dataItemWithValue:100 color:activityHeading1Code]];

    }
    else{
        if(eP!=0)
        {
            [items addObject:[PNPieChartDataItem dataItemWithValue:eP/total color:greenColor]];
        }
        if(lP!=0)
        {
            [items addObject:[PNPieChartDataItem dataItemWithValue:lP/total color:redColor]];
        }
            if(pP!=0)
        {
            [items addObject:[PNPieChartDataItem dataItemWithValue:pP/total color:orangeColor]];
        }
    }
    
    
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(15*ScreenWidthFactor,0,self.frame.size.height*.7f,self.frame.size.height*.7f) items:items];
    pieChart.descriptionTextColor = [UIColor clearColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0*ScreenFactor];
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    pieChart.showAbsoluteValues = NO;
    pieChart.showOnlyValues = NO;
    [pieChart strokeChart];
    [pieChart setCenter:CGPointMake(pieChart.center.x, self.frame.size.height/2+(yy/2))];
    
    pieChart.legendStyle = PNLegendItemStyleStacked;
    pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    [self addSubview:pieChart];
    
    int width = 150*ScreenWidthFactor;
    int height = 25*ScreenHeightFactor;
    int  initialY = 0;
    
    int center =(self.frame.size.height/3);//-(3*ScreenFactor)-(yy/2);
    
    NSString *percentage    = nil;
    NSString *title         = nil;
    NSString *points        = nil;
    UIImage  *imageNm       = nil;
    UIColor *color = [UIColor clearColor];
    
    for(int i = 0 ; i<3 ;i++)
    {
        percentage  = nil;
        title  = nil;
        color = [UIColor clearColor];;
        points = @"0.0";
        switch (i)
        {
           
            case 0:
                
                percentage =[NSString stringWithFormat:@"%d%@",(int)roundf([[dict valueForKey:@"EarnedPoints"]floatValue]*100/total),@"%"];
                title = @"Earned:";
                color  = greenColor;
                imageNm=[UIImage imageNamed:isiPhoneiPad(@"earnedCup.png")];
                if(![percentage isEqualToString:@"0%"])
                {
                   points  = [NSString stringWithFormat:@"%@",[dict valueForKey:@"EarnedPoints"]];
//                    float percentage_Points  = str.floatValue;
//                    points = [NSString stringWithFormat:@"%0.01f",(_childObj.earnedPts.floatValue * (percentage_Points))];
                }
            break;
                
            case 1:
                percentage =[NSString stringWithFormat:@"%d%@",(int)roundf([[dict valueForKey:@"PendingPoints"]floatValue]*100/total),@"%"];
                title = @"Pending:";
                color  = orangeColor;
                imageNm=[UIImage imageNamed:isiPhoneiPad(@"pendingCup.png")];
                if(![percentage isEqualToString:@"0%"])
                {
                    /* NSString *str*/points  = [NSString stringWithFormat:@"%@",[dict valueForKey:@"PendingPoints"]];
                    //                    float percentage_Points  = str.floatValue;
                    //                    points = [NSString stringWithFormat:@"%0.01f",(_childObj.pendingPts.floatValue * (percentage_Points))];
                }
            break;
                
            case 2:
                percentage =[NSString stringWithFormat:@"%d%@",(int)roundf([[dict valueForKey:@"LostPoints"]floatValue]*100/total),@"%"];
                title = @"Lost:";
                color  = redColor;
                imageNm=[UIImage imageNamed:isiPhoneiPad(@"lostPt.png")];
                if(![percentage isEqualToString:@"0%"])
                {
                    points = [NSString stringWithFormat:@"%@",[dict valueForKey:@"LostPoints"]];
                }
            break;
                
        }
        
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc]init];
        [dictionary setValue:percentage forKey:@"percentage"];
        [dictionary setValue:title forKey:@"title"];
        [dictionary setValue:points forKey:@"points"];
        
        PointSummaryViewItem *pointSummaryViewitem  = [[PointSummaryViewItem alloc]initWithFrame:CGRectMake(pieChart.frame.origin.x+pieChart.frame.size.width+50*ScreenWidthFactor,center+initialY,width,height)];
        [pointSummaryViewitem drawUI:dictionary withBoxColor:color withImage:imageNm];
        
        [pointSummaryViewitem setCenter:CGPointMake(self.frame.size.width- pointSummaryViewitem.frame.size.width/2,pointSummaryViewitem.center.y)];
        
        [self addSubview:pointSummaryViewitem];
        initialY += pointSummaryViewitem.frame.size.height+(15*ScreenHeightFactor);
    }
   
}
#pragma mark Connection Specific Function
-(void)pointInfoService
{
    GetPointsInfoByChildIDOnInsights *pointInfo = [[GetPointsInfoByChildIDOnInsights alloc]init];
    [pointInfo setDelegate:self];
    [pointInfo setServiceName:PinWiGetPointsInfoByChildIDOnInsights];
    [pointInfo initService:@{@"ChildID":_childObj.child_ID}];
    [self addLoaderView];
    [[InsightData insightData]updateConnectionArray:pointInfo isRemove:NO isAllRemove:NO];
}
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    if([connection.serviceName isEqualToString:PinWiGetPointsInfoByChildIDOnInsights])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetPointsInfoByChildIDOnInsightsResponse resultKey:PinWiGetPointsInfoByChildIDOnInsightsResult];
        NSLog(@"Value of Dict =%@",dict);
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)dict;
            NSDictionary *data = [array firstObject];
            [self drawCircle:data];
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
-(void)showAlertMessage:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
    
}

#pragma Strip information Delegate
-(void)stripInfoBtnTouch:(StripView *)stripView
{
   if(self.pointsSummaryDelegate)
   {
       [self.pointsSummaryDelegate stripInfoBtnTouch:@"Points Summary" andIndex:3];
   }
}

@end
