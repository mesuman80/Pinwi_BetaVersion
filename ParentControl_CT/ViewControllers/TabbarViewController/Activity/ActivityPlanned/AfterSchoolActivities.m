//
//  AfterSchoolActivities.m
//  ParentControl_CT
//
//  Created by Priyanka on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AfterSchoolActivities.h"
#import "AfterSchoolActivitiesSubCat.h"
#import "ShowActivityLoadingView.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"

@interface AfterSchoolActivities ()<HeaderViewProtocol,UISearchBarDelegate,UISearchResultsUpdating>
{
    NSMutableArray *completeActivityArray;
//    UIScrollView *scrollView;
    UITableView *afterSchoolActivities;
    UITableViewCell *tableCell;
    AfterSchoolActivitiesSubCat *academics;
    GetAfterSchoolCategoriesByOwnerID  *getAfterSchoolactivity;
    ShowActivityLoadingView *loaderView;
    
    HeaderView *headerView;
    RedLabelView *label;
    int yy;
    
    UISearchController *searchDisplayController;
    BOOL isSearchActive;
    NSArray *filterData;
}
@end

@implementation AfterSchoolActivities

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=appBackgroundColor;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[PC_DataManager sharedManager] getWidthHeight];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawHeaderView];
    [self childNameLabel];
    [self drawTableListView];
  //  [self addSearchBar];
    [self callAfterSchoolList];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // [completeActivityArray removeAllObjects];
    [[PC_DataManager sharedManager].calTableActivitybyDateArray removeAllObjects];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
     [self.navigationController setNavigationBarHidden:YES];
//    if(searchDisplayController)
//    {
//        [searchDisplayController.navigationController setNavigationBarHidden:YES];
//    }
    [searchDisplayController.navigationController setNavigationBarHidden:YES];
     [afterSchoolActivities reloadData];
}
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setCentreImgName:@"activityHeader.png"];
        [headerView setRightType:@""];
        [headerView drawHeaderViewWithTitle:@"Scheduler" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+25*ScreenHeightFactor;
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


#pragma mark child
-(void)childNameLabel
{
    if(!label)
    {
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:self.afterChild.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2+5*ScreenHeightFactor);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:self.afterChild.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2);
        }
        
        [self.view addSubview:label];
        yy+=label.frame.size.height+15*ScreenHeightFactor;
    }
}

#pragma mark draw Table
-(void)drawTableListView
{
    if(!afterSchoolActivities)
    {
        afterSchoolActivities = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
        afterSchoolActivities.backgroundColor=appBackgroundColor;
        afterSchoolActivities .delegate=self;
        afterSchoolActivities.dataSource=self;
        afterSchoolActivities.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:afterSchoolActivities];
    }
}
-(void)callAfterSchoolList
{
    NSDictionary *dict1 = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetAfterSchoolCategoriesByOwnerID"];
    if(dict1)
    {
        [self loadTableDataWith:dict1];
    }else{

                       getAfterSchoolactivity = [[GetAfterSchoolCategoriesByOwnerID alloc] init];
                       [getAfterSchoolactivity initService:@{
                                                             @"OwnerID":@"0"
                                                             }];
                       [getAfterSchoolactivity setDelegate:self];
    [self addLoaderView];
    }
}

-(void)addSearchBar
{
    if(!searchDisplayController)
    {
        searchDisplayController=[[UISearchController alloc]initWithSearchResultsController:nil];
        
        // searchDisplayControl    //searchDisplayController=[[UISearchController alloc]initWithSearchResultsController:self];
        searchDisplayController.delegate =self;// allyTable.delegate;
        [searchDisplayController setSearchResultsUpdater:self];// allyTable.dataSource;
        
        searchDisplayController.searchBar.frame = CGRectMake(0, yy, screenWidth, 44);
        self.definesPresentationContext = YES;
        afterSchoolActivities.tableHeaderView= searchDisplayController.searchBar;
        searchDisplayController.searchBar.delegate = self;
        
        searchDisplayController.dimsBackgroundDuringPresentation = NO;
        [searchDisplayController setHidesNavigationBarDuringPresentation:YES];
    }
}
#pragma mark - UISearchDisplayController Delegate Methods
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //    [label setAlpha:0.0f];
    //    [class setAlpha:0.0f];
    //    [allyHead setAlpha:0.0f];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    filterData = nil;
    isSearchActive = NO;
}

#pragma mark filterArray According To TextEnter
- (void)filterContentForSearchText:(NSString*)searchText
{
    //beginswith[c]
    //contains
    //    NSArray *data = [NSArray arrayWithObject:[NSMutableDictionary dictionaryWithObject:@"foo" forKey:@"CityName"]];
    //    filterData = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CityName == %@)", searchText]];
    if(searchText.length>0)
    {
        isSearchActive=YES;
    }
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"Name beginswith[c] %@",
                           searchText];
    filterData = [completeActivityArray filteredArrayUsingPredicate:filter];
    
    //    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@" contains[c] %@", searchText];
    //    filterData = [cityArray filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"Filter  data=%@",filterData);
    // [allyTable reloadData];
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    if(searchText.length>0)
    {
        isSearchActive=YES;
    }
    else
    {
        isSearchActive=NO;
    }
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"Name beginswith[c] %@",
                           searchText];
    filterData = [completeActivityArray filteredArrayUsingPredicate:filter];
    
    NSLog(@"Filter  data=%@",filterData);
    [afterSchoolActivities reloadData];
}

#pragma mark CONNECTION DELEGATES
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    NSLog(@"error is: %@",errorMessage);
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSLog(@"dictionary  %@", dictionary);
    
    NSDictionary * dict1 = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetAfterSchoolCategoriesByOwnerIDResponse" resultKey:@"GetAfterSchoolCategoriesByOwnerIDResult"];
    
 
    
    [[PC_DataManager sharedManager].serviceDictionary setObject:dict1 forKey:@"GetAfterSchoolCategoriesByOwnerID"];
    
    [self loadTableDataWith:dict1];
    [self removeLoaderView];
}

-(void)loadTableDataWith:(NSDictionary*)dict{
    
    NSLog(@"Country....:   %@", dict);
    completeActivityArray = [[NSMutableArray alloc]init];
    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"After School"}];
    
    
    NSMutableArray *sortArray=(id)dict;
    sortArray= [[PC_DataManager sharedManager]sortArrayWithArray:sortArray withKey:@"Name"];
    
    for (NSDictionary *cityDict in sortArray) {
        [completeActivityArray addObject:cityDict];
    }// Store in the dictionary using the data as the key
    [afterSchoolActivities reloadData];
    
}

-(void)fillCompleteArray
{
    completeActivityArray=[[NSMutableArray alloc] init];
    
    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"After School"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Academics"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Cultural"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Outdoor"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Indoor"}];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearchActive)
    {
        if(filterData.count>0)
        {
            tableView.frame =CGRectMake(0,yy+12*ScreenHeightFactor, screenWidth, screenHeight-yy);
            return filterData.count;
            
        }
        else
        {
            return 0;
        }
    }
    isSearchActive=NO;
    filterData = nil;

    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    if(indexPath.row==0)
    {
        return ScreenHeightFactor*30;
    }
    else if(indexPath.row< [completeActivityArray count])
    {
        return ScreenHeightFactor*42;
    }
//    if([[data valueForKey:@"key"] isEqualToString:@"banner1"] )
//    {
//        return 30;
//    }
//    if([[data valueForKey:@"key"] isEqualToString:@"banner2"] )
//    {
//        return 40;
//    }
//    
    else
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Add New Activity ";
    
    NSDictionary  *dictionary ;
    if(filterData.count>0)
    {
        dictionary =[filterData objectAtIndex:indexPath.row];
        
    }
    else
    {
        dictionary = [completeActivityArray objectAtIndex:indexPath.row];
    }
    
    TextAndDescTextCell *cell;//=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor=appBackgroundColor;

    if(indexPath.row==0 && filterData.count==0)
    {
//        cell.textLabel.text = @"After School";
//        cell.textLabel.textColor=activityHeading1FontCode;
        
        [cell addText:@"After School" andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
        
//        cell.textLabel1.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
        cell.backgroundColor=activityHeading1Code;
    }
    else
    {
        
       // NSDictionary  *dictionary  = [completeActivityArray objectAtIndex:indexPath.row];
//        cell.textLabel.text = [dictionary valueForKey:@"Name"];
//        cell.textLabel.textColor=textBlueColor;
//        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
        
        [cell addText:[dictionary valueForKey:@"Name"] andDesc:@"" withTextColor:textBlueColor andDecsColor:cellTextColor andType:@""];
        
        if(![self.parentClass isEqualToString:@"CustomActivitiesViewController"])
        {
            cell.arrowImageView.alpha=1.0f;
//            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"%@",tableCell.textLabel.text);
//    if([tableCell.textLabel.text isEqualToString: @"Academics"])
//    {
//        academics=[[AcademicsRotation alloc]init];
//        [self.navigationController pushViewController:academics animated:YES];
//        
//    }
    
    NSDictionary  *dictionary;
    if(filterData.count>0)
    {
        [searchDisplayController.navigationController setNavigationBarHidden:YES];
        dictionary = [filterData objectAtIndex:indexPath.row];
        academics=[[AfterSchoolActivitiesSubCat alloc]init];
        academics.afterChild=self.afterChild;
        [academics setTabBarCtlr:self.tabBarCtlr];
        academics.catIndex=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"CategoryID"]];
        academics.catName=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Name"]];
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        [self.navigationController pushViewController:academics animated:YES];

        
    }
    else
    {
        dictionary=[completeActivityArray objectAtIndex:indexPath.row];
    }
    
    if(indexPath.row!=0 && filterData.count==0)
    {
       // NSDictionary  *dictionary  = [completeActivityArray objectAtIndex:indexPath.row];
        if([self.parentClass isEqualToString:@"CustomActivitiesViewController"])
        {
            [self.afterSchoolActivitiesDelegate catagoryID:[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"CategoryID"]] andName:[dictionary valueForKey:@"Name"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
        academics=[[AfterSchoolActivitiesSubCat alloc]init];
        academics.afterChild=self.afterChild;
            [academics setTabBarCtlr:self.tabBarCtlr];
        academics.catIndex=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"CategoryID"]];
        academics.catName=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Name"]];
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
       [self.navigationController pushViewController:academics animated:YES];
        }
    }
    
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
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
