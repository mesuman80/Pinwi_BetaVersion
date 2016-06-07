 //
//  TimePicker.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "TimePicker.h"
#import "CancelDoneToolBar.h"
#import "Constant.h"

@implementation TimePicker
{
    NSMutableArray *pickerData;
    NSString *autoLockTime;
    NSString *type;
    int tagValue;
}
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        return self;
    }
    return nil;
}
-(void)pickerView:(NSString*)pickerType
{
    type=pickerType;
    autoLockTime = @"0";
    
    pickerData = [[NSMutableArray alloc]init];
    
    if([type isEqualToString:@"Autolock"])
    {
    pickerData = [@[@"1",@"3",@"5",@"10",@"15",@"30",@"45" ]mutableCopy];
        
        
    }
    
    else if ([type isEqualToString:@"Radius"])
    {
        for(int i = 0 ;i<=20 ; i++)
                {
                    [pickerData addObject:[NSString stringWithFormat:@"%i",i]];
                }
    }

    else if ([type isEqualToString:@"Frequency"])
    {
        pickerData = [@[@"Daily",@"Weekly",@"Monthly",@"Never"]mutableCopy];
    }
// pickerData = @[@"1",@"3",@"5",@"10",@"15",@"30"];
    
//    for(int i = 0 ;i<=59 ; i++)
//    {
//        [pickerData addObject:[NSString stringWithFormat:@"%i",i]];
//    }
//    
    CancelDoneToolBar *cancelDoneToolBar = [[CancelDoneToolBar alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,70*ScreenHeightFactor)];
    [cancelDoneToolBar setBackgroundColor:[UIColor whiteColor]];
    [cancelDoneToolBar setDelegate:self];
    [cancelDoneToolBar drawButtons];
    [cancelDoneToolBar.cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancelDoneToolBar.doneButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancelDoneToolBar.doneButton.titleLabel setFont:[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(320, 2)+powf(568, 2))]];
     [cancelDoneToolBar.cancelButton.titleLabel setFont:[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(320, 2)+powf(568, 2))]];

    [self addSubview:cancelDoneToolBar];
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,50*ScreenHeightFactor,self.frame.size.width,self.frame.size.height-50*ScreenHeightFactor)];
    //[pickerView setBackgroundColor:[UIColor grayColor]];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
     pickerView.showsSelectionIndicator = YES;
    [self addSubview:pickerView];
    [pickerView setBackgroundColor:[UIColor whiteColor]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
    {
        return pickerData.count;
    }
    else
    {
        return 1;
    }
    
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
    {
      return pickerData[row];
    }
//    else
//    {
//        if([type isEqualToString:@"Autolock"]){
//            return @"min(s)";
//        }
//    
//        else if ([type isEqualToString:@"Radius"])
//        {
//            return @"Km(s)";
//        }
//    }
    return nil;
}
//-(CGFloat )pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 90;
//}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if(component==0)
    {
        autoLockTime  = [pickerData objectAtIndex:row];
         tagValue=(int)row;
    }
    
}


#pragma mark toolBar Specific Functions
-(void)touchAtDoneButton:(CancelDoneToolBar *)cancelDoneToolBar
{
    if(self.pickerDelegate)
    {
        if([autoLockTime isEqualToString:@"0"])
        {
            autoLockTime=[pickerData objectAtIndex:[autoLockTime integerValue]];
           [self.pickerDelegate doneTouched:autoLockTime withTag:0];
        }
        else
        {
            [self.pickerDelegate doneTouched:autoLockTime withTag:tagValue];
        }
        
        self.textField.text  = autoLockTime;
        
        //[self removeFromSuperview];
    }
}
-(void)touchAtCancelButton:(CancelDoneToolBar *)cancelDoneToolBar
{
    if(self.pickerDelegate)
    {
        [self.pickerDelegate cancelTouched];
       // [self removeFromSuperview];
    }
}



@end
