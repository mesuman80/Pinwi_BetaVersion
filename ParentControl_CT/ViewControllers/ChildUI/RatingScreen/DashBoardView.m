//
//  DashBoardView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 30/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "DashBoardView.h"
#import "Sound.h"

@implementation DashBoardView
{
    UIView *rectView;
    UILabel *today;
    UILabel *todayDate;
    UILabel *pointsLabel;
    
     UIView *rectView1;
     UIView *rectView2;
    Sound *soundObject;
    BOOL isTouchedOnce;
}
@synthesize dayString;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize activityDashBoardDict;

-(id)initWithFrame:(CGRect)frame andDict:(NSDictionary *)dictionary WithDay:(NSString*)day
{
    if(self=[super initWithFrame:frame])
    {
        [self drawRectView];
        [self drawStatus:dictionary withDay:day];
        activityDashBoardDict=dictionary;
        soundObject=[[Sound alloc]init];
        isTouchedOnce = NO;
    }
    return self;
}

-(void)drawRectView
{
    rectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //rectView.alpha=0.4f;
    rectView.clipsToBounds=YES;
    rectView.layer.borderColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:0.1f].CGColor;
    rectView.layer.borderWidth=1.0f;
    [self addSubview:rectView];
    
}

-(void)drawStatus:(NSDictionary*)dictionary withDay:(NSString*)day
{
    NSString *textStr=[dictionary objectForKey:@"ActivityDate"];
    textStr=[textStr substringToIndex:7];
    
    today = [[UILabel alloc] initWithFrame:CGRectMake(5*ScreenWidthFactor,0,rectView.frame.size.width-10*ScreenWidthFactor,ScreenHeightFactor*60)];
    today.text=[NSString stringWithFormat:@"%@, %@",day,textStr];
    today.backgroundColor=[UIColor clearColor];
    today.textColor= [UIColor whiteColor];
    [today setFont:[UIFont fontWithName:Gotham size:11*ScreenFactor]];
    today.alpha=0.4;
    //[today sizeToFit];
    today.textAlignment=NSTextAlignmentCenter;
    [rectView addSubview:today];
    
    if([[dictionary objectForKey:@"Status"]isEqualToString:@"1"])
    {
        UIImageView *imageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"earnedPointsCup.png")]];
        [imageView setFrame:CGRectMake(0, 0,ScreenWidthFactor*60, ScreenWidthFactor*60)];
        [imageView setCenter:CGPointMake(rectView.frame.size.width/2, rectView.frame.size.height*.65)];
        [rectView addSubview:imageView];
    }
    else if([[dictionary objectForKey:@"Status"]isEqualToString:@"0"])
    {
        int originY=today.frame.origin.y+today.frame.size.height;
        
        rectView1=[[UIView alloc]initWithFrame:CGRectMake(0, originY, self.frame.size.width, self.frame.size.height-originY)];
        NSString *textStr=[dictionary objectForKey:@"PointsValue"];
       // textStr=[textStr substringToIndex:7];
        
       UILabel *today1 = [[UILabel alloc] initWithFrame:CGRectMake(5*ScreenWidthFactor,0,rectView1.frame.size.width-10*ScreenWidthFactor,ScreenHeightFactor*60)];
        if(screenWidth>700)
        {
            today1 = [[UILabel alloc] initWithFrame:CGRectMake(5*ScreenWidthFactor,0,rectView1.frame.size.width-10*ScreenWidthFactor,ScreenHeightFactor*100)];
        }
        today1.text=textStr;
        today1.backgroundColor=[UIColor clearColor];
        today1.textColor= [childDashBoardOrange2 colorWithAlphaComponent:0.8f];
        [today1 setFont:[UIFont fontWithName:gothamExtralight size:50*ScreenFactor]];
        
        today1.alpha=0.6;
        //[today sizeToFit];
        today1.textAlignment=NSTextAlignmentCenter;
        [rectView1 addSubview:today1];
        
        pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*ScreenWidthFactor,ScreenHeightFactor*50,rectView1.frame.size.width-10*ScreenWidthFactor,ScreenHeightFactor*40)];
        if(screenWidth>700)
        {
            pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*ScreenWidthFactor,ScreenHeightFactor*80,rectView1.frame.size.width-10*ScreenWidthFactor,ScreenHeightFactor*40)];
        }
        pointsLabel.text=@"Points Left";
        pointsLabel.backgroundColor=[UIColor clearColor];
        pointsLabel.textColor= childDashBoardOrange2;
        
        [pointsLabel setFont:[UIFont fontWithName:gothamLight size:11*ScreenFactor]];
        pointsLabel.alpha=0.6;
        //[today sizeToFit];
        pointsLabel.textAlignment=NSTextAlignmentCenter;
        [rectView1 addSubview:pointsLabel];
       
        
        [self addSubview:rectView1];
        UITapGestureRecognizer *celltap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RateAgain:)];
        [celltap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:celltap];

        [self animateAndFlip:dictionary andDay:(NSString*)day];
 [self addSubview:rectView];
    }
    else
    {
     
        
        UIImageView *imageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"lazyBoy.png")]];
        [imageView setFrame:CGRectMake(0, 0,ScreenWidthFactor*60, ScreenWidthFactor*60)];
        [imageView setCenter:CGPointMake(rectView.frame.size.width/2, rectView.frame.size.height*.65)];
        [rectView addSubview:imageView];
      
    }
}

-(void)RateAgain:(id)sender
{
    if(!isTouchedOnce){
        isTouchedOnce = YES;
        NSLog(@"rate again");
        [self setAlpha:0.1];
        [self performSelector:@selector(callDelegate:) withObject:sender afterDelay:0.2];
    }
}

-(void)callDelegate:(id)sender
{
    if(self.dashBoardDelegate)
    {
        [self setAlpha:1.0];
        [self.dashBoardDelegate RateAgainCellTouched:self];
    }
}


-(void)animateAndFlip:(NSDictionary*)dictionary andDay:(NSString*)day
{
    
    rectView2=[[UIView alloc]initWithFrame:rectView1.frame];
    
    UIImageView *imageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"pendingCup.png")]];
    [imageView setFrame:CGRectMake(0, 0,ScreenWidthFactor*60, ScreenWidthFactor*60)];
    [imageView setCenter:CGPointMake(rectView2.frame.size.width/2, rectView2.frame.size.height*.5)];
    [rectView2 addSubview:imageView];
    
    [self addSubview:rectView2];
    rectView2.alpha=0;
    rectView2.transform= CGAffineTransformMakeScale(0.01, 1.0);
    [self performSelector:@selector(animateRight) withObject:nil afterDelay:1];

}

-(void)animateRight
{
    rectView2.alpha=0.0;
    
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         rectView1.transform= CGAffineTransformMakeScale(0.01, 1.0);
                     }
                     completion:^(BOOL finished){
                         rectView1.alpha=0;
                         rectView2.alpha=1;
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                             
                                              rectView2.transform= CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished){
                                             // NSLog(@"Done!");
                                              [self performSelector:@selector(animateLeft) withObject:nil afterDelay:.05];
                                          }];
                     }];
    
    
    
//  //  [soundObject playWheelRotationSound:@"starAnimation" withFormat:@"mp3"];
//    [UIView transitionFromView:rectView1 toView:rectView2
//                      duration:1.0
//                       options:UIViewAnimationOptionTransitionFlipFromRight
//                    completion:^(BOOL finished) {
////                        [self addSubview:rectView2];
////                        [rectView1 addSubview:today];
////                        [rectView1 addSubview:todayDate];
////                        [rectView1 addSubview:pointsLabel];
//                        
//                        
//                        [self performSelector:@selector(animateLeft) withObject:nil afterDelay:4];
//                    }];
}

-(void)animateLeft
{
    
    rectView1.alpha=0;
    //rectView1.transform= CGAffineTransformMakeScale(0.01, 1.0);
    
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         rectView2.transform= CGAffineTransformMakeScale(0.01, 1.0);
                     }
                     completion:^(BOOL finished){
                         rectView1.alpha=1;
                         rectView2.alpha=0;
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              
                                              rectView1.transform= CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished){
                                              //NSLog(@"Done!");
                                              
                                              [self performSelector:@selector(animateRight) withObject:nil afterDelay:.05];
                                          }];
                     }];

    
    
  //  [soundObject playWheelRotationSound:@"starAnimation" withFormat:@"mp3"];
//    [UIView transitionFromView:rectView2 toView:rectView1
//                      duration:1.0
//                       options:UIViewAnimationOptionTransitionFlipFromRight
//                    completion:^(BOOL finished) {
//                        [self addSubview:rectView1];
//                        [rectView1 addSubview:today];
//                        [rectView1 addSubview:todayDate];
//                        [rectView1 addSubview:pointsLabel];
//                        [soundObject playWheelRotationSound:@"starAnimation" withFormat:@"mp3"];
//                         [self performSelector:@selector(animateRight) withObject:nil afterDelay:4];
//                    }];
}


@end
