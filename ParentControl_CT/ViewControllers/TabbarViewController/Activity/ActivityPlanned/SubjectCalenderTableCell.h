//
//  SubjectCalenderTableCell.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@interface SubjectCalenderTableCell : UITableViewCell

@property UILabel *subjectLabel;
@property NSMutableArray *daysArray;

-(void)addSubject:(NSString *)sub withDaysArray:(NSMutableArray*)daysPlannedArray withScreenWd:(float)screenWidth screenHt:(float)screenHeight;

@end
