//
//  CountryTableViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 28/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CountryTableViewController.h"
#import "GetCountryListService.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"

@interface CountryTableViewController ()<HeaderViewProtocol>

{
    UITableView *countryTableView;
    GetCountryListService *getCountryList;
    NSMutableArray *countryArray;

    ShowActivityLoadingView *loaderView;
    
    
    HeaderView *headerView;
    int yy;
}
@end

@implementation CountryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[PC_DataManager sharedManager]getWidthHeight];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:appBackgroundColor];
    [self drawHeaderView];
    
    countryTableView = [[UITableView alloc]init];
    countryTableView.backgroundColor=appBackgroundColor;
    countryTableView.frame =CGRectMake(0,yy, screenWidth, screenHeight-yy);
    countryTableView .delegate=self;
    countryTableView.dataSource=self;
    countryTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.view.backgroundColor=appBackgroundColor;
    [self.view addSubview:countryTableView];
    [self getCountryList];
    
    
    

       
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetCountryList"];
    if(dict)
    {
        [self loadTableDataWith:dict];
    }else{
        getCountryList = [[GetCountryListService alloc] init];
        [getCountryList initService:@{}];
        [getCountryList setDelegate:self];
        [self addLoaderView];
    }

}


-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetCountryListResponse" resultKey:@"GetCountryListResult"];
    [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:@"GetCountryList"];

    [self loadTableDataWith:dict];
    [self removeLoaderView];

}

-(void)loadTableDataWith:(NSDictionary*)dict{
    
    NSLog(@"Country....:   %@", dict);
    countryArray = [[NSMutableArray alloc]init];
    for (NSDictionary *cityDict in dict) {
        [countryArray addObject:cityDict];
    }// Store in the dictionary using the data as the key
    
    countryArray= [[PC_DataManager sharedManager]sortArrayWithArray:countryArray withKey:@"CountryName"];
    
    [loaderView removeLoaderView];
    [countryTableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScreenHeightFactor*42;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return countryArray .count;
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TextAndDescTextCell *cell;
    cell=[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    
    NSLog(@" country Array %@ ", countryArray);
    
    // Configure the cell...
    NSDictionary  *dictionary  = [countryArray objectAtIndex:indexPath.row];
    [cell addText:[dictionary valueForKey:@"CountryName"] andDesc:@"" withTextColor:cellTextColor andDecsColor:cellTextColor andType:@""];
//    cell.textLabel.text = [dictionary valueForKey:@"CountryName"];
//    cell.backgroundColor=appBackgroundColor;
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
    NSDictionary * dictionary = [countryArray objectAtIndex:indexPath.row];
    NSLog(@"Value of dictionary =%@",dictionary);
    //[self.cou selectedCity:[dictionary objectForKey:@"CityName"] andId:[dictionary objectForKey:@"CityID"]];
   // [self.countryListDelegate selectedCountry:[@"CountryName" ] andId:[dictionary objectForKey:@"CountryID"]];
    [self.countryListDelegate selectedCountry: [dictionary objectForKey:@"CountryName"] andId:[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"CountryID"] ]];
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
#pragma mark HeaderViewSpecific Functions
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
        [headerView drawHeaderViewWithTitle:@"Countries" isBackBtnReq:YES BackImage:@"leftArrow.png"];
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
