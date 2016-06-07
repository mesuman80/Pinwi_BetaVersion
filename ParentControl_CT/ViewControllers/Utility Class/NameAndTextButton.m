//
//  NameAndTextButton.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 05/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "NameAndTextButton.h"
#import "Constant.h"
#import "PC_DataManager.h"

@implementation NameAndTextButton
{
    int xx;
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
    if(self == [super initWithFrame:frame])
    {
        return self;
    }
    return nil;
}

-(void)drawUi:(NSString*)head andImage:(NSString*)imgName
{
    xx=20*ScreenFactor;
    [self drawImage:imgName];
    [self drawLabelWithText:head andColor:[UIColor whiteColor] andFont:[UIFont fontWithName:RobotoLight size:ScreenFactor*9]];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtButton:)];
    [self addGestureRecognizer:gesture];

}

-(void)drawImage:(NSString*)imgName
{
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(xx, 0, ScreenFactor*10, ScreenFactor*10)];
    image.image=[UIImage imageNamed:isiPhoneiPad(imgName)];
    [image setCenter:CGPointMake(image.center.x, self.frame.size.height/2)];
    [self addSubview:image];
    xx+=image.frame.size.width+3*ScreenFactor;
}
-(UILabel*)drawLabelWithText:(NSString*)title andColor:(UIColor*)color andFont:(UIFont*)font
{
    UILabel *label = [[UILabel alloc]init];
    [label setText:title];
    [label setTextColor:color];
    [label setFont:font];
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(xx,0, size.width, size.height)];
    [self addSubview:label];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setCenter:CGPointMake(label.center.x, self.frame.size.height/2)];
    xx+=label.frame.size.width+2*ScreenFactor;
    return label;
}

-(void)touchAtButton:(id)sender
{
    if(self.delegate)
    {
        self.alpha=0.1f;
        [self performSelector:@selector(callDelegate) withObject:nil afterDelay:0.2];
    }
}
-(void)callDelegate
{
    self.alpha=1.0f;
    [self.delegate TouchAtNameTextView:self];
}



@end
