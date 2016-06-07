//
//  AddPassCode.m
//  Pin Tel
//
//  Created by Veenus Chhabra on 06/11/14.
//  Copyright (c) 2014 mvn. All rights reserved.
//

#import "AddPassCode.h"
#import "HeaderView.h"
#import "AccessProfileViewController.h"

#define attributeKerniPad @""

@interface AddPassCode() <PinPadPassProtocol,HeaderViewProtocol>


@end

@implementation AddPassCode
{
    UITextField *enterPsWd;
    UITextField *reEnterPsWd;
    //    UITextField *enterEmail;
    
    UILabel *errorLabel;
    
    UIButton *okButton;
    UIButton *forgotPswd;
    
    NSMutableData *myData;
    NSURLConnection *urlConnection;
    
    UIImageView *navigationView;
    BOOL done;
    
    PPPinPadViewController * ppinViewController;
    NSString *tempPin;
    NSString *userKey;
    
    UIImageView *centerIcon;
    
    NSString *psswordText;
    
    HeaderView *headerView;
    int yy;
    
}

@synthesize firstDigitTextField,fourthDigitTextField,secondDigitTextField,thirdDigitTextField;
@synthesize animatingView;


-(void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.view setBackgroundColor:appBackgroundColor];
    
    yy= 0 ;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationItem setHidesBackButton:YES];
    
   
    
    psswordText = @"";
    if(!enterPsWd)
    {
        [self checkPasswd];
    }
    
}

-(id)initwithEnablePswd:(BOOL)enablePswd changePswd:(BOOL)chngpswd deletePswd:(BOOL)delPswd key:(NSString*)key
{
    if(self==[super init])
    {
        enterNewPsWd=enablePswd;
        changePswd=chngpswd;
        removePsWd=delPswd;
        userKey=key;
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    forgotPswdBool=NO;
    
    if(!done)
    {
        [self whichScreenToload];
        done=YES;
    }
    [enterPsWd becomeFirstResponder];
    
}
#pragma mark HeaderViewSpecificFunctions
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:@"Save"];
        [headerView setCentreImgName:@"accessProfileIcon.png"];
        [headerView drawHeaderViewWithTitle:@"Setup Passcode" isBackBtnReq:YES BackImage:@"Cancel"];
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
    [self setPassword:nil];
}
-(void)touchAtBackButton
{
    [self cancelBtnTouch:nil];
}



#pragma mark UI LOAD

-(void)whichScreenToload
{
    if(!enterNewPsWd && !removePsWd && !changePswd)
    {
        ppinViewController = [[PPPinPadViewController alloc] init];
        ppinViewController.delegate = self;
        ppinViewController.pinTitle = @"Enter Passcode";
        ppinViewController.errorTitle = @"";
        ppinViewController.parentClass=self.parentClass;
        ppinViewController.cancelButtonHidden = NO; //default is False
        //ppinViewController.backgroundImage = [UIImage imageNamed:@"loginBg-667h.png"]; //if you need remove the background set a empty UIImage ([UIImage new]) or set a background color
        ppinViewController.backgroundColor = appBackgroundColor;//[UIColor whiteColor]; //default is a darkGrayColor
        
        [self presentViewController:ppinViewController animated:NO completion:nil];
       // headerView.alpha=0;
        
    }
    else if(enterNewPsWd)
    {
         [self drawHeaderView];
        [self AddNewPassword];
        [enterPsWd becomeFirstResponder];
    }
}

- (BOOL)checkPin:(NSString *)pin {
    tempPin=pin;
    
    NSString *pinCode  =[LTHKeychainUtils getPasswordForUsername:userKey andServiceName:@"PCApp" error:nil];
    NSLog(@"pinCode  = %@",pinCode);
    
    //return [pin isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"LocalPassword"]];
    return [pin isEqualToString:[LTHKeychainUtils getPasswordForUsername:userKey andServiceName:@"PCApp" error:nil]];
}

- (NSInteger)pinLenght {
    return 4;
}

-(void)pinPadSuccessPin
{
    [self.passcodeDelegate passCodeSuccess];
    //    [self setPassword:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

-(void)pinForgot
{
    [self.passcodeDelegate forgotPasscode];
    [self dismissViewControllerAnimated:NO completion:nil];
    //[self forgotPassword:nil];
}

-(void)pinPadWillHide
{
    [self.passcodeDelegate cancelBtnTouched];
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)AddNewPassword
{
    
    UILabel *label   = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"Enter your passcode";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName:RobotoRegular size:16.0f*ScreenHeightFactor];
    CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    [label setCenter:CGPointMake(self.view.frame.size.width/2.0f,self.view.frame.size.height*.2)];
    [self.view addSubview:label];
    
    
    
    UIFont *font =[UIFont fontWithName:RobotoRegular size:50.0f*ScreenHeightFactor];
    enterPsWd=[[UITextField alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height*.26f,205*ScreenWidthFactor,40*ScreenHeightFactor)];
    
    if(screenWidth>700)
    {
        enterPsWd=[[UITextField alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height*.4f,205*ScreenWidthFactor,80*ScreenHeightFactor)];
    }
    [enterPsWd setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    enterPsWd.autocorrectionType = UITextAutocorrectionTypeNo;
    [enterPsWd setFont:font];
    enterPsWd.textAlignment=NSTextAlignmentLeft;
    enterPsWd.keyboardType=UIKeyboardTypeNumberPad;
    [enterPsWd setDelegate:self];
    [enterPsWd setSecureTextEntry:YES];
    [enterPsWd setCenter:CGPointMake(self.view.frame.size.width/2.0f, enterPsWd.center.y)];
    [self.view addSubview:enterPsWd];
    [enterPsWd setTextColor:[UIColor blackColor]];
    //enterPsWd.contentVerticalAlignment=UIControlContentVerticalAlignment;
    //  [enterPsWd setBackgroundColor:[UIColor redColor]];
    [enterPsWd becomeFirstResponder];
    
    
    int xx = enterPsWd.frame.origin.x-5*ScreenWidthFactor;
    int lineWidth = 33*ScreenWidthFactor;
    int lineHeight = 3*ScreenHeightFactor ;
    int gapBetweenTwoLine = 25*ScreenWidthFactor;
    
    int yHt=0;
    if(screenWidth>700)
    {
        yHt=10*ScreenHeightFactor;
    }
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(xx,enterPsWd.frame.origin.y+enterPsWd.frame.size.height-2*ScreenHeightFactor+yHt,lineWidth,lineHeight)];
    [self.view addSubview:lineView];
    lineView.backgroundColor=[UIColor grayColor];
    xx += lineView.frame.size.width+gapBetweenTwoLine+2*ScreenWidthFactor;
    
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(xx,enterPsWd.frame.origin.y+enterPsWd.frame.size.height-2*ScreenHeightFactor+yHt,lineWidth,lineHeight)];
    [self.view addSubview:lineView1];
    lineView1.backgroundColor=[UIColor grayColor];
    xx +=lineView1.frame.size.width+gapBetweenTwoLine+3*ScreenWidthFactor;
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(xx,enterPsWd.frame.origin.y+enterPsWd.frame.size.height-2*ScreenHeightFactor+yHt,lineWidth,lineHeight)];
    [self.view addSubview:lineView2];
    lineView2.backgroundColor=[UIColor grayColor];
    xx +=lineView2.frame.size.width+gapBetweenTwoLine+4*ScreenWidthFactor;
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(xx,enterPsWd.frame.origin.y+enterPsWd.frame.size.height-2*ScreenHeightFactor+yHt,lineWidth,lineHeight)];
    [self.view addSubview:lineView3];
    lineView3.backgroundColor=[UIColor grayColor];
}

-(void)removePassword
{
    [self AddNewPassword];
}

-(void)exitApp
{
    exit(1);
}


#pragma mark buttons and touches
-(void)cancelBtn
{
    
    // NSString *buttonTitle=@"Cancel";
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    cancelButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:20*ScreenHeightFactor];
    [cancelButton sizeToFit];
    cancelButton.center=CGPointMake(self.view.frame.size.width*.12,navigationView.frame.size.height/2.0+10);
    cancelButton.tintColor=[UIColor blackColor];
    [cancelButton addTarget:self action:@selector(cancelBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

-(void)cancelBtnTouch:(id)sender
{
    if(!removePsWd && !enterNewPsWd && !changePswd)
    {
        [self exitApp];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"pswdOn"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.passcodeDelegate cancelBtnTouched];
        [self dismissViewControllerAnimated:YES completion:nil];
        // [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


-(void)forgotPswd
{
    forgotPswd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [animatingView addSubview: forgotPswd];
    forgotPswd.titleLabel.font=[UIFont fontWithName:RobotoRegular size:18*ScreenHeightFactor];
    [ forgotPswd setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [forgotPswd setTitle:@"Forgot Password" forState:UIControlStateNormal];
    [ forgotPswd sizeToFit];
    forgotPswd.center=CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height*.5);
    [ forgotPswd addTarget:self action:@selector(forgotPassword:) forControlEvents:UIControlEventTouchUpInside];
    forgotPswd.tintColor=[UIColor redColor];
}


-(void)okButton
{
    okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:@"Done" forState:UIControlStateNormal];
    [okButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    okButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:20*ScreenHeightFactor];
    [okButton sizeToFit];
    okButton.center=CGPointMake(self.view.frame.size.width*.9,navigationView.frame.size.height/2.0+10);
    [okButton addTarget:self action:@selector(setPassword:) forControlEvents:UIControlEventTouchUpInside];
    okButton.tintColor=[UIColor blackColor];
    [self.view addSubview:okButton];
}

-(void)setPassword:(id)sender
{
    if(errorLabel)
    {
        errorLabel.text=@"";
    }
    int iValue;
    //=============================================================================================================================
    if(!removePsWd && !changePswd && !enterNewPsWd)
    {
//        AccessProfileViewController *accessProfileViewController = [[AccessProfileViewController alloc] init];
//        [self.navigationController pushViewController:accessProfileViewController animated:YES];
        if([tempPin isEqualToString:[LTHKeychainUtils getPasswordForUsername:userKey andServiceName:@"PCApp" error:nil]])
        {
            
            if(ppinViewController)
            {
                [ppinViewController dismissViewControllerAnimated:YES completion:nil];
                ppinViewController=nil;
            }
            
            
            
            //    [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [self setErrorField:@"Wrong passcode. Please try again."];
            // errorLabel.hidden=NO;
            errorLabel.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*.4);
            enterPsWd.text=@"";
            [enterPsWd becomeFirstResponder];
            
        }
    }
    //=============================================================================================================================
    else if(removePsWd)
    {
        if([enterPsWd.text isEqualToString:[LTHKeychainUtils getPasswordForUsername:userKey andServiceName:@"PCApp" error:nil]])
        {
            [LTHKeychainUtils deleteItemForUsername:userKey andServiceName:@"PCApp" error:nil];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"doesPswdExist"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"pswdOn"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            // [self.navigationController popToRootViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            // NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"pswdOn"]);
        }
        else
        {
            [self setErrorField:@"Password is incorrect. Please try again."];
            // errorLabel.hidden=NO;
            errorLabel.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*.4);
            enterPsWd.text=@"";
            [enterPsWd becomeFirstResponder];
        }
    }
    //=============================================================================================================================
    
    else if(changePswd && !enterNewPsWd)
    {
        if([enterPsWd.text isEqualToString:[LTHKeychainUtils getPasswordForUsername:userKey andServiceName:@"PCApp" error:nil]])
        {
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 animatingView.center=CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*1.5);
                             }
                             completion:^(BOOL finished){
                                 
                                 [animatingView removeFromSuperview];
                                 animatingView=nil;
                                 enterNewPsWd=YES;
                                 [self AddNewPassword];
            }];
        }
        else
        {
            [self setErrorField:@"Password is incorrect. Please try again."];
            // errorLabel.hidden=NO;
            errorLabel.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*.4);
            enterPsWd.text=@"";
            [enterPsWd becomeFirstResponder];
            
        }
        
    }
    //=============================================================================================================================
    else if (enterNewPsWd)
    {
        
        if([enterPsWd.text isEqualToString:@""])
        {
            [self setErrorField:@"Please enter all fields."];
            return;
        }
        
        
        if (!(enterPsWd.text.length > 0 && [[NSScanner scannerWithString:enterPsWd.text] scanInt:&iValue])) {
            //do smomething with iValue (int value from noOfPassengers.text)
            // NSLog(@"value entered correctly.");
            
            [self setErrorField:@"Enter password corrctly(numbers only)."];
            
            return ;
        }
        if(enterPsWd.text.length!=4)
        {
            [self setErrorField:@"Exactly 4 digits password."];
            enterPsWd.text=nil;
            reEnterPsWd.text=nil;
            [enterPsWd becomeFirstResponder];
            return;
        }
        
        //=============================================================================================================================
        NSLog(@"enterPsWd.text = %@",enterPsWd.text);
//        [LTHKeychainUtils storeUsername:userKey
//                            andPassword:enterPsWd.text
//                         forServiceName:@"PCApp"
//                         updateExisting:YES
//                                  error:nil];
//        [[NSUserDefaults standardUserDefaults]setObject:enterPsWd.text forKey:@"LocalPassword"];
//        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"doesPswdExist"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.passcodeDelegate passCodeSetUp:enterPsWd.text];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

//====================================================================================================================

-(void)setErrorField:(NSString*)errorText
{
    [self removeErrorField];
    errorLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    errorLabel.text=errorText;
    errorLabel.textColor=[UIColor redColor];
    errorLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenHeightFactor];
    errorLabel.numberOfLines=0;
    errorLabel.textAlignment=NSTextAlignmentCenter;
    [errorLabel sizeToFit];
    errorLabel.center=CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height*.5);
    [self.view addSubview:errorLabel];
}

-(void)removeErrorField
{
    if(errorLabel)
    {
        [errorLabel removeFromSuperview];
        errorLabel=nil;
    }
}

-(void)checkPasswd
{
    animatingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    animatingView.center=CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*1.5);
    animatingView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:animatingView];
}

//====================================================================================================================

#pragma mark TextField Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
  
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [self removeErrorField];
    
    NSLog(@"textField.text.Count =%lu %lu",(unsigned long)textField.text.length,(unsigned long)range.location);
    
    if([string isEqualToString:@""])
    {
        if ([psswordText length] > 0) {
            psswordText = [psswordText substringToIndex:[psswordText length] - 1];
        } else {
            //no characters to delete... attempting to do so will result in a crash
            psswordText = @"";
        }
        
        UIFont *font =[UIFont fontWithName:RobotoRegular size:45*ScreenFactor];
        NSAttributedString *attributedString =
        [[NSAttributedString alloc]
         initWithString:psswordText
         attributes:
         @{
           NSFontAttributeName :font,
           NSForegroundColorAttributeName :[UIColor blackColor],
           NSKernAttributeName : @(40*ScreenWidthFactor)
           }];
        
        enterPsWd.attributedText = attributedString;
        return NO;
    }
    else
    {
        
        NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
        s=[s invertedSet];
        
        NSRange r = [string rangeOfCharacterFromSet:s];
        if (r.location != NSNotFound)
        {
            NSLog(@"the string contains illegal characters");
            return NO;
        }
        
        
        psswordText = [textField.text stringByAppendingString:string];
        UIFont *font =[UIFont fontWithName:RobotoRegular size:45*ScreenFactor];
        NSAttributedString *attributedString =
        [[NSAttributedString alloc]
         initWithString:psswordText
         attributes:
         @{
           NSFontAttributeName :font,
           NSForegroundColorAttributeName :[UIColor blackColor],
           NSKernAttributeName : @(40*ScreenWidthFactor)
           }];
        
        enterPsWd.attributedText = attributedString;
        if( range.location==3)
        {
            
            //  [enterPsWd resignFirstResponder];
            tempPin=enterPsWd.text;
            [self setPassword:nil];
            return NO;
        }
        return NO;
    }
    
    
    //  }
    //
    return YES;
}



@end
