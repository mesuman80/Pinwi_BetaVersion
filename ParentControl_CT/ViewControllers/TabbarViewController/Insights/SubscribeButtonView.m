//
//  SubscribeButtonView.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "SubscribeButtonView.h"
#import "PC_DataManager.h"
#import "Constant.h"
@implementation SubscribeButtonView
{
    int yy;
    int factor;
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
    if(self = [super initWithFrame:frame])
    {
        factor = ScreenFactor;
        [self setBackgroundColor:radiobuttonSelectionColor];
        return self;
    }
    return nil;
}
-(void)drawUI:(NSDictionary *)dataDictionary
{
    NSString *labelStr = [dataDictionary valueForKey:@"labelStr"];
    NSString *buttonStr = [dataDictionary valueForKey:@"buttonStr"];
    NSLog(@"Label Str %@  button str  =%@" , labelStr , buttonStr);
    yy = self.frame.size.height*.1f;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = labelStr;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:RobotoRegular size:15.0f*ScreenHeightFactor];
    CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(0,yy, labelSize.width, labelSize.height)];
    [label setCenter:CGPointMake(self.frame.size.width/2.0f,label.center.y)];
    [self addSubview:label];
    
    yy += label.frame.size.height+self.frame.size.height*.1;
    
    UIButton *subscribeButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [subscribeButton setTitle:@"Subscribe Now" forState:UIControlStateNormal];
    subscribeButton.tintColor=activityHeading1FontCode;
    subscribeButton.backgroundColor=buttonGreenColor;//[UIColor colorWithRed:58.0f/255.0f green:141.0f/255.0f blue:196.0/255.0f alpha:1.0f];
    [subscribeButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    subscribeButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:15.0f*ScreenHeightFactor];
    subscribeButton.frame=CGRectMake(cellPadding,yy,self.frame.size.width-cellPadding*2, screenHeight*.07);
    subscribeButton.center=CGPointMake(self.frame.size.width/2,subscribeButton.center.y);
    [subscribeButton addTarget:self action:@selector(subscribeButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:subscribeButton];
    
}
-(void)subscribeButtonTouch:(id)sender
{if(_delegate)[_delegate touchAtSubscribe:self];}

@end
