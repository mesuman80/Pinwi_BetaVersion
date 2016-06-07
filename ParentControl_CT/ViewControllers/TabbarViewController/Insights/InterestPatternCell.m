//
//  interestCell.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 10/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InterestPatternCell.h"
#import "Constant.h"
#import "PC_DataManager.h"

@implementation InterestPatternCell
{
    int xx ;
    int yy;
}
-(void)drawUI:(NSDictionary *)dataDictionary withColor:(UIColor *)color
{

    NSString *title = [dataDictionary valueForKey:@"title"];
    NSArray *arr = [dataDictionary valueForKey:@"Array"];
    
    int circleCount =(int) arr.count;
    [self setBackgroundColor:[UIColor whiteColor]];
     xx = 10*ScreenFactor;
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xx,0,self.frame.size.height-xx,self.frame.size.height-xx)];
    [titleImageView setImage:[UIImage imageNamed:isiPhoneiPad([dataDictionary valueForKey:@"titleImage"])]];
    [titleImageView setCenter:CGPointMake(titleImageView.center.x, self.frame.size.height/2.0f)];
    [self addSubview:titleImageView];
    
    xx += titleImageView.frame.size.width+(1*ScreenFactor);

    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = title;
    label.textColor =color;
    label.font = [UIFont fontWithName:RobotoRegular size:15.0f*ScreenFactor];
    CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(xx,(2*ScreenFactor), labelSize.width, labelSize.height)];
    [label setCenter:CGPointMake(label.center.x, self.frame.size.height/2)];
    yy = label.frame.size.height + label.frame.origin.y + (2*ScreenFactor);
    [self addSubview:label];
    
    xx=140*ScreenFactor;
    for(int i = 0 ;i<5 ;i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:nil];
        [imageView setFrame:CGRectMake(xx,yy,27*ScreenFactor,27*ScreenFactor)];
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        [imageView setBackgroundColor:appBackgroundColor];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setCenter:CGPointMake(imageView.center.x, self.frame.size.height/2)];
        [self addSubview:imageView];
        xx += imageView.frame.size.width+(4*ScreenFactor);
    }
    
    if([dataDictionary valueForKey:@"imageName"])
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-self.frame.size.height/2.0f-(10*ScreenFactor),0,self.frame.size.height/3.0f,self.frame.size.height/3.0f)];
        [imageView setImage:[UIImage imageNamed:isiPhoneiPad([dataDictionary valueForKey:@"imageName"])]];
        [imageView setCenter:CGPointMake(self.frame.size.width-imageView.frame.size.width/2-7*ScreenFactor, self.frame.size.height/2.0f)];
        [self addSubview:imageView];
    }
    
    UIView *line=[[PC_DataManager sharedManager]drawLineView_withXPos:self.frame.size.width/2 andYPos:self.frame.size.height-1*ScreenFactor withScrnWid:self.frame.size.width withScrnHt:2*ScreenFactor ofColor:appBackgroundColor];
    [self addSubview:line];
}

@end
