//
//  AfterSchoolTableViewCell.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@interface AfterSchoolTableViewCell : UITableViewCell


@property UILabel *subjectLabel;

@property UILabel *startLabel;
@property UILabel *endLabel;
@property UILabel *repeatLabel;

@property UILabel *startTimeLabel;
@property UILabel *endTimeLabel;
@property UILabel *repeatTimeLabel;

@property NSMutableArray *daysArray;

-(void)addActivity:(NSString *)sub withDaysArray:(NSMutableArray*)daysPlannedArray startOn:(NSString*)startTime endOn:(NSString*)endTime repaetFor:(NSString*)repeatTime withScreenWd:(float)screenWidth screenHt:(float)screenHeight;

@end
