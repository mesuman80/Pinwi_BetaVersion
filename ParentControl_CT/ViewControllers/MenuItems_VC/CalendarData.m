                                            //
//  CalendarData.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 07/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CalendarData.h"
#import "CalendarDateSelected.h"
#define PinWiCalenderDateFormat @"dd/MM/yyyy"

static CalendarData *calenderData;
@implementation CalendarData
@synthesize allDateArray;

+(CalendarData *)sharedData
{
    if(!calenderData)
    {
        calenderData  = [[CalendarData alloc] init];
        
    }
    return calenderData;
}

-(id)init
{
    if(self = [super init])
    {
        allDateArray = [[NSMutableArray alloc]init];
        return self;
    }
    return nil;
}
-(CalendarDateSelected *)addObjectInArray:(NSDate *)date withKey:(NSString *)childId andFlag:(NSString*)flag
{
    CalendarDateSelected *dateSelected  = [self isCalenderDateExists:date childId:childId withString:nil];
    if(!dateSelected)
    {
        NSString *dateStr = [self convertDateInToString:date withFormat:PinWiCalenderDateFormat];
        CalendarDateSelected *calendarDateSelected  = [[CalendarDateSelected alloc]init];
        [calendarDateSelected setDate:dateStr];
        [calendarDateSelected setChildId:childId];
        [calendarDateSelected setFlag:flag];
        [allDateArray addObject:calendarDateSelected];
        return calendarDateSelected;
    }
    return dateSelected;
    
}
-(CalendarDateSelected *)isCalenderDateExists:(NSDate *)date1 childId:(NSString *)childId withString:(NSDictionary *) date
{
    NSString *date2;
    if(date1)
    {
        date2 = [date objectForKey:@"HolidayDate"];
         date2= [self convertDateInToString:date1 withFormat:PinWiCalenderDateFormat];
    }
    for(CalendarDateSelected *calenderDateSelected in allDateArray)
    {
        if([calenderDateSelected.date isEqualToString:date2] && [calenderDateSelected.childId isEqualToString:childId])
        {
            return calenderDateSelected;
        }
    }
    return nil ;
}
-(BOOL)isArraycontainsDate:(NSDate *)date withChildId:(NSString *)childID
{
     BOOL isArrayContainsDate = NO;
    NSString *date_to_be_checked = [self convertDateInToString:date withFormat:PinWiCalenderDateFormat];
    for(CalendarDateSelected *calenderDate  in allDateArray)
    {
        if([calenderDate.date isEqualToString:date_to_be_checked] && [calenderDate.childId isEqualToString:childID])
        {
            isArrayContainsDate = YES;
            break;
        }

    }
     return isArrayContainsDate;
}
-(void)removeObjectByKey:(NSString *)childId
{

}
-(CalendarDateSelected *)removeObjectFromArray:(NSDate *)date_to_be_Remove withKey:(NSString *)childId
{
   // BOOL isRemove = NO;
    if(date_to_be_Remove)
    {
        NSString *date_to_be_removeStr = [self convertDateInToString:date_to_be_Remove withFormat:PinWiCalenderDateFormat];
        if(date_to_be_removeStr)
        {    NSInteger  i = 0;
            for(CalendarDateSelected *calenderDateSelected in allDateArray)
            {
                if([calenderDateSelected.date isEqualToString:date_to_be_removeStr] && [calenderDateSelected.childId isEqualToString:childId] && ![calenderDateSelected.flag isEqualToString:@"1"])
                {
                    CalendarDateSelected *cds = calenderDateSelected;
                    [allDateArray removeObjectAtIndex:i];
                    NSLog(@"remove date  :) hfdsncngchjghfcgh");
                    return cds;
                }
                i++;
            }
          return nil;
        }
      return nil;
    }
   return nil;
}
-(NSString *)convertDateInToString:(NSDate *)date withFormat:(NSString *)dateFormat
{
    NSDateFormatter *userFormatter = [[NSDateFormatter alloc] init];
    [userFormatter setDateFormat:dateFormat];
    [userFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateConverted = [userFormatter stringFromDate:date];
    return dateConverted;
}

-(NSMutableArray *)getSelectedDatewithChildId :(NSString *)childId
{
    NSMutableArray *dateArray  = [[NSMutableArray alloc]init];
    BOOL isInLoop = NO;
    for(CalendarDateSelected *allDateStr in allDateArray)
    {
        if([allDateStr.childId isEqualToString:childId])
        {    isInLoop = YES;
            [dateArray addObject:allDateStr];
        }
    }
    
    if(!isInLoop)
    {
         dateArray = nil;
    }
    else
    {
       return [dateArray valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", @"date"]];
    }
    
    return dateArray;
}
-(CalendarDateSelected *)saveAllData:(NSDictionary *)dateString withKey:(NSString *)childId
{
    CalendarDateSelected *dateSelected  = [self isCalenderDateExists:nil childId:childId withString:dateString];
    if(!dateSelected)
    {
        dateSelected  = [[CalendarDateSelected alloc]init];
        dateSelected.date = [dateString objectForKey:@"HolidayDate"];
        dateSelected.childId = childId;
        dateSelected.flag= [NSString stringWithFormat:@"%@",[dateString objectForKey:@"Flag"]];
        [allDateArray addObject:dateSelected];
        return dateSelected;

    }
    return dateSelected;
}
-(NSArray *)getAllDatesBetweenTwoDates:(NSDate *)startDate endDate :(NSDate *)endDate
{
    
    
    startDate = [self getFormatedDate:startDate];
    endDate   = [self getFormatedDate:endDate];
    
    NSMutableArray *dates = [@[startDate] mutableCopy];
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    for (int i = 1; i < components.day; ++i) {
        NSDateComponents *newComponents = [NSDateComponents new];
        newComponents.day = i;
        
        NSDate *date = [gregorianCalendar dateByAddingComponents:newComponents
                                                          toDate:startDate
                                                         options:0];
        [dates addObject:date];
    }
    
    [dates addObject:endDate];
    return dates;
}
-(NSDate *)getFormatedDate:(NSDate *)date
{
    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:date];
    
    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
    NSDate* nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    return nowDate;
}

@end
