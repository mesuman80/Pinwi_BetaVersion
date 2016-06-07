//
//  VTPinPadViewController.m
//  PinPad
//
//  Created by Aleks Kosylo on 1/15/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import "PPPinPadViewController.h"
#import "PPPinCircleView.h"
#import "HeaderView.h"



#define PP_SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


typedef NS_ENUM(NSInteger, settingNewPinState) {
    settingMewPinStateFisrt   = 0,
    settingMewPinStateConfirm = 1
};
@interface PPPinPadViewController () <HeaderViewProtocol>{
    NSInteger _shakes;
    NSInteger _direction;
}
@property (nonatomic)                   settingNewPinState  newPinState;
@property (nonatomic,strong)            NSString            *fisrtPassCode;
@property (weak, nonatomic) IBOutlet    UILabel             *laInstructionsLabel;
@end

static  CGFloat kVTPinPadViewControllerCircleRadius = 6.0f;

@implementation PPPinPadViewController
{
    BOOL passcodeExist;
    UIView *translucentView;
    OverLayView *overlayView;
    int pinCentreY;
    HeaderView *headerView;
    
    NSMutableArray *circlePosArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    if(screenWidth>500)
//    {
//      //  NSString *str=[NSString stringWithFormat:@"PPPinPadViewController~ipad",nibNameOrNil];
//       self = [super initWithNibName:@"PPPinPadViewController" bundle:nibBundleOrNil];
//    }
//    else{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//}

    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [[PC_DataManager sharedManager]getWidthHeight];
    [self addTopLayer];
     [self addCircles];
    pinLabel.text = self.pinTitle ? :@"Enter PIN";
    pinErrorLabel.text = self.errorTitle ? : @"Password is incorrect. Please try again.";
  //  pinErrorLabel.center=CGPointMake(self.view.frame.size.width, 50);
    cancelButton.hidden = self.cancelButtonHidden;
    if (self.backgroundImage) {
        backgroundImageView.hidden = NO;
        backgroundImageView.image = self.backgroundImage;
    }
    
    if (self.backgroundColor && !self.backgroundImage) {
        backgroundImageView.hidden = YES;
        self.view.backgroundColor = self.backgroundColor;
    }
    self.laInstructionsLabel.center=CGPointMake(screenWidth/2, self.laInstructionsLabel.center.y);
    forgotPasswordBtn.center=CGPointMake(screenWidth/2, forgotPasswordBtn.center.y);
    
}

-(void)addTopLayer
{
//    UIImageView *topStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")]];
//    [topStrip setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    topStrip.center=CGPointMake(self.view.frame.size.width/2, .04*screenHeight);
//    [self.view addSubview:topStrip];
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:_backgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
       // [headerView setRightType:@"Menu"];
        [headerView setCentreImgName:@"accessProfileIcon.png"];
        [headerView drawHeaderViewWithTitle:@"Enter Passcode" isBackBtnReq:NO BackImage:nil];
        //[self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
        
    }

    
   UIImageView *bottomStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"welcomefooter.png") ]];
    bottomStrip.center=CGPointMake(screenWidth/2, screenHeight-bottomStrip.frame.size.height/2);
    [self.view addSubview:bottomStrip];
    
    [forgotPasswordBtn.titleLabel setFont:[UIFont fontWithName:RobotoBold size:8.0f]];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:RobotoBold size:8.0f]];
    [forgotPasswordBtn setTitleColor:radiobuttonSelectionColor forState:UIControlStateNormal];
    
    
}
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getMenuTouches
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setCancelButtonHidden:(BOOL)cancelButtonHidden{
    _cancelButtonHidden = cancelButtonHidden;
    cancelButton.hidden = cancelButtonHidden;
}

- (void) setErrorTitle:(NSString *)errorTitle{
    _errorTitle = errorTitle;
    pinErrorLabel.text = errorTitle;
}

- (void) setPinTitle:(NSString *)pinTitle{
    _pinTitle = pinTitle;
    pinLabel.text = pinTitle;
}

- (void) setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    backgroundImageView.image = backgroundImage;
    backgroundImageView.hidden = NO;
}

- (void) setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
    backgroundImageView.hidden = YES;
}


- (void)dismissPinPad {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pinPadWillHide)]) {
        [self.delegate pinPadWillHide];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(pinPadDidHide)]) {
            [self.delegate pinPadDidHide];
        }
    }];
}


#pragma mark Status Bar
- (void)changeStatusBarHidden:(BOOL)hidden {
    _errorView.hidden = hidden;
    if (PP_SYSTEM_VERSION_GREATER_THAN(@"6.9")) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return !_errorView.hidden;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)setIsSettingPinCode:(BOOL)isSettingPinCode{
    _isSettingPinCode = isSettingPinCode;
    if (isSettingPinCode) {
        self.newPinState = settingMewPinStateFisrt;
    }
}
#pragma mark Actions

- (IBAction)cancelClick:(id)sender {
    if([self.parentClass isEqualToString:PasscodeParentIsDelegate])
    {
       exit(1); 
    }
    else{
    [self dismissPinPad];
    }
    //exit(1);
}


- (IBAction)resetClick:(id)sender {
      [self deleteCircleFill:_inputPin.length];
//    [self showLoaderView1:YES withText:@"Please Wait..."];
//    [self.delegate pinForgot];
}
- (IBAction)forgotPassword:(id)sender {
    
    [self addOverLay];
    
//       [self.delegate pinForgot];
}
//-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
//    
//    
//}
//-(void)  connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
//{
//    
//    if (passcodeExist==YES) {
//        passcodeExist=NO;
//        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"ForgetPasscodeResponse" resultKey:@"ForgetPasscodeResult"];
//        if(!dict)
//        {
//            return;
//        }
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SuccessFul" message:@"Passcode is sent to your Email Id" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//}

-(void)brightImg:(id)sender
{
    [sender setAlpha:1.0];
}


- (IBAction)numberButtonClick:(id)sender {
    
    [sender setAlpha:0.1];
    [self performSelector:@selector(brightImg:) withObject:sender afterDelay:.15];
    
    if(!_inputPin) {
        _inputPin = [NSMutableString new];
    }
    if(!_errorView.hidden) {
        [self changeStatusBarHidden:YES];
    }
    [_inputPin appendString:[((UIButton*)sender) titleForState:UIControlStateNormal]];
    [self fillingCircle:_inputPin.length - 1];
    
    if (self.isSettingPinCode){
        if ([self pinLenght] == _inputPin.length){
            if (self.newPinState == settingMewPinStateFisrt) {
                self.fisrtPassCode  = _inputPin;
                // reset and prepare for confirmation stage
                [self resetClick:Nil];
                self.newPinState    = settingMewPinStateConfirm;
                // update instruction label
                self.laInstructionsLabel.text = NSLocalizedString(@"Confirm PassCode", @"");
                self.laInstructionsLabel.center=CGPointMake(screenWidth/2, self.laInstructionsLabel.center.y);
                forgotPasswordBtn.center=CGPointMake(screenWidth/2, forgotPasswordBtn.center.y);
            }else{
                // we are at confirmation stage check this pin with original one
                if ([self.fisrtPassCode isEqualToString:_inputPin]) {
                    // every thing is ok
                    if ([self.delegate respondsToSelector:@selector(userPassCode:)]) {
                        [self.delegate userPassCode:self.fisrtPassCode];
                        
                    }
                    [self dismissPinPad];
                }else{
                    // reset to first stage
                    self.laInstructionsLabel.text = NSLocalizedString(@"Enter PassCode", @"");
                    self.laInstructionsLabel.center=CGPointMake(screenWidth/2, self.laInstructionsLabel.center.y);
                    _direction = 1;
                    _shakes = 0;
                    [self shakeCircles:_pinCirclesView];
                    [self changeStatusBarHidden:YES];
                    [self resetClick:Nil];
                    forgotPasswordBtn.center=CGPointMake(screenWidth/2, forgotPasswordBtn.center.y);
                }
            }
        }
    }else{
        if ([self pinLenght] == _inputPin.length && [self checkPin:_inputPin]) {
           
            
            [self dismissViewControllerAnimated:YES completion:^{
                 [self.delegate pinPadSuccessPin];
            }];
//            double delayInSeconds = 0.3;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                NSLog(@"Correct pin");
//                [self resetClick:nil];
//                if (self.delegate && [self.delegate respondsToSelector:@selector(pinPadSuccessPin)]) {
//                    [self.delegate pinPadSuccessPin];
//                }
//                [self dismissPinPad];
//            });
            
        }
        else if ([self pinLenght] == _inputPin.length) {
            _direction = 1;
            _shakes = 0;
            [self shakeCircles:_pinCirclesView];
            [self changeStatusBarHidden:NO];
            NSLog(@"Not correct pin");
        }
    }
}

#pragma mark Delegate & methods

- (void)setDelegate:(id<PinPadPassProtocol>)delegate {
    if(_delegate != delegate) {
        _delegate = delegate;
        [self addCircles];
    }
}

- (BOOL)checkPin:(NSString *)pinString {
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkPin:)]) {
        return [self.delegate checkPin:pinString];
    }
    return NO;
}

- (NSInteger)pinLenght {
    if([self.delegate respondsToSelector:@selector(pinLenght)]) {
        NSLog(@"%i",[self.delegate pinLenght]);
        return [self.delegate pinLenght];
    }
    return 4;
}

-(void)pinPadSuccessPin
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Circles


- (void)addCircles {
    
    if(!circlePosArray && [self isViewLoaded] && self.delegate) {
        [[_pinCirclesView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_circleViewList removeAllObjects];
        _circleViewList = [NSMutableArray array];
        
        if(!circlePosArray)
        {
            circlePosArray=[[NSMutableArray alloc]init];
        }
        else
        {
            [circlePosArray removeAllObjects];
        }
       NSLog(@"self.view.frame.size.width = %f , %f",_pinCirclesView.frame.size.width,_pinCirclesView.frame.size.height);
        CGFloat neededWidth =  [self pinLenght] * kVTPinPadViewControllerCircleRadius;
        CGFloat shiftBetweenCircle = (_pinCirclesView.frame.size.width - neededWidth )/([self pinLenght] +20);
        CGFloat indent= (_pinCirclesView.frame.size.width - neededWidth  - shiftBetweenCircle *([self pinLenght] > 1 ? [self pinLenght]-1 : 0))/2;
        if(shiftBetweenCircle > kVTPinPadViewControllerCircleRadius * 5.0f) {
            shiftBetweenCircle = kVTPinPadViewControllerCircleRadius * 5.0f;
            NSLog(@"self.view.frame.size.width = %f",self.view.frame.size.width);
//            if(screenWidth>700)
//            {
//                indent = 100;
//            }
//            else
//            {
//                
                indent = (_pinCirclesView.frame.size.width - neededWidth  - shiftBetweenCircle *([self pinLenght] > 1 ? [self pinLenght]-1 : 0))/2;
//            }
          
        }
        
        
        int scrnXX;
//       if( isPhone568)
           scrnXX =85*ScreenWidthFactor;
        
        for(int i=0; i < [self pinLenght]; i++)
        {
            PPPinCircleView * circleView = [PPPinCircleView circleView:kVTPinPadViewControllerCircleRadius];
            CGRect circleFrame = circleView.frame;
            circleFrame.origin.x = indent + i * kVTPinPadViewControllerCircleRadius + i*shiftBetweenCircle;
            circleFrame.origin.y = (85*ScreenWidthFactor - kVTPinPadViewControllerCircleRadius)/2.0f;
            circleView.frame = circleFrame;
            
            if(circlePosArray.count<4)
            {
                circleView.center= CGPointMake(circleView.center.x,circleView.center.y);
                [circlePosArray addObject:[NSValue valueWithCGPoint:circleView.center]];
            }
            else
            {
                circleView.center=[[circlePosArray objectAtIndex:i]CGPointValue];
            }
            [_pinCirclesView addSubview:circleView];
            [_circleViewList addObject:circleView];
        }
        
//        if(screenWidth<500)
//        {
//            
        if(isPhone667)
            {
                [_pinCirclesView setCenter:CGPointMake(_pinCirclesView.center.x+20*ScreenWidthFactor,_pinCirclesView.center.y)];
            }
//            else
//            {
//                 [_pinCirclesView setCenter:CGPointMake(screenWidth/2,_pinCirclesView.center.y)];
//            }
//        }
     
    }
}

- (void)fillingCircle:(NSInteger)symbolIndex {
    if(symbolIndex>=_circleViewList.count)
        return;
    PPPinCircleView *circleView = [_circleViewList objectAtIndex:symbolIndex];
    circleView.backgroundColor = buttonGreenColor;//[UIColor colorWithRed:254.0f/255 green:94.0f/255 blue:58.0f/255 alpha:1];
}

-(void)deleteCircleFill:(NSInteger)symbolIndex{
    if(symbolIndex<=0)
    {
        return;
    }
    _inputPin=[[_inputPin substringToIndex:symbolIndex-1]mutableCopy];
    PPPinCircleView *circleView = [_circleViewList objectAtIndex:symbolIndex-1];
    circleView.backgroundColor = [UIColor clearColor];
}

-(void)shakeCircles:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.03 animations:^
     {
         resetButton.userInteractionEnabled=NO;
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*_direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(_shakes >= 15)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             [self addCircles];
             
             self.newPinState    = settingMewPinStateFisrt;
             self.laInstructionsLabel.text = NSLocalizedString(@"Enter PassCode", @"");
             self.laInstructionsLabel.center=CGPointMake(screenWidth/2, self.laInstructionsLabel.center.y);
           //  forgotPasswordBtn.center=CGPointMake(screenWidth/2, forgotPasswordBtn.center.y);
             _inputPin = [NSMutableString string];
        
             
             for (int symbolIndex=0; symbolIndex<_circleViewList.count;symbolIndex++)
             {
                 PPPinCircleView *circleView = [_circleViewList objectAtIndex:symbolIndex];
                 circleView.backgroundColor = [UIColor whiteColor];
             }
             resetButton.userInteractionEnabled=YES;
             return;
         }
         _shakes++;
         _direction = _direction * -1;
         [self shakeCircles:theOneYouWannaShake];
     }];
}


-(void)showLoaderView1:(BOOL)show withText:(NSString *)text
{
    static UILabel *label;
    static UIActivityIndicatorView *activity;
    static UIView *loaderView;
    
    if(show)
    {
        loaderView=[[UIView alloc] initWithFrame:self.view.bounds];
        [loaderView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.4]];
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(0, (loaderView.bounds.size.height/2)-10, loaderView.bounds.size.width, 20)];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        label.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*.40f);
        [label setText:text];
        [label setTextAlignment:NSTextAlignmentCenter];
        [loaderView addSubview:label];
        
        activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center=CGPointMake(label.center.x, label.frame.origin.y+label.frame.size.height+10+activity.frame.size.height/2);
        [activity startAnimating];
        [loaderView addSubview:activity];
        [self.view addSubview:loaderView];
    }else
    {
        // isTimeOut=NO;
        [label removeFromSuperview];
        [activity removeFromSuperview];
        [loaderView removeFromSuperview];
        label=nil;
        activity=nil;
        loaderView=nil;
    }
}

#pragma mark FORGOT PASSCODE FUNCTION
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    [self showLoaderView1:NO withText:@""];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    [self showLoaderView1:NO withText:@""];
    if([connection.serviceName isEqualToString:@"RecoverPasscode"])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"RecoverPasscodeResponse" resultKey:@"RecoverPasscodeResult"];
        if(!dict)
        {
            return;
        }
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Recover Passcode" message:@"Your Passcode has been sent to your registered email ID." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        alert.tag=1;
        [alert show];
    }
}

#pragma mark UIAlert delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0 && alertView.tag==1)
    {
        if([self.parentClass isEqualToString:PasscodeParentIsDelegate])
        {
            exit(1);
        }
        else
        {
            [self.delegate pinForgot];
        }
    }
}


#pragma Load recover Passcode Screen
-(void)addOverLay
{
    translucentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    translucentView.backgroundColor=[UIColor blackColor];
    translucentView.alpha=0.7;
    [self.view addSubview:translucentView];
    
    
    UITapGestureRecognizer *removeResend=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeResendScreen:)];
    [translucentView addGestureRecognizer:removeResend];
    
    overlayView=[[OverLayView alloc]initWithFrame:CGRectMake(0, screenHeight*.8, screenWidth, screenHeight*.2)withInfoText:@"" AndButtonText:@"Send" withHEading:@"Recover Passcode?"];
    overlayView.overLayDelegate=self;
    // goAheadView.tintColor=confirmcolorcode;
    [self.view addSubview:overlayView];
}


-(void)removeResendScreen:(id)sender
{
    [translucentView removeFromSuperview];
    translucentView=nil;
    [overlayView removeFromSuperview];
    overlayView=nil;
}

-(void)continueTouched
{
    [translucentView removeFromSuperview];
    translucentView=nil;
    //isPasscode=YES;
    RecoverPasscode *forgotPasscode = [[RecoverPasscode alloc] init];
    [forgotPasscode initService:@{@"ProfileID":[PC_DataManager sharedManager].parentObjectInstance.parentId
                                  }];
    [forgotPasscode setDelegate:self];
    forgotPasscode.serviceName=@"RecoverPasscode";
    [self showLoaderView1:YES withText:@"Wait..."];
}





@end
