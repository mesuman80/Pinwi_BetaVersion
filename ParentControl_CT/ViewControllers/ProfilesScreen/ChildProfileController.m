//
//  ChildProfileController.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 25/02/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ChildProfileController.h"
#import "AllyProfileController.h"
#import "SchoolTableViewController.h"
#import "CreateChildProfile.h"
#import "ShowActivityLoadingView.h"
#import "TimePicker.h"
#import "AutoLockPicker.h"
#import "HeaderView.h"
#import "TextAndToggle.h"

@interface ChildProfileController () <AddPassCodeDelegate,SchoolListDelegate,autolockProtocol,HeaderViewProtocol,ToggleProtocol,UIGestureRecognizerDelegate>
{
    NSMutableDictionary *childProfileDict;
    NSArray *itemArray ;
    NSMutableDictionary *autoDict;
    BOOL isDatePickerSetToDone;
    UIButton *cancelButton, *doneButton;
}

@end

@implementation ChildProfileController
{
    UILabel *titleLabel,*labelProfilePic;
    UITextField *profilePic, *firstName,*lastName,*nickName,*date,*nameOfSchool,*passcode,*autolock;
    
    
    UIButton *continueBtn;
    UIButton *addBtn;
    UIButton *arrowSchool;
    UIScrollView *scrollView;
    UIButton *calendarImg;
    
    BOOL isKeyBoard;
    BOOL isChildAdded;
    CGRect keyboardBounds;
    UIView *lineView;
    UIImageView *profileImg,*arrowDropDown,*navBgBar, *centerIcon;
    
    NSString *imgString;
    
    UISegmentedControl *segmentedControl;
    
    UIView *pickerView;
    UIDatePicker* picker;
    
    NSDate *eventDate;
    NSDateFormatter *dateFormat;
    
    ChildProfileEntity *childProfileEntity;
    ChildProfileObject *childObj;
    ChildProfileObject *childUpdateObj;
    
    CreateChildProfile *createChildProfile;
    ShowActivityLoadingView *loaderView;
    
    UITextField *activeField;
    
    NSString *schoolName;
    NSString *schoolId;
    NSString *autolocktimeId;
    NSMutableArray *autolockTimeArray;
    
    HeaderView *headerView;
    int yy;
    
    TextAndToggle * textAndToggleView;
    UILabel *picturelabel;
    
}


@synthesize radiobutton1 = __radiobutton1;
@synthesize radiobutton2 = __radiobutton2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:appBackgroundColor];
    
    ParentProfileEntity *parentProfileEntity = [[PC_DataManager sharedManager]getParentEntity];
    if(parentProfileEntity)
    {
        childProfileEntity = parentProfileEntity.childrenProfiles.array.lastObject;
        if(childProfileEntity.child_ID)
        {
            childProfileEntity=nil;
        }
        
    }
    
    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]childProfile];
    [self drawHeaderView];
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = appBackgroundColor;
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        //        scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
        // code for landscape orientation
    }
    else
    {
        scrollView.frame=CGRectMake(0,yy, screenWidth, screenHeight-yy);
        //        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    }
    [self.view addSubview:scrollView];
    
    
    
    
    [self setTitleLabel];
    [self setTextFields];
    [self imageAddition];
    [self addButton];
    [self choseGender];
    [self arrowDropDown];
    [self moreIcon];
    [self setCal];
    [self drawDatePicker];
    [self drawCenterIcon];
    [self drawToggleView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap1:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:singleTap];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"ChildOnceregistered"]isEqualToString:@"0"]||![[NSUserDefaults standardUserDefaults]objectForKey:@"ChildOnceregistered"])
    {
        [self showAlertWithTitle:@"Setting up Child Profiles" andMsg:@"Quickly set up profiles for your children in this section. This is important to ensure you get individual views and reports for each child."];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"ChildOnceregistered"];
    }
    
    [self fillData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    //self.navigationController.navigationBarHidden=NO;
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails] || [self.parentClassName isEqualToString:PinWiCreateNewChild])
    {
        self.navigationItem.hidesBackButton=NO;
        headerView.viewBack.alpha = 1.0f;
    }
    else
    {
        headerView.viewBack.alpha = 0.0f;
    }
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self addKeyBoardNotification];
    [passcode resignFirstResponder];
    [self drawCenterIcon];
    [passcode endEditing:YES];
    [self hideKeyBoard];
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails] || [self.parentClassName isEqualToString:PinWiCreateNewChild])
    {
        [continueBtn setTitle:@"Save" forState:UIControlStateNormal];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [passcode endEditing:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self hideKeyBoard];
    [centerIcon removeFromSuperview];
}



-(void)viewDidUnload
{
    [super viewDidUnload];
    [[PC_DataManager sharedManager].serviceDictionary removeAllObjects];
    
    
    [centerIcon removeFromSuperview];
    centerIcon = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)setTitleLabel
{
    // self.title=@"Child Profile Setup";
    
    
    titleLabel=[[UILabel alloc]init];
    NSString *str=[childprofileSetUpArray objectAtIndex:7];
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[childprofileSetUpSizeArray objectAtIndex:7]floatValue]]}];
    titleLabel.font=[UIFont fontWithName:RobotoLight size:[[childprofileSetUpSizeArray objectAtIndex:7] floatValue]];
    titleLabel.text=str;
    titleLabel.textColor=radiobuttonSelectionColor;
    [titleLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addChild)];
    [titleLabel addGestureRecognizer:tapGesture];
    
    titleLabel.frame=CGRectMake([[childprofileSetUpPosPXArray objectAtIndex:7]floatValue],[[childprofileSetUpPosPYArray objectAtIndex:7]floatValue],displayValueSize.width,displayValueSize.height);
    [titleLabel sizeToFit];
    if(![self.parentClassName isEqualToString:PinWiGetProfileDetails]&&![self.parentClassName isEqualToString:PinWiCreateNewChild])
    {
        [scrollView addSubview:titleLabel];
    }
}

-(void)imageAddition
{
    
    
    picturelabel=[[UILabel alloc]init];
    NSString *str=@"Add Picture";
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]}];
    picturelabel.font=[UIFont fontWithName:RobotoLight size:8*ScreenHeightFactor];
    picturelabel.text=str;
    picturelabel.frame=CGRectMake(0,0,displayValueSize.width+20,displayValueSize.height+5);
    picturelabel.textAlignment=NSTextAlignmentCenter;
    picturelabel.center=CGPointMake(.825*screenWidth+cellPaddingReg, .057*screenHeight);
    picturelabel.textColor=[UIColor blackColor];
    picturelabel.backgroundColor=[UIColor clearColor];
//    picturelabel.layer.cornerRadius=10;
//    picturelabel.clipsToBounds=YES;
    //[label sizeToFit];
    [scrollView addSubview:picturelabel];
    
    
    profileImg=[[UIImageView alloc]init];
    
    profileImg.frame=CGRectMake(0, 0,screenWidth*.15,screenWidth*.15);
    profileImg.center=CGPointMake(.825*screenWidth+cellPaddingReg, .057*screenHeight);
    [profileImg setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [profileImg addGestureRecognizer:singleTap];
    profileImg.layer.cornerRadius = profileImg.frame.size.width/2;
    profileImg.layer.borderWidth = 1.0f;
    profileImg.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImg.clipsToBounds = YES;
    profileImg.contentMode=UIViewContentModeScaleAspectFill;
    
    profileImg.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:.5f];
    
    [scrollView addSubview:profileImg];
}

-(void) drawCenterIcon
{
    
    //    if(!centerIcon)
    //    {
    //        centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"Child_header.png") ]];
    //        centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
    //        if(self.view.frame.size.width>700)
    //        {
    //             centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+20);
    //        }
    //        else
    //        {
    //             centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
    //        }
    //
    //        [self.navigationController.navigationBar addSubview:centerIcon];
    //    }
    //    else
    //    {
    //        [self.navigationController.navigationBar addSubview:centerIcon];
    //    }
    
    
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    [activeField resignFirstResponder];
    [self imageSelection];
}


-(void) arrowDropDown
{
    arrowSchool = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowSchool setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [arrowSchool setBackgroundImage:[UIImage imageNamed: isiPhoneiPad(@"arrow.png") ]  forState:UIControlStateNormal];
    arrowSchool.frame=CGRectMake(0, 0, .05*screenWidth, .05*screenWidth);
    arrowSchool.center =CGPointMake(screenWidth-arrowSchool.frame.size.width/2-cellPaddingReg, .47*screenHeight);
    
    [arrowSchool addTarget:self action:@selector(arrowTouchSchool) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:arrowSchool];
    
}
-(void) arrowTouchSchool
{
    SchoolTableViewController *school =[[SchoolTableViewController alloc]init];
    school.schoolListDelegate=self;
    [self.navigationController pushViewController:school animated:YES];
}
-(void)selectedSchool:(NSString *)schoolSelected andId:(NSString *)schoolIdSelected
{
    nameOfSchool.text=schoolSelected;
    schoolId=[NSString stringWithFormat:@"%@",schoolIdSelected];
    [[PC_DataManager sharedManager]writeParentObjToDisk];
}

-(void) moreIcon
{
    
    UIImage* imageMore = [UIImage imageNamed: isiPhoneiPad(@"Flower_pinwii.png") ];
    CGRect frameimg = CGRectMake(0, 0, imageMore.size.width, imageMore.size.height);
    UIButton *moreIcon = [[UIButton alloc] initWithFrame:frameimg];
    [moreIcon setBackgroundImage:imageMore forState:UIControlStateNormal];
    
    UIBarButtonItem *moreButton =[[UIBarButtonItem alloc] initWithCustomView:moreIcon];
    self.navigationItem.rightBarButtonItem=moreButton;
    
}



-(void) setCal
{
    calendarImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarImg setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [calendarImg setBackgroundImage:[UIImage imageNamed: isiPhoneiPad(@"calendar.png")]  forState:UIControlStateNormal];
    calendarImg.frame=CGRectMake(0, 0,25*ScreenWidthFactor, 25*ScreenWidthFactor);
    calendarImg.center =CGPointMake(screenWidth-calendarImg.frame.size.width/2-cellPaddingReg, .27*screenHeight);
    [calendarImg addTarget:self action:@selector(calImgTouchd) forControlEvents:UIControlEventTouchUpInside];
    //[calendarImg sizeToFit];
    [scrollView addSubview:calendarImg];
    
}

-(void)calImgTouchd
{
    [date becomeFirstResponder];
}

-(void)drawDatePicker
{
    
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(0, screenHeight*.6, screenWidth, screenHeight*.4)];
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
    [comps setYear:-15];
    [comps setMonth:[PC_DataManager sharedManager].returnMonthVlaue];
    [comps setDay:[PC_DataManager sharedManager].returnDayValue];
    
    
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:-3];
    [comps setMonth:[PC_DataManager sharedManager].returnMonthVlaue];
    [comps setDay:[PC_DataManager sharedManager].returnDayValue];
    
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
    
    
    picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(pickerView.frame.origin.x, pickerView.frame.size.height*.12, pickerView.frame.size.width, pickerView.frame.size.height);
    
    [picker setMaximumDate:maxDate];
    [picker setMinimumDate:minDate];
    [pickerView addSubview:picker];
    
    //DOB.inputView=pickerView;
    [date setInputView:pickerView];
    
}



-(void)datePickerCalShow
{
    [date becomeFirstResponder];
    //     [date resignFirstResponder];
    //    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
    //                     animations:^{
    //
    //                         pickerView.frame=CGRectMake(0, screenHeight/2, pickerView.frame.size.width, pickerView.frame.size.height);
    //
    //                     }
    //                     completion:^(BOOL finished){
    //
    //                     }];
    //
}

-(void)datePickerCalHideDone
{
    [date resignFirstResponder];
    //[autoLockTime resignFirstResponder];
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    if([activeField isEqual:date])
    {
        
        [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
        
        NSString *dateString = [dateFormat1 stringFromDate:eventDate];
        date.text = [NSString stringWithFormat:@"%@",dateString ];
  
    }
    
}
-(void)datePickerCalHideCancel
{
    [date resignFirstResponder];
    
}


//-(void)datePickerCalHide
//{
//     [date resignFirstResponder];
//    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//
//                         pickerView.frame=CGRectMake(0, screenHeight, screenWidth, screenHeight/2);
//                         //UIDatePicker *picker = (UIDatePicker*)DOB.inputView;
//                         [picker setMaximumDate:[NSDate date]];
//                         NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//                         eventDate = picker.date;
//                         [dateFormat setDateFormat:@"dd/MM/yyyy"];
//
//                         NSString *dateString = [dateFormat stringFromDate:eventDate];
//                         date.text = [NSString stringWithFormat:@"%@",dateString ];
//                     }
//                     completion:^(BOOL finished){
//
//                     }];
//
//}


-(void)setTextFields
{
    firstName= [self setUptextField:firstName forString:[childprofileSetUpArray objectAtIndex:0] withXpos:[[childprofileSetUpPosPXArray objectAtIndex:0]floatValue] withYpos:[[childprofileSetUpPosPYArray objectAtIndex:0]floatValue] withWidth:screenWidth*.43 withHieght:screenHeight*.05 isSecuretext:NO];
    [firstName setTag:0];
    
    lastName= [self setUptextField:lastName forString:[childprofileSetUpArray objectAtIndex:1] withXpos:[[childprofileSetUpPosPXArray objectAtIndex:1]floatValue] withYpos:[[childprofileSetUpPosPYArray objectAtIndex:1]floatValue] withWidth:screenWidth*.45 withHieght:screenHeight*.05 isSecuretext:NO];
    [lastName setTag:1];
    
    nickName= [self setUptextField:nickName forString:[childprofileSetUpArray objectAtIndex:2] withXpos:[[childprofileSetUpPosPXArray objectAtIndex:2]floatValue] withYpos:[[childprofileSetUpPosPYArray objectAtIndex:2]floatValue] withWidth:screenWidth-2*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:NO];
    [nickName setTag:2];
    
    date= [self setUptextField:date forString:[childprofileSetUpArray objectAtIndex:3] withXpos:[[childprofileSetUpPosPXArray objectAtIndex:3]floatValue] withYpos:[[childprofileSetUpPosPYArray objectAtIndex:3]floatValue] withWidth:screenWidth-2*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:NO];
    [date setTag:3];
    
//    UILongPressGestureRecognizer *gesture1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(celllongpressed:)];
//    [gesture1 setDelegate:self];
//    [gesture1 setMinimumPressDuration:1];
//    [date addGestureRecognizer:gesture1];
    
      for (UIGestureRecognizer *recognizer in date.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]){
                recognizer.enabled = NO;
        }
    }
    UILongPressGestureRecognizer *myLongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(celllongpressed:)];
    [date addGestureRecognizer:myLongPressRecognizer];

    
    
    nameOfSchool= [self setUptextField:nameOfSchool forString:[childprofileSetUpArray objectAtIndex:4] withXpos:[[childprofileSetUpPosPXArray objectAtIndex:4]floatValue] withYpos:[[childprofileSetUpPosPYArray objectAtIndex:4]floatValue] withWidth:screenWidth-2*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:NO];
    [nameOfSchool setTag:4];
    
    [nameOfSchool addTarget:self action:@selector(arrowTouchSchool) forControlEvents:UIControlEventEditingDidBegin];
    
    
    passcode= [self setUptextField:passcode forString:[childprofileSetUpArray objectAtIndex:5] withXpos:[[childprofileSetUpPosPXArray objectAtIndex:5]floatValue] withYpos:[[childprofileSetUpPosPYArray objectAtIndex:5]floatValue] withWidth:screenWidth*.43 withHieght:screenHeight*.05 isSecuretext:YES];
    [passcode addTarget:self action:@selector(addPswd) forControlEvents:UIControlEventEditingDidBegin];
    [passcode setTag:5];
    
    autolock= [self setUptextField:autolock forString:[childprofileSetUpArray objectAtIndex:6] withXpos:[[childprofileSetUpPosPXArray objectAtIndex:6]floatValue] withYpos:[[childprofileSetUpPosPYArray objectAtIndex:6]floatValue] withWidth:screenWidth*.45 withHieght:screenHeight*.05 isSecuretext:NO];
    [autolock setTag:6];
    
    AutoLockPicker *timePicker =[[AutoLockPicker alloc]initWithFrame:CGRectMake(0, screenHeight*.60f, screenWidth, screenHeight*.40f)];
    [timePicker setTextField:autolock];
    timePicker.autoDelegate=self;
    timePicker.autoDict=autoDict;
    [timePicker pickerView:@"Autolock"];
    [autolock setInputView:timePicker];
}

-(void)celllongpressed:(UIGestureRecognizer *)longPress
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
}

-(void)fillData
{
    
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails])
    {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"ChildOnceEdit"]isEqualToString:@"0"]||![[NSUserDefaults standardUserDefaults]objectForKey:@"ChildOnceEdit"])
        {
       // [self showAlertWithTitle:@"Notification" andMsg:@"You can not edit DOB and Gender of any child."];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"ChildOnceEdit"];
        }
        childUpdateObj=[[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:(int)self.childIndex];
        profileImg.image=[[PC_DataManager sharedManager]decodeImage:childUpdateObj.profile_pic];
        [autolock setText:childUpdateObj.autolock_Time];
        autolocktimeId=childUpdateObj.autolock_ID;
        textAndToggleView.toggleSwitch.on=YES;
        if([autolocktimeId isEqualToString:@"0"])
        {
            autolock.text=@"";
            autolocktimeId=@"0";
        }
        [passcode setText:childUpdateObj.passcode];
        if([passcode.text isEqualToString:@"0"])
        {
            [autolock setAlpha:0.5];
            [passcode setAlpha:0.5];
            textAndToggleView.toggleSwitch.on=NO;
            autolock.text=@"";
            passcode.text=@"";
        }
        [nameOfSchool setText:childUpdateObj.school_Name];
        schoolId=childUpdateObj.school_ID;
        [date setText:childUpdateObj.dob];
        [firstName setText:childUpdateObj.firstName];
        lastName.text=childUpdateObj.lastName;
        [nickName setText:childUpdateObj.nick_Name];
        if([childUpdateObj.gender isEqualToString:@"Girl"])
        {
            segmentedControl.selectedSegmentIndex=1;
        }
        else if ([childUpdateObj.gender isEqualToString:@"Boy"])
        {
            segmentedControl.selectedSegmentIndex=0;
        }
        [segmentedControl setUserInteractionEnabled:NO];
        [date setUserInteractionEnabled:NO];
        [date setTextColor:[UIColor lightGrayColor]];
        [[PC_DataManager sharedManager]resetSegmentColor:segmentedControl withTintColor:[UIColor lightGrayColor]];
        [continueBtn setTitle:@"Save" forState:UIControlStateNormal];
    }
    
    else if(childProfileEntity)
    {
        profileImg.image=[[PC_DataManager sharedManager]decodeImage:childProfileEntity.profile_pic];
        [autolock setText:childProfileEntity.autolock_Time];
        autolocktimeId=childProfileEntity.autolockID;
        if([autolocktimeId isEqualToString:@"0"])
        {
            autolock.text=@"";
            autolocktimeId=@"0";
        }
        [passcode setText:childProfileEntity.passcode];
        if([passcode.text isEqualToString:@"0"])
        {
            passcode.text=@"";
        }
        [nameOfSchool setText:childProfileEntity.school_Name];
        schoolId=childProfileEntity.school_ID;
        if([childProfileEntity.gender isEqualToString:@"Girl"])
        {
            segmentedControl.selectedSegmentIndex=1;
        }
        else if ([childProfileEntity.gender isEqualToString:@"Boy"])
        {
            segmentedControl.selectedSegmentIndex=0;
        }
        [date setText:childProfileEntity.dob];
        [firstName setText:childProfileEntity.firstName];
        lastName.text=childProfileEntity.lastName;
        [nickName setText:childProfileEntity.nick_Name];
    }
}

-(void)autoLock:(NSMutableDictionary *)autoDictData
{
    autoDict=autoDictData;
    autolocktimeId=[NSString stringWithFormat:@"%@",[autoDictData objectForKey:@"AutolockID"]];
    autolock.text=[NSString stringWithFormat:@"%@",[autoDictData objectForKey:@"TimeValue"]];
}



-(void)addPswd
{
    [self hideKeyBoard];
    NSString *childNo=kCAChildInfoUsernameKey;
    childNo=[childNo stringByAppendingString:[NSString stringWithFormat:@"%i",1]];
    
    AddPassCode *adpasscode=[[AddPassCode alloc]initwithEnablePswd:YES changePswd:NO deletePswd:NO key:childNo];
    adpasscode.passcodeDelegate=self;
    [self presentViewController:adpasscode animated:NO completion:nil];
}
-(void)passCodeSetUp:(NSString*)pscode
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"doesPswdExist"]boolValue])
    {
        passcode.secureTextEntry=YES;
        passcode.text=pscode;
        [passcode resignFirstResponder];
    }
}
-(void)cancelBtnTouched
{
    [passcode resignFirstResponder];
}


-(UITextField*)setUptextField:(UITextField*)textField1 forString:(NSString*)str withXpos:(float)x withYpos:(float)y withWidth:(float)wd withHieght:(float)ht isSecuretext:(BOOL)secured
{
    UITextField *textField=textField1;
    textField=[[UITextField alloc]initWithFrame:CGRectMake(x,y,wd,ht)];
    textField.placeholder = str;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setValue:placeHolderReg forKeyPath:@"_placeholderLabel.textColor"];
    [textField setFont:[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor]];
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

-(void)addButton
{
    addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    // [addBtn setTitle:@"Continue" forState:UIControlStateNormal];
    addBtn.tintColor=radiobuttonSelectionColor;
    [addBtn setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"addActivity.png")] forState:UIControlStateNormal];
    //addBtn.tintColor=[UIColor blueColor];
    [addBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    // addBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.03*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [addBtn sizeToFit];
    addBtn.frame=CGRectMake(cellPaddingReg, ScreenHeightFactor*63, ScreenHeightFactor*20, ScreenHeightFactor*20);
    addBtn.center=CGPointMake(addBtn.center.x,screenHeight*.68);
    [addBtn addTarget:self action:@selector(addChild) forControlEvents:UIControlEventTouchUpInside];
    
    if(![self.parentClassName isEqualToString:PinWiGetProfileDetails] && ![self.parentClassName isEqualToString:PinWiCreateNewChild])
    {
        [scrollView addSubview:addBtn];
    }
    
    continueBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [continueBtn setTitle:@"Continue" forState:UIControlStateNormal];
    continueBtn.tintColor=[[UIColor blackColor]colorWithAlphaComponent:0.8f];
    continueBtn.backgroundColor=buttonGreenColor;
    [continueBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    continueBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.023*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [continueBtn sizeToFit];
    continueBtn.frame=CGRectMake(cellPaddingReg, screenHeight*.7, screenWidth-cellPaddingReg*2, screenHeight*.07);
    continueBtn.center=CGPointMake(screenWidth*.5,screenHeight*.76);
    [continueBtn addTarget:self action:@selector(continueBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:continueBtn];
    
    
    
    
    scrollView.contentSize = CGSizeMake(screenWidth,continueBtn.frame.size.height+continueBtn.frame.origin.y+5);
    
    
}

-(void)choseGender
{
    itemArray = [NSArray arrayWithObjects: @"Boy", @"Girl", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];//create an intialize our segmented control
    segmentedControl.frame = CGRectMake(cellPaddingReg, .68*screenHeight, screenWidth-2*cellPaddingReg, .07*screenHeight);//set the size and placement
    segmentedControl.center = CGPointMake(screenWidth/2, screenHeight/2-1.7*segmentedControl.frame.size.height);
    if(childProfileEntity)
    {
        if([childProfileEntity.gender isEqualToString:@"Boy"])
        {
            segmentedControl.selectedSegmentIndex = 0;
        }
        else
        {
            segmentedControl.selectedSegmentIndex = 1;
        }
    }
    else{
        segmentedControl.selectedSegmentIndex = 0;
    }
    
    // segmentedControl.backgroundColor=radiobuttonBgColor;
    segmentedControl.backgroundColor= AddPictureColor;
    segmentedControl.tintColor = [UIColor clearColor];
    // segmentedControl.segmentedControlStyle = UISegmentedControlSegmentLeft;
    
    [segmentedControl addTarget:self
                         action:@selector(selectGender:)
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
    [scrollView addSubview:segmentedControl];
    
    [[PC_DataManager sharedManager]resetSegmentColor:segmentedControl withTintColor:radiobuttonSelectionColor];
    
}


- (void)selectGender:(UISegmentedControl *)paramSender{
    
    //check if its the same control that triggered the change event
    if ([paramSender isEqual:segmentedControl]){
        
        //get index position for the selected control
        NSInteger selectedIndex = [paramSender selectedSegmentIndex];
        
        //get the Text for the segmented control that was selected
        NSString *myChoice =
        [paramSender titleForSegmentAtIndex:selectedIndex];
        [[PC_DataManager sharedManager]resetSegmentColor:segmentedControl withTintColor:radiobuttonSelectionColor];
    }
}

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
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
}


-(void)pickImage
{
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    // imagePickerController=nil;
    UIImage *imagetaken = info[UIImagePickerControllerOriginalImage];
    profileImg.image=imagetaken;
    //  [self compressImage:image];
    
    
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

#pragma mark SCREENS
-(void)addChild
{
    UIImage *newImg;
    if(profileImg.image)
    {
        newImg= [[PC_DataManager sharedManager] imageWithImage:profileImg.image convertToSize:CGSizeMake(100,100)];
        // NSData *imageData = UIImageJPEGRepresentation(newImg, 0.7);
        
        imgString = [[PC_DataManager sharedManager]encodeImage:newImg];
    }
    isChildAdded=YES;
    if([self validateChildData])
    {
        [self saveChildInfo];
        //        profilePic.text=nil;
        //        firstName.text=nil;
        //        lastName.text=nil;
        //        nickName.text=nil;
        //        date.text=nil;
        //        passcode.text=nil;
        //        autolock.text=nil;
        //        nameOfSchool.text=nil;
        //        profileImg.image=[UIImage imageNamed:isiPhoneiPad(@"camera.png")];
    }
}

-(void)continueBtnTouch
{
    UIImage *newImg;
    if(profileImg.image)
    {
        newImg = [[PC_DataManager sharedManager] imageWithImage:profileImg.image convertToSize:CGSizeMake(50,50)];
        //  NSData *imageData = UIImageJPEGRepresentation(newImg, 0.7);
        
        imgString = [[PC_DataManager sharedManager]encodeImage:newImg];
    }
    
    if([self validateChildData])
    {
        [self saveChildInfo];
    }
    
}
-(void)saveChildInfo
{
    if(passcode.text.length==0)
    {
        passcode.text=@"0";
    }
    if(autolock.text.length==0 || !autolocktimeId)
    {
        autolock.text=@"0";
        autolocktimeId=@"0";
    }
    
    //ChildProfileObject *childObj=[[ChildProfileObject alloc] init];
    childObj=[[ChildProfileObject alloc] init];
    
    // childObj.child_ID=[NSNumber numberWithInt:1];
    childObj.parent_ID=[PC_DataManager sharedManager].parentObjectInstance.parentId;
    childObj.firstName=firstName.text;
    childObj.lastName=lastName.text;
    childObj.nick_Name=nickName.text;
    childObj.profile_pic=imgString;
    childObj.dob=date.text;
    
    if([[itemArray objectAtIndex:segmentedControl.selectedSegmentIndex]isEqualToString:@"Boy"])
    {
        childObj.gender=@"Boy";
    }
    else
    {
        childObj.gender=@"Girl";
    }
    childObj.school_Name=nameOfSchool.text;
    childObj.school_ID=schoolId;
    childObj.passcode=passcode.text;
    childObj.autolock_Time=autolock.text;//[NSString stringWithFormat:@"%@",[autoDict objectForKey:@"TimeValue"]];
    childObj.autolock_ID=autolocktimeId;//[NSString stringWithFormat:@"%@",[autoDict objectForKey:@"AutolockID"]];
    
    
     NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.parentId forKey:@"ParentID"];
    if(imgString && imgString.length!=0)
    { [dataDict setObject: childObj.profile_pic forKey:@"ProfileImage"]; }
    [dataDict setObject:childObj.firstName      forKey:@"FirstName"];
    [dataDict setObject:childObj.lastName       forKey:@"LastName"];
    [dataDict setObject:childObj.nick_Name      forKey:@"NickName"];
    [dataDict setObject:childObj.dob            forKey:@"DateOfBirth"];
    [dataDict setObject:childObj.gender         forKey:@"Gender"];
    [dataDict setObject:schoolId                forKey:@"SchoolName"];
    [dataDict setObject:childObj.passcode       forKey:@"Passcode"];
    [dataDict setObject:childObj.autolock_ID    forKey:@"AutolockTime"];
    
    
    //[PC_DataManager sharedManager].parentObjectInstance.parentId = @"2101";
    
    
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails])
    {
        childObj.child_ID=childUpdateObj.child_ID;
//        NSDictionary *dictionary = @{
//                                     @"ParentID"       : [PC_DataManager sharedManager].parentObjectInstance.parentId,
//                                     @"ChildID"        : childUpdateObj.child_ID,
//                                     @"ProfileImage"   : childObj.profile_pic,
//                                     @"FirstName"      : [NSString stringWithFormat:@"%@",childObj.firstName],
//                                     @"LastName"       : childObj.lastName,
//                                     @"NickName"       : childObj.nick_Name,
//                                     @"DateOfBirth"    : childObj.dob,
//                                     @"Gender"         : childObj.gender,
//                                     @"SchoolName"     : schoolId,//childObj.school_Name,
//                                     @"Passcode"       : childObj.passcode,
//                                     @"AutolockTime"   : childObj.autolock_ID,
//                                     };
        [dataDict setObject:childUpdateObj.child_ID    forKey:@"ChildID"];
        UpdateChildProfile *updateChildProfile = [[UpdateChildProfile alloc] init];
        [updateChildProfile initService:dataDict];
        updateChildProfile.serviceName=PinWiUpdateChild;
        [updateChildProfile setDelegate:self];
        
    }
    else
    {
//        NSDictionary *dictionary = @{
//                                     @"ParentID"       : [PC_DataManager sharedManager].parentObjectInstance.parentId,
//                                     @"ProfileImage"   : childObj.profile_pic,
//                                     @"FirstName"      : [NSString stringWithFormat:@"%@",childObj.firstName],
//                                     @"LastName"       : childObj.lastName,
//                                     @"NickName"       : childObj.nick_Name,
//                                     @"DateOfBirth"    : childObj.dob,
//                                     @"Gender"         : childObj.gender,
//                                     @"SchoolName"     : schoolId,//childObj.school_Name,
//                                     @"Passcode"       : childObj.passcode,
//                                     @"AutolockTime"   : childObj.autolock_ID,
//                                     };
        
        createChildProfile = [[CreateChildProfile alloc] init];
        [createChildProfile initService:dataDict];
        createChildProfile.serviceName=PinWiCreateChild;
        [createChildProfile setDelegate:self];
    }
    [self addLoaderView];
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    
    [self removeLoaderView];
}


-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:@"GetAutolockTime"])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetAutolockTimeResponse" resultKey:@"GetAutolockTimeResult"];
        
        if(!dict)
        {
            return;
        }
        
        
    }
    else if([connection.serviceName isEqualToString:PinWiCreateChild])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"CreateChildProfileResponse" resultKey:@"CreateChildProfileResult"];
        
        if(!dict)
        {
            return;
        }
        
        for (NSDictionary *childDict in dict)
        {
            // ChildProfileObject *childObj=[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.lastObject;
            
            childObj.child_ID= [NSString stringWithFormat:@"%@",[childDict objectForKey:@"ChildID"] ] ;
            [[PC_DataManager sharedManager].parentObjectInstance addNewChild:childObj];
            [[PC_DataManager sharedManager]writeParentObjToDisk];
            [[PC_DataManager sharedManager]retrieveDataAtLogin];
        }
        
        if(!isChildAdded)
        {
            if([self.parentClassName isEqualToString:PinWiCreateNewChild])
            {
//                if (self.isComingFromNetwork) {
                    [[PC_DataManager sharedManager].serviceDictionary removeAllObjects];
                    [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:PinWiGetChildren];
                    
                    [self.navigationController popViewControllerAnimated:YES];
//                }else{
//                [[PC_DataManager sharedManager].serviceDictionary removeAllObjects];
//                [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:PinWiGetChildren];
//                
//                AccessProfileViewController *access      = [[AccessProfileViewController alloc]init];
//                UINavigationController      *naviCtrl    = [[UINavigationController alloc]initWithRootViewController:access];
//                
//                AppDelegate                 *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//                [[appDelegate window]setRootViewController:naviCtrl];
//                
//                access      = nil;
//                naviCtrl    = nil;
//                appDelegate = nil;
//                }
            }
            else
            {
                [[NSUserDefaults standardUserDefaults]setValue:@"3" forKey:@"Confirmed"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                AllyProfileController *allyProfile=[[AllyProfileController alloc]init];
                self.navigationController.navigationItem.hidesBackButton=NO;
                [self.navigationController pushViewController:allyProfile animated:YES];
            }
        }
        
        else
        {
            isChildAdded=NO;
            profilePic.text=nil;
            firstName.text=nil;
            lastName.text=nil;
            nickName.text=nil;
            date.text=nil;
            passcode.text=nil;
            textAndToggleView.toggleSwitch.on=NO;
            autolock.text=nil;
            nameOfSchool.text=nil;
            schoolId=nil;
            picturelabel.alpha=1;
            profileImg.image=[UIImage imageNamed:isiPhoneiPad(@"")];
            
            [self showAlertWithTitle:@"Confirmation" andMsg:@"Woohoo! You succesfully added a new child profile"];
        }
    }
    
    else if([connection.serviceName isEqualToString:PinWiUpdateChild])
    {
        
        [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles replaceObjectAtIndex:(int)self.childIndex withObject:childObj];
        [[PC_DataManager sharedManager].serviceDictionary removeAllObjects];
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:PinWiGetChildren];
 //       AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
//        UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
//        [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(void)addPhoto
{
    ImageUpload *imgUpload=[[ImageUpload alloc]init];
    [imgUpload setDelegate:self];
    [self presentViewController:imgUpload animated:NO completion:nil];
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

-(void)resignOnTap1:(id)sender
{
    [profilePic resignFirstResponder];
    [firstName resignFirstResponder];
    [lastName resignFirstResponder];
    [nickName resignFirstResponder];
    [date resignFirstResponder];
    [passcode resignFirstResponder];
    [autolock resignFirstResponder];
    [nameOfSchool resignFirstResponder];
}


//#pragma mark
//#pragma mark Keyboard notifications
//
//- (void)keyboardWillShow:(NSNotification *)note
//{
//    isKeyBoard=YES;
//    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//
//    // Need to translate the bounds to account for rotation.
//    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
//
//    // get a rect for the textView frame
//    CGRect containerFrame = scrollView.frame;
//    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
//    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//
//    scrollView.frame = containerFrame;
//    [UIView commitAnimations];
//
//
//    CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//
//
//}
//
//- (void)keyboardWillHide:(NSNotification *)note
//{
//    isKeyBoard=NO;
//    [self ResetToolBar:note];
//
//}
//
//-(void)ResetToolBar:(NSNotification *)note
//{
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//
//    // get a rect for the textView frame
//    CGRect containerFrame = scrollView.frame;
//    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
//
//    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//
//    // set views with new info
//    scrollView.frame = containerFrame;
//
//    // commit animations
//    [UIView commitAnimations];
//
//}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [profilePic resignFirstResponder];
    [firstName resignFirstResponder];
    [lastName resignFirstResponder];
    [nickName resignFirstResponder];
    [date resignFirstResponder];
    [passcode resignFirstResponder];
    [autolock resignFirstResponder];
    [nameOfSchool resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) radioButton{
    
    //Checkboxes
    
    [self drawradioLabel:2];
    [self drawradioLabel:3];
    
    //radio buttons
    __radiobutton1 = [[UIButton alloc] initWithFrame:CGRectMake([[radioButtonPosPXArray objectAtIndex:2]floatValue], [[radioButtonPosPYArray objectAtIndex:2]floatValue],screenWidth*.09,screenHeight*.05)];
    [__radiobutton1 setTag:0];
    
    //[__radiobutton1 setTitle:@"Female" forState:UIControlStateSelected];
    [__radiobutton1 setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    [__radiobutton1 setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [__radiobutton1 addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    __radiobutton2 = [[UIButton alloc] initWithFrame:CGRectMake([[radioButtonPosPXArray objectAtIndex:3]floatValue], [[radioButtonPosPYArray objectAtIndex:3]floatValue],screenWidth*.09,screenHeight*.05)];
    [__radiobutton2 setTag:1];
    [__radiobutton2 setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    [__radiobutton2 setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [__radiobutton2 addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [scrollView addSubview:__radiobutton1];
    [scrollView addSubview:__radiobutton2];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)radiobuttonSelected:(id)sender{
    switch ([sender tag]) {
        case 0:
            if([__radiobutton1 isSelected]==YES)
            {
                [__radiobutton1 setSelected:NO];
                [__radiobutton2 setSelected:YES];
            }
            else{
                [__radiobutton1 setSelected:YES];
                [__radiobutton2 setSelected:NO];
            }
            
            break;
        case 1:
            if([__radiobutton2 isSelected]==YES)
            {
                [__radiobutton2 setSelected:NO];
                [__radiobutton1 setSelected:YES];
            }
            else
            {
                [__radiobutton2 setSelected:YES];
                [__radiobutton1 setSelected:NO];
            }
            
            break;
        default:
            break;
    }
    
}

-(void) drawradioLabel:(int)index
{
    
    UILabel *label=[[UILabel alloc]init];
    label.textColor=[UIColor lightGrayColor];
    NSString *str=[radioLabelArray objectAtIndex:index];
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[radioLabelSize objectAtIndex:index]floatValue]]}];
    label.font=[UIFont fontWithName:RobotoRegular size:[[radioLabelSize objectAtIndex:index] floatValue]];
    label.text=str;
    label.frame=CGRectMake([[labelRadioPosPXArray objectAtIndex:index]floatValue],[[labelRadioPosPYArray objectAtIndex:index]floatValue],displayValueSize.width,displayValueSize.height);
    [label sizeToFit];
    [scrollView addSubview:label];
    
}

#pragma mark Keyboard notifications

//- (void)keyboardWillShow:(NSNotification *)note
//{
//
//    scrollView.scrollEnabled=YES;
//    scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight/2);
//    NSDictionary* info = [note userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    [scrollView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
//}
//
//- (void)keyboardWillHide:(NSNotification *)note
//{
//    isKeyBoard=NO;
//    scrollView.scrollEnabled=YES;
//    scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
//    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    // [self ResetToolBar:note];
//
//}
#pragma mark KeyBoard Notification
-(void) keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0, kbSize.height+64, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint point=activeField.frame.origin;
    // point.y+=66;
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
-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:self];
    
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if(activeField.tag == 3)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
        }];
        return [super canPerformAction:action withSender:sender];
    }
    return NO;
}


#pragma mark VALIDATION
-(BOOL)validateChildData
{
    if(firstName.text.length==0 && nickName.text.length==0 && date.text.length==0 && nameOfSchool.text.length==0 && lastName.text.length==0 )
    {
        [self showAlertWithTitle:@"Incomplete Data" andMsg:@"Oops! You left a few important fields blank."];
         [nickName becomeFirstResponder];
    }
    else if (nickName.text.length ==0 || ![[PC_DataManager sharedManager]islegalCharacterWithoutNumbers:nickName.text])
    {
        [self showAlertWithTitle:@"Invalid Data" andMsg:@"Did you type the name right?\nNote: You cant use smileys or special characters."];
        [nickName becomeFirstResponder];
    }
    else if (firstName.text.length==0 || ![[PC_DataManager sharedManager]islegalCharacterWithoutNumbers:firstName.text])
    {
        [self showAlertWithTitle:@"Invalid Data" andMsg:@"Did you type the name right?\nNote: You cant use smileys or special characters."];
        [firstName becomeFirstResponder];
    }
    else if (lastName.text.length==0 || ![[PC_DataManager sharedManager]islegalCharacterWithoutNumbers:lastName.text])
    {
        [self showAlertWithTitle:@"Invalid Data" andMsg:@"Did you type the name right?\nNote: You cant use smileys or special characters."];
        [lastName becomeFirstResponder];
    }
    else if (date.text.length ==0)
    {
        [self showAlertWithTitle:@"Incomplete Data" andMsg:@"Please enter date of birth of the child before you proceed."];
        [date becomeFirstResponder];
    }
    
    else if (nameOfSchool.text.length ==0)
    {
        [self showAlertWithTitle:@"Incomplete Data" andMsg:@"Please enter the school before you proceed."];
        [nameOfSchool becomeFirstResponder];
    }
    else if (textAndToggleView.toggleSwitch.on && passcode.text.length!=4)
    {
        [self showAlertWithTitle:@"Alert" andMsg:@"Please enter a passcode before you proceed."];
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
        BOOL sameName=NO;
        if ([PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count>0)
        {
            for(ChildProfileObject *childObj1 in [PC_DataManager sharedManager].parentObjectInstance.childrenProfiles)
            {
                if(![self.parentClassName isEqualToString:PinWiGetProfileDetails] && ([childObj1.firstName isEqualToString:firstName.text] || [childObj1.nick_Name isEqualToString: nickName.text]) )
                {
                    sameName=YES;
                    break;
                }
            }
            if(sameName)
            {
                [self showAlertWithTitle:@"Profile Mix Up" andMsg:@"A child profile already exists with this name. Every child profile should have a unique name. "];
                return NO;
            }
        }
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
            [self saveChildInfo];
        }
    }
}

-(void)showAlertWithTitle:(NSString *)heading andMsg:(NSString*)msg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:heading message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
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


#pragma mark OTHER functionalities
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"Child_header.png"];
        if([self.parentClassName isEqualToString:PinWiGetProfileDetails] || [self.parentClassName isEqualToString:PinWiCreateNewChild])
        {
            [headerView drawHeaderViewWithTitle:@"Child Profile Setup" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        }
        else
        {
            [headerView drawHeaderViewWithTitle:@"Child Profile Setup" isBackBtnReq:NO BackImage:@"leftArrow.png"];
        }
        headerView.viewBack.alpha = 0.0f;
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


#pragma mark toggle
-(void)drawToggleView
{
    if(!textAndToggleView)
    {
        textAndToggleView=[[TextAndToggle alloc]initWithFrame:CGRectMake(0,nameOfSchool.frame.origin.y+nameOfSchool.frame.size.height+15*ScreenHeightFactor,screenWidth, ScreenHeightFactor*25)];
        [textAndToggleView setBackgroundColor:[UIColor clearColor]];
        [textAndToggleView drawUi:@"Passcode" textcolor:placeHolderReg font:[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor]];
        [scrollView addSubview:textAndToggleView];
        [textAndToggleView setToggleDelegate:self];
        
        if(!textAndToggleView.toggleSwitch.on)
        {
            [autolock setEnabled:NO];
            [passcode setEnabled:NO];
            
            [autolock setAlpha:0.5];
            [passcode setAlpha:0.5];
            
            autolock.text=@"";
            passcode.text=@"";
        }
        //[lineViewArray addObject:textAndToggleView];
    }
}

-(void)toggleButtonTouched:(BOOL)isToggleOn
{
    if(isToggleOn)
    {
        [autolock setEnabled:YES];
        [passcode setEnabled:YES];
        [autolock setAlpha:1.0];
        [passcode setAlpha:1.0];
    }
    else
    {
        [autolock setEnabled:NO];
        [passcode setEnabled:NO];
        [autolock setAlpha:0.5];
        [passcode setAlpha:0.5];
        autolock.text=@"";
        passcode.text=@"";
    }
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
