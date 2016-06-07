//
//  AppEnterCodeTableViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 01/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AppEnterCodeTableViewController.h"
#import "AppEnterTableViewCell.h"

@interface AppEnterCodeTableViewController ()

{
    UILabel  *titleLabel;
    UIImageView *topStrip;
    UIScrollView  *scrollView;
    UITableView *tableView;
}
@end

@implementation AppEnterCodeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[PC_DataManager sharedManager]getWidthHeight];
        self.tableView.separatorColor=[UIColor clearColor];
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor=[UIColor whiteColor];
    
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = YES;
    
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
        // code for landscape orientation
    }
    else
    {
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    }
    [self.view addSubview:scrollView];
  
    [self userImages];
    
    [self addTitleLabel];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getWidthHeight
{
    
    screenHeight=[ScreenInfo getScreenHeight];
    screenWidth=[ScreenInfo getScreenWidth];
}

-(void)  addTitleLabel
{
   titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(.18*screenWidth, .01*screenHeight, .7*screenWidth ,.1*screenHeight)];
    

  
    
    titleLabel.text = @"Enter Passcode To Access";
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
  
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:RobotoRegular size:16.0];
    
    titleLabel.highlightedTextColor = [UIColor blueColor];
    
    [scrollView addSubview:titleLabel];
}

-(void) userImages
{
    topStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navStrip-667h.png"]];
    topStrip.center=CGPointMake(screenWidth/2,topStrip.frame.size.height/2);
    [scrollView addSubview:topStrip];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 && indexPath.row == 1) {
        return 200.0;
    }
    // "Else"
    return 200.0;
}

// the cell will be returned to the tableView
//- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"HistoryCell";
//    
//    // Similar to UITableViewCell, but
//    AppEnterTableViewCell *cell = (AppEnterTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[AppEnterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    switch (indexPath.row) {
//        case 0:
//            cell.nameLabel.text = @" Parent";
//            
//            cell.userImageView.image = [UIImage imageNamed:@"face_icon@2x.png"];
//            break;
//        case 1:
////<<<<<<< Updated upstream
//            cell.nameLabel.text = @"Aadya";
//            cell.userImageView.image = [UIImage imageNamed:@"face_icon@2x.png"];
//            break;
//        case 2:
//            cell.nameLabel.text = @"Mayra";
//=======
//          //  cell.namelabel.text = @"Aadya";
//            cell.userImageView.image = [UIImage imageNamed:@"face_icon@2x.png"];
//            break;
//        case 2:
//          //  cell.namelabel.text = @"Mayra";
//>>>>>>> Stashed changes
//            cell.userImageView.image = [UIImage imageNamed:@"face_icon@2x.png"];
//            break;
//            

    //    default:
        //    break;
//    }
    // Just want to test, so I hardcode the data
   // return cell;
//}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
//- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"selected %d row", indexPath.row);
//}
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellAccessoryDetailDisclosureButton;
//}
//

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

@end
