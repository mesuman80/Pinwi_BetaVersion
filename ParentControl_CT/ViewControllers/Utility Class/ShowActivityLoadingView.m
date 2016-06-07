//
//  ShowActivityLoadingView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 06/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ShowActivityLoadingView.h"

@implementation ShowActivityLoadingView
{
     UILabel *label;
    UIActivityIndicatorView *activity;
    UIView *loaderView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    if(self==[super initWithFrame:frame])
    {
        self.frame=frame;
    }
    return self;
}

-(void)showLoaderViewWithText:(NSString *)text
{

        loaderView=[[UIView alloc] initWithFrame:self.bounds];
        [loaderView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.4]];
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(0, (loaderView.bounds.size.height/2)-10, loaderView.bounds.size.width, 20)];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        label.center=CGPointMake(self.frame.size.width/2, self.frame.size.height*.40f);
        [label setText:text];
        [label setTextAlignment:NSTextAlignmentCenter];
        [loaderView addSubview:label];
        
        activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center=CGPointMake(label.center.x, label.frame.origin.y+label.frame.size.height+10+activity.frame.size.height/2);
        [activity startAnimating];
        [loaderView addSubview:activity];
        [self addSubview:loaderView];
}

-(void)removeLoaderView
{
        // isTimeOut=NO;
        [label removeFromSuperview];
        [activity removeFromSuperview];
        [loaderView removeFromSuperview];
        label=nil;
        activity=nil;
        loaderView=nil;
}



@end
