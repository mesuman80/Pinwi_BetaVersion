
//  ConfirmationProfileViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 09/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ConfirmationProfileViewController.h"
#import "WelcomeScreenViewController.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"
#import "TermsAndConditions_VC.h"

@interface ConfirmationProfileViewController ()<HeaderViewProtocol>

@end

@implementation ConfirmationProfileViewController
{
    UILabel *titleLabel;
    UIScrollView *scrollView;
    UITextField *EnterCode;
    NSMutableArray *labelobjectArray;
    UIButton *SubmitBtn,*send;
    BOOL isKeyBoard;
    CGRect keyboardBounds;
    CGSize displayValueSize;
    UIView *lineView;
    UIImageView *navBgBar, *centerIcon;
    UISegmentedControl *segmentedControl;

    SendConfirmationCodeToMail *sendConfirmationCodeToMail;
    CheckConfirmationCodeByParentID *checkConfirmationCodeByParentID;
    NSString *confirmationCode;
    BOOL confirmationCodeCheck;
    ShowActivityLoadingView *loaderView;
    BOOL resendOn;
    
    UITextField *activeField;
    HeaderView *headerView;
    int yy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
       // if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
           // self.edgesForExtendedLayout = UIRectEdgeNone;

    
    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]confirmProfile];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:appBackgroundColor];
    [self drawHeaderView];
    resendOn=NO;
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = appBackgroundColor;
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        //scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
        // code for landscape orientation
    }
    else
    {
        scrollView.frame=CGRectMake(0,yy, screenWidth, screenHeight-yy);
       // scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    }
    [self.view addSubview:scrollView];
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    self.navigationController.navigationBar.translucent=YES;

    
    
    [self moreIcon];
    [self setTitleLabel];
    [self titleLabel];
    [self addButton];
    
    [self setTextFields];
    [self checkBox];
    [self choosemode];
    
//    UIBarButtonItem *newBackButton =
//    [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                     style:UIBarButtonItemStyleBordered
//                                    target:nil
//                                    action:nil];
//    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap1:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:singleTap];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")]forBarMetrics:UIBarMetricsDefault];
    

    
   // self.navigationItem.hidesBackButton=NO;
   //  self.navigationController.navigationBar.topItem.title = @"";

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self addKeyBoardNotification];
    //self.navigationController.navigationBarHidden=NO;
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    
//    
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
    // self.navigationItem.hidesBackButton = NO;
   //  self.navigationController.navigationBar.topItem.title = @"";
   
    [self drawCenterIcon];
    [self hideKeyBoard];
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:YES];
   // [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [centerIcon removeFromSuperview];
    centerIcon =nil ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTitleLabel
{
    //self.title=@"Confirm Profile";
    titleLabel=[[UILabel alloc]init];
    NSString *str=[confirmationprofileArray objectAtIndex:0];
     displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[confirmProfileSizeArray objectAtIndex:0]floatValue]]}];
    titleLabel.font=[UIFont fontWithName:RobotoRegular size:[[confirmProfileSizeArray objectAtIndex:0] floatValue]];
    titleLabel.text=str;
   // titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.frame=CGRectMake([[confirmProfilePosPXArray objectAtIndex:0]floatValue],[[confirmProfilePosPYArray objectAtIndex:0]floatValue],screenWidth-cellPaddingReg*2,screenHeight*.22);
  // [titleLabel sizeToFit];
    titleLabel.textColor=placeHolderReg;
    [scrollView addSubview:titleLabel];
    
   
    lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:screenWidth*.5 andYPos:.26*screenHeight withScrnWid:screenWidth-2*cellPaddingReg withScrnHt:.001*screenHeight ofColor:lineTextColor];
    [scrollView addSubview:lineView];
    
    
}
-(void)titleLabel
{
    
    titleLabel=[[UILabel alloc]init];
    NSString *str=[confirmationprofileArray objectAtIndex:1];
    
   
    [titleLabel setText:str];
    
    displayValueSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[confirmProfileSizeArray objectAtIndex:1]floatValue]]}];
    titleLabel.font=[UIFont fontWithName:RobotoRegular size:[[confirmProfileSizeArray objectAtIndex:1] floatValue]];
    titleLabel.text=str;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //titleLabel.numberOfLines = 0;
    titleLabel.frame=CGRectMake([[confirmProfilePosPXArray objectAtIndex:1]floatValue],[[confirmProfilePosPYArray objectAtIndex:1]floatValue],displayValueSize.width,displayValueSize.height);
    [titleLabel sizeToFit];
    titleLabel.textColor=placeHolderReg;
    [scrollView addSubview:titleLabel];

    
    
    
    titleLabel=[[UILabel alloc]init];
    
   str=[confirmationprofileArray objectAtIndex:3];
    titleLabel.textColor = placeHolderReg;
    
    titleLabel.font=[UIFont fontWithName:RobotoRegular size:[[confirmProfileSizeArray objectAtIndex:3] floatValue]];
    
    NSMutableAttributedString *yourString = [[NSMutableAttributedString alloc]initWithString:str];
    [yourString addAttribute:NSForegroundColorAttributeName value:textBlueColor range:NSMakeRange(13,18)];

    
    displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[confirmProfileSizeArray objectAtIndex:3]floatValue]]}];
   
    titleLabel.attributedText=yourString;
    titleLabel.frame=CGRectMake([[confirmProfilePosPXArray objectAtIndex:3]floatValue],[[confirmProfilePosPYArray objectAtIndex:3]floatValue],displayValueSize.width,displayValueSize.height);
    [titleLabel sizeToFit];
    
    UITapGestureRecognizer  *gestureRecognizer  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtTermsAndCondition:)];
    [titleLabel setUserInteractionEnabled:YES];
    [titleLabel addGestureRecognizer:gestureRecognizer];
    
    [scrollView addSubview:titleLabel];

    
}
-(void)touchAtTermsAndCondition:(id)sender
{
    NSLog(@"Terms and Conditions ");
    
    TermsAndConditions_VC *termsAndCondition_VC = [[TermsAndConditions_VC alloc]init];
    [self.navigationController pushViewController:termsAndCondition_VC animated:YES];
}

-(void) moreIcon
{
    
    UIImage* imageMore = [UIImage imageNamed:  isiPhoneiPad(@"Flower_pinwii.png") ];
    CGRect frameimg = CGRectMake(0, 0, imageMore.size.width, imageMore.size.height);
    UIButton *moreIcon = [[UIButton alloc] initWithFrame:frameimg];
    [moreIcon setBackgroundImage:imageMore forState:UIControlStateNormal];
    
    UIBarButtonItem *moreButton =[[UIBarButtonItem alloc] initWithCustomView:moreIcon];
    self.navigationItem.rightBarButtonItem=moreButton;
    
}


-(void) drawCenterIcon
{
//    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"Confirm_header.png") ]];
//    centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//    if(self.view.frame.size.width>700)
//    {
//        centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+20);
//    }
//    else
//    {
//        centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
//    }
//    
//    [self.navigationController.navigationBar addSubview:centerIcon];
    
}


-(void)setTextFields
{
    EnterCode=  [self setUptextField:EnterCode forString:[confirmationprofileArray objectAtIndex:2] withXpos:[[confirmProfilePosPXArray objectAtIndex:2]floatValue] withYpos:[[confirmProfilePosPYArray objectAtIndex:2]floatValue] withWidth:screenWidth-2*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:NO];
    EnterCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
   // EnterCode.textColor = pl;
}

-(UITextField*)setUptextField:(UITextField*)textField forString:(NSString*)str withXpos:(float)x withYpos:(float)y withWidth:(float)wd withHieght:(float)ht isSecuretext:(BOOL)secured
{
    textField=[[UITextField alloc]initWithFrame:CGRectMake(x,y,wd,ht)];
    textField.placeholder = str;
    [textField setValue:placeHolderReg forKeyPath:@"_placeholderLabel.textColor"];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setFont:[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor]];

    //textField.secureTextEntry=YES;
    //textField.borderStyle=UITextBorderStyleBezel;
   //textField.keyboardType=UIKeyboardTypeNumberPad;
    [scrollView addSubview:textField];
    textField.delegate=self;
    
    if(secured)
    {
        textField.secureTextEntry=secured;
    }
    lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:textField.center.x andYPos:textField.center.y+.02*screenHeight withScrnWid:textField.frame.size.width withScrnHt:.001*screenHeight ofColor:lineTextColor];
    [scrollView addSubview:lineView];
    return textField;
}

-(BOOL)becomeFirstResponder
{
    return YES;
}

-(BOOL)resignFirstResponder
{
    return YES;
}

-(void)resignOnTap1:(id)sender
{
    [EnterCode resignFirstResponder];
        
}


#pragma mark
#pragma mark Keyboard notifications

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.navigationItem.hidesBackButton = NO;
}

-(void)ResetToolBar:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = scrollView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    scrollView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField=textField;
    
    //    [DOB resignFirstResponder];
    //    [passcode resignFirstResponder];
    //  [autoLockTime resignFirstResponder];
    
    
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [EnterCode resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



-(void)addButton
{
    SubmitBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    
    [SubmitBtn setTitle:@"Submit" forState:UIControlStateNormal];
    SubmitBtn.tintColor=[[UIColor blackColor]colorWithAlphaComponent:0.8f];
    SubmitBtn.backgroundColor=buttonGreenColor;
    [SubmitBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    SubmitBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [SubmitBtn sizeToFit];
    SubmitBtn.frame=CGRectMake(cellPaddingReg, .8*screenHeight, screenWidth-2*cellPaddingReg, .07*screenHeight);
    SubmitBtn.center=CGPointMake(screenWidth*.5,screenHeight*.76);
    
    [SubmitBtn addTarget:self action:@selector(submitButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:SubmitBtn];
    //Yogesh
    [SubmitBtn setEnabled:NO];
   
    send=[UIButton buttonWithType:UIButtonTypeSystem];
    [send setTitle:@"Send" forState:UIControlStateNormal];
    [send setTitleColor:textBlueColor forState:UIControlStateNormal];
    send.tintColor=textBlueColor;
    send.backgroundColor=[UIColor clearColor];
    send.layer.borderColor = textBlueColor.CGColor;
    send.layer.borderWidth = 1.0;
    [send setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    send.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [send sizeToFit];
    send.frame=CGRectMake(cellPaddingReg, .8*screenHeight, screenWidth-2*cellPaddingReg, .06*screenHeight);
    send.center=CGPointMake(screenWidth*.5,screenHeight*.465);
    [send addTarget:self action:@selector(sendButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:send];
    
    [scrollView setContentSize:CGSizeMake(screenWidth,SubmitBtn.frame.size.height + SubmitBtn.frame.origin.y+5)];
    
    
   }
-(void)choosemode
{
    NSArray *itemArray = [NSArray arrayWithObjects: @"SMS", @"Email", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];//create an intialize our segmented control
    segmentedControl.frame = CGRectMake(cellPaddingReg, .68*screenHeight, screenWidth-2*cellPaddingReg, .06*screenHeight);//set the size and placement
    segmentedControl.center = CGPointMake(screenWidth/2, .37*screenHeight);
    segmentedControl.selectedSegmentIndex = 1;
    [segmentedControl setEnabled:NO forSegmentAtIndex:0];
    segmentedControl.backgroundColor=radiobuttonBgColor;
   // segmentedControl.tintColor = radiobuttonSelectionColor;
    //segmentedControl.segmentedControlStyle = UISegmentedControlSegmentLeft;
    
    [segmentedControl addTarget:self
                         action:@selector(whichColor:)
               forControlEvents:UIControlEventValueChanged];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,
                                placeHolderReg, NSForegroundColorAttributeName, nil];
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,
                                 [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [segmentedControl setTitleTextAttributes:attributes1  forState:UIControlStateSelected];
    
     [segmentedControl setContentPositionAdjustment:UIOffsetMake(-segmentedControl.frame.size.width/8, 0) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
    segmentedControl.backgroundColor= [[UIColor lightGrayColor]colorWithAlphaComponent:.5f];
    for (int i=0; i<[segmentedControl.subviews count]; i++)
    {
        if ([[segmentedControl.subviews objectAtIndex:i]isSelected] )
        {
            [[segmentedControl.subviews objectAtIndex:i] setTintColor:radiobuttonSelectionColor];
        }
        else
        {
            [[segmentedControl.subviews objectAtIndex:i] setTintColor:[UIColor clearColor]];
        }
    }
    

    
    [scrollView addSubview:segmentedControl];
}

- (void) whichColor:(UISegmentedControl *)paramSender{
    
    for (int i=0; i<[segmentedControl.subviews count]; i++)
    {
        if ([[segmentedControl.subviews objectAtIndex:i]isSelected] )
        {
            [[segmentedControl.subviews objectAtIndex:i] setTintColor:radiobuttonSelectionColor];
        }
        else
        {
            [[segmentedControl.subviews objectAtIndex:i] setTintColor:[UIColor clearColor]];
        }
    }
    
    //check if its the same control that triggered the change event
    if ([paramSender isEqual:segmentedControl]){
        
        //get index position for the selected control
        NSInteger selectedIndex = [paramSender selectedSegmentIndex];
        
        //get the Text for the segmented control that was selected
        NSString *myChoice =
        [paramSender titleForSegmentAtIndex:selectedIndex];
        //let log this info to the console
        //        NSLog(@"Segment at position %i with %@ text is selected",
        //              selectedIndex, myChoice);
    }
}

#pragma mark send and continue button
-(void)submitButtonTouch
{
    [EnterCode resignFirstResponder];
    if([checkbox isSelected]==YES && EnterCode.text.length!=0)
    {
        confirmationCodeCheck=YES;
        checkConfirmationCodeByParentID = [[CheckConfirmationCodeByParentID alloc] init];
        
        [checkConfirmationCodeByParentID initService:@{
                                                       @"ParentID"           : [PC_DataManager sharedManager].parentObjectInstance.parentId,
                                                       @"ConfirmationCode"   : EnterCode.text,
                                                       @"EmailAddress"       : [PC_DataManager sharedManager].parentObjectInstance.emailAdd,//childObj.gender,
                                                       }];
        [checkConfirmationCodeByParentID setDelegate:self];
        checkConfirmationCodeByParentID.serviceName=@"CheckConfirmationCodeByParentID";
        [self addLoaderView];

        
    }
    else if([checkbox isSelected]==NO && EnterCode.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Please enter verification code sent to you and accept Terms & Conditions." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([checkbox isSelected]==NO)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Please accept Terms & Conditions." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Please enter verification code sent to you." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}



-(void)sendButtonTouch
{
    if(resendOn==YES)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Are you sure you want the verification code sent again?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag=1;
        [alert show];
    }
    else{
    resendOn=YES;
    [send setTitle:@"Resend" forState:UIControlStateNormal];
    
    [self callServiceCode];
    }
    
   
    
}
-(void)callServiceCode
{
    EnterCode.text=@"";
    
    sendConfirmationCodeToMail =[[SendConfirmationCodeToMail alloc] init];
    sendConfirmationCodeToMail.sendConfirmationDelegate=self;
    [sendConfirmationCodeToMail initService:@{
                                              @"ParentID"       : [PC_DataManager sharedManager].parentObjectInstance.parentId,
                                              @"EmailAddress"   : [PC_DataManager sharedManager].parentObjectInstance.emailAdd,//childObj.gender,
                                              }];
    [sendConfirmationCodeToMail setDelegate:self];
    sendConfirmationCodeToMail.serviceName=@"SendConfirmationCodeToMail";
    [self addLoaderView];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1 && alertView.tag==1)
    {
        [self callServiceCode];
    }
}

#pragma mark overlay and delegate
-(void)continueTouched
{
    ChildProfileController *child=[[ChildProfileController alloc]init];
    [self.navigationController pushViewController:child animated:YES];
//    if([checkbox isSelected]==YES)
//    {
//        ChildProfileController *child=[[ChildProfileController alloc]init];
//        [self.navigationController pushViewController:child animated:YES];
//
//    }
//    else
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please accept the Terms and Services!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}



#pragma mark URL connection delegates

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"register: \n%@", dictionary);
    [self removeLoaderView];
    if(confirmationCodeCheck && [connection.serviceName isEqualToString:@"CheckConfirmationCodeByParentID"])
    {
        
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"CheckConfirmationCodeByParentIDResponse" resultKey:@"CheckConfirmationCodeByParentIDResult"];
        if(!dict)
        {
            return;
        }

        [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:@"Confirmed"];
        
        UIView *translucentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        translucentView.backgroundColor=[UIColor grayColor];
        translucentView.alpha=0.5;
        [self.view addSubview:translucentView];
        
        OverLayView *goAheadView=[[OverLayView alloc]initWithFrame:CGRectMake(0, screenHeight*.6, screenWidth, screenHeight*.4)withInfoText:@"Your profile has been confirmed. You may now continue setting it up." AndButtonText:@"Continue"withHEading:@"Congratulations!"];
                goAheadView.overLayDelegate=self;
       // goAheadView.tintColor=confirmcolorcode;
        [self.view addSubview:goAheadView];
        

    }
    else
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"SendConfirmationCodeToMailResponse" resultKey:@"SendConfirmationCodeToMailResult"];
        if(!dict)
        {
            return;
        }
        [SubmitBtn setEnabled:YES];

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"We just sent a verification code to your registered email ID." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)confirmationCode:(NSString *)code
{
    confirmationCode=code;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)checkBox
{
    [[PC_DataManager sharedManager]confirmProfile];
    checkbox = [[UIButton alloc] initWithFrame:CGRectMake([[checkboxPosPXArray objectAtIndex:1]floatValue], 0.635*screenHeight,screenWidth*.05,screenHeight*.03)];
    [checkbox setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"check-box.png")] forState:UIControlStateNormal];
    [checkbox setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"checked.png")] forState:UIControlStateSelected];
    
    [checkbox addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:checkbox];
}

-(void)checkboxSelected:(id)sender
{
    if([checkbox isSelected]==YES)
    {
        [checkbox setSelected:NO];
    }
    else
    {
        [checkbox setSelected:YES];
    }
}


-(void) drawradioLabel:(int)index
{
    
    UILabel *label=[[UILabel alloc]init];
    NSString *str=[radioLabelArray objectAtIndex:index];
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[radioLabelSize objectAtIndex:index]floatValue]]}];
    label.font=[UIFont fontWithName:RobotoRegular size:[[radioLabelSize objectAtIndex:index] floatValue]];
    label.text=str;
    label.frame=CGRectMake([[labelRadioPosPXArray objectAtIndex:index]floatValue],[[labelRadioPosPYArray objectAtIndex:index]floatValue],displayValueSize.width,displayValueSize.height);
    [label sizeToFit];
    label.textColor=[UIColor lightGrayColor];
    [scrollView addSubview:label];
    
}

#pragma mark KeyBoard Notification

-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, kbSize.height+64, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint point=activeField.frame.origin;
    //point.y+=64;
    if (!CGRectContainsPoint(aRect,point))
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}
-(void) keyboardWillHide:(NSNotification *)notification
{
     [self hideKeyBoard];
}
-(void)hideKeyBoard
{
    UIEdgeInsets contentInsets=UIEdgeInsetsMake(0, 0.0,0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    NSLog(@"Live=%f",self.view.frame.size.height/2.0f);
}



#pragma mark ADD / REMOVE LOADER
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
#pragma mark keyboardSpecificFunction
-(void)showAlertWithTitle:(NSString *)heading andMsg:(NSString*)msg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:heading message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
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
        [headerView drawHeaderViewWithTitle:@"Confirm Profile" isBackBtnReq:NO BackImage:@"leftArrow.png"];
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
    }
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
