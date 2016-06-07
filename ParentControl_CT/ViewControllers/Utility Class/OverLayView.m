//
//  OverLayView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 08/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "OverLayView.h"
#import "PC_DataManager.h"

@implementation OverLayView
{
    UIView *goAheadView;
    NSString *information;
    NSString *buttonName;
    BOOL isFromConfirmScreen;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame withInfoText:(NSString*)info AndButtonText:(NSString*)buttonTitle
{
    if(self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor whiteColor];
        information=info;
        buttonName=buttonTitle;
        isFromConfirmScreen = NO;
        [self drawLabelView];
        [self drawButton];
        self.frame=frame;
        //[self overLay];
        return self;
    }
    return nil;
}

-(id)initWithFrame:(CGRect)frame withInfoText:(NSString*)info AndButtonText:(NSString*)buttonTitle withHEading:(NSString *)headingStr
{
    if(self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor whiteColor];
        information=info;
        buttonName=buttonTitle;
        isFromConfirmScreen = YES;
        [self drawHeading:headingStr];
        [self drawLabelView];
        [self drawButton];
        self.frame=frame;
        //[self overLay];
        return self;
    }
    return nil;
}

-(void)overLay
{
    goAheadView=[[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.width, screenWidth, self.frame.size.height)];
    [self addSubview:goAheadView];
    goAheadView.backgroundColor=[UIColor whiteColor];
}


-(void)drawHeading:(NSString *)str
{
    UILabel *label=[[UILabel alloc]init];
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:23*ScreenHeightFactor]}];
    label.font=[UIFont systemFontOfSize:23*ScreenHeightFactor weight:0.5f];
    label.font=[UIFont fontWithName:RobotoRegular size:23*ScreenHeightFactor];
    label.numberOfLines=0;
    label.text=str;
    
    label.frame=CGRectMake(cellPaddingReg,self.frame.size.height*.05,screenWidth-2*cellPaddingReg,displayValueSize.height);
    label.textAlignment=NSTextAlignmentCenter;
    [label sizeToFit];
    label.center=CGPointMake(self.frame.size.width*.5, label.center.y);
    NSLog(@"FRAME = %f..... %f",self.frame.size.width,self.frame.size.height);
    NSLog(@"FRAME = %f..... %f",label.center.x,label.center.y);
    label.textColor=[UIColor blackColor];
    //
    [self addSubview:label];
    

}
-(void)drawLabelView
{
    UILabel *label=[[UILabel alloc]init];
    CGSize displayValueSize = [information sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ScreenHeightFactor]}];
    label.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    label.numberOfLines=0;
    label.text=information;
    
    if(isFromConfirmScreen)
    {
        label.frame=CGRectMake(cellPaddingReg,self.frame.size.height*.3,screenWidth-2*cellPaddingReg,displayValueSize.height);
        
    }
    else
    {
        label.frame=CGRectMake(cellPaddingReg,self.frame.size.height*.3,screenWidth-2*cellPaddingReg,displayValueSize.height);
        
    }
    label.textAlignment=NSTextAlignmentCenter;
    [label sizeToFit];
    label.center=CGPointMake(self.frame.size.width*.5, label.center.y);
    NSLog(@"FRAME = %f..... %f",self.frame.size.width,self.frame.size.height);
     NSLog(@"FRAME = %f..... %f",label.center.x,label.center.y);
    label.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.6f];
  //
    [self addSubview:label];
    
}

-(void)drawButton
{
    UIButton *continueButton=[UIButton buttonWithType:UIButtonTypeSystem];
     continueButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.023*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [continueButton setTitle:buttonName forState:UIControlStateNormal];
    continueButton.tintColor=[UIColor blackColor];
    continueButton.backgroundColor=buttonGreenColor;
    [continueButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
   
    [continueButton sizeToFit];
    continueButton.frame=CGRectMake(cellPaddingReg,0,self.frame.size.width-cellPaddingReg*2,screenHeight*.07);
    continueButton.center=CGPointMake(self.frame.size.width*.5,self.frame.size.height-continueButton.frame.size.height-5*ScreenHeightFactor);
    NSLog(@"FRAME = %f..... %f",self.frame.size.width,self.frame.size.height);
    NSLog(@"FRAME = %f..... %f",continueButton.center.x,continueButton.center.y);
    [continueButton addTarget:self action:@selector(continueBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:continueButton];

}

-(void)continueBtnTouched
{
    
    [self.overLayDelegate continueTouched];
    [self removeFromSuperview];
}



@end
