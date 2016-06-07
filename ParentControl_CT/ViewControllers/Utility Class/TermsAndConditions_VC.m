//
//  TermsAndConditions_VC.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 11/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "TermsAndConditions_VC.h"
#import "HeaderView.h"
#import "Constant.h"
#import "PC_DataManager.h"
#import "WebPageViewController.h"
@interface TermsAndConditions_VC ()<HeaderViewProtocol>

@end

@implementation TermsAndConditions_VC
{
    HeaderView *headerView;
    int yy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:appBackgroundColor];
    [self drawHeaderView];
    [self drawWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"Confirm_header.png"];
        [headerView drawHeaderViewWithTitle:@"Terms and Conditions" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
        
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+30*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }
        [self.view setBackgroundColor:appBackgroundColor];
    }
}

-(void)drawWebView
{
    WebPageViewController *webPage=[[WebPageViewController alloc]initWithFrame:CGRectMake(0,yy, screenWidth, screenHeight-yy)];
    [webPage drawWebView:@"http://pinwi.in/terms.html"];
    [self.view addSubview:webPage];
}

#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
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
