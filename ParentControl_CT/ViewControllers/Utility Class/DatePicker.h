//
//  DatePicker.h
//  ParentControl_CT
//
//  Created by Yogesh on 10/01/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePicker : UIView
-(void)textField:(UITextField *)textField;
-(void)drawPicker;
-(NSDate *)date ;
-(NSString *)dateInFormat:(NSString *)format;
@end
