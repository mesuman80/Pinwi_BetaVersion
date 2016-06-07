 //
//  ProfileSetUpViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 2/25/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ProfileSetUpViewController.h"
#import "ProfileSetUp2.h"
#import "ConfirmationProfileViewController.h"
#import "ParentViewProfile.h"
#import "CancelDoneToolBar.h"
#import "TimePicker.h"
#import "AutoLockTimeViewController.h"
#import "CustomToolBar.h"
#import "OverLayView.h"
#import "AutoLockPicker.h"
#import "HeaderView.h"
#import "UpdateParentProfile.h"
#import "ShowActivityLoadingView.h"
#import "TextAndToggle.h"

@interface ProfileSetUpViewController ()<CustomToolBarDelegate,autolockProtocol,HeaderViewProtocol,UrlConnectionDelegate,ToggleProtocol,UIAlertViewDelegate>
{
    
    UITextField *FirstName;
    UITextField *LastName;
    UITextField *Email;
    UITextField *password;
    UITextField *DOB;
    UITextField *phone;
    UITextField *phonePrefix;
    UITextField *passcode;
    UITextField *autoLockTime;
    UIButton *continueButton;
    UIButton *addBtn;
    UILabel *titleLabel;
    UIScrollView *scrollView;
    
    UIView *lineView;
    UIImageView *profileImg,*moreIcon,*navBgBar, *centerIcon, *maleIcon,*femaleIcon;
    UIButton *calendarImg;
    NSMutableArray *labelobjectArray, *ttLabelobjectArray, *facebookFriendsArray,*lineViewArray;
    
    BOOL isKeyBoard;
    CGRect keyboardBounds;
    UISegmentedControl *segmentedControl;
    UISegmentedControl *segmentedControl1;
    NSArray *itemArray ;
    NSArray *itemArray1 ;
    
    UIButton *cancelButton, *doneButton;
    UIView *pickerView;
    UIDatePicker* picker;
    NSString *imgString;
    
    ParentProfileEntity *parentProfileEntity;
    
    BOOL isGaurdian;
    
    UITextField *activeField;
    CancelDoneToolBar *cancelDoneView;
    LogoutView *logout;
    NSMutableDictionary *autoDict;
    
    NSString *autolockID;
    
    ShowActivityLoadingView *loaderView;
    HeaderView *headerView ;
    int yy ;
    
    TextAndToggle *textAndToggleView;
    
    BOOL isPasscodeScreen;
    
}
@end

@implementation ProfileSetUpViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]profileLabel];
    [[PC_DataManager sharedManager]radioButton];
    
    isPasscodeScreen = NO;
    
    parentProfileEntity =[[PC_DataManager sharedManager]getParentEntity];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton  = YES;
    [self.view setBackgroundColor:appBackgroundColor];
    [self drawHeaderView];
    
    labelobjectArray=[[NSMutableArray alloc]init];
    ttLabelobjectArray=[[NSMutableArray alloc]init];
    lineViewArray=[[NSMutableArray alloc]init];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = appBackgroundColor;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setAutoresizesSubviews:YES];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    scrollView.frame=CGRectMake(0,yy, screenWidth,screenHeight-yy);
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight*1.1);

    [self.view addSubview:scrollView];
    [passcode resignFirstResponder];
    
    
    [self moreIcon];
    [self imageAddition];
    [self drawProfilePic];
    [self choseGender];
    [self addContinueButton];
    [self drawDatePicker];
    [self setCal];
    [self drawToggleView];
       
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:singleTap];

    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"SignUpfromFaceBook"]isEqualToString:@"1"]||[[[NSUserDefaults standardUserDefaults]objectForKey:@"SignUpinfromGoogle"]isEqualToString:@"1"])
    {
        profileImg.image=[[PC_DataManager sharedManager]decodeImage:[PC_DataManager sharedManager].parentObjectInstance.image];//[UIImage imageWithContentsOfFile:[PC_DataManager sharedManager].parentObjectInstance.image];
        FirstName.text=[PC_DataManager sharedManager].parentObjectInstance.firstName;
        LastName.text=[PC_DataManager sharedManager].parentObjectInstance.lastName;
        Email.text=[PC_DataManager sharedManager].parentObjectInstance.emailAdd;
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"SignUpfromFaceBook"];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"SignUpinfromGoogle"];
    }
    
    [self drawToolBar];
    
    NSLog(@"Value of bar height = %f",self.navigationController.navigationBar.frame.size.height);
   
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  //  [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [centerIcon removeFromSuperview];
    centerIcon=nil;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self addKeyBoardNotification];
    //  [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton = YES;
    //    if([self.parentClassName isEqualToString:PinWiGetProfileDetails])
    //    {
    //
    //    }
    //    else
    //    {
    //        self.navigationItem.hidesBackButton = YES;
    //    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    password.secureTextEntry=YES;
    //[scrollView setContentSize:CGSizeMake(screenWidth, screenHeight)];
    //scrollView.contentSize = CGSizeMake(scrnWid, continueButton.center.y+scrnHt*.2);
    [self drawCenterIcon];
    
    [self hideKeyBoard];
    
    
    if([passcode.text isEqualToString:@"0"])
    {
        passcode.text=@"";
    }
    if([autolockID isEqualToString:@"0"])
    {
        autoLockTime.text=@"";
        autolockID=@"0";
    }
    parentProfileEntity =[[PC_DataManager sharedManager]getParentEntity];
     [self fillDetails];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}



-(void) drawTitleLabel
{
    int i=0;
    for(NSString *str in labelProfileArray)
    {
        UILabel *label=[[UILabel alloc]init];
        CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[profileLabelSize objectAtIndex:i]floatValue]]}];
        label.font=[UIFont fontWithName:RobotoRegular size:[[profileLabelSize objectAtIndex:i] floatValue]];
        label.text=str;
        label.frame=CGRectMake([[labelProfilePosPxArray objectAtIndex:i]floatValue],[[labelProfilePosPyArray objectAtIndex:i]floatValue],displayValueSize.width,displayValueSize.height);
        label.textColor=[UIColor lightGrayColor];
        [label sizeToFit];
        [scrollView addSubview:label];
        i++;
        [labelobjectArray addObject:label];
    }
    
}

-(void)imageAddition
{
    //
    UILabel *label=[[UILabel alloc]init];
    NSString *str=@"Add Picture";
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]}];
    label.font=[UIFont fontWithName:RobotoLight size:8*ScreenHeightFactor];
    label.text=str;
    label.frame=CGRectMake(0,0,displayValueSize.width+20,displayValueSize.height+5);
    label.textAlignment=NSTextAlignmentCenter;
    [label sizeToFit];
    label.center=CGPointMake(.825*screenWidth+cellPaddingReg, .057*screenHeight);
    label.textColor=[UIColor blackColor];
    label.backgroundColor=[UIColor clearColor];
//    label.layer.cornerRadius=10;
//    label.clipsToBounds=YES;
    //[label sizeToFit];
   [scrollView addSubview:label];
    
    
    
    profileImg=[[UIImageView alloc]init];//WithImage:[UIImage imageNamed:  isiPhoneiPad(@"camera.png")]];
    profileImg.frame=CGRectMake(0, 0,screenWidth*.15,screenWidth*.15);
    profileImg.center=CGPointMake(.825*screenWidth+cellPaddingReg, .057*screenHeight);
    [profileImg setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [profileImg addGestureRecognizer:singleTap];
    if(!parentProfileEntity)
    {
        profileImg.image=[UIImage imageNamed:isiPhoneiPad(@"")];
        //profileImg.backgroundColor =AddPictureColor;
        // profileImg.frame=CGRectMake(0, 0,screenWidth*.,screenWidth*.07);
    }
    else
    {
      //  label.alpha=0;
        if(![[PC_DataManager sharedManager].parentObjectInstance.image isEqualToString:@"(null)"] && [PC_DataManager sharedManager].parentObjectInstance.image)
        {
        UIImage *newImg=[[PC_DataManager sharedManager]decodeImage:[PC_DataManager sharedManager].parentObjectInstance.image];
        profileImg.image=newImg;
        }
        else
        {
             profileImg.image=[UIImage imageNamed:isiPhoneiPad(@"")];
        }
        //[UIImage imageWithContentsOfFile:[PC_DataManager sharedManager].parentObjectInstance.image];
        //profileImg.frame=CGRectMake(0, 0,screenWidth*.2,screenWidth*.2);
    }
    profileImg.layer.cornerRadius = profileImg.frame.size.width/2;
    profileImg.clipsToBounds = YES;
    profileImg.contentMode=UIViewContentModeScaleAspectFill;
    profileImg.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:.5f];
    [scrollView addSubview:profileImg];
    
    
}
-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    [self resignOnTap:nil];
    [self imageSelection];
}


-(void) drawCenterIcon
{
//    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"profile_header.png") ]];
//    centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//    if(self.view.frame.size.width > 700)
//    {
//        centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+20);
//    }
//    else
//    {
//        centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
//    }
//    
//    [self.navigationController.navigationBar addSubview:centerIcon];
    // [self.navigationController.navigationBar sendSubviewToBack:centerIcon];
    
}

-(void) moreIcon
{
    UIImage* imageMore = [UIImage imageNamed: isiPhoneiPad( @"Flower_pinwii.png")];
    CGRect frameimg = CGRectMake(0, 0, imageMore.size.width, imageMore.size.height);
    UIButton *moreIcon1 = [[UIButton alloc] initWithFrame:frameimg];
    [moreIcon1 setBackgroundImage:imageMore forState:UIControlStateNormal];
    UIBarButtonItem *moreButton1 =[[UIBarButtonItem alloc] initWithCustomView:moreIcon];
    self.navigationItem.rightBarButtonItem=moreButton1;
    //[moreIcon resignFirstResponder];
}

-(void) setCal
{
    calendarImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarImg setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    calendarImg.frame=CGRectMake(0, 0, 25*ScreenWidthFactor,25*ScreenWidthFactor);
    calendarImg.center =CGPointMake(screenWidth-calendarImg.frame.size.width/2-cellPaddingReg, .32*screenHeight);
    [calendarImg setBackgroundImage:[UIImage imageNamed: isiPhoneiPad(@"calendar.png") ]  forState:UIControlStateNormal];
    [calendarImg addTarget:self action:@selector(calBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    // CGFloat spacing = 100; // the amount of spacing to appear between image and title
    // [calendarImg sizeToFit];
    [scrollView addSubview:calendarImg];
}

-(void)calBtnTouched
{
    [DOB becomeFirstResponder];
}

-(void)drawDatePicker
{
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(0, screenHeight*.6, screenWidth, screenHeight*.4)];
    //[scrollView addSubview:pickerView];
    pickerView.backgroundColor=[UIColor whiteColor];
    
    cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.tintColor=[UIColor darkGrayColor];
    cancelButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [cancelButton sizeToFit];
    cancelButton.frame=CGRectMake(0,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [cancelButton addTarget:self action:@selector(datePickerCalHideCancel) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:cancelButton];
    
    doneButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.tintColor=[UIColor darkGrayColor];
    doneButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    doneButton.frame=CGRectMake(pickerView.frame.size.width-cancelButton.frame.size.width,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [doneButton addTarget:self action:@selector(datePickerCalHideDone) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:doneButton];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-100];
    [comps setMonth:[PC_DataManager sharedManager].returnMonthVlaue];
    [comps setDay:[PC_DataManager sharedManager].returnDayValue];

    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:-18];
    [comps setMonth:[PC_DataManager sharedManager].returnMonthVlaue];
    [comps setDay:[PC_DataManager sharedManager].returnDayValue];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(pickerView.frame.origin.x, pickerView.frame.size.height*.12, pickerView.frame.size.width, pickerView.frame.size.height);
    
    [picker setMaximumDate:maxDate];
    //[picker setDate:[NSDate minDate]];

    [picker setMinimumDate:minDate];
    [picker reloadInputViews];
    [pickerView addSubview:picker];
    //DOB.inputView=pickerView;
    [DOB setInputView:pickerView];
    // [autoLockTime setInputView:pickerView];
    // [self datePickerCalShow];
    
    
}

-(void)removeDatePicker
{
    [pickerView removeFromSuperview];
    picker=nil;
    pickerView=nil;
    doneButton=nil;
    cancelButton=nil;
}

-(void)datePickerCalShow
{
    
    //  [self resignOnTap:nil];
    [scrollView endEditing:YES];
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         pickerView.frame=CGRectMake(0, screenHeight/2, pickerView.frame.size.width, pickerView.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    // [DOB resignFirstResponder];
}
-(void)datePickerCalHideDone
{
    [DOB resignFirstResponder];
    [autoLockTime resignFirstResponder];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    if([activeField isEqual:DOB])
    {
        
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
        NSString *dateString = [dateFormat stringFromDate:eventDate];
        DOB.text = [NSString stringWithFormat:@"%@",dateString ];
    }
    
    else if ([activeField isEqual:autoLockTime])
    {
        [dateFormat setDateFormat:@"hh:mm"];
        
        NSString *dateString = [dateFormat stringFromDate:eventDate];
        DOB.text = [NSString stringWithFormat:@"%@",dateString ];
        
        autoLockTime.text=[NSString stringWithFormat:@"%@",picker.date];
    }
}
-(void)datePickerCalHideCancel
{
    [DOB resignFirstResponder];
    [autoLockTime resignFirstResponder];
}

-(void)drawProfilePic
{
    FirstName = [self setUptextField:FirstName forString:[profileTextFieldArray objectAtIndex:0] withXpos:[[profileTextFieldPosPXArray objectAtIndex:0]floatValue] withYpos:[[profileTextFieldPosPYArray objectAtIndex:0]floatValue] withWidth:screenWidth*.43 withHieght:screenHeight*.05 isSecuretext:NO];
    
    LastName = [self setUptextField: LastName forString:[profileTextFieldArray objectAtIndex:1] withXpos:[[profileTextFieldPosPXArray objectAtIndex:1]floatValue] withYpos:[[profileTextFieldPosPYArray objectAtIndex:1]floatValue] withWidth:screenWidth*.45 withHieght:screenHeight*.05 isSecuretext:NO];
    
    Email=  [self setUptextField:Email  forString:[profileTextFieldArray objectAtIndex:2] withXpos:[[profileTextFieldPosPXArray objectAtIndex:2]floatValue] withYpos:[[profileTextFieldPosPYArray objectAtIndex:2]floatValue] withWidth:screenWidth-cellPaddingReg*2 withHieght:screenHeight*.05 isSecuretext:NO];
    Email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    Email.keyboardType=UIKeyboardTypeEmailAddress;
    
    password=  [self setUptextField:password  forString:[profileTextFieldArray objectAtIndex:3] withXpos:[[profileTextFieldPosPXArray objectAtIndex:3]floatValue] withYpos:[[profileTextFieldPosPYArray objectAtIndex:3]floatValue] withWidth:screenWidth-cellPaddingReg*2 withHieght:screenHeight*.05 isSecuretext:YES];

    DOB=  [self setUptextField:DOB forString:[profileTextFieldArray objectAtIndex:4] withXpos:[[profileTextFieldPosPXArray objectAtIndex:4]floatValue] withYpos:[[profileTextFieldPosPYArray objectAtIndex:4]floatValue] withWidth:screenWidth-cellPaddingReg*2 withHieght:screenHeight*.05 isSecuretext:NO];

    phonePrefix=  [self setUptextField:phone  forString:@"" withXpos:cellPaddingReg withYpos:[[profileTextFieldPosPYArray objectAtIndex:5]floatValue] withWidth:screenWidth*.1 withHieght:screenHeight*.05 isSecuretext:NO];
    phonePrefix.text=@"+91";
    phonePrefix.textAlignment=NSTextAlignmentCenter;
    [lineViewArray addObject:phonePrefix];
    [lineViewArray addObject:lineView];
    
    phone=  [self setUptextField:phone  forString:[profileTextFieldArray objectAtIndex:5] withXpos:phonePrefix.frame.size.width+2*cellPaddingReg withYpos:[[profileTextFieldPosPYArray objectAtIndex:5]floatValue] withWidth:screenWidth-(phonePrefix.frame.size.width+3*cellPaddingReg) withHieght:screenHeight*.05 isSecuretext:NO];
    
    
    CustomToolBar *toolBar = [[CustomToolBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.customDelgate = self;
    [toolBar setTextField:phone];
    [toolBar addToolBar];
    phone.inputAccessoryView = toolBar;
    
    [lineViewArray addObject:phone];
    [lineViewArray addObject:lineView];
    
    passcode=  [self setUptextField:passcode  forString:[profileTextFieldArray objectAtIndex:6] withXpos:[[profileTextFieldPosPXArray objectAtIndex:6]floatValue] withYpos:[[profileTextFieldPosPYArray objectAtIndex:6]floatValue] withWidth:screenWidth*.43 withHieght:screenHeight*.05 isSecuretext:NO];
    [passcode setSecureTextEntry:YES];
    [lineViewArray addObject:passcode];
    [lineViewArray addObject:lineView];
    [passcode addTarget:self action:@selector(addPswd) forControlEvents:UIControlEventEditingDidBegin];
    
    autoLockTime=  [self setUptextField:autoLockTime  forString:[profileTextFieldArray objectAtIndex:7] withXpos:[[profileTextFieldPosPXArray objectAtIndex:7]floatValue] withYpos:[[profileTextFieldPosPYArray objectAtIndex:7]floatValue] withWidth:screenWidth*.45 withHieght:screenHeight*.05 isSecuretext:NO];
    
    AutoLockPicker *timePicker =[[AutoLockPicker alloc]initWithFrame:CGRectMake(0, screenHeight*.6, screenWidth, screenHeight*.4)];
    [timePicker setTextField:autoLockTime];
    timePicker.autoDelegate=self;
    [timePicker pickerView:@"Autolock"];
    [autoLockTime setInputView:timePicker];
    [lineViewArray addObject:autoLockTime];
    [lineViewArray addObject:lineView];
    
}

-(void)fillDetails
{
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails] && !isPasscodeScreen)
    {
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"ParentOnceEdit"]isEqualToString:@"0"]||![[NSUserDefaults standardUserDefaults]objectForKey:@"ParentOnceEdit"])
        {
         //   [self showAlertWithTitle:@"Notification" andMsg:@"You can not edit Email address, DOB of parent and its Relationship with Child."];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"ParentOnceEdit"];
        }
        
        FirstName.text = [PC_DataManager sharedManager].parentObjectInstance.firstName;
        LastName.text=[[PC_DataManager sharedManager].parentObjectInstance lastName];
        phone.text = [PC_DataManager sharedManager].parentObjectInstance.contactNo;
        Email.text = [[PC_DataManager sharedManager].parentObjectInstance emailAdd];
        [Email setEnabled:NO];
        [Email setTextColor:[UIColor lightGrayColor]];
        
        DOB.text = [[PC_DataManager sharedManager].parentObjectInstance dob];
        [DOB setEnabled:NO];
         [DOB setTextColor:[UIColor lightGrayColor]];
        
        password.text = [[PC_DataManager sharedManager].parentObjectInstance passwd];
        
        textAndToggleView.toggleSwitch.on=[[[NSUserDefaults standardUserDefaults]objectForKey:@"doesPswdExist"]boolValue];
        [autoLockTime setEnabled:YES];
        [passcode setEnabled:YES];
        if(textAndToggleView.toggleSwitch.on)
        {
            autoLockTime.alpha = 1.0f;
            passcode.alpha = 1.0f;
            [autoLockTime setEnabled:YES];
            [passcode setEnabled:YES];
        }
        
        else
        {
            autoLockTime.alpha = 0.0f;
            passcode.alpha = 0.0f;
            
            [autoLockTime setEnabled:NO];
            [passcode setEnabled:NO];
        }
        
        passcode.text = [PC_DataManager sharedManager].parentObjectInstance.passcode;
        if([passcode.text isEqualToString:@"0"])
        {
            passcode.text=@"";
            textAndToggleView.toggleSwitch.on=NO;
            [autoLockTime setEnabled:NO];
            [passcode setEnabled:NO];
            [autoLockTime setAlpha:0.5];
            [passcode setAlpha:0.5];
            autoLockTime.text=@"";
            passcode.text=@"";
        }
        
        autoLockTime.text = [PC_DataManager sharedManager].parentObjectInstance.autoLockTime;
        autolockID=[PC_DataManager sharedManager].parentObjectInstance.autoLockID;
        
        if([autolockID isEqualToString:@"0"])
        {
            autoLockTime.text=@"";
            autolockID=@"0";
        }
        NSLog(@"[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex]: %@",[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex]);
        
        
        if([[[PC_DataManager sharedManager].parentObjectInstance relation] isEqualToString:@"Father"])
        {
            [segmentedControl setSelectedSegmentIndex:0];
            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
            [segmentedControl setEnabled:NO forSegmentAtIndex:2];
            
        }
        else if([[[PC_DataManager sharedManager].parentObjectInstance relation] isEqualToString:@"Mother"])
        {
            [segmentedControl setSelectedSegmentIndex:1];
            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
            [segmentedControl setEnabled:NO forSegmentAtIndex:2];
            
        }
        else if([[[PC_DataManager sharedManager].parentObjectInstance relation] isEqualToString:@"Guardian"])
        {
            [segmentedControl setSelectedSegmentIndex:2];
            [segmentedControl setEnabled:NO forSegmentAtIndex:1];
            [segmentedControl setEnabled:NO forSegmentAtIndex:0];
            
            [self showSegment];
            if([[[PC_DataManager sharedManager].parentObjectInstance gender] isEqualToString:@"Male"])
            {
                segmentedControl1.selectedSegmentIndex = 0;
                [segmentedControl1 setEnabled:NO forSegmentAtIndex:1];
            }
            else
            {
                segmentedControl1.selectedSegmentIndex = 1;
                [segmentedControl1 setEnabled:NO forSegmentAtIndex:0];
            }
            segmentedControl1.userInteractionEnabled=NO;
            [[PC_DataManager sharedManager]resetSegmentColor:segmentedControl1 withTintColor:[UIColor lightGrayColor]];
        }
        segmentedControl.userInteractionEnabled=NO;
        [[PC_DataManager sharedManager]resetSegmentColor:segmentedControl withTintColor:[UIColor lightGrayColor]];
        [continueButton setTitle:@"Save" forState:UIControlStateNormal];
    }
    
    else if(parentProfileEntity && !isPasscodeScreen)
    {
        FirstName.text = [parentProfileEntity firstName];
        LastName.text=[parentProfileEntity lastName];
        phone.text = parentProfileEntity.contactNo;
        Email.text = [parentProfileEntity emailAdd];
        DOB.text = [parentProfileEntity dob];
        password.text = [parentProfileEntity passwd];
        passcode.text = parentProfileEntity.passcode;
        textAndToggleView.toggleSwitch.on=YES;
        if([passcode.text isEqualToString:@"0"])
        {
            passcode.text=@"";
            textAndToggleView.toggleSwitch.on=NO;
            [autoLockTime setEnabled:NO];
            [passcode setEnabled:NO];
            [autoLockTime setAlpha:0.5];
            [passcode setAlpha:0.5];
            autoLockTime.text=@"";
            passcode.text=@"";
        }
        
        autoLockTime.text = parentProfileEntity.autoLockTime;
        autolockID=parentProfileEntity.autolockID;
        
        if([autoLockTime.text isEqualToString:@"0"])
        {
            autoLockTime.text=@"";
        }
        NSLog(@"[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex]: %@",[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex]);
        
        
        if([parentProfileEntity.relation isEqual:@"Father"])
        {
            segmentedControl.selectedSegmentIndex = 0;
        }
        else if ([parentProfileEntity.relation isEqual:@"Mother"])
        {
             segmentedControl.selectedSegmentIndex = 1;
        }
        else
        if([[parentProfileEntity relation] isEqualToString:@"Guardian"])
        {
            segmentedControl.selectedSegmentIndex = 2;
            [self showSegment];
            if([[parentProfileEntity gender] isEqualToString:@"Male"])
            {
                segmentedControl1.selectedSegmentIndex = 0;
            }
            else
            {
                segmentedControl1.selectedSegmentIndex = 1;
            }
            
        }
        
    }

}

-(void)autoLock:(NSMutableDictionary *)autoDictData
{
    autoDict=autoDictData;
    autolockID=[NSString stringWithFormat:@"%@",[autoDict objectForKey:@"AutolockID"]];
}
-(void)touchAtAutoLockTime:(id)sender
{
    AutoLockTimeViewController *autoLockViewController = [[AutoLockTimeViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:autoLockViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

-(void)addPswd
{
    isPasscodeScreen = YES;
    AddPassCode *adpasscode=[[AddPassCode alloc]initwithEnablePswd:YES changePswd:NO deletePswd:NO key:kCAUserInfoUsernameKey] ;
    adpasscode.passcodeDelegate=self;
    [self presentViewController:adpasscode animated:NO completion:nil];
    [self hideKeyBoard];
}

-(void)passCodeSetUp:(NSString*)pscode
{
//    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"doesPswdExist"]boolValue])
//    {
        passcode.secureTextEntry=YES;
        passcode.text=pscode;
        [passcode resignFirstResponder];
        [PC_DataManager sharedManager].parentObjectInstance.passcode=passcode.text;
//    }
}
-(void)cancelBtnTouched
{
    [passcode resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [passcode resignFirstResponder];
    [DOB resignFirstResponder];
    //    [autolock resignFirstResponder];
    //    [address resignFirstResponder];
    //    [neighbourAdd resignFirstResponder];
}
-(void)moveUp
{
    //UIView *view = nil;
    if(isGaurdian)
    {
        for(UIView *dummy in lineViewArray)
        {
                      [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 dummy.center=CGPointMake(dummy.center.x, dummy.center.y-.07*screenHeight);
                                 //dummy.alpha=0.0f;
                                 if([dummy isKindOfClass:[UISegmentedControl class]])
                                 {
                                     if(dummy.tag == 2)
                                     {
                                        // dummy.alpha=0.0f;
                                     }
                                 }
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
        isGaurdian=NO;
        scrollView.contentSize = CGSizeMake(screenWidth,screenHeight);
    }
    
    
}

-(void)moveDown
{
    if(!isGaurdian)
    {
        for(UIView *dummy in lineViewArray)
        {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 dummy.center=CGPointMake(dummy.center.x, dummy.center.y+.07*screenHeight);
                             }
                             completion:^(BOOL finished){
                                 NSLog(@"count: %lu", (unsigned long)lineViewArray.count);
                             }];
            //        CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
            //        [scrollView setContentOffset:bottomOffset animated:YES];
        }
        isGaurdian=YES;
        scrollView.contentSize = CGSizeMake(screenWidth,screenHeight+.1*screenHeight);
    }
    NSLog(@"count outside: %lu", (unsigned long)lineViewArray.count);
}


-(UITextField*)setUptextField:(UITextField*)textField1 forString:(NSString*)str withXpos:(float)x withYpos:(float)y withWidth:(float)wd withHieght:(float)ht isSecuretext:(BOOL)secured
{
    UITextField *textField=textField1;
    textField=[[UITextField alloc]initWithFrame:CGRectMake(x,y,wd,ht)];
    textField.placeholder = str;
    [textField setValue:placeHolderReg forKeyPath:@"_placeholderLabel.textColor"];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setFont:[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor]];
    
    [scrollView addSubview:textField];
    textField.delegate=self;
    
    if(secured)
    {
        textField.secureTextEntry=secured;
    }
    
    if([str isEqualToString:@"Phone"])
    {
        
        textField.keyboardType=UIKeyboardTypePhonePad;
    }
    
    lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:textField.center.x andYPos:textField.center.y+.02*screenHeight withScrnWid:textField.frame.size.width withScrnHt:.001*screenHeight ofColor:lineTextColor];
    [scrollView addSubview:lineView];
    
    
    
    return textField;
}



#pragma mark Segmented Controller
-(void)choseGender
{
    itemArray = [NSArray arrayWithObjects: @"Father", @"Mother",@"Guardian", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(cellPaddingReg, .68*screenHeight,screenWidth-2*cellPaddingReg, .060*screenHeight);//set the size and placement
    segmentedControl.center = CGPointMake(screenWidth/2,screenHeight*.43 - 10*ScreenHeightFactor);

    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.backgroundColor= [UIColor colorWithRed:225.0f/255 green:225.0f/255 blue:225.0f/255 alpha:1.0f];
    [segmentedControl addTarget:self
                         action:@selector(selectRelationShip:)
               forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:segmentedControl];
 
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,
                                placeHolderReg, NSForegroundColorAttributeName, nil];
   
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    
     [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
     [segmentedControl setTitleTextAttributes:attributes1  forState:UIControlStateSelected];
    
     [[PC_DataManager sharedManager] resetSegmentColor:segmentedControl withTintColor:radiobuttonSelectionColor];
}


-(void) guardianSelection
{
    itemArray1 = [NSArray arrayWithObjects: @"Male", @"Female" ,nil];
    segmentedControl1 = [[UISegmentedControl alloc] initWithItems:itemArray1];//create an intialize our segmented control
    segmentedControl1.frame = CGRectMake(cellPaddingReg, .68*screenHeight,screenWidth-2*cellPaddingReg, .060*screenHeight);//set the size and placement
    segmentedControl1.center = CGPointMake(screenWidth/2,screenHeight*.43);
    segmentedControl1.selectedSegmentIndex = 0;
    segmentedControl1.backgroundColor=radiobuttonBgColor;
    segmentedControl1.tag =2;
    [segmentedControl1 setContentPositionAdjustment:UIOffsetMake(-13, 0) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,
                                placeHolderReg, NSForegroundColorAttributeName, nil];
    
    [segmentedControl1 setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,
                                 [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
     [segmentedControl1 setTitleTextAttributes:attributes1 forState:UIControlStateSelected];
    
    [segmentedControl1 addTarget:self
                          action:@selector(guardianGender:)
                forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:segmentedControl1];
    [lineViewArray addObject:segmentedControl1];
    
    [[PC_DataManager sharedManager] resetSegmentColor:segmentedControl1 withTintColor:buttonGreenColor];
    
    
    maleIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:  isiPhoneiPad(@"male_h.png") ]];
    maleIcon.frame=CGRectMake(0, 0, maleIcon.image.size.width, maleIcon.image.size.height);
    maleIcon.center=CGPointMake(.13*screenWidth, .43*screenHeight);
    [scrollView addSubview:maleIcon];
    [lineViewArray addObject:maleIcon];
    
    femaleIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:    isiPhoneiPad(@"female.png")]];
    femaleIcon.frame=CGRectMake(0, 0, femaleIcon.image.size.width, femaleIcon.image.size.height);
    femaleIcon.center=CGPointMake(.57*screenWidth, .43*screenHeight);
    [scrollView addSubview:femaleIcon];
    [lineViewArray addObject:femaleIcon];
    // [lineViewArray addObject:segmentedControl];
    
    
}

- (void)selectRelationShip:(UISegmentedControl *)paramSender{
    
    //check if its the same control that triggered the change event
    if ([paramSender isEqual:segmentedControl])
    {
        
        //get index position for the selected control
        NSInteger selectedIndex = [paramSender selectedSegmentIndex];
        
        //get the Text for the segmented control that was selected
        NSString *myChoice =
        [paramSender titleForSegmentAtIndex:selectedIndex];
        [[PC_DataManager sharedManager] resetSegmentColor:segmentedControl withTintColor:radiobuttonSelectionColor];
        [self showSegment];
    }
}

- (void)guardianGender:(UISegmentedControl *)paramSender{
    
    //check if its the same control that triggered the change event
    if ([paramSender isEqual:segmentedControl1]){
        
        //get index position for the selected control
        NSInteger selectedIndexguardian = [paramSender selectedSegmentIndex];
        
        //get the Text for the segmented control that was selected
        NSString *myChoice =
        [paramSender titleForSegmentAtIndex:selectedIndexguardian];
      
        [self highlightedImage];
    }
}

-(void)showSegment
{
    if(segmentedControl.selectedSegmentIndex==2)
    {
        if(!segmentedControl1)
        {
            [self guardianSelection];
            [self moveDown];
            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+segmentedControl1.frame.size.height+20)];
        }
    }
    else if(isGaurdian)
    {
        [self moveUp];
        [self performSelector:@selector(removeGuardianGender) withObject:nil afterDelay:.05];
        isGaurdian=NO;
    }
}

-(void)removeGuardianGender
{
    [segmentedControl1 removeFromSuperview];
    [maleIcon removeFromSuperview];
    [femaleIcon removeFromSuperview];
    
    [lineViewArray removeLastObject];
    [lineViewArray removeLastObject];
    [lineViewArray removeLastObject];
    
    segmentedControl1=nil;
    maleIcon=nil;
    femaleIcon=nil;
    
}



-(void)highlightedImage
{
    [[PC_DataManager sharedManager]resetSegmentColor:segmentedControl1 withTintColor:buttonGreenColor];
    if(segmentedControl1.selectedSegmentIndex==0)
    {
        maleIcon.image=[UIImage imageNamed: isiPhoneiPad(@"male_h.png") ];
        femaleIcon.image=[UIImage imageNamed: isiPhoneiPad (@"female.png")];
    }
    else if(segmentedControl1.selectedSegmentIndex==1)
    {
        maleIcon.image=[UIImage imageNamed: isiPhoneiPad (@"male.png")];
        femaleIcon.image=[UIImage imageNamed:  isiPhoneiPad (@"female_h.png")];
    }
    
}
//===============================================================================================

#pragma mark Add profile picture
-(void)imageSelection
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take Photo",@"Camera Roll",nil];
    
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // NSLog(@"media state=%u",media.state);
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Take Photo"])
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self takePhotoOrVideo];
        }];
        
        
    }
    else if([buttonTitle isEqualToString:@"Camera Roll"])
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self pickImage];
        }];
        
    }
}

-(void)takePhotoOrVideo
{
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
        //imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:imagePicker animated:YES completion:nil];
        // }
    }
}


-(void)pickImage
{
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [imagePicker setDelegate:self];
    
    //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    [self presentViewController:imagePicker animated:YES completion:nil];
    //}
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *imagetaken = info[UIImagePickerControllerOriginalImage];
    profileImg.image=imagetaken;
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Go To Settings/Privacy/photos-allow to Save photo On Gallery"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //imagePickerController=nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark KEYBOARD delegates
-(BOOL)becomeFirstResponder
{
    return YES;
}

-(BOOL)resignFirstResponder
{
    return YES;
}

-(void)resignOnTap:(id)sender
{
    [FirstName resignFirstResponder];
    [LastName resignFirstResponder];
    [Email resignFirstResponder];
    [password resignFirstResponder];
    [phone resignFirstResponder];
    [phonePrefix resignFirstResponder];
    [autoLockTime resignFirstResponder];
    [DOB resignFirstResponder];
    [passcode resignFirstResponder];
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    //    [Name resignFirstResponder];
    //    [Email resignFirstResponder];
    //    [password resignFirstResponder];
    //    [phone resignFirstResponder];
    //    [phonePrefix resignFirstResponder];
    //    [autoLockTime resignFirstResponder];
    //    [passcode resignFirstResponder];
    //    [DOB resignFirstResponder];
    [textField resignFirstResponder];
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if([textField isEqual:DOB])
    {
        
        picker.datePickerMode=UIDatePickerModeDate;
    }
    
    if([textField isEqual:autoLockTime])
    {
        picker.datePickerMode=UIDatePickerModeCountDownTimer;
    }
    activeField=textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if (textField==phone)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:phoneAcceptableCharacter] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        
        if(phone.text.length >=10 && range.location>=10)
        {
            return NO;
            //[textField resignFirstResponder];
        }
        
        return [string isEqualToString:filtered];
        
    }
    return YES;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)addContinueButton
{
    
    continueButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    continueButton.tintColor=[UIColor blackColor];
    continueButton.backgroundColor=buttonGreenColor;
    [continueButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    continueButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.023*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [continueButton sizeToFit];
    continueButton.frame=CGRectMake(cellPaddingReg, .8*screenHeight, screenWidth-2*cellPaddingReg, .066*screenHeight);
    continueButton.center=CGPointMake(screenWidth*.5,screenHeight*.73);
    [continueButton addTarget:self action:@selector(continueBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:continueButton];
    [lineViewArray addObject:continueButton];
    
    scrollView.contentSize = CGSizeMake(screenWidth,continueButton.frame.size.height+continueButton.frame.origin.y+15);
    
}


-(void)continueBtnTouched
{
    //    ProfileSetUp2 *profile =[[ProfileSetUp2 alloc]init];
    //    [self.navigationController pushViewController:profile animated:YES];
//     [self performContinueAction];

    NSLog(@"PARENT PROFILE %@",[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles);
    NSLog(@"PARENT PROFILE %@",[PC_DataManager sharedManager].parentObjectInstance.firstName);
    
    NSLog(@"PARENT PROFILE %@",[PC_DataManager sharedManager].parentObjectInstance.lastName);
    UIImage *newImg;
    if(profileImg.image )
    {
        newImg= [[PC_DataManager sharedManager] imageWithImage:profileImg.image convertToSize:CGSizeMake(50,50)];
        
        //Encode
        imgString =  [[PC_DataManager sharedManager]encodeImage:newImg];
    }
     //[UIImagePNGRepresentation(newImg)
    
    if([self validateParentData])
    {
        [self performContinueAction];
    }
    // [self overlay];
}

-(void)performContinueAction
{
    if(parentProfileEntity)
    {
        
        ParentProfileObject *parent  =[[ParentProfileObject alloc]init];
        parent.firstName             =FirstName.text;
        parent.lastName              =LastName.text;
        parent.dob                   =DOB.text;
        parent.passwd                =password.text;
        parent.emailAdd              =Email.text;
        parent.contactNo             =phone.text;
        parent.autoLockTime          =autoLockTime.text;
        parent.autoLockID            =autolockID;
        parent.passcode              =passcode.text;
        parent.relation              =[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex];
        
        if([[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex] isEqualToString:@"Father"])
        {
            [PC_DataManager sharedManager].parentObjectInstance.gender=@"Male";
            parent.gender=@"Male";
        }
        else if([[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex]isEqualToString:@"Mother"])
        {
            [PC_DataManager sharedManager].parentObjectInstance.gender=@"Female";
            parent.gender=@"Female";
        }
        else
        {
            parent.gender=[itemArray1 objectAtIndex:segmentedControl1.selectedSegmentIndex];
        }
        parent.image=imgString;
        
        //           [[PC_DataManager sharedManager]writeParentObjToDisk];
        //           [[PC_DataManager sharedManager]retrieveDataAtLogin];
    }
    
    if(passcode.text.length==0)
    {
        passcode.text=@"0";
    }
    if(autoLockTime.text.length==0)
    {
        autoLockTime.text=@"0";
        autolockID=@"0";
    }
    //       if([[autoDict objectForKey:@"TimeValue"] isEqualToString:@""])
    //       {
    //            autoLockTime.text=@"0";
    //       }
    //Changes
    if([[PC_DataManager sharedManager].parentObjectInstance.deviceToken isEqualToString:@""] || [PC_DataManager sharedManager].parentObjectInstance.deviceToken==NULL)
    {
        [PC_DataManager sharedManager].parentObjectInstance.deviceToken=@"64356345r673r5vccvcb36";
    }
    //
    [PC_DataManager sharedManager].parentObjectInstance.firstName   =FirstName.text;
    [PC_DataManager sharedManager].parentObjectInstance.lastName    =LastName.text;
    
    [PC_DataManager sharedManager].parentObjectInstance.dob         =DOB.text;
    [PC_DataManager sharedManager].parentObjectInstance.passwd      =password.text;
    [PC_DataManager sharedManager].parentObjectInstance.emailAdd    =Email.text;
    [PC_DataManager sharedManager].parentObjectInstance.contactNo   =phone.text;
    [PC_DataManager sharedManager].parentObjectInstance.autoLockTime= autoLockTime.text; // [NSNumber numberWithInt:autoLockTime.text];
    [PC_DataManager sharedManager].parentObjectInstance.autoLockID  =autolockID;//[NSString stringWithFormat:@"%@",[autoDict objectForKey:@"AutolockID"]];
    [PC_DataManager sharedManager].parentObjectInstance.passcode    =passcode.text;// [NSNumber numberWithInt:passcode.text];
    [PC_DataManager sharedManager].parentObjectInstance.relation    =[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex];
    NSLog(@"Value of name  =%@",[PC_DataManager sharedManager].parentObjectInstance.firstName);
    if([[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex] isEqualToString:@"Father"])
    {
        [PC_DataManager sharedManager].parentObjectInstance.gender=@"Male";
    }
    else if([[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex]isEqualToString:@"Mother"])
    {
        [PC_DataManager sharedManager].parentObjectInstance.gender=@"Female";
    }
    else
    {
        [PC_DataManager sharedManager].parentObjectInstance.gender=[itemArray1 objectAtIndex:segmentedControl1.selectedSegmentIndex];
    }
    
    
    [PC_DataManager sharedManager].parentObjectInstance.image=imgString;
    
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails])
    {
        [self updateParentProfileDetails];
    }
    else
    {
        ProfileSetUp2 *profile =[[ProfileSetUp2 alloc]init];
        profile.parentClassName=self.parentClassName;
        [self.navigationController pushViewController:profile animated:YES];
    }

}

-(void)segmentAnimation
{
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         phone.frame=CGRectMake(pickerView.frame.origin.x, screenWidth/2, pickerView.frame.size.width, screenHeight/2);
                         
                         NSLog(@"AFTER ANIMATION");
                         NSLog(@"calc wid: %f,  ht: %f\n",screenWidth,screenHeight);
                         
                         NSLog(@"PICKER");
                         NSLog(@"origin: %f,  ht: %f",pickerView.frame.origin.x,pickerView.frame.origin.y);
                         NSLog(@"calc wid: %f,  ht: %f\n",pickerView.frame.size.width,pickerView.frame.size.height);
                         
                         NSLog(@"DONE BUTTON");
                         NSLog(@"calc wid: %f,  ht: %f",doneButton.frame.size.width,doneButton.frame.size.height);
                         NSLog(@"origin: %f,  ht: %f\n",doneButton.frame.origin.x,doneButton.frame.origin.y);
                         
                         NSLog(@"CANCEL BUTTON");
                         NSLog(@"origin: %f,  ht: %f",cancelButton.frame.origin.x,cancelButton.frame.origin.y);
                         NSLog(@"calc wid: %f,  ht: %f\n",cancelButton.frame.size.width,cancelButton.frame.size.height);
                         
                         NSLog(@"DATE PICKER");
                         NSLog(@"origin: %f,  ht: %f",picker.frame.origin.x,picker.frame.origin.y);
                         NSLog(@"calc wid: %f,  ht: %f\n",picker.frame.size.width,picker.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}





-(void)getFreindsList
{
    //NSArray *permissionsNeeded = @[@"public_profile", @"user_birthday",@"email"];
    
    [self showLoaderView:YES withText:@"Loading..."];
    [FBRequestConnection startWithGraphPath:@"/me/permissions" parameters:nil HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
     {
         if(!error)
         {
             if([result isKindOfClass:[NSDictionary class]])
             {
                 NSLog(@"dictionary Class=%@",result);
                 NSDictionary *dict=(NSDictionary *)result;
                 NSArray *array= [dict valueForKey:@"data"];
                 if(!facebookFriendsArray)
                 {
                     facebookFriendsArray =[[NSMutableArray alloc]init];
                 }
                 else
                 {
                     [facebookFriendsArray removeAllObjects];
                 }
                 for(NSDictionary *dictionary in array)
                 {
                     NSLog(@"%@",dictionary);
                     
                     FirstName.text=[dictionary valueForKey:@"firstName"];
                     LastName.text=[dictionary valueForKey:@"firstName"];
                     
                     
                     NSDictionary *pictureDictionary= [dictionary valueForKey:@"picture"];
                     NSDictionary *dataDictionary= [pictureDictionary valueForKey:@"data"];
                     //ns =[dataDictionary valueForKey:@"url"];
                     profileImg.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[dataDictionary valueForKey:@"url"]]];
                     //                     profileImg.frame=CGRectMake(0, 0,screenWidth*.2,screenWidth*.2);
                     //                      profileImg.center=CGPointMake(.8*screenWidth, .13*screenHeight);
                     Email.text = [dictionary valueForKey:@"email"];
                     NSLog(@"fullname:%@",FirstName.text);
                     NSLog(@"fullname:%@",LastName.text);
                     
                 }
             }
         }
         else
         {
             [self showLoaderView:NO withText:nil];
             [self showAlertWithTitle:@"Alert" andMsg:@""];
         }
     }];
    
}
//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
//                            user:(id<FBGraphUser>)user {
//    profileImg= [UIImage imageWithData:[NSData dataWithContentsOfURL:profileImg]];
//    Name.text= user.name;
//    //dateOfBirth.text=user.;
//}
//

-(void)showLoaderView:(BOOL)show withText:(NSString *)text
{
    static UILabel *label;
    static UIActivityIndicatorView *activity;
    static UIView *loaderView1;
    
    if(show)
    {
        
        loaderView1=[[UIView alloc] initWithFrame:self.view.bounds];
        [loaderView1 setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.4]];
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(0, (loaderView1.bounds.size.height/2)-10, loaderView1.bounds.size.width, 20)];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [label setText:text];
        [label setTextAlignment:NSTextAlignmentCenter];
        [loaderView1 addSubview:label];
        
        activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activity.center=CGPointMake(label.center.x, label.frame.origin.y+label.frame.size.height+10+activity.frame.size.height/2);
        
        [activity startAnimating];
        [loaderView1 addSubview:activity];
        [self.view addSubview:loaderView1];
    }else
    {
        
        [label removeFromSuperview];
        [activity removeFromSuperview];
        [loaderView1 removeFromSuperview];
        label=nil;
        activity=nil;
        loaderView1=nil;
    }
}



#pragma mark functions
-(void)addPhoto
{
    //    ImageUpload *imgUpload=[[ImageUpload alloc]init];
    //    [imgUpload setDelegate:self];
    //    [self presentViewController:imgUpload animated:NO completion:nil];
}

-(BOOL)validateParentData
{
    [FirstName resignFirstResponder];
    [LastName resignFirstResponder];
    [password resignFirstResponder];
    [Email resignFirstResponder];
    [DOB resignFirstResponder];
    [phone resignFirstResponder];
    [autoLockTime resignFirstResponder];
    [scrollView setContentSize:CGSizeMake(screenWidth, screenHeight)];
    
    
    if(FirstName.text.length==0 && LastName.text.length==0 && password.text.length==0 && Email.text.length==0&& DOB.text.length==0 &&phone.text.length==0 )
    {
        [self showAlertWithTitle:@"Incomplete Data" andMsg:@"Oops! You left a few important fields blank."];
    }
    else if (FirstName.text.length ==0 || ![[PC_DataManager sharedManager]islegalCharacterWithoutNumbers:FirstName.text])
    {
        [self showAlertWithTitle:@"Invalid Data" andMsg:@"Did you type the name right?\nNote: You cant use smileys or special characters."];
        [FirstName becomeFirstResponder];
    }
    
    else if (LastName.text.length ==0 || ![[PC_DataManager sharedManager]islegalCharacterWithoutNumbers:LastName.text])
    {
        [self showAlertWithTitle:@"Invalid Data" andMsg:@"Did you type the name right?\nNote: You cant use smileys or special characters."];
        [LastName becomeFirstResponder];
    }
    
    else if (Email.text.length==0 || ![[PC_DataManager sharedManager]isIllegalCharacter:Email.text])
    {
        [self showAlertWithTitle:@"Invalid Email ID" andMsg:@"Your email ID may not be correct. Please check."];
        [Email becomeFirstResponder];
    }
    
    else if (Email.text.length==0 || ![[PC_DataManager sharedManager]NSStringIsValidEmail:Email.text])
    {
        [self showAlertWithTitle:@"Invalid Email ID" andMsg:@"Your email ID may not be correct. Please check."];
    }
    
    else if (password.text.length==0)
    {
        [self showAlertWithTitle:@"Incomplete Data" andMsg:@"Please enter a password before you proceed."];
        [password becomeFirstResponder];
    }
    
    else if (DOB.text.length==0 )
    {
        [self showAlertWithTitle:@"Incomplete Data" andMsg:@"Please enter date of birth before you proceed."];
        [DOB becomeFirstResponder];
    }
    
    else if (phone.text.length ==0 || phone.text.length!=10)
    {
        [self showAlertWithTitle:@"Incorrect Number" andMsg:@"Your phone number should have 10 digits. Please check."];
        [phone becomeFirstResponder];
    }
    else if (textAndToggleView.toggleSwitch.on && (passcode.text.length!=4 || autoLockTime.text.length <= 0))
    {
        if(passcode.text.length!=4)
        {
            [self showAlertWithTitle:@"Alert" andMsg:@"Please enter a passcode before you proceed."];
        }
        
        
        else if(autoLockTime.text.length <= 0)
        {
            [self showAlertWithTitle:@"Alert" andMsg:@"Please enter auto lock time before you proceed."];
        }
        
    }
    else if (!textAndToggleView.toggleSwitch.on)
    {
        UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Passcodes come in handy when you want to secure access to different profiles within the app. Are you sure you don't want to set them up?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", nil];
        alert1.tag=1;
        [alert1 show];
    }
    
//    else if (imgString==nil)
//    {
//        [self showAlertWithTitle:@"Add Picture" andMsg:@"Please upload the picture"];
//    }
    else
    {
        return YES;
    }
    return NO;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if(alertView.tag==1)
   {
       if(buttonIndex==1)
       {
           [self performContinueAction];
       }
   }
}



-(void)showAlertWithTitle:(NSString *)heading andMsg:(NSString*)msg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:heading message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark KeyBoard Notification
-(void) keyboardWillShow:(NSNotification *)notification
{
    
    //    NSLog(@"ScreenWidth = %f",screenWidth);
    //
    //    NSDictionary* info = [notification userInfo];
    //    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0, kbSize.height, 0.0);
    //    scrollView.contentInset = contentInsets;
    //    scrollView.scrollIndicatorInsets = contentInsets;
    //    CGRect aRect = self.view.frame;
    //    aRect.size.height -= kbSize.height;
    //   // CGPoint point=activeField.frame.origin;
    //    //point.y+=66;
    //    if (!CGRectContainsPoint(aRect,activeField.frame.origin))
    //    {
    //
    //        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
    //        // scrollPoint.y+=64;
    //        [scrollView setContentOffset:scrollPoint animated:YES];
    //        //CGPointMake
    //        //[scrollView setContentSize:CGSizeMake(screenWidth,scrollView.contentSize.height+64)];
    //    }
    //
    //   if([phone isFirstResponder])
    //   {
    //       [self drawToolBar];
    //   }
    
    
    
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
//-(void) keyboardWillHide:(NSNotification *)notification
//{
//    UIEdgeInsets contentInsets=UIEdgeInsetsMake(0, 0.0,0.0, 0.0);
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
//    NSLog(@"Live=%f",self.view.frame.size.height/2.0f);
//   //[scrollView setContentSize:CGSizeMake(screenWidth, screenHeight)];
//}

-(void)drawToolBar
{
    cancelDoneView=[[CancelDoneToolBar alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight*.2) andTextField:phone];
    [self.view addSubview:cancelDoneView];
}
#pragma mark customToolBarDelegate
-(void)touchAtCancelButton:(CustomToolBar *)cancelDoneToolBar
{
    
}
-(void)touchAtDoneButton:(CustomToolBar *)cancelDoneToolBar
{
    
}
/*
 -(void)overlay
 {
 UIView *translucentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
 translucentView.backgroundColor=[UIColor grayColor];
 translucentView.alpha=0.5;
 [self.view addSubview:translucentView];
 
 OverLayView *goAheadView=[[OverLayView alloc]initWithFrame:CGRectMake(0, screenHeight*.6, screenWidth, screenHeight*.4)withInfoText:@"Congratulations! Your profile is verified. Now, please create profiles for your child/children to complete the Sign up process." AndButtonText:@"CONTINUE"];
 // goAheadView.overLayDelegate=self;
 // goAheadView.tintColor=confirmcolorcode;
 [self.view addSubview:goAheadView];
 
 }
 */
/*
 - (void)keyboardWillShow:(NSNotification *)note
 {
 
 scrollView.scrollEnabled=YES;
 scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight/2);
 NSDictionary* info = [note userInfo];
 CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
 [scrollView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
 }
 
 - (void)keyboardWillHide:(NSNotification *)note
 {
 isKeyBoard=NO;
 scrollView.scrollEnabled=YES;
 scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
 [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
 // [self ResetToolBar:note];
 
 }
 */
/*
 
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 */

#pragma  mark HeaderViewSpecific Functions
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"profile_header.png"];
        [headerView drawHeaderViewWithTitle:@"Parent Profile Setup" isBackBtnReq:YES BackImage:@"leftArrow.png"];
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
    
}

#pragma mark update parent profile
-(void)updateParentProfileDetails
{
    NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]init];
    NSLog(@"[PC_DataManager sharedManager].parentObjectInstance = %@",[PC_DataManager sharedManager].parentObjectInstance);
    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.parentId        forKey:@"ParentID"];
    
    if(![[PC_DataManager sharedManager].parentObjectInstance.image isEqualToString:@"(null)"] && [PC_DataManager sharedManager].parentObjectInstance.image)
    {
        [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.image         forKey:@"ProfileImage"];
    }

    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.firstName       forKey:@"FirstName"];
    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.lastName        forKey:@"LastName"];
    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.emailAdd        forKey:@"EmailAddress"];
    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.passwd          forKey:@"Password"];
    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.relation        forKey:@"Relation"];
    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.contactNo       forKey:@"Contact"];
    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.passcode        forKey:@"Passcode"];
    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.autoLockID      forKey:@"AutolockTime"];
    
    
    
    UpdateParentProfile *createParentProfile = [[UpdateParentProfile alloc] init];
//    [createParentProfile initService:@{
//                                       @"ParentID"          :[PC_DataManager sharedManager].parentObjectInstance.parentId,
//                                       @"ProfileImage"      :[PC_DataManager sharedManager].parentObjectInstance.image,
//                                       @"FirstName"         :[PC_DataManager sharedManager].parentObjectInstance.firstName,
//                                       @"LastName"          :[PC_DataManager sharedManager].parentObjectInstance.lastName,
//                                       @"EmailAddress"      :[PC_DataManager sharedManager].parentObjectInstance.emailAdd,
//                                       @"Password"          :[PC_DataManager sharedManager].parentObjectInstance.passwd,
//                                       @"Contact"           :[PC_DataManager sharedManager].parentObjectInstance.contactNo,
//                                       @"Passcode"          :[PC_DataManager sharedManager].parentObjectInstance.passcode,
//                                       @"Relation"          :[PC_DataManager sharedManager].parentObjectInstance.relation,
//                                       @"AutolockTime"      :[PC_DataManager sharedManager].parentObjectInstance.autoLockID,
//                                       }];
    [createParentProfile initService:dataDict];
    [createParentProfile setDelegate:self];
    [createParentProfile setServiceName:PinWiUpdateParent];
    [self addLoaderView];
}


-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"register: \n%@", dictionary);
    [self removeLoaderView];
    if ([connection.serviceName isEqualToString:PinWiUpdateParent])
    {
        [LTHKeychainUtils storeUsername:kCAUserInfoUsernameKey
                            andPassword:[PC_DataManager sharedManager].parentObjectInstance.passcode
                         forServiceName:@"PCApp"
                         updateExisting:YES
                                  error:nil];
        [[NSUserDefaults standardUserDefaults]setObject:[PC_DataManager sharedManager].parentObjectInstance.passcode forKey:@"LocalPassword"];
        
        [[NSUserDefaults standardUserDefaults]setBool:textAndToggleView.toggleSwitch.on forKey:@"doesPswdExist"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[PC_DataManager sharedManager]writeParentObjToDisk];
        [[PC_DataManager sharedManager]retrieveDataAtLogin];
        
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:@"GetNamesByParentID"];
        [self.navigationController popViewControllerAnimated:YES];
        
        NSLog(@"[PC_DataManager sharedManager].parentObjectInstance = %@",[PC_DataManager sharedManager].parentObjectInstance);

    }
    
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

#pragma mark toggle
-(void)drawToggleView
{
    if(!textAndToggleView)
    {
        textAndToggleView=[[TextAndToggle alloc]initWithFrame:CGRectMake(0,phone.frame.origin.y+phone.frame.size.height+5*ScreenHeightFactor,screenWidth, ScreenHeightFactor*25)];
        [textAndToggleView setBackgroundColor:[UIColor clearColor]];
        [textAndToggleView drawUi:@"Passcode" textcolor:placeHolderReg font:[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor]];
        [scrollView addSubview:textAndToggleView];
        [textAndToggleView setToggleDelegate:self];
        [lineViewArray addObject:textAndToggleView];
        
        
        if(!textAndToggleView.toggleSwitch.on)
        {
            [autoLockTime setEnabled:NO];
            [passcode setEnabled:NO];
            
            [autoLockTime setAlpha:0.0];
            [passcode setAlpha:0.0];
            
            autoLockTime.text=@"";
            passcode.text=@"";
        }
    }
}

-(void)toggleButtonTouched:(BOOL)isToggleOn
{
    if(isToggleOn)
    {
        [autoLockTime setEnabled:YES];
        [passcode setEnabled:YES];
        [autoLockTime setAlpha:1.0];
        [passcode setAlpha:1.0];
    }
    else
    {
        [autoLockTime setEnabled:NO];
        [passcode setEnabled:NO];
        [autoLockTime setAlpha:0.0];
        [passcode setAlpha:0.0];
        autoLockTime.text=@"";
        passcode.text=@"";
        
    }
}

@end
