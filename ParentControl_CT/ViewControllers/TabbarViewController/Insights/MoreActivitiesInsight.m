//
//  MoreActivitiesInsight.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 13/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "MoreActivitiesInsight.h"
#import "Constant.h"
#import "PC_DataManager.h"

@implementation MoreActivitiesInsight

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawUI{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [titleLabel setText:@"More Activities"];
    [titleLabel setTextColor:[UIColor colorWithRed:39.0f/255.0f green:124.0f/255.0f blue:188.0f/255.0f alpha:1.0f]];
    [titleLabel setFont:[UIFont systemFontOfSize:10.0*ScreenFactor]];
    CGSize labelSize =[titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}];
    [titleLabel setFrame:CGRectMake(cellPadding, 0, labelSize.width, labelSize.height)];
    [titleLabel setCenter:CGPointMake(titleLabel.center.x, self.frame.size.height/2.0f)];
    [self addSubview:titleLabel];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"grayArrow.png")]];
    [imageView setFrame:CGRectMake(self.frame.size.width-self.frame.size.height*.5f-cellPadding, 0, self.frame.size.height*.5f, self.frame.size.height*.5f)];
    [imageView setCenter:CGPointMake(imageView.center.x,self.frame.size.height/2.0f)];
    [self addSubview:imageView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtMoreActivity:)];
    [self addGestureRecognizer:gestureRecognizer];
    

}
-(void)touchAtMoreActivity:(id)sender
{
    if(_delegate)
    {
        [_delegate touchBegan:self];
    }
}
@end
