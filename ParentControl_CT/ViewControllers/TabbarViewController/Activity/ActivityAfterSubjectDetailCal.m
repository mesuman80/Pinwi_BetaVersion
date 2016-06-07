//
//  ActivitySubjectDetailCal.m
//  ParentControl_CT
//
//  Created by Priyanka on 19/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ActivitySubjectDetailCal.h"

@interface ActivitySubjectDetailCal ()

{
    
     
    NSMutableArray *completeActivityArray;
    
    UITableView *detailTableView;
    UIScrollView *scrollView;
    UITextView *notes;
    NSString *placeholderText;
    UIView *pickerView;
    UIButton *doneButton, *cancelButton;
    UIDatePicker *picker;
    UITableViewCell *tableCell;
    UIImageView *exam;
    UIButton  *customButton;
    AddSubjectActivity *addSubjectActivity;
    NSString *examDate;
    NSString *daysStr;
}

@end

@implementation ActivitySubjectDetailCal
{
    
}
@synthesize child;
@synthesize subjectID;
@synthesize subject;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [[PC_DataManager sharedManager] getWidthHeight];
    
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
    
    detailTableView = [[UITableView alloc]init];
    detailTableView.backgroundColor=[UIColor clearColor];
    detailTableView.frame =CGRectMake(0, .07*screenHeight, screenWidth, screenHeight*.77);
    detailTableView .delegate=self;
    detailTableView.dataSource=self;
    
    [scrollView addSubview:detailTableView];
    
    
    [self fillCompleteArray];
    daysStr=@"";
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addKeyBoardNotification];
    
}


-(void)childNameLabel
{
    UILabel *label=[[UILabel alloc]init];
    
    
    
    NSString *str=child.name;
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
   // [detailTableView reloadData];
}


-(void)fillCompleteArray
{
    completeActivityArray=[[NSMutableArray alloc] init];
    
    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"Subject Calendar"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":subject}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Monday"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Tuesday"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Wednesday"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Thursday"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Friday"} ];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Saturday"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Sunday"}];
    
    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Exam Date",  @"Date":@"22 Feb 2015"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Note"}];


    [completeActivityArray addObject:@{@"key":@"textbox", @"value":@"textbox"}];
    
   // [completeActivityArray addObject:@{@"key":@"Button", @"value":@"textbox"}];
    
}

-(void)addGotoMerchant
{
    customButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [customButton setTitle:@"FINISH" forState:UIControlStateNormal];
    customButton.tintColor=radiobuttonSelectionColor;
    customButton.backgroundColor=[UIColor clearColor];
    [customButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    customButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:.018*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [customButton sizeToFit];
   // customButton.frame=CGRectMake(.2*screenWidth, .8*screenHeight, .73*screenWidth, .07*screenHeight);
    customButton.layer.borderWidth=1.0;
    customButton.layer.borderColor=radiobuttonSelectionColor.CGColor;
    [customButton addTarget:self action:@selector(customBtnTouched) forControlEvents:UIControlEventTouchUpInside];
}

-(void)customBtnTouched
{
    if([daysStr length]>1)
    {
        daysStr=[daysStr substringFromIndex:1];
    }
    if([examDate isEqualToString:@""] || examDate==nil)
    {
        examDate=@"Not Added";
    }
    addSubjectActivity=[[AddSubjectActivity alloc]init];
    [addSubjectActivity initService:@{
                                     @"ActivityID"  :[NSString stringWithFormat:@"%i",subjectID],
                                     @"ChildID"     :self.child.child_ID,
                                     @"ActivityDays":daysStr,
                                     @"Remarks"     :notes.text,
                                     @"ExamDate"    :examDate
                                         }];
    [addSubjectActivity setDelegate:self];
    
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
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Activity" message:@"Subject Activity scheduled!!" delegate:nil cancelButtonTitle:@"Ok " otherButtonTitles:nil, nil];
    [alert show];

    [self.navigationController popToRootViewControllerAnimated:YES];
   // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
        return 30;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"banner2"] )
    {
        return 30;
    }

    
    if([[data valueForKey:@"key"] isEqualToString:@"Days"] )
    {
        return 40;
    }
    
    if([[data valueForKey:@"key"] isEqualToString:@"navigation"] )
    {
        return 50;
    }

    if([[data valueForKey:@"key"] isEqualToString:@"textbox"] )
    {
        return 180;
    }
    
//    if([[data valueForKey:@"key"] isEqualToString:@"Button"] )
//    {
//        return 70;
//    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Activity Subject Detail";
    //DetailPlanViewCell *cell = [[DetailPlanViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    UITableViewCell *cell;//=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
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
    
    
    
    
    else if([[data valueForKey:@"key"] isEqualToString:@"Days"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = [data objectForKey:@"value"];
    }
    
    else if([[data valueForKey:@"key"] isEqualToString:@"navigation"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = [data objectForKey:@"value"];
        cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"calendar-667h@2x.png"];
        cell.imageView.image = imgView.image;
        UIImageView *imgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar-667h@2x.png"]];
        cell.accessoryView=imgView1;
        
//        [cell.accessoryView setUserInteractionEnabled:YES];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
//        [tap setNumberOfTouchesRequired:1];
//        [tap setNumberOfTapsRequired:1];
//        [cell.accessoryView addGestureRecognizer:tap];

    }
    else if([[data valueForKey:@"key"] isEqualToString:@"textbox"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        notes = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 120)];
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
    
//    else if([[data valueForKey:@"key"] isEqualToString:@"Button"])
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
//        [self addGotoMerchant];
//        [cell addSubview:customButton];
//    }
    

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
    NSLog(@"%@",tableCell.textLabel.text);
    
    if([tableCell.textLabel.text isEqualToString: @"Exam Date"] )
    {
        [self drawDatePicker];
    }
    
    
    if([tableCell.textLabel.text isEqualToString: @"Sunday"] )
    {
        if ([tableCell accessoryType] == UITableViewCellAccessoryNone) {
            [tableCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            daysStr= [daysStr stringByAppendingString:@",1"];
            
        } else {
            [tableCell setAccessoryType:UITableViewCellAccessoryNone];
            daysStr= [daysStr stringByReplacingOccurrencesOfString:@",1" withString:@""];
        }
    }

    if([tableCell.textLabel.text isEqualToString: @"Monday"] )
    {
        if ([tableCell accessoryType] == UITableViewCellAccessoryNone) {
            [tableCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            daysStr= [daysStr stringByAppendingString:@",2"];
            
        } else {
            [tableCell setAccessoryType:UITableViewCellAccessoryNone];
            daysStr= [daysStr stringByReplacingOccurrencesOfString:@",2" withString:@""];
        }

    }

    if([tableCell.textLabel.text isEqualToString: @"Tuesday"] )
    {
        if ([tableCell accessoryType] == UITableViewCellAccessoryNone) {
            [tableCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            daysStr= [daysStr stringByAppendingString:@",3"];
            
        } else {
            [tableCell setAccessoryType:UITableViewCellAccessoryNone];
            daysStr= [daysStr stringByReplacingOccurrencesOfString:@",3" withString:@""];
        }

    }
    
    if([tableCell.textLabel.text isEqualToString: @"Wednesday"])
    {
        if ([tableCell accessoryType] == UITableViewCellAccessoryNone) {
            [tableCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            daysStr= [daysStr stringByAppendingString:@",4"];
            
        } else {
            [tableCell setAccessoryType:UITableViewCellAccessoryNone];
            daysStr= [daysStr stringByReplacingOccurrencesOfString:@",4" withString:@""];
        }

    }

    if([tableCell.textLabel.text isEqualToString: @"Thursday"] )
    {
        if ([tableCell accessoryType] == UITableViewCellAccessoryNone) {
            [tableCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            daysStr= [daysStr stringByAppendingString:@",5"];
            
        } else {
            [tableCell setAccessoryType:UITableViewCellAccessoryNone];
            daysStr= [daysStr stringByReplacingOccurrencesOfString:@",5" withString:@""];
        }

    }

    if([tableCell.textLabel.text isEqualToString: @"Friday"])
    {
        if ([tableCell accessoryType] == UITableViewCellAccessoryNone) {
            [tableCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            daysStr= [daysStr stringByAppendingString:@",6"];
            
        } else {
            [tableCell setAccessoryType:UITableViewCellAccessoryNone];
            daysStr= [daysStr stringByReplacingOccurrencesOfString:@",6" withString:@""];
        }

    }

    if([tableCell.textLabel.text isEqualToString: @"Saturday"])
    {
        if ([tableCell accessoryType] == UITableViewCellAccessoryNone) {
            [tableCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            daysStr= [daysStr stringByAppendingString:@",7"];
            
        } else {
            [tableCell setAccessoryType:UITableViewCellAccessoryNone];
            daysStr= [daysStr stringByReplacingOccurrencesOfString:@",7" withString:@""];
        }

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    doneButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.tintColor=[UIColor darkGrayColor];
    doneButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    doneButton.frame=CGRectMake(0,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [doneButton addTarget:self action:@selector(ClickOnDone) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:doneButton];
    
    cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.tintColor=[UIColor darkGrayColor];
    cancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [cancelButton sizeToFit];
    cancelButton.frame=CGRectMake(pickerView.frame.size.width-doneButton.frame.size.width,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [cancelButton addTarget:self action:@selector(ClickOnCancel) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:cancelButton];
    
    
    picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
     picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(pickerView.frame.origin.x, pickerView.frame.size.height*.12, pickerView.frame.size.width, pickerView.frame.size.height);
    [pickerView addSubview:picker];
    // .inputView=picker;
}



-(void)ClickOnDone
{
    
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
