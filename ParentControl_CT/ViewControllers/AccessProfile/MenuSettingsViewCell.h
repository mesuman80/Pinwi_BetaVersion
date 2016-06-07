//
//  AccessProfileCell.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 29/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@interface MenuSettingsViewCell : UITableViewCell

@property UILabel *nameLabel;
@property UIImageView *userImage;


-(void)addMenuCredential:(NSString*)name image:(UIImage*)image;
-(void)addInviteCredential:(NSString*)name image:(UIImage*)image;

@end
