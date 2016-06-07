//
//  interestCell.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 10/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InterestCell.h"
#import "Constant.h"
#import "PC_DataManager.h"

@implementation InterestCell
{
    int xx ;
    int yy;
    
}
@synthesize dataDict;
-(void)drawUI:(NSDictionary *)dataDictionary withColor:(UIColor *)color
{

    NSString *title = [dataDictionary valueForKey:@"title"];
    NSArray *arr = [dataDictionary valueForKey:@"Array"];
    
    int circleCount = arr.count;
    if(circleCount>5)
    {
        circleCount=5;
    }
    [self setBackgroundColor:[dataDictionary valueForKey:@"Color"]];
     xx = cellPadding;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = title;
    label.textColor = [UIColor colorWithRed:240.0f/255 green:242.0f/255 blue:245.0f/255 alpha:1];
    label.font = [UIFont fontWithName:RobotoRegular size:12.0f*ScreenFactor];
    CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(xx,(2*ScreenWidthFactor), labelSize.width, labelSize.height)];
    [label setCenter:CGPointMake(label.center.x, self.frame.size.height/2)];
    yy = label.frame.size.height + label.frame.origin.y + (2*ScreenHeightFactor);
    [self addSubview:label];
    
    xx=134*ScreenWidthFactor;
    for(int i = 0 ;i<circleCount ;i++)
    {
        NSDictionary *dict=[arr objectAtIndex:i];
        NSString *imageStr= [NSString stringWithFormat:@"%@.png", [dict objectForKey:@"InterestTraitID"]];
        
//        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(imageStr)]];
//        [imageView setFrame:CGRectMake(xx,yy,27*ScreenFactor,27*ScreenFactor)];
//        [imageView setCenter:CGPointMake(imageView.center.x, self.frame.size.height/2)];
//        //imageView.contentMode=UIViewContentModeScaleAspectFit;
//        [self addSubview:imageView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:nil];
        [imageView setFrame:CGRectMake(xx,yy,20*ScreenFactor,20*ScreenFactor)];
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        [imageView setBackgroundColor:[UIColor whiteColor]];
        imageView.clipsToBounds = YES;
        [imageView setImage:[UIImage imageNamed:isiPhoneiPad(imageStr)]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setCenter:CGPointMake(imageView.center.x, self.frame.size.height/2)];
        [self addSubview:imageView];
        
        imageStr=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Status"]];
        
        if([imageStr isEqualToString:@"0"])
        {
            imageStr=nil;
        }
        else if([imageStr isEqualToString:@"1"])
        {
            imageStr=@"upArrowTrait.png";
        }
        else if([imageStr isEqualToString:@"2"])
        {
            imageStr=@"downArrowTrait.png";
        }
        
        UIImageView *imageArrowView = [[UIImageView alloc]initWithImage:nil];
        [imageArrowView setFrame:CGRectMake(xx,yy,12*ScreenFactor,12*ScreenFactor)];
//        imageArrowView.layer.cornerRadius = imageView.frame.size.width/10;
//        [imageArrowView setBackgroundColor:[UIColor whiteColor]];
//        imageArrowView.clipsToBounds = YES;
        [imageArrowView setImage:[UIImage imageNamed:isiPhoneiPad(imageStr)]];
        imageArrowView.contentMode = UIViewContentModeScaleAspectFill;
        [imageArrowView setCenter:CGPointMake(imageView.frame.size.width+imageView.frame.origin.x-2*ScreenWidthFactor, imageView.frame.origin.y+imageView.frame.size.width-1*ScreenHeightFactor)];
        [self addSubview:imageArrowView];

        
        
        xx += imageView.frame.size.width+(4*ScreenFactor);
    }
    
    if([dataDictionary valueForKey:@"imageName"])
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-self.frame.size.height/2.0f-(7*ScreenFactor),0,self.frame.size.height/3.0f,self.frame.size.height/3.0f)];
       // [imageView setImage:[UIImage imageNamed:isiPhoneiPad(@"1.png")]];
        [imageView setImage:[UIImage imageNamed:isiPhoneiPad([dataDictionary valueForKey:@"imageName"])]];
        [imageView setCenter:CGPointMake(self.frame.size.width-imageView.frame.size.width/2-cellPadding/2, self.frame.size.height/2.0f)];
        [self addSubview:imageView];
    }
    
    dataDict=dataDictionary;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtDriver:)];
    [self addGestureRecognizer:gesture];
    
    
}
-(void)touchAtDriver:(id)sender
{
    if(self.interestDriverDelegate)
    {
        self.alpha=0.4f;
        [self performSelector:@selector(callDelegate) withObject:nil afterDelay:0.1];
        
    }
}
-(void)callDelegate
{
    self.alpha=1.0f;
  [self.interestDriverDelegate interestDriverTouched:self];
}




@end
