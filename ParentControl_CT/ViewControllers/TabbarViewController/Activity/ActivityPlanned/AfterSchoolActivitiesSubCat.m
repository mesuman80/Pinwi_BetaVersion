//
//  AfterSchoolActivities.m
//  ParentControl_CT
//
//  Created by Priyanka on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AfterSchoolActivitiesSubCat.h"
#import "AcademicsRotation.h"
#import "ShowActivityLoadingView.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"

@interface AfterSchoolActivitiesSubCat ()<HeaderViewProtocol,UISearchBarDelegate,UISearchResultsUpdating>
{
    NSMutableArray *completeActivityArray;
  //  UIScrollView *scrollView;
    UITableView *afterSchoolActivities;
    UITableViewCell *tableCell;
    AcademicsRotation *academics;
    GetCategoriesAndSubCategories  *getAfterSchoolactivity;
    ShowActivityLoadingView *loaderView;
    HeaderView *headerView;
    RedLabelView *label;
    int yy;
    
    UISearchController *searchDisplayController;
    BOOL isSearchActive;
    NSArray *filterData;
}
@end

@implementation AfterSchoolActivitiesSubCat

- (void)viewDidLoad {
    [super viewDidLoad];
[self.navigationController setNavigationBarHidden:YES];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor=appBackgroundColor;
    [[PC_DataManager sharedManager] getWidthHeight];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self drawHeaderView];
    [self childNameLabel];
    [self drawTableListView];
   // [self addSearchBar];
    [self callAfterSchoolList];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [afterSchoolActivities reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
   [searchDisplayController.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
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
    NSDictionary *dict1 = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetCategoriesAndSubCategories"];
//    if(dict1)
//    {
//        [self loadTableDataWith:dict1];
//    }else{
                       getAfterSchoolactivity = [[GetCategoriesAndSubCategories alloc] init];
                       [getAfterSchoolactivity initService:@{
                                                             @"OwnerCategoryID":self.catIndex
                                                             }];
                       [getAfterSchoolactivity setDelegate:self];
    [self addLoaderView];
//    }
}

#pragma mark Search bar
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
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"CategoryName beginswith[c] %@",
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
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"CategoryName beginswith[c] %@",
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
    
    NSDictionary * dict1 = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetCategoriesAndSubCategoriesResponse" resultKey:@"GetCategoriesAndSubCategoriesResult"];
    
 //   [[PC_DataManager sharedManager].serviceDictionary setObject:dict1 forKey:@"GetCategoriesAndSubCategories"];
    
    [self loadTableDataWith:dict1];
    [self removeLoaderView];
}

-(void)loadTableDataWith:(NSDictionary*)dict{
    
    NSLog(@"Country....:   %@", dict);
    completeActivityArray = [[NSMutableArray alloc]init];
    self.catName=[self.catName uppercaseString];
    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"After School"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":self.catName}];
    
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
    
    if(indexPath.row==0 || indexPath.row==1)
    {
        return ScreenHeightFactor*30;
    }
    else
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
//        cell.backgroundColor=activityHeading1Code;
//        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
          [cell addText:@"After School" andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
        
        cell.backgroundColor=activityHeading1Code;
    }
   else if(indexPath.row==1 && filterData.count==0)
    {
//        cell.textLabel.text = [[completeActivityArray objectAtIndex:indexPath.row] objectForKey:@"value"];
//        cell.backgroundColor=activityHeading2Code;
//         cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
          [cell addText:[[completeActivityArray objectAtIndex:indexPath.row] objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading2FontCode andDecsColor:cellTextColor andType:@"Banner"];
        cell.backgroundColor=activityHeading2Code;
    }
    else
    {
        
//        NSDictionary  *dictionary  = [completeActivityArray objectAtIndex:indexPath.row];
//        cell.textLabel.text = [dictionary valueForKey:@"CategoryName"];
//        cell.textLabel.textColor=textBlueColor;
//         cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
        [cell addText:[dictionary valueForKey:@"CategoryName"] andDesc:@"" withTextColor:textBlueColor andDecsColor:cellTextColor andType:@""];
        cell.backgroundColor=appBackgroundColor;
        if(![self.parentClass isEqualToString:@"CustomActivitiesViewController"])
        {
            cell.arrowImageView.alpha=1.0f;
       // [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary  *dictionary;
    if(filterData.count>0)
    {
        [searchDisplayController.navigationController setNavigationBarHidden:YES];
        dictionary = [filterData objectAtIndex:indexPath.row];
        
        academics=[[AcademicsRotation alloc]init];
        academics.child=self.afterChild;
        [academics setTabBarCtlr:self.tabBarCtlr];
        academics.categoryName = self.catName;
        academics.indexVal=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"CategoryID"]];
        academics.activityName=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"CategoryName"]];
        academics.categoryId = self.catIndex;
        academics.subCategoryId = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"CategoryID"]];
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

    
    
    if(indexPath.row>1 && filterData.count==0)
    {
        NSDictionary  *dictionary  = [completeActivityArray objectAtIndex:indexPath.row];
        if([self.parentClass isEqualToString:@"CustomActivitiesViewController"])
        {
            [self.AfterSchoolSubCatDelegate subCatagoryID:[dictionary valueForKey:@"CategoryID"] andName:[dictionary valueForKey:@"CategoryName"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
        academics=[[AcademicsRotation alloc]init];
        academics.child=self.afterChild;
        [academics setTabBarCtlr:self.tabBarCtlr];
        academics.categoryName = self.catName;
        academics.indexVal=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"CategoryID"]];
        academics.activityName=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"CategoryName"]];
        academics.subCategoryId = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"CategoryID"]];
            academics.categoryId = self.catIndex;
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
