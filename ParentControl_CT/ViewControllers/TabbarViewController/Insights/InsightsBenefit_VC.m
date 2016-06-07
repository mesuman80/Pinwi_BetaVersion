//
//  InsightsBenefit_VC.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InsightsBenefit_VC.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "StripView.h"

@interface InsightsBenefit_VC ()<HeaderViewProtocol>

@end

@implementation InsightsBenefit_VC
{
HeaderView *headerView;
UIScrollView *scrollView;
int yy;
int yCord, xCord;
    UIButton *continueButton;
//    UIButton *backButton;
//    UIView *viewBack;
//    UIGestureRecognizer *gestureRecognizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
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
        RedLabelView *label;
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:self.childObj.nick_Name];
            label.center=CGPointMake(ScreenWidthFactor*320/2,yy+label.frame.size.height/2+20*ScreenHeightFactor);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:self.childObj.nick_Name];
            label.center=CGPointMake(ScreenWidthFactor*320/2,yy+label.frame.size.height/2+10*ScreenHeightFactor);
        }
        
        [self.view addSubview:label];
        
        yy+=label.frame.size.height+30*ScreenHeightFactor;
        
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:NO];
        [scrollView setScrollEnabled:NO];
        [scrollView setBackgroundColor:appBackgroundColor];
        [self.view addSubview:scrollView];
        
        //yCord+=20*ScreenFactor;
        
        [self  drawLabelWithText:@"Benefits of Insights" andColor:cellBlackColor_6 andFont:[UIFont fontWithName:RobotoRegular size:9*ScreenFactor]];
        
        yCord+=20*ScreenFactor;
        
        for(int i=0; i<6; i++)
        {
            [self drawBeneFits];
        }
        
        yCord+=10*ScreenHeightFactor;
        
        
        [self addContinueButton];
        
        
        yy+=yCord;
        if(yy>self.view.frame.size.height-headerView.frame.size.height)
        {
            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, yy)];
            [scrollView setScrollEnabled:YES];
        }
    }
}

-(void)addContinueButton
{
    
    continueButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    continueButton.tintColor=activityHeading1FontCode;
    continueButton.backgroundColor=buttonGreenColor;
    [continueButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    continueButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    [continueButton sizeToFit];
    continueButton.frame=CGRectMake(cellPadding, yCord,scrollView.frame.size.width-2*cellPadding,ScreenHeightFactor*40);
    continueButton.center=CGPointMake(scrollView.center.x,continueButton.center.y);
    [continueButton addTarget:self action:@selector(continueBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:continueButton];
    
    //yCord+=continueButton.frame.size.height;
}


-(void)continueBtnTouched
{
    NSLog(@"Subscribe now");
    
}

-(UILabel*)drawLabelWithText:(NSString*)title andColor:(UIColor*)color andFont:(UIFont*)font
{
    UILabel *label = [[UILabel alloc]init];
    [label setText:title];
    [label setTextColor:color];
    [label setFont:font];
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(10*ScreenWidthFactor,yCord, size.width, size.height)];
    [scrollView addSubview:label];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setCenter:CGPointMake(scrollView.frame.size.width/2, label.center.y)];
    yCord+=label.frame.size.height+2*ScreenHeightFactor;
    return label;
}


-(void)drawBeneFits
{
    UIImageView *tickView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"tickInsight.png")]];
    [tickView setFrame:CGRectMake(cellPadding,yCord,ScreenWidthFactor*15,ScreenWidthFactor*15)];
    tickView.contentMode=UIViewContentModeScaleAspectFit;
    [scrollView addSubview:tickView];

    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidthFactor*45,yCord,scrollView.frame.size.width-ScreenWidthFactor*45-cellPadding,ScreenWidthFactor*60)];
    label.textColor=[UIColor lightGrayColor];
    [label setFont:[UIFont systemFontOfSize:7.0*ScreenFactor]];
    NSString *str =[NSString stringWithFormat:@"Based on consistency and frequency of rating you are currently at Level.Based on consistency and frequency of rating you are currently at Level."];
    [label setText:str];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label sizeToFit];
    [label setTextAlignment:NSTextAlignmentLeft];
    [scrollView addSubview:label];

    
    yCord+=label.frame.size.height+10*ScreenHeightFactor;
}


#pragma mark MENU BUTTON DELEGATE
-(void)getMenuTouches
{
   // [self touchAtPinwiWheel];
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
