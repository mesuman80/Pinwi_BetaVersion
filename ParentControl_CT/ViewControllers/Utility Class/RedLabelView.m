//
//  RedLabelView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 21/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "RedLabelView.h"

@implementation RedLabelView
{
    UILabel *childLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame withChildStr:(NSString *)str
{
    if(self==[super initWithFrame:frame])
    {
        self.frame=frame;
        [self drawRedBgLabel:str];
        //self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

-(void)drawRedBgLabel:(NSString*)str
{
    //NSString *str=childObject.firstName;
    childLabel=[[UILabel alloc]init];
    str=[str uppercaseString];
    CGSize displayValueSize;
    if(str.length<3)
    {
        displayValueSize = [[NSString stringWithFormat:@"  %@",str] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.frame.size.height*.8]}];
    }
    else
    {
        displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.frame.size.height*.8]}];
    }
    childLabel.text=str;
    childLabel.font=[UIFont fontWithName:KGTheLastTime size:self.frame.size.height*.8];
    childLabel.frame=CGRectMake(0,0,displayValueSize.width+ScreenWidthFactor*15,displayValueSize.height+screenHeight*.01);
    childLabel.textAlignment=NSTextAlignmentCenter;
    childLabel.center=CGPointMake(screenWidth/2,childLabel.frame.size.height/2);
    childLabel.textColor=[UIColor whiteColor];
    childLabel.backgroundColor=labelBgColor;
    childLabel.layer.borderColor=labelBgColor.CGColor;
    childLabel.layer.shadowColor=labelBgColor.CGColor;
    childLabel.layer.shadowOpacity=0.0f;
    childLabel.layer.cornerRadius=childLabel.frame.size.height/2;
    childLabel.clipsToBounds=YES;
    [self addSubview:childLabel];

}


@end
