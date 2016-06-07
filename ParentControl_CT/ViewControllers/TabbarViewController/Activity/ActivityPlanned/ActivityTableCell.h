//
//  ActivityTableCell.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@interface ActivityTableCell : UITableViewCell

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

-(void)addSubjectCredential:(NSString*)statusString;

-(void)addSubject:(NSString *)sub withDaysArray:(NSMutableArray*)daysPlannedArray withScreenWd:(float)screenWidth screenHt:(float)screenHeight;

-(void)addActivity:(NSString *)sub withDaysArray:(NSMutableArray*)daysPlannedArray startOn:(NSString*)startTime endOn:(NSString*)endTime repaetFor:(NSString*)repeatTime withScreenWd:(float)screenWidth1 screenHt:(float)screenHeight1;

-(void)scheduleActivity:(NSMutableDictionary*)statusDict;
-(void)addActivity:(NSMutableDictionary *)activityDict;
@end
