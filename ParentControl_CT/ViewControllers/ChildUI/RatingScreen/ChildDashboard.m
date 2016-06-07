//
//  ChildDashboard.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ChildDashboard.h"

@interface ChildDashboard ()
{
    NSMutableArray *dashBoardImagesArray;
    UIImageView *childImgview;
    UILabel *earnedLabel, *pendingLabel;
    UILabel *earnedPointLabel, *pendingPointLabel;
    UIButton *doneBtn;
    UIButton *anotherButton;
     UIView *viewBack;
}
@end

@implementation ChildDashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]childdashBoard];
    [self backgroundImage];
    [self childProfileImg];
    [self pointsLabels];
    //[self drawDashBoard];
    [self doneButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)backgroundImage
{
//    UIImageView *bgImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"childRatingBg.png"]];
//    bgImg.frame=CGRectMake(0, 0, screenWidth, screenHeight);
//    bgImg.center=CGPointMake(screenWidth/2, screenHeight/2);
//    [self.view addSubview:bgImg];
    self.view.backgroundColor=[UIColor blackColor];
}

-(void)childProfileImg
{
    
 //  ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)? isiPhoneiPad(@""):iPadAirImage(@"")
    
    childImgview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, screenWidth*.22, screenHeight*.15)];
    // childImgview.image=self.childObjDashBoard.profile_pic;
    childImgview.image=[[PC_DataManager sharedManager]decodeImage:self.childObjDashBoard.profile_pic];
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

-(void)pointsLabels
{
    NSString *str=@"EARNED";
    earnedLabel=[[UILabel alloc]init];
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    earnedLabel.font=[UIFont fontWithName:RobotoRegular size:15.0f];
    earnedLabel.text=str;
    earnedLabel.frame=CGRectMake(.1*screenWidth,.13*screenHeight,displayValueSize.width, displayValueSize.height);
    earnedLabel.textColor=[UIColor whiteColor];
    [earnedLabel sizeToFit];
    [self.view addSubview:earnedLabel];
    
    
    str=@"PENDING";
    pendingLabel=[[UILabel alloc]init];
    displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    pendingLabel.font=[UIFont fontWithName:RobotoRegular size:15.0f];
    pendingLabel.text=str;
    pendingLabel.frame=CGRectMake(screenWidth*.9-displayValueSize.width,.13*screenHeight,displayValueSize.width, displayValueSize.height);
    pendingLabel.textColor=[UIColor whiteColor];
    [pendingLabel sizeToFit];
    [self.view addSubview:pendingLabel];
    
    
    str=self.childObjDashBoard.earnedPts;
    earnedPointLabel=[[UILabel alloc]init];
    displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}];
    earnedPointLabel.font=[UIFont fontWithName:RobotoRegular size:20.0f];
    earnedPointLabel.text=str;
    earnedPointLabel.frame=CGRectMake(.1*screenWidth,.16*screenHeight,displayValueSize.width, displayValueSize.height);
    earnedPointLabel.textColor=buttonGreenColor;
    [earnedPointLabel sizeToFit];
    [self.view addSubview:earnedPointLabel];
    
    
    str=@"8909";
    pendingPointLabel=[[UILabel alloc]init];
    displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}];
    pendingPointLabel.font=[UIFont fontWithName:RobotoRegular size:20.0f];
    pendingPointLabel.text=str;
    pendingPointLabel.frame=CGRectMake(screenWidth*.9-displayValueSize.width,.16*screenHeight,displayValueSize.width, displayValueSize.height);
    pendingPointLabel.textColor=[UIColor orangeColor];
    [pendingPointLabel sizeToFit];
    [self.view addSubview:pendingPointLabel];


}

//-(void)drawDashBoard
//{
//    dashBoardImagesArray=[[NSMutableArray alloc]init];
//    for(int i=0; i<childDashBoardArray.count ; i++)
//    {
//        DashBoardImageView *dashView=[[DashBoardImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth*.26, screenHeight*.17) andImage:[UIImage imageNamed:[childDashBoardArray objectAtIndex:i]]];
//        dashView.center=[[childDashBoardPosArray objectAtIndex:i]CGPointValue];
//        dashView.tag=i;
//        [self.view addSubview:dashView];
//        [dashBoardImagesArray addObject:dashView];
//    }
//}


-(void)goBackBtn
{
    
    viewBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenHeight*.1, screenHeight*.1)];
    [viewBack setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar addSubview:viewBack];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack)];
    [viewBack addGestureRecognizer:gestureRecognizer];
    
    anotherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // anotherButton=[UIButton buttonWithType:UIButtonTypeContactAdd];
    [anotherButton setTitle:@"<" forState:UIControlStateNormal];
    anotherButton.tintColor=[UIColor whiteColor];
    [anotherButton setImage:[UIImage imageNamed:isiPhoneiPad(@"ParentHome_header.png")] forState:UIControlStateNormal];
    [anotherButton setFrame:CGRectMake(0, 0,screenWidth*.08,screenWidth*.08)];
    anotherButton.center=CGPointMake(.07*screenWidth ,.04*screenHeight);
    [self.navigationController.navigationBar addSubview:anotherButton];
    [anotherButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
     viewBack.center=CGPointMake(anotherButton.center.x, anotherButton.center.y);
}
//
-(void)goBack
{
    AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
    UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
    [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
    
}



-(void)doneButton
{
    doneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneBtn setTitle:@"CLOSE" forState:UIControlStateNormal];
    doneBtn.tintColor=[UIColor whiteColor];
    doneBtn.backgroundColor=[UIColor colorWithRed:103.0f/255 green:155.0f/255 blue:73.0f/255 alpha:1.0f];
    doneBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.03*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    doneBtn.frame=CGRectMake(.2*screenWidth, .9*screenHeight, .6*screenWidth, .07*screenHeight);
    doneBtn.layer.cornerRadius=5;
    doneBtn.clipsToBounds=YES;
    // doneBtn.layer.borderWidth=1.0;
    // doneBtn.layer.borderColor=radiobuttonSelectionColor.CGColor;
    [self.view addSubview:doneBtn];
    [doneBtn addTarget:self action:@selector(doneBtnTouched) forControlEvents:UIControlEventTouchUpInside];
}

-(void)doneBtnTouched
{
    exit(1);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    
    for(UIImageView *img in dashBoardImagesArray)
    {
        if(CGRectContainsPoint(img.frame, loc))
        {
            switch (img.tag)
            {
                case 0:
                {
                    NSLog(@"image 1" );
                    break;
                }
                    
                case 1:
                {
                    NSLog(@"image 2" );
                    break;
                    
                }
                    
                    
                case 2:
                {
                    NSLog(@"image 3" );
                    break;
                }
            }
        }
    }

    

}




/** Create UIBezierPath for regular polygon with rounded corners
 *
 * @param square        The CGRect of the square in which the path should be created.
 * @param lineWidth     The width of the stroke around the polygon. The polygon will be inset such that the stroke stays within the above square.
 * @param sides         How many sides to the polygon (e.g. 6=hexagon; 8=octagon, etc.).
 * @param cornerRadius  The radius to be applied when rounding the corners.
 *
 * @return              UIBezierPath of the resulting rounded polygon path.
 */

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
