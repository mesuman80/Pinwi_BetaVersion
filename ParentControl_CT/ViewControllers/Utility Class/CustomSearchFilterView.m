//
//  CustomSearchFilterView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 09/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CustomSearchFilterView.h"

@implementation CustomSearchFilterView
{
    NSArray *filterData;
    NSArray *actualData;
    NSString *textFieldString;
    UITableView *searchTableView;
    UITextField *searchTextField;
    BOOL isSearchActive;
}

-(id)init:(NSString*)searchtext andArray:(NSMutableArray*)placeArray
{
        if(self=[super init])
        {
            searchTextField=[[UITextField alloc]initWithFrame:CGRectMake(10,70, 300, 40)];
            searchTextField.borderStyle=UITextBorderStyleRoundedRect;
            searchTextField.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [searchTextField setDelegate:self];
            [self addSubview:searchTextField];
            actualData=placeArray;//[[NSArray alloc]initWithObjects:@"s",@"su",@"sun",@"sund",@"sunda",@"sunday", nil];
            textFieldString=@"";
             return self;
        }
    return nil;
}

#pragma mark TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!searchTableView)
    {
        searchTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,112,310, 150)];
        [searchTableView setDelegate:self];
        [searchTableView setDataSource:self];
        searchTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:searchTableView];
        
    }
    [searchTableView setAlpha:0.0];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    isSearchActive=YES;
    if(searchTableView.alpha==0.0)
    {
        [searchTableView setAlpha:1.0];
    }
    if([string isEqualToString:@""])//for BackSpace
    {
        textFieldString= [textFieldString stringByReplacingCharactersInRange:range withString:string];
    }
    else
    {
        textFieldString=[textFieldString stringByAppendingString:string];
    }
    [self filterContentForSearchText:textFieldString];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self reset:textField];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self reset:textField];
    return YES;
}
-(void)reset:(UITextField *)textField
{
    isSearchActive=NO;
    textFieldString=textField.text;
    [searchTableView setAlpha:0.0];
    [self endEditing:YES];
}

#pragma mark filterArray According To TextEnter
- (void)filterContentForSearchText:(NSString*)searchText
{
    //beginswith[c]
    //contains
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    filterData = [actualData filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"Filter  data=%@",filterData);
    [searchTableView reloadData];
}

#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearchActive)
    {
        return filterData.count;
    }
    else
    {
        return actualData.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AutoTextFieldCell";
    NSString *displayString=nil;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if(isSearchActive)
    {
        displayString=[filterData objectAtIndex:indexPath.row];
    }
    else
    {
        displayString=[actualData objectAtIndex:indexPath.row];
    }
    cell.textLabel.text=displayString;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    textFieldString=@"";
    if(isSearchActive)
    {
        searchTextField.text= textFieldString=[filterData objectAtIndex:indexPath.row];
    }
    else
    {
        searchTextField.text=textFieldString=[actualData objectAtIndex:indexPath.row];
    }
    [searchTableView setAlpha:0.0];
}
#pragma mark ScrollView Delegate Function
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // [self.view endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




@end
