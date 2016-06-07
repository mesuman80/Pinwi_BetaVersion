//
//  SupportView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "TutorialPlayView.h"
#import "HeaderView.h"

@interface TutorialPlayView()<HeaderViewProtocol,UIPageViewControllerDelegate,UIScrollViewDelegate,SounPlayerProtocol>

@end

@implementation TutorialPlayView
{
    // UIImageView *tutImg;
    UIScrollView *scrollView;
    HeaderView *headerView;
    
    int yy;
    
    UIPageControl *pageControl;
    Sound *soundObject;
    int soundPlayIndex;
    UIButton *button;
}
@synthesize loadIndexVal;
@synthesize imgLoadArr;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]TutorialImages];
    [self.view setBackgroundColor:appBackgroundColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //  [self drawHeaderView];
    [self setupScroll];
}

#pragma mark HeaderViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"tutorialHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Tutorials" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view addSubview:headerView];
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+30*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }
    }
}

-(void)getMenuTouches
{
    
}
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupScroll
{
    if(!scrollView)
    {
        scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor=appBackgroundColor;
        scrollView.pagingEnabled = YES;
        scrollView.scrollEnabled = YES;
        scrollView.delegate=self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        //int h=[[UIApplication sharedApplication]statusBarFrame].size.height+ self.navigationController.navigationBar.frame.size.height;
        
        scrollView.frame=CGRectMake(0,yy, screenWidth,screenHeight-yy);
        scrollView.contentSize = CGSizeMake(screenWidth, scrollView.frame.size.height);
        
        [self.view addSubview:scrollView];
        if(loadIndexVal==15)
        {
            soundPlayIndex=8;
            //imgLoadArr = [[NSMutableArray alloc]init];
            imgLoadArr = tutorialChildList2Array;
        }
        else{
            soundPlayIndex=0;
            imgLoadArr=[tutorialListArrayComplete objectAtIndex:loadIndexVal];
        }
        [self renderElements];
        [self addSkipButton];
        
        [[PC_DataManager sharedManager]TutorialImages];
        
        [self initsounds];
        //}
        if(soundPlayIndex==imgLoadArr.count-1)
        {
            [button setTitle:@"Done" forState:UIControlStateNormal];
        }
        else{
            [button setTitle:@"Skip" forState:UIControlStateNormal];
        }
       
            [self setUpPageControllers:(int)imgLoadArr.count];
        
         [button setCenter:CGPointMake(screenWidth-cellPadding-button.frame.size.width/2,pageControl.center.y)];
    }
}
-(void)setUpPageControllers:(int)number_Of_Page
{
    if(screenWidth>700)
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,screenHeight*.95,ScreenWidthFactor*20,ScreenWidthFactor*20)];
        pageControl.transform = CGAffineTransformMakeScale(2, 2);
    }
    else
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,screenHeight*.95,ScreenWidthFactor*20,ScreenWidthFactor*20)];
    }
    
    [pageControl setCenter:CGPointMake(screenWidth/2,pageControl.center.y)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=number_Of_Page;
    // pageControl.pageIndicatorTintColor=[UIColor blackColor];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    if((int)imgLoadArr.count>1)
    {
        [self.view addSubview:pageControl];
    }
    
    
}
-(void)renderElements
{
    int scrollX=screenWidth/2;
    
    for(NSString *imgstr in imgLoadArr)
    {
        UIImageView *tutImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, scrollView.frame.size.height)];
        tutImg.center=CGPointMake(scrollX, scrollView.frame.size.height/2);
        NSLog(@"%f    %f",tutImg.center.x,tutImg.center.y );
        tutImg.backgroundColor=[UIColor redColor];
        
        NSLog(@"Image name: %@",isiPhoneiPad(imgstr));
        
        tutImg.image=[UIImage imageNamed:isiPhoneiPad(imgstr)];
        
        [scrollView addSubview:tutImg];
        scrollX+=screenWidth;
        // [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width-screenWidth, scrollView.contentSize.height)];
    }
    
    if(loadIndexVal==15)
    {
        UILabel * pendingPointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellPadding,50*ScreenHeightFactor,screenWidth-2*cellPadding,20*ScreenFactor)];
        [pendingPointsLabel setText:[[tutorialTextOpeningArray objectAtIndex:self.statusCountIndex] uppercaseString]];
        [pendingPointsLabel setFont:[UIFont fontWithName:Gotham size:11*ScreenFactor]];
        [pendingPointsLabel setTextColor:cellWhiteColor_5];
        [pendingPointsLabel sizeToFit];
        [pendingPointsLabel setCenter:CGPointMake(screenWidth/2, pendingPointsLabel.center.y)];
        [scrollView addSubview:pendingPointsLabel];

        UIImageView *img=[[UIImageView alloc]init];
        if(self.statusCountIndex==0 || self.statusCountIndex==2 || self.statusCountIndex==3 || self.statusCountIndex==5)
        {
            img.image=[UIImage imageNamed:isiPhoneiPad(@"hexFrameHi.png")];
        }
        else if(self.statusCountIndex==1 || self.statusCountIndex==4)
        {
            img.image=[UIImage imageNamed:isiPhoneiPad(@"hexFrameTrophy.png")];
        }
        img.frame=CGRectMake(0, 0, screenWidth*.4, screenWidth*.4);
        img.center=CGPointMake(scrollView.center.x, scrollView.frame.size.height*.55);
        [scrollView addSubview:img];
    }
    
    
    [scrollView setContentSize:CGSizeMake( scrollX-screenWidth/2, scrollView.contentSize.height)];
    // [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width-screenWidth, scrollView.contentSize.height)];
}

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    soundPlayIndex=page;
    [self initsounds];
    
    if(soundPlayIndex==imgLoadArr.count-1)
    {
        [button setTitle:@"Done" forState:UIControlStateNormal];
    }
    else{
        [button setTitle:@"Skip" forState:UIControlStateNormal];
    }
    //  [soundObject playVoiceOverSounds:[tutorialChildSounds objectAtIndex:page] withFormat:@"mp4"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)sender
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    
    
}

-(void)addSkipButton
{
    button  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,40*ScreenWidthFactor,30*ScreenWidthFactor)];
    [button setTintColor:[UIColor whiteColor]];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:@"Skip" forState:UIControlStateNormal];
    //[button.titleLabel setTextAlignment:NSTextAlignmentRight];
    [button.titleLabel setFont:[UIFont fontWithName:RobotoRegular size:12*ScreenFactor]];
    
    [button addTarget:self action:@selector(touchAtSkip) forControlEvents:UIControlEventTouchUpInside];
    //  [button setCenter:CGPointMake(self.frame.size.width*.90f,self.frame.size.height/2+10)];
    [button setCenter:CGPointMake(screenWidth-cellPadding-button.frame.size.width/2,screenHeight-cellPadding-button.frame.size.height/2)];
    [self.view addSubview:button];
}
-(void)touchAtSkip
{
    if(self.delegate)
    {
        [self.delegate SkipTouched];
    }
    soundObject.soundDelegate=nil;
    [soundObject stopSound];
    [soundObject stopVoiceOver];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:self.tutorialName];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark sound delegate
-(void)initsounds
{
    if(self.isSoundPlaying==YES)
    {
        [soundObject stopSound];
        [soundObject stopVoiceOver];
        if(loadIndexVal==childTutIndex || loadIndexVal==childTutNextIndex)
        {
            if(!soundObject)
            {
                soundObject=[[Sound alloc]init];
            }
            soundObject.child=self.child;
            [soundObject setSoundDelegate:self];
            
            NSLog(@"playing sound: %@",[tutorialChildSounds objectAtIndex:soundPlayIndex]);
            if(loadIndexVal==childTutIndex){
            [soundObject playVoiceOverSounds:[tutorialChildSounds objectAtIndex:soundPlayIndex] withFormat:@"m4a"];
            }
            else if (loadIndexVal==childTutNextIndex)
            {
                [soundObject playVoiceOverSounds:[tutorialChildSoundsOpening objectAtIndex:self.statusCountIndex] withFormat:@"m4a"];
            }
        }
    }
}

-(void)audioPlayerDidFinishedPlaying
{
    soundPlayIndex+=1;
    
    if(soundPlayIndex>=imgLoadArr.count)
    {
        if(self.autoSkip)
        {
            [self touchAtSkip];
        }
    }
    else{
        // [self initsounds];
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x+screenWidth,scrollView.contentOffset.y)
                            animated:YES];
    }
    // [soundObject playVoiceOverSounds:[tutorialChildSounds objectAtIndex:soundPlayIndex] withFormat:@"mp4"];
}
@end

