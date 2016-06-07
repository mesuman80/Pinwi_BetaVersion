//
//  DelightTrendsFull_VC.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 01/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InterestDriversFull_VC.h"
#import "HeaderView.h"
#import "PC_DataManager.h"
#import "Constant.h"
#import "InterestDriverBigView.h"
#import "RedLabelView.h"
#import "StripView.h"
@interface InterestDriversFull_VC ()<HeaderViewProtocol>

@end

@implementation InterestDriversFull_VC
{
    HeaderView *headerView;
    UIScrollView *scrollView;
    int yy;
    int yCord, xCord;
    //    UIButton *backButton;
    //    UIView *viewBack;
    //    UIGestureRecognizer *gestureRecognizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
    yCord=0;
    [self.view setBackgroundColor:appBackgroundColor];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.title=@"Insights";
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self drawHeaderView];
    [self drawUiWithHead];
     [self.tabBarCtlr.tabBar setSelectedImageTintColor:[UIColor redColor]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //  [viewBack removeGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark headerViewSpecificFunction
#pragma mark headerViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setCentreImgName:@"insightHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Insights" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        //[self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
        yy+=headerView.frame.size.height+10*ScreenHeightFactor;
    }
    // yy+=headerView.frame.size.height+10*ScreenHeightFactor;
}
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark drawUI
-(void)drawUiWithHead
{
    
    if(!scrollView)
    {
        //yy = 64+20*ScreenFactor;
        
        RedLabelView *label;
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:self.childObj.nick_Name];
            label.center=CGPointMake(ScreenWidthFactor*320/2,yy+label.frame.size.height/2+20*ScreenHeightFactor);
            yy+=label.frame.size.height+30*ScreenHeightFactor;

        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:self.childObj.nick_Name];
            label.center=CGPointMake(ScreenWidthFactor*320/2,yy+label.frame.size.height/2+5*ScreenHeightFactor);
            yy+=label.frame.size.height+20*ScreenHeightFactor;

        }
        
        [self.view addSubview:label];
        
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:NO];
        [scrollView setScrollEnabled:NO];
        
        [scrollView setBackgroundColor:[self.dataDictionary objectForKeyedSubscript:@"Color"]];
        [self.view addSubview:scrollView];
        
        StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0, yCord, self.view.frame.size.width,30*ScreenHeightFactor)];
        [stripView drawStrip:[self.dataDictionary objectForKeyedSubscript:@"title"] color:activityHeading1Code];
        [scrollView addSubview:stripView];
        
        yCord += stripView.frame.size.height;
        
        [[PC_DataManager sharedManager]InsightsArrays];
        [self drawDescriptiveText:[interestDriversArray objectAtIndex:self.tagVal]];
        
//        NSArray *array=[[PC_DataManager sharedManager].serviceDictionary objectForKey:[NSString stringWithFormat:@"PinWiGetInterestTraitsByChildIDOnInsight-%@",self.childObj.child_ID]];

        xCord=scrollView.frame.size.width*.25;
        int interestHt=180*ScreenHeightFactor;
        NSLog(@"self.dataDictionary  =%@" , self.dataDictionary);
        
        for(int i=0; i<[[self.dataDictionary objectForKey:@"Array"] count]; i++)
        {
//            if(i%2==0 && i!=0)
//            {
//                xCord=scrollView.frame.size.width*.25;
//                yCord +=interestHt;
//            }
//            else if(i%2==1)
//            {
//                xCord=scrollView.frame.size.width*.75;
//                //+30*ScreenHeightFactor;
//            }
            
            InterestDriverBigView *interestView=[[InterestDriverBigView alloc]initWithFrame:CGRectMake(cellPadding, yCord, scrollView.frame.size.width-3*cellPadding, interestHt)];
            [interestView setBackgroundColor:[UIColor clearColor]];
            [interestView drawUi:[[self.dataDictionary objectForKey:@"Array"] objectAtIndex:i]];
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
    
    NSArray *array=[[PC_DataManager sharedManager].serviceDictionary objectForKey:[NSString stringWithFormat:@"PinWiGetDelightTraitsByChildIDOnInsight-%@",self.childObj.child_ID]];
    
    UITextView *textDesc=[[UITextView alloc]init];
    [textDesc setText:str];
    [textDesc setDelegate:nil];
    [textDesc setEditable:NO];
    [textDesc setSelectable:NO];
    [textDesc setScrollEnabled:NO];
    [textDesc setTextColor:[UIColor whiteColor]];
    [textDesc setFont:[UIFont fontWithName:RobotoRegular size:9*ScreenFactor]];
    [textDesc setBackgroundColor:[UIColor clearColor]];
    textDesc.frame=CGRectMake(cellPadding,yCord,scrollView.frame.size.width-2*cellPadding,100*ScreenHeightFactor);
    textDesc.textAlignment=NSTextAlignmentLeft;
    [textDesc resignFirstResponder];
    [textDesc setEditable:NO];
    [scrollView addSubview:textDesc];
    
    yCord+=textDesc.frame.size.height+5*ScreenHeightFactor;
    
   UIView *line= [[PC_DataManager sharedManager]drawLineView_withXPos:scrollView.center.x andYPos:textDesc.frame.origin.x+textDesc.frame.size.height+20*ScreenHeightFactor withScrnWid:scrollView.frame.size.width-2*cellPadding withScrnHt:1*ScreenHeightFactor ofColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4f]];
    [scrollView addSubview:line];
    
    yCord+=30*ScreenHeightFactor;
    
    
}



#pragma mark MENU BUTTON DELEGATE
-(void)getMenuTouches
{
//    [self touchAtPinwiWheel];
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
