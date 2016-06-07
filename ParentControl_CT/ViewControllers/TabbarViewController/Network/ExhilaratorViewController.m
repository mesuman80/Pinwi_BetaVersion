//
//  ExhilaratorViewController.m
//  ParentControl_CT
//
//  Created by Sakshi on 07/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "ExhilaratorViewController.h"
#import "InterestDriverBigView.h"

@interface ExhilaratorViewController ()<HeaderViewProtocol>

@end

@implementation ExhilaratorViewController

@synthesize stripView;
@synthesize childDetailArray;
@synthesize tabBarCtrl,loaderView,loadElementView,yCord,yy,xCord,cellHeight,headerHeight;
@synthesize label,headerView,scrollView,pageControl,pageControlHeight,childName;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PC_DataManager sharedManager]getWidthHeight];
    pageControlHeight = (ScreenWidthFactor*20);
    if(!loadElementView)
    {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth*1.5, screenHeight)];
        [self.view addSubview:loadElementView];
    }
    
    [self.view setBackgroundColor:appBackgroundColor];
    
    childDetailArray = [[NSMutableArray alloc]init];
    cellHeight = 150;
    headerHeight = 50;

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self drawHeaderView];
    [self childNameLabel];
    [self drawUiWithHead];
//    [self getFriendsDetail];
    [self.tabBarCtrl.tabBar setSelectedImageTintColor:NonInfluencerGreen];
}

#pragma mark headerViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setCentreImgName:@"networkHeader.png"];
        //[headerView setRightType:@"Menu"];
        [headerView drawHeaderViewWithTitle:@"Network" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+25*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }
        //        StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0,yy+50, self.view.frame.size.width,27*ScreenHeightFactor)];
        //        [stripView drawStrip:@"My Profile" color:[UIColor clearColor]];
        //
        //        [self.view addSubview:stripView];
        
        
    }
}
#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark drawUI
-(void)drawUiWithHead
{
    
//    [self setupPageControl:[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count];
    yCord = label.frame.size.height + label.frame.origin.y + 10*ScreenHeightFactor;
    StripView *stripView1 = [[StripView alloc] initWithFrame:CGRectMake(0, yCord, self.view.frame.size.width,30*ScreenHeightFactor)];
    [stripView1 drawStrip:self.childName color:[UIColor grayColor]];
    [self.view addSubview:stripView1];
    
    
    StripView *stripView2 = [[StripView alloc] initWithFrame:CGRectMake(0, yCord+stripView1.frame.size.height, self.view.frame.size.width,30*ScreenHeightFactor)];
    [stripView2 drawStrip:@"Exhilarators" color:[UIColor grayColor]];
    stripView2.backgroundColor = [UIColor grayColor];
    stripView2.alpha = 0.5;
    stripView2.StripLabel.textColor = [UIColor blackColor] ;
    [self.view addSubview:stripView2];
    
    yCord += stripView2.frame.size.height + stripView2.frame.size.height;

    if(!scrollView)
    {
        if (screenWidth>700) {
            scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yCord, self.view.frame.size.width, self.view.frame.size.height-yCord)];
            scrollView.center = CGPointMake(scrollView.frame.size.width/2, scrollView.center.y);
        }else{
        if (screenWidth>320) {
            scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yCord, self.view.frame.size.width, self.view.frame.size.height-yCord)];
            scrollView.center = CGPointMake(scrollView.frame.size.width/2, scrollView.center.y);
        }
        else{
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yCord, self.view.frame.size.width, self.view.frame.size.height-yCord)];
        scrollView.center = CGPointMake(scrollView.frame.size.width/2, scrollView.center.y);
        }
        }
        [scrollView setPagingEnabled:NO];
        [scrollView setScrollEnabled:NO];
        [scrollView setBackgroundColor:ExhilaratorPurple];
        [self.view addSubview:scrollView];
        
//        StripView *stripView1 = [[StripView alloc]initWithFrame:CGRectMake(0, yCord, self.view.frame.size.width,30*ScreenHeightFactor)];
//        [stripView1 drawStrip:self.childName color:[UIColor grayColor]];
//        stripView1.StripLabel.font = [UIFont fontWithName:RobotoRegular size:14.0f*ScreenHeightFactor];
//        stripView1.StripLabel.textColor = activityHeading1FontCode;
//        [scrollView addSubview:stripView1];
//        
//        StripView *stripView2 = [[StripView alloc]initWithFrame:CGRectMake(0, yCord+stripView1.frame.size.height, self.view.frame.size.width,30*ScreenHeightFactor)];
//        [stripView2 drawStrip:@"Exhilarators" color:[UIColor colorWithRed:216.0f/255 green:220.0f/255 blue:226.0f/255 alpha:0.0f]];
//        stripView2.StripLabel.font = [UIFont fontWithName:RobotoRegular size:14.0f*ScreenHeightFactor];
//      //  stripView2.backgroundColor = [UIColor grayColor];
//       // stripView2.alpha = 1.5;
//        stripView2.StripLabel.textColor = activityHeading2FontCode;
//        [scrollView addSubview:stripView2];
        
        
        [[PC_DataManager sharedManager]InsightsArrays];
        [self drawDescriptiveText:[interestDriversArray objectAtIndex:self.tagVal]];
        
        
        xCord=scrollView.frame.size.width*.25;
        int interestHt=180*ScreenHeightFactor;
        NSLog(@"self.dataDictionary  =%@" , self.dataDictionary);
         NSArray *arr = (NSArray *)self.dataDictionary;
        
        for(int i=0; i<arr.count; i++)
        {
            InterestDriverBigView *interestView=[[InterestDriverBigView alloc]initWithFrame:CGRectMake(cellPadding, yCord, scrollView.frame.size.width-3*cellPadding, interestHt)];
            [interestView setBackgroundColor:[UIColor clearColor]];
            [interestView drawUi:[arr objectAtIndex:i]];
            [interestView setCenter:CGPointMake( interestView.center.x, interestView.center.y)];
            yCord +=interestHt;
            [scrollView addSubview:interestView];
            
        }
        NSLog(@"y cord= %i",yCord);
        NSLog(@"yy == %i",yy);
        
        yCord+=yy+10*ScreenHeightFactor;
        
        if(screenWidth<700)
        {
            yCord+=ScreenHeightFactor;
        }
        if(yCord>self.view.frame.size.height-yy)
        {
            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, yCord)];
            [scrollView setScrollEnabled:YES];
        }
    }
}

-(void)drawDescriptiveText:(NSString*)str
{
    // yCord+=20*ScreenFactor;
    
    // NSString *str =[NSString stringWithFormat:@"Based on consistency and frequency of rating you are currently at Level.Based on consistency and frequency of rating you are currently at Level.Based on consistency and frequency of rating you are currently at Level.Based on consistency and frequency of rating you are currently at Level.Based on consistency and frequency of rating you are currently at Level.Based on consistency and frequency of rating you are currently at Level.Based on consistency and frequency of rating you are currently at Level.Based on consistency and frequency of rating you are currently at Level."];
    
 //   NSArray *array=[[PC_DataManager sharedManager].serviceDictionary objectForKey:[NSString stringWithFormat:@"PinWiGetDelightTraitsByChildIDOnInsight-%@",self.childObj.child_ID]];
    
    UITextView *textDesc=[[UITextView alloc]init];
    [textDesc setText:str];
    [textDesc setDelegate:nil];
    [textDesc setEditable:NO];
    [textDesc setSelectable:NO];
    [textDesc setScrollEnabled:NO];
    [textDesc setTextColor:[UIColor whiteColor]];
    [textDesc setFont:[UIFont fontWithName:RobotoRegular size:9*ScreenFactor]];
    [textDesc setBackgroundColor:[UIColor clearColor]];
    if (screenWidth>700) {
        textDesc.frame=CGRectMake(cellPadding,10*ScreenHeightFactor,scrollView.frame.size.width-2*cellPadding,120*ScreenHeightFactor);
    }else{

    if (screenWidth>320) {
        textDesc.frame=CGRectMake(cellPadding,15*ScreenHeightFactor,scrollView.frame.size.width-2*cellPadding,100*ScreenHeightFactor);
    }
    else{
        textDesc.frame=CGRectMake(cellPadding,15*ScreenHeightFactor,scrollView.frame.size.width-2*cellPadding,120*ScreenHeightFactor);
    }
    }
    textDesc.textAlignment=NSTextAlignmentLeft;
    [textDesc resignFirstResponder];
    [textDesc setEditable:NO];
    [scrollView addSubview:textDesc];
    
    yCord+=textDesc.frame.size.height+5*ScreenHeightFactor;
    
    UIView *line= [[PC_DataManager sharedManager]drawLineView_withXPos:scrollView.center.x andYPos:textDesc.frame.origin.x+textDesc.frame.size.height+20*ScreenHeightFactor withScrnWid:scrollView.frame.size.width-2*cellPadding withScrnHt:1*ScreenHeightFactor ofColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4f]];
    [scrollView addSubview:line];
    
    yCord = line.frame.size.height +10*ScreenHeightFactor + line.frame.origin.y;
    
    
}


-(void)setupPageControl:(NSInteger)number_Of_Page
{
    //int height  = [self navigationBarHeight];
    if(screenWidth>700)
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*3,pageControlHeight,pageControlHeight)];
        pageControl.transform = CGAffineTransformMakeScale(2, 2);
    }
    else
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*12,pageControlHeight,pageControlHeight)];
    }
    
    [pageControl setCenter:CGPointMake(screenWidth/2, pageControl.center.y)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=number_Of_Page;
    // pageControl.pageIndicatorTintColor=[UIColor blackColor];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    
    [loadElementView addSubview:pageControl];
}

#pragma mark child
-(void)childNameLabel
{
    if(!label)
    {
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 180, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
            label.center=CGPointMake(screenWidth/2,180);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2);
        }
        
        [self.view addSubview:label];
        yy+=80+label.frame.size.height+15*ScreenHeightFactor;
    }
    
    
//    [self addLoaderView];
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
