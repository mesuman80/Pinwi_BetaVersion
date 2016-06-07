//
//  GetHolidayDetailsByHolidayDescViewController.m
//  ParentControl_CT
//
//  Created by Yogesh on 09/01/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "GetHolidayDetailsByHolidayDescController.h"
#import "Constant.h"
#import "AddHolidaysByChildIDService.h"
#import "DeleteHolidayByHolidayDescService.h"
#import "GetHolidayDetailsByHolidayDescService.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"
#import "MenuSettingsView.h"
#import "RedLabelView.h"
#import "HolidayCell.h"
#import "GetExhilaratorsListByChildID.h"

@interface GetHolidayDetailsByHolidayDescController ()<HeaderViewProtocol, UrlConnectionDelegate, UITableViewDataSource , UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@end

@implementation GetHolidayDetailsByHolidayDescController {
    ShowActivityLoadingView *loaderView              ;
    HeaderView              *headerView              ;
    AddHolidaysByChildIDService *addHolidayByChildId ;
    RedLabelView            *label                   ;
    NSMutableArray          *dataStorage             ;
  
    int yy                                           ;
    NSInteger cellheight                             ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:appBackgroundColor];
    [[self navigationController] setNavigationBarHidden:YES];
    [self drawHeaderView];
    [self drawChildLabel];
    [self tableViewLayout];
    [self drawDeleteLabel];
     dataStorage  = [[NSMutableArray alloc]initWithCapacity:3];
    if(_isTouchEnable) {
        
        [dataStorage addObject:@{
                                 @"Title"    : @"Holiday Name" ,
                                 @"SubTitle" : @"" ,
                                 @"Type"     : [NSNumber numberWithInt:CellTypeText]
                                 }
         ];
        
        [dataStorage addObject:@{
                                 @"Title"    : @"Start Date" ,
                                 @"SubTitle" : @"" ,
                                 @"Type"     : [NSNumber numberWithInt:CellTypeDate]
                                 }
         ];
        
        
        [dataStorage addObject:@{
                                 @"Title"    : @"End Date" ,
                                 @"SubTitle" : @"" ,
                                 @"Type"     : [NSNumber numberWithInt:CellTypeDate]
                                 
                                 }
         ];
 
    }
    else {
        GetHolidayDetailsByHolidayDescService *holidayDetails = [[GetHolidayDetailsByHolidayDescService alloc] init];
        [holidayDetails setServiceName:PinWiGetHolidayDetailsByHolidayDesc];
        [holidayDetails setDelegate:self];
        [holidayDetails initService:@{
                                         @"ChildID"             : _childId,
                                         @"HolidayDescription"  : _holidayDescription
                                     }];
        [self addLoaderView];
    }
   
}

-(void)addHolidays:(id)sender {
    
}

-(void)drawDeleteLabel {
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height*.80f, screenWidth-25*ScreenWidthFactor,40*ScreenHeightFactor)];
    [view setCenter:CGPointMake(self.view.frame.size.width/2.0f, view.center.y)];
    [self.view addSubview:view];
    
    UIButton *button  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,50*ScreenWidthFactor,30*ScreenWidthFactor)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:@"Delete" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:RobotoRegular size:12*ScreenFactor]];
    [button setCenter:CGPointMake(view.frame.size.width/2.0f, view.frame.size.height/2.0f)];
    if(_isTouchEnable) {
        [button setTintColor:[UIColor grayColor]];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setAlpha:0.6f];
        [button setEnabled:NO];
        [self addBorderToUiView:view withBorderWidth:1.0f cornerRadius:0.0f Color:[UIColor grayColor]];
    }
    else {
        [button setTintColor:[UIColor redColor]];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteHolidays:) forControlEvents:UIControlEventTouchUpInside];
        [self addBorderToUiView:view withBorderWidth:1.0f cornerRadius:0.0f Color:[UIColor redColor]];
    }
    [view addSubview:button];

}
-(void)deleteHolidays:(id)sender {
    [self deleteHolidays];
}
-(void)addBorderToUiView:(UIView *)view withBorderWidth:(float)borderWidth cornerRadius:(float)cornerRadius Color:(UIColor *)color {
    [view.layer setBorderColor:color.CGColor];//[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [view.layer setBorderWidth:borderWidth];
    view.layer.cornerRadius = cornerRadius;
    view.clipsToBounds = YES;
}
-(void)tableViewLayout {

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, cellheight)];
    [view setBackgroundColor:activityHeading1Code];
    [self.view addSubview:view];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [headerLabel setText:@"Add New Holiday"];
    [headerLabel setTextColor:activityHeading1FontCode];
    UIFont *font  = (self.view.frame.size.width>700) ?
    [UIFont fontWithName:RobotoRegular size:9*ScreenFactor]
    :[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
    [headerLabel setFont:font];
    [headerLabel setBackgroundColor:activityHeading1Code];
    [headerLabel setFrame:CGRectMake(10*ScreenWidthFactor,0, screenWidth, cellheight)];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
    [view addSubview:headerLabel];
    yy+=view.frame.size.height;
    
    _table =[[UITableView alloc]initWithFrame:CGRectMake(0, yy, screenWidth,self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
    
    _table.backgroundColor=appBackgroundColor;
    _table .delegate=self;
    _table.dataSource=self;
    [_table setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_table];
    
    [_table setKeyboardDismissMode :UIScrollViewKeyboardDismissModeInteractive];
    
   UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    gestureRecognizer.view.tag = 1;
    gestureRecognizer.cancelsTouchesInView = NO;
    [_table addGestureRecognizer:gestureRecognizer];
    
}
-(void)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

-(void) drawHeaderView {
    if(!headerView) {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:@"Done"];
        [headerView setRightButtonDisable:!_isTouchEnable];
        [headerView setCentreImgName:@"activityHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Holidays" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view addSubview:headerView];
        if(screenWidth>700) {    yy+=headerView.frame.size.height+25*ScreenHeightFactor;
        }
        else {
            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }
    }
    cellheight  = 40 *ScreenHeightFactor ;
}

-(void)drawChildLabel {
    if(!label){
        if(screenWidth>700) {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0,yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:_nickName];
            label.center=CGPointMake(screenWidth/2,label.center.y);
        }
        else {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0,yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:_nickName];
            label.center=CGPointMake(screenWidth/2,label.center.y);
        }
        [self.view addSubview:label];
        
        yy += label.frame.size.height+ScreenHeightFactor*10;
    }
    
}

-(void)getMenuTouches {
     NSArray *cellStorage  = [_table visibleCells];
   __block NSDate *startDate = nil;
    __block NSDate *endDate   = nil;
    __block NSString *holidayDescription = nil;
    __block NSString *endDateStr   = nil;
     __block NSString *startDateStr = nil;
    [cellStorage enumerateObjectsUsingBlock:^(HolidayCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        if([cell subTitleText] == nil || [[cell subTitleText ] isEqualToString:@""]) {
            [self showAlertViewWithMessage:@"Please enter valid information." title:@"Alert"];
            *stop = YES;
        }
        else {
            if(idx ==0) {
                holidayDescription = [cell text];
            }
            else if(idx == 1) {
                startDate =    [cell date];
                startDateStr = [cell text];
            }
            else if(idx == 2){
                endDate    =  [cell date];
                endDateStr = [cell text];
            }
        }
    }];
    
    if(startDate  && endDate) {
        if([endDate compare:startDate] == NSOrderedDescending  || [endDate compare:startDate] == NSOrderedSame) {
            
            addHolidayByChildId  = [[AddHolidaysByChildIDService alloc]init];
            [addHolidayByChildId setDelegate:self];
            [addHolidayByChildId setServiceName:PinWiAddHolidayByChildId];
            NSDictionary *dictionary = @{ @"ChildID"              : _childId ,
                                          @"HolidayDescription"   : holidayDescription      ,
                                          @"StartDate"            : startDateStr      ,
                                          @"EndDate"              : endDateStr
                                          };
            [addHolidayByChildId initService:dictionary];
            [self addLoaderView];
        }
        else {
            [self showAlertViewWithMessage:@"End date must be greater than StartDate. Please enter valid information." title:@"Alert"];
        }
    }
   
    
}
-(void)showAlertViewWithMessage:(NSString *)message title:(NSString *)title {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil
                                             cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)touchAtBackButton {
    [self goBack];
}

-(void)deleteHolidays {
    DeleteHolidayByHolidayDescService *deleteHoliday = [[DeleteHolidayByHolidayDescService alloc] init];
    [deleteHoliday setServiceName:PinWiDeleteHolidayByHolidayDesc];
    [deleteHoliday setDelegate:self];
    [deleteHoliday initService:@{
                                   @"ChildID"             : _childId,
                                   @"HolidayDescription"  : _holidayDescription
                                 }];
      [self addLoaderView];
}


-(void)goBack {
    if(addHolidayByChildId){
        [addHolidayByChildId stopConnection];
        addHolidayByChildId = nil;
    }
    [self removeLoaderView];
    [[self navigationController] popViewControllerAnimated:YES];
}


-(void)addHolidayByChildId {
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection {
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
     [self removeLoaderView];
    NSDictionary *resultDict  = nil;
    if([connection.serviceName isEqualToString:PinWiAddHolidaysByChildID]) {
        
       resultDict = [connection getJsonWithXmlDictionary  : dictionary
                                                            ResponseKey  : PinWiAddHolidayByChildIdResponse resultKey: PinWiAddHolidayByChildIdResult];
        
    }
    else if ([connection.serviceName isEqualToString:PinWiDeleteHolidayByHolidayDesc]) {
         resultDict = [connection getJsonWithXmlDictionary  : dictionary
                                               ResponseKey  : PinWiDeleteHolidayByHolidayDescResponse
                                                   resultKey: PinWiDeleteHolidayByHolidayDescResult];
        
       
        if(!resultDict) {
            [_table reloadData];
            [self goBack];
        }
    }
    else if ([connection.serviceName isEqualToString:PinWiGetHolidayDetailsByHolidayDesc]) {
        resultDict = [connection getJsonWithXmlDictionary  : dictionary
                                              ResponseKey  : PinWiGetHolidayDetailsByHolidayDescResponse
                                                  resultKey: PinWiGetHolidayDetailsByHolidayDescResult];
        
        [dataStorage removeAllObjects];
        [_table reloadData];
        
    }
    
    if(!resultDict){
        return;
    }
    
    if(resultDict && [resultDict isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)resultDict;
        NSDictionary *dictionary = [arr firstObject];
        if([dictionary valueForKey:@"ErrorDesc"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else  if([connection.serviceName isEqualToString:PinWiGetHolidayDetailsByHolidayDesc]){
           
            [arr enumerateObjectsUsingBlock:^(NSDictionary *dict,NSUInteger idx, BOOL * _Nonnull stop) {
                [dataStorage addObject:@{
                                           @"Title"              : @"Holiday Name" ,
                                           @"SubTitle"           : [dict valueForKey:@"HolidayDescription"],
                                           @"Type"               : [NSNumber numberWithInt:CellTypeText]
                                         }
                 ];
              //
               [dataStorage addObject:@{
                                        @"Title"    : @"Start Date" ,
                                        @"SubTitle" : [[PC_DataManager sharedManager]getDateStringFromString:
                                                       [dict valueForKey:@"StartDate"] format:@"dd/MM/yyyy"],
                                        @"Type"     : [NSNumber numberWithInt:CellTypeDate]
                                        }
                ];
               
               
               [dataStorage addObject:@{
                                        @"Title"    : @"End Date" ,
                                        @"SubTitle" : [[PC_DataManager sharedManager]getDateStringFromString:
                                                       [dict valueForKey:@"EndDate"] format:@"dd/MM/yyyy"],
                                        @"Type"     : [NSNumber numberWithInt:CellTypeDate]
                                        
                                        }
                ];

            }];
             [_table reloadData];
            
        }
    }
    if(![connection.serviceName isEqualToString:PinWiGetHolidayDetailsByHolidayDesc]) [self goBack];
    
}

-(void)addLoaderView {
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
}

-(void)removeLoaderView {
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Specific Functions
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataStorage.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"HolidayCell";
    HolidayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[HolidayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell  cellSize:CGSizeMake(self.view.frame.size.width, cellheight)];
        [cell  cellInitialization:_isTouchEnable];
    }
    [cell cellType:(CellType) [[[dataStorage objectAtIndex:indexPath.row] valueForKey:@"Type"] integerValue]];
    [cell cellLayout:[dataStorage objectAtIndex:indexPath.row] isTouchEnable:_isTouchEnable];
    if(_isTouchEnable) [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellheight;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isTouchEnable) {
        __weak HolidayCell *holidayCell = [tableView cellForRowAtIndexPath:indexPath];
        [holidayCell editable];
    }
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.table setLayoutMargins:UIEdgeInsetsZero];
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
