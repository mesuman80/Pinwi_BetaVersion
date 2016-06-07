//
//  ViewController.m
//  CircleAnim
//
//  Created by Suman Bhattacharyya on 19/04/15.
//  Copyright (c) 2015 Suman Bhattacharyya. All rights reserved.
//

#import "ChildSubjectRatingViewController.h"
#import "PinwiWheel.h"
#import "Constant.h"
#import "ChildSubjectRating.h"
#import "AddActivityRating.h"
#import "Sound.h"
#import "ShowActivityLoadingView.h"
#import "TutorialPlayView.h"
#import "PlayFirstTimeChildTutorial_VC.h"

static int DaysAgoValue;
@interface ChildSubjectRatingViewController ()<UIAlertViewDelegate,SounPlayerProtocol>
{
    // JUST COPY THESE 2 METHODS
    
    PinwiWheel * pinwiWheel;
    UIImageView *subImg;
    int subCounter, waitCnt;
    NSMutableArray *stars;
    NSMutableArray *rate;
    
    UIButton *soundBtn, *anotherButton;
    UIButton *micBtn;
    UIButton *doneBtn;
    UIButton *dontLikeBtn;
    UIImageView *skipDoneButton;
    
    UIImageView *soundButton, *voiceOverButton;
    
    int clickCounter;
    NSString *clickStr;
    
    UIView *currentView;
    
    NSMutableArray *childSubjectRatingArray;
    ShowActivityLoadingView *loaderView;
    
    UILabel *titleLabel;
    
    NSString *ratingStr;
    Sound *soundObject;
    BOOL soundFinish;
    BOOL soundSkip;
    int touchCounter;
    int touchCounter1;
    
    NSMutableArray *imagesArraySmiley;
    NSMutableArray *voiceOverArray;
    int voiceOverIndex;
    UIImageView *arrowIndicator;
    UITapGestureRecognizer *arrowGesture;
    
    BOOL tutDone;
    BOOL onlyOnceNew;
    BOOL arrowRotationDone;
    
    NSString *soundPlayString;
    NSString *voicePlayString;
    
@private CGFloat imageAngle;
@private OneFingerRotationGestureRecognizer *gestureRecognizer;
    
}
@end

@implementation ChildSubjectRatingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:GothamMedium size:13*ScreenFactor],
      NSFontAttributeName, nil]];
    
    ratingStr = @"";
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.navigationController.navigationBarHidden=YES;
    
    soundPlayString=[NSString stringWithFormat:@"SoundOnOff-%@",self.rateChilObj.child_ID];
    voicePlayString=[NSString stringWithFormat:@"VoiceOverOnOff-%@",self.rateChilObj.child_ID];
    
    if(!tutDone && !self.isSoundPlaying)
    {
        
        NSString *str=[NSString stringWithFormat:@"ChildTutorialb-%@",self.rateChilObj.child_ID];
        if([[[NSUserDefaults standardUserDefaults]objectForKey:str]isEqualToString:@"1"])
        {
            tutDone=YES;
            TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
            tutorial.tutorialName=@"Child Tutorial";
            tutorial.loadIndexVal=childTutNextIndex;
            tutorial.statusCountIndex=self.statusCount;
            tutorial.isSoundPlaying=YES;
            tutorial.autoSkip=YES;
            tutorial.child=self.rateChilObj;
            [self presentViewController:tutorial animated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:str];
        }
        else
            if(![[[NSUserDefaults standardUserDefaults]objectForKey:str]isEqualToString:@"1"])
            {
                tutDone=YES;
//                PlayFirstTimeChildTutorial_VC *platFTut=[[PlayFirstTimeChildTutorial_VC alloc]init];
//                platFTut.childObj=self.rateChilObj;
//                platFTut.gotoClass=@"Rating";
//                [self.navigationController presentViewController:platFTut animated:YES completion:nil];
                TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
                tutorial.tutorialName=@"Child Tutorial";
                tutorial.loadIndexVal=childTutIndex;
                tutorial.isSoundPlaying=YES;
                tutorial.child=self.rateChilObj;
  //              [self presentViewController:tutorial animated:YES completion:nil];
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:str];
            }
    }
    else
    {
       // [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"ChildTutorial"];
        
        clickCounter = 1;
        [[PC_DataManager sharedManager]getWidthHeight];
        [[PC_DataManager sharedManager]childdashBoard];
        imageAngle = 0;
        UIView *view ;
        
        //    if(screenWidth>700)
        //    {
        //    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, screenWidth, ScreenHeightFactor*100)];
        //        [self.view setBackgroundColor:[UIColor orangeColor]];
        //    view = [[UIView alloc]initWithFrame:CGRectMake(0,12*ScreenHeightFactor, screenWidth, ScreenHeightFactor*100)];
        //    }
        //    else
        //    {
        childSubjectRatingArray = [[NSMutableArray alloc]init];
        imagesArraySmiley=[[NSMutableArray alloc]initWithObjects:@"s1.png",@"s2.png",@"s3.png",@"s4.png",@"s5.png",@"s6.png",@"s7.png",@"s8.png",@"s9.png",@"s10.png", nil];
        voiceOverArray=[[NSMutableArray alloc]initWithObjects:@"VO1",@"VO2",@"VO3",@"VO4",@"VO5",@"VO6",@"VO7",@"VO8",@"VO9",@"VO10", nil];
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth, screenHeight)];
        //    }
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        currentView = view;
        [self updateView:view];
        soundObject=[[Sound alloc]init];
        soundObject.soundDelegate=self;
        soundObject.child=self.rateChilObj;
        soundFinish=NO;
        soundSkip=NO;
        voiceOverIndex=1;
        [soundObject playButtonSound:@"pageFlip" withFormat:@"mp3"];
        [self drawArrow];
    }
    
    
    //[self.navigationController.navigationBar setFrame:CGRectMake(0, 0, screenWidth, ScreenHeightFactor*100)];
}

+(void)setDaysAgoValue:(int)daysAgo{
    DaysAgoValue = daysAgo;
}

-(void)navigationControllerSetUp:(UIView*)view
{
    NSLog(@"NavigatoinController Setup");
    
    //    titleLabel.text =[[_allData objectAtIndex:clickCounter]valueForKey:@"Name"];
    //    titleLabel.text=[titleLabel.text uppercaseString];
    
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    UIImageView *headView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"child_headerBg.png")]];
    [headView setFrame:CGRectMake(0, 0, screenWidth, headView.image.size.height)];
    [view addSubview:headView];
    
    
    NSString *str=[[_allData objectAtIndex:clickCounter-1]valueForKey:@"Name"];//[[activityArray objectAtIndex:completedActivity] objectForKey:@"Name"];
    str= [str uppercaseString];
    titleLabel=[[UILabel alloc]init];
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30*ScreenFactor]}];
    
    titleLabel.text=str;
    titleLabel.frame=CGRectMake(0,0,displayValueSize.width,displayValueSize.height);
    if(titleLabel.frame.size.width>150*ScreenWidthFactor)
    {
       titleLabel.frame=CGRectMake(0,0,ScreenWidthFactor*145,displayValueSize.height);
    }
    titleLabel.center=CGPointMake(screenWidth*.4, headView.center.y+8*ScreenHeightFactor);
    titleLabel.textColor=[[UIColor whiteColor]colorWithAlphaComponent:0.8f];
    titleLabel.font=[UIFont fontWithName:Gotham size:10*ScreenFactor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    //[titleLabel sizeToFit];
    [view addSubview:titleLabel];
    
    
    
    
    //    [childSubjectRatingArray addObject:[_allData objectAtIndex:clickCounter]];
    
    soundButton = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-40*ScreenWidthFactor, 0,30*ScreenHeightFactor,30*ScreenHeightFactor)];
    
   //  NSString *soundPlayString=[NSString stringWithFormat:@"SoundOnOff-%@",self.rateChilObj];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:soundPlayString]isEqualToString:@"0"])
    {
        [soundButton setImage:[UIImage imageNamed:isiPhoneiPad(@"mute.png")]];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:soundPlayString];
    }
    else
    {
        [soundButton setImage:[UIImage imageNamed:isiPhoneiPad(@"volume.png")]];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:soundPlayString];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    [soundButton setCenter:CGPointMake(screenWidth-0.07*screenWidth, headView.frame.size.height/2.0f+5*ScreenHeightFactor)];
    [view addSubview:soundButton];
    [soundButton setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *recognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(soundButtonClicks:)];
    [soundButton addGestureRecognizer:recognizer];
    
    
    voiceOverButton = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-40*ScreenWidthFactor, 0,30*ScreenHeightFactor,30*ScreenHeightFactor)];
    
    
    if( [[[NSUserDefaults standardUserDefaults]valueForKey:voicePlayString]isEqualToString:@"0"])
    {
        [voiceOverButton setImage:[UIImage imageNamed:isiPhoneiPad(@"soundSpeakOff.png")]];
         [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:voicePlayString];
    }
    else
    {
        [voiceOverButton setImage:[UIImage imageNamed:isiPhoneiPad(@"soundSpeak.png")]];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:voicePlayString];
    }
     [[NSUserDefaults standardUserDefaults]synchronize];
    [voiceOverButton setCenter:CGPointMake(soundButton.frame.origin.x-voiceOverButton.frame.size.width/2-cellPadding, headView.frame.size.height/2.0f+5*ScreenHeightFactor)];
    [view addSubview:voiceOverButton];
    [voiceOverButton setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *recognizerVoice= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(voiceButtonClicks:)];
    [voiceOverButton addGestureRecognizer:recognizerVoice];

    
    
    
    
    //    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    //    [self.navigationController.navigationBar setAlpha:0.0];
    if(clickCounter==1)
    {
        UIView *viewBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenHeight*.1, screenHeight*.1)];
        [viewBack setBackgroundColor:[UIColor clearColor]];
        [view addSubview:viewBack];
        UITapGestureRecognizer *gestureRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack)];
        [viewBack addGestureRecognizer:gestureRecognizer1];
        
        anotherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        anotherButton.tintColor=[UIColor whiteColor];
        [anotherButton setImage:[UIImage imageNamed:isiPhoneiPad(@"accessProfileBack.png")] forState:UIControlStateNormal];
        
        
        if(self.view.frame.size.width>700)
        {
            [anotherButton setFrame:CGRectMake(screenWidth*.03, 0,screenWidth*.05,screenWidth*.05)];
            //  anotherButton.center=CGPointMake(.04*screenWidth ,.02*screenHeight);
        }
        else
        {
            [anotherButton setFrame:CGRectMake(screenWidth*.03, 0,screenWidth*.08,screenWidth*.08)];
            // anotherButton.center=CGPointMake(.07*screenWidth ,.04*screenHeight);
            
        }
        
        [anotherButton setFrame:CGRectMake(40*ScreenWidthFactor, 0,30*ScreenHeightFactor,30*ScreenHeightFactor)];
        [anotherButton setCenter:CGPointMake(ScreenWidthFactor*20, headView.frame.size.height/2.0f+5*ScreenHeightFactor)];
        //  anotherButton.center=CGPointMake(anotherButton.center.x,view.frame.size.height-anotherButton.frame.size.height/2-5);
        [view addSubview:anotherButton];
        viewBack.center=CGPointMake(anotherButton.center.x, anotherButton.center.y);
        
        [anotherButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)soundButtonClicks:(id)sender
{
    NSLog(@"SoundButtonCLick");
   // touchCounter++;
   
    if([[[NSUserDefaults standardUserDefaults]valueForKey:soundPlayString]isEqualToString:@"1"])
    {
        [soundButton setImage:[UIImage imageNamed:isiPhoneiPad(@"mute.png")]];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:soundPlayString];
        [soundObject stopSound];
    }
    else{
        [soundButton setImage:[UIImage imageNamed:isiPhoneiPad(@"volume.png")]];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:soundPlayString];
    }
     [soundObject playButtonSound:@"two_tone_nav" withFormat:@".mp3"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)voiceButtonClicks:(id)sender
{
    NSLog(@"VoiceButtonCLick");
  //  touchCounter1++;
    [soundObject playButtonSound:@"two_tone_nav" withFormat:@".mp3"];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:voicePlayString]isEqualToString:@"1"])
    {
        [voiceOverButton setImage:[UIImage imageNamed:isiPhoneiPad(@"soundSpeakOff.png")]];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:voicePlayString];
      //  [soundObject stopSound];
        [soundObject stopVoiceOver];
    }
    else{
        [voiceOverButton setImage:[UIImage imageNamed:isiPhoneiPad(@"soundSpeak.png")]];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:voicePlayString];
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}



-(void)goBack
{
    [soundObject stopSound];
    [soundObject stopVoiceOver];
    [soundObject playPageFlipSound:@"pageFlip" withFormat:@"mp3"];
    
    AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
    UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
    [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
}

-(void)mikeButtonClicks:(id)sender
{
    NSLog(@"MikeButtonCLick");
}
-(void)backgroundImage:(UIView *)view
{
    UIImageView *bgImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"ChildPinwheelBgText.png")]];
    bgImg.frame=CGRectMake(0, 0, screenWidth, screenHeight);
    bgImg.center=CGPointMake(screenWidth/2, screenHeight/2);
    [view addSubview:bgImg];
}

-(void)updateView:(UIView *)view
{
    
    [self backgroundImage:view];
    [self navigationControllerSetUp:view];
    
    [self subjectNameLAbel:view];
    [self setupPinwheel:view];
    // if(clickCounter<=1)
    //{
    [self drawRating:view];
    //}
    
    [self drawStars:view];
    [self dontlikeButton:view];
    [self doneButton:view];
    [self drawSubjectImage:view];
    clickStr = @"";
}
-(void)subjectNameLAbel:(UIView *)view
{
    //    NSString *str=@"English";//[[activityArray objectAtIndex:completedActivity] objectForKey:@"Name"];
    //    titleLabel=[[UILabel alloc]init];
    //    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}];
    //    titleLabel.font=[UIFont fontWithName:GothamMedium size:14*ScreenFactor];
    //    titleLabel.text=str;
    //    titleLabel.frame=CGRectMake(0,0,displayValueSize.width,displayValueSize.height);
    //    titleLabel.center=CGPointMake(screenWidth/2, screenHeight*.08);
    //    titleLabel.textColor=[UIColor whiteColor];
    //    [titleLabel sizeToFit];
    //    [self.view addSubview:titleLabel];
}

-(void)drawSoundButton:(UIView *)view
{
    //    soundBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    //soundBtn.tintColor=textBlueColor;
    //    soundBtn.frame=CGRectMake(0, 0, screenWidth*.08, screenHeight*.06);
    //    soundBtn.center=CGPointMake(.87*screenWidth ,.08*screenHeight);
    //    [soundBtn setImage:[UIImage imageNamed:@"sound.png"] forState:UIControlStateNormal];
    //    [soundBtn setImage:[UIImage imageNamed:@"sound_selected.png"] forState:UIControlStateSelected];
    //    [self.view addSubview:soundBtn];
    //    //[soundBtn addTarget:self action:@selector(addNewActivity) forControlEvents:UIControlEventTouchUpInside];
    //
    //    micBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    //micBtn.tintColor=textBlueColor;
    //    micBtn.frame=CGRectMake(0, 0, screenWidth*.08, screenHeight*.06);
    //    micBtn.center=CGPointMake(.95*screenWidth ,.08*screenHeight);
    //    [micBtn setImage:[UIImage imageNamed:@"mic.png"] forState:UIControlStateNormal];
    //     [micBtn setImage:[UIImage imageNamed:@"mic_selected.png"] forState:UIControlStateSelected];
    //    [self.view addSubview:micBtn];
    //[micBtn addTarget:self action:@selector(addNewActivity) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)dontlikeButton:(UIView *)view
{
    //    dontLikeBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [dontLikeBtn setTitle:@"I didn't like this >" forState:UIControlStateNormal];
    //    dontLikeBtn.tintColor=[UIColor whiteColor];
    //    //dontLikeBtn.backgroundColor=[UIColor colorWithRed:103.0f/255 green:155.0f/255 blue:73.0f/255 alpha:1.0f];
    //    dontLikeBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:25.0f];
    //    dontLikeBtn.frame=CGRectMake(.2*screenWidth, .93*screenHeight, .6*screenWidth, .05*screenHeight);
    //
    //    dontLikeBtn.center=CGPointMake(screenWidth/2, dontLikeBtn.center.y);
    //    // doneBtn.layer.borderWidth=1.0;
    //    // doneBtn.layer.borderColor=radiobuttonSelectionColor.CGColor;
    //    [self.view addSubview:dontLikeBtn];
    //    [dontLikeBtn addTarget:self action:@selector(doneBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)doneButton:(UIView *)view
{
    //    doneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [doneBtn setTitle:@"DONE" forState:UIControlStateNormal];
    //    doneBtn.tintColor=[UIColor whiteColor];
    //    doneBtn.backgroundColor=[UIColor colorWithRed:103.0f/255 green:155.0f/255 blue:73.0f/255 alpha:1.0f];
    //    doneBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.03*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    //     doneBtn.frame=CGRectMake(.61*screenWidth, .37*screenHeight, .32*screenWidth, .05*screenHeight);
    //    doneBtn.layer.cornerRadius=5;
    //    doneBtn.clipsToBounds=YES;
    //    [self.view addSubview:doneBtn];
    //    [doneBtn addTarget:self action:@selector(doneBtnTouched) forControlEvents:UIControlEventTouchUpInside];
}

-(void)doneBtnTouched
{
    NSLog(@"Done Button Touches");
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"SoundOnOff"]isEqualToString:@"1"])
    {
    soundFinish=YES;
    [soundObject playButtonSound:@"two_tone_nav" withFormat:@"mp3"];
    }
    else
    {
        [self makeChnagesOnDoneBtnClick];
        soundFinish=NO;
    }
    
}
-(void)makeChnagesOnDoneBtnClick
{
    [soundObject stopSound];
    [soundObject stopVoiceOver];
    if(clickCounter<self.allData.count)
    {
        NSDictionary *dictionary = [_allData objectAtIndex:clickCounter];
        NSString *title  = [dictionary valueForKey:@"Name"];
        title=[title uppercaseString];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, screenWidth, ScreenHeightFactor*100)];
        ChildSubjectRating *childRating = [[ChildSubjectRating alloc]init];
        [childRating updateRating:[_allData objectAtIndex:clickCounter-1] rating:[NSString stringWithFormat:@"%i",subCounter]];
        [childSubjectRatingArray addObject:childRating];
        
        NSDictionary *dictionary1 =[_allData objectAtIndex:clickCounter-1];
        
        if(ratingStr.length > 0/*[PC_DataManager sharedManager].actRatingString*/)
        {
            //  [PC_DataManager sharedManager].actRatingString=[[[PC_DataManager sharedManager].actRatingString stringByAppendingString:@","] mutableCopy];
            ratingStr=[ratingStr stringByAppendingString:@","];
        }
        
        //  [PC_DataManager sharedManager].actRatingString=[[[PC_DataManager sharedManager].actRatingString stringByAppendingString:[NSString stringWithFormat:@"%@-%@",[dictionary1 valueForKey:@"ActivityID"],[NSString stringWithFormat:@"%i",subCounter]]] mutableCopy];
        
        ratingStr=[ratingStr stringByAppendingString:[NSString stringWithFormat:@"%@-%@",[dictionary1 valueForKey:@"ActivityID"],[NSString stringWithFormat:@"%i",subCounter+1]]];
        
        UIView *view  = [[UIView alloc]initWithFrame:self.view.bounds];
        [view setCenter:CGPointMake((screenWidth*3)/2, screenHeight/2)];
        [self.view addSubview:view];
        clickCounter++;
        [self updateView:view];
        
        
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            titleLabel.text =title;
            if(!onlyOnceNew)
            {
                onlyOnceNew=YES;
            [soundObject playVoiceOverSounds:@"VO4" withFormat:@"m4a"];
            }
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            [view setCenter:CGPointMake(screenWidth/2, screenHeight/2)];
            [currentView setCenter:CGPointMake(-3/2*screenWidth, screenHeight/2)];
            
        } completion:^(BOOL finished) {
            [currentView removeFromSuperview];
            [arrowIndicator removeFromSuperview];
            
            currentView = view;
        }];
        
        
    }
    else
    {
        
        ChildSubjectRating *childRating = [[ChildSubjectRating alloc]init];
        [childRating updateRating:[_allData objectAtIndex:clickCounter-1] rating:[NSString stringWithFormat:@"%i",subCounter]];
        [childSubjectRatingArray addObject:childRating];
        
        NSDictionary *dictionary1 =[_allData objectAtIndex:clickCounter-1];
        
        if(ratingStr.length > 0)
        {
            ratingStr=[ratingStr stringByAppendingString:[NSString stringWithFormat:@",%@-%@",[dictionary1 valueForKey:@"ActivityID"],[NSString stringWithFormat:@"%i",subCounter]]];
        }else{
            ratingStr=[ratingStr stringByAppendingString:[NSString stringWithFormat:@"%@-%@",[dictionary1 valueForKey:@"ActivityID"],[NSString stringWithFormat:@"%i",subCounter+1]]];
        }
        
        
     /*   if([PC_DataManager sharedManager].actRatingString)
        {
            //  [PC_DataManager sharedManager].actRatingString=[[[PC_DataManager sharedManager].actRatingString stringByAppendingString:@","] mutableCopy];
            
            
        }
        else
        {
            ratingStr=[NSString stringWithFormat:@"%@-%@",[dictionary1 valueForKey:@"ActivityID"],[NSString stringWithFormat:@"%i",subCounter]];
        }
      */
        // ratingStr=[ratingStr stringByAppendingString:[NSString stringWithFormat:@",%@-%@",[dictionary1 valueForKey:@"ActivityID"],[NSString stringWithFormat:@"%i",subCounter]]];
        
        //   [PC_DataManager sharedManager].actRatingString=[[[PC_DataManager sharedManager].actRatingString stringByAppendingString:[NSString stringWithFormat:@"%@-%@",[dictionary1 valueForKey:@"ActivityID"],[NSString stringWithFormat:@"%i",subCounter]]] mutableCopy];
        
        NSLog(@"rating value--- %@",ratingStr);
        [self activityRatingServices:dictionary1];
        
        
        NSLog(@"Child Subject Rating Arry = %@",childSubjectRatingArray);
        
    }
    
}


-(void)drawSubjectImage:(UIView *)view
{
    // subImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"subject.png"]];
    subImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad([imagesArraySmiley objectAtIndex:0])]];
    subImg.frame=CGRectMake(0, 0, screenWidth*.43, screenWidth*.43);
    if(screenWidth>700)
    {
         subImg.frame=CGRectMake(0, 0, screenWidth*.4, screenWidth*.4);
    }
    subImg.center=CGPointMake(subImg.frame.size.width/2+screenWidth*.04, screenHeight*.30);
    [view addSubview:subImg];
}

-(void)setupPinwheel:(UIView *)view
{
    pinwiWheel = [[PinwiWheel alloc]initWithFrame:CGRectMake(0, 0, screenWidth*.75, screenWidth*.75)andImage:[UIImage imageNamed:isiPhoneiPad(@"pin-wheel.png")]];
    pinwiWheel.center= CGPointMake(screenWidth/2, screenHeight*.695);
    if(screenWidth>700)
    {
        pinwiWheel.frame=CGRectMake(0, 0, screenWidth*.53, screenWidth*.53);
        pinwiWheel.center= CGPointMake(screenWidth/2, screenHeight*.715);
    }
    
    
    [view addSubview:pinwiWheel];
    pinwiWheel.userInteractionEnabled= YES;
    pinwiWheel.childRateVc = self;
    
    subCounter = 0;
    waitCnt = 0;
    
    imageAngle = 0;
    pinwiWheel.transform = CGAffineTransformIdentity;
    
    [self setupGestureRecognizer];
}



///////////////////////////////////////

- (void) rotation: (CGFloat) angle
{
    NSLog(@"angle   %f", angle);
    
    if(angle>0)
    {
        //[skipDoneButton setImage:nil];
        [self updateElements];
        
    }
    else
    {
        [self reverseUpdateElements];
        
    }
    
    // calculate rotation angle
    imageAngle += angle;
    if (imageAngle > 360)
    {
        imageAngle -= 360;
    }
    else if (imageAngle < -360)
    {
        imageAngle += 360;
    }
    
    // rotate image and update text field
    pinwiWheel.transform = CGAffineTransformMakeRotation(imageAngle *  M_PI / 180);
    
    //[self updateElements];
    
}


- (void) reverseUpdateElements
{
    waitCnt--;
    if(waitCnt == -10 && subCounter >=0)
    {
        [soundObject playWheelRotationSound:@"wheelRotation" withFormat:@"mp3"];
        [subImg setImage:[UIImage imageNamed:isiPhoneiPad([imagesArraySmiley objectAtIndex:subCounter])]];
        [[stars objectAtIndex:subCounter]setAlpha:0.4f];
        waitCnt=0;
        subCounter--;
        
        if(subCounter <0){
            subCounter=0;
            [[stars objectAtIndex:0]setAlpha:0.4f];
        }
        
    }
    
    if(subCounter <= 0)
    {
        [[stars objectAtIndex:0]setAlpha:0.4f];
        clickStr=@"Skip";
        [skipDoneButton setImage:[UIImage imageNamed:isiPhoneiPad(@"Skip.png")]];
    }
    
    if(!arrowRotationDone)
    {
        arrowRotationDone=YES;
        [self touchAtArrowBlink:nil];
    }
}


- (void) updateElements
{
    waitCnt++;
    if(waitCnt == 10 &&  subCounter < 10)
    {
        [[stars objectAtIndex:subCounter] setAlpha:1.0f];
        [subImg setImage:[UIImage imageNamed:isiPhoneiPad([imagesArraySmiley objectAtIndex:subCounter])]];
        [soundObject playWheelRotationSound:@"wheelRotation" withFormat:@"mp3"];
        waitCnt=0;
        subCounter++;
        if(subCounter >9){
            subCounter=9;
        }
        
    }
    if(subCounter>0)
    {
        [skipDoneButton setImage:[UIImage imageNamed:isiPhoneiPad(@"Done.png")]];
        clickStr=@"Done";
    }
    
    if(!arrowRotationDone)
    {
        arrowRotationDone=YES;
        [self touchAtArrowBlink:nil];
    }
}


- (void) setupGestureRecognizer
{
    // calculate center and radius of the control
    CGPoint midPoint = CGPointMake(pinwiWheel.frame.origin.x + pinwiWheel.frame.size.width / 2, pinwiWheel.frame.origin.y + pinwiWheel.frame.size.height / 2);
    CGFloat outRadius = 250;
    gestureRecognizer = [[OneFingerRotationGestureRecognizer alloc] initWithMidPoint: midPoint
                                                                         innerRadius: 5
                                                                         outerRadius: outRadius
                                                                              target: self];
    [pinwiWheel addGestureRecognizer: gestureRecognizer];
    
}


-(void)drawRating:(UIView *)view
{
    int x=screenWidth/20;
    
    NSInteger sub=self.allData.count;
    
    // int rateVal=[[[NSUserDefaults standardUserDefaults]valueForKey:@"ActivityCompleted"]intValue];
    rate=[[NSMutableArray alloc]init];
    
    float width = round(screenWidth/sub) - 5*ScreenWidthFactor;
    if(width>30*ScreenWidthFactor)
    {
        width=30*ScreenWidthFactor;
    }
    x=14*ScreenWidthFactor;
    for (int i=0; i<sub; i++)
    {
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(x, ScreenHeightFactor*70, width, 3*ScreenHeightFactor)];
        view1.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.2f];
        [view addSubview:view1];
        [rate addObject:view1];
        x+=width+5*ScreenWidthFactor;
    }
    int i =0;
    for(ChildSubjectRating *childRating in childSubjectRatingArray)
    {
        //        if(![childRating.rating isEqualToString:@"0"])
        //        {
        [[rate objectAtIndex:i]setBackgroundColor:buttonGreenColor];
        //        }
        i++;
    }
}


-(void)drawStars:(UIView *)view
{
    int y=screenHeight*.43;
    
    stars=[[NSMutableArray alloc]init];
    for(int i=0; i<10 ; i++)
    {
        StarsRating *starRating=[[StarsRating alloc]init];
        [starRating drawStars:[UIImage imageNamed:isiPhoneiPad([childRatingSelArray objectAtIndex:i])]];
        starRating.center=CGPointMake(screenWidth*.55, y);
        starRating.alpha=0.4f;
        NSLog(@"view center= %f , %f",starRating.center.x,starRating.center.y);
        [view addSubview:starRating];
        [stars addObject:starRating];
        y-=.03*screenHeight;
    }
    clickStr = @"Skip";
    skipDoneButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"Skip.png")]];
    [skipDoneButton setFrame:CGRectMake(screenWidth-screenWidth*.25,screenHeight*.34,screenWidth*.22,screenWidth*.22)];
    [skipDoneButton setUserInteractionEnabled:YES];
    [skipDoneButton setAlpha:.8f];
    [view addSubview:skipDoneButton];
    
    UITapGestureRecognizer *gestureRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtSkipDoneButton)];
    [skipDoneButton addGestureRecognizer:gestureRecognizer1];
    
}
-(void)touchAtSkipDoneButton
{
    [arrowIndicator removeFromSuperview];
    if([clickStr isEqualToString:@"Skip"]||[clickStr isEqualToString:@""])
    {
        [soundObject stopSound];
        [soundObject stopVoiceOver];
        [soundObject playButtonSound:@"two_tone_nav" withFormat:@"mp3"];
        soundSkip=YES;
        voiceOverIndex=2;
        [self playVoiceOverSounds:nil];
        [self showAlertView];
    }
    else if ([clickStr isEqualToString:@"Done"])
    {
        [self doneBtnTouched];
    }
    
    NSLog(@"Clik Str = %@",clickStr);
    
}
-(void)showAlertView
{
    UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Do you want to skip this activity?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    [alertView setBackgroundColor:placeHolderReg];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [soundObject stopSound];
    [soundObject stopVoiceOver];
    if(buttonIndex==0)
    {
        [self doneBtnTouched];
        //        if([clickStr isEqualToString:@"Skip"])
        //        {
        //            clickStr = @"Done";
        //        }
        //        else
        //        {
        //            clickStr = @"Skip";
        //        }
    }
    else
    {
        [soundObject playButtonSound:@"two_tone_nav" withFormat:@"mp3"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ConnectionSpecificFunction

-(void)activityRatingServices:(NSDictionary *)dictionary
{
    NSLog(@"rating value--- %@",[PC_DataManager sharedManager].actRatingString);
    NSLog(@"child id value--- %@",self.rateChilObj.child_ID);
    
    AddActivityRating *addActivity = [[AddActivityRating alloc]init];
    [addActivity initService:@{@"ChildID":self.rateChilObj.child_ID,
                               @"ActRatingValue":ratingStr,
                               //                               @"ActivityID":[dictionary valueForKey:@"ActivityID"],
                               //                               @"RatingValue":[NSString stringWithFormat:@"%i",subCounter],
                               @"DaysAgo":[NSString stringWithFormat:@"%d",DaysAgoValue]//@"0"
                               }];
    [addActivity setServiceName:PinWiAddActivityRating];
    [addActivity setDelegate:self];
    [self addLoaderView];
}
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    [self removeLoaderView];
}
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    [self removeLoaderView];
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"AddActivityRatingResponse" resultKey:@"AddActivityRatingResult"];
    NSLog(@"Dict  = %@ ",dict);
    //[self doneBtnTouched];
    int p= [self.rateChilObj.earnedPts intValue]+100;
    RatingConfirmation_VC *dashborad=[[RatingConfirmation_VC alloc]init];
    dashborad.childObj     =  self.rateChilObj;
    dashborad.daysagoValue =  DaysAgoValue;
    dashborad.statusCount  =  self.statusCount;
    dashborad.childObj.earnedPts=[NSString stringWithFormat:@"%i",p];
    
    [soundObject playPageFlipSound:@"pageFlip" withFormat:@"mp3"];
    [self.navigationController pushViewController:dashborad animated:YES];
    
}
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [currentView addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}


#pragma mark sound delegate
- (void)audioPlayerDidFinishedPlaying
{
    if(soundFinish)
    {
        if(clickCounter<self.allData.count)
        {
            [soundObject playPageFlipSound:@"pageFlip" withFormat:@"mp3"];
        }
        [self makeChnagesOnDoneBtnClick];
        soundFinish=NO;
    }
    
    if(soundSkip)
    {
        [arrowIndicator stopAnimating];
        arrowIndicator.alpha=1.0f;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateArrowLight) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateArrowDark) object:nil];
        [self animateArrowLight];
        [arrowIndicator setUserInteractionEnabled:NO];
        //[soundObject playVoiceOverSounds:[voiceOverArray objectAtIndex:voiceOverIndex] withFormat:@"m4a"];
        soundSkip=NO;
    }
}

#pragma mark animate Arrow
-(void)drawArrow
{
    arrowIndicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"arrowIndication.png")]];
    [arrowIndicator setFrame:CGRectMake(screenWidth*.8, skipDoneButton.frame.origin.y+skipDoneButton.frame.size.height+5*ScreenHeightFactor, screenWidth*.15, screenHeight*.1)];
    [arrowIndicator setUserInteractionEnabled:YES];
    [self.view addSubview:arrowIndicator];
    if(screenWidth>700)
    {
        [arrowIndicator setCenter:CGPointMake(arrowIndicator.center.x-10*ScreenWidthFactor, screenHeight*.6)];
    }
    [self performSelector:@selector(animateArrowLight) withObject:nil afterDelay:0.5];
    arrowGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtArrowBlink:)];
    [arrowIndicator addGestureRecognizer:arrowGesture];
}

-(void)playVoiceOverSounds:(id)sender
{
    [soundObject playVoiceOverSounds:[voiceOverArray objectAtIndex:voiceOverIndex] withFormat:@"m4a"];
}

-(void)animateArrowLight
{
    arrowIndicator.alpha=0.0f;
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateArrowLight) object:nil];
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateArrowDark) object:nil];
    [self performSelector:@selector(animateArrowDark) withObject:nil afterDelay:0.5];
}
-(void)animateArrowDark
{
    arrowIndicator.alpha=1.0f;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateArrowLight) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateArrowDark) object:nil];
    [self performSelector:@selector(animateArrowLight) withObject:nil afterDelay:0.5];
}

-(void)touchAtArrowBlink:(id)sender
{
    arrowRotationDone=YES;
    [arrowIndicator setUserInteractionEnabled:NO];
    soundSkip=YES;
    [soundObject stopSound];
    [soundObject stopVoiceOver];
    [self playVoiceOverSounds:nil];
    [arrowIndicator setCenter:CGPointMake(arrowIndicator.center.x+10*ScreenWidthFactor, arrowIndicator.center.y)];
    arrowIndicator.transform = CGAffineTransformMakeRotation(130 * M_PI/180);
    
    [arrowIndicator removeGestureRecognizer:arrowGesture];
}

/*- (void)touchesBegan:(NSSet*) touches withEvent:(UIEvent *) event{
 [super touchesBegan:touches withEvent:event];
 // Get location of touched point
 CGPoint point = [[touches anyObject] locationInView:self.view];
 
 if(CGRectContainsPoint(arrowIndicator.frame, point) && )
 {
 [arrowIndicator setUserInteractionEnabled:NO];
 soundSkip=YES;
 [soundObject stopSound];
 [self playVoiceOverSounds:nil];
 //[arrowIndicator setAlpha:0.0f];
 //        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateArrowLight) object:nil];
 //        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateArrowDark) object:nil];
 [arrowIndicator setCenter:CGPointMake(arrowIndicator.center.x, screenHeight*.6)];
 arrowIndicator.transform = CGAffineTransformMakeRotation(M_PI_2);
 }
 }
 */
@end
