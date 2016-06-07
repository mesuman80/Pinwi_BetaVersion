//
//  CityTableViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 28/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CityTableViewController.h"
#import "GetCityListService.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"
@interface CityTableViewController ()<HeaderViewProtocol,UISearchBarDelegate,UISearchResultsUpdating>

@end

@implementation CityTableViewController
{
    
    UITableView *cityTableView;
    UISearchBar *searchBar;
    GetCityListService *getCity;
    UISearchController *searchDisplayController;
    NSMutableArray *cityArray;
     NSArray *filterData;
    ShowActivityLoadingView *loaderView;
    BOOL isSearchActive;
    HeaderView *headerView;
    int yy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ [PC_DataManager  sharedManager] getWidthHeight];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:appBackgroundColor];
    [self drawHeaderView];
    
    cityTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    cityTableView.backgroundColor=appBackgroundColor;
    cityTableView.frame =CGRectMake(0,yy, screenWidth, screenHeight-yy);
    cityTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    cityTableView .delegate=self;
    cityTableView.dataSource=self;
    
    [self.view addSubview:cityTableView];
    [self addSearchBar];
    [self getCityList];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:YES];
    if(searchDisplayController)
    {
        [searchDisplayController.navigationController setNavigationBarHidden:YES];
    }
}
-(void)addSearchBar
{
//    searchBar=[[UISearchBar alloc]init];
//    [searchBar setShowsScopeBar:YES];
//    searchBar.delegate = self;
//    searchBar.placeholder=@"Search";
//    searchBar.searchBarStyle = UISearchBarStyleDefault;
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    
    searchDisplayController=[[UISearchController alloc]initWithSearchResultsController:nil];
   
   // searchDisplayControl    //searchDisplayController=[[UISearchController alloc]initWithSearchResultsController:self];
    searchDisplayController.delegate =self;// allyTable.delegate;
    [searchDisplayController setSearchResultsUpdater:self];// allyTable.dataSource;
    
    searchDisplayController.searchBar.frame = CGRectMake(0, yy, screenWidth, 44);
    self.definesPresentationContext = YES;
    cityTableView.tableHeaderView= searchDisplayController.searchBar;
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


-(void) getCityList
{
    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetCityList"];
    if(dict)
    {
        [self loadTableDataWith:dict];
    }else{
    getCity = [[GetCityListService alloc] init];
    [getCity initService:@{
                           @"CountryID":[PC_DataManager sharedManager].parentObjectInstance.countryID
                           }];
    [getCity setDelegate:self];
         [self addLoaderView];
    }
   
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSLog(@"dict:\t %@",dictionary);
    
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetCityListResponse" resultKey:@"GetCityListResult"];
    
    [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:@"GetCityList"];
    
    [self loadTableDataWith:dict];
     [self removeLoaderView];
}

-(void)loadTableDataWith:(NSDictionary*)dict{
    
    NSLog(@"Country....:   %@", dict);
    cityArray = [[NSMutableArray alloc]init];
    for (NSDictionary *cityDict in dict) {
        [cityArray addObject:cityDict];
    }// Store in the dictionary using the data as the key
    
    
    cityArray=[[PC_DataManager sharedManager]sortArrayWithArray:cityArray withKey:@"CityName"];
    
    [loaderView removeLoaderView];
    [cityTableView reloadData];
   
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
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"CityName beginswith[c] %@",
                           searchText];
    filterData = [cityArray filteredArrayUsingPredicate:filter];
    
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
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"CityName beginswith[c] %@",
                           searchText];
    filterData = [cityArray filteredArrayUsingPredicate:filter];
    
    //    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@" contains[c] %@", searchText];
    //    filterData = [cityArray filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"Filter  data=%@",filterData);
     [cityTableView reloadData];
    
    
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
    //[self filterContentForSearchText:searchBar.text];
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
   // cityTableView.frame =CGRectMake(0,yy, screenWidth, screenHeight-yy);
    return cityArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    TextAndDescTextCell *cell;
    cell=[cityTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary  *dictionary;
    NSLog(@" city Array %@ ", cityArray);
    
    // Configure the cell...
    if(filterData.count>0)
    {
        dictionary =[filterData objectAtIndex:indexPath.row];
    }
    else
    {
        dictionary = [cityArray objectAtIndex:indexPath.row];
    }

    [cell addText:[dictionary valueForKey:@"CityName"] andDesc:@"" withTextColor:cellTextColor andDecsColor:cellTextColor andType:@""];
    cell.backgroundColor=[UIColor clearColor];
//    cell.textLabel.text = [dictionary valueForKey:@"CityName"];
//    cell.backgroundColor=[UIColor clearColor];
//    cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    return cell;
    
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dictionary;
    if(filterData.count>0)
    {
        dictionary = [filterData objectAtIndex:indexPath.row];
        [searchDisplayController.navigationController setNavigationBarHidden:YES];
    }
    else
    {
        dictionary=[cityArray objectAtIndex:indexPath.row];
    }
    NSLog(@"Value of dictionary =%@",dictionary);
    [self.cityListDelegate selectedCity:[dictionary objectForKey:@"CityName"] andId:[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"CityID"]]];
    //[self dismissViewControllerAnimated:YES completion:nil];
    // [self popoverPresentationController];
    [self.navigationController popViewControllerAnimated:YES];
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
#define HeaderViewSpecific Function
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"Location_header.png"];
        [headerView drawHeaderViewWithTitle:@"Cities" isBackBtnReq:YES BackImage:@"leftArrow.png"];
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
