//
//  ActivitySubjectDetailClassViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ActivitySubjectDetailClass.h"
#import "RedLabelView.h"
#import "TextAndDescTextCell.h"
@interface ActivitySubjectDetailClass ()

{
    NSMutableArray *completeActivityArray;
    
    UITableView *subjectDetailTableview;
    UIScrollView *scrollView;
    UITextView *notes;
    
    NSString *placeholderText;
    UIView *pickerView;
    UIButton *doneButton, *cancelButton , *customButton;
    UIDatePicker *picker;
    TextAndDescTextCell *tableCell;
    
}
@end

@implementation ActivitySubjectDetailClass

- (void)viewDidLoad {
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
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
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight*1.2);
    }
    [self.view addSubview:scrollView];
    
    [self childNameLabel];
    
    
    subjectDetailTableview = [[UITableView alloc]init];
    subjectDetailTableview.backgroundColor=[UIColor clearColor];
    subjectDetailTableview.frame =CGRectMake(0, .07*screenHeight, screenWidth, screenHeight*.8);
    subjectDetailTableview .delegate=self;
    subjectDetailTableview.dataSource=self;
    
    [scrollView addSubview:subjectDetailTableview];
    
    
    [[PC_DataManager sharedManager] getWidthHeight];
    [self fillCompleteArray];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addKeyBoardNotification];
    
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
//    label.clipsToBounds=YES;      //[label sizeToFit];
//    [scrollView addSubview:label];

    RedLabelView *label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*.06)withChildStr:@""];
    label.center=CGPointMake(screenWidth/2,screenHeight*.03);
    [self.view addSubview:label];

}

-(void)viewDidAppear:(BOOL)animated
{
    [subjectDetailTableview reloadData];
}


-(void)fillCompleteArray
{
    completeActivityArray=[[NSMutableArray alloc] init];
    
    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"After School"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Yoga Class"}];
    
    
    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Date",  @"Date":@"27 Jan, 2015"}];
    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Start", @"Start":@"10:am"}];
    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"End",   @"End":@"11:am"}];
    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Repeat",@"Repeat":@"Every Week"}];
    
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Reminder"}];
    
    [completeActivityArray addObject:@{@"key":@"switch", @"value":@"Mark Special"}];
    [completeActivityArray addObject:@{@"key":@"switch", @"value":@"Mark private"}];
    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Inform Ally",@"Inform Ally":@"Ally1"}];
    
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Note"}];
    
    [completeActivityArray addObject:@{@"key":@"textbox", @"value":@"textbox"}];
}
-(void)addGotoMerchant
{
    customButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [customButton setTitle:@"FINISH" forState:UIControlStateNormal];
    customButton.tintColor=radiobuttonSelectionColor;
    customButton.backgroundColor=[UIColor clearColor];
    [customButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    customButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.018*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [customButton sizeToFit];
    // customButton.frame=CGRectMake(.2*screenWidth, .8*screenHeight, .73*screenWidth, .07*screenHeight);
    customButton.layer.borderWidth=1.0;
    customButton.layer.borderColor=radiobuttonSelectionColor.CGColor;
    [customButton addTarget:self action:@selector(customBtnTouched) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark TableView Specific Function
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
    
    if([[data valueForKey:@"key"] isEqualToString:@"navigation"] )
    {
        return screenHeight*.06;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"switch"] )
    {
        return screenHeight*.1;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"textbox"] )
    {
        return screenHeight*.3;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    static NSString *CellIdentifier = @"DetailPlanViewCell";
//    static NSString *CellIdentifier = @"DetailPlanViewCell";
//    static NSString *CellIdentifier = @"DetailPlanViewCell";
//    static NSString *CellIdentifier = @"DetailPlanViewCell";
//    static NSString *CellIdentifier = @"DetailPlanViewCell";
//    static NSString *CellIdentifier = @"DetailPlanViewCell";
//    static NSString *CellIdentifier = @"DetailPlanViewCell";
    //DetailPlanViewCell *cell = [[DetailPlanViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    TextAndDescTextCell *cell;//=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading1Code andDecsColor:cellTextColor andType:@"Banner"];
       // cell.textLabel.text= [data objectForKey:@"value"];
        // cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
        cell.backgroundColor=activityHeading1FontCode;
    }
    else  if([[data valueForKey:@"key"] isEqualToString:@"banner2"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
//        cell.textLabel.text= [data objectForKey:@"value"];
        // cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
         [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading1Code andDecsColor:cellTextColor andType:@"Banner"];
        cell.backgroundColor=activityHeading2FontCode;
    }
    
    // else   if([[data valueForKey:@"key"] isEqualToString:@"banner2"])
    //    {
    //
    //        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    //        cell.textLabel.text= [data objectForKey:@"value"];
    //        // cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
    //        cell.backgroundColor=[UIColor lightGrayColor];
    //    }
    
    else if([[data valueForKey:@"key"] isEqualToString:@"navigation"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = [data objectForKey:@"value"];
        cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
        [cell.detailTextLabel setCenter:CGPointMake(cell.detailTextLabel.center.x-cellPadding, cell.detailTextLabel.center.y)];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
    
    else if([[data valueForKey:@"key"] isEqualToString:@"switch"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = [data objectForKey:@"value"];
        cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else if([[data valueForKey:@"key"] isEqualToString:@"textbox"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        notes = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
        [notes setDelegate:self];
        [notes setFont:[UIFont fontWithName:@"Enriqueta" size:15]];
        [notes setScrollEnabled:NO];
        [notes setUserInteractionEnabled:YES];
        notes.editable=YES;
        [notes setBackgroundColor:[UIColor clearColor]];
        // [notes setText:@"Type Note Here...."];
        placeholderText = @"Type Note Here....";
        [notes setText:placeholderText];
        CGRect frame = notes.frame;
        frame.size.height = notes.contentSize.height;
        notes.frame = frame;
        [cell addSubview:notes];
        
        [self addGotoMerchant];
        customButton.frame=CGRectMake(20,100,200,40);
        //customButton.backgroundColor=buttonGreenColor;
        customButton.center=CGPointMake(screenWidth/2, customButton.center.y);
        [cell addSubview:customButton];

    }
    
    
    else
    {
        
        cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    NSLog(@"data  %@", [completeActivityArray objectAtIndex:indexPath.row]);
    
    
    
    
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    if([tableCell.textLabel.text isEqualToString: @"Date"])
    {
        
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
        }
        
        NSLog(@"in selection %@",tableCell.class);
        [self drawDatePicker];
        picker.datePickerMode=UIDatePickerModeDate;
        // [pickerView removeFromSuperview];
        
        //   tableCell.inputView=picker
        
    }
    else if([tableCell.textLabel.text isEqualToString: @"Start"]|| [tableCell.textLabel.text isEqualToString: @"End"] )
    {
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
            pickerView=nil;
            
            
        }
        NSLog(@"in selection %@",tableCell.class);
        [self drawDatePicker];
        picker.datePickerMode=UIDatePickerModeTime;
        
        
    }
    
    else if ([tableCell.textLabel.text isEqualToString: @"Repeat"])
    {
//        ActivitySubjectDetailCal *activitysubjectCal=[[ActivitySubjectDetailCal alloc]init];
//        [self presentViewController:activitysubjectCal animated:YES completion:nil];
    }
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
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
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
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
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

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    if([tableCell.textLabel.text isEqualToString:@"Mark Special"])
    {
        
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
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(0, screenHeight-scrollView.frame.size.height/2, screenWidth, screenHeight/2)];
    [scrollView addSubview:pickerView];
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
    doneButton.frame=CGRectMake(pickerView.frame.size.width-doneButton.frame.size.width,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [doneButton addTarget:self action:@selector(ClickOnDone) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:doneButton];
    
       
    picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(pickerView.frame.origin.x, pickerView.frame.size.height*.12, pickerView.frame.size.width, pickerView.frame.size.height);
    [pickerView addSubview:picker];
    // .inputView=picker;
}



-(void)ClickOnDone
{
    
    NSDate *date = picker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    if([tableCell.textLabel.text isEqualToString:@"Date"])
    {
        [dateFormat setDateFormat:@"dd MMMM, yyyy"];
        NSString *dateString = [dateFormat stringFromDate:date];
        tableCell.detailTextLabel.text =dateString;
        [pickerView removeFromSuperview];
        
    }
    else if([tableCell.textLabel.text isEqualToString:@"Start"]|| [tableCell.textLabel.text isEqualToString:@"End"])
    {
        [dateFormat setDateFormat:@"hh:mm a"];
        [dateFormat setAMSymbol:@"AM "];
        [dateFormat setPMSymbol:@"PM "];
        NSString *dateString = [dateFormat stringFromDate:date];
        tableCell.detailTextLabel.text =dateString;
        [pickerView removeFromSuperview];
    }
    [subjectDetailTableview reloadData];
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
