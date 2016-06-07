//
//  InterestTraitsView.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InterestTraitsView.h"
#import "StripView.h"
#import "InterestCell.h"
#import "Constant.h"
#import "ShowActivityLoadingView.h"
#import "InsightData.h"
#import "InterestDriversFull_VC.h"
#import "PC_DataManager.h"

@interface InterestTraitsView() <InterestDriverProtocol,StripViewInfoprotocol>

@end


@implementation InterestTraitsView
{
    int yy;
    ShowActivityLoadingView *loaderView;
}
-(void)drawUi
{
    StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,ScreenHeightFactor*25)];
    [stripView drawStrip:@"Interest Drivers" color:[UIColor clearColor]];
    [stripView drawInfoIcon];
    [stripView setStripInfoDelegate:self];
    [self addSubview:stripView];
    yy += stripView.frame.size.height;
    [self interestTraits];
}
-(void)updateView:(NSArray *)dataArray
{
    
   NSString *title = nil;
   NSString *imageName = nil;
   float height = self.frame.size.height-yy;
    for(int i = 0 ;i<5 ;i++)
    {
        imageName = nil;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        UIColor *color = nil;
        switch (i)
        {
            case 0:
                title =@"Exhilarators";
                color  = ExhilaratorPurple;
                imageName = @"rightArrow.png";
            break;
                
            case 1:
                title =@"Amusers";
                 color  = AmusersRed;
                imageName = @"rightArrow.png";
            break;
                
            case 2:
                title =@"Unexciting";
                 color  = HoHummersOrange;
                 imageName = @"rightArrow.png";
            break;
                
//            case 3:
//                title =@"Non-Influencers";
//                color  = NonInfluencerGreen;
//                imageName = @"rightArrow.png";// @"insightLock.png";
//            break;
                
            case 4:
                title =@"Unexplored";
                color  = BlankstersGray;
                imageName = @"rightArrow.png";// @"insightLock.png";
            break;
        }
        
        for(NSDictionary *dictionary in dataArray)
        {
            if([[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"BucketID"]]isEqualToString:[NSString stringWithFormat:@"%i",i+1]])
            {
                if ([[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"BucketID"]] isEqualToString:@"4"]) {
                    break;
                }
                else{
                [array addObject:dictionary];
                }
            }
        }
        
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc]init];
        if (i == 3) {
            
        }
        else{
       
        [dictionary setValue:title forKey:@"title"];
        [dictionary setValue:array forKey:@"Array"];
        [dictionary setValue:imageName forKey:@"imageName"];
        [dictionary setValue:color forKey:@"Color"];
        //[dictionary setValue:[dictionary valueForKey:@"InterestTraitID"] forKey:@"InterestTraitID"];
        
        InterestCell *interestCell = [[InterestCell alloc]initWithFrame:CGRectMake(0,yy,self.frame.size.width,(self.frame.size.height-ScreenHeightFactor*25)/4)];
        [interestCell setInterestDriverDelegate:self];
        [interestCell drawUI:dictionary withColor:color];
        [interestCell setTag:i];
        [self addSubview:interestCell];
        yy+=interestCell.frame.size.height;
        }
    }
}
#pragma mark connection Specific Function
-(void)interestTraits
{
     NSArray *array=[[PC_DataManager sharedManager].serviceDictionary objectForKey:[NSString stringWithFormat:@"PinWiGetInterestTraitsByChildIDOnInsight-%@",self.childObj.child_ID]];
    
    if(array)
    {
        [self updateView:array];
    }
    else
    {
    GetInterestTraitsByChildIDOnInsight *interestTraits= [[GetInterestTraitsByChildIDOnInsight alloc]init];
    [interestTraits setDelegate:self];
    [interestTraits setServiceName:PinWiGetInterestTraitsByChildIDOnInsight];
    [interestTraits initService:@{@"ChildID":_childObj.child_ID}];
    [self addLoaderView];
    [[InsightData insightData]updateConnectionArray:interestTraits isRemove:NO isAllRemove:NO];
    }
}
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    if([connection.serviceName isEqualToString:PinWiGetInterestTraitsByChildIDOnInsight])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetInterestTraitsByChildIDOnInsightResponse resultKey:PinWiGetInterestTraitsByChildIDOnInsightResult];
        NSLog(@"Value of Dict =%@",dict);
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)dict;
           [self updateView:array];
            
            [[PC_DataManager sharedManager].serviceDictionary setObject:array forKey:[NSString stringWithFormat:@"PinWiGetInterestTraitsByChildIDOnInsight-%@",self.childObj.child_ID]];
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


#pragma mark INTEREST DRIVERS
-(void)interestDriverTouched:(InterestCell *)interestCell
{
    InterestDriversFull_VC *interestView=[[InterestDriversFull_VC alloc]init];
    [interestView setChildObj:self.childObj];
    [interestView setTabBarCtlr:self.tabBarCtlr];
    [interestView setDataDictionary:interestCell.dataDict];
    [interestView setTagVal:(int)interestCell.tag];
    // delightView.hidesBottomBarWhenPushed=YES;
    [self.rootViewController.navigationController pushViewController:interestView animated:YES];
}

#pragma Strip information Delegate
-(void)stripInfoBtnTouch:(StripView *)stripView
{
    if(self.interestTraitdelegate)
    {
        [self.interestTraitdelegate stripInfoBtnTouch:@"Interest Drivers" andIndex:1];
    }
//   UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Interest Drivers" message:@"interset drivers" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

@end
