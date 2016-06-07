//
//  DatePicker.m
//  ParentControl_CT
//
//  Created by Yogesh on 10/01/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "DatePicker.h"
#import "PC_DataManager.h"


@implementation DatePicker {
    UIDatePicker *picker ;
    UITextField  *textField ;
    NSDateFormatter *formatter;
}

-(void)drawPicker {
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.tintColor=[UIColor darkGrayColor];
    cancelButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [cancelButton sizeToFit];
    cancelButton.frame=CGRectMake(0,0,self.frame.size.width*.3, self.frame.size.height*.1);
    [cancelButton addTarget:self action:@selector(datePickerCalHideCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.tintColor=[UIColor darkGrayColor];
    doneButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    doneButton.frame=CGRectMake(self.frame.size.width-cancelButton.frame.size.width,0,self.frame.size.width*.3, self.frame.size.height*.1);
    [doneButton addTarget:self action:@selector(datePickerCalHideDone) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear   :0];
    [comps setMonth  :0];
    [comps setDay    :0];
    
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
    
    [comps setYear  : 5];
    [comps setMonth : 0];
    [comps setDay   : 0];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
    
    
    picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(self.frame.origin.x, self.frame.size.height*.12, self.frame.size.width, self.frame.size.height);
    
    [picker setMaximumDate:maxDate];
    [picker setMinimumDate:minDate];
    [self addSubview:picker];
    

}
-(void)textField:(UITextField *)field {
    textField  = field;
}

-(NSString *)text {
    if(!formatter) {
        formatter = [[NSDateFormatter alloc]init];
       
    }
   [formatter setDateFormat:@"MMM d,y"];
    return [formatter stringFromDate:picker.date];
   
}


-(void)datePickerCalHideCancel {
    [textField resignFirstResponder];
}

-(void)datePickerCalHideDone {
    
    NSDate *currentDate = [NSDate date];
    if(!formatter) {
        formatter = [[NSDateFormatter alloc]init];
        
    }
    [formatter setDateFormat:@"MMM d,y"];
    
    if ([picker.date compare:currentDate] == NSOrderedAscending ) {
        picker.date = currentDate;
    }
 //   NSString *dateString = [formatter stringFromDate:picker.date];
    [textField setText:[self text]];
    [self datePickerCalHideCancel];
}

-(NSDate *)date {
   return  [picker date];
}

-(NSString *)dateInFormat:(NSString *)format {
    if(!formatter) {
        formatter = [[NSDateFormatter alloc]init];
        
    }
   [formatter setDateFormat:format];
    return [formatter stringFromDate:picker.date];
}

@end
