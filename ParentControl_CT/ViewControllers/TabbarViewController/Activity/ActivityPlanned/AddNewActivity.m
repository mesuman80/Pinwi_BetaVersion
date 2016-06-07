//
//  AddNewActivity.m
//  ParentControl_CT
//
//  Created by Priyanka on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AddNewActivity.h"
#import "SubjectCalenderList.h"
#import "AfterSchoolActivities.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"

@interface AddNewActivity() <HeaderViewProtocol>


@end

@implementation AddNewActivity
{
    NSMutableArray *completeActivityArray;
 //   UIScrollView *scrollView;
    UITableView *addNewActivityTableview;
    TextAndDescTextCell *tableCell;
    SubjectCalenderList *pinWiRotationViewController;
    AfterSchoolActivities *afterSchoolactivities;
    
    HeaderView *headerView;
    RedLabelView *label;
    int yy;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)viewDidLoad
{
    
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
    [self drawTableListView];
    [self fillCompleteArray];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // [completeActivityArray removeAllObjects];
    [self.navigationController setNavigationBarHidden:YES];
    [[PC_DataManager sharedManager].calTableActivitybyDateArray removeAllObjects];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
     [addNewActivityTableview reloadData];
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
        //[headerView setRightType:@"Menu"];
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

-(void)fillCompleteArray
{
    completeActivityArray=[[NSMutableArray alloc] init];
    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"Add Activity"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"School Activities"}];
     [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"After School Activities"}];
     //[completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Holiday Calendar"}];
    
}
-(void)drawTableListView
{
    if(!addNewActivityTableview)
    {
        addNewActivityTableview = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
        addNewActivityTableview.backgroundColor=appBackgroundColor;
        //  calendarTable.frame =;
        addNewActivityTableview .delegate=self;
        addNewActivityTableview.dataSource=self;
        addNewActivityTableview.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:addNewActivityTableview];
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"] )
    {
        return ScreenHeightFactor*30;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"banner2"] )
    {
        return ScreenHeightFactor*42;
    }
    
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //static NSString *CellIdentifier = @"Add New Activity ";
    
    
    TextAndDescTextCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell)
    {
        cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor=appBackgroundColor;
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"])
    {
        [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
       // cell.textLabel.text= [data objectForKey:@"value"];
        cell.backgroundColor=activityHeading1Code;
       // cell.textLabel.textColor=activityHeading1FontCode;
       // cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
    }
    
    else  if([[data valueForKey:@"key"] isEqualToString:@"banner2"])
    {
         [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:textBlueColor andDecsColor:cellTextColor andType:@""];
        //cell.textlabel1.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
        cell.arrowImageView.alpha=1.0;
//        cell.textLabel.text= [data objectForKey:@"value"];
//        cell.textLabel.textColor=textBlueColor;
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//       cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",tableCell.textLabel.text);
    
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    

    
    if([tableCell.textlabel1.text isEqualToString: @"School Activities"])
    {
       pinWiRotationViewController=[[SubjectCalenderList alloc]init];
        pinWiRotationViewController.child=self.child;
        [self.navigationController pushViewController:pinWiRotationViewController animated:YES];
       
    }
   else if([tableCell.textlabel1.text isEqualToString: @"After School Activities"])
    {
        afterSchoolactivities=[[AfterSchoolActivities alloc]init];
        afterSchoolactivities.afterChild=self.child;
        [self.navigationController pushViewController:afterSchoolactivities animated:YES];
        
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

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    
//}



@end
