//
//  InformAllyViewController.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "NotificationSettings.h"
#import "InformAllyDetailViewController.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"
#import "StripView.h"
#import "TextAndDescTextCell.h"
#import "GetNotificationSettingsByProfileID.h"
#import "AddNotificationSettingsByProfileID.h"
#import "InsightData.h"

@interface NotificationSettings ()<HeaderViewProtocol>

@end

@implementation NotificationSettings
{
    NSMutableArray *completeActivityArray;
    //  UIScrollView  *scrollView;
    UITableViewCell *tableCell;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *allyDummy;
    
    
    NSArray *filterData;
    //NSArray *actualData;
    NSString *textFieldString;
    UITableView *searchTableView;
    
    BOOL isSearchActive;
    GetListOfAllys *allyList;
    ShowActivityLoadingView *loaderView;
    UILabel *allyHead;
    
    int indexPathCalc;
    UIImageView *centerIcon;
    
    HeaderView *headerView;
    int yy ;
    
    NSMutableArray *statusArray;
    NSMutableArray *typeArray;
    NSMutableArray *headArray;
}
@synthesize notificationTable;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
    [[PC_DataManager sharedManager] getWidthHeight];
    [[PC_DataManager sharedManager]NotificationList];
    self.view.backgroundColor=appBackgroundColor;
    [self drawHeaderView];
    [self addLabels];
    //int h=self.tabBarController.tabBar.frame.size.height;
    notificationTable = [[UITableView alloc]init];
    notificationTable.backgroundColor=appBackgroundColor;
    notificationTable.frame =CGRectMake(0,yy, screenWidth, screenHeight-yy);
    notificationTable .delegate=self;
    notificationTable.dataSource=self;
    notificationTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:notificationTable];
    
    typeArray=[[NSMutableArray alloc]init];
    statusArray=[[NSMutableArray alloc]init];
    
    [self getSettingsNotification];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [notificationTable reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [centerIcon removeFromSuperview];
    centerIcon=nil;
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
        [headerView setRightType:@"Save"];
        [headerView setCentreImgName:@"settingsHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Settings" isBackBtnReq:YES BackImage:@"leftArrow.png"];
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


-(void)addLabels
{
    StripView *strip=[[StripView alloc]initWithFrame:CGRectMake(0, yy, screenWidth, ScreenHeightFactor*30)];
    [strip drawStrip:@"" color:activityHeading1Code];
    [self.view addSubview:strip];
    
    allyHead=[[UILabel alloc]init];
    
    NSString *str=@"NOTIFICATIONS";
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*ScreenFactor]}];
    allyHead.font=[UIFont fontWithName:RobotoRegular size:9* ScreenFactor];
    allyHead.text=str;
    allyHead.frame=CGRectMake(cellPadding,yy,displayValueSize.width,ScreenHeightFactor*30);
    //childHead.center=CGPointMake(screenWidth/2,childHead.center.y);
    allyHead.textColor=activityHeading1FontCode;
    yy+= strip.frame.size.height;
    //    childHead.backgroundColor=activityHeading2Code;
    //    [childHead sizeToFit];
    [self.view addSubview:allyHead];
}


#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark MENU BUTTON DELEGATE
-(void)getMenuTouches
{
    [self addSettingsNotification];
}
#pragma mark call services for Notification
-(void)getSettingsNotification
{
    
    NSDictionary *dict=[[PC_DataManager sharedManager].serviceDictionary objectForKey:PinWiGetNotificationSettingsByProfileID];
    if(dict)
    {
        [self loadTableDataWith : dict];
    }
    else
    {
        GetNotificationSettingsByProfileID *getNotification=[[GetNotificationSettingsByProfileID alloc]init];
        [getNotification initService:@{
                                       @"ProfileID":[PC_DataManager sharedManager].parentObjectInstance.parentId
                                       }];
        getNotification.serviceName=PinWiGetNotificationSettingsByProfileID;
        getNotification.delegate=self;
        [self addLoaderView];
    }
}

-(void)addSettingsNotification
{
    NSString *statusString;
    for (int i=0; i<4; i++) {
        if(!statusString || statusString.length==0)
        {
            statusString=[[completeActivityArray objectAtIndex:i]objectForKey:@"Selected"];
        }
        else{
        statusString=[statusString stringByAppendingString:[NSString stringWithFormat:@",%@",[[completeActivityArray objectAtIndex:i]objectForKey:@"Selected"]]];
        }
    }
    
    AddNotificationSettingsByProfileID *addNotification=[[AddNotificationSettingsByProfileID alloc]init];
    [addNotification initService:@{
                                    @"ProfileID"        :[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                    @"NotificationType" :@"1,2,3,4",
                                    @"Status"           :statusString
                                   }];
    addNotification.serviceName=PinWiAddNotificationSettingsByProfileID;
    addNotification.delegate=self;
    [self addLoaderView];
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:PinWiGetNotificationSettingsByProfileID])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetNotificationSettingsByProfileIDResponse resultKey:PinWiGetNotificationSettingsByProfileIDResult];
        NSLog(@"dict:\t %@",dict);
        
//        if(!dict)
//        {
//            return;
//        }

        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *arr = (NSArray *)dict;
            dict = [arr firstObject];
        }
        [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:PinWiGetNotificationSettingsByProfileID];
        
        [self loadTableDataWith:dict];
    }
    else if([connection.serviceName isEqualToString:PinWiAddNotificationSettingsByProfileID])
    {
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:PinWiGetNotificationSettingsByProfileID];
    }
}

-(void)loadTableDataWith:(NSDictionary*)dict{
    
    NSLog(@"Country....:   %@", dict);
    if([dict objectForKey:@"ErrorDesc"])
    {
        NSLog(@"No Record found.");
    }
    else
    {
    statusArray=[[[dict objectForKey:@"Status"]componentsSeparatedByString:@","]mutableCopy];
    typeArray=[[[dict objectForKey:@"Type"]componentsSeparatedByString:@","]mutableCopy];
    }
    
    if(typeArray.count<4)
    {
        for (int count=typeArray.count; count<4; count++) {
            [typeArray addObject:[NSString stringWithFormat:@"%d",(count+1)]];
            [statusArray addObject:[NSString stringWithFormat:@"%d",1]];
        }
    }
    [self fillCompleteArray];
//    completeActivityArray = [[NSMutableArray alloc]init];
//    int i=0;
//    for (NSString *type in typeArray) {
//        [completeActivityArray addObject:@{
//                                           @"Type":type,
//                                           @"Status":[statusArray objectAtIndex:i]
//                                           }];
//        i++;
//    }// Store in the dictionary using the data as the key
    
    [loaderView removeLoaderView];
    [notificationTable reloadData];
    
}

-(void)fillCompleteArray
{
    NSMutableDictionary *makeDict;
    completeActivityArray=[[NSMutableArray alloc] init];
    headArray=[[NSMutableArray alloc] initWithObjects:@"Profile",@"Settings",@"Schedule",@"Insights", nil];
    
    for (int i=0; i<headArray.count; i++) {
        makeDict=[[NSMutableDictionary alloc]init];
        [makeDict setObject:[headArray objectAtIndex:i]             forKey:@"Name"];
        [makeDict setObject:[NSString stringWithFormat:@"%d",(i+1)] forKey:@"Tag"];
        [makeDict setObject:[typeArray objectAtIndex:i]             forKey:@"Type"];
        [makeDict setObject:[statusArray objectAtIndex:i]           forKey:@"Selected"];
        [completeActivityArray addObject:makeDict];
    }
    
    [notificationTable reloadData];
    NSLog(@"complete array activity is: \n %@",completeActivityArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScreenHeightFactor*42;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ToggleCellIdentifier = @"ToggleCell";
    
   
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    TextAndDescTextCell *cell;// = [tableView dequeueReusableCellWithIdentifier:@"InformAllyCell" forIndexPath:indexPath];
    
    cell = [tableView dequeueReusableCellWithIdentifier:ToggleCellIdentifier];
    if(!cell)
    {
        cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ToggleCellIdentifier];
    }
    if(!cell.accessoryView)
    {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setFrame:CGRectMake(0, 0, 25*ScreenWidthFactor, 20*ScreenHeightFactor)];
        [switchView setCenter:CGPointMake(screenWidth-switchView.frame.size.width/2-cellPadding, ScreenHeightFactor*20)];
        switchView.tag=[[data objectForKey:@"Tag"]intValue];
        if([[data objectForKey:@"Selected"]isEqualToString:@"1"])
        {
            [switchView setOn:YES animated:NO];
        }
        else
        {
            [switchView setOn:NO animated:NO];
        }
        switchView.onTintColor=radiobuttonSelectionColor;
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    
    // cell.backgroundColor=appBackgroundColor;
    [cell addText:[data objectForKey:@"Name"] andDesc:@"" withTextColor:cellBlackColor_5 andDecsColor:cellTextColor andType:@""];
    cell.arrowImageView.image=[UIImage imageNamed:isiPhoneiPad([notificationListArray objectAtIndex:indexPath.row])];
    cell.arrowImageView.frame=CGRectMake(cellPadding, ScreenHeightFactor*5, ScreenHeightFactor*25, ScreenHeightFactor*25);
    cell.arrowImageView.center=CGPointMake(cellPadding+cell.arrowImageView.frame.size.width/2,cell.textlabel1.center.y);
    cell.arrowImageView.alpha=1;
    cell.textlabel1.center=CGPointMake(2*cellPadding+cell.arrowImageView.frame.size.width+cell.textlabel1.frame.size.width/2, cell.textlabel1.center.y);
    //cell.textLabel.text=[data objectForKey:@"Name"];
    //    cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
    //    cell.textLabel.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.5f];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexPathCalc=indexPath.row;
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
   // [self switchChanged:nil];
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

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSMutableDictionary *makeDict=[completeActivityArray objectAtIndex:(switchControl.tag-1)];
    
    
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    if(switchControl.on)
    {
        [makeDict setObject:@"1" forKey:@"Selected"];
    }
    else
    {
        [makeDict setObject:@"0" forKey:@"Selected"];
    }
    
     NSLog(@"complete array activity is: \n %@",completeActivityArray);
    [notificationTable reloadData];
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


@end
