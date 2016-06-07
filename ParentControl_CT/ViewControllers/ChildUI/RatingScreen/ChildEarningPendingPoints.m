//
//  ChildEarningPendingPoints.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 26/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ChildEarningPendingPoints.h"

@implementation ChildEarningPendingPoints

-(void)drawUIWithData:(NSString *)points withString:(NSString *)pointType andTextLabel:(NSString*)textString
{
    NSString *imageName = nil;
    BOOL isLevel = NO;
    int xx= 0;
    int yy = 0;
    if([pointType isEqualToString:@"EarnedPoints"])
    {
        imageName = isiPhoneiPad(@"earnedCup.png");
    }
    else if([pointType isEqualToString:@"PendingPoints"])
    {
        imageName = isiPhoneiPad(@"pendingCup.png");
//        if(![points isEqualToString:@"0"])
//        {
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"claim.png")]];
        [image setFrame:CGRectMake(self.frame.size.width-50*ScreenWidthFactor,0,30*ScreenHeightFactor,30*ScreenHeightFactor)];
        [image setCenter:CGPointMake(image.center.x, self.frame.size.height/2)];
        [self addSubview:image];
        
        UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"claim-arrow.png")]];
        [image1 setFrame:CGRectMake(self.frame.size.width-18*ScreenWidthFactor,0,16*ScreenHeightFactor,16*ScreenHeightFactor)];
        [image1 setCenter:CGPointMake(image1.center.x, self.frame.size.height/2)];
        [self addSubview:image1];
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtCell:)];
        [self addGestureRecognizer:gestureRecognizer];
//        }
        
    }
    else
    {
        [[PC_DataManager sharedManager]RatingList];
        imageName = isiPhoneiPad([ratingListArray objectAtIndex:[textString intValue]-1]);
        isLevel = YES;
    }
    
        UIImageView *hexaGoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"hexagon.png")]];
        [hexaGoneImage setFrame:CGRectMake(10*ScreenWidthFactor, 0,self.frame.size.height-20*ScreenHeightFactor,self.frame.size.height-20*ScreenHeightFactor )];
        [self addSubview:hexaGoneImage];
        
        UIImageView *imageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        [imageView setFrame:CGRectMake(0, 0,hexaGoneImage.frame.size.width/2,  hexaGoneImage.frame.size.height/2)];
        [imageView setCenter:CGPointMake(hexaGoneImage.frame.size.width/2, hexaGoneImage.frame.size.height/2)];
        [hexaGoneImage addSubview:imageView];
        
        xx = hexaGoneImage.frame.size.width+20*ScreenWidthFactor;
        
        yy = self.frame.size.height/2-40*ScreenHeightFactor;
    
    if(!isLevel)
    {
        UILabel * pendingPointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(xx,yy,self.frame.size.width-xx,20*ScreenFactor)];
        [pendingPointsLabel setText:textString];
        [pendingPointsLabel setFont:[UIFont fontWithName:Gotham size:13*ScreenFactor]];
        [pendingPointsLabel setTextColor:cellWhiteColor_5];
        [pendingPointsLabel sizeToFit];
        [self addSubview:pendingPointsLabel];
        yy += pendingPointsLabel.frame.size.height+5*ScreenHeightFactor;
        
        UILabel * pointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(xx,yy,self.frame.size.width-xx,18*ScreenFactor)];
        [pointsLabel setText:points];
        [pointsLabel setFont:[UIFont fontWithName:Gotham size:13*ScreenFactor]];
        [pointsLabel setTextColor:cellWhiteColor_7];
        [pointsLabel sizeToFit];
        [self addSubview:pointsLabel];
    }
   else
   {
       [[PC_DataManager sharedManager]InsightsArrays];
       NSString *headVal=[qualityBadgeArray objectAtIndex:[textString intValue]-1];
       UILabel * pendingPointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(xx,yy,self.frame.size.width-xx,20*ScreenFactor)];
       [pendingPointsLabel setText:headVal];
       [pendingPointsLabel setFont:[UIFont fontWithName:Gotham size:13*ScreenFactor]];
       [pendingPointsLabel setTextColor:cellWhiteColor_5];
       [pendingPointsLabel sizeToFit];
       [self addSubview:pendingPointsLabel];
       yy += pendingPointsLabel.frame.size.height+5*ScreenHeightFactor;
       
       
       UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xx,yy,self.frame.size.width-xx,self.frame.size.height-10*ScreenFactor)];
       [label setFont:[UIFont fontWithName:Gotham size:10*ScreenFactor]];
       [label setText:[NSString stringWithFormat:@"Based on the consistency and quality of rating data, this report is currently at Level %@. Level 5 reports are most realistic and reliable.",textString ]];
       [label setTextColor:cellWhiteColor_6];
       label.numberOfLines = 0;
       label.lineBreakMode = NSLineBreakByWordWrapping;
       [label sizeToFit];
       //[label setCenter:CGPointMake(label.center.x, self.frame.size.height/2-10*ScreenHeightFactor)];
       [self addSubview:label];
   }
}



-(void)touchAtCell:(UITapGestureRecognizer *)recognizer
{
    if(_delegate)
    {
        self.alpha=0.1f;
        [self performSelector:@selector(calldelegate) withObject:nil afterDelay:.1];
    }
}

-(void)calldelegate
{
    self.alpha=1.0f;
    [_delegate touchAtCell:self];
}

@end
