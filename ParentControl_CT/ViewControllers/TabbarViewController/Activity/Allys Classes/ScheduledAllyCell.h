//
//  ActivityTableCell.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@interface ScheduledAllyCell : UITableViewCell

@property UILabel *nameLabel;
@property UILabel *dateLabel;
@property UILabel *timeLabel;
@property UILabel *pickDropLabel;

-(void)listingOfAlly:(AllyProfileObject*)allyObj;
@end
