//
//  ActivityTableCell.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@interface CalenderByDateCell : UITableViewCell

@property UILabel *subjectLabel;

@property UILabel *startLabel;
@property UILabel *endLabel;
@property UILabel *repeatLabel;

@property UILabel *startTimeLabel;
@property UILabel *endTimeLabel;
@property UILabel *repeatTimeLabel;

@property UIImageView *spclImg;
@property UIImageView *privateImg;
@property UIImageView *ValidImg;

@property NSMutableArray *daysArray;
@property NSMutableArray *daysPlannedArray;


-(void)addSubject:(NSDictionary *)subDictionary;
-(void)addActivityHeading:(NSDictionary*)subDict;
@end
