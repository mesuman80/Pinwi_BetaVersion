//
//  ListOfChildHolidayController.m
//  ParentControl_CT
//
//  Created by Yogesh on 09/01/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "ListOfChildHolidayController.h"
#import "GetListofHolidaysByChildIDService.h"
#import "GetHolidayDetailsByHolidayDescController.h"
#import "Constant.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"
#import "MenuSettingsView.h"
#import "RedLabelView.h"
#import "ListOfHolidayCell.h"
#import "StripView.h"
#import "ChildProfileObject.h"

@interface ListOfChildHolidayController () <UrlConnectionDelegate,HeaderViewProtocol,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;

@end

@implementation ListOfChildHolidayController {
        ShowActivityLoadingView *loaderView     ;
        GetListofHolidaysByChildIDService *getListOfholidayByChildId ;
        HeaderView              *headerView     ;
        UIView                  *loadElementView;
        UIView                  *removeMenuView ;
        MenuSettingsView        *menu           ;
        RedLabelView            *label          ;
        NSMutableArray          *tableDataStorage ;
        UIButton                *addBtn         ;
        NSInteger               cellHeight      ;
        BOOL isToggleMenu                       ;
        int yy                                  ;
        UIScrollView            *scrollView;
        BOOL pageControlBeingUsed;
        UIPageControl *pageControl;
        int pageControlHeight;
        int scrollXX;
        int reduceYY;
        int initialY;

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:appBackgroundColor];
    tableDataStorage = [[NSMutableArray alloc]init];
    [self drawHeaderView];
    [self addButton];
  //  [self drawChildLabel];
    [self drawTableLayout];
}

-(void)drawTableLayout {
    cellHeight  = 40 *ScreenHeightFactor ;
    _table =[[UITableView alloc]initWithFrame:CGRectMake(0, yy+50, screenWidth,self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
    
    _table.backgroundColor=appBackgroundColor;
    _table .delegate=self;
    _table.dataSource=self;
    [_table setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [loadElementView addSubview:_table];

}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden=YES;
     [self listOfChildByChildId:_childId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) drawHeaderView {
    if(!loadElementView) {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width*1.5, self.view.frame.size.height)];
        [self.view addSubview:loadElementView];
    }
    if(!headerView) {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:@"Menu"];
        [headerView setCentreImgName:@"activityHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Scheduler" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [loadElementView addSubview:headerView];
         [self setupPageControl:[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count];
        
        if(screenWidth>700) {
            yy+=headerView.frame.size.height+25*ScreenHeightFactor;
        }
        else {
            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }
        
    }
    StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0,yy+40, self.view.frame.size.width,27*ScreenHeightFactor)];
    [stripView drawStrip:@"Holidays List" color:[UIColor clearColor]];
    [loadElementView addSubview:stripView];
}

-(void)drawUI
{
//    if(!scrollView)
//    {
//        NSMutableArray *array =[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles;
//        scrollXX = 0;
//        int i = 0 ;
//        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,initialY, self.view.frame.size.width,self.view.frame.size.height-reduceYY/2-self.navigationController.navigationBar.frame.size.height/2)];
//        [scrollView setBackgroundColor:appBackgroundColor];
//        scrollView.pagingEnabled = YES;
//        [scrollView setDelegate:self];
//        [scrollView setUserInteractionEnabled:YES];
//        [self.view addSubview:scrollView];
//        scrollXX = 0;
//        NSInteger count  = array.count;
//        int scrollYY = 0;
//        int centerCount  = 1;
//        holidayViewArray = [[NSMutableArray alloc]init];
//        HolidayView *holidayView;
//        
//        while (i<count) {
//            
//            holidayView = [[HolidayView alloc]initWithFrame:CGRectMake(scrollXX, 0,scrollView.frame.size.width, scrollView.frame.size.height)];
//            ChildProfileObject *childProfileObject =  [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:i];
//            RedLabelView *view = nil;
//            if(![childProfileObject.lastName isEqualToString:@"(null)"])
//            {
//                view = [self drawChildName:[NSString stringWithFormat:@"%@",childProfileObject.nick_Name] withFrame:CGRectMake(0,0,0, 0) withInteger:centerCount];
//                
//                scrollYY =view.frame.origin.y + view.frame.size.height+7*ScreenHeightFactor;
//                [holidayView addSubview:view];
//            }
//            else
//            {
//                view =
//                [self drawChildName:childProfileObject.nick_Name withFrame:CGRectMake(0,0, 0, 0) withInteger:centerCount];
//                
//                scrollYY =view.frame.origin.y + view.frame.size.height+7*ScreenHeightFactor;
//                scrollXX += view.frame.size.width;
//                [holidayView addSubview:view];
//                stripView = [[StripView alloc]initWithFrame:CGRectMake(0,scrollYY, self.view.frame.size.width,27*ScreenHeightFactor)];
//                [stripView drawStrip:@"Holidays List" color:[UIColor clearColor]];
//                [holidayView addSubview:stripView];
//                [scrollView addSubview:holidayView];
//                
//            }
//            centerCount += 2;
//            i++;
//        }
//        
//        ChildProfileObject *childProfileObject =  [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:pageControl.currentPage];
//        
//        [self listOfChildByChildId:childProfileObject.child_ID];
//        scrollYY+=stripView.frame.size.height+4*ScreenHeightFactor;
//        
//        float calenderHeight  = scrollView.frame.size.height-scrollYY - 42*ScreenHeightFactor;
//        
//        holidayView.userInteractionEnabled = YES;
//        
//        
//        holidayView.showActivityLoadingView = [self addLoaderViewWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height) WithView:holidayView];
//        
//        [holidayViewArray addObject:holidayView];
//    }
//    
//    
//    [scrollView setContentSize:CGSizeMake(scrollXX,scrollView.frame.size.height)];
    
}


-(void) addButton
{
    if(!addBtn)
    {
        addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setFrame:CGRectMake(0, 0, ScreenHeightFactor*25, ScreenHeightFactor*25)];
        [addBtn setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"addActivity.png")] forState:UIControlStateNormal];
        addBtn.tintColor=radiobuttonSelectionColor;
        if(screenWidth>500)
        {
            addBtn.center=CGPointMake(screenWidth-addBtn.frame.size.width/2-cellPadding, yy);
        }
        else {
            addBtn.center=CGPointMake(screenWidth-addBtn.frame.size.width/2-cellPadding, yy);
        }
        [addBtn setBackgroundColor:[UIColor clearColor]];
        [loadElementView addSubview:addBtn];
        [addBtn addTarget:self action:@selector(tapAtAddIcon:) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(RedLabelView *)drawChildName:(NSString *)childName withFrame:(CGRect)rect withInteger:(int)i
{
    
    if(screenWidth>700)
    {
        label=[[RedLabelView alloc]initWithFrame:CGRectMake(0,rect.origin.y, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:childName];
    }
    else
    {
        label=[[RedLabelView alloc]initWithFrame:CGRectMake(0,rect.origin.y, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:childName];
    }
    [label setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:label];
    
    return label;
}

-(void)getMenuTouches
{
    [self touchAtMenuButton:self];
}
-(void)touchAtBackButton
{
    [self goBack];
}
-(void)touchAtMenuButton:(id)sender {
    if(!menu) {
        removeMenuView=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height, screenWidth, screenHeight-headerView.frame.size.height)];
        removeMenuView.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *removeMenuGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToRemoveMenu:)];
        [removeMenuView addGestureRecognizer:removeMenuGesture];
        
        menu=[[MenuSettingsView alloc]initWithFrame:CGRectMake(screenWidth,20*ScreenHeightFactor, screenWidth*.5, screenHeight)andViewCtrl:self];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:menu.bounds];
        menu.layer.masksToBounds = NO;
        [menu.layer setShadowColor:[UIColor grayColor].CGColor];
        [menu.layer setShadowOpacity:0.8];
        [menu.layer setShadowRadius:10.0];
        [menu.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
         menu.layer.shadowPath = shadowPath.CGPath;
        [loadElementView addSubview:menu];
    }
    if(!isToggleMenu)
    {
        isToggleMenu=YES;
        [self slideIn];
    }
    else
    {
        [self touchToRemoveMenu:nil];
    }
}

-(void)goBack {
    if(getListOfholidayByChildId){
        [getListOfholidayByChildId stopConnection];
        getListOfholidayByChildId = nil;
    }
    [self removeLoaderView];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)slideIn {
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [loadElementView addSubview:removeMenuView];
        [loadElementView setUserInteractionEnabled:NO];
        [loadElementView setCenter:CGPointMake(loadElementView.center.x-screenWidth*.5, self.view.center.y)];
    } completion:^(BOOL finished) {
        [loadElementView setUserInteractionEnabled:YES];
    }];

}

-(void)touchToRemoveMenu:(id)sender {
    isToggleMenu=NO;
    [self slideOut];
}

-(void)slideOut
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [removeMenuView removeFromSuperview];
        [loadElementView setUserInteractionEnabled:NO];
        [loadElementView setCenter:CGPointMake(loadElementView.center.x+screenWidth*.5, self.view.center.y)];
    } completion:^(BOOL finished) {
        [loadElementView setUserInteractionEnabled:YES];
    }];
}


#pragma mark WebServices related Functions
-(void)listOfChildByChildId:(NSString *)childId {
    getListOfholidayByChildId = [[GetListofHolidaysByChildIDService alloc]init];
    [getListOfholidayByChildId setDelegate:self];
    [getListOfholidayByChildId setServiceName:PinWiGetListofHolidaysByChildID];
    [getListOfholidayByChildId initService:@{@"ChildID":childId}];
    [self addLoaderView];
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection {
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection {
    [self removeLoaderView];
   NSDictionary *resultDict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetListofHolidaysByChildIDResponse resultKey:PinWiGetListofHolidaysByChildIDResult];

    if(!resultDict){
        return;
    }
    
    if([resultDict isKindOfClass:[NSArray class]]) {
        [tableDataStorage removeAllObjects];
        NSArray *arr = (NSArray *)resultDict;
        NSDictionary *dictionary    = [arr firstObject];
        if([dictionary valueForKey:@"ErrorDesc"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            
            for(NSDictionary *dictionary in arr) {
                [tableDataStorage addObject:[dictionary valueForKey:@"HolidayDescription"]];
            }
            
        }
        [_table reloadData];
    }

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

-(void)tapAtAddIcon:(id)sender {
    [self goToNextController:YES description:nil];
}
-(void)goToNextController:(BOOL)isTouchEnable description:(NSString *)description {
    GetHolidayDetailsByHolidayDescController *holidayDescController = [[GetHolidayDetailsByHolidayDescController alloc]init];
    [holidayDescController setNickName:_nickName];
    [holidayDescController setChildId :_childId];
    [holidayDescController setHolidayDescription:description];
    [holidayDescController setIsTouchEnable:isTouchEnable];
    [[self navigationController] pushViewController:holidayDescController animated:YES];
}


#pragma mark TableView Specific Functions
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableDataStorage.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"HolidayCell";
    ListOfHolidayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[ListOfHolidayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell  initialization:CGSizeMake(self.view.frame.size.width, cellHeight)];
        
    }
    [cell updateUI:[tableDataStorage objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self goToNextController:NO description:[tableDataStorage objectAtIndex:indexPath.row]];
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


#pragma mark ScrollViewSpecificFunctions
-(void)setupPageControl:(NSInteger)number_Of_Page
{
    // int height  = [self navigationBarHeight];
    if(screenWidth>700)
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*3,pageControlHeight,pageControlHeight)];
        pageControl.transform = CGAffineTransformMakeScale(2, 2);
    }
    else
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*12,pageControlHeight,pageControlHeight)];
    }
    
    [pageControl setCenter:CGPointMake(screenWidth/2, pageControl.center.y)];
    [pageControl setCenter:CGPointMake(screenWidth/2, pageControl.center.y)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=number_Of_Page;
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [self.view addSubview:pageControl];
}

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pageControlBeingUsed)
    {
        CGFloat pageWidth = sender.frame.size.width;
        int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        pageControl.currentPage = page;
        
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)sender
{
    pageControlBeingUsed = NO;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    pageControlBeingUsed = NO;
    
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
