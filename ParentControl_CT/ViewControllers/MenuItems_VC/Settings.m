//
//  WelcomeScreenViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 11/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "Settings.h"
#import "ParentViewProfile.h"
#import "ShowActivityLoadingView.h"
#import "ProfileSetUpViewController.h"
#import "TimePicker.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"
#import "ProfileSetUp2.h"
#import "ChildSelectionViewController.h"
//#import "AppEnterCodeTableViewController.h"

@interface Settings ()<PickerProtocol,HeaderViewProtocol>
{
    UIImageView *topStrip,*bottomStrip,*titleImg, *centerIcon, *moreIcon, *navBgBar;
    UIScrollView *scrollView;
    UILabel *textLabel,*textLabel1;
    CGSize displayValueSize;
    UIButton *gotoTermsBtn;
    UIView *lineView;
    
    UITextField *activeField;
    ShowActivityLoadingView *loaderView;
    UIViewController *viewCtrlToOpen;
    
    UIView *pickerView;
    UIDatePicker *picker;
    TimePicker *timePicker ;
    UIButton *doneButton, *cancelButton;
    int rowNumber;
     HeaderView *headerView ;
    NSDate *reminderDate;
    int reminderTag;
    int yy;
    ChildSelectionViewController *childSelectionViewController;
}
@end

@implementation Settings
{
    NSMutableArray *settingsDict;
}
@synthesize settingsTable,rootViewController,isComingFromNatwork;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[PC_DataManager sharedManager]getWidthHeight];
    [self.view setBackgroundColor:appBackgroundColor];
    
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton = YES;
    
//    self.navigationController.navigationBarHidden=NO;
//    
//    
//   // self.navigationItem.title=@"Settings";
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
//    //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor=appBackgroundColor;
    scrollView.scrollEnabled = NO;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    [self drawHeaderView];
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
        // code for landscape orientation
    }
    else
    {
       // float height =[UIApplication sharedApplication].statusBarFrame.size.height;
        scrollView.frame=CGRectMake(0,yy+10*ScreenHeightFactor, screenWidth, screenHeight-yy-10*ScreenHeightFactor);
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    }
    [self.view addSubview:scrollView];
    
    [self fillSettingsDict];
    [self drawtableView];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
   
//    for(NSMutableDictionary *dict in settingsDict)
//    {
//        if([[dict objectForKey:@"Name"] isEqualToString:@"Time"])
//        {
//            NSDate *date=[NSDate date];
//            NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
//            [dateFormat setDateFormat:@"hh:mm"];
//            NSString *currentDateString=[dateFormat stringFromDate:date];
//            
//            [dict setObject:currentDateString forKey:@"Desc"];
//        }
//    }
//    [settingsTable reloadData];
    //self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     //self.title=@"Settings";
    self.navigationController.navigationBarHidden=YES;
    [self drawCenterIcon];
}
-(void)drawtableView
{
    settingsTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth,scrollView.frame.size.height)];
    [scrollView addSubview:settingsTable];
    settingsTable.backgroundColor=appBackgroundColor;
    settingsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    settingsTable.delegate=self;
    settingsTable.dataSource=self;
    settingsTable.scrollEnabled=NO;
    settingsTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
   // [settingsTable setContentOffset:CGPointMake(-100, 0)];
}

-(void)fillSettingsDict
{
    if(!settingsDict)
    {
        settingsDict=[[NSMutableArray alloc]init];
    }
    NSMutableDictionary *dataDict;
    dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:@"Parent Profile" forKey:@"Name"];
    [dataDict setObject:@"Parent" forKey:@"Type"];
    [dataDict setObject:@"" forKey:@"Desc"];
    [settingsDict addObject:dataDict];

    dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:@"Set Location" forKey:@"Name"];
    [dataDict setObject:@"Parent" forKey:@"Type"];
    [dataDict setObject:@"" forKey:@"Desc"];
    [settingsDict addObject:dataDict];
    
    dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:@"Child Profile" forKey:@"Name"];
    [dataDict setObject:@"Navigation" forKey:@"Type"];
    [dataDict setObject:@"" forKey:@"Desc"];
    [settingsDict addObject:dataDict];
    
    dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:@"Ally" forKey:@"Name"];
    [dataDict setObject:@"Navigation" forKey:@"Type"];
    [dataDict setObject:@"" forKey:@"Desc"];
    [settingsDict addObject:dataDict];
    
    dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:@"Notifications" forKey:@"Name"];
    [dataDict setObject:@"Navigation" forKey:@"Type"];
    [dataDict setObject:@"" forKey:@"Desc"];
    [settingsDict addObject:dataDict];
    
    dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:@"Holiday Calendar" forKey:@"Name"];
    [dataDict setObject:@"Navigation" forKey:@"Type"];
    [dataDict setObject:@"" forKey:@"Desc"];
    [settingsDict addObject:dataDict];
    
    dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:@"REMINDER" forKey:@"Name"];
    [dataDict setObject:@"Banner" forKey:@"Type"];
    [dataDict setObject:@"" forKey:@"Desc"];
    [settingsDict addObject:dataDict];
    
    dataDict=[[NSMutableDictionary alloc]init];
    NSString *currentFrequency;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"Frequency"])
    {
        currentFrequency=[[NSUserDefaults standardUserDefaults]objectForKey:@"Frequency"];
    }
    else
    {
        currentFrequency=@"Daily";
    }
    
    [dataDict setObject:@"Frequency" forKey:@"Name"];
    [dataDict setObject:@"Fill" forKey:@"Type"];
    [dataDict setObject:currentFrequency forKey:@"Desc"];
    reminderTag=0;
    [settingsDict addObject:dataDict];
    
//    NSDate *date=[NSDate date];
//    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
//    [dateFormat setDateFormat:@"hh:mm"];
    NSString *currentDateString;//=[dateFormat stringFromDate:date];
//    reminderDate=date;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"ReminderValue"])
    {
        currentDateString=[[NSUserDefaults standardUserDefaults]objectForKey:@"ReminderValue"];
    }
    else
    {
        currentDateString=@"8:00 pm";
    }
    
    dataDict=[[NSMutableDictionary alloc]init];
    [dataDict setObject:@"Time" forKey:@"Name"];
    [dataDict setObject:@"Fill" forKey:@"Type"];
    [dataDict setObject:currentDateString forKey:@"Desc"];
    [settingsDict addObject:dataDict];

}

-(void)getWidthHeight
{
    
    screenHeight=[ScreenInfo getScreenHeight];
    screenWidth=[ScreenInfo getScreenWidth];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

//    [centerIcon removeFromSuperview];
//    centerIcon=nil;
    //self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [centerIcon removeFromSuperview];
    centerIcon=nil;
}

-(void) drawCenterIcon
{
//    if(!centerIcon)
//    {
//    
//    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"settingsHeader.png") ]];
//         centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//        if(self.view.frame.size.width>700)
//        {
//           // centerIcon.frame=CGRectMake(0, 0,centerIcon.image.size.height-20, centerIcon.image.size.height-20);
//            centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+20);
//            
//        }
//        else
//        {
//            //centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//            centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
//            
//        }
//    [self.navigationController.navigationBar addSubview:centerIcon];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return settingsDict.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if([[[settingsDict objectAtIndex:indexPath.row] objectForKey:@"Type"]isEqualToString:@"Banner"])
    {
        return ScreenHeightFactor*30;
    }
    
    return ScreenHeightFactor*42;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ParentCellIdentifier = @"ParentTableCell";
    static NSString *IndicatorCellIdentifier = @"IndicatorTableCell";
    static NSString *BannerCellIdentifier = @"BannerTableCell";
    static NSString *InfoCellIdentifier = @"InfoTableCell";

    NSDictionary *dataDict=[settingsDict objectAtIndex:(int)indexPath.row];
    
    TextAndDescTextCell *cell;
    
    if([[dataDict objectForKey:@"Type"]isEqualToString:@"Parent"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:ParentCellIdentifier];
        if(cell == nil)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ParentCellIdentifier];
        }
         [cell addText:[dataDict objectForKey:@"Name"] andDesc:@"" withTextColor:cellTextColor andDecsColor:cellBlackColor_6 andType:@""];
        cell.arrowImageView.alpha=1.0f;
        //cell.textlabel1.center=CGPointMake(cell.textlabel1.center.x,15*ScreenHeightFactor);
       // [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.backgroundColor=[UIColor clearColor];
       
    }
    
    if([[dataDict objectForKey:@"Type"]isEqualToString:@"Navigation"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:IndicatorCellIdentifier];
        if(cell == nil)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IndicatorCellIdentifier];
        }
         [cell addText:[dataDict objectForKey:@"Name"] andDesc:@"" withTextColor:cellTextColor andDecsColor:cellBlackColor_6 andType:@""];
       // [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.arrowImageView.alpha=1.0f;
         cell.backgroundColor=[UIColor clearColor];
    }
    
    if([[dataDict objectForKey:@"Type"]isEqualToString:@"Banner"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:BannerCellIdentifier];
        if(cell == nil)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BannerCellIdentifier];
        }
        [cell addText:[dataDict objectForKey:@"Name"] andDesc:@"" withTextColor:cellTextColor andDecsColor:cellBlackColor_6 andType:@""];
        cell.textlabel1.center=CGPointMake(cell.textlabel1.center.x,15*ScreenHeightFactor);
        cell.backgroundColor=activityHeading2Code;
    }
    
    if([[dataDict objectForKey:@"Type"]isEqualToString:@"Fill"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:InfoCellIdentifier];
        if(cell == nil)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InfoCellIdentifier];
        }
        [cell addText:[dataDict objectForKey:@"Name"] andDesc:[dataDict objectForKey:@"Desc"] withTextColor:cellTextColor andDecsColor:cellBlackColor_6 andType:@""];
//        cell.detailTextLabel.text=[dataDict objectForKey:@"Desc"];
//         cell.backgroundColor=[UIColor clearColor];
//        cell.detailTextLabel.textColor=cellBlackColor_6;
//        cell.detailTextLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
    }
    
//    cell.textLabel.textColor=cellBlackColor_6;
//    cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
//    //cell.con
//    cell.textLabel.text=[dataDict objectForKey:@"Name"];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [pickerView removeFromSuperview];
    [timePicker removeFromSuperview];
    
    [self getTouchesOfCells:(int)indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
}

-(void)getTouchesOfCells:(int)rowNum
{
    
    rowNumber=rowNum;
    if (rowNum<6)
    {
        NSArray *classArray=@[@"ProfileSetUpViewController",@"ProfileSetUp2",@"ChildSelectionViewController",@"AllySelectionViewController",@"NotificationSettings",@"HolidayCalendar_VC"];
        NSString *classStr=[classArray objectAtIndex:rowNum];
        viewCtrlToOpen=[[NSClassFromString(classStr) alloc]init];
        
        if(rowNum==1)
        {
            [self getDetailsofProfile:@"0"];
        }
        else if (rowNum==0)
        {
            [self getDetailsofProfile:@"1"];
        }
        else if (rowNum==2){
            
            childSelectionViewController = [[ChildSelectionViewController alloc] init];
            childSelectionViewController.isComingfromNetwork = self.isComingFromNatwork;
            [self.navigationController pushViewController:childSelectionViewController animated:YES];
        }
        else
        {
            self.title=@"";
            
            [self.navigationController.navigationBar setTitleTextAttributes:
                  [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
                 //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
                 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
                 self.navigationController.navigationBar.tintColor=[UIColor whiteColor];

            
             self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:viewCtrlToOpen animated:YES];
        }
    }
    else if (rowNum==7)
    {
        [self showFrequency];
    }
    else if (rowNum==8)
    {
        [self drawDatePicker];
    }
    
 /*  switch (rowNum) {
        case 0:
            //[self iniviteFriendByEmail:nil];
            break;
            
        case 1:
            //[self openMessageController];
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
    }
    if(rowNum<5)
    {
    NSArray *classArray=@[@"ProfileSetUpViewController",@"ChildSelectionViewController",@"AllySelectionViewController",@"NotificationSettings",@"HolidayCalendar"];
//        UIBarButtonItem *newBackButton =
//        [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                         style:UIBarButtonItemStyleBordered
//                                        target:nil
//                                        action:nil];
//        [[self.navigationController navigationItem] setBackBarButtonItem:newBackButton];
//
    
    NSString *classStr=[classArray objectAtIndex:rowNum];
    
    UIViewController *viewCtrl=[[NSClassFromString(classStr) alloc]init];
    //[viewCtrl.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:viewCtrl animated:YES];
      //  [self presentViewController:viewCtrl animated:YES completion:nil];
    }*/
}


#pragma mark url delegates
-(void)getDetailsofProfile:(NSString*)profileId
{
//    NSString *str=[NSString stringWithFormat:@"%@-%d",PinWiGetProfileDetails,rowNumber];
//    NSDictionary *dataDict=[[PC_DataManager sharedManager].serviceDictionary objectForKey:str];
//    
//    if(dataDict)
//    {
//         [self loadParentObject:dataDict];
//    }
//    else
//    {
   GetAllProfilesDetails *getDetails = [[GetAllProfilesDetails alloc] init];
    [getDetails initService:@{
                             @"ProfileType":profileId,
                            @"ProfileID":[PC_DataManager sharedManager].parentObjectInstance.parentId
                            }];
    [getDetails setDelegate:self];
    getDetails.serviceName=PinWiGetProfileDetails;
    [self addLoaderView];
    }
//}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"Connection Finish data =%@",dictionary);
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:PinWiGetProfileDetails])
    {
        
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetAllProfilesDetailsResponse" resultKey:@"GetAllProfilesDetailsResult"];
        NSLog(@"Dict  = %@ ",dict);
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            [self loadParentObject:dictionary];
            
            NSString *str=[NSString stringWithFormat:@"%@-%d",PinWiGetProfileDetails,rowNumber];
           [[PC_DataManager sharedManager].serviceDictionary setObject:dictionary forKey:str];
        }
    }
}

-(void)loadParentObject:(NSDictionary*)parentDict
{
    
    ParentProfileObject *parentObj=[[ParentProfileObject alloc]init];
    parentObj.image         =[parentDict objectForKey:@"ProfileImage"];
    parentObj.firstName     =[parentDict objectForKey:@"FirstName"];
    parentObj.lastName      =[parentDict objectForKey:@"LastName"];
    parentObj.contactNo     =[parentDict objectForKey:@"Contact"];
    parentObj.passcode      =[parentDict objectForKey:@"Passcode"];
    parentObj.passwd        =[parentDict objectForKey:@"Password"];
    parentObj.autoLockID    =[parentDict objectForKey:@"AutolockTime"];
    parentObj.autoLockTime  =[parentDict objectForKey:@"TimeValue"];
    parentObj.longitute     =[parentDict objectForKey:@"Longitude"];
    parentObj.latitude      =[parentDict objectForKey:@"Latitude"];
    parentObj.googleAddress =[parentDict objectForKey:@"GoogleMapAddress"];
    parentObj.country       =[parentDict objectForKey:@"CountryName"];
    parentObj.countryID     =[parentDict objectForKey:@"Country"];
    parentObj.city          =[parentDict objectForKey:@"CityName"];
    parentObj.cityID        =[parentDict objectForKey:@"City"];
    parentObj.neighourRad   =[parentDict objectForKey:@"NeighbourhoodRadiusValue"];
    parentObj.neighourID    =[parentDict objectForKey:@"NeighbourhoodRadius"];
    parentObj.flatBuilding  =[parentDict objectForKey:@"FlatNoBuilding"];
    parentObj.streetLocality=[parentDict objectForKey:@"StreetLocality"];
    
    
    [PC_DataManager sharedManager].parentObjectInstance.image         =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"ProfileImage"]];
    [PC_DataManager sharedManager].parentObjectInstance.firstName     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"FirstName"]];
    [PC_DataManager sharedManager].parentObjectInstance.lastName      =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"LastName"]];
    [PC_DataManager sharedManager].parentObjectInstance.contactNo     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Contact"]];
    [PC_DataManager sharedManager].parentObjectInstance.passcode      =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Passcode"]];
    [PC_DataManager sharedManager].parentObjectInstance.passwd        =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Password"]];
    [PC_DataManager sharedManager].parentObjectInstance.autoLockID    =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"AutolockTime"]];
    [PC_DataManager sharedManager].parentObjectInstance.autoLockTime  =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"TimeValue"]];
    [PC_DataManager sharedManager].parentObjectInstance.longitute     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Longitude"]];
    [PC_DataManager sharedManager].parentObjectInstance.latitude      =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Latitude"]];
    [PC_DataManager sharedManager].parentObjectInstance.googleAddress =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"GoogleMapAddress"]];
    [PC_DataManager sharedManager].parentObjectInstance.country       =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"CountryName"]];
    [PC_DataManager sharedManager].parentObjectInstance.countryID     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Country"]];
    [PC_DataManager sharedManager].parentObjectInstance.city          =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"CityName"]];
    [PC_DataManager sharedManager].parentObjectInstance.cityID        =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"City"]];
    [PC_DataManager sharedManager].parentObjectInstance.neighourRad   =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"NeighbourhoodRadiusValue"]];
    [PC_DataManager sharedManager].parentObjectInstance.neighourID    =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"NeighbourhoodRadius"]];
    [PC_DataManager sharedManager].parentObjectInstance.flatBuilding  =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"FlatNoBuilding"]];
    [PC_DataManager sharedManager].parentObjectInstance.streetLocality=[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"StreetLocality"]];
    [PC_DataManager sharedManager].parentObjectInstance.emailAdd=[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"EmailAddress"]];
    [PC_DataManager sharedManager].parentObjectInstance.dob=[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"DateOfBirth"]];
    
    [PC_DataManager sharedManager].parentObjectInstance.relation=[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Relation"]];
    
    [PC_DataManager sharedManager].parentObjectInstance.gender=[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Gender"]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    
    self.navigationController.navigationBarHidden = NO;
    
    
    self.title = @"";
    
    
    if(rowNumber==0)
    {
        ProfileSetUpViewController *viewCtrl=[[ProfileSetUpViewController alloc]init];
        viewCtrl.parentClassName=PinWiGetProfileDetails;
        viewCtrl.parentObject=parentObj;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
    else
    {
        ProfileSetUp2 *viewCtrl=[[ProfileSetUp2 alloc]init];
        viewCtrl.parentClassName=PinWiGetProfileDetails;
        viewCtrl.parentObject=parentObj;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
    
    

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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0, kbSize.height-64, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = scrollView.frame;
    aRect.size.height -= kbSize.height;
    CGPoint point=activeField.frame.origin;
    point.y+=64;
    if (!CGRectContainsPoint(aRect,point))
    {
        CGPoint scrollPoint = CGPointMake(0.0,activeField.frame.origin.y-aRect.size.height+activeField.frame.size.height+5);
        scrollPoint.y+=64;
        [scrollView setContentOffset:scrollPoint animated:YES];
        //CGPointMake
        [scrollView setContentSize:CGSizeMake(screenWidth, screenHeight+64)];
    }
}
-(void) keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsMake(0, 0.0,0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    NSLog(@"Live=%f",self.view.frame.size.height/2.0f);
    [ scrollView setContentSize:CGSizeMake(screenWidth, screenHeight)];
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

#pragma mark time picker view
-(void)drawDatePicker
{
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(0, screenHeight-self.view.frame.size.height*.4, screenWidth, screenHeight*.4)];
    [self.view addSubview:pickerView];
    pickerView.backgroundColor=[UIColor whiteColor];
    
    
    cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.tintColor=[UIColor darkGrayColor];
    cancelButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [cancelButton sizeToFit];
    cancelButton.frame=CGRectMake(0,15,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [cancelButton addTarget:self action:@selector(ClickOnCancel) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:cancelButton];
    
    doneButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.tintColor=[UIColor darkGrayColor];
    doneButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    doneButton.frame=CGRectMake(pickerView.frame.size.width-cancelButton.frame.size.width,15,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [doneButton addTarget:self action:@selector(ClickOnDone) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:doneButton];
    
    
    picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(pickerView.frame.origin.x, pickerView.frame.size.height*.12, pickerView.frame.size.width, pickerView.frame.size.height);
    
    picker.minimumDate  = nil;
    picker.datePickerMode=UIDatePickerModeTime;
    [pickerView addSubview:picker];
    // .inputView=picker;
}



-(void)ClickOnDone
{
    NSMutableDictionary *changeVal=[settingsDict objectAtIndex:rowNumber];
    NSDate *date1 = picker.date;
    if(picker.date==nil)
    {
        date1=[NSDate date];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    reminderDate=date1;
    
        [dateFormat setDateFormat:@"hh:mm a"];
        [dateFormat setAMSymbol:@"AM "];
        [dateFormat setPMSymbol:@"PM "];
        
        NSString *dateString = [dateFormat stringFromDate:date1];
                   [changeVal setObject:dateString forKey:@"Desc"];
    [[NSUserDefaults standardUserDefaults]setObject:dateString forKey:@"ReminderValue"];
    [pickerView removeFromSuperview];
    [settingsTable reloadData];
    [self createReminder];
}

-(void)ClickOnCancel
{
    
    [pickerView removeFromSuperview];
}


#pragma mark Frequency picker view
-(void)showFrequency
{
    AppDelegate *appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate reminderpermission];
    
   timePicker  =[[TimePicker alloc]initWithFrame:CGRectMake(0, screenHeight*.6, screenWidth, screenHeight*.4)];
    [timePicker setBackgroundColor:[UIColor whiteColor]];
    cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.tintColor=[UIColor darkGrayColor];
    cancelButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [cancelButton sizeToFit];
    cancelButton.frame=CGRectMake(0,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    
    timePicker.pickerDelegate=self;
    
    [timePicker pickerView:@"Frequency"];
    [self.view addSubview:timePicker];
}
-(void)doneTouched:(NSString *)value withTag:(int)tagVal
{
    reminderTag=tagVal;
    NSMutableDictionary *changeVal=[settingsDict objectAtIndex:rowNumber];
     [changeVal setObject:value forKey:@"Desc"];
    [[NSUserDefaults standardUserDefaults]setObject:[changeVal valueForKey:@"Desc"] forKey:@"Frequency"];
    [settingsTable reloadData];
    [timePicker removeFromSuperview];
    
    [self createReminder];
}
-(void)cancelTouched
{
    [timePicker removeFromSuperview];
}

#pragma mark create reminder
-(void)createReminder
{
   /*
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.eventStore = appDelegate.eventStore;
    
    EKReminder *reminder = [EKReminder
                            reminderWithEventStore:self.eventStore];
    NSString *alarmText  = [NSString stringWithFormat:@"PinWi Daily Alert."];
    reminder.title = alarmText; //@"Alarm";
    
    reminder.calendar = [_eventStore defaultCalendarForNewReminders];
  //  NSDate *alarmTime = [[NSDate date] dateByAddingTimeInterval:-];
    
   
    EKRecurrenceRule *recurrenceRule;
    if(reminderTag==0)
    {
         [_eventStore removeReminder:reminder commit:YES error:nil];
       recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:nil];
    }
    else if (reminderTag==1)
    {
         [_eventStore removeReminder:reminder commit:YES error:nil];
     recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:nil];
    }
    if(reminderTag==2)
    {
         [_eventStore removeReminder:reminder commit:YES error:nil];
        recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 end:nil];
    }
    else if (reminderTag==3)
    {
          [_eventStore removeReminder:reminder commit:YES error:nil];
        return;
        //recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:nil];
    }
    
    reminder.recurrenceRules = [NSArray arrayWithObject:recurrenceRule];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    reminder.dueDateComponents = [cal components:unitFlags fromDate:[NSDate date]];
    
    
    NSDate *alarmTime = [reminderDate dateByAddingTimeInterval:-10];
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:alarmTime];
    
    [reminder addAlarm:alarm];
    
    NSError *error = nil;
    [_eventStore saveReminder:reminder commit:YES error:&error];
    
    if (error)
        NSLog(@"error = %@", error);*/
}
#pragma mark HeaderViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"settingsHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Settings" isBackBtnReq:YES BackImage:@"leftArrow.png"];
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
    
}
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue gotoTermsBtner:(id)gotoTermsBtner {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
