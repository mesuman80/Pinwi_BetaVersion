//
//  InformAllyViewController.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ChildSelectionViewController.h"
#import "InformAllyDetailViewController.h"
#import "ShowActivityLoadingView.h"
#import "ChildSelectionViewController.h"
#import "HeaderView.h"
#import "StripView.h"
#import "TextAndDescTextCell.h"

@interface ChildSelectionViewController ()<HeaderViewProtocol>

@end

@implementation ChildSelectionViewController
{
    NSMutableArray *completeActivityArray;
    //  UIScrollView  *scrollView;
    UITableViewCell *tableCell;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *childDummy;
    
    
    NSArray *filterData;
    //NSArray *actualData;
    NSString *textFieldString;
    UITableView *searchTableView;
    
    BOOL isSearchActive;
    ShowActivityLoadingView *loaderView;
    UILabel *childHead;
    
    UIButton *addButton;
    
    NSIndexPath *indexPathCalc;
    int rowNumber;
    
    UIImageView *centerIcon;
    HeaderView *headerView;
    BOOL isComingFromNetwork;
    int yy;
}
@synthesize childSelectionTable;



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationItem setHidesBackButton:YES];
    
    [[PC_DataManager sharedManager] getWidthHeight];
    self.view.backgroundColor=appBackgroundColor;
    [self drawHeaderView];
    [self addLabels];
    //int h=self.tabBarController.tabBar.frame.size.height;
    childSelectionTable = [[UITableView alloc]init];
    childSelectionTable.backgroundColor=appBackgroundColor;
    childSelectionTable.frame =CGRectMake(0, yy, screenWidth, screenHeight-yy);
    childSelectionTable .delegate=self;
    childSelectionTable.dataSource=self;
    childSelectionTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:childSelectionTable];
    
   // [self addSearchBar];
    
}

-(void) drawCenterIcon
{
    if(!centerIcon)
    {
        
        centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"settingsHeader.png") ]];
        centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
        if(self.view.frame.size.width>700)
        {
            // centerIcon.frame=CGRectMake(0, 0,centerIcon.image.size.height-20, centerIcon.image.size.height-20);
            centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+20);
            
        }
        else
        {
            //centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
            centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
            
        }
        [self.navigationController.navigationBar addSubview:centerIcon];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.title=@"Children";
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    UIBarButtonItem *newBackButton =
//    [[UIBarButtonItem alloc] initWithTitle:@""
//                                     style:UIBarButtonItemStyleBordered
//                                    target:nil
//                                    action:nil];
//    [[self.navigationController navigationItem] setBackBarButtonItem:newBackButton];
    [self getChildList];
    [self drawCenterIcon];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [childSelectionTable reloadData];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [centerIcon removeFromSuperview];
    centerIcon=nil;
}

-(void) getChildList
{
    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:PinWiGetChildren];
    if(dict)
    {
        NSArray *arr=(NSArray*)dict;
        NSMutableDictionary *checkDict=[[arr firstObject]mutableCopy];
        if([[checkDict objectForKey:@"ErrorDesc"]isEqualToString:@"Child doesn't exixts."])
        {
            completeActivityArray=[[NSMutableArray alloc]init];
            NSMutableDictionary *makeDict=[[NSMutableDictionary alloc]init];
            [makeDict setObject:@"Button" forKey:@"Type"];
            [completeActivityArray addObject:makeDict];
        }
        else
        {
            [self loadTableDataWith:(NSMutableDictionary*)dict];
        }
    }else{
        
       GetListofChildsByParentID *childList = [[GetListofChildsByParentID alloc] init];
        [childList initService:@{
                                 @"ParentID":[PC_DataManager sharedManager].parentObjectInstance.parentId
                                 }];
        [childList setDelegate:self];
        childList.serviceName=PinWiGetChildren;
        [self addLoaderView];
    }
    [childSelectionTable reloadData];
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    if([connection.serviceName isEqualToString:PinWiGetProfileDetails])
    {
        
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetAllProfilesDetailsResponse" resultKey:@"GetAllProfilesDetailsResult"];
        NSLog(@"Dict  = %@ ",dict);
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            [self loadParentObject:dictionary];
            
        }
    }
    else if ([connection.serviceName isEqualToString:PinWiDeleteChild])
    {
        [completeActivityArray removeObjectAtIndex:rowNumber];
        [[[PC_DataManager sharedManager].parentObjectInstance childrenProfiles]removeObjectAtIndex:rowNumber];
        [childSelectionTable reloadData];
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:PinWiGetChildren];
    }
    else
    {
        
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetListofChildsByParentIDResponse" resultKey:@"GetListofChildsByParentIDResult"];
        NSLog(@"dict:\t %@",dict);
        
        if(!dict)
        {
            return;
        }
        NSArray *arr=(NSArray*)dict;
        NSMutableDictionary *checkDict=[[arr firstObject]mutableCopy];
        if([[checkDict objectForKey:@"ErrorDesc"]isEqualToString:@"Parent doesn't exixts."])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:PinWiGetChildren];
        
        [self loadTableDataWith:(NSMutableDictionary*)dict];
        
    }
    [self removeLoaderView];
}

-(void)loadTableDataWith:(NSMutableDictionary*)dict{
    
    NSLog(@"Country....:   %@", dict);
    completeActivityArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *makedict;
    for (NSMutableDictionary *child in dict) {
        
        /*   ChildProfileObject *child1=[[ChildProfileObject alloc]init];
         child1.nick_Name=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"FirstName"]];
         child1.profile_pic=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"ProfileImage"]];
         child1.child_ID=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"ProfileID"]];
         child1.firstName=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"FirstName"]];
         child1.lastName=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"ProfileName"]];
         child1.earnedPts=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"EarnedPoints"]];
         child1.pendingPts=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"PendingPoints"]];
         
         // [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles addObject:child1];*/
            makedict=[[NSMutableDictionary alloc]init];
            [makedict setObject:[NSString stringWithFormat:@"%@",[child objectForKey:@"FirstName"]] forKey:@"FirstName"];
            [makedict setObject:[NSString stringWithFormat:@"%@",[child objectForKey:@"NickName"]] forKey:@"NickName"];
            [makedict setObject:[NSString stringWithFormat:@"%@",[child objectForKey:@"ChildID"]] forKey:@"ChildID"];
            [makedict setObject:@"Data"  forKey:@"Type"];
            [completeActivityArray addObject:makedict];
            
        
    }// Store in the dictionary using the data as the key
    makedict=[[NSMutableDictionary alloc]init];
    [makedict setObject:@"Button" forKey:@"Type"];
    [completeActivityArray addObject:makedict];
    [childSelectionTable reloadData];
    
}


-(void)addSearchBar {
    
    
    //searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,screenWidth,screenHeight*.15)];
    searchBar=[[UISearchBar alloc]init];
    [searchBar setShowsScopeBar:YES];
    searchBar.delegate = self;
    searchBar.placeholder=@"Search";
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];searchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    //searchDisplayController=[[UISearchController alloc]initWithSearchResultsController:self];
    searchDisplayController.searchResultsDelegate =self;// allyTable.delegate;
    searchDisplayController.searchResultsDataSource =self;// allyTable.dataSource;
    
    self.definesPresentationContext = YES;
    //searchBar.frame=CGRectMake(0,0,screenWidth,screenHeight*.15);
    childSelectionTable.tableHeaderView=searchBar;
    
}



-(void)addLabels
{
    
    StripView *strip=[[StripView alloc]initWithFrame:CGRectMake(0, yy, screenWidth, ScreenHeightFactor*30)];
    [strip drawStrip:@"" color:activityHeading1Code];
    [self.view addSubview:strip];
    
    childHead=[[UILabel alloc]init];
    
    NSString *str=@"CHILD PROFILE";
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*ScreenFactor]}];
    childHead.font=[UIFont fontWithName:RobotoRegular size:9* ScreenFactor];
    childHead.text=str;
    childHead.frame=CGRectMake(cellPadding,yy,displayValueSize.width,ScreenHeightFactor*30);
    //childHead.center=CGPointMake(screenWidth/2,childHead.center.y);
    childHead.textColor=activityHeading1FontCode;
     yy+= strip.frame.size.height;
//    childHead.backgroundColor=activityHeading2Code;
//    [childHead sizeToFit];
    [self.view addSubview:childHead];
    //yy+= childHead.frame.size.height;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UISearchDisplayController Delegate Methods
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
  //  [childHead setAlpha:0.0f];
    //  allyTable.frame =CGRectMake(0, 0, screenWidth, screenHeight);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
   // [childHead setAlpha:1.0f];
    // searchBar.frame=CGRectMake(0,0,screenWidth,screenHeight*.15);
    //    allyTable.frame =CGRectMake(0, .15*screenHeight, screenWidth, screenHeight*.9);
    //    allyTable.tableHeaderView=searchBar;
}

#pragma mark filterArray According To TextEnter
- (void)filterContentForSearchText:(NSString*)searchText
{
    //beginswith[c]
    //contains
    if(searchText.length>0)
    {
        isSearchActive=YES;
    }
    else
    {
        isSearchActive=NO;
    }
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"NickName beginswith[c] %@", searchText];
    filterData = [completeActivityArray filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"Filter  data=%@",filterData);
    // [allyTable reloadData];
}

#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    [self filterContentForSearchText:searchBar.text];
    if(isSearchActive)
    {
        if(filterData.count>0)
        {
            return filterData.count;
        }
        else
        {
            return 0;
        }
    }
    isSearchActive=NO;
    return completeActivityArray.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [childSelectionTable setEditing:editing animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    rowNumber=(int)indexPath.row;
    //    if (editingStyle == UITableViewCellEditingStyleDelete) {
    //        //remove the deleted object from your data source.
    //        //If your data source is an NSMutableArray, do this
    //        [completeActivityArray removeObjectAtIndex:indexPath.row];
    //        [childSelectionTable reloadData]; // tell table to refresh now
    //    }
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    rowNumber=(int)indexPath.row;
    NSMutableDictionary *dict=[completeActivityArray objectAtIndex:indexPath.row];
    if([[dict objectForKey:@"Type"]isEqualToString:@"Data"])
    {

    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [self editRowsInTable:indexPath];
            
            NSLog(@"Edit");
        }];

        
        editAction.backgroundColor = [UIColor lightGrayColor];
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            if (completeActivityArray.count == 2) {
                UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:@"Alert" message:@"You cannot delete last child." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView setBackgroundColor:placeHolderReg];
                [alertView show];
            }else{
            [self deleteRowsInTable:indexPath];
            }
        }];
        
        deleteAction.backgroundColor=[UIColor redColor];
        return @[deleteAction, editAction];
    }
    return nil;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    filterData =nil;
    [childHead setAlpha:1.0f];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   CGFloat height =  ScreenHeightFactor*42;
    return (int)height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ChildCellIdentifier = @"ChildCell";
    static NSString *ButtonCellIdentifier = @"ButtonCell";
    rowNumber=(int)indexPath.row;
    TextAndDescTextCell *cell;// = [tableView dequeueReusableCellWithIdentifier:@"InformAllyCell" forIndexPath:indexPath];
    
    NSMutableDictionary *dict=[completeActivityArray objectAtIndex:indexPath.row];
    
    if([[dict objectForKey:@"Type"]isEqualToString:@"Data"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:ChildCellIdentifier];
        if(!cell)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChildCellIdentifier];
        }
        NSDictionary *dict;
        cell.textLabel.textColor=activityHeading1FontCode;
        if(filterData.count>0)
        {
            dict=[filterData objectAtIndex:indexPath.row];
           // cell.textLabel.text=[dict objectForKey:@"FirstName"];
        }
        else
        {
            dict = [completeActivityArray objectAtIndex:indexPath.row];
           // cell.textLabel.text=[data objectForKey:@"FirstName"];
        }
        [cell addText:[dict objectForKey:@"NickName"] andDesc:@"" withTextColor:cellBlackColor_5 andDecsColor:cellTextColor andType:@""];
        cell.editingAccessoryView.backgroundColor=[UIColor clearColor];
//        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
//        cell.textLabel.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.5f];
       cell.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    else if([[dict objectForKey:@"Type"]isEqualToString:@"Button"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:ButtonCellIdentifier];
        if(!cell)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ButtonCellIdentifier];
        }
        if(!addButton)
        {
//            UIButton *imgView = [UIButton buttonWithType:UIButtonTypeCustom];
//            imgView.tintColor=textBlueColor;
            
            [cell addText:@"Add another child's profile" andDesc:@"" withTextColor:textBlueColor andDecsColor:cellTextColor andType:@""];
            
            [cell.arrowImageView setImage:[UIImage imageNamed:isiPhoneiPad(@"addActivity.png")]];
            if(screenWidth>700)
            {
                cell.arrowImageView.frame= CGRectMake(cellPadding, 10*ScreenHeightFactor,20*ScreenHeightFactor, 20*ScreenHeightFactor);
            }
            else
            {
                cell.arrowImageView.frame= CGRectMake(cellPadding, 11*ScreenHeightFactor,20*ScreenHeightFactor, 20*ScreenHeightFactor);
            }
            cell.arrowImageView.alpha=1.0;
             [cell.textlabel1 setCenter:CGPointMake(cell.textlabel1.center.x+cell.arrowImageView.frame.size.width+cellPadding, cell.textlabel1.center.y)];
            
            
            
           // [cell.contentView addSubview:imgView];
            
            
//           addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//            addButton.tintColor=textBlueColor;
//            if(screenWidth>700)
//            {
//                addButton.frame= CGRectMake(cellPadding, 12.5*ScreenHeightFactor,20*ScreenWidthFactor, 20*ScreenWidthFactor);
//            }
//            else
//            {
//                addButton.frame= CGRectMake(cellPadding, 15*ScreenHeightFactor,20*ScreenWidthFactor, 20*ScreenWidthFactor);
//            }
//            addButton.center=CGPointMake(addButton.center.x,ScreenHeightFactor*20);
//             [addButton addTarget:self action:@selector(TouchAddChild) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:addButton];
            
            }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    rowNumber=(int)indexPath.row;
    NSMutableDictionary *dict=[completeActivityArray objectAtIndex:indexPath.row];
    if([[dict objectForKey:@"Type"]isEqualToString:@"Data"])
    {
        [self editRowsInTable:indexPath];
    }
    else  if([[dict objectForKey:@"Type"]isEqualToString:@"Button"])
    {
        [self TouchAddChild];
    }
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


#pragma mark edit rows in table

-(void)deleteRowsInTable:(NSIndexPath*)indexPath
{
     //   indexPathCalc=indexPath;
    
 //   NSMutableDictionary *dict=[completeActivityArray objectAtIndex:indexPath.row];
    UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure, you want to delete this child?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertView setBackgroundColor:placeHolderReg];
    [alertView show];
    
//    NSMutableDictionary *dict=[completeActivityArray objectAtIndex:rowNumber];
//   DeleteChildByChildID *deleteChild = [[DeleteChildByChildID alloc] init];
//    [deleteChild initService:@{
//                             @"ChildID":[dict objectForKey:@"ChildID"]
//                             }];
//    [deleteChild setDelegate:self];
//    deleteChild.serviceName=PinWiDeleteChild;
//    [self addLoaderView];
//    
//    NSLog(@"Call service");
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSMutableDictionary *dict=[completeActivityArray objectAtIndex:rowNumber];
        DeleteChildByChildID *deleteChild = [[DeleteChildByChildID alloc] init];
        [deleteChild initService:@{
                                   @"ChildID":[dict objectForKey:@"ChildID"]
                                   }];
        [deleteChild setDelegate:self];
        deleteChild.serviceName=PinWiDeleteChild;
        [self addLoaderView];
        
        NSLog(@"Call service");
    }else{
        
    }
}


-(void)editRowsInTable:(NSIndexPath*)indexPath
{
    
    [self getDetailsofProfile:indexPath];
    
    NSLog(@"Edit rows");
}

-(void)TouchAddChild
{
    NSLog(@" cretae new ChildProfileObject");
    ChildProfileController *viewCtrl=[[ChildProfileController alloc]init];
    viewCtrl.isComingFromNetwork = self.isComingfromNetwork;
    viewCtrl.parentClassName=PinWiCreateNewChild;
    self.title=@"";
//    UIBarButtonItem *newBackButton =
//    [[UIBarButtonItem alloc] initWithTitle:@""
//                                     style:UIBarButtonItemStyleBordered
//                                    target:nil
//                                    action:nil];
//    [[self.navigationController navigationItem] setBackBarButtonItem:newBackButton];
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}
#pragma mark url delegates
-(void)getDetailsofProfile:(NSIndexPath*)indexPath
{
  //  indexPathCalc=indexPath;
    // NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    //ChildProfileObject *child=[[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:indexPath.row];
    
    ChildProfileObject *child=[[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:rowNumber];
    GetAllProfilesDetails *getDetails = [[GetAllProfilesDetails alloc] init];
    [getDetails initService:@{
                              @"ProfileType":@"2",
                              @"ProfileID":child.child_ID
                              }];
    [getDetails setDelegate:self];
    getDetails.serviceName=PinWiGetProfileDetails;
    [self addLoaderView];
}

-(void)loadParentObject:(NSDictionary*)parentDict
{
    
    ChildProfileObject *parentObj=[[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:rowNumber];//[[ChildProfileObject alloc]init];
    parentObj.profile_pic   =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"ProfileImage"]];
    parentObj.firstName     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"FirstName"]];
    parentObj.lastName      =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"LastName"]];
    parentObj.nick_Name     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"NickName"]];
    parentObj.dob           =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"DateOfBirth"]];
    parentObj.gender        =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Gender"]];
    parentObj.school_Name   =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"SchoolName"]];
    parentObj.school_ID     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"SchoolID"]];
    parentObj.passcode      =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Passcode"]];
    parentObj.autolock_Time =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"TimeValue"]];
    parentObj.autolock_ID   =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"AutolockTime"]];
    parentObj.child_ID      =parentObj.child_ID;
    parentObj.parent_ID     =[PC_DataManager sharedManager].parentObjectInstance.parentId;
    
    
    [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles replaceObjectAtIndex:rowNumber withObject:parentObj];
    
    /*    [PC_DataManager sharedManager].parentObjectInstance.image         =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"ProfileImage"]];
     [PC_DataManager sharedManager].parentObjectInstance.firstName     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"FirstName"]];
     [PC_DataManager sharedManager].parentObjectInstance.lastName      =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"LastName"]];
     [PC_DataManager sharedManager].parentObjectInstance.contactNo     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Contact"]];
     [PC_DataManager sharedManager].parentObjectInstance.passcode      =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Passcode"]];
     [PC_DataManager sharedManager].parentObjectInstance.passwd        =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Password"]];
     [PC_DataManager sharedManager].parentObjectInstance.autoLockID    =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"AutolockTime"]];
     [PC_DataManager sharedManager].parentObjectInstance.autoLockTime  =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"AutolockTime"]];
     [PC_DataManager sharedManager].parentObjectInstance.longitute     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Longitude"]];
     [PC_DataManager sharedManager].parentObjectInstance.latitude      =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Latitude"]];
     [PC_DataManager sharedManager].parentObjectInstance.googleAddress =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"GoogleMapAddress"]];
     [PC_DataManager sharedManager].parentObjectInstance.country       =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Country"]];
     [PC_DataManager sharedManager].parentObjectInstance.countryID     =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Country"]];
     [PC_DataManager sharedManager].parentObjectInstance.city          =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"City"]];
     [PC_DataManager sharedManager].parentObjectInstance.cityID        =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"City"]];
     [PC_DataManager sharedManager].parentObjectInstance.neighourRad   =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"NeighbourhoodRadius"]];
     [PC_DataManager sharedManager].parentObjectInstance.neighourID    =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"NeighbourhoodRadius"]];
     [PC_DataManager sharedManager].parentObjectInstance.flatBuilding  =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"FlatNoBuilding"]];
     [PC_DataManager sharedManager].parentObjectInstance.streetLocality=[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"StreetLocality"]];
     */
    
    ChildProfileController *viewCtrl=[[ChildProfileController alloc]init];
    viewCtrl.parentClassName=PinWiGetProfileDetails;
    viewCtrl.childIndex=rowNumber;
    
    self.title=@""; 
//    UIBarButtonItem *newBackButton =
//    [[UIBarButtonItem alloc] initWithTitle:@""
//                                     style:UIBarButtonItemStyleBordered
//                                    target:nil
//                                    action:nil];
//    [[self.navigationController navigationItem] setBackBarButtonItem:newBackButton];
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController pushViewController:viewCtrl animated:YES];
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


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark headerViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
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


@end
