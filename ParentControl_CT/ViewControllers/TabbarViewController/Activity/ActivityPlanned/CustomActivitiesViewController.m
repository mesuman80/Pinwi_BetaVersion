//
//  CustomActivitiesViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 27/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CustomActivitiesViewController.h"
#import "AfterSchoolActivitiesSubCat.h"
#import "AfterSchoolActivities.h"
#import "ShowActivityLoadingView.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"

@interface CustomActivitiesViewController ()<AfterSchoolActivitiesSubCatProtocol,AfterSchoolActivitiesProtocol,HeaderViewProtocol>

@end

@implementation CustomActivitiesViewController
{
    NSMutableArray *completeActivityArray;
   
    UITableView *customActivityTableview;
    TextAndDescTextCell *tableCell;
    TextAndDescTextCell *tableCell1;
    UITextField *nameOfActivity;
    UIButton *SubmitButton;
   ShowActivityLoadingView *loaderView;
    NSString *catname;
    
    HeaderView *headerView;
    RedLabelView *label;
    int yy;
    
}
@synthesize  categoryName,subCategoryName;

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
    [self drawTableListView];
    [self fillCompleteArray];
   [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
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
    if(!customActivityTableview)
    {
        customActivityTableview = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
        customActivityTableview.backgroundColor=appBackgroundColor;
        customActivityTableview .delegate=self;
        customActivityTableview.dataSource=self;
        customActivityTableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:customActivityTableview];
    }
}

-(void)fillCompleteArray
{
    completeActivityArray=[[NSMutableArray alloc] init];
    
    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"Custom"}];
    [completeActivityArray addObject:@{@"key":@"banner2",@"value": @" "}];
    [completeActivityArray addObject:@{@"key":@"banner3", @"Type":@"Category", @"value":@" "}];
    [completeActivityArray addObject:@{@"key":@"banner3", @"Type":@"Sub Category", @"value":@" "}];
    [completeActivityArray addObject:@{@"key":@"banner4", @"value":@"Submit"}];
    
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

    if([[data valueForKey:@"key"] isEqualToString:@"banner3"] )
    {
        return ScreenHeightFactor*42;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"banner4"] )
    {
        return ScreenHeightFactor*42;
    }
    
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier1 = @"CustomCellIdentifier";
    static NSString *CellIdentifier2 = @"NameCellIdentifier ";
    static NSString *CellIdentifier3 = @"CatagoryCellIdentifier";
    static NSString *CellIdentifier4 = @"ButtonCellIdentifier";
    
    TextAndDescTextCell *cell;//=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
   
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
        }
        
        [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
        //cell.textLabel.text= [data objectForKey:@"value"];
        cell.backgroundColor=activityHeading1Code;
//        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
//        cell.textLabel.textColor=activityHeading1FontCode;
    }
  else  if([[data valueForKey:@"key"] isEqualToString:@"banner2"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2];
        }
        if(!nameOfActivity)
        {
            if(screenWidth>700)
            {
            nameOfActivity=[[UITextField alloc] initWithFrame:CGRectMake(cellPadding, .02*screenHeight, screenWidth-2*cellPadding, .05*screenHeight)];
            }
            else
            {
              nameOfActivity=[[UITextField alloc] initWithFrame:CGRectMake(cellPadding, .02*screenHeight, screenWidth-2*cellPadding, .05*screenHeight)];
            }
            nameOfActivity.delegate=self;
            //nameOfActivity.center=CGPointMake(screenWidth, screenHeight*.05);
            //nameOfActivity.placeholder = @"Name Of Activity";
            nameOfActivity.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name Of Activity"attributes:@{NSForegroundColorAttributeName: placeHolderReg, NSFontAttributeName: RobotoRegular}];
           
            nameOfActivity.textColor=placeHolderReg;
            [nameOfActivity setFont:[UIFont fontWithName:RobotoRegular size:11*ScreenFactor]];
            //[nameOfActivity setClearButtonMode:UITextFieldViewModeWhileEditing];
            nameOfActivity.autocorrectionType=UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:nameOfActivity];
            cell.backgroundColor=appBackgroundColor;
        }
        
    }
    
    else  if([[data valueForKey:@"key"] isEqualToString:@"banner3"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier3];
        }
        
        
       
            if ([[data valueForKey:@"Type"] isEqualToString:@"Category"]) {
                 [cell addText:self.categoryName andDesc:@"" withTextColor:placeHolderReg andDecsColor:cellTextColor andType:@""];
            }
            if ([[data valueForKey:@"Type"] isEqualToString:@"Sub Category"]) {
                 [cell addText:self.subCategoryName andDesc:@"" withTextColor:placeHolderReg andDecsColor:cellTextColor andType:@""];
            }
     
       
        [cell.arrowImageView setAlpha:1.0f];
//        cell.textLabel.text= [data objectForKey:@"Type"];
//        cell.textLabel.textColor=placeHolderReg;
//        cell.textLabel.font=[UIFont fontWithName:RobotoLight size:11*ScreenFactor];
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//        cell.backgroundColor=appBackgroundColor;
    }
    
    else  if([[data valueForKey:@"key"] isEqualToString:@"banner4"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier4];
        }
        if(!SubmitButton)
        {
        SubmitButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [SubmitButton setTitle:@"Submit" forState:UIControlStateNormal];
        SubmitButton.tintColor=textBlueColor;
        SubmitButton.backgroundColor=[UIColor clearColor];
        //SubmitButton.layer.borderColor = radiobuttonSelectionColor.CGColor;
       // SubmitButton.layer.borderWidth = 1.0;
        [SubmitButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        SubmitButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
        [SubmitButton sizeToFit];
        SubmitButton.frame=CGRectMake(ScreenWidthFactor*20,ScreenHeightFactor*5,screenWidth- ScreenWidthFactor*40,ScreenHeightFactor*32);
       // SubmitButton.center=CGPointMake(screenWidth*.5,screenHeight*.5);
        [SubmitButton addTarget:self action:@selector(submitButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:SubmitButton];
            cell.backgroundColor=appBackgroundColor;
        }
    }
   
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",tableCell.textLabel.text);
    
    NSDictionary *datadict=[completeActivityArray objectAtIndex:indexPath.row];
//    
//    UIBarButtonItem *newBackButton =
//    [[UIBarButtonItem alloc] initWithTitle:@""
//                                     style:UIBarButtonItemStyleBordered
//                                    target:nil
//                                    action:nil];
//    [[self navigationItem] setBackBarButtonItem:newBackButton];
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
   UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    if([[datadict objectForKey:@"Type"] isEqualToString: @"Category"])
    {
      AfterSchoolActivities *afterSchoolactivities=[[AfterSchoolActivities alloc]init];
        afterSchoolactivities.afterChild=self.child;
        afterSchoolactivities.afterSchoolActivitiesDelegate=self;
        afterSchoolactivities.parentClass=@"CustomActivitiesViewController";
       // afterSchoolactivities.
        [self.navigationController pushViewController:afterSchoolactivities animated:YES];
        
    }
    else if([[datadict objectForKey:@"Type"] isEqualToString: @"Sub Category"])
    {
        
        if(self.catagoryID.length==0 || [self.catagoryID isEqualToString:@""])
        {
            UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Incomplete Data" message:@"You must enter a name and choose category/sub actegory to add a custom activity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
        }
        else{
        AfterSchoolActivitiesSubCat *academics=[[AfterSchoolActivitiesSubCat alloc]init];
        academics.afterChild=self.child;
        academics.catIndex=self.catagoryID;
        academics.catName=catname;
        academics.AfterSchoolSubCatDelegate=self;
        academics.parentClass=@"CustomActivitiesViewController";
        [self.navigationController pushViewController:academics animated:YES];
        }
//        [self.navigationController pushViewController:afterSchoolactivities animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark CATAGORY AND SUB-CATAGORY DELEGATES
-(void)catagoryID:(NSString *)catID andName:(NSString *)catName
{
    self.catagoryID=catID;
    tableCell.textlabel1.text=catName;
    [tableCell.textlabel1 sizeToFit];
     [tableCell.textlabel1 setTextColor:cellTextColor];
    catname=catName;
}

-(void)subCatagoryID:(NSString *)catID andName:(NSString *)catName
{
    self.subCatagoryID=catID;
    tableCell.textlabel1.text=catName;
      [tableCell.textlabel1 sizeToFit];
    [tableCell.textlabel1 setTextColor:cellTextColor];
}

-(void) submitButtonTouched
{
    NSLog(@"parent id:%@",[PC_DataManager sharedManager].parentObjectInstance.parentId);
    
    if(nameOfActivity.text.length==0 || [nameOfActivity.text isEqualToString:@""])
    {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Incomplete Data" message:@"You must enter a name to add a custom activity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
    }
 
    else if(!self.subCatagoryID)
    {
        UIAlertView *alrt1=[[UIAlertView alloc]initWithTitle:@"Incomplete Data" message:@"You must choose a category/sub category to add a custom activity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt1 show];
    }
    else
    {
        AddCustomActivity  *addCustomActivity = [[AddCustomActivity alloc] init];
        [addCustomActivity initService:@{
                                         @"Name":[NSString stringWithFormat:@"%@",nameOfActivity.text],
                                         @"SubCategoryID":[NSString stringWithFormat:@"%@",self.subCatagoryID],
                                         @"ParentID":[NSString stringWithFormat:@"%@",[PC_DataManager sharedManager].parentObjectInstance.parentId]
                                         }];
        [addCustomActivity setDelegate:self];
        [self addLoaderView];
    }

}
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    [self removeLoaderView];
    [self.navigationController popViewControllerAnimated:YES];
    [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:@""];
    // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

//-(void) keyboardWillShow:(NSNotification *)notification
//{
//    NSDictionary* info = [notification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0, kbSize.height+64, 0.0);
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    CGPoint point=activeField.frame.origin;
//    // point.y+=66;
//    if (!CGRectContainsPoint(aRect,point))
//    {
//        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
//        [scrollView setContentOffset:scrollPoint animated:YES];
//    }
//}
//-(void) keyboardWillHide:(NSNotification *)notification
//{
//    [self hideKeyBoard];
//}
//-(void)hideKeyBoard
//{
//    UIEdgeInsets contentInsets=UIEdgeInsetsMake(0, 0.0,0.0, 0.0);
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
//    NSLog(@"Live=%f",self.view.frame.size.height/2.0f);
//}
//


-(BOOL)becomeFirstResponder
{
    return YES;
}

-(BOOL)resignFirstResponder
{
    return YES;
}


-(void)resignOnTap:(id)sender
{
    [nameOfActivity resignFirstResponder];
}
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
    
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    [nameOfActivity endEditing:YES];
  //  textField.placeholder = @"";
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    [nameOfActivity resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
//    if([textField isKindOfClass:[nameOfActivity class]])
//    {
//        textField.placeholder = @"";
//        textField.attributedPlaceholder = nil;
//        NSLog(@" textField.attributedPlaceholder %@",  textField.attributedPlaceholder);
//        NSLog(@" textField.placeholder %@",  textField.placeholder);
//
//    }
//    textField.placeholder = @"";
//     textField.attributedPlaceholder = nil;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
   // textField.placeholder = @"";
   // nameOfActivity.attributedPlaceholder = @"Name Of Activity";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
