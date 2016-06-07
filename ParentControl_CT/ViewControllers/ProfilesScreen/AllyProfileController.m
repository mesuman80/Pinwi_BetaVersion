//
//  AllyProfileController.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 04/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AllyProfileController.h"
#import "ConfirmationProfileViewController.h"
#import "AllyRelationTableViewController.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"

@interface AllyProfileController () <AllyListDelegate,HeaderViewProtocol>

@end

@implementation AllyProfileController
{
    UILabel *titleLabel,*labelProfilePic;
    UITextField *firstName,*lastName,*relationship,*email_id,*phoneNo;
    
    
    
    UIButton *continueBtn, *laterOn;
    UIButton *addBtn;
    UIScrollView *scrollView;
    
    BOOL isKeyBoard;
    CGRect keyboardBounds;
    UIView *lineView;
    UIImageView *profileImg, *navBgBar, *centerIcon;
    UIButton *arrowDropDown;
    
    AllyProfileObject *allyObj;
    AllyProfileObject *allyUpdateObj;
    ParentProfileEntity *parentProfileEntity;
    AllyProfileEntity *allyProfileEntity;
    
    NSData *imageData;
    NSString *imgString;
    CreateAllyProfile *createAllyProfile;
    BOOL isContinueBtnTouch;
    
    ShowActivityLoadingView *loaderView;
    
    UITextField *activeField;
    NSString *relId;
    
    HeaderView *headerView;
    int yy;
    UILabel *pictureLabel;
    //float scrnHt,scrnWd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    parentProfileEntity =[[PC_DataManager sharedManager]getParentEntity];
    if(parentProfileEntity)
    {
        allyProfileEntity = parentProfileEntity.allyProfiles.array.lastObject;
        if(allyProfileEntity.ally_ID)
        {
            allyProfileEntity=nil;
        }
    }
    
    self.navigationController.navigationBarHidden= YES;
    self.view.backgroundColor = appBackgroundColor;
    [self.navigationItem setHidesBackButton:YES];
    
    
    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]AllyProfile];
    [self drawHeaderView];
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = appBackgroundColor;
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        scrollView.frame=CGRectMake(0,yy, screenWidth, screenHeight-yy);
        // scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
        // code for landscape orientation
    }
    else
    {
        scrollView.frame=CGRectMake(0,yy, screenWidth, screenHeight-yy);
        //scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    }
    [self.view addSubview:scrollView];
   // self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self addProfilePic];
    [self setTitleLabel];
    [self setTextFields];
    [self addButton];
    [self moreIcon];
    [self arrowDropDown];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap1:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:singleTap];
    
    self.navigationItem.hidesBackButton=NO;
    self.navigationController.navigationBar.topItem.title = @"";

    
    // [self addKeyBoardNotification];
    
    // Do any additional setup after loading the view.
    
    NSLog(@"hfgehfghejfc %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"AllyOnceregistered"]);
    
     if([[[NSUserDefaults standardUserDefaults]objectForKey:@"AllyOnceregistered"]isEqualToString:@"0"]||![[NSUserDefaults standardUserDefaults]objectForKey:@"AllyOnceregistered"])
     {
         [self showAlertWithTitle:@"PiNWi Help" andMsg:@"An ally is someone whose help you need to manage all the activities in your child’s hectic life. For eg, your driver who picks/drops your child, a neighbour whom you car pool with and sometimes even your spouse who is otherwise off child duty.\n\nAdd as many Ally profiles as you have to easily communicate and connect with them."];
        
         [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"AllyOnceregistered"];
         
     }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails] ||[self.parentClassName isEqualToString:PinWiCreateNewAlly] || !self.parentClassName)
    {
       // self.navigationItem.hidesBackButton=NO;
        headerView.alpha = 1.0f;
    }
    else
    {
         headerView.alpha = 0.0f;
    }
    

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
//    
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
//    
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//>>>>>>> origin/v2
//    //    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//    //self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self addKeyBoardNotification];
    [self drawCenterIcon];
    
//    self.navigationController.navigationBar.topItem.title = @"";
//    self.title=@"Add Ally";
    /* [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
     if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
     self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
     
     self.navigationController.navigationBarHidden=NO;
     self.navigationItem.hidesBackButton = YES;
     self.edgesForExtendedLayout = UIRectEdgeNone; */
    
    [self hideKeyBoard];
    
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails] || [self.parentClassName isEqualToString:PinWiCreateNewAlly])
    {
        [continueBtn setTitle:@"Save" forState:UIControlStateNormal];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    // self.navigationItem.hidesBackButton = YES;
    
//    if(!centerIcon)
//    {
//        [self drawCenterIcon];
//    }
//    centerIcon.image=[UIImage imageNamed:isiPhoneiPad(@"Ally_header.png")];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [centerIcon removeFromSuperview];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    centerIcon = nil;
}


-(void)viewDidUnload
{
    [super viewDidUnload];
    [[PC_DataManager sharedManager].serviceDictionary removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)setTitleLabel
{

    //self.title=@"Add Ally";
//    UIBarButtonItem *newBackButton =

    
    //    UIBarButtonItem *newBackButton =

//    [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                     style:UIBarButtonItemStyleBordered
//                                    target:nil
//                                    action:nil];
//    [[self navigationItem] setBackBarButtonItem:newBackButton];
    

//    titleLabel=[[UILabel alloc]init];
//    NSString *str=[allyProfileArray objectAtIndex:5];
//    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[allyProfileSizeArray objectAtIndex:5]floatValue]]}];
//    titleLabel.font=[UIFont fontWithName:RobotoLight size:[[allyProfileSizeArray objectAtIndex:5] floatValue]];
//    titleLabel.text=str;
//    titleLabel.frame=CGRectMake([[allyProfilePosPXArray objectAtIndex:5]floatValue],[[allyProfilePosPYArray objectAtIndex:5]floatValue],displayValueSize.width,displayValueSize.height);
//    [titleLabel sizeToFit];
//    titleLabel.textColor=radiobuttonSelectionColor;
//    if(![self.parentClassName isEqualToString:PinWiGetProfileDetails]&&![self.parentClassName isEqualToString:PinWiCreateNewAlly])
//    {
//    [scrollView addSubview:titleLabel];
//    }

    titleLabel=[[UILabel alloc]init];
    NSString *str=[allyProfileArray objectAtIndex:5];
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[allyProfileSizeArray objectAtIndex:5]floatValue]]}];
    titleLabel.font=[UIFont fontWithName:RobotoLight size:[[allyProfileSizeArray objectAtIndex:5] floatValue]];
    titleLabel.text=str;
    titleLabel.frame=CGRectMake([[allyProfilePosPXArray objectAtIndex:5]floatValue],[[allyProfilePosPYArray objectAtIndex:5]floatValue],displayValueSize.width,displayValueSize.height);
    [titleLabel sizeToFit];
    titleLabel.textColor=radiobuttonSelectionColor;
    if(![self.parentClassName isEqualToString:PinWiGetProfileDetails]&&![self.parentClassName isEqualToString:PinWiCreateNewAlly])
    {
    [scrollView addSubview:titleLabel];
    }
    [titleLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAlly)];
    [titleLabel addGestureRecognizer:tapGesture];

    /*   labelProfilePic=[[UILabel alloc]init];
     NSString *strProfile=[allyProfileArray objectAtIndex:0];
     CGSize displayValueSize1 = [strProfile sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[allyProfileSizeArray objectAtIndex:0]floatValue]]}];
     labelProfilePic.font=[UIFont fontWithName:@"Roboto Light" size:[[allyProfileSizeArray objectAtIndex:0] floatValue]];
     labelProfilePic.text=strProfile;
     labelProfilePic.frame=CGRectMake([[allyProfilePosPXArray objectAtIndex:0]floatValue],[[allyProfilePosPYArray objectAtIndex:0]floatValue],displayValueSize1.width,displayValueSize1.height);
     labelProfilePic.textColor=[UIColor lightGrayColor];
     
     // [labelProfilePic sizeToFit];
     // labelProfilePic.textColor=textBlueColor;
     [scrollView addSubview:labelProfilePic]; */
    
    
}

-(void)setTextFields
{
    
    firstName =[self setUptextField:firstName forString:[allyProfileArray objectAtIndex:0] withXpos:[[allyProfilePosPXArray objectAtIndex:0]floatValue] withYpos:[[allyProfilePosPYArray objectAtIndex:0]floatValue] withWidth:screenWidth*.43 withHieght:screenHeight*.05 isSecuretext:NO];
    
    lastName =[self setUptextField:lastName forString:[allyProfileArray objectAtIndex:1] withXpos:[[allyProfilePosPXArray objectAtIndex:1]floatValue] withYpos:[[allyProfilePosPYArray objectAtIndex:1]floatValue] withWidth:screenWidth*.45 withHieght:screenHeight*.05 isSecuretext:NO];
    
    
    relationship= [self setUptextField:relationship forString:[allyProfileArray objectAtIndex:2] withXpos:[[allyProfilePosPXArray objectAtIndex:2]floatValue] withYpos:[[allyProfilePosPYArray objectAtIndex:2]floatValue] withWidth:screenWidth-2*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:NO];
    
    [relationship addTarget:self action:@selector(arrowTouchRel) forControlEvents:UIControlEventEditingDidBegin];
    
    email_id= [self setUptextField:email_id forString:[allyProfileArray objectAtIndex:3] withXpos:[[allyProfilePosPXArray objectAtIndex:3]floatValue] withYpos:[[allyProfilePosPYArray objectAtIndex:3]floatValue] withWidth:screenWidth-2*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:NO];
    email_id.autocapitalizationType = UITextAutocapitalizationTypeNone;
    email_id.keyboardType=UIKeyboardTypeEmailAddress;
    
    
    phoneNo= [self setUptextField:phoneNo forString:[allyProfileArray objectAtIndex:4] withXpos:[[allyProfilePosPXArray objectAtIndex:4]floatValue] withYpos:[[allyProfilePosPYArray objectAtIndex:4]floatValue] withWidth:screenWidth-2*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:NO];
    
    phoneNo.keyboardType=UIKeyboardTypePhonePad;
    
    CustomToolBar *toolBar = [[CustomToolBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.customDelgate = self;
    [toolBar setTextField:phoneNo];
    [toolBar addToolBar];
    phoneNo.inputAccessoryView = toolBar;
    
    
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails])
    {
        allyUpdateObj=[[PC_DataManager sharedManager].parentObjectInstance.allyProfiles objectAtIndex:self.allyIndex];
        firstName.text= allyUpdateObj.firstName;
        lastName.text= allyUpdateObj.lastName;
        relationship.text= allyUpdateObj.relationship;
        relId=allyUpdateObj.relationship_ID;
        email_id.text= allyUpdateObj.emailAdd;
        phoneNo.text= allyUpdateObj.contact_no;
        profileImg.image = [[PC_DataManager sharedManager]decodeImage:allyUpdateObj.profilePic];
        [continueBtn setTitle:@"Save" forState:UIControlStateNormal];
    }
    else if(allyProfileEntity)
    {
        firstName.text= allyProfileEntity.firstName;
        lastName.text= allyProfileEntity.lastName;
        relationship.text= allyProfileEntity.relationship;
        relId=allyProfileEntity.relationship_ID;
        email_id.text= allyProfileEntity.emailAdd;
        phoneNo.text= allyProfileEntity.contact_no;
        profileImg.image = [[PC_DataManager sharedManager]decodeImage:allyProfileEntity.profilePic];
    }
    
    if([phoneNo.text isEqualToString:@"(null)"])
    {
        phoneNo.text=@"";
    }
    
    
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


-(void) drawCenterIcon
{
//    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"Ally_header.png") ]];
//    centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//    if(self.view.frame.size.width>700)
//    {
//        centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+20);
//    }
//    else
//    {
//        centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
//    }
//    [self.navigationController.navigationBar addSubview:centerIcon];
    
}
-(void) arrowDropDown
{
    arrowDropDown = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowDropDown setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [arrowDropDown setBackgroundImage:[UIImage imageNamed: isiPhoneiPad(@"arrow.png") ]  forState:UIControlStateNormal];
    arrowDropDown.frame=CGRectMake(0, 0, .05*screenWidth, .05*screenWidth);
    arrowDropDown.center =CGPointMake(screenWidth-arrowDropDown.frame.size.width/2-cellPaddingReg, .21*screenHeight);
    
    [arrowDropDown addTarget:self action:@selector(arrowTouchRel) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:arrowDropDown];
    
}
-(void) arrowTouchRel
{
    AllyRelationTableViewController *ally=[[AllyRelationTableViewController alloc] init];
    ally.allyListDelegate=self;
    [self.navigationController pushViewController:ally animated:YES];
}

-(void)selectedRel:(NSString *)relSelected andId:(NSString *)relIdSelected
{
    relationship.text=relSelected;
    relId=[NSString stringWithFormat:@"%@",relIdSelected];
    [[PC_DataManager sharedManager]writeParentObjToDisk];
}

-(UITextField*)setUptextField:(UITextField*)textField forString:(NSString*)str withXpos:(float)x withYpos:(float)y withWidth:(float)wd withHieght:(float)ht isSecuretext:(BOOL)secured
{
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


-(void) addProfilePic
{
    pictureLabel=[[UILabel alloc]init];
    NSString *str=@"Add Picture";
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]}];
    pictureLabel.font=[UIFont fontWithName:RobotoLight size:8*ScreenHeightFactor];
    pictureLabel.text=str;
    pictureLabel.frame=CGRectMake(0,0,displayValueSize.width+20,displayValueSize.height+5);
    pictureLabel.textAlignment=NSTextAlignmentCenter;
    pictureLabel.center=CGPointMake(.825*screenWidth+cellPaddingReg, .057*screenHeight);
    pictureLabel.textColor=[UIColor blackColor];
    pictureLabel.backgroundColor=[UIColor clearColor];
//    pictureLabel.layer.cornerRadius=10;
//    pictureLabel.clipsToBounds=YES;
    //[label sizeToFit];
    [scrollView addSubview:pictureLabel];
    
    
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

    //    if(allyProfileEntity)
    //    {
    //        //AllyProfileObject *all=[[PC_DataManager sharedManager].parentObjectInstance.allyProfiles lastObject];
    //        // [profileImg setImage:[UIImage imageWithData:allyProfileEntity.profilePic]];
    //        profileImg.image = [[PC_DataManager sharedManager]decodeImage:allyProfileEntity.profilePic];
    //    }
    //    else{
    //        [profileImg setImage:[UIImage imageNamed: isiPhoneiPad( @"")]];
    //    }
    //WithImage:[UIImage imageNamed:  isiPhoneiPad(@"camera.png")]];
}


-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    [activeField resignFirstResponder];
    [self imageSelection];
}

-(void)addButton
{
    
    addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.tintColor=textBlueColor;
    [addBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [addBtn sizeToFit];
    [addBtn setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"addActivity.png")] forState:UIControlStateNormal];
    addBtn.frame=CGRectMake(cellPaddingReg, screenHeight*.4, ScreenHeightFactor*20, ScreenHeightFactor*20);
    addBtn.center=CGPointMake(addBtn.center.x,screenHeight*.42);
    [addBtn addTarget:self action:@selector(addAlly) forControlEvents:UIControlEventTouchUpInside];
    
    continueBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [continueBtn setTitle:@"Save & Continue" forState:UIControlStateNormal];
    continueBtn.tintColor=[UIColor blackColor];
    continueBtn.backgroundColor=buttonGreenColor;
    [continueBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    continueBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [continueBtn sizeToFit];
    continueBtn.frame=CGRectMake(cellPaddingReg, .8*screenHeight, screenWidth-2*cellPaddingReg, .06*screenHeight);
    continueBtn.center=CGPointMake(screenWidth*.5,screenHeight*.5);
    
    [continueBtn addTarget:self action:@selector(continueBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:continueBtn];
    
    
    
    laterOn=[UIButton buttonWithType:UIButtonTypeSystem];
    
    [laterOn setTitle:@"I'll do this Later" forState:UIControlStateNormal];
    laterOn.backgroundColor=[UIColor clearColor];
    [laterOn setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    laterOn.tintColor=textBlueColor;
    laterOn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [laterOn sizeToFit];
    laterOn.frame=CGRectMake(cellPaddingReg, .8*screenHeight, screenWidth-2*cellPaddingReg, .06*screenHeight);
    laterOn.center=CGPointMake(screenWidth*.5,screenHeight*.6);
    laterOn.layer.borderColor = textBlueColor.CGColor;
    laterOn.layer.borderWidth = 1.0f;
    [laterOn addTarget:self action:@selector(laterOnBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView setContentSize:CGSizeMake(screenWidth, laterOn.frame.size.height + laterOn.frame.origin.y+5)];
    if(![self.parentClassName isEqualToString:PinWiGetProfileDetails] && ![self.parentClassName isEqualToString:PinWiCreateNewAlly])
    {
    [scrollView addSubview:addBtn];
    [scrollView addSubview:laterOn];
    }
}

-(void)addAlly
{
    //    WelcomeScreenViewController *confirmProfile=[[WelcomeScreenViewController alloc]init];
    //   // [self.navigationController pushViewController:confirmProfile animated:YES];
    //
    //    [self presentViewController:confirmProfile animated:YES completion:nil];
    //
    UIImage *newImg;
    if(profileImg.image)
    {
        newImg = [[PC_DataManager sharedManager] imageWithImage:profileImg.image convertToSize:CGSizeMake(50,50)];
        //imageData = UIImageJPEGRepresentation(newImg, 0.7);
        
        imgString = [[PC_DataManager sharedManager]encodeImage:newImg];
    }
    
    

    if([self validateAllyData])
    {
        isContinueBtnTouch=NO;
        
        [self saveAllyInfo];
        
    }
}
-(void)continueBtnTouch
{
    UIImage *newImg;
    if(profileImg.image)
    {
        newImg = [[PC_DataManager sharedManager] imageWithImage:profileImg.image convertToSize:CGSizeMake(50,50)];
        //imageData = UIImageJPEGRepresentation(newImg, 0.7);
        
        imgString = [[PC_DataManager sharedManager]encodeImage:newImg];
    }

    if([self validateAllyData])
    {
        isContinueBtnTouch=YES;
        // NSLog(@"PARENT PROFILE %@",[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles);
        [self saveAllyInfo];
        [[NSUserDefaults standardUserDefaults]setValue:@"4" forKey:@"Confirmed"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

-(void)laterOnBtnTouch
{
    [[NSUserDefaults standardUserDefaults]setValue:@"4" forKey:@"Confirmed"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[PC_DataManager sharedManager]writeParentObjToDisk];
    [[PC_DataManager sharedManager]retrieveDataAtLogin];
    
    
    
    WelcomeScreenViewController *confirmProfile=[[WelcomeScreenViewController alloc]init];
    [self presentViewController:confirmProfile animated:YES completion:nil];
}

-(void)saveAllyInfo
{
    // AllyProfileObject *allyObj=[[AllyProfileObject alloc] init];
    
    allyObj=[[AllyProfileObject alloc] init];
    allyObj.firstName=firstName.text;
    allyObj.lastName=lastName.text;
    allyObj.relationship=relationship.text;
    allyObj.emailAdd=email_id.text;
    allyObj.profilePic=imgString;
    allyObj.contact_no=phoneNo.text;
    allyObj.relationship_ID=relId;
    allyObj.parent_ID=[PC_DataManager sharedManager].parentObjectInstance.parentId;
    
    
    NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:[PC_DataManager sharedManager].parentObjectInstance.parentId forKey:@"ParentID"];
    if(imgString && imgString.length!=0)
    {
        [dataDict setObject:imgString           forKey:@"ProfileImage"];
    }
    [dataDict setObject:allyObj.firstName   forKey:@"FirstName"];
    [dataDict setObject:allyObj.lastName    forKey:@"LastName"];
    [dataDict setObject:relId               forKey:@"Relationship"];
    [dataDict setObject:allyObj.emailAdd    forKey:@"EmailAddress"];
    if(allyObj.contact_no.length!=0)
    {
        [dataDict setObject:allyObj.contact_no       forKey:@"Contact"];
    }
   // [dataDict setObject:allyObj.contact_no  forKey:@"Contact"];
    

    
    
    if([self.parentClassName isEqualToString:PinWiGetProfileDetails])
    {
        allyObj.ally_ID=allyUpdateObj.ally_ID;
        UpdateAllyProfile *updateAllyProfile = [[UpdateAllyProfile alloc] init];
//        [updateAllyProfile initService:@{
//                                         @"AllyID"         :allyObj.ally_ID,
//                                         @"ParentID"       : [PC_DataManager sharedManager].parentObjectInstance.parentId,
//                                         @"ProfileImage"   : imgString,//allyObj.profilePic,
//                                         @"FirstName"      : [NSString stringWithFormat:@"%@",allyObj.firstName],
//                                         @"LastName"      : [NSString stringWithFormat:@"%@",allyObj.lastName],
//                                         @"Relationship"   : relId,//allyObj.relationship,
//                                         @"EmailAddress"   : allyObj.emailAdd,
//                                         @"Contact"        : allyObj.contact_no,
//                                         }];
        [dataDict setObject:allyObj.ally_ID  forKey:@"AllyID"];
        [updateAllyProfile initService:dataDict];
        updateAllyProfile.serviceName=PinWiUpdateAlly;
        [updateAllyProfile setDelegate:self];
    }
    else
    {
        createAllyProfile = [[CreateAllyProfile alloc] init];
//        [createAllyProfile initService:@{
//                                         @"ParentID"       : [PC_DataManager sharedManager].parentObjectInstance.parentId,
//                                         @"ProfileImage"   : imgString,//allyObj.profilePic,
//                                         @"FirstName"      : [NSString stringWithFormat:@"%@",allyObj.firstName],
//                                         @"LastName"      : [NSString stringWithFormat:@"%@",allyObj.lastName],
//                                         @"Relationship"   : relId,//allyObj.relationship,
//                                         @"EmailAddress"   : allyObj.emailAdd,
//                                         @"Contact"        : allyObj.contact_no,
//                                         }];
        
        [createAllyProfile initService:dataDict];
        if([self.parentClassName isEqualToString:PinWiCreateNewAlly])
        {
            createAllyProfile.serviceName=PinWiCreateNewAlly;
        }
        else
        {
            createAllyProfile.serviceName=PinWiCreateAlly;
        }
        
        [createAllyProfile setDelegate:self];
    }
    
    [self addLoaderView];
    
}


-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"register: \n%@", dictionary);
    
    
    if([connection.serviceName isEqualToString:PinWiUpdateAlly])
    {
        [[PC_DataManager sharedManager].parentObjectInstance.allyProfiles replaceObjectAtIndex:(int)self.allyIndex withObject:allyObj];
        [[PC_DataManager sharedManager].serviceDictionary removeAllObjects];
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:PinWiGetAllies];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"CreateAllyProfileResponse" resultKey:@"CreateAllyProfileResult"];
        if(!dict)
        {
            return;
        }
        for (NSDictionary *allyDict in dict)
        {
            // NSInteger val= [[parentDict objectForKey:@"ParentID"] integerValue];
            // AllyProfileObject *allyObj=[PC_DataManager sharedManager].parentObjectInstance.allyProfiles.lastObject;
            
            allyObj.ally_ID= [NSString stringWithFormat:@"%@",[allyDict objectForKey:@"AllyID"] ] ;
            [[PC_DataManager sharedManager].parentObjectInstance addnewAlly:allyObj];
            [[PC_DataManager sharedManager]writeParentObjToDisk];
            [[PC_DataManager sharedManager]retrieveDataAtLogin];
        }// Store in the dictionary using the data as the key
        
        
        [self removeLoaderView];
        if(isContinueBtnTouch)
        {
            
            if([connection.serviceName isEqualToString:PinWiCreateNewAlly])
            {
                [[PC_DataManager sharedManager].serviceDictionary removeAllObjects];
                [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:PinWiGetAllies];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if([connection.serviceName isEqualToString:PinWiCreateAlly])
            {
                WelcomeScreenViewController *confirmProfile=[[WelcomeScreenViewController alloc]init];
                [self presentViewController:confirmProfile animated:YES completion:nil];
                // [self.navigationController pushViewController:confirmProfile animated:YES];
                isContinueBtnTouch=NO;
            }
        }
        else
        {
            firstName.text=nil;
            lastName.text=nil;
            relationship.text=nil;
            email_id.text=nil;
            phoneNo.text=nil;
            relId=nil;
            pictureLabel.alpha=1;
            profileImg.image=[UIImage imageNamed:isiPhoneiPad(@"")];
            
            [self showAlertWithTitle:@"Confirmation" andMsg:@"Way to go! You just added a new Ally to your list."];
        }
    }
}







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
{//
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:imagePicker animated:YES completion:nil];
        // }
        
        // imagePickerController=imagePicker;
        //newMedia = YES;
    }
}


-(void)pickImage
{
    
    UIImagePickerController * imagePicker = [UIImagePickerController new];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [imagePicker setDelegate:self];
    
    //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    [self presentViewController:imagePicker animated:YES completion:nil];
    //  }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    // imagePickerController=nil;
    UIImage *imagetaken = info[UIImagePickerControllerOriginalImage];
    profileImg.image=imagetaken;
    //imageData
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
    [firstName resignFirstResponder];
    [lastName  resignFirstResponder];
    [phoneNo resignFirstResponder];
    [email_id resignFirstResponder];
    [relationship resignFirstResponder];
    
}


#pragma mark TEXTFIELD DELEGATES
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField=textField;
    
    //    [DOB resignFirstResponder];
    //    [passcode resignFirstResponder];
    //  [autoLockTime resignFirstResponder];
    
    
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if (textField==phoneNo)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:phoneAcceptableCharacter] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        
        if(phoneNo.text.length >=10 && range.location>=10)
        {
            return NO;
        }
        
        return [string isEqualToString:filtered];
        
    }
    //    if(passcode)
    //    {
    //        //        AddPassCode *adpasscode=[[AddPassCode alloc]initwithEnablePswd:YES changePswd:NO deletePswd:NO key:kCAUserInfoUsernameKey] ;
    //        [self.view addSubview:passcode];
    //    }
    
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [firstName resignFirstResponder];
    [lastName resignFirstResponder];
    [relationship resignFirstResponder];
    [phoneNo resignFirstResponder];
    [email_id resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


#pragma mark VALIDATION
-(BOOL)validateAllyData
{
    if(firstName.text.length==0 && relationship.text.length==0 && email_id.text.length==0 && lastName.text==0)
    {
        [self showAlertWithTitle:@"Incomplete Data" andMsg:@"Oops! You left a few important fields blank."];
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
    else if (relationship.text.length==0)
    {
         [self showAlertWithTitle:@"Incomplete Data" andMsg:@"Please enter relationship before you proceed."];
        //[relationship becomeFirstResponder];
    }
    else if (email_id.text.length==0 || ![[PC_DataManager sharedManager]isIllegalCharacter:email_id.text])
    {
        [self showAlertWithTitle:@"Invalid Email ID" andMsg:@"Your email ID may not be correct. Please check."];
        [email_id becomeFirstResponder];
    }
    else if (email_id.text.length==0 || ![[PC_DataManager sharedManager]NSStringIsValidEmail:email_id.text])
    {
        [self showAlertWithTitle:@"Invalid Email ID" andMsg:@"Your email ID may not be correct. Please check."];
        [email_id becomeFirstResponder];
    }
    else if (phoneNo.text.length>0 && phoneNo.text.length<10)
    {
        [self showAlertWithTitle:@"Incorrect Number" andMsg:@"Your phone number should have 10 digits. Please check."];
        [phoneNo becomeFirstResponder];
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

#pragma mark customToolBarDelegate
-(void)touchAtCancelButton:(CustomToolBar *)cancelDoneToolBar
{
    
}
-(void)touchAtDoneButton:(CustomToolBar *)cancelDoneToolBar
{
    
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
        [headerView setCentreImgName:@"Ally_header.png"];
        if([self.parentClassName isEqualToString:PinWiGetProfileDetails] || [self.parentClassName isEqualToString:PinWiCreateNewAlly])
        {
            [headerView drawHeaderViewWithTitle:@"Add Ally" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        }
        else
        {
            [headerView drawHeaderViewWithTitle:@"Add Ally" isBackBtnReq:NO BackImage:@"leftArrow.png"];
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
   // [self touchAtPinwiWheel];
}

#pragma mark OTHER functionalities


@end
