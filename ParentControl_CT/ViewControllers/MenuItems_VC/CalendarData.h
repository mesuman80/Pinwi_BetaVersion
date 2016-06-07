//
//  CalendarData.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 07/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CalendarDateSelected;
@interface CalendarData : NSObject
@property NSMutableArray *allDateArray;
+(CalendarData *)sharedData;
-(CalendarDateSelected *)saveAllData:(NSDictionary *)dateString withKey:(NSString *)childId;
-(CalendarDateSelected *)addObjectInArray:(NSDate *)date withKey:(NSString *)childId andFlag:(NSString*)flag;
-(CalendarDateSelected *)removeObjectFromArray:(NSDate *)date_to_be_Remove withKey:(NSString *)childId;
-(void)removeObjectByKey:(NSString *)childId;
-(BOOL)isArraycontainsDate:(NSDate *)date withChildId:(NSString *)childID;
-(NSString *)convertDateInToString:(NSDate *)date withFormat:(NSString *)dateFormat;
-(NSMutableArray *)getSelectedDatewithChildId :(NSString *)childId;
-(NSArray *)getAllDatesBetweenTwoDates:(NSDate *)startDate endDate :(NSDate *)endDate;
@end
