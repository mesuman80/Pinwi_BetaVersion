//
//  FaceBookFriendsViewController.m
//  Amgine
//
//  Created by Yogesh Gupta on 09/02/15.
//
//

#import "FaceBookFriendsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FaceBookFriends.h"
#import "ScreenInfo.h"
#import "FaceBookFriendsCell.h"
//#import "ContactData.h"
//#import "Constants.h"
//#import "Data.h"
//#import "SearchResultTableViewController.h"
//#import "ScreenInfo.h"

@interface FaceBookFriendsViewController ()<UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>

{
}
@property UISearchController *searchController;
@end

@implementation FaceBookFriendsViewController
{
    NSMutableArray *facebookFriendsArray;
    float screenWidth;
    float screenHeight;
    
    //SearchResultTableViewController *searchResultController;
    NSMutableArray *searchResultArray;
    
}
@synthesize searchController;
#pragma mark ViewLifeCycleFunctions
- (void)viewDidLoad
{
    [super viewDidLoad];
    screenWidth=[ScreenInfo getScreenWidth];
    screenHeight=[ScreenInfo getScreenHeight];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self navigationTitleSetup];
    [self tableViewSetup];
    [self getFreindsList];
    
}
-(void)navigationTitleSetup
{
    self.title=@"My Friends";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
}
-(void)getFreindsList
{
    NSArray *permissionsNeeded = @[@"public_profile", @"user_birthday",@"email"];
    
    [self showLoaderView:YES withText:@"Loading..."];
    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends" parameters:nil HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
     {
         if(!error)
         {
             if([result isKindOfClass:[NSDictionary class]])
             {
                 NSLog(@"dictionary Class=%@",result);
                 NSDictionary *dict=(NSDictionary *)result;
                 NSArray *array= [dict valueForKey:@"data"];
                 if(!facebookFriendsArray)
                 {
                     facebookFriendsArray =[[NSMutableArray alloc]init];
                 }
                 else
                 {
                     [facebookFriendsArray removeAllObjects];
                 }
                 for(NSDictionary *dictionary in array)
                 {
                     FaceBookFriends *faceBookFriends = [[FaceBookFriends alloc]init];
                     faceBookFriends.faceBookId = [dictionary valueForKey:@"id"];
                     faceBookFriends.userName = [dictionary valueForKey:@"name"];
                     NSDictionary *pictureDictionary= [dictionary valueForKey:@"picture"];
                     NSDictionary *dataDictionary= [pictureDictionary valueForKey:@"data"];
                     faceBookFriends.profilePicUrl =[dataDictionary valueForKey:@"url"];
                     //                                          ContactData *contactData=[[Data sharedData]checkContactEntityExist:AmgineContactsData passengerName:faceBookFriends.userName withFriendType:AmgineFaceBookFriends withFriendId:faceBookFriends.faceBookId];
                     //                                          if(contactData)
                     //                                          {
                     //                                              faceBookFriends.isAddInFriendList=YES;
                     //                                          }
                     [facebookFriendsArray addObject:faceBookFriends];
                     [self.friendsTableView reloadData];
                     [self showLoaderView:NO withText:nil];
                 }
             }
         }
         else
         {
             [self showLoaderView:NO withText:nil];
             [self showAlertViewWithTitle:@"Alert" Message:@""];
         }
     }];
    
}
-(void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)showLoaderView:(BOOL)show withText:(NSString *)text
{
    static UILabel *label;
    static UIActivityIndicatorView *activity;
    static UIView *loaderView;
    
    if(show)
    {
        
        loaderView=[[UIView alloc] initWithFrame:self.view.bounds];
        [loaderView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.4]];
        
        label=[[UILabel alloc] initWithFrame:CGRectMake(0, (loaderView.bounds.size.height/2)-10, loaderView.bounds.size.width, 20)];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [label setText:text];
        [label setTextAlignment:NSTextAlignmentCenter];
        [loaderView addSubview:label];
        
        activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activity.center=CGPointMake(label.center.x, label.frame.origin.y+label.frame.size.height+10+activity.frame.size.height/2);
        
        [activity startAnimating];
        [loaderView addSubview:activity];
        [self.view addSubview:loaderView];
    }else
    {
        
        [label removeFromSuperview];
        [activity removeFromSuperview];
        [loaderView removeFromSuperview];
        label=nil;
        activity=nil;
        loaderView=nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"My Friends";
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showLoaderView:NO withText:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark tableViewSpecificFunctions
-(void)tableViewSetup
{
    if(!self.friendsTableView)
    {
        self.friendsTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
        self.friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.friendsTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        [self.friendsTableView setDelegate:self];
        [self.friendsTableView setDataSource:self];
        [self.view addSubview:self.friendsTableView];
    }
    else
    {
    }
    searchResultArray = [[NSMutableArray alloc]init];
    
    //    searchResultController=[[SearchResultTableViewController alloc]init];
    //    [searchResultController setViewController:self];
    //    searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultController];
    //    searchController.searchResultsUpdater = self;
    //    [searchController.searchBar sizeToFit];
    //    self.friendsTableView.tableHeaderView = searchController.searchBar;
    //    searchController.delegate = self;
    //    searchController.dimsBackgroundDuringPresentation = YES; // default is YES
    //    searchController.searchBar.delegate = self; // so we can monitor text changes + others
    //    searchController.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return facebookFriendsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FaceBookFriends *faceBookFriends= [facebookFriendsArray objectAtIndex:indexPath.row];
    FaceBookFriendsCell *faceBookFriendsCell = [self cellTableView:tableView withData:faceBookFriends];
    return faceBookFriendsCell;
}
-(FaceBookFriendsCell *)cellTableView :(UITableView *)tableView withData:(FaceBookFriends *)faceBookFriends
{
    static NSString *CellIdentifier=@"FriendsCell";
    FaceBookFriendsCell *faceBookFriendsCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(faceBookFriendsCell==nil)
    {
        faceBookFriendsCell=[[FaceBookFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    faceBookFriendsCell.selectionStyle=UITableViewCellSelectionStyleNone;
    [faceBookFriendsCell drawUI:faceBookFriends];
    return faceBookFriendsCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clickAtCell:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self layOutSubView:cell];
}
-(void)clickAtCell:(NSIndexPath *)indexPath
{
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}
#pragma mark searchspecificFunction
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [searchResultArray removeAllObjects];
    for (FaceBookFriends *faceBookFriends in facebookFriendsArray)
    {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange contactNameRange = NSMakeRange(0, faceBookFriends.userName.length);
        NSRange foundRange = [faceBookFriends.userName rangeOfString:searchText options:searchOptions range:contactNameRange];
        if (foundRange.length > 0)
        {
            NSLog(@"contact first Name=%@",faceBookFriends.userName);
            [searchResultArray addObject:faceBookFriends];
            
        }
    }
    //if (searchController.searchResultsController)
    //{
    //    SearchResultTableViewController *resultController = (SearchResultTableViewController *)searchController.searchResultsController;
    //    [resultController.searchTableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    //    resultController.searchResults =searchResultArray;
    //    [resultController.searchTableView reloadData];
    //}
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
}
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    NSString *searchString = [self.searchController.searchBar text];
    if(searchString.length>0)
    {
        
        [self filterContentForSearchText:searchString
                                   scope:[[self.searchController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchController.searchBar selectedScopeButtonIndex]]];
        
    }
    
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}


-(void)layOutSubView:(UITableViewCell *)cell
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}



@end
