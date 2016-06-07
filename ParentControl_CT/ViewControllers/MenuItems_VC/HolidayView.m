//
//  HolidayView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 09/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "HolidayView.h"
#import "ShowActivityLoadingView.h"
#import "ListOfHolidayCell.h"
#import "PC_DataManager.h"
#import "GetListofHolidaysByChildIDService.h"
#import "HolidayFooterView.h"
#import "GetHolidayDetailsByHolidayDescController.h"


@interface HolidayView ()<UITableViewDataSource, UITableViewDelegate, UrlConnectionDelegate, FooterViewDelegate>
@property (nonatomic, strong) UITableView *tableLayout;
@property (nonatomic, strong) NSMutableArray *dataStorage;
@end


@implementation HolidayView {
    int cellHeight;
    ShowActivityLoadingView *loaderView;
    HolidayFooterView *footerView;
}
@synthesize  tableLayout;
@synthesize  dataStorage;
@synthesize  childProfileObject;

-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        return self;
    }
    return nil;
}


#pragma mark DrawUI specific Functions
-(void)drawUI:(CGFloat) originy {

    cellHeight  = 40 *ScreenHeightFactor;
    tableLayout =[[UITableView alloc]initWithFrame:CGRectMake(0,originy , self.frame.size.width,self.frame.size.height-originy)];
    tableLayout.backgroundColor=appBackgroundColor;
    tableLayout .delegate=self;
    tableLayout.dataSource=self;
    [tableLayout setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:tableLayout];
    tableLayout.backgroundColor=[UIColor whiteColor];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    gestureRecognizer.view.tag = 1;
    gestureRecognizer.cancelsTouchesInView = NO;
    [tableLayout addGestureRecognizer:gestureRecognizer];
    
    [self listOfChildHoliday:childProfileObject.child_ID];
    
}

-(void)addLoaderView {
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:self.frame];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self addSubview:loaderView];

}

-(void)removeLoaderView {
    [loaderView removeFromSuperview];
    loaderView = nil;
}
#pragma mark TableViewSpecific Functions
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataStorage.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(!footerView) {
        footerView = [[HolidayFooterView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,40)];
        footerView.delegate = self;
        footerView.childId = childProfileObject.child_ID;
        [footerView drawUI];
    }
    
    return footerView;
    
}
-(void)backgroundTap:(id)sender {
    [self endEditing:YES];
}


-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"HolidayCell";
    ListOfHolidayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[ListOfHolidayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell  initialization:CGSizeMake(self.frame.size.width, cellHeight)];
        
    }
    [cell updateUI:[dataStorage objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(goTOController:description:)]) {
        [self.delegate goTOController:NO description:[dataStorage objectAtIndex:indexPath.row]];
    }
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
    if ([tableLayout respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableLayout setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableLayout respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableLayout setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark Connection Specific Functions 
-(void)listOfChildHoliday:(NSString *)childId {
    GetListofHolidaysByChildIDService *getListOfholidayByChildId = [[GetListofHolidaysByChildIDService alloc]init];
    [getListOfholidayByChildId setDelegate:self];
    [getListOfholidayByChildId setServiceName:PinWiGetListofHolidaysByChildID];
    [getListOfholidayByChildId initService:@{@"ChildID":childId}];
    [self addLoaderView];
}


#pragma mark Connection Specific Functions
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    if ([connection.serviceName isEqualToString:PinWiGetListofHolidaysByChildID]){
        [self removeLoaderView];
    }
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
  if ([connection.serviceName isEqualToString:PinWiGetListofHolidaysByChildID]){
        NSDictionary *resultDict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetListofHolidaysByChildIDResponse resultKey:PinWiGetListofHolidaysByChildIDResult];
        
        if(!resultDict){
            return;
        }
        
        if([resultDict isKindOfClass:[NSArray class]]) {
            [dataStorage removeAllObjects];
            NSArray *arr = (NSArray *)resultDict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"]) {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//                [alert show];
            }
            else {
                
                if (!dataStorage) {
                    dataStorage = [[NSMutableArray alloc] init];
                }
                
                for(NSDictionary *dictionary in arr) {
                    [dataStorage addObject:[dictionary valueForKey:@"HolidayDescription"]];
                }
                
            }
            [self removeLoaderView];
            [tableLayout reloadData];
        }
    }
    
    
}

-(void)viewWillAppear {
    [self listOfChildHoliday:childProfileObject.child_ID];
}

-(void)touchAtFooterView:(NSString *)childId {
    NSLog(@"childId= %@",childId);
    if(self.delegate && [self.delegate respondsToSelector:@selector(goTOController:description:)]) {
        [self.delegate goTOController:YES description:nil];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
