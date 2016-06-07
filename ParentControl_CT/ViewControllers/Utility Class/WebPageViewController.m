//
//  WebPageViewController.m
//  Pin_Tel
//
//  Created by Veenus Chhabra on 06/10/14.
//  Copyright (c) 2014 mvn. All rights reserved.
//

#import "WebPageViewController.h"
#import "PC_DataManager.h"

@implementation WebPageViewController
{
    NSString *webString;
    UIButton *backButton;
}


-(id)initWithWebString:(NSString *)str frame:(CGRect)frame
{
    if(self =[super init])
    {
        NSLog(@"......INIT......");
        webString=str;
        return self;
    }
    return nil;
}


- (void)drawWebView:(NSString *)link
{
//    [super viewDidLoad];
   // self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
     NSLog(@"......LOAD......");
    
    //NSString *webStr=[NSString stringWithFormat:@"https://www.pintelapp.com/iphone/%@",webString];
    
    
    
    NSString *webStr=link;
       
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
    webView.delegate=self;
    webView.backgroundColor=appBackgroundColor;
    
    NSString *url=webStr;
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [self addSubview:webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    webView.delegate = self; // setup the delegate as the web view is shown
}

- (void)viewWillDisappear:(BOOL)animated
{
    [webView stopLoading]; // in case the web view is still loading its content
    webView.delegate = nil; // disconnect the delegate as the webview is hidden
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self showLoaderView:YES withText:@"Hold On..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self showLoaderView:NO withText:nil];
}

- (void)webView:(UIWebView *)webView1 didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ERROR!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self showLoaderView:NO withText:nil];
    
}

-(void)showLoaderView:(BOOL)show withText:(NSString *)text
{
    static UILabel *label;
    static UIActivityIndicatorView *activity;
    static UIView *loaderView;
    
    if(show)
    {
        
        
        loaderView=[[UIView alloc] initWithFrame:self.bounds];
        [loaderView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.4]];
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(0, (loaderView.bounds.size.height/2)-10, loaderView.bounds.size.width, 20)];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        label.center=CGPointMake(self.frame.size.width/2, self.frame.size.height*.40f);
        [label setText:text];
        [label setTextAlignment:NSTextAlignmentCenter];
        [loaderView addSubview:label];
        
        activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activity.center=CGPointMake(label.center.x, label.frame.origin.y+label.frame.size.height+10+activity.frame.size.height/2);
        
        [activity startAnimating];
        [loaderView addSubview:activity];
        [self addSubview:loaderView];
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



@end
