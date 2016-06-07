//
//  PointSummaryViewItem.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 10/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "PointSummaryViewItem.h"
#import "Constant.h"
@implementation PointSummaryViewItem
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
-(void)drawUI:(NSDictionary *)dictionary withBoxColor:(UIColor *)color withImage:(UIImage*)imageName
{
    [self setBackgroundColor:[UIColor clearColor]];
    xx= 0 ;
    
    NSString *percentage = [dictionary valueForKey:@"percentage"];
    NSString *title = [dictionary valueForKey:@"title"];
    NSString *points = [dictionary valueForKey:@"points"];
    
    NSArray *dataArray = [[NSArray alloc]initWithObjects:percentage,@"",title,points,nil];
    int i=0;
    for(NSString *str in dataArray)
    {
        if([str isEqualToString:@""])
        {

            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(xx, 0,self.frame.size.height,self.frame.size.height)];
            imageView.image=imageName;
            [self addSubview:imageView];
            xx+=imageView.frame.size.width+(4 * ScreenWidthFactor);
        }
        else
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            switch (i)
            {
                case 0:
                {
                    int count = 4 - str.length;
                    NSString *labelText = str;
                    for(int i = 0 ;i <count ;i++)
                    {
                        labelText = [labelText stringByAppendingString:@"1"];
                    }
                    label.text = labelText;
                }
                    
                break;

                case 2:
                    if(str.length<8)
                    {
                        int count = 8 - str.length;
                        NSString *labelText = str;
                        for(int i = 0 ;i <count ;i++)
                        {
                            labelText = [labelText stringByAppendingString:@"1"];
                        }
                        label.text = labelText;
                    }
                    else
                    {
                        label.text = str;
                    }

                break;

                case 3:
                    label.text = str;
                break;

            }
            
            label.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
            [label setBackgroundColor:[UIColor clearColor]];
            label.font = [UIFont fontWithName:RobotoRegular size:9.0f*ScreenFactor];
            CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
            [label setFrame:CGRectMake(xx,0,labelSize.width, labelSize.height)];
            label.text = str;
            [self addSubview:label];
            //[label sizeToFit];
            xx+=label.frame.size.width+(2 * ScreenWidthFactor);
        }
        i++;
        
    }
}

@end
