//
//  CuetomToolBar.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 11/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CustomToolBar.h"

@implementation CustomToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)addToolBar
{
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    cancelItem.tintColor=[UIColor lightGrayColor];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doDone)];
     doneItem.tintColor=[UIColor lightGrayColor];
    
    [self setItems:@[cancelItem,flex,doneItem]];
}
-(void)doDone
{
    [self resignFirstResponder1];
    if(self.customDelgate)
    {
        [self.customDelgate touchAtDoneButton:self];
    }
}
-(void)cancel
{
    self.textField.text = nil;
    [self resignFirstResponder1];
    if(self.customDelgate)
    {
        [self.customDelgate touchAtDoneButton:self];
    }
}
-(void)resignFirstResponder1
{
    if(self.textField)
    {
        [self.textField resignFirstResponder];
    }
}
@end
