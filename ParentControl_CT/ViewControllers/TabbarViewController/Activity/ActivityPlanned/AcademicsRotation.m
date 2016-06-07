//
//  ViewController.m
//  CircleAnim
//
//  Created by Suman Bhattacharyya on 19/04/15.
//  Copyright (c) 2015 Suman Bhattacharyya. All rights reserved.
//

#import "AcademicsRotation.h"
#import "PinwiWheel.h"
#import "ActivityElementList.h"
#import "ShowActivityLoadingView.h"
#import "CustomActivitiesViewController.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"

@interface AcademicsRotation ()<HeaderViewProtocol,UISearchBarDelegate,UISearchResultsUpdating>
{
    // JUST COPY THESE 2 METHODS
    
    PinwiWheel * pinwiWheel;
    ActivityElementList *activityList;
    UIImageView *img;
    NSMutableArray *subjects;
    int subCounter, waitCnt;
    NSMutableAttributedString *yourString;
    
@private CGFloat imageAngle;
@private OneFingerRotationGestureRecognizer *gestureRecognizer;
    
    GetActivitiesByCatID *getSubjectActivities;
    ShowActivityLoadingView *loaderView;
    
    UISearchController *searchDisplayController;
    BOOL isSearchActive;
    NSArray *filterData;
    NSMutableArray *filterSearchArray;
}

@end

@implementation AcademicsRotation
{
    HeaderView *headerView;
    RedLabelView *label;
    int yy;
}
@synthesize child;
@synthesize activityListTable,categoryName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor=appBackgroundColor;
    [[PC_DataManager sharedManager] getWidthHeight];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawHeaderView];
    [self childNameLabel];
    [self addCustomSubject];
    [self drawTableListView];
    [self addSearchBar];
    [self getSubjects];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([self.childClassName isEqualToString:@"CustomActivitiesViewController"])
    {
        [self getSubjects];
        self.childClassName=@"";
    }
    [self.navigationController setNavigationBarHidden:YES];
    [PC_DataManager sharedManager].repeatDaysString=[@"" mutableCopy];
    [activityListTable reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // [completeActivityArray removeAllObjects];
    [self.navigationController setNavigationBarHidden:YES];

        [searchDisplayController.navigationController setNavigationBarHidden:YES];
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
    if(!activityListTable)
    {
        activityListTable = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
        activityListTable.backgroundColor=appBackgroundColor;
        activityListTable .delegate=self;
        activityListTable.dataSource=self;
        activityListTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:activityListTable];
    }
}


// JUST COPY THESE 2 METHODS

-(void)getSubjects
{
//    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetActivitiesByCatID"];
//    if(dict)
//    {
//        [self loadTableDataWith:dict];
//    }else{
    
    getSubjectActivities=[[GetActivitiesByCatID alloc]init];
    
    [getSubjectActivities initService:@{
                                        @"CategoryID":self.indexVal,
                                        @"ParentID":[PC_DataManager sharedManager].parentObjectInstance.parentId
                                        }];
    
    [getSubjectActivities setDelegate:self];
    [self addLoaderView];
  //  }
}


-(void)addCustomSubject
{
    NSString *str=@"Can't find activity? Create custom";
    yourString=[[NSMutableAttributedString alloc]initWithString:str];
    [yourString addAttribute:NSForegroundColorAttributeName value:textBlueColor range:NSMakeRange(21,13)];
}


///////////////////////////////////////
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
        activityListTable.tableHeaderView= searchDisplayController.searchBar;
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
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"value Name contains[c] %@",
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
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"Name contains[c] %@",
                           searchText];
//    for(NSDictionary *dictionary in subjects)
//    {
    filterData = [filterSearchArray filteredArrayUsingPredicate:filter];
//    }
    
    NSLog(@"Filter  data=%@",filterData);
    [activityListTable reloadData];
}


#pragma mark CONNECTION DELEGATES

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
    
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetActivitiesByCatIDResponse" resultKey:@"GetActivitiesByCatIDResult"];
  //  [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:@"GetActivitiesByCatID"];
    [self loadTableDataWith:dict];
    [self removeLoaderView];

}

-(void)loadTableDataWith:(NSDictionary*)dict{
    subjects = [[NSMutableArray alloc]init];
    filterSearchArray = [[NSMutableArray alloc]init];
    //SubjectDict = [[NSMutableArray alloc]init];
   // self.activityName=[self.activityName uppercaseString];
     [subjects addObject:@{@"key":@"banner1", @"value":@"After School"}];
     [subjects addObject:@{@"key":@"banner2", @"value":[self.activityName uppercaseString]}];
    
    
    NSMutableArray *sortArray=(id)dict;
    sortArray= [[PC_DataManager sharedManager]sortArrayWithArray:sortArray withKey:@"Name"];
    
    for (NSDictionary *subDict in sortArray) {
        [subjects addObject:@{@"key":@"item", @"value":subDict}];//[subDict objectForKey:@"Name"]];
        [filterSearchArray addObject:subDict];
        //[SubjectDict addObject:subDict];
    }
    [subjects addObject:@{@"key":@"button", @"value":yourString}];
    [activityListTable reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    return subjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *data = [subjects objectAtIndex:indexPath.row];
    
    if([[data valueForKey:@"key"]isEqualToString:@"banner1"]||[[data valueForKey:@"key"]isEqualToString:@"banner2"])
    {
        return ScreenHeightFactor*30;
    }
    else if(indexPath.row< [subjects count])
    {
        return ScreenHeightFactor*42;
    }
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *Banner1CellIdentifier = @"AddAfterSchoolListBanner1";
    static NSString *Banner2CellIdentifier = @"AddAfterSchoolListBanner2";
     static NSString *ItemCellIdentifier = @"AddAfterSchoolListItem";
     static NSString *ButtonCellIdentifier = @"AddAfterSchoolListButton";
    
    NSMutableDictionary  *dictionary =[[NSMutableDictionary alloc]init];
    if(filterData.count>0)
    {
        [dictionary setObject:@"item" forKey:@"key"];
        [dictionary setObject:[filterData objectAtIndex:indexPath.row] forKey:@"value"];
    }
    else
    {
        dictionary = [subjects objectAtIndex:indexPath.row];
    }

    TextAndDescTextCell *cell;//=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];

    if([[dictionary objectForKey:@"key"]isEqualToString:@"banner1"])
    {
        cell=[tableView dequeueReusableCellWithIdentifier:Banner1CellIdentifier];
        if(cell == nil)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Banner1CellIdentifier];
        }
        [cell addText:[dictionary objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
//            cell.backgroundColor=appBackgroundColor;
//            cell.textLabel.text = [dictionary objectForKey:@"value"];
//            cell.textLabel.textColor=activityHeading1FontCode;
//            cell.textLabel.font=[UIFont systemFontOfSize:11*ScreenFactor];
            cell.backgroundColor=activityHeading1Code;
    }
    else if([[dictionary objectForKey:@"key"]isEqualToString:@"banner2"])
    {
        cell=[tableView dequeueReusableCellWithIdentifier:Banner2CellIdentifier];
        if(cell == nil)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Banner2CellIdentifier];
        }
        [cell addText:[dictionary objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading2FontCode andDecsColor:cellTextColor andType:@"Banner"];
//        cell.backgroundColor=appBackgroundColor;
//        cell.textLabel.text = [dictionary objectForKey:@"value"];
//        cell.textLabel.font=[UIFont systemFontOfSize:11*ScreenFactor];
//        cell.textLabel.textColor=activityHeading2FontCode;
        cell.backgroundColor=activityHeading2Code;
    }
    else if([[dictionary objectForKey:@"key"]isEqualToString:@"button"])
    {
        cell=[tableView dequeueReusableCellWithIdentifier:ButtonCellIdentifier];
        if(cell == nil)
        {
            cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ButtonCellIdentifier];
        }
        
        [cell addText:@"" andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@""];
        cell.textlabel1.attributedText=[dictionary objectForKey:@"value"];
        [cell.textlabel1 sizeToFit];
        [cell.textlabel1 setCenter:CGPointMake(cell.textlabel1.center.x, ScreenHeightFactor*20)];
//        cell.textLabel.font=[UIFont systemFontOfSize:11*ScreenFactor];
//        cell.backgroundColor=appBackgroundColor;
//        cell.textLabel.attributedText = [dictionary objectForKey:@"value"];
    }
   else if([[dictionary objectForKey:@"key"]isEqualToString:@"item"])
   {
       cell=[tableView dequeueReusableCellWithIdentifier:ItemCellIdentifier];
       if(cell == nil)
       {
           cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ItemCellIdentifier];
       }
       NSMutableDictionary *data=[dictionary objectForKey:@"value"];
        [cell addText:[data valueForKey:@"Name"] andDesc:@"" withTextColor:textBlueColor andDecsColor:cellTextColor andType:@""];
       cell.arrowImageView.alpha=1.0f;
       
//       cell.backgroundColor=appBackgroundColor;
//       cell.textLabel.font=[UIFont systemFontOfSize:11*ScreenFactor];
//       cell.textLabel.text = [data valueForKey:@"Name"];
//       cell.textLabel.textColor=textBlueColor;
//       [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
   }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // tableCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary  *dictionary =[[NSMutableDictionary alloc]init];
    if(filterData.count>0)
    {
        [dictionary setObject:@"item" forKey:@"key"];
        [dictionary setObject:[filterData objectAtIndex:indexPath.row] forKey:@"value"] ;
         [searchDisplayController.navigationController setNavigationBarHidden:YES]; 
    }
    else
    {
        dictionary = [subjects objectAtIndex:indexPath.row];
    }
    
    
    if([[dictionary objectForKey:@"key"]isEqualToString:@"button"])
    {
        CustomActivitiesViewController *custom=[[CustomActivitiesViewController alloc]init];
        custom.child=self.child;
        [custom setTabBarCtlr:self.tabBarCtlr];
        custom.categoryName = self.categoryName;
        custom.subCategoryName = self.activityName;
        custom.catagoryID = self.categoryId;
        custom.subCatagoryID = self.subCategoryId;
        self.childClassName=@"CustomActivitiesViewController";
        [self.navigationController pushViewController:custom animated:YES];
    }
    
    else  if([[dictionary objectForKey:@"key"]isEqualToString:@"item"])
    {
        ActivityDetails *activityDetails =[[ActivityDetails alloc]init];
        
        activityDetails.afterSchoolChild=self.child;
       // activityDetails.subjectID=[[[SubjectDict objectAtIndex:subCounter] valueForKey:@"ActivityID"]intValue];
       activityDetails.activityName=self.activityName;
        [activityDetails setTabBarCtlr:self.tabBarCtlr];
      //  activityDetails.SubName=[subjects objectAtIndex:subCounter];
        activityDetails.afterSchoolDataDict=[dictionary objectForKey:@"value"];
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        [self.navigationController pushViewController:activityDetails animated:YES];
    
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

@end
