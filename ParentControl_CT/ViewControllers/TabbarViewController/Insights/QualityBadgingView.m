//
//  QualityBadgingView.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "QualityBadgingView.h"
#import "StripView.h"
#import "Constant.h"
#import "PC_DataManager.h"
#import "ShowActivityLoadingView.h"
#import "InsightData.h"

@interface QualityBadgingView() <StripViewInfoprotocol>

@end

@implementation QualityBadgingView
{
    int yy;
    int xx;
    ShowActivityLoadingView *loaderView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawUi
{
    yy =0;
    StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,25*ScreenHeightFactor)];
    [stripView drawStrip:@"Quality Badge" color:[UIColor clearColor]];
    [stripView drawInfoIcon];
    [stripView setStripInfoDelegate:self];
    [self addSubview:stripView];
    yy+=stripView.frame.size.height;
    [self badgeService];
    //[self updateView:1];
}


-(void)updateView:(int)count
{
    [[PC_DataManager sharedManager]RatingList];
    NSString *imageName = [ratingListArray objectAtIndex:count-1];
    UIImageView *ratingView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(imageName)]];
    [ratingView setFrame:CGRectMake(0,0,ScreenFactor*70,ScreenFactor*70)];
    [ratingView setCenter:CGPointMake(ratingView.frame.size.width/2+20*ScreenWidthFactor,self.frame.size.height/2+yy/2)];
     ratingView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:ratingView];
    
     UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width*.5f,self.frame.size.height*.5)];
     label.textColor=[UIColor colorWithRed:109.0f/255 green:109.0f/255 blue:109.0f/255 alpha:1];
    [label setFont:[UIFont systemFontOfSize:8*ScreenFactor]];
    
    
    [[PC_DataManager sharedManager]InsightsArrays];
    NSString *str =[qualityBadgeArray objectAtIndex:count-1];
    
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    headLabel.textColor=[UIColor blackColor];
    [headLabel setFont:[UIFont systemFontOfSize:9*ScreenFactor]];
    headLabel.text=str;
    [headLabel sizeToFit];
   
    str =[NSString stringWithFormat:@" Based on the consistency and quality of rating data, this report is currently at Level %i. Level 5 reports are most realistic and reliable.",count];
     NSMutableAttributedString *yourString = [[NSMutableAttributedString alloc]initWithString:str];
    [yourString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(82,7)];
    [label setAttributedText:yourString];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    //[label sizeToFit];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setCenter:CGPointMake(self.frame.size.width*.7f, self.frame.size.height/2+(yy/2))];
     [headLabel setCenter:CGPointMake(label.center.x,label.frame.origin.y-headLabel.frame.size.height/2)];
    [self addSubview:headLabel];
    [self addSubview:label];
    
}

#pragma mark Connection Specific Function
-(void)badgeService
{
    GetInsightBatchDetailsByChildID *bagdeService = [[GetInsightBatchDetailsByChildID alloc]init];
    [bagdeService setDelegate:self];
    [bagdeService setServiceName:PinWiGetInsightBatchDetailsByChildID];
    [bagdeService initService:@{@"ChildID":_childProfileObj.child_ID}];
    [self addLoaderView];
    [[InsightData insightData]updateConnectionArray:bagdeService isRemove:NO isAllRemove:NO];
}
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    if([connection.serviceName isEqualToString:PinWiGetInsightBatchDetailsByChildID])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetInsightBatchDetailsByChildIDResponse resultKey:PinWiGetInsightBatchDetailsByChildIDResult];
        NSLog(@"Value of Dict =%@",dict);
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)dict;
            NSDictionary *data = [array firstObject];
            NSString *quality_badge = [NSString stringWithFormat:@"%@",[data valueForKey:@"Quality_Badge"]];
            if([quality_badge  isEqualToString:@"(null)"])
            {
               
                [self showAlertMessage:@"Alert" message:[data valueForKey:@"ErrorDesc"]];

            }
            else
            {
                [self updateView:quality_badge.intValue];
                [_dateLabel setAlpha:1.0f];
                _dateLabel.text = [NSString stringWithFormat:@"Report as on %@",[data valueForKey:@"CreatedOn"]];//[data valueForKey:@"CreatedOn"];
               
            }
          
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
    if(self.qualityBadgeDelegate)
    {
    [self.qualityBadgeDelegate stripInfoBtnTouch:@"Data Quality Badge" andIndex:0];
    }
   // [self showAlertMessage:@"Quality Badge" message:@"quality badge"];
}


@end
