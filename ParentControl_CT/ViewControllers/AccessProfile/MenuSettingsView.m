//
//  MenuSettingsView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 01/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "MenuSettingsView.h"
#import "MenuSettingsViewCell.h"
#import "SignUpViewController.h"
#import "ShowActivityLoadingView.h"

@implementation MenuSettingsView
{
   // NSArray *menuListArray;
    SignUpViewController *sign;
    ShowActivityLoadingView *loaderView;
}
@synthesize rootViewController;

-(id)initWithFrame:(CGRect)frame andViewCtrl:(UIViewController*)rootViewCtrl
{
    if(self==[super initWithFrame:frame])
    {
        rootViewController=rootViewCtrl;
        [self setElements];
    }
    return self;
}
-(void)setElements
{
    [[PC_DataManager sharedManager] getWidthHeight];
    [[PC_DataManager sharedManager] MenuList];

    [self setDelegate:self];
    [self setDataSource:self];
    self.scrollEnabled=NO;
    self.backgroundColor=[UIColor whiteColor];
    
    self.window.backgroundColor = [UIColor colorWithRed:0.78f green:0.13f blue:0.11f alpha:1];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
}



#pragma mark Table view delegates!

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
       return screenHeight*.08;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuTableCell";
    MenuSettingsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[MenuSettingsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *imgStr=[NSString stringWithFormat:@"%@.png",[menuListNameArray objectAtIndex:indexPath.row]];
    [cell addMenuCredential:[menuListArray objectAtIndex:indexPath.row] image:[UIImage imageNamed:isiPhoneiPad(imgStr)]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self getTouchesOfCells:(int)indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)getTouchesOfCells:(int)rowNum
{
    if(rowNum==1 && [self.parentClass isEqualToString:NoChildTouchForMenu])
    {
        return;
    }
    
    if(rowNum==4)
    {
        NSLog(@"Logout");
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isLoggedOut"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
         NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"isLoggedOut"]);
        [PC_DataManager sharedManager].serviceDictionary = nil;
        sign=[[SignUpViewController alloc]init];
        UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:sign];
        [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
        [self performSelector:@selector(loadSighnView) withObject:nil afterDelay:1.0f];
    }
//    else if (rowNum==6)
//    {
//        [self addOnRequest];
//    }
    else
    {
        
        
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [[rootViewController navigationItem] setBackBarButtonItem:newBackButton];

        NSString *classStr=[menuListNameArray objectAtIndex:rowNum];
        
        UIViewController *viewCtrl=[[NSClassFromString(classStr) alloc]init];
         [viewCtrl setHidesBottomBarWhenPushed:YES];
        
        //[viewCtrl.view setBackgroundColor:[UIColor whiteColor]];
        [rootViewController.navigationController pushViewController:viewCtrl animated:YES];
    }
    
    
    
    /*switch (rowNum) {
        case 0:
            NSLog(@"About us");
            break;
        case 1:
             NSLog(@"Support");
            break;
        case 2:
             NSLog(@"Tutorial");
            break;
        case 3:
             NSLog(@"Invite friend");
            break;
        case 4:
             NSLog(@"Contact us");
            break;
        case 5:
            NSLog(@"Settings");
            //[rootViewController.navigationController pushViewController:<#(UIViewController *)#> animated:YES];
            
            
            break;
        case 6:
            NSLog(@"Logout");
            [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isLoggedOut"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            exit(1);
            break;
    }*/
}

-(void)loadSighnView
{
    [sign isDeviceTokenExist:YES];
}
#pragma mark url delegates
-(void)addOnRequest
{
    RequestAddOnVersion *getDetails = [[RequestAddOnVersion alloc] init];
    [getDetails initService:@{
                              @"ParentID":[PC_DataManager sharedManager].parentObjectInstance.parentId
                              }];
    [getDetails setDelegate:self];
    getDetails.serviceName=PinWiRequestAddOnVersion;
    [self addLoaderView];
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:PinWiRequestAddOnVersion])
    {
        
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiRequestAddOnVersionResponse resultKey:PinWiRequestAddOnVersionResult];
        NSLog(@"Dict  = %@ ",dict);
        if(!dict)
        {
            return;
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Add On Request" message:@"Your request for AddOn services has been confirmed!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

}


#pragma mark ADD / REMOVE LOADER
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(-screenWidth/2, 0, screenWidth/2, screenHeight)];
    [loaderView showLoaderViewWithText:@"Hold On.."];
    [self addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}


@end
