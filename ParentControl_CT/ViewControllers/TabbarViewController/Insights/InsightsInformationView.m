//
//  InsightsInformationView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 27/10/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import "InsightsInformationView.h"
#import "Constant.h"
#import "PC_DataManager.h"

@implementation InsightsInformationView
{
    UIScrollView *scrollView;
    int yy;
    int yCord;
    NSArray *dataArray;
}
-(id)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame])
    {
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawUi:(NSString *)head andIndex:(int)index
{
    self.backgroundColor=[UIColor whiteColor];
    self.layer.borderWidth=1.0f;
    self.layer.borderColor=[cellTextColor colorWithAlphaComponent:0.3].CGColor;
    self.layer.cornerRadius=self.frame.size.height/10;
    self.clipsToBounds = YES;
    yy=0;
    yCord=0;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, yy, self.frame.size.width,ScreenHeightFactor*30)];
    label.textColor=[UIColor blackColor];
    [label setFont:[UIFont systemFontOfSize:9.0*ScreenFactor]];
    [label setText:head];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
    
    yy+=label.frame.size.height+5*ScreenHeightFactor;
    
    [[PC_DataManager sharedManager]InsightsArrays];
    dataArray=[insightsInfoArray objectAtIndex:index];
    if(!scrollView)
    {
        scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.frame.size.width,self.frame.size.height-65*ScreenHeightFactor)];
        [scrollView setPagingEnabled:NO];
        [scrollView setScrollEnabled:NO];
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:scrollView];
        yy+=scrollView.frame.size.height;
        
        for(NSString *str in dataArray)
        {
            [self addElements:str andIndex:index];
        }
    }
    
    if(yCord>ScreenHeightFactor*130)
    {
        [scrollView setScrollEnabled:YES];
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, yCord)];
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Ok" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:RobotoRegular size:9*ScreenFactor]];
    [button setTitleColor:textBlueColor forState:UIControlStateNormal];
    button.backgroundColor=[UIColor clearColor];
    button.layer.borderColor = [cellTextColor colorWithAlphaComponent:0.3].CGColor;
    button.layer.borderWidth = 1.0;
    [button setFrame:CGRectMake(0,self.frame.size.height-ScreenHeightFactor*30, self.frame.size.width, ScreenHeightFactor*30)];
    [button setCenter:CGPointMake(self.frame.size.width/2, button.center.y)];
    [button addTarget:self action:@selector(touchAtOkButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void)addElements:(NSString*)data andIndex:(int)index
{
    int xx=cellPadding;
    UIImageView *tickView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"")]];
    [tickView setFrame:CGRectMake(xx,yCord+ScreenHeightFactor*5,ScreenWidthFactor*5,ScreenWidthFactor*5)];
    tickView.layer.cornerRadius = tickView.frame.size.width/2;
    tickView.backgroundColor = [UIColor blackColor];
    tickView.clipsToBounds = YES;
    tickView.contentMode=UIViewContentModeScaleAspectFit;
    [scrollView addSubview:tickView];
    
    
    xx+=tickView.frame.size.width+5*ScreenWidthFactor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xx,yCord,scrollView.frame.size.width-xx-cellPadding,ScreenWidthFactor*60)];
    label.textColor=[UIColor blackColor];
    [label setFont:[UIFont systemFontOfSize:7.0*ScreenFactor]];
    NSString *str =data;
    [label setText:str];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label sizeToFit];
    [label setTextAlignment:NSTextAlignmentLeft];
    [scrollView addSubview:label];
    //[tickView setCenter:CGPointMake(tickView.center.x, label.frame.origin.y+)];
    
    yCord+=label.frame.size.height+10*ScreenHeightFactor;

}

-(void)touchAtOkButton:(id)sender
{
    if(self.infoDeledgate)
    {
        [self.infoDeledgate removeInformationView];
    }
}

@end
