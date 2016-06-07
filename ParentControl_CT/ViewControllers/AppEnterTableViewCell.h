//
//  AppEnterTableViewCell.h
//  ParentControl_CT
//
//  Created by Priyanka on 01/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@interface AppEnterTableViewCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UILabel       * nameLabel;

@property(strong,nonatomic) IBOutlet UIImageView   * userImageView;

@property(strong,nonatomic) IBOutlet  UILabel      *  earned,*pending;


-(void)setupCellWithDictionary:(NSDictionary *)userDict;
-(void)addNewItems;
@end
