//
//  InterestTraitsView.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InterestPatternView.h"
#import "StripView.h"
#import "InterestPatternCell.h"
#import "Constant.h"
#import "ShowActivityLoadingView.h"
#import "InsightData.h"
#import "PC_DataManager.h"

@implementation InterestPatternView
{
    int yy;
    ShowActivityLoadingView *loaderView;
}
-(void)drawUi
{
    StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,ScreenFactor*30)];
    [stripView drawStrip:@"Interest Pattern" color:[UIColor clearColor]];
    [self addSubview:stripView];
    yy += stripView.frame.size.height;
    [self interestTraits];
}
-(void)updateView:(NSArray *)dataArray
{
    
   NSString *title = nil;
   NSString *imageName = nil;
   NSString *titleImage=nil;
   float height = self.frame.size.height-yy;
    for(int i = 0 ;i<5 ;i++)
    {
        imageName = nil;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        UIColor *color = nil;
        switch (i)
        {
            case 0:
                title =@"LONG HELD";
                color  = buttonGreenColor;
                imageName = @"lock_gray.png";
                titleImage=@"long-held.png";
                
            break;
            case 1:
                title =@"FOUND";
                 color  = AmusersRed;
                imageName = @"lock_gray.png";
               titleImage=@"newPattern.png";
            break;
                
            case 2:
                title =@"SEE-SAW";
                 color  = radiobuttonSelectionColor;
                 imageName = @"lock_gray.png";
                titleImage=@"seeSaw.png";
            break;
                
        }
        
        for(NSDictionary *dictionary in dataArray)
        {
            if([[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"BucketID"]]isEqualToString:[NSString stringWithFormat:@"%i",i+1]])
            {
                [array addObject:dictionary];
            }
        }
        
        NSMutableDictionary *dictionary =[[NSMutableDictionary alloc]init];
        [dictionary setValue:title forKey:@"title"];
        [dictionary setValue:array forKey:@"Array"];
        [dictionary setValue:imageName forKey:@"imageName"];
         [dictionary setValue:titleImage forKey:@"titleImage"];
        
        InterestPatternCell *interestCell = [[InterestPatternCell alloc]initWithFrame:CGRectMake(0,yy,self.frame.size.width,(self.frame.size.height-ScreenFactor*30)/3)];
        [interestCell drawUI:dictionary withColor:color];
        [self addSubview:interestCell];
        yy+=interestCell.frame.size.height;
    }
}
#pragma mark connection Specific Function
-(void)interestTraits
{
    GetInterestTraitsByChildIDOnInsight *interestTraits= [[GetInterestTraitsByChildIDOnInsight alloc]init];
    [interestTraits setDelegate:self];
    [interestTraits setServiceName:PinWiGetInterestTraitsByChildIDOnInsight];
    [interestTraits initService:@{@"ChildID":_childObj.child_ID}];
    [self addLoaderView];
    [[InsightData insightData]updateConnectionArray:interestTraits isRemove:NO isAllRemove:NO];
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
