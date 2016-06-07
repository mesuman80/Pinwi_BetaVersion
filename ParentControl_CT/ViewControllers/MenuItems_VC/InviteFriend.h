//
//  ViewController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 01/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import <MessageUI/MessageUI.h>

@interface InviteFriend: UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property UITableView *inviteTable;

@end
