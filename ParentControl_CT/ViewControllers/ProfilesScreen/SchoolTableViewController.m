//
//  CountryTableViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 28/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "SchoolTableViewController.h"
#import "GetSchoolNamesByParentID.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"
@interface SchoolTableViewController ()<HeaderViewProtocol,UISearchBarDelegate,UISearchResultsUpdating>

{
    UITableView *countryTableView;
    GetSchoolNamesByParentID *getSchoolList;
    NSMutableArray *countryArray;
    UISearchBar *searchBar;
    UISearchController *searchDisplayController;
     NSArray *filterData;
    ShowActivityLoadingView *loaderView;
    BOOL isSearchActive;
    HeaderView *headerView;
    int yy;
    
    UIViewController* dummyCtrl;
    
}

@end

@implementation SchoolTableViewController
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=appBackgroundColor;
    
    [[PC_DataManager sharedManager]getWidthHeight];
    [self drawHeaderView];
    countryTableView = [[UITableView alloc]init];
    countryTableView.backgroundColor=appBackgroundColor;
    countryTableView.frame =CGRectMake(0,yy, screenWidth, screenHeight-yy);
    countryTableView .delegate=self;
    countryTableView.dataSource=self;
    self.view.backgroundColor=appBackgroundColor;
    countryTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:countryTableView];
    
    [self addSearchBar];
    [self getCountryList];
}

-(void)drawDummyCtrl
{
    dummyCtrl=[[UIViewController alloc]init];
    
}

-(void)addSearchBar
{
    searchDisplayController=[[UISearchController alloc]initWithSearchResultsController:nil];
    
    // searchDisplayControl    //searchDisplayController=[[UISearchController alloc]initWithSearchResultsController:self];
    searchDisplayController.delegate =self;// allyTable.delegate;
    [searchDisplayController setSearchResultsUpdater:self];// allyTable.dataSource;
    
    searchDisplayController.searchBar.frame = CGRectMake(0, yy, screenWidth, 44);
    self.definesPresentationContext = YES;
    countryTableView.tableHeaderView= searchDisplayController.searchBar;
    searchDisplayController.searchBar.delegate = self;
    
    searchDisplayController.dimsBackgroundDuringPresentation = NO;
    [searchDisplayController setHidesNavigationBarDuringPresentation:YES];

}

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

-(void) getCountryList
{
    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetSchoolNamesByParentID"];
    if(dict)
    {
        [self loadTableDataWith:dict];
    }else{
    getSchoolList = [[GetSchoolNamesByParentID alloc] init];
    [getSchoolList initService:@{
                                 @"ParentID":[PC_DataManager sharedManager].parentObjectInstance.parentId
                                 }];
    [getSchoolList setDelegate:self];

    [self addLoaderView];
    }
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetSchoolNamesByParentIDResponse" resultKey:@"GetSchoolNamesByParentIDResult"];
    if(dict)
    {
    [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:@"GetSchoolNamesByParentID"];
    
    [self loadTableDataWith:dict];
    }
    [self removeLoaderView];
    
}

-(void)loadTableDataWith:(NSDictionary*)dict{
    
    NSLog(@"Country....:   %@", dict);
    countryArray = [[NSMutableArray alloc]init];
    for (NSDictionary *cityDict in dict) {
        [countryArray addObject:cityDict];
    }// Store in the dictionary using the data as the key
    
    countryArray=[[PC_DataManager sharedManager]sortArrayWithArray:countryArray withKey:@"SchoolName"];
    
    [loaderView removeLoaderView];
    [countryTableView reloadData];
    
}

#pragma mark filterArray According To TextEnter
//- (void)filterContentForSearchText:(NSString*)searchText
//{
//    //beginswith[c]
//    //contains
//    //    NSArray *data = [NSArray arrayWithObject:[NSMutableDictionary dictionaryWithObject:@"foo" forKey:@"CityName"]];
//    //    filterData = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CityName == %@)", searchText]];
//    if(searchText.length>0)
//    {
//        isSearchActive=YES;
//    }
//    NSPredicate *filter = [NSPredicate predicateWithFormat:@"SchoolName beginswith[c] %@",
//                           searchText];
//    filterData = [countryArray filteredArrayUsingPredicate:filter];
//    
//    //    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@" contains[c] %@", searchText];
//    //    filterData = [cityArray filteredArrayUsingPredicate:resultPredicate];
//    NSLog(@"Filter  data=%@",filterData);
//    // [allyTable reloadData];
//}

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
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"SchoolName beginswith[c] %@",
                           searchText];
    filterData = [countryArray filteredArrayUsingPredicate:filter];
    
    //    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@" contains[c] %@", searchText];
    //    filterData = [cityArray filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"Filter  data=%@",filterData);
    [countryTableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScreenHeightFactor*42;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
   // [self filterContentForSearchText:searchBar.text];
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

    return countryArray .count;

}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TextAndDescTextCell *cell;
     NSDictionary  *dictionary;
    cell=[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if(filterData.count>0)
    {
        dictionary =[filterData objectAtIndex:indexPath.row];
    }
    else
    {
        dictionary = [countryArray objectAtIndex:indexPath.row];
    }

    NSLog(@" country Array %@ ", countryArray);
    [cell addText:[dictionary valueForKey:@"SchoolName"] andDesc:@"" withTextColor:cellTextColor andDecsColor:cellTextColor andType:@""];
    cell.backgroundColor=[UIColor clearColor];
    // Configure the cell...
    //NSDictionary  *dictionary  = [countryArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = [dictionary valueForKey:@"SchoolName"];
//    cell.backgroundColor=[UIColor clearColor];
//    cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
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
    
}


#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary  *dictionary;
    if(filterData.count>0)
    {
        dictionary = [filterData objectAtIndex:indexPath.row];
    }
    else
    {
        dictionary=[countryArray objectAtIndex:indexPath.row];
    }

    //[self.cou selectedCity:[dictionary objectForKey:@"CityName"] andId:[dictionary objectForKey:@"CityID"]];
   // [self.countryListDelegate selectedCountry:[@"CountryName" ] andId:[dictionary objectForKey:@"CountryID"]];
    [self.schoolListDelegate selectedSchool: [dictionary objectForKey:@"SchoolName"] andId:[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"SchoolID"] ]];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
        [headerView drawHeaderViewWithTitle:@"Schools" isBackBtnReq:YES BackImage:@"leftArrow.png"];
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
    //[self touchAtPinwiWheel];
}


@end
