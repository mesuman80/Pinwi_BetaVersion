//
//  InformAllyViewController.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InformAllyViewController.h"

@interface InformAllyViewController ()

@end

@implementation InformAllyViewController
{
    NSMutableArray *completeActivityArray;
    UIScrollView *scrollView;
    UITextView *notes;
    NSString *placeholderText;
    UIView *pickerView;
    UIButton *doneButton, *cancelButton;
    UIDatePicker *picker;
    UITableViewCell *tableCell;
    UIImageView *exam;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    
}
@synthesize allyTable;



- (void)viewDidLoad {
    [super viewDidLoad];
    [[PC_DataManager sharedManager] getWidthHeight];
    self.view.backgroundColor=[UIColor whiteColor];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight*1.2);
    [self.view addSubview:scrollView];
    
    [self childNameLabel];
   // [self loadTableView];
    allyTable = [[UITableView alloc]init];
    allyTable.backgroundColor=[UIColor clearColor];
    allyTable.frame =CGRectMake(0, .05*screenHeight, screenWidth, screenHeight*.9);
    allyTable .delegate=self;
    allyTable.dataSource=self;
    
    [scrollView addSubview:allyTable];
    
    
    
    
    [self fillCompleteArray];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self addKeyBoardNotification];
    
}
-(void)loadTableView {
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    
    self.allyTable.tableHeaderView = searchBar;
    
}



-(void)childNameLabel
{
    UILabel *label=[[UILabel alloc]init];
    NSString *str=@"Aadya";
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    label.font=[UIFont fontWithName:@"Arial" size:13.0f];
    label.text=str;
    label.frame=CGRectMake(0,0,displayValueSize.width,displayValueSize.height);
    label.center=CGPointMake(screenWidth/2, .02*screenHeight);
    label.textColor=[UIColor darkGrayColor];
    [label sizeToFit];
    [scrollView addSubview:label];
}

-(void)viewDidAppear:(BOOL)animated
{
    [allyTable reloadData];
}


-(void)fillCompleteArray
{
    
    ParentProfileEntity *parentProfileEntity  =[[PC_DataManager sharedManager]getParentEntity];
    
    completeActivityArray=[[NSMutableArray alloc] init];

    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"Yoga Class"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"INFORM ALLY"}];

    
    NSMutableArray *allyDummy= [[NSMutableArray alloc]init];
    allyDummy= parentProfileEntity.allyProfiles.array.mutableCopy;
   // NSMutableArray *completeActivityArray1= [[NSMutableArray alloc]init];
    for(AllyProfileEntity *ally in allyDummy)
    {
        [completeActivityArray addObject:@{@"key":@"Alliies", @"value":ally.name}];
        NSLog(@"complete activity array %@ ", completeActivityArray);
        //[completeActivityArray1 addObject:ally.name];
    }
    
                                       

    
    
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

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"] )
    {
        return 30;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"banner2"] )
    {
        return 30;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"Alliies"] )
    {
        return 40;
    }

    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:@"InformAllyCell" forIndexPath:indexPath];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"InformAllyCell"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"InformAllyCell"];
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];

    
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"])
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text= [data objectForKey:@"value"];
        // cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
        cell.backgroundColor=[UIColor darkGrayColor];
    }
    
    else  if([[data valueForKey:@"key"] isEqualToString:@"banner2"])
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text= [data objectForKey:@"value"];
        cell.backgroundColor=[UIColor lightGrayColor];
    }
    else  if([[data valueForKey:@"key"] isEqualToString:@"Alliies"])
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Alliies"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text= [data objectForKey:@"value"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    

   
        // cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
       // cell.backgroundColor=[UIColor darkGrayColor];
    
    return cell;
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
