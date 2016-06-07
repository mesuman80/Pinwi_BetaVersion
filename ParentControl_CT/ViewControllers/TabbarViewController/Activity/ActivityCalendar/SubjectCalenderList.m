//
//  SubjectCalenderList.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 11/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "SubjectCalenderList.h"
#import "RedLabelView.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"
#import "RedLabelView.h"
#import "TextAndDescTextCell.h"

@interface SubjectCalenderList() <HeaderViewProtocol,UISearchBarDelegate,UISearchResultsUpdating>

@end

@implementation SubjectCalenderList
{
    // JUST COPY THESE 2 METHODS
    UIImageView *img;
    NSMutableArray *subjects;
    int subCounter, waitCnt;
    
    GetSubjectActivities *getSubjectActivities;
    ShowActivityLoadingView *loaderView;
    HeaderView *headerView;
    RedLabelView *label;
    int yy;
    
    UISearchController *searchDisplayController;
    BOOL isSearchActive;
    NSArray *filterData;
}

@synthesize child;
@synthesize subListTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[PC_DataManager sharedManager]getWidthHeight];
    
    self.view.backgroundColor=appBackgroundColor;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawHeaderView];
    [self childNameLabel];
    [self drawTableListView];
    [self addSearchBar];
    [self getSubjects];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // [completeActivityArray removeAllObjects];
    [self.navigationController setNavigationBarHidden:YES];
    [[PC_DataManager sharedManager].calTableActivitybyDateArray removeAllObjects];
    if(searchDisplayController)
    {
        searchDisplayController.searchBar.text = @"";
        [searchDisplayController.searchBar resignFirstResponder];
        searchDisplayController.active=NO;
         [searchDisplayController.navigationController setNavigationBarHidden: YES animated: NO];
        [searchDisplayController.navigationController setNavigationBarHidden:YES];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // [calendarTable reloadData];
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
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:self.child.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2+5*ScreenHeightFactor);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:self.child.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2);
        }
        
        [self.view addSubview:label];
        yy+=label.frame.size.height+15*ScreenHeightFactor;
    }
}

#pragma mark draw Table
-(void)drawTableListView
{
    if(!subListTable)
    {
        subListTable = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
        subListTable.backgroundColor=appBackgroundColor;
        subListTable .delegate=self;
        subListTable.dataSource=self;
        subListTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:subListTable];
    }
}

// JUST COPY THESE 2 METHODS

-(void)getSubjects
{
    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetSubjectActivities"];
    if(dict)
    {
        [self loadTableDataWith:dict];
    }else{
        
        getSubjectActivities=[[GetSubjectActivities alloc]init];
        
        [getSubjectActivities initService:@{
                                            
                                            }];
        
        [getSubjectActivities setDelegate:self];
        [self addLoaderView];
    }
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
    subListTable.tableHeaderView= searchDisplayController.searchBar;
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
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"SubjectName contains[c] %@",
                           searchText];
    filterData = [subjects filteredArrayUsingPredicate:filter];
    
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
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"SubjectName contains[c] %@",
                           searchText];
    filterData = [subjects filteredArrayUsingPredicate:filter];

    NSLog(@"Filter  data=%@",filterData);
    [subListTable reloadData];
}



#pragma mark CONNECTION DELEGATES

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
    
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetSubjectActivitiesResponse" resultKey:@"GetSubjectActivitiesResult"];
    [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:@"GetSubjectActivities"];
    [self loadTableDataWith:dict];
    [self removeLoaderView];
    
}

-(void)loadTableDataWith:(NSDictionary*)dict{
    subjects = [[NSMutableArray alloc]init];
    
    [subjects addObject:@{
                          @"Type"      :@"Heading",
                          @"Heading"   :@"At School"
                                       }];
  
    NSMutableArray *sortArray=(id)dict;
    
   sortArray= [[PC_DataManager sharedManager]sortArrayWithArray:sortArray withKey:@"SubjectName"];
    
    for (NSDictionary *subDict in sortArray) {
        [subjects addObject:subDict];
        //[subjects addObject:[subDict objectForKey:@"SubjectName"]];
    }
    
    [subListTable reloadData];
    
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
    return subjects.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data;
    
    if(isSearchActive && filterData.count>0)
    {
         data= [filterData objectAtIndex:indexPath.row];
    }
   else
   {
        data= [subjects objectAtIndex:indexPath.row];
   }
    if(data)
    {
    if([[data objectForKey:@"Type"]isEqualToString:@"Heading"])
    {
        return ScreenHeightFactor*30;
    }
    else
    {
        return ScreenHeightFactor*42;
    }
    }
    else
        return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Add New Activity ";
    static NSString *CellIdentifier1 = @"Add New Activity1 ";
    
    NSDictionary  *dictionary ;
    if(filterData.count>0)
    {
        dictionary =[filterData objectAtIndex:indexPath.row];
    }
    else
    {
        dictionary = [subjects objectAtIndex:indexPath.row];
    }
    
    TextAndDescTextCell *cell;//=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    if([[dictionary objectForKey:@"Type"]isEqualToString:@"Heading"])
    {
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }

        [cell addText:[dictionary objectForKey:@"Heading"] andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
        
        //cell.textLabel.text = [dictionary objectForKey:@"Heading"];
        
//           cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:12*ScreenFactor];
               cell.backgroundColor=activityHeading1Code;
//        cell.textLabel.textColor=activityHeading2FontCode;
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if(cell == nil)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
        }

        [cell addText:[dictionary objectForKey:@"SubjectName"] andDesc:@"" withTextColor:textBlueColor andDecsColor:cellTextColor andType:@""];
//        cell.backgroundColor=appBackgroundColor;
//        cell.textLabel.text = [dictionary valueForKey:@"SubjectName"];
                   //cell.textlabel1.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
        cell.arrowImageView.alpha=1.0f;
//        cell.textLabel.textColor=textBlueColor;
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // tableCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary  *dictionary;
    if(filterData.count>0)
    {
        dictionary = [filterData objectAtIndex:indexPath.row];
        [searchDisplayController.navigationController setNavigationBarHidden:YES];
    }
    else
    {
        dictionary=[subjects objectAtIndex:indexPath.row];
    }

   // NSDictionary  *dictionary  = [subjects objectAtIndex:indexPath.row];
if(![[dictionary objectForKey:@"Type"]isEqualToString:@"Heading"])
{
    [searchDisplayController.navigationController setNavigationBarHidden:YES];
    UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
     //[searchDisplayController.navigationController setNavigationBarHidden:YES];
    //searchDisplayController.active=NO;
        ActivitySubjectDetailCal *details=[[ActivitySubjectDetailCal alloc]init];
        details.child=self.child;
        [details setTabBarCtlr:self.tabBarCtlr];
        details.subjectID=[[dictionary objectForKey:@"SubjectID"] intValue];
        details.subject=[dictionary objectForKey:@"SubjectName"];
        
        [self.navigationController pushViewController:details animated:YES];
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
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0,yy , screenWidth, screenHeight-yy-self.tabBarController.tabBar.frame.size.height)];
    [loaderView showLoaderViewWithText:@"Hold On.."];
    [self.view addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
