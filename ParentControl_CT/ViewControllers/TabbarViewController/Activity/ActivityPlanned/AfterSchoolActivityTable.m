//
//  SubjectCalenderTableView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AfterSchoolActivityTable.h"
#import "PC_DataManager.h"

@implementation AfterSchoolActivityTable
{
    NSArray *array;
    NSMutableArray *daysPlannedArray;
}

-(id)initWithFrame:(CGRect)frame
{
    if(self =[super initWithFrame:frame])
    {
        
        [self setDelegate:self];
        [self setDataSource:self];
        self.backgroundColor=appBackgroundColor;
        
        
        //self.bounces=NO;
        //array=[[NSArray alloc] initWithObjects:@"Yoga Class",@"Dance Class",@"Music Class", nil];
        [[PC_DataManager sharedManager] getWidthHeight];
        
        //[self reloadData];
        return self;
    }
    return nil;
}


#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"instantiate cell count %lu",(unsigned long)array.count);
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return screenHeight*.15;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"instantiate caleder school cell");
    if(daysPlannedArray)
    {
        [daysPlannedArray removeAllObjects];
        daysPlannedArray = nil;
    }
    
    daysPlannedArray=[[NSMutableArray alloc]init];
    for (int i=0; i<7; i++) {
        [daysPlannedArray addObject:[NSString stringWithFormat:@"%i",arc4random()%2]];
    }
    
    
    NSLog(@" daysPlannedArray %@", daysPlannedArray);
    
    
    static NSString *CellIdentifier = @"AfterSchoolTableViewCell";
    AfterSchoolTableViewCell *cell = [[AfterSchoolTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell addActivity:[array objectAtIndex:indexPath.row] withDaysArray:daysPlannedArray startOn:@"10:00 am" endOn:@"11:00 am" repaetFor:@"Every Week" withScreenWd:screenWidth screenHt:screenHeight];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end