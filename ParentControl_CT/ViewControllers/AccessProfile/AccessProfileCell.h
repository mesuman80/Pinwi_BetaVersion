//
//  AccessProfileCell.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 29/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@interface AccessProfileCell : UITableViewCell

@property UILabel *nameLabel;
@property UIImageView *userImage;
@property UILabel *earnedPoints;
@property UILabel *pendingPoints;
@property UIImageView *earnedImage;
@property UIImageView *pendingImage;
@property UIImageView *arrowImgView;

-(void)addParentCredential:(NSString*)name image:(UIImage*)image;
-(void)addChildCredential:(NSString*)name image:(UIImage*)image earnedPoints:(NSString*)earned pendingPOints:(NSString*)pending;
@end
