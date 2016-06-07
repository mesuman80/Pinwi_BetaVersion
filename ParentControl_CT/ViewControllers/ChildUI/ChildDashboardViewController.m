//
//  ChildDashboardViewController.m
//  ParentControl_CT
//
//  Created by Sakshi on 01/06/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "ChildDashboardViewController.h"
#import "Constant.h"
#import "PC_DataManager.h"

@interface ChildDashboardViewController ()<SounPlayerProtocol>

@end

@implementation ChildDashboardViewController

@synthesize dashboardImageView,dashboardComponentLabel,soundObject;
@synthesize childImgview;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[PC_DataManager sharedManager]getWidthHeight];
    [self backgroundImage];
//    [self setNavigationBarSetup];
    soundObject=[[Sound alloc]init];
    soundObject.soundDelegate=self;
    soundObject.child=self.childObj;
    [self drawImageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backgroundImage
{
    UIImageView *bgImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"Child-Pinwheel-Bg.png")]];
    bgImg.frame=CGRectMake(0, 0, screenWidth, screenHeight);
    bgImg.center=CGPointMake(screenWidth/2, screenHeight/2);
    [self.view addSubview:bgImg];
}
-(void)childProfileImg
{
    
    //  ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)? isiPhoneiPad(@""):iPadAirImage(@"")
    
    childImgview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, screenWidth*.22, screenHeight*.15)];
    // childImgview.image=self.childObjDashBoard.profile_pic;
    childImgview.image=[[PC_DataManager sharedManager]decodeImage:self.childObj.profile_pic];
    childImgview.center=CGPointMake(.5*screenWidth, .15*screenHeight);
    //[childImgview setUserInteractionEnabled:YES];
    //    childImgview.layer.cornerRadius = 20;
    childImgview.layer.borderWidth = 2.0f;
    childImgview.layer.borderColor = [UIColor whiteColor].CGColor;
    //    childImgview.clipsToBounds = YES;
    
    //    CGFloat lineWidth    = 5.0;
    UIBezierPath *path   = [self roundedPolygonPathWithRect:childImgview.bounds
                                                  lineWidth:2.0
                                                      sides:6
                                               cornerRadius:20];
    //
    CAShapeLayer *mask   = [CAShapeLayer layer];
    mask.path            = path.CGPath;
    //mask.transform  =CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(M_PI_2));
    mask.lineWidth       = 2.0;
    mask.strokeColor     = [UIColor clearColor].CGColor;
    mask.fillColor       = [UIColor whiteColor].CGColor;
    childImgview.layer.mask = mask;
    //
    CAShapeLayer *border = [CAShapeLayer layer];
    border.path          = path.CGPath;
    border.lineWidth     = 2.0;
    border.strokeColor   = [UIColor whiteColor].CGColor;
    border.fillColor     = [UIColor clearColor].CGColor;
    [childImgview.layer addSublayer:border];
    
    [self.view addSubview:childImgview];
}

- (UIBezierPath *)roundedPolygonPathWithRect:(CGRect)square
                                   lineWidth:(CGFloat)lineWidth
                                       sides:(NSInteger)sides
                                cornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *path  = [UIBezierPath bezierPath];
    
    CGFloat theta       = 2.0 * M_PI / sides;                           // how much to turn at every corner
    CGFloat offset      = cornerRadius * tanf(theta / 2.0);             // offset from which to start rounding corners
    CGFloat squareWidth = MIN(square.size.width, square.size.height);   // width of the square
    
    // calculate the length of the sides of the polygon
    
    CGFloat length      = squareWidth - lineWidth;
    if (sides % 4 != 0) {                                               // if not dealing with polygon which will be square with all sides ...
        length = length * cosf(theta / 2.0) + offset/2.0;               // ... offset it inside a circle inside the square
    }
    CGFloat sideLength = length * tanf(theta / 2.0);
    
    // start drawing at `point` in lower right corner
    
    CGPoint point = CGPointMake(squareWidth / 2.0 + sideLength / 2.0 - offset, squareWidth - (squareWidth - length) / 2.0);
    CGFloat angle = M_PI;
    [path moveToPoint:point];
    
    // draw the sides and rounded corners of the polygon
    
    for (NSInteger side = 0; side < sides; side++) {
        point = CGPointMake(point.x + (sideLength - offset * 2.0) * cosf(angle), point.y + (sideLength - offset * 2.0) * sinf(angle));
        [path addLineToPoint:point];
        
        CGPoint center = CGPointMake(point.x + cornerRadius * cosf(angle + M_PI_2), point.y + cornerRadius * sinf(angle + M_PI_2));
        [path addArcWithCenter:center radius:cornerRadius startAngle:angle - M_PI_2 endAngle:angle + theta - M_PI_2 clockwise:YES];
        
        point = path.currentPoint; // we don't have to calculate where the arc ended ... UIBezierPath did that for us
        angle += theta;
    }
    
    [path closePath];
    
    return path;
}



-(void)drawImageView{
    
    for (int i = 0; i<6; i++) {
        
        
        switch (i) {
            case 0:
                self.dashboardImageView = [[UIImageView alloc]init];
                [self.view addSubview:self.dashboardImageView];
                [self.dashboardImageView setFrame:CGRectMake(screenWidth/2-ScreenWidthFactor*100, screenHeight/2-ScreenHeightFactor*200, ScreenWidthFactor*100, ScreenWidthFactor*100)];
                if (screenWidth>700) {
                    [self.dashboardImageView setImage:[UIImage imageNamed:@"post_card_iPad.png"]];
                }
                else{
                    if (screenWidth>320) {
                         [self.dashboardImageView setImage:[UIImage imageNamed:@"post_card_iPhone6.png"]];
                    }
                    else{
                         [self.dashboardImageView setImage:[UIImage imageNamed:@"post_card_iPhone5.png"]];
                    }
                }
                dashboardComponentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dashboardImageView.frame.origin.x-ScreenWidthFactor*45, self.dashboardImageView.frame.origin.y-ScreenHeightFactor*30, self.dashboardImageView.frame.size.width/2+ScreenWidthFactor*20, self.dashboardImageView.frame.size.height/2-ScreenHeightFactor*10)];
                [dashboardComponentLabel setFont:[UIFont fontWithName:Gotham size:10]];
                [dashboardComponentLabel setTextColor:[UIColor whiteColor]];
                dashboardComponentLabel.textAlignment = NSTextAlignmentCenter;
                dashboardComponentLabel.text = @"POST CARD";
                [self.dashboardImageView addSubview:dashboardComponentLabel];
                break;
                
            case 1:
                self.dashboardImageView = [[UIImageView alloc]init];
                [self.view addSubview:self.dashboardImageView];
                [self.dashboardImageView setFrame:CGRectMake(screenWidth/2+ScreenWidthFactor*10, screenHeight/2-ScreenHeightFactor*200, ScreenWidthFactor*100, ScreenWidthFactor*100)];
                if (screenWidth>700) {
                    [self.dashboardImageView setImage:[UIImage imageNamed:@"play_wall_iPad.png"]];
                }
                else{
                    if (screenWidth>320) {
                        [self.dashboardImageView setImage:[UIImage imageNamed:@"play_wall_iPhone6.png"]];
                    }
                    else{
                        [self.dashboardImageView setImage:[UIImage imageNamed:@"play_wall_iPhone5.png"]];
                    }
                }
                dashboardComponentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dashboardImageView.frame.origin.x-ScreenWidthFactor*157, self.dashboardImageView.frame.origin.y-ScreenHeightFactor*30, self.dashboardImageView.frame.size.width/2+ScreenWidthFactor*20, self.dashboardImageView.frame.size.height/2-ScreenHeightFactor*10)];
                [dashboardComponentLabel setFont:[UIFont fontWithName:Gotham size:10]];
                [dashboardComponentLabel setTextColor:[UIColor whiteColor]];
                dashboardComponentLabel.textAlignment = NSTextAlignmentCenter;
                dashboardComponentLabel.text = @"PLAYWALL";
                [self.dashboardImageView addSubview:dashboardComponentLabel];
                break;
                
            case 2:
                self.dashboardImageView = [[UIImageView alloc]init];
                [self.view addSubview:self.dashboardImageView];
                [self.dashboardImageView setFrame:CGRectMake(screenWidth/2-ScreenWidthFactor*45, screenHeight/2-ScreenHeightFactor*100, ScreenWidthFactor*100, ScreenWidthFactor*100)];
                if (screenWidth>700) {
                    [self.dashboardImageView setImage:[UIImage imageNamed:@"point_iPad.png"]];
                }
                else{
                    if (screenWidth>320) {
                        [self.dashboardImageView setImage:[UIImage imageNamed:@"point_iPhone5.png"]];
                    }
                    else{
                        [self.dashboardImageView setImage:[UIImage imageNamed:@"point_iPhone6.png"]];
                    }
                }
                dashboardComponentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dashboardImageView.frame.origin.x-ScreenWidthFactor*97, self.dashboardImageView.frame.origin.y-ScreenHeightFactor*128, self.dashboardImageView.frame.size.width/2+ScreenWidthFactor*20, self.dashboardImageView.frame.size.height/2-ScreenHeightFactor*10)];
                [dashboardComponentLabel setFont:[UIFont fontWithName:Gotham size:10]];
                [dashboardComponentLabel setTextColor:[UIColor whiteColor]];
                dashboardComponentLabel.textAlignment = NSTextAlignmentCenter;
                dashboardComponentLabel.text = @"POINTS";
                [self.dashboardImageView addSubview:dashboardComponentLabel];
                break;
                
            case 3:
                self.dashboardImageView = [[UIImageView alloc]init];
                [self.view addSubview:self.dashboardImageView];
                [self.dashboardImageView setFrame:CGRectMake(screenWidth/2-ScreenWidthFactor*100, screenHeight/2-ScreenHeightFactor*5, ScreenWidthFactor*100, ScreenWidthFactor*100)];
                if (screenWidth>700) {
                    [self.dashboardImageView setImage:[UIImage imageNamed:@"buddies_iPad.png"]];
                }
                else{
                    if (screenWidth>320) {
                        [self.dashboardImageView setImage:[UIImage imageNamed:@"buddies_iPhone6.png"]];
                    }
                    else{
                        [self.dashboardImageView setImage:[UIImage imageNamed:@"buddies_iPhone5.png"]];
                    }
                }
                dashboardComponentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dashboardImageView.frame.origin.x-ScreenWidthFactor*46, self.dashboardImageView.frame.origin.y-ScreenHeightFactor*229, self.dashboardImageView.frame.size.width/2+ScreenWidthFactor*20, self.dashboardImageView.frame.size.height/2-ScreenHeightFactor*10)];
                [dashboardComponentLabel setFont:[UIFont fontWithName:Gotham size:10]];
                [dashboardComponentLabel setTextColor:[UIColor whiteColor]];
                dashboardComponentLabel.text = @"BUDDIES";
                dashboardComponentLabel.textAlignment = NSTextAlignmentCenter;
                [self.dashboardImageView addSubview:dashboardComponentLabel];
                break;
                
            case 4:
                self.dashboardImageView = [[UIImageView alloc]init];
                [self.view addSubview:self.dashboardImageView];
                [self.dashboardImageView setFrame:CGRectMake(screenWidth/2+ScreenWidthFactor*10, screenHeight/2-ScreenHeightFactor*5, ScreenWidthFactor*100, ScreenWidthFactor*100)];
                if (screenWidth>700) {
                    [self.dashboardImageView setImage:[UIImage imageNamed:@"wishlist_iPad.png"]];
                }
                else{
                    if (screenWidth>320) {
                        [self.dashboardImageView setImage:[UIImage imageNamed:@"wishlist_iPhone6.png"]];
                    }
                    else{
                        [self.dashboardImageView setImage:[UIImage imageNamed:@"wishlist_iPhone5.png"]];
                    }
                }
                dashboardComponentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dashboardImageView.frame.origin.x-ScreenWidthFactor*156, self.dashboardImageView.frame.origin.y-ScreenHeightFactor*229, self.dashboardImageView.frame.size.width/2+ScreenWidthFactor*20, self.dashboardImageView.frame.size.height/2-ScreenHeightFactor*10)];
                [dashboardComponentLabel setFont:[UIFont fontWithName:Gotham size:10]];
                [dashboardComponentLabel setTextColor:[UIColor whiteColor]];
                dashboardComponentLabel.text = @"WISHLIST";
                dashboardComponentLabel.textAlignment = NSTextAlignmentCenter;
                [self.dashboardImageView addSubview:dashboardComponentLabel];
                break;
                
            case 5:
                self.dashboardImageView = [[UIImageView alloc]init];
                [self.view addSubview:self.dashboardImageView];
                [self.dashboardImageView setFrame:CGRectMake(screenWidth/2-ScreenWidthFactor*45, screenHeight/2+ScreenHeightFactor*100, ScreenWidthFactor*100, ScreenWidthFactor*100)];
                if (screenWidth>700) {
                    [self.dashboardImageView setImage:[UIImage imageNamed:@"alerts_iPad.png"]];
                }
                else{
                    if (screenWidth>320) {
                        [self.dashboardImageView setImage:[UIImage imageNamed:@"alerts_iPhone6.png"]];
                    }
                    else{
                        [self.dashboardImageView setImage:[UIImage imageNamed:@"alerts_iPhone5.png"]];
                    }
                }
                dashboardComponentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dashboardImageView.frame.origin.x-ScreenWidthFactor*100, self.dashboardImageView.frame.origin.y-ScreenHeightFactor*332, self.dashboardImageView.frame.size.width/2+ScreenWidthFactor*20, self.dashboardImageView.frame.size.height/2-ScreenHeightFactor*10)];
                [dashboardComponentLabel setFont:[UIFont fontWithName:Gotham size:10]];
                [dashboardComponentLabel setTextColor:[UIColor whiteColor]];
                dashboardComponentLabel.text = @"ALERTS";
                 dashboardComponentLabel.textAlignment = NSTextAlignmentCenter;
                [self.dashboardImageView addSubview:dashboardComponentLabel];
                break;
                
            default:
                break;
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
