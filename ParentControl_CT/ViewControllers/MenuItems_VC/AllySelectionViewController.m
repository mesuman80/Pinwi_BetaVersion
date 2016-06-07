//
//  InformAllyViewController.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AllySelectionViewController.h"
#import "InformAllyDetailViewController.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"
#import "StripView.h"
#import "TextAndDescTextCell.h"
@interface AllySelectionViewController ()<HeaderViewProtocol>

@end

@implementation AllySelectionViewController
{
    NSMutableArray *completeActivityArray;
    //  UIScrollView  *scrollView;
    UITableViewCell *tableCell;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *allyDummy;
    
    int yy;
    NSArray *filterData;
    //NSArray *actualData;
    NSString *textFieldString;
    UITableView *searchTableView;
  
    BOOL isSearchActive;
    ShowActivityLoadingView *loaderView;
    UILabel *allyHead;
    UIButton *addButton;
    
    NSIndexPath *indexPathCalc;
    
    UIImageView *centerIcon;
    HeaderView *headerView;
    
}
@synthesize allyTableSelection;



- (void)viewDidLoad {
    [super viewDidLoad];

//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    [[PC_DataManager sharedManager] getWidthHeight];
    self.view.backgroundColor=appBackgroundColor;
    [self drawHeaderView];
    [self addLabels];
   // int h=self.tabBarController.tabBar.frame.size.height;
    allyTableSelection = [[UITableView alloc]init];
    allyTableSelection.backgroundColor=appBackgroundColor;
    allyTableSelection.frame =CGRectMake(0,yy, screenWidth, screenHeight-yy);
    allyTableSelection .delegate=self;
    allyTableSelection.dataSource=self;
    allyTableSelection.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:allyTableSelection];
    
    //[self addSearchBar];
    
    

    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title=@"Allies";
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    [self drawCenterIcon];
//    UIBarButtonItem *newBackButton =
//    [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                     style:UIBarButtonItemStyleBordered
//                                    target:nil
//                                    action:nil];
//    [[self.navigationController navigationItem] setBackBarButtonItem:newBackButton];
    [self getAllyList];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [centerIcon removeFromSuperview];
    centerIcon=nil;
}


-(void) getAllyList
{
    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:PinWiGetAllies];
    if(dict)
    {
        NSArray *arr=(NSArray*)dict;
        NSMutableDictionary *checkDict=[[arr firstObject]mutableCopy];
        if([[checkDict objectForKey:@"ErrorDesc"]isEqualToString:@"No Ally found."])
        {
            completeActivityArray=[[NSMutableArray alloc]init];
            NSMutableDictionary *makeDict=[[NSMutableDictionary alloc]init];
            [makeDict setObject:@"Button" forKey:@"Type"];
            [completeActivityArray addObject:makeDict];
           // [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self loadTableDataWith:dict];
        }
    }else{
        //ChildProfileObject *child=[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.firstObject;
       GetListofAllysByParentID *allyList = [[GetListofAllysByParentID alloc] init];
        [allyList initService:@{
                                @"ParentID":[PC_DataManager sharedManager].parentObjectInstance.parentId
                                }];
        [allyList setDelegate:self];
        allyList.serviceName=PinWiGetAllies;
        [self addLoaderView];
    }
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
    else if ([connection.serviceName isEqualToString:PinWiDeleteAlly])
    {
        [completeActivityArray removeObjectAtIndex:indexPathCalc.row];
        [allyTableSelection reloadData];
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:PinWiGetAllies];
    }
    else if ([connection.serviceName isEqualToString:PinWiGetAllies])
    {
    
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetListofAllysByParentIDResponse" resultKey:@"GetListofAllysByParentIDResult"];
    NSLog(@"dict:\t %@",dict);
    
    if(!dict)
    {
        return;
    }
    
    [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:PinWiGetAllies];
    
    [self loadTableDataWith:dict];
    }
    [self removeLoaderView];
}

-(void)loadTableDataWith:(NSDictionary*)dict1{
    
    NSLog(@"Country....:   %@", dict1);
    NSArray *dict=(NSArray*)dict1;
    completeActivityArray = [[NSMutableArray alloc]init];
    [[PC_DataManager sharedManager].parentObjectInstance.allyProfiles removeAllObjects];
    NSMutableDictionary *makeDict = nil;
    
    if([[dict firstObject]objectForKey:@"ErrorDesc"])
    {
        NSLog(@"No ally found");
    }
       else{
    for (NSMutableDictionary *cityDict in dict)
    {
        AllyProfileObject *parentObj=[[AllyProfileObject alloc]init];
        parentObj.firstName         =[NSString stringWithFormat:@"%@",[cityDict objectForKey:@"FirstName"]];
        parentObj.ally_ID           =[NSString stringWithFormat:@"%@",[cityDict objectForKey:@"AllyID"]];
        parentObj.parent_ID         =[PC_DataManager sharedManager].parentObjectInstance.parentId;
  
        [[PC_DataManager sharedManager].parentObjectInstance.allyProfiles addObject:parentObj];
        
        
        makeDict=[[NSMutableDictionary alloc]init];
        [makeDict setObject:@"Data" forKey:@"Type"];
        [makeDict setObject:[NSString stringWithFormat:@"%@",[cityDict objectForKey:@"FirstName"]] forKey:@"AllyName"];
        [makeDict setObject:[NSString stringWithFormat:@"%@",[cityDict objectForKey:@"AllyID"]] forKey:@"AllyID"];
        [completeActivityArray addObject:makeDict];
    }// Store in the dictionary using the data as the key
    }
    makeDict=[[NSMutableDictionary alloc]init];
    [makeDict setObject:@"Button" forKey:@"Type"];
    [completeActivityArray addObject:makeDict];
    
    [loaderView removeLoaderView];
    [allyTableSelection reloadData];
    
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
    allyTableSelection.tableHeaderView=searchBar;
    
}



-(void)addLabels
{
    StripView *strip=[[StripView alloc]initWithFrame:CGRectMake(0, yy, screenWidth, ScreenHeightFactor*30)];
    [strip drawStrip:@"" color:activityHeading1Code];
    [self.view addSubview:strip];
    
    allyHead=[[UILabel alloc]init];
    
    NSString *str=@"ALLY";
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

-(void)viewDidAppear:(BOOL)animated
{
    [allyTableSelection reloadData];
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
    //[allyHead setAlpha:0.0f];
    //  allyTable.frame =CGRectMake(0, 0, screenWidth, screenHeight);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
    //[allyHead setAlpha:1.0f];
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
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"AllyName contains[c] %@", searchText];
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
    [allyTableSelection setEditing:editing animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSMutableDictionary *dict=[completeActivityArray objectAtIndex:indexPath.row];
    if([[dict objectForKey:@"Type"]isEqualToString:@"Data"])
    {
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [self editRowsInTable:indexPath];
            NSLog(@"Edit");
        }];
        
        editAction.backgroundColor = [UIColor lightGrayColor];
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [self deleteRowsInTable:indexPath];
        }];
        
        //deleteAction.backgroundColor=[UIColor redColor];
        
        return @[deleteAction, editAction];
    }
    return nil;
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    filterData =nil;
    [allyHead setAlpha:1.0f];
}

#pragma mark - Table view data source



//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    // Return the number of rows in the section.
//    return completeActivityArray.count;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //  CGFloat height =  screenHeight*.1;
    return ScreenHeightFactor*42;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AllyCellIdentifier = @"AllyCell";
    static NSString *ButtonCellIdentifier = @"ButtonCell";
    
    TextAndDescTextCell *cell;// = [tableView dequeueReusableCellWithIdentifier:@"InformAllyCell" forIndexPath:indexPath];
    
    NSMutableDictionary *dict=[completeActivityArray objectAtIndex:indexPath.row];
    
    if([[dict objectForKey:@"Type"]isEqualToString:@"Data"])
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:AllyCellIdentifier];
        if(!cell)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AllyCellIdentifier];
        }
        NSDictionary *dict;
        cell.textLabel.textColor=activityHeading1FontCode;
        if(filterData.count>0)
        {
            dict=[filterData objectAtIndex:indexPath.row];
           // cell.textLabel.text=[dict objectForKey:@"AllyName"];
        }
        else
        {
            dict= [completeActivityArray objectAtIndex:indexPath.row];
           // cell.textLabel.text=[data objectForKey:@"AllyName"];
        }
        [cell addText:[dict objectForKey:@"AllyName"] andDesc:@"" withTextColor:cellBlackColor_5 andDecsColor:cellTextColor andType:@""];
        //cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
        cell.textLabel.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.5f];
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
            [cell addText:@"Add New Ally" andDesc:@"" withTextColor:textBlueColor andDecsColor:cellTextColor andType:@""];
            
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
            cell.userInteractionEnabled=YES;
            [cell.textlabel1 setCenter:CGPointMake(cell.textlabel1.center.x+cell.arrowImageView.frame.size.width+cellPadding, cell.textlabel1.center.y)];
//            addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//            addButton.tintColor=textBlueColor;
//            if(screenWidth>700)
//            {
//                addButton.frame= CGRectMake(cellPadding, 12.5*ScreenHeightFactor,10*ScreenWidthFactor, 10*ScreenWidthFactor);
//            }
//            else
//            {
//                addButton.frame= CGRectMake(cellPadding, 15*ScreenHeightFactor,10*ScreenWidthFactor, 10*ScreenWidthFactor);
//            }
//            addButton.center=CGPointMake(addButton.center.x,ScreenHeightFactor*20);
//            [addButton addTarget:self action:@selector(TouchAddChild) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:addButton];
            
//            [cell addText:@"Add another Ally's profile" andDesc:@"" withTextColor:textBlueColor andDecsColor:cellTextColor andType:@""];
//            [cell.textlabel1 setCenter:CGPointMake(cell.textlabel1.center.x+cellPadding, cell.textlabel1.center.y)];
        }
    }
    
    cell.backgroundColor=appBackgroundColor;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
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


#pragma mark allyDetail
-(void)sendAllyName:(NSString *)allyName andId:(NSString *)allyId andAllyObj:(AllyProfileObject *)allyObj
{
    [self.navigationController popViewControllerAnimated:YES];
   // [self.informAllyDelegate sendAllyName:allyName andId:allyId andAllyObj:allyObj];
    
}

#pragma mark edit rows in table

-(void)deleteRowsInTable:(NSIndexPath*)indexPath
{
    indexPathCalc=indexPath;
    NSMutableDictionary *dict=[completeActivityArray objectAtIndex:indexPath.row];
    DeleteAllyByAllyID *deleteAlly = [[DeleteAllyByAllyID alloc] init];
    [deleteAlly initService:@{
                               @"AllyID":[dict objectForKey:@"AllyID"]
                               }];
    [deleteAlly setDelegate:self];
    deleteAlly.serviceName=PinWiDeleteAlly;
    [self addLoaderView];
    
}

-(void)editRowsInTable:(NSIndexPath*)indexPath
{
    
    [self getDetailsofProfile:indexPath];
    
    NSLog(@"Edit rows");
}

-(void)TouchAddChild
{
    self.title=@"";
    NSLog(@" cretae new ChildProfileObject");
    AllyProfileController *viewCtrl=[[AllyProfileController alloc]init];
    viewCtrl.parentClassName=PinWiCreateNewAlly;
    viewCtrl.allyIndex=(int)indexPathCalc.row;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}
#pragma mark url delegates
-(void)getDetailsofProfile:(NSIndexPath*)indexPath
{
    indexPathCalc=indexPath;
    NSMutableDictionary *dict=[completeActivityArray objectAtIndex:indexPath.row];
    //AllyProfileObject *ally=[[PC_DataManager sharedManager].parentObjectInstance.allyProfiles objectAtIndex:indexPath.row];
    
    GetAllProfilesDetails *getDetails = [[GetAllProfilesDetails alloc] init];
    [getDetails initService:@{
                              @"ProfileType":@"3",
                              @"ProfileID":[dict objectForKey:@"AllyID"]
                              }];
    [getDetails setDelegate:self];
    getDetails.serviceName=PinWiGetProfileDetails;
    [self addLoaderView];
}

-(void)loadParentObject:(NSDictionary*)parentDict
{
    
    AllyProfileObject *parentObj=[[PC_DataManager sharedManager].parentObjectInstance.allyProfiles objectAtIndex:indexPathCalc.row];//[[ChildProfileObject alloc]init];
    
    //AllyProfileObject *parentObj=[[AllyProfileObject alloc]init];
    parentObj.profilePic        =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"ProfileImage"]];
    parentObj.firstName         =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"FirstName"]];
    parentObj.lastName          =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"LastName"]];
    parentObj.emailAdd          =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"EmailAddress"]];
    parentObj.contact_no        =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Contact"]];
    parentObj.relationship      =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"RelationshipName"]];
    parentObj.relationship_ID   =[NSString stringWithFormat:@"%@",[parentDict objectForKey:@"Relationship"]];
    parentObj.ally_ID           =parentObj.ally_ID;
    parentObj.parent_ID         =[PC_DataManager sharedManager].parentObjectInstance.parentId;
    
    
    [[PC_DataManager sharedManager].parentObjectInstance.allyProfiles replaceObjectAtIndex:indexPathCalc.row withObject:parentObj];
    
    
    AllyProfileController *viewCtrl=[[AllyProfileController alloc]init];
    viewCtrl.parentClassName=PinWiGetProfileDetails;
    viewCtrl.allyIndex=(int)indexPathCalc.row;
    
//    UIBarButtonItem *newBackButton =
//    [[UIBarButtonItem alloc] initWithTitle:@""
//                                     style:UIBarButtonItemStyleBordered
//                                    target:nil
//                                    action:nil];
//    [[self.navigationController navigationItem] setBackBarButtonItem:newBackButton];
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    self.title=@"";
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

@end
