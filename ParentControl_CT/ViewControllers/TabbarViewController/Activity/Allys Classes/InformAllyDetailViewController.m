//
//  InformAllyDetailViewController.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 22/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InformAllyDetailViewController.h"
#import "ShowActivityLoadingView.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"
#import "InformToAllyViewController.h"
#import "AddAllyInformationOnActivity.h"

@interface InformAllyDetailViewController ()<HeaderViewProtocol,InformAllyProtocol,UrlConnectionDelegate>
{
    NSMutableArray *completeActivityArray;
    // UIScrollView  *scrollView;
    TextAndDescTextCell *tableCell;
    UITextView *notes;
    NSString *placeholderText;
    UIView *pickerView;
    UIButton *doneButton, *cancelButton, *customButton;
    UIDatePicker *picker;
    
    UIImageView *profileImg;
    
    //AddAllyInformationOnActivity *addAllyInfo;
    ShowActivityLoadingView *loaderView;
    
    UIButton *sms;
    UIButton *email;
    
    
    NSString *isPickUp;
    NSString *isDrop;
    NSString *Date;
    NSString *time;
    UISegmentedControl *smsEmailCtrl;
    
    HeaderView *headerView;
    RedLabelView *label;
    int yy;
    int rowNumber;
    
    // NSString *notification
}

@end

@implementation InformAllyDetailViewController

@synthesize allyDetailTable;
@synthesize detailAlly;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PC_DataManager sharedManager] getWidthHeight];
    self.view.backgroundColor=appBackgroundColor;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //   [self childNameLabel];
    
    // [self loadTableView];
    
    isPickUp=@"0";
    isDrop=@"0";
    
    
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawHeaderView];
    [self childNameLabel];
   // [self setImageAndAllyName];
    [self drawTableListView];
    [self fillCompleteArray];
     [self addKeyBoardNotification];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [allyDetailTable reloadData];
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
        // [headerView setRightType:@""];
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
-(void)getMenuTouches
{
    
}

#pragma mark child
-(void)childNameLabel
{
    if(!label)
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
}

-(void)drawTableListView
{
    if(!allyDetailTable)
    {
//        if(!isPhone667)
//        {
            allyDetailTable = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
//        }
//        else{
//            allyDetailTable = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy)];
//        }
        allyDetailTable.backgroundColor=appBackgroundColor;
        allyDetailTable .delegate=self;
        allyDetailTable.dataSource=self;
        [allyDetailTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        allyDetailTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:allyDetailTable];
    }
}

-(void)fillCompleteArray
{
    completeActivityArray=[[NSMutableArray alloc] init];
    
    NSMutableDictionary *dictdata=[[NSMutableDictionary alloc]init];
    //==============================================================================
    
    NSLog(@"ally object data\n %@", self.detailAlly);
    dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setValue:@"Banner1" forKey:@"key"];
    [dictdata setValue:[self.activityDict objectForKey:@"activityName"] forKey:@"Desc"];
    [completeActivityArray addObject:dictdata];
    
    //==============================================================================

    dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setValue:@"Banner2" forKey:@"key"];
    [dictdata setValue:@"INFORM ALLY" forKey:@"Desc"];
    [completeActivityArray addObject:dictdata];

    //==============================================================================
    
    dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setValue:@"navigation" forKey:@"key"];
    [dictdata setValue:@"Select Ally" forKey:@"value"];
    if(!self.detailAlly.firstName)
    {
        [dictdata setValue:@"" forKey:@"Select Ally"];
    }
    else
    {
        [dictdata setValue:self.detailAlly.firstName forKey:@"Select Ally"];
       // Date=self.detailAlly.activityDate;
    }
    [completeActivityArray addObject:dictdata];
    
    
    //==============================================================================
    
    dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setValue:@"navigation" forKey:@"key"];
    [dictdata setValue:@"Set Date" forKey:@"value"];
    if(!self.detailAlly.activityDate)
    {
        [dictdata setValue:@"" forKey:@"Set Date"];
    }
    else
    {
        [dictdata setValue:self.detailAlly.activityDate forKey:@"Set Date"];
        Date=self.detailAlly.activityDate;
    }
    [completeActivityArray addObject:dictdata];
    //==============================================================================
    
    dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setValue:@"navigation" forKey:@"key"];
    [dictdata setValue:@"Set Time" forKey:@"value"];
    if(!self.detailAlly.activityTime)
    {
        [dictdata setValue:@"" forKey:@"Set Time"];
    }
    else
    {
        [dictdata setValue:self.detailAlly.activityTime forKey:@"Set Time"];
        time=self.detailAlly.activityTime;
    }
    [completeActivityArray addObject:dictdata];
    
    //==============================================================================
    
    dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setValue:@"banner" forKey:@"key"];
    [dictdata setValue:@"SELECT ONE" forKey:@"value"];
    [completeActivityArray addObject:dictdata];

    //==============================================================================
    
    dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setValue:@"switch" forKey:@"key"];
    [dictdata setValue:@"Pick" forKey:@"value"];
    [dictdata setValue:@"0" forKey:@"tagIndex"];
    if([self.detailAlly.pickUp isEqualToString:@"1"])
    {
        [dictdata setValue:@"1" forKey:@"Status"];
        isPickUp=@"1";
    }
    else
    {
        [dictdata setValue:@"0" forKey:@"Status"];
        isPickUp=@"0";
    }
    [completeActivityArray addObject:dictdata];
    //==============================================================================
    
    dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setValue:@"switch" forKey:@"key"];
    [dictdata setValue:@"Drop" forKey:@"value"];
    [dictdata setValue:@"1" forKey:@"tagIndex"];
    if([self.detailAlly.drop isEqualToString:@"1"])
    {
        [dictdata setValue:@"1" forKey:@"Status"];
        isDrop=@"1";
    }
    else
    {
        [dictdata setValue:@"0" forKey:@"Status"];
        isDrop=@"0";
    }
    [completeActivityArray addObject:dictdata];
    //==============================================================================
    
    dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setValue:@"banner" forKey:@"key"];
    [dictdata setValue:@"SPECIAL INSTRUCTIONS" forKey:@"value"];
    [completeActivityArray addObject:dictdata];
    
    //==============================================================================
    
    dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setValue:@"textbox" forKey:@"key"];
    [dictdata setValue:@"textbox" forKey:@"value"];
    if(self.detailAlly.remarks)
    {
        [dictdata setValue:self.detailAlly.remarks forKey:@"Remarks"];
    }
    else
    {
        [dictdata setValue:@"Type here..." forKey:@"Remarks"];
    }
    [completeActivityArray addObject:dictdata];
    
    
    //==============================================================================
    
//    dictdata = [[NSMutableDictionary alloc]init];
//    [dictdata setValue:@"Segment" forKey:@"key"];
//    [dictdata setValue:@"Segment" forKey:@"value"];
//    [completeActivityArray addObject:dictdata];
//    
//    dictdata = [[NSMutableDictionary alloc]init];
//    [dictdata setValue:@"Button" forKey:@"key"];
//    [dictdata setValue:@"Button" forKey:@"value"];
//    [completeActivityArray addObject:dictdata];
}


#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner"] || [[data valueForKey:@"key"] isEqualToString:@"Banner1"] || [[data valueForKey:@"key"] isEqualToString:@"Banner2"] )
    {
        return ScreenHeightFactor*30;
    }
    
    if([[data valueForKey:@"key"] isEqualToString:@"navigation"] )
    {
        return ScreenHeightFactor*42;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"switch"] )
    {
        return ScreenHeightFactor*42;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"textbox"] )
    {
        return ScreenHeightFactor*200;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"Button"]||[[data valueForKey:@"key"] isEqualToString:@"Segment"] )
    {
        return ScreenHeightFactor*50;
    }
    
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *DateAllyCellIdentifier     = @"DateAllyCell";
    static NSString *ToggleAllyCellIdentifier   = @"ToggleAllyCell";
    static NSString *Head2AllyCellIdentifier    = @"Head2AllyCell";
    static NSString *NoteAllyCellIdentifier     = @"NoteAllyCell";
    static NSString *ButtonAllyCellIdentifier   = @"ButtonAllyCell";
    static NSString *BannerCellIdentifier1      = @"BannerCell1";
    static NSString *BannerCellIdentifier2      = @"BannerCell2";
    
    TextAndDescTextCell *cell;// =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
   // cell.backgroundColor=appBackgroundColor;
    
    
    if([[data objectForKey:@"key"]isEqualToString:@"Banner1"])
    {
        TextAndDescTextCell *cell1 = [tableView dequeueReusableCellWithIdentifier:BannerCellIdentifier1
                                      ];
        if(!cell1)
        {
            cell1 = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BannerCellIdentifier1];
            
        }
        [cell1 addText:[data objectForKey:@"Desc"] andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:activityHeading1Code andType:@"Banner"];
        cell1.backgroundColor=activityHeading1Code;
        cell=cell1;
    }
    
    if([[data objectForKey:@"key"]isEqualToString:@"Banner2"])
    {
        TextAndDescTextCell *cell1 = [tableView dequeueReusableCellWithIdentifier:BannerCellIdentifier2
                                      ];
        if(!cell1)
        {
            cell1 = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BannerCellIdentifier2];
            
        }
        [cell1 addText:[data objectForKey:@"Desc"] andDesc:@"" withTextColor:activityHeading2FontCode andDecsColor:activityHeading2Code andType:@"Banner"];
        cell1.backgroundColor=activityHeading2Code;
        cell=cell1;
    }

    
    if([[data valueForKey:@"key"] isEqualToString:@"banner"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:Head2AllyCellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Head2AllyCellIdentifier];
        }
        if(cell.textLabel.text==0)
        {
            [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading2FontCode andDecsColor:cellTextColor andType:@"Banner"];
            [cell.textlabel1 sizeToFit];
            cell.backgroundColor=activityHeading2Code;
        }
    }
    
    
    
    else if([[data valueForKey:@"key"] isEqualToString:@"navigation"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:DateAllyCellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DateAllyCellIdentifier];
        }
        
        if(cell.textLabel.text==0)
        {
            [cell addText:[data objectForKey:@"value"] andDesc:[data objectForKey:[data objectForKey:@"value"]] withTextColor:cellBlackColor_7 andDecsColor:placeHolderReg andType:@""];
            cell.arrowImageView.alpha=1.0f;
            cell.descTextLabel.center=CGPointMake(cell.descTextLabel.center.x-cellPadding, cell.descTextLabel.center.y);
        }
        
    }
    
    else if([[data valueForKey:@"key"] isEqualToString:@"switch"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:ToggleAllyCellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ToggleAllyCellIdentifier];
        }
        if(cell.textLabel.text.length<=0)
        {
            [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:cellBlackColor_7 andDecsColor:cellTextColor andType:@""];
            cell.arrowImageView.image=[UIImage imageNamed:isiPhoneiPad(@"selectedWeekDay.png")];
            if([[data valueForKey:@"Status"] isEqualToString:@"0"])
            {
                cell.arrowImageView.alpha=0;
            }
            else{
                cell.arrowImageView.alpha=1;

            }
        }
    }
    else if([[data valueForKey:@"key"] isEqualToString:@"textbox"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:NoteAllyCellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NoteAllyCellIdentifier];
        }
        if(!notes && cell.textLabel.text.length==0)
        {
            notes = [[UITextView alloc] initWithFrame:CGRectMake(cellPadding, 10*ScreenHeightFactor, screenWidth-2*cellPadding, 100*ScreenHeightFactor)];
            [notes setDelegate:self];
            [notes setFont:[UIFont fontWithName:RobotoRegular size:10*ScreenFactor]];
            [notes setScrollEnabled:YES];
            [notes setUserInteractionEnabled:YES];
            notes.editable=YES;
            [notes setBackgroundColor:[UIColor clearColor]];
            placeholderText = [data objectForKey:@"Remarks"];
            notes.textColor=placeHolderReg;
            [notes setText:placeholderText];
            CGRect frame = notes.frame;
            frame.size.height = notes.contentSize.height;
            notes.frame = frame;
            [cell.contentView addSubview:notes];
            cell.backgroundColor=appBackgroundColor;
        }
        if(!smsEmailCtrl)
        {
            NSArray *itemArray = [NSArray arrayWithObjects: @"SMS", @"Email", nil];
            smsEmailCtrl = [[UISegmentedControl alloc] initWithItems:itemArray];//create an intialize our segmented control
            smsEmailCtrl.frame = CGRectMake(cellPadding, 100*ScreenHeightFactor, screenWidth-2*cellPadding, 40*ScreenHeightFactor);//set the size and placement
            smsEmailCtrl.center = CGPointMake(screenWidth/2, smsEmailCtrl.center.y);
            smsEmailCtrl.selectedSegmentIndex = 1;
            [smsEmailCtrl setEnabled:NO forSegmentAtIndex:0];
            smsEmailCtrl.backgroundColor=[UIColor clearColor];
            smsEmailCtrl.tintColor = radiobuttonSelectionColor;
            smsEmailCtrl.segmentedControlStyle = UISegmentedControlSegmentLeft;
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:RobotoRegular size:10*ScreenFactor], NSFontAttributeName,
                                        placeHolderReg, NSForegroundColorAttributeName, nil];
            
            [smsEmailCtrl setTitleTextAttributes:attributes forState:UIControlStateNormal];
            
            
            NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:RobotoRegular size:10*ScreenFactor], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName, nil];
            
            [smsEmailCtrl setTitleTextAttributes:attributes1 forState:UIControlStateSelected];
            
            
            [smsEmailCtrl addTarget:self
                             action:@selector(whichWayToSend:)
                   forControlEvents:UIControlEventValueChanged];
            
            [cell.contentView addSubview:smsEmailCtrl];
        }
        [self addGotoMerchant:cell];
        
    }
    else if([[data valueForKey:@"key"] isEqualToString:@"Segment"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:ButtonAllyCellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ButtonAllyCellIdentifier];
        }
        if(!smsEmailCtrl)
        {
            NSArray *itemArray = [NSArray arrayWithObjects: @"SMS", @"Email", nil];
            smsEmailCtrl = [[UISegmentedControl alloc] initWithItems:itemArray];//create an intialize our segmented control
            smsEmailCtrl.frame = CGRectMake(cellPadding, 5*ScreenHeightFactor, screenWidth-2*cellPadding, 40*ScreenHeightFactor);//set the size and placement
            smsEmailCtrl.center = CGPointMake(screenWidth/2, smsEmailCtrl.center.y);
            smsEmailCtrl.selectedSegmentIndex = 1;
            [smsEmailCtrl setEnabled:NO forSegmentAtIndex:0];
            smsEmailCtrl.backgroundColor=[UIColor clearColor];
            smsEmailCtrl.tintColor = radiobuttonSelectionColor;
            smsEmailCtrl.segmentedControlStyle = UISegmentedControlSegmentLeft;
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:RobotoRegular size:10*ScreenFactor], NSFontAttributeName,
                                        placeHolderReg, NSForegroundColorAttributeName, nil];
            
            [smsEmailCtrl setTitleTextAttributes:attributes forState:UIControlStateNormal];
            
            
            NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:RobotoRegular size:10*ScreenFactor], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName, nil];
            
            [smsEmailCtrl setTitleTextAttributes:attributes1 forState:UIControlStateSelected];
            
            
            [smsEmailCtrl addTarget:self
                             action:@selector(whichWayToSend:)
                   forControlEvents:UIControlEventValueChanged];
            
            [cell.contentView addSubview:smsEmailCtrl];
        }
        cell.backgroundColor=appBackgroundColor;
    }
    else if([[data valueForKey:@"key"] isEqualToString:@"Button"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:ButtonAllyCellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ButtonAllyCellIdentifier];
        }
        /* if(!sms)
         {
         sms=[UIButton buttonWithType:UIButtonTypeSystem];
         [sms setTitle:@"SMS" forState:UIControlStateNormal];
         sms.tintColor=radiobuttonSelectionColor;
         sms.backgroundColor=[UIColor clearColor];
         [sms setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
         sms.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.018*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
         sms.frame=CGRectMake(20,110,135,30);
         sms.layer.borderWidth=1.0;
         sms.layer.borderColor=radiobuttonSelectionColor.CGColor;
         //[sms addTarget:self action:@selector(smsBtnTouched) forControlEvents:UIControlEventTouchUpInside];
         [cell.contentView addSubview:sms];
         }
         
         if(!email)
         {
         email=[UIButton buttonWithType:UIButtonTypeSystem];
         [email setTitle:@"E-MAIL" forState:UIControlStateNormal];
         email.tintColor=radiobuttonSelectionColor;
         email.backgroundColor=[UIColor clearColor];
         [email setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
         email.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.018*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
         email.frame=CGRectMake(165,110,135,30);
         email.layer.borderWidth=1.0;
         email.layer.borderColor=radiobuttonSelectionColor.CGColor;
         // [email addTarget:self action:@selector(emailBtnTouched) forControlEvents:UIControlEventTouchUpInside];
         [cell.contentView addSubview:email];
         }*/
        cell.backgroundColor=appBackgroundColor;
        [self addGotoMerchant:cell];
        
        
        cell.textLabel.textColor=radiobuttonSelectionColor;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    rowNumber= indexPath.row;
    NSMutableDictionary *dict=[completeActivityArray objectAtIndex:rowNumber];
    if(pickerView!=nil)
    {
        [pickerView removeFromSuperview];
    }
    if([tableCell.textlabel1.text isEqualToString: @"Select Ally"])
    {
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
        }
        InformToAllyViewController *inform=[[InformToAllyViewController alloc]init];
        inform.informAllyDelegate=self;
        inform.child=self.child;
        inform.activityDict=self.activityDict;
        inform.informAllyDict=[[AllyProfileObject alloc]init];
        //inform.informAllyDict.activity_ID=[NSString stringWithFormat:@"%i",self.subjectID];
        inform.informAllyDict.child_ID=self.child.child_ID;
        //        inform.parentClass=ParentIsAfetrSchoolPlan;
        [self.navigationController pushViewController:inform animated:YES];
    }

    if([tableCell.textlabel1.text isEqualToString: @"Set Date"])
    {
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
        }
        
        NSLog(@"in selection %@",tableCell.class);
        [self drawDatePicker];
        picker.minimumDate=[NSDate date];
        picker.datePickerMode=UIDatePickerModeDate;
    }
    
    else if([tableCell.textlabel1.text isEqualToString: @"Set Time"] )
    {
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
            pickerView=nil;
        }
        NSLog(@"in selection %@",tableCell.class);
        [self drawDatePicker];
        picker.minimumDate=nil;
        picker.datePickerMode=UIDatePickerModeTime;
    }
    
    else if([tableCell.textlabel1.text isEqualToString: @"Pick"] )
    {
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
            pickerView=nil;
        }
        if([[dict objectForKey:@"Status"]isEqualToString:@"0"])
        {
            NSMutableDictionary *dict1=[completeActivityArray objectAtIndex:rowNumber+1];
            [dict1 setObject:@"0" forKey:@"Status"];
            [dict setObject:@"1" forKey:@"Status"];
            isDrop=@"0";
            isPickUp=@"1";
        }
    }
    
    else if([tableCell.textlabel1.text isEqualToString: @"Drop"] )
    {
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
            pickerView=nil;
        }
        if([[dict objectForKey:@"Status"]isEqualToString:@"0"])
        {
            NSMutableDictionary *dict1=[completeActivityArray objectAtIndex:rowNumber-1];
            [dict1 setObject:@"0" forKey:@"Status"];
            [dict setObject:@"1" forKey:@"Status"];
            isDrop=@"1";
            isPickUp=@"0";
        }
    }
    [allyDetailTable reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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


-(void)addGotoMerchant:(UITableViewCell*)cell
{
    if(!customButton)
    {
        customButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [customButton setTitle:@"Save & Notify" forState:UIControlStateNormal];
        customButton.tintColor=activityHeading1FontCode;
        customButton.backgroundColor=buttonGreenColor;
        [customButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        customButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:12*ScreenFactor];
        [customButton sizeToFit];
        // customButton.frame=CGRectMake(.2*screenWidth, .8*screenHeight, .73*screenWidth, .07*screenHeight);
        //    customButton.layer.borderWidth=1.0;
        //    customButton.layer.borderColor=radiobuttonSelectionColor.CGColor;
        [customButton addTarget:self action:@selector(customBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        customButton.frame=CGRectMake(cellPadding, 150*ScreenHeightFactor, screenWidth-2*cellPadding, 40*ScreenHeightFactor);
        //customButton.backgroundColor=buttonGreenColor;
        customButton.center=CGPointMake(screenWidth/2, customButton.center.y);
        [cell.contentView addSubview:customButton];
    }
}

-(void)whichWayToSend:(UISegmentedControl *)paramSender{
    if ([paramSender isEqual:smsEmailCtrl]){
        
        //get index position for the selected control
        NSInteger selectedIndex = [paramSender selectedSegmentIndex];
        
        //get the Text for the segmented control that was selected
        NSString *myChoice =
        [paramSender titleForSegmentAtIndex:selectedIndex];
    }
}

-(void)customBtnTouched
{
    NSLog(@"self.child.child_ID== %@",self.child.child_ID);
    NSLog(@"self.detailAlly.ally_ID == %@",self.detailAlly.ally_ID);
    NSLog(@"date == %@",Date);
    NSLog(@"time == %@",time);
    NSLog(@"pickup == %@", isPickUp);
    NSLog(@"isDrop == %@", isDrop);
    NSLog(@"notes.text == %@", notes.text);
    NSLog(@"email == %@", @"email");
    
    
    if(!Date || !time || !isPickUp ||!isDrop  || time.length==0|| isPickUp.length==0 || Date.length==0 )
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Incomplete Data" message:@"Oops! You left a few important fields blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(notes.text.length==0 || !notes)
    {
        notes.text=@"Type here...";
    }
    

    self.detailAlly.drop=isDrop;
    self.detailAlly.pickUp=isPickUp;
    self.detailAlly.activityTime=time;
    self.detailAlly.activityDate=Date;
    self.detailAlly.remarks=notes.text;
    self.detailAlly.notifyMode=@"email";
    
    NSLog(@"detal ally object: %@\n%@\n%@\n%@\n%@\n%@",self.detailAlly.drop,
          self.detailAlly.pickUp,
          self.detailAlly.activityTime,
          self.detailAlly.activityDate,
          self.detailAlly.remarks,
          self.detailAlly.notifyMode);
    
    AddAllyInformationOnActivity *addAllyInfo=[[AddAllyInformationOnActivity alloc]init];
    [addAllyInfo initService:@{
                               @"ChildID"            :self.child.child_ID,
                               @"ActivityID"         :[self.activityDict objectForKey:@"activityID"],
                               @"AllyID"             :self.detailAlly.ally_ID,
                               @"Date"               :self.detailAlly.activityDate,
                               @"Time"               :self.detailAlly.activityTime,
                               @"PickUp"             :self.detailAlly.pickUp,
                               @"Drop"               :self.detailAlly.drop,
                               @"SpeicalInstructions":self.detailAlly.remarks,
                               @"NotificationMode"   :self.detailAlly.notifyMode,//alyObj.notifyMode
                               @"AllyIndex"          :@"0"
                               }];
    [addAllyInfo setDelegate:self];
    addAllyInfo.serviceName=PinWiAddAllyInformationOnActivity;
    [self addLoaderView];

    
    
    
//    if(self.informAllyDetailDelegate)
//    {
//        [self.informAllyDetailDelegate sendAllyObject:self.detailAlly];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//    if([self.parentClass isEqualToString:ParentIsAfetrSchoolPlan])
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//        //[self.informAllyDetailDelegate sendAllyName:self.detailAlly.firstName andId:self.detailAlly.ally_ID andAllyObj:self.detailAlly];
//    }
//    else
//    {
//        NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
//        UIViewController *parentViewController;
//        parentViewController  = self.navigationController.viewControllers[numberOfViewControllersOnStack - 3];
//        Class parentVCClass = [parentViewController class];
//        NSString *className = NSStringFromClass(parentVCClass);
//        
//        [self.navigationController popToViewController:parentViewController animated:YES];
//    }
//    [self.informAllyDetailDelegate sendAllyName:self.detailAlly.firstName andId:self.detailAlly.ally_ID andAllyObj:self.detailAlly];
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:PinWiAddAllyInformationOnActivity])
    {
        NSString *str=[NSString stringWithFormat:@"%@-%@-%@",PinWiGetListOfScheduledAllys,self.child.child_ID,[self.activityDict objectForKey:@"activityID"]];
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:str];
        [self.navigationController popViewControllerAnimated:YES];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(-150*ScreenHeightFactor-yy, allyDetailTable.frame.origin.x, kbSize.height, 0);
    allyDetailTable.contentInset = contentInsets;
    allyDetailTable.scrollIndicatorInsets = contentInsets;
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
    allyDetailTable.contentInset = contentInsets;
    allyDetailTable.scrollIndicatorInsets = contentInsets;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    else if(text.length >150)
    {
        [textView resignFirstResponder];
    }
    else{
        
    }
    
    return YES;
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
    // doneButton.frame=CGRectMake(0,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    doneButton.frame=CGRectMake(pickerView.frame.size.width-cancelButton.frame.size.width,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    
    [doneButton addTarget:self action:@selector(ClickOnDone:) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:doneButton];
    
    picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(pickerView.frame.origin.x, pickerView.frame.size.height*.12, pickerView.frame.size.width, pickerView.frame.size.height);
    [pickerView addSubview:picker];
    // .inputView=picker;
}



-(void)ClickOnDone:(id)sender
{
    NSMutableDictionary *changeVal=[completeActivityArray objectAtIndex:rowNumber];
    NSDate *date = picker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    if([tableCell.textlabel1.text isEqualToString:@"Set Date"])
    {
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSString *dateString = [dateFormat stringFromDate:date];
        tableCell.descTextLabel.text =dateString;
        [pickerView removeFromSuperview];
        Date=dateString;
    }
    else if([tableCell.textlabel1.text isEqualToString:@"Set Time"])
    {
        [dateFormat setDateFormat:@"hh:mm a"];
        [dateFormat setAMSymbol:@"AM "];
        [dateFormat setPMSymbol:@"PM "];
        NSString *dateString = [dateFormat stringFromDate:date];
        tableCell.descTextLabel.text =dateString;
        [pickerView removeFromSuperview];
        time=dateString;
        
    }
    
    [changeVal setObject:tableCell.descTextLabel.text forKey:tableCell.textlabel1.text];
    [allyDetailTable reloadData];
}

-(void)ClickOnCancel
{
    
    [pickerView removeFromSuperview];
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" detail button tap");
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

#pragma mark delegates
-(void)sendAllyName:(NSString *)allyName andId:(NSString *)allyId andAllyObj:(NSMutableDictionary *)allyObj
{
    self.detailAlly=[[AllyProfileObject alloc]init];
    
    self.detailAlly.firstName=[allyObj objectForKey:@"AllyName"];
    self.detailAlly.ally_ID=[allyObj objectForKey: @"AllyProfileID"];
    self.detailAlly.relationship=[allyObj objectForKey:@"Relationship"];
    self.detailAlly.profilePic=[allyObj objectForKey:@"AllyProfileImage"];
    
    tableCell.descTextLabel.text=[allyObj objectForKey:@"AllyName"];
    
    NSMutableDictionary *dict=[completeActivityArray objectAtIndex:2];
    [dict setObject:tableCell.descTextLabel.text forKey:@"Select Ally"];
    
    [allyDetailTable reloadData];
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
