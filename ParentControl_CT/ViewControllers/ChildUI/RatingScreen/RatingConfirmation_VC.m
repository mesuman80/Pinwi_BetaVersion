//
//  RatingConfirmation_VC.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 05/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "RatingConfirmation_VC.h"
#import "Constant.h"
#import "ShowActivityLoadingView.h"
#import "PC_DataManager.h"
#import "GetPointsInfoByChildID.h"
#import "ChildEarningPendingPoints.h"
#import "GetPastDaysRatingStatus.h"
#import "DashBoardView.h"
#import "DashBoardImageView.h"
#import "Sound.h"
#import "GetChildAfterSchoolActiviesByDay.h"
#import "GetChildSubjectActiviesByDay.h"
#import "PlayFirstTimeChildTutorial_VC.h"
#import "TutorialPlayView.h"

//#import "header"
@interface RatingConfirmation_VC ()<ChildEarningPendingPointsDelegate, SounPlayerProtocol,DashBoardProtocol,TutorialProtocol,PointsCalProtocol>

@end

@implementation RatingConfirmation_VC
{
    UIButton *doneBtn;
    ShowActivityLoadingView *loaderView;
    UIImageView *pointsImageView;
    int touchCounter,touchCounter1;
    UIImageView *soundButton, *voiceOverButton;
    
    UIScrollView *scrollView  ;
    UIButton *anotherButton;
    
    int imgCentreHt;
    UIView *viewBack;
    
    NSString *className;
    NSString *pointEarned;
    NSArray *dataArray;
    NSArray *dataRatingArray;
    Sound *soundObject;
    BOOL BtnSoundFinish;
    BOOL starSoundFinish;
    BOOL cellBtnSoundFinish;
    
    DashBoardView *rateDashBoard;
    NSMutableArray *getAllData;
    
    NSString *soundPlayString;
    NSString *voicePlayString;
    BOOL isStatus;
    
    UIImageView *star1View;
    UIImageView *star2View;
    BOOL pendingPointsExist;
    BOOL isPointInfo;
    BOOL isPendingPointInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[PC_DataManager sharedManager]getWidthHeight];
    
    soundPlayString=[NSString stringWithFormat:@"SoundOnOff-%@",self.childObj.child_ID];
    voicePlayString=[NSString stringWithFormat:@"VoiceOverOnOff-%@",self.childObj.child_ID];
    
    [self backgroundImage];
    [self setNavigationBarSetup];
    soundObject=[[Sound alloc]init];
    soundObject.soundDelegate=self;
    soundObject.child=self.childObj;
    
    //[self imageViewSetUp];
    
    // [self addLabel];
    // [self doneButton];
    
    
    
    if(_isComingFormRating)
    {
        isPointInfo=YES;
        [self getPointInfoByChildId];
        if([[[NSUserDefaults standardUserDefaults]valueForKey:soundPlayString]isEqualToString:@"0"] && ![[[NSUserDefaults standardUserDefaults]valueForKey:voicePlayString]isEqualToString:@"0"])
        {
            [self playAllSounds];
            //            isPointInfo=NO;
            //            [self performSelector:@selector(checkTodayRating) withObject:nil afterDelay:0.1];
        }
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"RatingDate-%@",self.childObj.child_ID];
        [[NSUserDefaults standardUserDefaults]setObject:[self saveRatingDate] forKey:str];
        [self addPointsEarned];
        //        [self getPointInfoByChildId];
    }
    
    
    /*
    
    NSString *str=[NSString stringWithFormat:@"ChildTutorial-%@",self.childObj.child_ID];
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:str]isEqualToString:@"1"])
    {
        //  tutDone=YES;
        TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
        tutorial.tutorialName=@"Child Tutorial";
        tutorial.loadIndexVal=childTutIndex;
        tutorial.isSoundPlaying=YES;
        _isComingFormRating=YES;
        tutorial.delegate=self;
        tutorial.child=self.childObj;
        [self presentViewController:tutorial animated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:str];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //        PlayFirstTimeChildTutorial_VC *platFTut=[[PlayFirstTimeChildTutorial_VC alloc]init];
        //        platFTut.childObj=self.childObj;
        //        platFTut.gotoClass=@"Rating";
        //        [self.navigationController presentViewController:platFTut animated:YES completion:nil];
        //                TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
    }
    else{
        
    }

     */
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isStatus=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tutorial delegate
-(void)SkipTouched
{
    [self getPointInfoByChildId];
    [soundObject playVoiceOverSounds:@"VO9" withFormat:@".m4a"];
}

-(void)earnedPointSetup:(NSString *)pointEarned1
{
    [soundObject playVoiceOverSounds:@"VO5" withFormat:@"m4a"];
    className=@"PointsInfo";
    
    pointsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"hexagonPointBg.png")]];
    [pointsImageView setCenter:CGPointMake(screenWidth/2, screenHeight*.55)];
    [self.view addSubview:pointsImageView];
    
    
    star1View=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"shining-stars.png")]];
    [star1View setFrame:CGRectMake(0,0, star1View.image.size.width, star1View.image.size.height)];
    [star1View setCenter:CGPointMake(pointsImageView.frame.size.width*.5, pointsImageView.frame.size.height*.45)];
    [pointsImageView addSubview:star1View];
    
    star2View=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"shining-stars1.png")]];
    [star2View setFrame:CGRectMake(0, 0, star2View.image.size.width, star2View.image.size.height)];
    [star2View setCenter:CGPointMake(pointsImageView.frame.size.width*.5, pointsImageView.frame.size.height*.45)];
    [pointsImageView addSubview:star2View];
    
    star1View.alpha=0.1f;
    star2View.alpha=0.1f;
    [self blinkStars];
    UILabel *earnedPointLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pointsImageView.frame.size.width,pointsImageView.frame.size.height/4)];
    earnedPointLabel.text = @"You have earned";
    earnedPointLabel.font = [UIFont fontWithName:Gotham size:20*ScreenHeightFactor];
    earnedPointLabel.textColor = cellWhiteColor_6;
    [earnedPointLabel sizeToFit];
    [earnedPointLabel setCenter:CGPointMake(pointsImageView.frame.size.width/2.0f,pointsImageView.frame.size.height*.30f)];
    [pointsImageView addSubview:earnedPointLabel];
    
    
    UILabel *pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pointsImageView.frame.size.width,pointsImageView.frame.size.height*.7)];
    pointLabel.text = [NSString stringWithFormat:@"%@",pointEarned1];
    pointLabel.font = [UIFont fontWithName:Gotham size:45*ScreenHeightFactor];
    pointLabel.textColor = cellWhiteColor_8;
    [pointLabel sizeToFit];
    [pointLabel setCenter:CGPointMake(pointsImageView.frame.size.width/2.0f,pointsImageView.frame.size.height*.5f)];
    [pointsImageView addSubview:pointLabel];
    
    UILabel *points = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pointsImageView.frame.size.width,pointsImageView.frame.size.height/3)];
    points.text = @"Points";
    points.font = [UIFont fontWithName:Gotham size:20*ScreenHeightFactor];
    points.textColor = cellWhiteColor_6;
    [points sizeToFit];
    [points setCenter:CGPointMake(pointsImageView.frame.size.width/2.0f,pointsImageView.frame.size.height*.70f)];
    [pointsImageView addSubview:points];
    
    [self performSelector:@selector(dismissView:) withObject:self afterDelay:5.0f];
}
-(void)setNavigationBarSetup
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth, 64*ScreenHeightFactor)];
    [view setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.4f]];
    [self.view addSubview:view];
    [self imageViewSetUp];
    
    soundButton = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-40*ScreenWidthFactor, 0,30*ScreenHeightFactor,30*ScreenHeightFactor)];
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
    [soundButton setCenter:CGPointMake(screenWidth-0.07*screenWidth, view.frame.size.height/2.0f+5*ScreenHeightFactor)];
    [view addSubview:soundButton];
    [soundButton setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *recognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtSoundButton:)];
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
    [voiceOverButton setCenter:CGPointMake(soundButton.frame.origin.x-voiceOverButton.frame.size.width/2-cellPadding, view.frame.size.height/2.0f+5*ScreenHeightFactor)];
    [view addSubview:voiceOverButton];
    [voiceOverButton setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *recognizerVoice= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(voiceButtonClicks:)];
    [voiceOverButton addGestureRecognizer:recognizerVoice];
    
    
    viewBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenHeight*.1, screenHeight*.1)];
    [viewBack setBackgroundColor:[UIColor clearColor]];
    [view addSubview:viewBack];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack)];
    [viewBack addGestureRecognizer:gestureRecognizer];
    
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
    [anotherButton setCenter:CGPointMake(ScreenWidthFactor*20, view.frame.size.height/2.0f+5*ScreenHeightFactor)];
    //  anotherButton.center=CGPointMake(anotherButton.center.x,view.frame.size.height-anotherButton.frame.size.height/2-5);
    [view addSubview:anotherButton];
    viewBack.center=CGPointMake(anotherButton.center.x, anotherButton.center.y);
    imgCentreHt=view.frame.size.height;
    [anotherButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchAtSoundButton:(id)sender
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




-(void)backgroundImage
{
    UIImageView *bgImg;
    if (screenWidth>700) {
        bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Child-Pinwheel-iPad.png"]];
    }
    else{
        if (screenWidth>320) {
            bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Child-Pinwheel-iPhone6.png"]];
        }else{
            bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Child-Pinwheel-iPhone5.png"]];
        }
    }
    bgImg.frame=CGRectMake(0, 0, screenWidth, screenHeight);
    bgImg.center=CGPointMake(screenWidth/2, screenHeight/2);
    [self.view addSubview:bgImg];
}
-(void)dismissView:(id)sender
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [pointsImageView setCenter:CGPointMake(-screenWidth/2, screenHeight/2)];
        [soundObject stopSound];
        [soundObject stopVoiceOver];
    } completion:^(BOOL finished) {
        [pointsImageView removeFromSuperview];
        [soundObject playPageFlipSound:@"pageFlip" withFormat:@"mp3"];
        [self openNewView];
    }];
}
-(void)openNewView
{
    NSLog(@"DashBoard");
    //[anotherButton setImage:[UIImage imageNamed:isiPhoneiPad(@"leftArrow.png")] forState:UIControlStateNormal];
    [self getPointInfoByChildId];
}
-(void)addLabel
{
    
    //    NSString *point=self.childObj.earnedPts;
    //    NSString *str=[NSString stringWithFormat:@"CONGRATULATIONS !!! \n You earned %@  more points. ",point];
    //    UILabel *label=[[UILabel alloc]init];
    //    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25.0f]}];
    //    label.font=[UIFont fontWithName:RobotoRegular size:25.0f];
    //    label.numberOfLines=0;
    //    label.text=str;
    //    label.textAlignment=NSTextAlignmentCenter;
    //    label.frame=CGRectMake(0,0,displayValueSize.width,displayValueSize.height);
    //    label.center=CGPointMake(screenWidth/2, screenHeight*.3);
    //    label.textColor=[UIColor whiteColor];
    //    [label sizeToFit];
    //    [self.view addSubview:label];
}


-(void)doneButton
{
    doneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneBtn setTitle:@"CONTINUE" forState:UIControlStateNormal];
    doneBtn.tintColor=[UIColor whiteColor];
    doneBtn.backgroundColor=[UIColor colorWithRed:103.0f/255 green:155.0f/255 blue:73.0f/255 alpha:1.0f];
    doneBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.03*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    doneBtn.frame=CGRectMake(.2*screenWidth, .7*screenHeight, .6*screenWidth, .07*screenHeight);
    doneBtn.layer.cornerRadius=5;
    doneBtn.clipsToBounds=YES;
    // doneBtn.layer.borderWidth=1.0;
    // doneBtn.layer.borderColor=radiobuttonSelectionColor.CGColor;
    [self.view addSubview:doneBtn];
    [doneBtn addTarget:self action:@selector(doneBtnTouched) forControlEvents:UIControlEventTouchUpInside];
}

-(void)doneBtnTouched
{
    ChildDashboard *dashborad=[[ChildDashboard alloc]init];
    dashborad.childObjDashBoard=self.childObj;
    [self.navigationController pushViewController:dashborad animated:YES];
    
}
#pragma mark Connection specific Functions
-(void)addPointsEarned
{
    AddPointsEarned *pointsEarned = [[AddPointsEarned alloc]init];
    [pointsEarned initService:@{@"ChildID":self.childObj.child_ID,
                                @"DaysAgo":[NSString stringWithFormat:@"%d",self.daysagoValue]
                                }];
    [pointsEarned setDelegate:self];
    [pointsEarned setServiceName:PinWiAddPointsEarned];
    [self addLoaderView];
}

-(void)getPointInfoByChildId
{
    NSString *str=[NSString stringWithFormat:@"GetPointsInfoByChildID-%@",self.childObj.child_ID];
    dataArray=[[PC_DataManager sharedManager].serviceDictionary objectForKey:str];
    if(dataArray && dataArray.count>0)
    {
        [self openDashBoard:dataArray];
        [soundObject playButtonSound:@"pageFlip" withFormat:@"mp3"];
    }
    else
    {
        GetPointsInfoByChildID *pointsChildId = [[GetPointsInfoByChildID alloc]init];
        [pointsChildId setDelegate:self];
        [pointsChildId setServiceName:PinWiGetPointsInfoByChildID];
        [pointsChildId initService:@{@"ChildID":self.childObj.child_ID}];
        [self addLoaderView];
    }
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    if([connection.serviceName isEqualToString:PinWiAddPointsEarned])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"AddPointsEarnedResponse" resultKey:@"AddPointsEarnedResult"];
        NSLog(@"Value of Dict =%@",dict);
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)dict;
            NSDictionary *data = [array firstObject];
            pointEarned  = [NSString stringWithFormat:@"%@",[data objectForKey:@"PointsEarned"]];
            NSLog(@"Points earned  = %@",pointEarned);
            // starSoundFinish=YES;
            [self earnedPointSetup:pointEarned];
            [soundObject playWheelRotationSound:@"starAnimation" withFormat:@"mp3"];
            NSString *str=[NSString stringWithFormat:@"GetPointsInfoByChildID-%@",self.childObj.child_ID];
            [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:str];
            
            str=[NSString stringWithFormat:@"%@-%@",PinWiGetPastDaysRatingStatus,self.childObj.child_ID];
            [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:str];
            
            [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:@"GetNamesByParentID"];
            
        }
        [self removeLoaderView];
    }
    else if([connection.serviceName isEqualToString:PinWiGetPointsInfoByChildID])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetPointsInfoByChildIDResponse" resultKey:@"GetPointsInfoByChildIDResult"];
        if([dict isKindOfClass:[NSArray class]])
        {
            dataArray = (NSArray *)dict;
            NSLog(@"Dict  = %@",dict);
            starSoundFinish=NO;
            [soundObject stopSound];
            // [soundObject stopVoiceOver];
            [star1View stopAnimating];
            [star2View stopAnimating];
            //[self checkTodayRating];
            [self openDashBoard:dataArray];
            NSString *str=[NSString stringWithFormat:@"GetPointsInfoByChildID-%@",self.childObj.child_ID];
            [[PC_DataManager sharedManager].serviceDictionary setObject:dataArray forKey:str];
            [soundObject playButtonSound:@"pageFlip" withFormat:@"mp3"];
        }
        [self removeLoaderView];
    }
    else if([connection.serviceName isEqualToString:PinWiGetPastDaysRatingStatus])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetPastDaysRatingStatusResponse" resultKey:@"GetPastDaysRatingStatusResult"];
        if([dict isKindOfClass:[NSArray class]])
        {
            dataRatingArray = (NSArray *)dict;
            NSString *str=[NSString stringWithFormat:@"%@-%@",PinWiGetPastDaysRatingStatus,self.childObj.child_ID];
            [[PC_DataManager sharedManager].serviceDictionary setObject:dataRatingArray forKey:str];
            [self gotoRatingStatus:dataRatingArray];
            NSLog(@"Dict  = %@",dict);
        }
        [self removeLoaderView];
    }
    else if([connection.serviceName isEqualToString:PinWiGetAfterSchoolActivityByChildId])
    {
        [getAllData removeAllObjects];
        getAllData=[[NSMutableArray alloc]init];
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetChildAfterSchoolActiviesByDayResponse" resultKey:@"GetChildAfterSchoolActiviesByDayResult"];
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"])
            {
//                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:PinWiGetAfterSchoolActivityByChildId message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//                  [alert show];
            }
            
            else
            {
                if(dict)
                {
                    for(NSDictionary *dictionary in dict)
                    {
                        [getAllData addObject:dictionary];
                    }
                }
            }
        }
        [self getSchoolActivitiesToRate];
    }
    else if([connection.serviceName isEqualToString:PinWiGetSubjectByChildID])
    {
        // [getAllData removeAllObjects];
        //if(get)
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetChildSubjectActiviesByDayResponse" resultKey:@"GetChildSubjectActiviesByDayResult"];
        
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"])
            {
                //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:PinWiGetSubjectByChildID message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                // [alert show];
            }
            else
            {
                
                for(NSDictionary *dictionary in arr)
                {
                    [getAllData addObject:dictionary];
                }
            }
        }
        if(getAllData.count>0)
        {
            [self StartRatingAgain];
            
        }
        
    }
    
    
}
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection {
    [self removeLoaderView];
}
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}
-(void)imageViewSetUp
{
    
    //    UIImageView  *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"defaultChild.png")]];
    //    imageView1.frame=CGRectMake(0, 0, ScreenHeightFactor*80, ScreenHeightFactor*80);
    //    [self.view addSubview:imageView1];
    UIImageView  *imageView ;
    
    if(![self.childObj.profile_pic isEqualToString:@"(null)"] && ![self.childObj.profile_pic isEqualToString:@""])
    {
        imageView = [[UIImageView alloc]initWithImage:[[PC_DataManager sharedManager]decodeImage:self.childObj.profile_pic]];
    }
    else
    {
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"defaultChild.png")]];
    }

//    if(self.statusCount==1 || self.statusCount==2)
//    {
//        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"trophy.png")]];
//    }
//    else if(self.statusCount==0)
//    {
//        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"lazyBoy.png")]];
//    }
//    else if(self.statusCount==3 || self.statusCount==4 || self.statusCount==5)
//    {
//        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"dashBoardClock.png")]];
//    }

    imageView.frame=CGRectMake(0, 0, ScreenHeightFactor*80, ScreenHeightFactor*80);
    [self.view addSubview:imageView];
    
    CALayer *mask1 = [CALayer layer];
    mask1.contents = (id)[[UIImage imageNamed:@"hexagon-mask.png"] CGImage];
    mask1.frame = CGRectMake(0, 0, ScreenHeightFactor*80, ScreenHeightFactor*80);
    mask1.opacity=1.0f;
    imageView.layer.mask = mask1;
    
    imageView.layer.masksToBounds = YES;
    
    UIImageView  *imageViewBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"hexagonPointBg.png")]];
    imageViewBg.frame=CGRectMake(0, 0, ScreenHeightFactor*80, ScreenHeightFactor*80);
    //imageView.frame=CGRectMake(0, 0, ScreenHeightFactor*50, ScreenHeightFactor*50);
    imageView.center = CGPointMake(screenWidth/2,64*ScreenHeightFactor);
    imageViewBg.center = CGPointMake(screenWidth/2,64*ScreenHeightFactor);
    [self.view addSubview:imageViewBg];
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
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
#pragma mark DashBoardSetup
-(void)openDashBoard:(NSArray *)array
{
    if(scrollView)
    {
        [scrollView removeFromSuperview];
        scrollView=nil;
    }
    className=@"PointsInfo";
    
    int scrollYY = 0;
    scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0,screenHeight*.2 , screenWidth, screenHeight*.8)];
    [self.view addSubview:scrollView];
    
    NSDictionary *dictionary =array.firstObject;
    
    NSString *earnedPoints = [dictionary valueForKey:@"EarnedPoints"];
    NSString *pendingPoints = [dictionary valueForKey:@"PendingPoints"];
  //  NSString *badgevalue = [dictionary valueForKey:@"QualityBadge"];
    
    if(![pendingPoints isEqualToString:@"0"])
    {
        pendingPointsExist=YES;
    }
    
    if(earnedPoints)
    {
    ChildEarningPendingPoints *earningAndPendingPoints =[[ChildEarningPendingPoints alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*5,screenWidth,120*ScreenHeightFactor)];
    [earningAndPendingPoints drawUIWithData:earnedPoints withString:@"EarnedPoints" andTextLabel:@"Total Earned Points"];
    [scrollView addSubview:earningAndPendingPoints];
    
    scrollYY =earningAndPendingPoints.frame.origin.y + earningAndPendingPoints.frame.size.height+20*ScreenHeightFactor;
    }
    
    if(pendingPoints)
    {
    ChildEarningPendingPoints *earningAndPendingPoint1 =[[ChildEarningPendingPoints alloc]initWithFrame:CGRectMake(0,scrollYY,screenWidth,120*ScreenHeightFactor)];
    [earningAndPendingPoint1 setDelegate:self];
    scrollYY+= earningAndPendingPoint1.frame.size.height+20*ScreenHeightFactor;
    
    [earningAndPendingPoint1 drawUIWithData:pendingPoints withString:@"PendingPoints" andTextLabel:@"Pending Points"];
    [scrollView addSubview:earningAndPendingPoint1];
    [scrollView setContentSize:CGSizeMake(0, scrollYY)];
    }
   /*
    if(badgevalue)
    {
    ChildEarningPendingPoints *earningAndPendingPoint2 =[[ChildEarningPendingPoints alloc]initWithFrame:CGRectMake(0,scrollYY,screenWidth,120*ScreenHeightFactor)];
    
    scrollYY+= earningAndPendingPoint2.frame.size.height;
    
    [earningAndPendingPoint2 drawUIWithData:badgevalue withString:@"Badgevalue" andTextLabel:[dictionary valueForKey:@"QualityBadge"]];
    [scrollView addSubview:earningAndPendingPoint2];
    [scrollView setContentSize:CGSizeMake(0, scrollYY)];
    }*/
}

-(void)touchAtCell:(ChildEarningPendingPoints *)childPoints
{
    [soundObject stopSound];
    [soundObject stopVoiceOver];
    cellBtnSoundFinish=YES;
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"SoundOnOff"]isEqualToString:@"0"] && ![[[NSUserDefaults standardUserDefaults]valueForKey:@"VoiceOverOnOff"]isEqualToString:@"0"])
    {
        [self playAllSounds];
    }
    else{
    [soundObject playButtonSound:@"two_tone_nav" withFormat:@"mp3"];
    }
    [self seePastDayRatingStatus];
}

-(void)seePastDayRatingStatus
{
//    NSString *str=[NSString stringWithFormat:@"%@-%@",PinWiGetPastDaysRatingStatus,self.childObj.child_ID];
//    dataRatingArray=[[PC_DataManager sharedManager].serviceDictionary objectForKey:str];
//    if(dataRatingArray && dataRatingArray.count>0)
//    {
//        [self gotoRatingStatus:dataRatingArray];
//    }
//    else
//    {
        GetPastDaysRatingStatus *pastDayRatingStatus = [[GetPastDaysRatingStatus alloc]init];
        [pastDayRatingStatus initService:@{@"ChildID":self.childObj.child_ID}];
        [pastDayRatingStatus setServiceName:PinWiGetPastDaysRatingStatus];
        [pastDayRatingStatus setDelegate:self];
        [self addLoaderView];
//    }
}


-(void)gotoRatingStatus:(NSArray*)dictArray
{
    [scrollView removeFromSuperview];
    scrollView=nil;
    
    
    isPendingPointInfo=YES;
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"SoundOnOff"]isEqualToString:@"0"] && ![[[NSUserDefaults standardUserDefaults]valueForKey:@"VoiceOverOnOff"]isEqualToString:@"0"])
    {
        [self playAllSounds];
    }
    else{
        [soundObject playButtonSound:@"pageFlip" withFormat:@"mp3"];
    }

    // [soundObject stopSound];
    className=@"WeekRating";
    [anotherButton setImage:[UIImage imageNamed:isiPhoneiPad(@"leftArrow.png")] forState:UIControlStateNormal];
    NSDate *currentDate=[NSDate date];
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd MMMM"];
    NSString *currentDateString=[dateFormat stringFromDate:currentDate];
    [dateFormat setDateFormat:@"EEE"];
    
    int yy=ScreenHeightFactor*5;
    scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0,screenHeight*.2 , screenWidth, screenHeight*.8)];
    [self.view addSubview:scrollView];
    
    UILabel *today = [[UILabel alloc]initWithFrame:CGRectMake(0,yy, scrollView.frame.size.width,ScreenHeightFactor*18)];
    today.text=@"POINTS CALENDAR";
    today.textColor= cellWhiteColor_8;
    [today setFont:[UIFont fontWithName:Gotham size:ScreenHeightFactor*18]];
    today.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:today];
    
    yy+=ScreenHeightFactor*25+today.frame.size.height;
    
    
    UILabel *todayDate = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidthFactor*30,yy, scrollView.frame.size.width-ScreenWidthFactor*60,10*ScreenFactor)];
    todayDate.text=[NSString stringWithFormat:@"Today, %@",[currentDateString uppercaseString]];
    todayDate.textColor= [[UIColor whiteColor]colorWithAlphaComponent:0.5f];
    [todayDate setFont:[UIFont fontWithName:RobotoRegular size:9*ScreenFactor]];
    todayDate.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:todayDate];
    
    
    yy+=ScreenHeightFactor*10+todayDate.frame.size.height;
    
    NSLog(@"%d",self.statusCount);
    DashBoardImageView *dashBoardImg=[[DashBoardImageView alloc]initWithFrame:CGRectMake(20*ScreenWidthFactor,yy, scrollView.frame.size.width-40*ScreenWidthFactor, ScreenHeightFactor*45)andDate:[[dictArray objectAtIndex:1]objectForKey:@"RemaningTime"] andStatus:self.statusCount];
    dashBoardImg.delegate=self;
    dashBoardImg.clipsToBounds=YES;
    dashBoardImg.layer.cornerRadius=10.0f;
    [scrollView addSubview:dashBoardImg];
    
    yy+=ScreenHeightFactor*20+dashBoardImg.frame.size.height;
    
    
    int scrollX=ScreenWidthFactor*20;
    
    for(int i=0; i<6; i++)
    {
        [components setDay:(-(i+1))];
        NSDate *endDate = [calendar dateByAddingComponents:components toDate:currentDate options:0];
        NSString *currentDateString=[dateFormat stringFromDate:endDate];
        
        if(i%2==0 && i!=0)
        {
            scrollX=ScreenWidthFactor*20;
            yy+=ScreenWidthFactor*140;
        }
        else if(i%2!=0)
        {
            scrollX+=ScreenWidthFactor*140;
        }
        
        DashBoardView *dashBoard=[[DashBoardView alloc]initWithFrame:CGRectMake(scrollX,yy, ScreenWidthFactor*140,ScreenWidthFactor*140) andDict:[dictArray objectAtIndex:i]WithDay:currentDateString];
        [dashBoard setDashBoardDelegate:self];
        [dashBoard setSoundObj:soundObject];
        //dashBoard.center=CGPointMake(scrollX, scrollY);
        [scrollView addSubview:dashBoard];
        //yy+=dashBoard.frame.size.height;
    }
    
    if(yy>ScreenHeightFactor*320)
    {
        [scrollView setUserInteractionEnabled:YES];
        [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, yy+200*ScreenHeightFactor)];
    }
}

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
    [anotherButton setImage:[UIImage imageNamed:isiPhoneiPad(@"accessProfileBack.png")] forState:UIControlStateNormal];
    [anotherButton setFrame:CGRectMake(0, 0,screenWidth*.08,screenWidth*.08)];
    anotherButton.center=CGPointMake(.07*screenWidth ,.04*screenHeight);
    [self.navigationController.navigationBar addSubview:anotherButton];
    [anotherButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];    //anotherButton.tintColor=[UIColor whiteColor];
    viewBack.center=CGPointMake(anotherButton.center.x, anotherButton.center.y);
}
//
-(void)goBack
{
    [soundObject stopSound];
    [soundObject stopVoiceOver];
    BtnSoundFinish=YES;
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"SoundOnOff"]isEqualToString:@"0"] && ![[[NSUserDefaults standardUserDefaults]valueForKey:@"VoiceOverOnOff"]isEqualToString:@"0"])
        {
            [self playAllSounds];
        }
        else{
        [soundObject playButtonSound:@"two_tone_nav" withFormat:@".mp3"];
    }
    [self goBackView];
}

-(void)goBackView
{
//    [soundObject stopSound];
//    [soundObject stopVoiceOver];
//    soundObject.soundDelegate=nil;
//    
    for(UIView *vviews in [self.view subviews])
    {
        if([vviews isKindOfClass:[DashBoardView class]])
        {
            for (UIView *vvview in [vviews subviews])
            {
               [vvview.layer removeAllAnimations];
            }
         
        }
    }
    
    [self.view.layer removeAllAnimations];

    if([className isEqualToString:@"WeekRating"])
    {
        NSString *str=[NSString stringWithFormat:@"GetPointsInfoByChildID-%@",self.childObj.child_ID];
        dataArray=[[PC_DataManager sharedManager].serviceDictionary objectForKey:str];
        [soundObject stopSound];
        [soundObject stopVoiceOver];
        BtnSoundFinish=NO;
   //     [soundObject playPageFlipSound:@"pageFlip" withFormat:@"mp3"];
        [self openDashBoard:dataArray];
        [anotherButton setImage:[UIImage imageNamed:isiPhoneiPad(@"accessProfileBack.png")] forState:UIControlStateNormal];
    }
    else if ([className isEqualToString:@"PointsInfo"])
    {
        [soundObject stopSound];
        [soundObject stopVoiceOver];
        soundObject.soundDelegate=nil;
        AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
        UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
        [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
    }
}

-(void)playAllSounds
{
    if(BtnSoundFinish)
    {
        BtnSoundFinish=NO;
        [soundObject playPageFlipSound:@"pageFlip" withFormat:@"mp3"];
        [self goBackView];
    }
    if(cellBtnSoundFinish)
    {
        cellBtnSoundFinish=NO;
        [soundObject playPageFlipSound:@"pageFlip" withFormat:@"mp3"];
    }
    if(starSoundFinish)
    {
        //starSoundFinish=NO;
        [soundObject playButtonSound:@"starAnimation" withFormat:@"mp3"];
    }
    if(isPointInfo)
    {
        isPointInfo=NO;
        [self checkTodayRating];
    }
    if(isPendingPointInfo)
    {
        isPendingPointInfo=NO;
        if(pendingPointsExist)
        {
            [soundObject playVoiceOverSounds:@"VO6" withFormat:@"m4a"];
        }
        else
        {
            [soundObject playVoiceOverSounds:@"VO6_1" withFormat:@"m4a"];
        }
    }

}


-(void)audioPlayerDidFinishedPlaying
{
    if(BtnSoundFinish)
    {
        BtnSoundFinish=NO;
        [soundObject playPageFlipSound:@"pageFlip" withFormat:@"mp3"];
        [self goBackView];
    }
    if(cellBtnSoundFinish)
    {
        cellBtnSoundFinish=NO;
        [soundObject playPageFlipSound:@"pageFlip" withFormat:@"mp3"];
    }
    if(starSoundFinish)
    {
        [soundObject playButtonSound:@"starAnimation" withFormat:@"mp3"];
    }
    if(isPointInfo)
    {
        isPointInfo=NO;
        [self checkTodayRating];
    }
    if(isPendingPointInfo)
    {
        isPendingPointInfo=NO;
        if(pendingPointsExist)
        {
            [soundObject playVoiceOverSounds:@"VO6" withFormat:@"m4a"];
        }
        else
        {
            [soundObject playVoiceOverSounds:@"VO6_1" withFormat:@"m4a"];
        }
    }
}

#pragma mark rating for today
-(void)rateAgain
{
    rateDashBoard=[[DashBoardView alloc]init];
    rateDashBoard.activityDashBoardDict=[[NSMutableDictionary alloc]init];
    [rateDashBoard.activityDashBoardDict setValue:@"0" forKey:@"DaysAgo"];
    isStatus=YES;
    [rateDashBoard.soundObj stopVoiceOver];
    [rateDashBoard.soundObj stopSound];
    [self getAfterSchoolActivitiesToRate];
}

#pragma mark rating for previous left out days
-(void)RateAgainCellTouched:(DashBoardView *)dashBoard
{
    [dashBoard.layer removeAllAnimations];
    rateDashBoard=dashBoard;
    [rateDashBoard.soundObj stopVoiceOver];
    [rateDashBoard.soundObj stopSound];
    [self getAfterSchoolActivitiesToRate];
}
-(void)getAfterSchoolActivitiesToRate
{
    GetChildAfterSchoolActiviesByDay *activityID =  [[GetChildAfterSchoolActiviesByDay alloc]init];
    [activityID setServiceName:PinWiGetAfterSchoolActivityByChildId];
    [activityID setDelegate:self];
    [activityID initService:@{@"ChildID":self.childObj.child_ID,
                              @"DaysAgo":[rateDashBoard.activityDashBoardDict objectForKey:@"DaysAgo"]
                              }];
}
-(void)getSchoolActivitiesToRate
{
    GetChildSubjectActiviesByDay * activityID  = [[GetChildSubjectActiviesByDay alloc]init];
    [activityID setDelegate:self];
    [activityID setServiceName:PinWiGetSubjectByChildID];
    [activityID initService:@{@"ChildID":self.childObj.child_ID,
                              @"DaysAgo":[rateDashBoard.activityDashBoardDict objectForKey:@"DaysAgo"]
                              }];
}
-(void)StartRatingAgain
{
    ChildSubjectRatingViewController *childSubjectRatingViewController=[[ChildSubjectRatingViewController alloc]init];
    [ChildSubjectRatingViewController setDaysAgoValue:[[rateDashBoard.activityDashBoardDict objectForKey:@"DaysAgo"] intValue]];
    [childSubjectRatingViewController setAllData:getAllData];
    childSubjectRatingViewController.rateChilObj=self.childObj;
    childSubjectRatingViewController.isSoundPlaying=YES;
    if(isStatus){
        childSubjectRatingViewController.statusCount=2;
        childSubjectRatingViewController.isSoundPlaying=NO;
    }
    childSubjectRatingViewController.statusCount = self.statusCount;
    childSubjectRatingViewController.parentClass=@"Acess";
    childSubjectRatingViewController.rateChilObj.earnedPts=self.childObj.earnedPts;
    UINavigationController *navigationcontroller  = [[UINavigationController alloc]initWithRootViewController:childSubjectRatingViewController];
    [self presentViewController:navigationcontroller animated:YES completion:nil];
    rateDashBoard=nil;
}
#pragma mark stars rating
-(void)blinkStars
{
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         star2View.alpha=1.0f;
                         star1View.alpha=1.0f;
                         
                     }
                     completion:nil];
    
}

#pragma mark Rating defaults save
-(NSString*)saveRatingDate
{
    NSDateFormatter *ratingFormatter=[[NSDateFormatter alloc]init];
    [ratingFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *ratingDate=[ratingFormatter stringFromDate:[NSDate date]];
    return ratingDate;
}
-(void)checkTodayRating
{
    NSString *str=[NSString stringWithFormat:@"RatingDate-%@",self.childObj.child_ID];
    
    TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
    tutorial.tutorialName=@"Child Tutorial";
    tutorial.loadIndexVal=childTutNextIndex;
    tutorial.isSoundPlaying=YES;
    tutorial.autoSkip=YES;
    tutorial.statusCountIndex=self.statusCount;
    tutorial.child=self.childObj;
    [self presentViewController:tutorial animated:YES completion:nil];
    
    
//    if([[NSUserDefaults standardUserDefaults]objectForKey:str] && [[self saveRatingDate]isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:str]])
//    {
//        [soundObject playVoiceOverSounds:@"VO7" withFormat:@"m4a"];
//    }
//    else
//    {
//        [soundObject playVoiceOverSounds:@"VO9" withFormat:@"m4a"];
//    }
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
