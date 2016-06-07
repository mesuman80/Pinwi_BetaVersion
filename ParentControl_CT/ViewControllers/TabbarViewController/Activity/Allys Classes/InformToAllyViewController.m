//
//  InformAllyViewController.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InformToAllyViewController.h"
#import "InformAllyDetailViewController.h"
#import "ShowActivityLoadingView.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"
#import "AllyProfileController.h"

@interface InformToAllyViewController ()<HeaderViewProtocol>

@end

@implementation InformToAllyViewController
{
    NSMutableArray *completeActivityArray;
  //  UIScrollView  *scrollView;
    TextAndDescTextCell *tableCell;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *allyDummy;
    
    BOOL isSearchActive;
    
    NSArray *filterData;
    //NSArray *actualData;
    NSString *textFieldString;
    UITableView *searchTableView;
    UITextField *searchTextField;
  

    RedLabelView *label;
   // UILabel *label;
    UILabel *class;
    UILabel *allyHead;
    UILabel *subjectLabel;
    
    GetListOfAllys *allyList;
    ShowActivityLoadingView *loaderView;
    
    HeaderView *headerView;
    int yy;
}
@synthesize allyTable;
@synthesize parentClass;


- (void)viewDidLoad {
    [super viewDidLoad];
    [[PC_DataManager sharedManager] getWidthHeight];
    self.view.backgroundColor=appBackgroundColor;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawHeaderView];
    [self childNameLabel];
    [self drawTableListView];
    [self getAllyList];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [allyTable reloadData];
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
       // [headerView setRightType:@""];
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

-(void)drawTableListView
{
    if(!allyTable)
    {
        allyTable = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
        allyTable.backgroundColor=appBackgroundColor;
        allyTable .delegate=self;
        allyTable.dataSource=self;
        allyTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:allyTable];
    }
}

-(void) getAllyList
{
    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetListOfAllys"];
    if(dict)
    {
        NSArray *arr=(NSArray*)dict;
        NSMutableDictionary *checkDict=[[arr firstObject]mutableCopy];
        if([[checkDict objectForKey:@"ErrorDesc"]isEqualToString:@"No Ally found."])
        {
            [self loadTableDataWith:nil];
        }
        else
        {
        [self loadTableDataWith:dict];
        }
    }else{

    allyList = [[GetListOfAllys alloc] init];
    [allyList initService:@{
                            @"ChildID":self.child.child_ID
                                 }];
    [allyList setDelegate:self];
    
    [self addLoaderView];
    }
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetListOfAllysResponse" resultKey:@"GetListOfAllysResult"];
    NSLog(@"dict:\t %@",dict);
    
    if(!dict)
    {
        return;
    }
    NSArray *arr=(NSArray*)dict;
    NSMutableDictionary *checkDict=[[arr firstObject]mutableCopy];
    if([[checkDict objectForKey:@"ErrorDesc"]isEqualToString:@"No Ally found."])
    {
        [self loadTableDataWith:nil];
       // [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self loadTableDataWith:dict];
    }
    [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:@"GetListOfAllys"];
    
    
    [self removeLoaderView];
}

-(void)loadTableDataWith:(NSDictionary*)dict{
    
    NSLog(@"Country....:   %@", dict);

    completeActivityArray = [[NSMutableArray alloc]init];
    
    [completeActivityArray addObject:@{
                                       @"Type" :@"banner1",
                                       @"Value":[self.activityDict objectForKey:@"activityName"]
                                       }];
    
    [completeActivityArray addObject:@{
                                       @"Type" :@"banner2",
                                       @"Value":@"SELECT ALLY"
                                       }];
if(dict)
{
    for (NSDictionary *cityDict in dict) {
        [completeActivityArray addObject:cityDict];
    }
}// Store in the dictionary using the data as the key
    [completeActivityArray addObject:@{
                                       @"Type"      :@"Blank",
                                       @"Desc"      :@"       Add New Ally"
                                       }];
    
    [loaderView removeLoaderView];
    [allyTable reloadData];
    
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

   
    //searchDisplayController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES;
    //searchBar.frame=CGRectMake(0,0,screenWidth,screenHeight*.15);
    allyTable.tableHeaderView=searchBar;
    
}



-(void)addLabels
{

    NSString *str=self.child.firstName;
    
  label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*.06)withChildStr:self.child.nick_Name];
    label.center=CGPointMake(screenWidth/2,screenHeight*.03);
    [self.view addSubview:label];
    
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
//    label.text=str;
//    label.font=[UIFont fontWithName:RobotoRegular size:13.0f];
//    label.frame=CGRectMake(0,0,displayValueSize.width+screenWidth*.02,displayValueSize.height+screenHeight*.01);
//    label.textAlignment=NSTextAlignmentCenter;
//    label.center=CGPointMake(screenWidth/2,screenHeight*.06);
//    label.textColor=[UIColor whiteColor];
//    label.backgroundColor=labelBgColor;
//    label.layer.borderColor=labelBgColor.CGColor;
//    label.layer.shadowColor=labelBgColor.CGColor;
//    label.layer.shadowOpacity=0.0f;
//    label.layer.cornerRadius=label.frame.size.height/2;
//    label.clipsToBounds=YES;
//    label.textAlignment=NSTextAlignmentCenter;
//    [self.view addSubview:label];
    
    class=[[UILabel alloc]init];
    str=[NSString stringWithFormat:@"   %@",self.subjectName];
    displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25.0f]}];
    class.font=[UIFont fontWithName:RobotoRegular size:20.0f];
    class.text=str;
    class.frame=CGRectMake(0,0,screenWidth,screenHeight*.05);
    class.center=CGPointMake(screenWidth/2, .12*screenHeight);
    class.textColor=activityHeading1FontCode;
    class.backgroundColor=activityHeading1Code;
    //[class sizeToFit];
    [self.view addSubview:class];
    
    allyHead=[[UILabel alloc]init];
    str=@"   INFORM ALLY";
    displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25.0f]}];
    allyHead.font=[UIFont fontWithName:RobotoRegular size:20.0f];
    allyHead.text=str;
    allyHead.frame=CGRectMake(0,0,screenWidth,screenHeight*.05);
    allyHead.center=CGPointMake(screenWidth/2, class.center.y+allyHead.frame.size.height-2);
    allyHead.textColor=activityHeading2FontCode;
    allyHead.backgroundColor=activityHeading2Code;
    //[allyHead sizeToFit];
    [self.view addSubview:allyHead];
}


-(void)fillCompleteArray
{
    
    ParentProfileEntity *parentProfileEntity  =[[PC_DataManager sharedManager]getParentEntity];
    
    completeActivityArray=[[NSMutableArray alloc] init];

//    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"Yoga Class"}];
//    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"INFORM ALLY"}];

    
    NSMutableArray *allyDummy= [[NSMutableArray alloc]init];
    allyDummy= parentProfileEntity.allyProfiles.array.mutableCopy;
   // NSMutableArray *completeActivityArray1= [[NSMutableArray alloc]init];
    for(AllyProfileEntity *ally in allyDummy)
    {
        //[completeActivityArray addObject:@{@"key":@"Alliies", @"value":ally.name}];
        NSLog(@"complete activity array %@ ", completeActivityArray);
        [completeActivityArray addObject:ally.firstName];
    }
    
    
//    [completeActivityArray addObject:@"neeta"];
//    [completeActivityArray addObject:@"preeti"];
//    [completeActivityArray addObject:@"sonia"];
//    [completeActivityArray addObject:@"ana"];
//    [completeActivityArray addObject:@"naina"];
//    [completeActivityArray addObject:@"priya"];
//    [completeActivityArray addObject:@"anu"];
//    [completeActivityArray addObject:@"anaya"];
    NSLog(@"complete array activity is: \n %@",completeActivityArray);
    
//    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"Subject Calendar"}];
//    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Maths"}];
//    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Monday"}];
//    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Tuesday"}];
//    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Wednesday"}];
//    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Thursday"}];
//    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Friday"} ];
//    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Saturday"}];
//    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Sunday"}];
//    
//    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Date",  @"Date":@"22 Feb 2015"}];
//    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Note"}];
//    
//    
//    [completeActivityArray addObject:@{@"key":@"textbox", @"value":@"textbox"}];
    
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
    [label setAlpha:0.0f];
    [class setAlpha:0.0f];
    [allyHead setAlpha:0.0f];
  //  allyTable.frame =CGRectMake(0, 0, screenWidth, screenHeight);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
    [label setAlpha:1.0f];
    [class setAlpha:1.0f];
    [allyHead setAlpha:1.0f];
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
    
//    if(isSearchActive)
//    {
//        return filterData.count;
//    }
////    else
////    {
//
////    }
////    return 0;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    filterData =nil;
    [label setAlpha:1.0f];
    [class setAlpha:1.0f];
    [allyHead setAlpha:1.0f];
}

#pragma mark - Table view data source



//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    // Return the number of rows in the section.
//    return completeActivityArray.count;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
//
//    
//    
    if([[data valueForKey:@"Type"] isEqualToString:@"banner1"] || [[data valueForKey:@"Type"] isEqualToString:@"banner2"])
    {
        return ScreenHeightFactor*30;
    }
    if([[data valueForKey:@"Type"] isEqualToString:@"Blank"] )
    {
        return ScreenHeightFactor*50;
    }
//    if([[data valueForKey:@"key"] isEqualToString:@"Alliies"] )
//    {
//        return 40;
//    }

    
    return ScreenHeightFactor*42;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier=@"InformAllyCell";
    NSString *CellIdentifier1=@"NewButtonCell";
    NSString *Head2AfterSchoolIdentifier=@"Heading2";
     NSString *Head1AfterSchoolIdentifier=@"Heading2";
    
    
    UITableViewCell *cell1;// = [tableView dequeueReusableCellWithIdentifier:@"InformAllyCell" forIndexPath:indexPath];
    
        NSDictionary *data=[completeActivityArray objectAtIndex:indexPath.row];

    if([[data valueForKey:@"Type"] isEqualToString:@"banner1"])
    {
        TextAndDescTextCell *cell =[tableView dequeueReusableCellWithIdentifier:Head1AfterSchoolIdentifier];
            if(!cell)
            {
             cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Head1AfterSchoolIdentifier];
            }
            [cell addText:[data objectForKey:@"Value"] andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
//            cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
//            cell.textLabel.text= [data objectForKey:@"Value"];
//            cell.textLabel.textColor=activityHeading1FontCode;
            cell.backgroundColor=activityHeading1Code;
        cell.userInteractionEnabled=NO;
        cell1=cell;
    }
    
    else  if([[data valueForKey:@"Type"] isEqualToString:@"banner2"])
    {
        TextAndDescTextCell *cell =[tableView dequeueReusableCellWithIdentifier:Head2AfterSchoolIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Head2AfterSchoolIdentifier];
        }
        //        if(cell.textLabel.text.length==0)
        //        {
//        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
//        cell.textLabel.text= [data objectForKey:@"Value"];
//        cell.textLabel.textColor=activityHeading2FontCode;
        [cell addText:[data objectForKey:@"Value"] andDesc:@"" withTextColor:activityHeading2FontCode andDecsColor:cellTextColor andType:@"Banner"];
        
        cell.backgroundColor=activityHeading2Code;
         cell.userInteractionEnabled=NO;
        cell1=cell;
    }
    else if([[data objectForKey:@"Type"]isEqualToString:@"Blank"])
    {
        cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if(cell1 == nil)
        {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
        }
        cell1.textLabel.text = [data objectForKey:@"Desc"];
        cell1.textLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
        cell1.textLabel.textColor=textBlueColor;
        
        if(!subjectLabel)
        {
            subjectLabel=[[UILabel alloc]init];
            UIButton *imgView = [UIButton buttonWithType:UIButtonTypeCustom];
            imgView.tintColor=textBlueColor;
            [imgView setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"addActivity.png")] forState:UIControlStateNormal];
            if(screenWidth>700)
            {
                imgView.frame= CGRectMake(cellPadding, 14*ScreenHeightFactor,20*ScreenHeightFactor, 20*ScreenHeightFactor);
            }
            else
            {
                imgView.frame= CGRectMake(cellPadding, 15*ScreenHeightFactor,20*ScreenHeightFactor, 20*ScreenHeightFactor);
            }
            [imgView addTarget:self action:@selector(newallyTouched) forControlEvents:UIControlEventTouchUpInside];
            [cell1.contentView addSubview:imgView];
        }
        cell1.backgroundColor=appBackgroundColor;
    }

else
{
    TextAndDescTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
    }
    NSDictionary *dict;
    if(filterData.count>0)
    {
        dict=[filterData objectAtIndex:indexPath.row];
    }
    else
    {
         dict= [completeActivityArray objectAtIndex:indexPath.row];
        cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
   [cell addText:[dict objectForKey:@"AllyName"] andDesc:@"" withTextColor:cellBlackColor_7 andDecsColor:cellTextColor andType:@""];
    cell1=cell;
}
    
    return cell1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dict=[completeActivityArray objectAtIndex:indexPath.row];
    
    if([[dict objectForKey:@"Type"]isEqualToString:@"Blank"])
    {
        [self newallyTouched];
    }
    else
    {
    if(self.informAllyDelegate)
    {
        [self.informAllyDelegate sendAllyName:nil andId:nil andAllyObj:dict];
    }
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark allyDetail
-(void)sendAllyName:(NSString *)allyName andId:(NSString *)allyId andAllyObj:(AllyProfileObject *)allyObj
{
     [self.navigationController popViewControllerAnimated:YES];
    [self.informAllyDelegate sendAllyName:allyName andId:allyId andAllyObj:allyObj];
   
}

-(void)newallyTouched
{
    AllyProfileController *viewCtrl=[[AllyProfileController alloc]init];
    viewCtrl.parentClassName=PinWiCreateNewAlly;
    //viewCtrl.allyIndex=(int)indexPathCalc.row;
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

@end
