//
//  TextAndToggle.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 24/09/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import "TextAndToggle.h"
#import "Constant.h"
#import "PC_DataManager.h"
@implementation TextAndToggle
{
    int xx;
}
@synthesize toggleSwitch;
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
        return self;
    }
    return nil;
}

-(void)drawUi:(NSString *)labeltext textcolor:(UIColor*)color font:(UIFont*)textfont
{
    [self drawLabelWithText:labeltext andColor:color andFont:textfont];
    [self drawSwitch];
}


-(UILabel*)drawLabelWithText:(NSString*)title andColor:(UIColor*)color andFont:(UIFont*)font
{
    UILabel *label = [[UILabel alloc]init];
    [label setText:title];
    [label setTextColor:color];
    [label setFont:font];
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(cellPaddingReg,0, size.width, size.height)];
    [self addSubview:label];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setCenter:CGPointMake(label.center.x, self.frame.size.height/2)];
    xx+=label.frame.size.width+2*ScreenFactor;
    return label;
}

-(UISwitch*)drawSwitch
{
    [[PC_DataManager sharedManager]getWidthHeight];
    toggleSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(0,0,30*ScreenWidthFactor, self.frame.size.height)];
    toggleSwitch.onTintColor=radiobuttonSelectionColor;
    toggleSwitch.center=CGPointMake(screenWidth-toggleSwitch.frame.size.width/2-cellPaddingReg, self.frame.size.height/2);
    [toggleSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:toggleSwitch];
    return toggleSwitch;
}

-(void)switchChanged:(id)sender
{
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    if(self.toggleDelegate)
    {
        if(switchControl.on)
        {
            [self.toggleDelegate toggleButtonTouched:YES];
        }
        else
        {
            [self.toggleDelegate toggleButtonTouched:NO];
        }
    }
}


@end
