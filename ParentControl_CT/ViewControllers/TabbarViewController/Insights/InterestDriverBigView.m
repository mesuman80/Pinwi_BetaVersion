//
//  InterestDriverBigView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InterestDriverBigView.h"
#import "PC_DataManager.h"
#import "Constant.h"

@implementation InterestDriverBigView
{
    int yy;
    int xx;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawUi:(NSDictionary*)dataDict
{
    
    yy=0;
    BOOL isNew=NO;
        NSString *imageStr= [NSString stringWithFormat:@"%@big.png", [dataDict objectForKey:@"InterestTraitID"]];

        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:nil];
        [imageView setFrame:CGRectMake(0,0,ScreenHeightFactor*100,ScreenHeightFactor*100)];
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        [imageView setBackgroundColor:[UIColor whiteColor]];
        imageView.clipsToBounds = YES;
        [imageView setImage:[UIImage imageNamed:isiPhoneiPad(imageStr)]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setCenter:CGPointMake(imageView.center.x,self.frame.size.height/2)];
        [self addSubview:imageView];
    
    
        imageStr=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"Status"]];
        
        if([imageStr isEqualToString:@"0"])
        {
            imageStr=nil;
        }
        else if([imageStr isEqualToString:@"1"])
        {
            imageStr=@"upArrowTrait.png";
            isNew=YES;
        }
        else if([imageStr isEqualToString:@"2"])
        {
            imageStr=@"downArrowTrait.png";
        }
        
        UIImageView *imageArrowView = [[UIImageView alloc]initWithImage:nil];
        [imageArrowView setFrame:CGRectMake(0,0,30*ScreenHeightFactor,30*ScreenHeightFactor)];
        [imageArrowView setImage:[UIImage imageNamed:isiPhoneiPad(imageStr)]];
        imageArrowView.contentMode = UIViewContentModeScaleAspectFill;
        [imageArrowView setCenter:CGPointMake(imageView.frame.size.width+imageView.frame.origin.x-12*ScreenWidthFactor, imageView.frame.origin.y+imageView.frame.size.height-8*ScreenHeightFactor)];
        [self addSubview:imageArrowView];
    
    //yy+=imageView.frame.size.height+10*ScreenHeightFactor;
    xx+=imageView.frame.size.width+10*ScreenHeightFactor;
    yy=self.frame.size.height*.3;
    [self drawLabelWithText1:[dataDict objectForKey:@"Name"] andColor:[UIColor colorWithRed:240.0f/255 green:242.0f/255 blue:245.0f/255 alpha:0.8f]];
    
    if(isNew)
    {
    [self drawLabelWithText:@"This driver is new." andColor:[UIColor colorWithRed:240.0f/255 green:242.0f/255 blue:245.0f/255 alpha:1] andFont:[UIFont fontWithName:RobotoRegular size:6*ScreenFactor] andLines:NO];
    }
    

    
    NSString *text= [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"Description"]];
    NSLog(@"InterestDriverBigView text = %@" , text);
    [self drawLabelWithText:text andColor:[UIColor colorWithRed:240.0f/255 green:242.0f/255 blue:245.0f/255 alpha:1] andFont:[UIFont fontWithName:RobotoRegular size:8*ScreenFactor] andLines:YES];
    
    
    UIView *line= [[PC_DataManager sharedManager]drawLineView_withXPos:self.frame.size.width/2 andYPos:self.frame.size.height-0.5*ScreenHeightFactor withScrnWid:self.frame.size.width withScrnHt:1*ScreenHeightFactor ofColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4f]];
    [self addSubview:line];
}

-(UILabel*)drawLabelWithText:(NSString*)title andColor:(UIColor*)color andFont:(UIFont*)font andLines:(BOOL)numLines
{
    UILabel *label = [[UILabel alloc]init];
    [label setText:title];
    [label setTextColor:color];
    [label setFont:font];
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(xx,yy, size.width, size.height)];
        if(numLines)
        {
             [label setFrame:CGRectMake(xx,yy-10,self.frame.size.width-cellPadding-xx, size.height*6)];
            label.numberOfLines=5;
        }
    [self addSubview:label];
    [label setTextAlignment:NSTextAlignmentLeft];
    //[label setCenter:CGPointMake(self.frame.size.width/2, label.center.y)];
    yy+=label.frame.size.height+10*ScreenHeightFactor;
    return label;
}

-(UILabel*)drawLabelWithText1:(NSString*)title andColor:(UIColor*)color
{
    UILabel *label = [[UILabel alloc]init];
    [label setText:title];
    [label setTextColor:color];
    UIFont *customFont = [UIFont fontWithName:RobotoBold size:10*ScreenFactor];
    [label setFont:customFont];
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(xx,yy, size.width, size.height)];
    [self addSubview:label];
    [label setTextAlignment:NSTextAlignmentLeft];
    //[label setCenter:CGPointMake(self.frame.size.width/2, label.center.y)];
    yy+=label.frame.size.height+10*ScreenHeightFactor;
    return label;
}


//-(UILabel*)drawLabelWithText:(NSString*)title andColor:(UIColor*)color andFont:(UIFont*)font
//{
//    UILabel *label = [[UILabel alloc]init];
//    [label setText:title];
//    [label setTextColor:color];
//    [label setFont:font];
//    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
//    [label setFrame:CGRectMake(xx,yy, size.width, size.height)];
//    [self addSubview:label];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [label setCenter:CGPointMake(self.frame.size.width/2, label.center.y)];
//    yy+=label.frame.size.height+10*ScreenHeightFactor;
//    return label;
//}



@end
