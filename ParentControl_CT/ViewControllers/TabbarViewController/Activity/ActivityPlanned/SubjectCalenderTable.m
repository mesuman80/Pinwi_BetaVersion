//
//  SubjectCalenderTableView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "SubjectCalenderTable.h"
#import "PC_DataManager.h"

@implementation SubjectCalenderTable
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
        
        array=[[NSArray alloc] initWithObjects:@"Maths",@"English",@"Hindi", nil];
        [[PC_DataManager sharedManager] getWidthHeight];
        self.backgroundColor=appBackgroundColor;
        
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
    return screenHeight*.08;
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
    
    
        static NSString *CellIdentifier = @"SubjectCalenderTableCell";
        SubjectCalenderTableCell *cell = [[SubjectCalenderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell addSubject:[array objectAtIndex:indexPath.row] withDaysArray:daysPlannedArray withScreenWd:screenWidth screenHt:screenHeight];
    
    
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