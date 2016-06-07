//
//  Parent_ViewProfile.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 19/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ParentViewProfile.h"
#import "TabBarViewController.h"
#import "ParentViewObject.h"
#import "MenuSettingsView.h"
#import "HeaderView.h"
#import "GetNewNotificationCount.h"
#import "TutorialPlayView.h"
@interface ParentViewProfile ()<HeaderViewProtocol,UrlConnectionDelegate>

@end

@implementation ParentViewProfile
{
    UIImageView *profileBtn, *settingBtn, *wishlistBtn, *activityBtn, *notificationBtn, *recommendations, *netwotk, *topStrip, *centerIcon, *moreImg, *bottomStrip;
    int objectCount;
    float centerX, centerY;
    int i;
    UILabel *heading;
    
    MenuSettingsView *menu;
    
    NSMutableArray *fieldsArray;
    UIButton *backButton;
    LogoutView *logout;
    
    BOOL isToggleMenu;
    UIView *loadElementView;
    UIView *viewBack;
    HeaderView *headerView ;
    
    UIView *removeMenuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    i=0;
    [[PC_DataManager sharedManager]viewProfile];
    [[PC_DataManager sharedManager]getWidthHeight];
    self.view.backgroundColor=appBackgroundColor;
    // Do any additional setup after loading the view.
    if(!loadElementView)
    {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth*1.5, screenHeight)];
        [self.view addSubview:loadElementView];
    }
    [self drawheadingLabel];
    [self drawHeaderView];
    [self moreIcon];
    [self drawCenterIcon];
    [self drawBottomImage];
    [self drawImageViews];
    [self drawCircumference];
    [self pageHeading];
    [self goBackBtn];
    [self getNotificationCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    float time=0.1;
    
    for(UIImageView *img in fieldsArray)
    {
        [UIView animateWithDuration:.5 delay:time options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [img setAlpha:0.7];
                         }
                         completion:^(BOOL finished){
                             //[self removeFromSuperview];
                         }];
        
        time+=0.1;
    }
    
    for(UIImageView *img in fieldsArray)
    {
        [self performSelector:@selector(becomeVisibleimg:) withObject:img afterDelay:0.1];
        
    }
    
    self.navigationController.navigationBarHidden=YES;
    
    //    [self performSelector:@selector(becomeVisibleimg:) withObject:settingBtn afterDelay:0.1];
    //    [self performSelector:@selector(becomeVisibleimg:) withObject:notificationBtn afterDelay:0.2];
    //    [self performSelector:@selector(becomeVisibleimg:) withObject:recommendations afterDelay:0.4];
    //    [self performSelector:@selector(becomeVisibleimg:) withObject:wishlistBtn afterDelay:0.6];
    //    [self performSelector:@selector(becomeVisibleimg:) withObject:activityBtn afterDelay:0.8];
    //    [self performSelector:@selector(becomeVisibleimg:) withObject:netwotk afterDelay:1.0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    //    if(isToggleMenu)
    //    {
    //        isToggleMenu=NO;
    //        //accessTable.userInteractionEnabled=YES;
    //        [self slideOut];
    //    }
    
}

//-(void)addNavBar
//{
//    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*.1)];
//    navbar.tintColor=[UIColor whiteColor];
//    [self setTitle:@"good mrng..parent"];
//    //self.navigationItem.title = @"good mrng..parent";
//    //do something like background color, title, etc you self
//    [self.view addSubview:navbar];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header_above.png"]forBarMetrics:UIBarMetricsDefault];
//
//}
//
-(void)drawImageViews
{
    profileBtn=[[UIImageView alloc]init];
    UIImage *img =nil;
    NSString *imageName = [PC_DataManager sharedManager].parentObjectInstance.image;
    if (imageName == (id)[NSNull null] || imageName.length == 0 ) {
        img =  [UIImage imageNamed:@"notificationProfile-568h@2x.png"];
    }
    else {
        img=[[PC_DataManager sharedManager] decodeImage:imageName];
    }
    profileBtn.image=img;
    profileBtn.frame=CGRectMake(0, 0, screenWidth*.2, screenWidth*.2);
    if(screenWidth>700)
    {
        profileBtn.center=CGPointMake(screenWidth/2, screenHeight*.6);
    }
    else
    {
        profileBtn.center=CGPointMake(screenWidth/2, screenHeight*.6);
    }
    // profileBtn.layer.cornerRadius = profileBtn.frame.size.width/2;
    //profileBtn.layer.borderWidth = 0.5f;
    profileBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    //profileBtn.clipsToBounds = YES;
    profileBtn.layer.cornerRadius = profileBtn.frame.size.height /2;
    profileBtn.layer.masksToBounds = YES;
    profileBtn.layer.borderWidth = 0;
    profileBtn.contentMode=UIViewContentModeScaleAspectFill;
    
    
    
    
    [loadElementView addSubview:profileBtn];
    
    //    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
    //    singleTap.numberOfTapsRequired = 1;
    //    singleTap.numberOfTouchesRequired = 1;
    //    [profileBtn addGestureRecognizer:singleTap];
    //    [profileBtn setUserInteractionEnabled:YES];
    
}

-(void) drawHeaderView
{
    //    topStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")]];
    //    topStrip.frame=CGRectMake(0, 0, screenWidth, 64);
    //    [loadElementView addSubview:topStrip];
    
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:@"Menu"];
        [headerView setCentreImgName:@"ParentHome_header.png"];
        NSString *labelStr=[NSString stringWithFormat:@"Hi %@",[PC_DataManager sharedManager].parentObjectInstance.firstName];
        [headerView drawHeaderViewWithTitle:labelStr isBackBtnReq:YES BackImage:@"accessProfileBack.png"];
        //[self.view bringSubviewToFront:headerView];
        [loadElementView addSubview:headerView];
        
        // [self setupPageControl:[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count];
        
        
    }
    
    
}

-(void) drawCenterIcon
{
    //    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"ParentHome_header.png") ]];
    //    centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
    //    centerIcon.center=CGPointMake(.5*screenWidth, topStrip.frame.origin.y+topStrip.frame.size.height);
    //    [topStrip addSubview:centerIcon];
    //    NSLog(@"Width = %f",self.view.frame.size.width);
    //
    //    if(!centerIcon)
    //    {
    //        centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"ParentHome_header.png")]];
    //        centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
    //        if(self.view.frame.size.width>700)
    //        {
    //            centerIcon.center=CGPointMake(.5*screenWidth, topStrip.frame.origin.y+topStrip.frame.size.height+20);
    //        }
    //        else
    //        {
    //            centerIcon.center=CGPointMake(.5*screenWidth, topStrip.frame.origin.y+topStrip.frame.size.height+5);
    //        }
    //        //[centerIcon setBackgroundColor:[UIColor redColor]];
    //
    //    }
    //    //[loadElementView setBackgroundColor:[UIColor blueColor]];
    //    [loadElementView addSubview:centerIcon];
    
}
-(void) moreIcon
{
    //    UIView *view=[[UIView alloc]init];
    //    view.userInteractionEnabled=YES;
    //    [loadElementView addSubview:view];
    //
    //    moreImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"Flower_pinwii.png") ]];
    //    moreImg.frame=CGRectMake(0, 0, moreImg.image.size.width*1.5, moreImg.image.size.height*1.5);
    //    moreImg.center=CGPointMake(.9*screenWidth, topStrip.center.y+10);
    //    NSLog(@"FRAME :   %f----  %f",moreImg.frame.size.width,moreImg.frame.size.height+10);
    //
    //    [loadElementView  addSubview:moreImg];
    //    [moreImg setUserInteractionEnabled:YES];
    //
    //    view.frame=CGRectMake(0, 0, moreImg.frame.size.width*3, moreImg.frame.size.height*3);
    //    view.center=CGPointMake(moreImg.center.x, moreImg.center.y);
    //
    //    UITapGestureRecognizer *recognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtMenuButton:)];
    //    [view addGestureRecognizer:recognizer];
    
    //    moreImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"Flower_pinwii.png") ]];
    //    if(self.view.frame.size.width>700)
    //    {
    //       // moreImg.frame=CGRectMake(topStrip.frame.size.width-topStrip.frame.size.height-10, 0,topStrip.frame.size.height-10, topStrip.frame.size.height-22);
    //        moreImg.frame=CGRectMake(topStrip.frame.size.width-moreImg.image.size.width*2-5,0,moreImg.frame.size.width,moreImg.frame.size.height);
    //    }
    //    else
    //    {
    //        moreImg.frame=CGRectMake(topStrip.frame.size.width-moreImg.image.size.width-10, 0,moreImg.image.size.width,moreImg.image.size.height);
    //    }
    //
    //    moreImg.center=CGPointMake(moreImg.center.x,topStrip.frame.size.height/2.0f+10);
    //    NSLog(@"FRAME :   %f----  %f",moreImg.frame.size.width,moreImg.frame.size.height+10);
    //    [moreImg setUserInteractionEnabled:YES];
    //    [topStrip setUserInteractionEnabled:YES];
    //    [topStrip  addSubview:moreImg];
    //
    //
    //    //    view.frame=CGRectMake(0, 0, moreImg.frame.size.width*3, moreImg.frame.size.height*3);
    //    //    view.center=CGPointMake(moreImg.center.x, moreImg.center.y);
    //
    //    UITapGestureRecognizer *recognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtMenuButton:)];
    //    [moreImg addGestureRecognizer:recognizer];
}

-(void)goBackBtn
{
    
    //    viewBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth*.1, screenWidth*.1)];
    //    [viewBack setBackgroundColor:[UIColor clearColor]];
    //
    //    [topStrip addSubview:viewBack];
    //    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack)];
    //    [viewBack addGestureRecognizer:gestureRecognizer];
    //
    //
    //    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    // backButton=[UIButton buttonWithType:UIButtonTypeContactAdd];
    //   // [backButton setTitle:@"<" forState:UIControlStateNormal];
    //    backButton.tintColor=[UIColor whiteColor];
    //    [backButton setImage:[UIImage imageNamed:isiPhoneiPad(@"accessProfileBack.png")] forState:UIControlStateNormal];
    //    if(self.view.frame.size.width>700)
    //    {
    //        [backButton setFrame:CGRectMake(0, 0,screenWidth*.05,screenWidth*.05)];
    //        backButton.center=CGPointMake(.04*screenWidth ,moreImg.center.y);
    //
    //    }
    //    else
    //    {
    //        [backButton setFrame:CGRectMake(0, 0,screenWidth*.1,screenWidth*.1)];
    //        backButton.center=CGPointMake(.07*screenWidth ,moreImg.center.y);
    //
    //    }
    //       [topStrip addSubview:backButton];
    //    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    //     viewBack.center=CGPointMake(backButton.center.x, backButton.center.y);
    //backButton.tintColor=[UIColor whiteColor];
}
//
-(void)goBack
{
    AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
    UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
    [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
    //
}

-(void)pageHeading
{
    //    NSString *labelStr=[NSString stringWithFormat:@"Hello, %@",[PC_DataManager sharedManager].parentObjectInstance.firstName];
    //   UILabel *name=[[UILabel alloc]init];
    //    CGSize displayValueSize = [labelStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    //    name.font=[UIFont fontWithName:RobotoRegular size:15.0f];
    //    name.text=labelStr;
    //    name.frame=CGRectMake(0,0,displayValueSize.width,displayValueSize.height);
    //    name.center=CGPointMake(topStrip.center.x, topStrip.center.y);
    //    name.textColor=[UIColor whiteColor];
    //    [name sizeToFit];
    //    [loadElementView addSubview:name];
}

-(void)drawBottomImage
{
    bottomStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"welcomefooter.png") ]];
    bottomStrip.center=CGPointMake(screenWidth/2, screenHeight-bottomStrip.frame.size.height/2);
    [loadElementView addSubview:bottomStrip];
}

-(void)drawheadingLabel
{
    CGPoint point = CGPointZero;
    NSString *labelStr=@"What would you like to view?";
    heading=[[UILabel alloc]init];
    heading.font=[UIFont fontWithName:RobotoRegular size:15.0f * ScreenHeightFactor];
    CGSize displayValueSize = [labelStr sizeWithAttributes:@{NSFontAttributeName:heading.font}];
    
    heading.text=labelStr;
    heading.frame=CGRectMake(0,0,displayValueSize.width,displayValueSize.height);
    // heading.center=CGPointMake(screenWidth/2, screenHeight*.2);
    heading.textColor=placeHolderReg;
    [heading sizeToFit];
    [loadElementView addSubview:heading];
    if(screenWidth>700)
    {
        //rect = CGRectMake(0, 0, 0, 0);
        heading.center=CGPointMake(screenWidth/2, screenHeight*.20);
        point = CGPointMake(heading.center.x, screenHeight*.28);
        
    }
    else{
        // rect = CGRectMake(0, 0, 0, 0);
        heading.center=CGPointMake(screenWidth/2, screenHeight*.2);
        point = CGPointMake(heading.center.x, screenHeight*.28);
        
    }
    
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth*.15, 1*ScreenHeightFactor)];
    lineview.center=point;
    lineview.backgroundColor=[UIColor lightGrayColor];
    [loadElementView addSubview:lineview];
}


-(void)drawCircumference
{
    fieldsArray=[[NSMutableArray alloc]init];//initWithObjects: @"settingBtn",@"notificationBtn",@"recommendations",@"wishlistBtn",@"activityBtn",@"network", nil];
    
    
    
    centerX=profileBtn.center.x;
    centerY=profileBtn.center.y;
    // objectCount=[viewProfileArray count];
    float objctDis= centerX*.6f;
    if(screenWidth>700)
    {
        objctDis= centerX*.6f;
    }
    else
    {
        objctDis= centerX*.65f;
    }
    
    float angle=360/[viewProfileArray count];
    
    float newX, newY;
    
    for(int count=0 ; count< viewProfileArray.count ; count++)
    {
                
        newX=centerX+ (cosf(((i)*(angle)*M_PI)/180)* objctDis);
        newY=centerY+ (sinf(((i)*(angle)*M_PI)/180)* objctDis);
        
        
        CGRect frame  = CGRectZero;
        
        if(screenWidth>700)
        {
            frame = CGRectMake(0, 0, screenWidth*.18, screenWidth*.18);
        }
        else
        {
            frame = CGRectMake(0, 0, screenWidth*.2, screenWidth*.2);
        }
        ParentViewObject *objectView=[[ParentViewObject alloc]initWithFrame:frame];
        [objectView implementViewWithImage:[viewProfileArray objectAtIndex:count] withLabel:[viewProfileLabelArray objectAtIndex:count]];
        if(count==3 && [[PC_DataManager sharedManager]badgeCount] && ![[[PC_DataManager sharedManager]badgeCount]isEqualToString:@"0"])
        {
            [objectView updateViewWithBadgeCount:[[PC_DataManager sharedManager]badgeCount]];
        }
        
        objectView.center=CGPointMake(newX, newY);
        [loadElementView addSubview:objectView];
        [objectView setAlpha:0];
        objectView.tag=i;
        i++;
        [fieldsArray addObject:objectView];
        // angle+=angle;
    }
}

-(void)becomeVisibleimg:(UIImageView*)img
{
    [img setAlpha:1.0];
}


-(void) touchesBegan:touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    for(UIImageView *img in fieldsArray)
    {
        if(CGRectContainsPoint(img.frame, loc))
        {
            img.alpha=0.1f;
        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //
    //    AppMenuViewController *appenu=[[AppMenuViewController alloc ]init];
    //    [self.navigationController pushViewController:appenu animated:YES];
    
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    
    //    if(CGRectContainsPoint(moreImg.frame, loc))
    //    {
    //       logout = [[LogoutView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    //        logout.logoutDelegate=self;
    //        [self.view addSubview:logout];
    //    }
    //
    
    for(UIImageView *img in fieldsArray)
    {
        img.alpha=1.0f;
        if(CGRectContainsPoint(img.frame, loc))
        {
            
            TabBarViewController *appenu=[[TabBarViewController alloc ]init];
            switch (img.tag)
            {
                case 0:
                {
                    NSLog(@"image 1" );
                    
                    
                    [appenu setSelectedIndex:3];
                    break;
                }
                    
                case 1:
                {
                    NSLog(@"image 2" );
                    [appenu setSelectedIndex:2];
                    break;
                    
                }
                    
                    
                case 2:
                {
                    NSLog(@"image 3" );
                   [appenu setSelectedIndex:4];
                    break;
                    
                }
                    
                case 3:
                {
                    NSLog(@"image 4" );
                    [appenu setSelectedIndex:0];
                    break;
                }
                    
                case 4:
                {
                    
                    
                    NSLog(@"image 5" );
                    //  [self addSchedularTutorial];
                    [appenu setSelectedIndex:1];
                    break;
                    
                }
                    
                    
            }
            break;
        
        }
    }
}



#pragma mark  LOgout view delegate
-(void)mainMenuClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)cancelClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer {
    
    //    TabBarViewController *appenu=[[TabBarViewController alloc ]init];
    //
    //    [appenu setSelectedIndex:1];
    //    NSLog(@"appmenu");
    //    //[self  presentViewController:appenu animated:YES completion:nil];
    
}

#pragma mark gesture recognizers
-(void)touchAtMenuButton:(id)sender
{
    if(!menu)
    {
        removeMenuView=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height, screenWidth, screenHeight-headerView.frame.size.height)];
        removeMenuView.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *removeMenuGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToRemoveMenu:)];
        [removeMenuView addGestureRecognizer:removeMenuGesture];
        
        menu=[[MenuSettingsView alloc]initWithFrame:CGRectMake(screenWidth,20*ScreenHeightFactor, screenWidth*.5, screenHeight-moreImg.frame.origin.y)andViewCtrl:self];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:menu.bounds];
        menu.layer.masksToBounds = NO;
        [menu.layer setShadowColor:[UIColor grayColor].CGColor];
        [menu.layer setShadowOpacity:0.8];
        [menu.layer setShadowRadius:10.0];
        [menu.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        menu.layer.shadowPath = shadowPath.CGPath;
        [loadElementView addSubview:menu];
    }
    if(!isToggleMenu)
    {
        isToggleMenu=YES;
        //accessTable.userInteractionEnabled=NO;
        [self slideIn];
    }
    else
    {
        [self touchToRemoveMenu:nil];
    }
}

-(void)touchToRemoveMenu:(id)sender
{
    isToggleMenu=NO;
    [self slideOut];
}

-(void)slideIn
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // [menu setCenter:CGPointMake(menu.center.x-screenWidth*.2, screenHeight/2)];
        [loadElementView addSubview:removeMenuView];
        [loadElementView setUserInteractionEnabled:NO];
        [loadElementView setCenter:CGPointMake(loadElementView.center.x-screenWidth*.5, self.view.center.y)];
    } completion:^(BOOL finished) {
        [loadElementView setUserInteractionEnabled:YES];
    }];
    
}
-(void)slideOut
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // [menu setCenter:CGPointMake(menu.center.x+screenWidth*.2, screenHeight/2)];
        [removeMenuView removeFromSuperview];
        [loadElementView setUserInteractionEnabled:NO];
        [loadElementView setCenter:CGPointMake(loadElementView.center.x+screenWidth*.5, self.view.center.y)];
    } completion:^(BOOL finished) {
        [loadElementView setUserInteractionEnabled:YES];
    }];
}

-(void)getMenuTouches
{
    [self touchAtMenuButton:self];
}
-(void)touchAtBackButton
{
    [self goBack];
}

#pragma mark ConnectionSpecificFunctions
-(void)getNotificationCount
{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"123"]isEqualToString:@"2"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:PinWiGetNewNotificationCount];
        GetNewNotificationCount *getNewNotificationCount = [[GetNewNotificationCount alloc]init];
        [getNewNotificationCount setDelegate:self];
        [getNewNotificationCount setServiceName:PinWiGetNewNotificationCount];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setValue:[PC_DataManager sharedManager].parentObjectInstance.parentId forKey:@"ParentID"];
        [getNewNotificationCount initService:dictionary];
    }
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetNewNotificationCountResponse resultKey:PinWiGetNewNotificationCountResult];
    
    NSLog(@"Dict  = %@",dict);
    if([dict isKindOfClass:[NSArray class]])
    {
        NSArray *arr  = (NSArray *)dict;
        NSDictionary *dictionary = [arr firstObject];
        
        NSString *badgeCount = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Count"]];
        [[PC_DataManager sharedManager]setBadgeCount:badgeCount];
        if(![badgeCount isEqualToString:@"0"])
        {
           //  [self drawCircumference];
            ParentViewObject *notificationObject  = [fieldsArray objectAtIndex:3];
            [notificationObject updateViewWithBadgeCount:badgeCount];
        }
    }
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
}


#pragma mark Add Tutorials
-(void)addSchedularTutorial
{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"Schedular1"]isEqualToString:@"1"])
    {
        TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
        tutorial.tutorialName=@"Schedular1";
        tutorial.loadIndexVal=schedularIndex;
        [self presentViewController:tutorial animated:YES completion:nil];
    }
}



@end
