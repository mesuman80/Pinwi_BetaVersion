//
//  AfterSchoolAcademicsClass.m
//  ParentControl_CT
//
//  Created by Priyanka on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AfterSchoolAcademicsClass.h"
#import "RedLabelView.h"

@interface AfterSchoolAcademicsClass ()
{
    NSMutableArray *completeActivityArray;
    UIScrollView *scrollView;
    UITableView *afterSchoolClass;
    UITableViewCell *tableCell;
   // AcademicsRotation *academics;
}

@end

@implementation AfterSchoolAcademicsClass

- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.title=@" Activity";
    [[PC_DataManager sharedManager] getWidthHeight];
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    [self.view addSubview:scrollView];
    [self childNameLabel];
    afterSchoolClass = [[UITableView alloc]init];
    afterSchoolClass.backgroundColor=[UIColor clearColor];
    afterSchoolClass.frame =CGRectMake(0, .07*screenHeight, screenWidth, screenHeight*2);
    afterSchoolClass .delegate=self;
    afterSchoolClass.dataSource=self;
    
    [scrollView addSubview:afterSchoolClass];
    
    
    [self fillCompleteArray];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}


-(void)childNameLabel
{
//    UILabel *label=[[UILabel alloc]init];
//    NSString *str=@"Aadya";
//    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
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
//    //[label sizeToFit];
//    [scrollView addSubview:label];
    
    RedLabelView *label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*.06)withChildStr:@""];
    label.center=CGPointMake(screenWidth/2,screenHeight*.03);
    [self.view addSubview:label];
}

-(void)viewDidAppear:(BOOL)animated
{
    [afterSchoolClass reloadData];
}

-(void)fillCompleteArray
{
    completeActivityArray=[[NSMutableArray alloc] init];
    
    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"After School"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"TUTION CLASS"}];
    [completeActivityArray addObject:@{@"key":@"banner3", @"value":@"Maths"}];
    [completeActivityArray addObject:@{@"key":@"banner3", @"value":@"Science"}];
    [completeActivityArray addObject:@{@"key":@"banner3", @"value":@"Physics"}];
    [completeActivityArray addObject:@{@"key":@"banner3", @"value":@"Chemistry"}];

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"] )
    {
        return screenHeight*.05;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"banner2"] )
    {
        return screenHeight*.05;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"banner3"] )
    {
        return screenHeight*.06;
    }
    
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Add New Activity ";
    
    
    UITableViewCell *cell;//=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"])
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text= [data objectForKey:@"value"];
        cell.backgroundColor=[UIColor  darkGrayColor];
    }
    
    else  if([[data valueForKey:@"key"] isEqualToString:@"banner2"])
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text= [data objectForKey:@"value"];
       
        cell.backgroundColor=[UIColor lightGrayColor];
    }
    else  if([[data valueForKey:@"key"] isEqualToString:@"banner3"])
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text= [data objectForKey:@"value"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.textColor=radiobuttonSelectionColor;
        cell.backgroundColor=appBackgroundColor;
//        ActivityDetails *activityDetails=[[ActivityDetails alloc]init];
//        [self.navigationController pushViewController:activityDetails animated:YES];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",tableCell.textLabel.text);
    if([tableCell.textLabel.text isEqualToString: @"Maths"])
    {
        ActivityDetails *activityDetails =[[ActivityDetails alloc]init];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
