//
//  HolidayFooterView.m
//  ParentControl_CT
//
//  Created by Sakshi on 05/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "HolidayFooterView.h"
#import "PC_DataManager.h"

@implementation HolidayFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawUI {
    [self setBackgroundColor:[UIColor whiteColor]];
    UILabel *plusSign;
    
    if (screenWidth >700) {
        plusSign = [[UILabel alloc] initWithFrame:CGRectMake(2,10,ScreenHeightFactor*28, ScreenHeightFactor*28)];
        [plusSign setCenter:CGPointMake(plusSign.center.x,self.frame.size.height/2.0)];
        // plusSign.layer.cornerRadius = plusSign.frame.size.width/2;
    }
    else{
        if (screenWidth>320){
        plusSign = [[UILabel alloc] initWithFrame:CGRectMake(2,0,ScreenHeightFactor*20, ScreenHeightFactor*20)];
        [plusSign setCenter:CGPointMake(plusSign.center.x,self.frame.size.height/2.0)];
        }else{
            plusSign = [[UILabel alloc] initWithFrame:CGRectMake(2,0,ScreenHeightFactor*23, ScreenHeightFactor*23)];
            [plusSign setCenter:CGPointMake(plusSign.center.x,self.frame.size.height/2.0)];
        }
       // plusSign.layer.cornerRadius = plusSign.frame.size.width/2;
    }
    
    plusSign.layer.masksToBounds = YES;
    plusSign.layer.borderWidth = 0;
    plusSign.contentMode=UIViewContentModeScaleAspectFill;
    plusSign.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:isiPhoneiPad(@"addActivity.png")]];
    [self addSubview:plusSign];
    
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [headerLabel setText:@"Add New Holiday"];
    [headerLabel setTextColor:textBlueColor];
    UIFont *font  = (self.frame.size.width>700) ?
    [UIFont fontWithName:RobotoRegular size:9*ScreenFactor]
    :[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
    [headerLabel setFont:font];
    [headerLabel setBackgroundColor:[UIColor whiteColor]];
    [headerLabel setFrame:CGRectMake(10*ScreenWidthFactor+plusSign.frame.size.width,0,self.frame.size.width,self.frame.size.height-10)];
    [headerLabel setCenter:CGPointMake(headerLabel.center.x,self.frame.size.height/2.0)];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:headerLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick:)];
    [self addGestureRecognizer:tapGesture];

}

-(void)onClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(touchAtFooterView:)]) {
        [_delegate touchAtFooterView:_childId];
    }
}

@end
