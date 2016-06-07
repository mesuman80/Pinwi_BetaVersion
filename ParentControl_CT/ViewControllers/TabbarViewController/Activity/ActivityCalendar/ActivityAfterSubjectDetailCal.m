//
//  ActivitySubjectDetailCal.m
//  ParentControl_CT
//
//  Created by Priyanka on 19/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ActivityAfterSubjectDetailCal.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"
#import "AfterSchoolActivityDataClass.h"


@interface ActivityAfterSubjectDetailCal ()<HeaderViewProtocol>

{
    
    
    NSMutableArray *completeActivityArray;
    
    UITableView *detailTableView;
    // UIScrollView *scrollView;
    UITextView *notes;
    NSString *placeholderText;
    UIView *pickerView;
    UIButton *doneButton, *cancelButton;
    UIDatePicker *picker;
    TextAndDescTextCell *tableCell;
    UIImageView *exam;
    UIButton  *customButton;
    AddAfterSchoolActivities *addSubjectActivity;
    NSString *examDate;
    NSString *daysStr;
    
    HeaderView *headerView;
    RedLabelView *label;
    int yy;
}

@end

@implementation ActivityAfterSubjectDetailCal
{
    
}
@synthesize child;
@synthesize subjectID;
@synthesize subject;
@synthesize parentClass;

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
    [self addKeyBoardNotification];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
    NSLog(@"Appear: days string is : %@",[PC_DataManager sharedManager].repeatDaysString);
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear in Activity After Subject Detail");
   //[self tableView:detailTableView didSelectRowAtIndexPath:[NSIndexPath  indexPathForRow:11 inSection:0] ];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"DisAppear: days string is : %@",[PC_DataManager sharedManager].repeatDaysString);
    

    
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
        [headerView setRightType:@"Save"];
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
    NSString *str = [PC_DataManager sharedManager].repeatDaysString;
    NSLog(@"back btn touch: days string is : %@",[PC_DataManager sharedManager].repeatDaysString);
    if(([[PC_DataManager sharedManager].repeatDaysString length]>1 && [[[PC_DataManager sharedManager].repeatDaysString substringToIndex:1]isEqualToString:@","]) )
    {
        NSString * daysStr1=[[PC_DataManager sharedManager].repeatDaysString mutableCopy];
        daysStr1= [daysStr1 substringFromIndex:1];
        [PC_DataManager sharedManager].repeatDaysString=[daysStr1 mutableCopy];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getMenuTouches
{
    NSLog(@"save button: days string is : %@",[PC_DataManager sharedManager].repeatDaysString);
    NSLog(@"%@",daysStr);
    if([daysStr length]>1 && [[daysStr substringToIndex:1]isEqualToString:@","] )
    {
        daysStr=[daysStr substringFromIndex:1];
        [PC_DataManager sharedManager].repeatDaysString=[daysStr mutableCopy];
    }
    
    else if([daysStr isEqualToString:@""])
    {
        daysStr = @"1,2,3,4,5,6,7";
        [PC_DataManager sharedManager].repeatDaysString= daysStr.mutableCopy;
    }
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
    if(!detailTableView)
    {
//        if(!isPhone667)
//        {
           detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
//        }
//        else{
//        detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy)];
//        }
        detailTableView.backgroundColor=appBackgroundColor;
        detailTableView .delegate=self;
        detailTableView.dataSource=self;
        detailTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:detailTableView];
    }
}


-(void)fillCompleteArray
{
    completeActivityArray=[[NSMutableArray alloc] init];
    
    if(!self.activityName)
    {
        self.activityName=@"After School";
    }
    
    
    NSMutableArray *newArr=[[NSMutableArray alloc]init];
    NSLog(@"repeatDaysString = %@",[PC_DataManager sharedManager].repeatDaysString);
   
    if([PC_DataManager sharedManager].repeatDaysString.length>0)
    {
        NSArray *selectedArray=[[PC_DataManager sharedManager].repeatDaysString componentsSeparatedByString:@","];
        
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:selectedArray];
        selectedArray = [orderedSet array];
        
        selectedArray = [selectedArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
        
        int cnt=0;
        for(NSString * str1 in selectedArray)
        {
            int val = [str1 intValue];
            val = val - cnt;
            //cnt=0;
            for(int i=1; i<val;i++){
                [newArr addObject:@"0"];
                cnt++;
            }
            [newArr addObject:@"1"];
            cnt++;
        }
        NSLog(@"newArr  %@", newArr);
        if(newArr.count<7){
            for(int val=(int)newArr.count; val<7; val++){
                [newArr addObject:@"0"];
            }
        }
        
        
        [PC_DataManager sharedManager].repeatDaysString=[[NSString stringWithFormat:@",%@",[PC_DataManager sharedManager].repeatDaysString] mutableCopy];
        if([[PC_DataManager sharedManager].repeatDaysString isEqualToString:@",1,7"])
        {
            cnt=0;
            while (cnt<7) {
                [newArr replaceObjectAtIndex:cnt withObject:@"0"];
                cnt++;
            }
            [newArr addObject:@"0"];
            [newArr addObject:@"1"];
            [newArr addObject:@"0"];
        }
        if([[PC_DataManager sharedManager].repeatDaysString isEqualToString:@",2,3,4,5,6"])
        {
            cnt=0;
            while (cnt<7)
            {
                [newArr replaceObjectAtIndex:cnt withObject:@"0"];
                cnt++;
            }
            [newArr addObject:@"1"];
            [newArr addObject:@"0"];
            [newArr addObject:@"0"];
        }
        else if([[PC_DataManager sharedManager].repeatDaysString isEqualToString:@",1,2,3,4,5,6,7"])
        {
            cnt=0;
            while (cnt<7)
            {
                [newArr replaceObjectAtIndex:cnt withObject:@"0"];
                cnt++;
            }
            [newArr addObject:@"0"];
            [newArr addObject:@"0"];
            [newArr addObject:@"1"];
        }
        else
        {
            [newArr addObject:@"0"];
            [newArr addObject:@"0"];
            [newArr addObject:@"0"];
        }
    }
    else
    {
        for(int i=0;i<10;i++)
        {
            [newArr addObject:@"0"];
        }
    }
//    if(daysStr && daysStr.length >0) {
//        daysStr =
//    }
    daysStr= [PC_DataManager sharedManager].repeatDaysString;
    
    
    AfterSchoolActivityDataClass *afterSchoolActivityDataClass = [[AfterSchoolActivityDataClass alloc] init];
    [afterSchoolActivityDataClass setType:@"banner1"];
    [afterSchoolActivityDataClass setValue:self.activityName];
    [afterSchoolActivityDataClass setIsSelect:false];
    [completeActivityArray addObject:afterSchoolActivityDataClass];
    
    
    AfterSchoolActivityDataClass *afterSchoolActivityDataClass1 = [[AfterSchoolActivityDataClass alloc] init];
    [afterSchoolActivityDataClass1 setType:@"banner2"];
    [afterSchoolActivityDataClass1 setValue:self.subject];
    [afterSchoolActivityDataClass1 setIsSelect:false];
    [completeActivityArray addObject:afterSchoolActivityDataClass1];

    

    
    
    NSArray *dayArr=@[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Week days",@"Weekend",@"All days"];
    
    int i=0;
    for(NSString *str in dayArr)
    {
        NSString *isSelected = [newArr objectAtIndex:i];
        AfterSchoolActivityDataClass *afterSchoolActivityDataClass = [[AfterSchoolActivityDataClass alloc] init];
        [afterSchoolActivityDataClass setIndex:i];
        [afterSchoolActivityDataClass setType:@"Days"];
        [afterSchoolActivityDataClass setValue:str];
//        if([str isEqualToString:@"All days"]) {
//            [afterSchoolActivityDataClass setIsSelect:true];
//        }
//        else {
            [afterSchoolActivityDataClass setIsSelect:isSelected.boolValue];
        //}
        
        [completeActivityArray addObject:afterSchoolActivityDataClass];
        
        i++;
    }
    
    if ([PC_DataManager sharedManager].repeatDaysString.length==0) {
         AfterSchoolActivityDataClass *afterSchoolActivityDataClass = [completeActivityArray objectAtIndex:11];
         [afterSchoolActivityDataClass setIsSelect:true];
        daysStr = @",1,2,3,4,5,6,7" ;
    }
    
    //    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Monday"       , @"Index":@"0" ,@"isSelected":@"0"}];
    //    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Tuesday"      , @"Index":@"1" ,@"isSelected":@"0"}];
    //    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Wednesday"    , @"Index":@"2" ,@"isSelected":@"0"}];
    //    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Thursday"     , @"Index":@"3" ,@"isSelected":@"0"}];
    //    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Friday"       , @"Index":@"4" ,@"isSelected":@"0"}];
    //    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Saturday"     , @"Index":@"5" ,@"isSelected":@"0"}];
    //    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Sunday"       , @"Index":@"6" ,@"isSelected":@"0"}];
    //    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Week days"    , @"Index":@"7" ,@"isSelected":@"0"}];
    //    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Weekend"      , @"Index":@"8" ,@"isSelected":@"0"}];
    //    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Weekend"      , @"Index":@"9" ,@"isSelected":@"0"}];
    //    [completeActivityArray addObject:@{@"key":@"ok",   @"value":@"Done" }];
}


# pragma mark URL DELEGATES
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"result given: %@",dictionary);
    ActivityData *actData=[[ActivityData alloc]init];
    actData.activityId=[NSString stringWithFormat:@"%i",subjectID];
    actData.activityName=subject;
    actData.acitivityNotes=notes.text;
    actData.childId=self.child.child_ID;
    actData.parentId=[PC_DataManager sharedManager].parentObjectInstance.parentId;
    [[PC_DataManager sharedManager].activities addObject:actData];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AfterSchoolActivityDataClass *dataClass = [completeActivityArray objectAtIndex:indexPath.row];
    
    
    
    if([dataClass.type isEqualToString:@"banner1"] )
    {
        return ScreenHeightFactor*30;
    }
    if([dataClass.type  isEqualToString:@"banner2"] )
    {
        return ScreenHeightFactor*30;
    }
    if([dataClass.type  isEqualToString:@"Days"] )
    {
        return ScreenHeightFactor*42;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *Banner1CellIdentifier = @"ScheduleCellBanner1";
    static NSString *Banner2CellIdentifier = @"ScheduleCellBanner2";
    static NSString *DaysCellIdentifier    = @"ScheduleCellDays";
    static NSString *okCellIdentifier      = @"okCellDays";
    //DetailPlanViewCell *cell = [[DetailPlanViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    TextAndDescTextCell *cell;
    
    AfterSchoolActivityDataClass *activityData = [completeActivityArray objectAtIndex:indexPath.row];
    cell.backgroundColor=appBackgroundColor;
    if([activityData.type isEqualToString:@"banner1"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:Banner1CellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Banner1CellIdentifier];
        }
        [cell addText: activityData.value andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
//        cell.textLabel.text= [data objectForKey:@"value"];
//        cell.textLabel.textColor=activityHeading1FontCode;
//        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
        // cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
        cell.backgroundColor=activityHeading1Code;
    }
    
    else  if([activityData.type isEqualToString:@"banner2"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:Banner2CellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Banner2CellIdentifier];
        }
         [cell addText: activityData.value andDesc:@"" withTextColor:activityHeading2FontCode andDecsColor:cellTextColor andType:@"Banner"];
//        cell.textLabel.text= [data objectForKey:@"value"];
//        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
//        cell.textLabel.textColor=activityHeading2FontCode;
        cell.backgroundColor=activityHeading2Code;
    }
    else if([activityData.type isEqualToString:@"Days"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:DaysCellIdentifier];
//        if (indexPath.row == 11) {
//            [data setValue:@"1" forKey:@"isSelected"];
//        }
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DaysCellIdentifier];
        }
         [cell addText: activityData.value andDesc:@"" withTextColor:ActivityDaysColor andDecsColor:cellTextColor andType:@""];
        
        if(!activityData.isSelect)
        {
            cell.arrowImageView.image= nil ;
            cell.arrowImageView.alpha=0;
        }
        else{
             cell.arrowImageView.image=[UIImage imageNamed:isiPhoneiPad(@"selectedWeekDay.png")];
             cell.arrowImageView.alpha=1;
        }
        
        
         NSLog(@"data  %@", [completeActivityArray objectAtIndex:indexPath.row]);
    }
    
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
     NSLog(@"%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self tableView:detailTableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:2]];
     AfterSchoolActivityDataClass *activityData=[completeActivityArray objectAtIndex:indexPath.row];
    if(activityData.index >= 0 && activityData.index <7) {
       if(!activityData.isSelect) {
            AfterSchoolActivityDataClass *activityData9=[completeActivityArray objectAtIndex:9];
            AfterSchoolActivityDataClass *activityData10=[completeActivityArray objectAtIndex:10];
            AfterSchoolActivityDataClass *activityData11=[completeActivityArray objectAtIndex:11];
           if(activityData9.isSelect) {
               daysStr  = @"";
           }
           else if(activityData10.isSelect) {
               daysStr  = @"";
           }
           
           else if(activityData11.isSelect) {
               daysStr  = @"";
           }
           activityData9.isSelect = false;
           activityData10.isSelect = false;
           activityData11.isSelect = false;
               
        }
    }
    else  if (activityData.index >6 && activityData.index <10){
        daysStr  = @"";
        for(AfterSchoolActivityDataClass *obj in completeActivityArray) {
                //AfterSchoolActivityDataClass *activityData9=[completeActivityArray objectAtIndex:i];
            if([obj isEqual:activityData]) {
                continue;
            }
            
             [obj setIsSelect:NO];
           
        }
    }
    

    if(indexPath.row!=9 && indexPath.row!=10 && indexPath.row!=11)
    {
        [self validateCheckMark2];
    }
    
    NSLog(@"%@",tableCell.textLabel.text);
    
    if([activityData.value isEqualToString: @"Sunday"] )
    {
        
        [self updateViewCheck:@"Sunday" andDay:@",1" withDict:activityData];
    }
    
    if([activityData.value isEqualToString: @"Monday"] )
    {
        [self updateViewCheck:@"Monday" andDay:@",2" withDict:activityData];
        
    }
    
    if([activityData.value isEqualToString: @"Tuesday"] )
    {
        [self updateViewCheck:@"Tuesday" andDay:@",3" withDict:activityData];
        
    }
    
    if([activityData.value isEqualToString: @"Wednesday"])
    {
        [self updateViewCheck:@"Wednesday" andDay:@",4" withDict:activityData];
        
    }
    
    if([activityData.value isEqualToString: @"Thursday"] )
    {
        [self updateViewCheck:@"Thursday" andDay:@",5" withDict:activityData];
    }
    
    if([activityData.value isEqualToString: @"Friday"])
    {
        [self updateViewCheck:@"Friday" andDay:@",6" withDict:activityData];
    }
    
    if([activityData.value isEqualToString: @"Saturday"])
    {
        [self updateViewCheck:@"Saturday" andDay:@",7" withDict:activityData];
        
    }
    if([activityData.value isEqualToString: @"Week days"])
    {
        [self validateCheckMark];
        [self updateViewCheck:@"Week days" andDay:@",2,3,4,5,6" withDict:activityData];
        
    }
    
    if([activityData.value isEqualToString: @"Weekend"])
    {
        [self validateCheckMark];
        [self updateViewCheck:@"Weekend" andDay:@",1,7" withDict:activityData];
    }
    
    NSLog(@"tableCell.textlabel1.text = %@", tableCell.textlabel1.text);
    
    if([activityData.value isEqualToString: @"All days"])
    {
        [self validateCheckMark];
        [self updateViewCheck:@"All days" andDay:@",1,2,3,4,5,6,7" withDict:activityData];
    }
    
    if (indexPath.row == 11 && activityData.value == nil) {
        [self validateCheckMark];
        [activityData setIsSelect:YES]  ;
        daysStr= [daysStr stringByAppendingString:@",1,2,3,4,5,6,7"];
      
    }
//     NSLog(@"Day Sring = %@", daysStr);
    [tableView reloadData];

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    NSLog(@"%ld",(long)indexPath.row);
//    for (int i = 0; i<12; i++) {
//        if (i != indexPath.row) {
//            if ([[data valueForKey:@"isSelected"]isEqualToString:@"1"]) {
//                [data setValue:@"0" forKey:@"isSelected"];
//                TextAndDescTextCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:2]];
//                cell.arrowImageView.alpha=0;
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                cell.accessoryView = nil;
//            }
//        }
//    }
//    [tableView reloadData];
//    for (int section = 0, sectionCount = (int)detailTableView.numberOfSections; section < sectionCount; ++section)
//    {
//        for (int row = 2, rowCount = (int)[detailTableView numberOfRowsInSection:section]; row < rowCount; ++row)
//        {
//            TextAndDescTextCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
//            cell.arrowImageView.alpha=0;
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            cell.accessoryView = nil;
//        }
//    }
    
    
    // [tableView reloadData];

}



-(void)updateViewCheck:(NSString*)str andDay:(NSString*)dayNo withDict:(AfterSchoolActivityDataClass*)data
{
    
    
    if([data.value isEqualToString:str])
    {
        if(!data.isSelect)
        {
           
            daysStr= [daysStr stringByAppendingString:dayNo];
            data.isSelect =true;
        }
        else
        {
            //tableCell.arrowImageView.alpha=0;
          //  [tableCell setAccessoryType:UITableViewCellAccessoryNone];
            daysStr= [daysStr stringByReplacingOccurrencesOfString:dayNo withString:@""];
          //  [changeDict setObject:@"0" forKey:@"isSelected"];
             data.isSelect =false;
        }
        
    }
    
}


-(void)validateCheckMark
{
//    for (int section = 0, sectionCount = (int)detailTableView.numberOfSections; section < sectionCount; ++section)
//    {
//        for (int row = 2, rowCount = (int)[detailTableView numberOfRowsInSection:section]; row < rowCount; ++row)
//        {
//            TextAndDescTextCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
//            cell.arrowImageView.alpha=0;
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            cell.accessoryView = nil;
//        }
//    }
    daysStr=@"";
}

-(void)validateCheckMark2
{
    
    AfterSchoolActivityDataClass *dataClass  = [completeActivityArray objectAtIndex:9];
   // TextAndDescTextCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    if (dataClass.isSelect==YES)
    {
        dataClass.isSelect = false;
        daysStr=@"";
    }
    
    AfterSchoolActivityDataClass *dataClass1  = [completeActivityArray objectAtIndex:10];
   // TextAndDescTextCell *cell1 = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
    if (dataClass1.isSelect)
    {
        dataClass1.isSelect = false;
        
        daysStr=@"";
    }
     AfterSchoolActivityDataClass *dataClass11  = [completeActivityArray objectAtIndex:11];
    
   // TextAndDescTextCell *cell2 = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
    if (dataClass11.isSelect)
    {
         dataClass11.isSelect = false;
        daysStr=@"";
    }

}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    [self drawDatePicker];
}


-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) keyboardWillShow:(NSNotification *)note
{
    NSLog(@"KeyBoard wiil Show");
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    //[scrollView setFrame:CGRectMake(0,-20, scrollView.frame.size.width, scrollView.frame.size.height)];
    [UIView commitAnimations];
    
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(-150, 0, kbSize.height, 0);
    detailTableView.contentInset = contentInsets;
    detailTableView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    //    if (!CGRectContainsPoint(aRect, timeTextField.frame.origin) ) {
    //        CGPoint scrollPoint = CGPointMake(0.0, timeTextField.frame.origin.y-kbSize.height);
    //        [scrollView setContentOffset:scrollPoint animated:YES];
    //    }
    
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSLog(@"KeyBoard wiil Hide");
    UIEdgeInsets contentInsets=UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    detailTableView.contentInset = contentInsets;
    detailTableView.scrollIndicatorInsets = contentInsets;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        
    }
    else
    {
        
    }
    
    
    return YES;
    
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




-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:placeholderText])
    {
        textView.text = @"";
    }
    
}

-(void)drawDatePicker
{
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(0, screenHeight-self.view.frame.size.height/2-64, screenWidth, screenHeight/2)];
    [self.view addSubview:pickerView];
    pickerView.backgroundColor=[UIColor whiteColor];
    
    
    
    cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.tintColor=[UIColor darkGrayColor];
    cancelButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [cancelButton sizeToFit];
    cancelButton.frame=CGRectMake(0,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [cancelButton addTarget:self action:@selector(ClickOnCancel) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:cancelButton];
    
    doneButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.tintColor=[UIColor darkGrayColor];
    doneButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    doneButton.frame=CGRectMake(pickerView.frame.size.width-cancelButton.frame.size.width,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [doneButton addTarget:self action:@selector(ClickOnDone) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:doneButton];
    
    
    picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(pickerView.frame.origin.x, pickerView.frame.size.height*.12, pickerView.frame.size.width, pickerView.frame.size.height);
    picker.minimumDate  = [NSDate date];
    [pickerView addSubview:picker];
    // .inputView=picker;
}



-(void)ClickOnDone {
    NSDate *date = picker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    tableCell.detailTextLabel.text =dateString;
    examDate=dateString;
    [pickerView removeFromSuperview];
}

-(void)ClickOnCancel
{
    
    [pickerView removeFromSuperview];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
