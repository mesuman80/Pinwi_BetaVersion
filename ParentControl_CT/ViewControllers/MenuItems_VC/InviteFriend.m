//
//  WelcomeScreenViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 11/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InviteFriend.h"
#import "SupportView.h"
#import "MenuSettingsViewCell.h"
#import "GetInviteURL.h"
#import "ShowActivityLoadingView.h"
#import "HeaderView.h"
//#import "AppEnterCodeTableViewController.h"

@interface InviteFriend ()<UrlConnectionDelegate,HeaderViewProtocol>
{
    UIImageView *topStrip,*bottomStrip,*titleImg, *centerIcon, *moreIcon, *navBgBar;
    UIScrollView *scrollView;
    UILabel *textLabel,*textLabel1;
    CGSize displayValueSize;
    UIButton *gotoTermsBtn;
    UIView *lineView;
    int yy ;
    UITextField *activeField;
    ShowActivityLoadingView *loaderView;
     HeaderView *headerView ;
    NSString *inviteLink;
}
@end

@implementation InviteFriend
{
    
}
@synthesize inviteTable;


- (void)viewDidLoad {
    [super viewDidLoad];
    yy = 0;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]InviteList];
    
    [self.view setBackgroundColor:appBackgroundColor];
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton = YES;
     
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor=appBackgroundColor;
    scrollView.scrollEnabled = NO;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
     [self drawHeaderView];
    
    scrollView.frame=CGRectMake(0,yy, screenWidth, screenHeight-yy);
   
    [self.view addSubview:scrollView];
    
    [self drawCenterIcon];
    [self drawtableView];
    [self getURL];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //self.navigationController.navigationBarHidden=NO;
}

-(void)drawtableView
{
    inviteTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, scrollView.frame.size.height)];
    [scrollView addSubview:inviteTable];
    inviteTable.backgroundColor=appBackgroundColor;
    inviteTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    inviteTable.delegate=self;
    inviteTable.dataSource=self;
    inviteTable.scrollEnabled=NO;
}

-(void)getWidthHeight
{
    
    screenHeight=[ScreenInfo getScreenHeight];
    screenWidth=[ScreenInfo getScreenWidth];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //self.navigationController.navigationBarHidden=YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden=YES;
    [centerIcon removeFromSuperview];
    centerIcon=nil;
}

-(void) drawCenterIcon
{
//    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"invitefrndHeader.png") ]];
//    centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//    if(self.view.frame.size.width>700)
//    {
//         centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+20);
//    }
//    else
//    {
//         centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
//    }
//   
//    [self.navigationController.navigationBar addSubview:centerIcon];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return inviteListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ScreenHeightFactor*80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuTableCell";
    MenuSettingsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[MenuSettingsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *imgStr=[NSString stringWithFormat:@"%@.png",[inviteListArray objectAtIndex:indexPath.row]];
    [cell addInviteCredential:[inviteListArray objectAtIndex:indexPath.row] image:[UIImage imageNamed:isiPhoneiPad(imgStr)]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self getTouchesOfCells:(int)indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)getTouchesOfCells:(int)rowNum
{
    [self getURL];
    
    switch (rowNum) {
        case 0:
            [self iniviteFriendByEmail:nil];
            break;
            
        case 1:
            [self openMessageController];
            break;
            
        case 2:
            [self inviteFriendFromWatsApp];
            break;
            
        case 3:
            
            break;
    }
    
}



#pragma mark KeyBoard Notification
-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
-(void) keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0, kbSize.height-64, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = scrollView.frame;
    aRect.size.height -= kbSize.height;
    CGPoint point=activeField.frame.origin;
    point.y+=64;
    if (!CGRectContainsPoint(aRect,point))
    {
        CGPoint scrollPoint = CGPointMake(0.0,activeField.frame.origin.y-aRect.size.height+activeField.frame.size.height+5);
        scrollPoint.y+=64;
        [scrollView setContentOffset:scrollPoint animated:YES];
        //CGPointMake
        [scrollView setContentSize:CGSizeMake(screenWidth, screenHeight+64)];
    }
}
-(void) keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsMake(0, 0.0,0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    NSLog(@"Live=%f",self.view.frame.size.height/2.0f);
    [ scrollView setContentSize:CGSizeMake(screenWidth, screenHeight)];
}

#pragma mark Mail Invitation
-(void)iniviteFriendByEmail:(NSArray *)toRecipents
{
    NSString *str= inviteLink;//[NSString stringWithFormat:@"Hey,Check out your child's interest by downloading pinWi."];
    
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:@"PinWi"];
        [mc setMessageBody:str isHTML:NO];
        //[mc setToRecipients:toRecipents];
        [self presentViewController:mc animated:YES completion:NULL];
    }
       else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Setup Mail Account in Phone Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
       
       - (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
    {
        switch (result)
        {
            case MFMailComposeResultCancelled:
                NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
                break;
                
            case MFMailComposeResultSaved:
                NSLog(@"Mail saved: you saved the email message in the drafts folder.");
                break;
                
            case MFMailComposeResultSent:
                NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
                break;
                
            case MFMailComposeResultFailed:
                NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
                break;
            default:
                NSLog(@"Mail not sent.");
                break;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
#pragma mark MessageController Specific Function
       -(void)openMessageController
    {
        if([MFMessageComposeViewController canSendText])
        {
            MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
            smsController.messageComposeDelegate = self;
            smsController.subject=@"Sms";
            smsController.body = inviteLink;
            [self presentViewController:smsController animated:YES completion:nil];
        }
        
    }
       - (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
    {
        switch (result)
        {
            case MessageComposeResultCancelled:
                NSLog(@"Message was cancelled");
                break;
                
            case MessageComposeResultFailed:
                NSLog(@"Message failed");
                break;
                
            case MessageComposeResultSent:
                NSLog(@"Message was sent");
                break;
                
            default:
                break;
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
    }

#pragma mark Watsapp Invitation
-(void)inviteFriendFromWatsApp
{
   inviteLink= [inviteLink substringToIndex:inviteLink.length-1];
    inviteLink= [inviteLink substringFromIndex:1];
   
   // Hey! Did you hear about PiNWi - a new app to map what drives your children’s interest?
  //  It looks promising to me. Try is out. Here is the link -
    
  //  inviteLink =[NSString stringWithFormat:@"Hey! Did you hear about PiNWi - a new app to map what drives your children’s interest?It looks promising to me. Try is out. Here is the link -%@",inviteLink];
    
    NSString *inviteString=[NSString stringWithFormat:@"whatsapp://send?text=%@",inviteLink];
    
    NSURL *whatsappURL = [NSURL URLWithString:inviteString];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}

#pragma mark url delegates
-(void)getURL
{
    
    NSDictionary *dict1 = [[PC_DataManager sharedManager].serviceDictionary objectForKey:PinWiGetInviteURL];
    if(dict1)
    {
        [self getInviteLinkString:dict1];
    }
    else{
    GetInviteURL *getlink = [[GetInviteURL alloc] init];
    [getlink initService:@{
                              @"ParentID":[PC_DataManager sharedManager].parentObjectInstance.parentId
                              }];
    
    [getlink setDelegate:self];
    getlink.serviceName=PinWiGetInviteURL;
    [self addLoaderView];
    }
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"Connection Finish data =%@",dictionary);
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:PinWiGetInviteURL])
    {
        
        NSDictionary *getCityListResponse = [dictionary valueForKey:PinWiGetInviteURLResponse];
        NSDictionary *getCityResult =  [getCityListResponse valueForKey:PinWiGetInviteURLResult];
        NSString *textStr= [getCityResult valueForKey:@"text"];
        NSArray *textStrArray = [textStr componentsSeparatedByString:@"["];
        NSString *errorCode  = [textStrArray objectAtIndex:2];
        if ([errorCode length] > 0)
        {
            errorCode = [errorCode substringToIndex:[errorCode length] - 2];
            errorCode = [errorCode substringFromIndex:1];
        }
       // NSData *data = [errorCode dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict  = @{
                                @"inviteString":errorCode
                                }
                                ;
        [self getInviteLinkString:dict];
        [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:PinWiGetInviteURL];

        
        
        
        
//        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetInviteURLResponse resultKey:PinWiGetInviteURLResult];
//        NSLog(@"Dict  = %@ ",dict);
//        if([dict isKindOfClass:[NSArray class]])
//        {
//            NSArray *arr = (NSArray *)dict;
//            NSDictionary *dictionary = [arr firstObject];
//            [self getInviteLinkString:dictionary];
//            [[PC_DataManager sharedManager].serviceDictionary setObject:dictionary forKey:PinWiGetInviteURL];
//        }
    }
}

-(void)getInviteLinkString:(NSDictionary*)dict1
{
    inviteLink=nil;
    inviteLink=[dict1 objectForKey:@"inviteString"];
    
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

#pragma mark HeaderViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"invitefrndHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Invite Friends" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view addSubview:headerView];
        
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+30*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }

    }
    
    
}
-(void)getMenuTouches
{
    
}
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
