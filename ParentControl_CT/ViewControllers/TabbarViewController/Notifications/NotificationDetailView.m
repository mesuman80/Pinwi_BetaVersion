//
//  NotificationDetailView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 07/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "NotificationDetailView.h"
#import "Constant.h"
#import "PC_DataManager.h"

@implementation NotificationDetailView
{
    int yy;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawUI:(NSDictionary*)dict
{
   // self.dataDict=dict;
    [[PC_DataManager sharedManager]NotificationList];
   // NSString *str=[notificationListArray objectAtIndex:[[dict objectForKey:@"NotificationID"] intValue]];
     NSString *str=[notificationListArray objectAtIndex:1];
    
    // NSString *str=[NSString stringWithFormat:@"%@.png",[dict objectForKey:@"NotificationID"]];
    yy=10*ScreenHeightFactor;
    
    UIImageView *tickView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(str)]];
    [tickView setFrame:CGRectMake(cellPadding,yy,ScreenWidthFactor*40,ScreenWidthFactor*40)];
    tickView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:tickView];
    
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(tickView.frame.size.width+2*cellPadding,yy,self.frame.size.width-tickView.frame.size.width-2*cellPadding,ScreenHeightFactor*30)];
    labelTime.textColor=NotificationTimeColor;//[UIColor colorWithRed:216.0f/255 green:220.0f/255 blue:226.0f/255 alpha:1.0];
    [labelTime setFont:[UIFont systemFontOfSize:9.0*ScreenFactor]];
    str =[dict objectForKey:@"Time"];
    [labelTime setText:str];
    [labelTime sizeToFit];
    labelTime.center=CGPointMake(labelTime.center.x, tickView.center.y);
    [labelTime setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:labelTime];
    
    yy+=tickView.frame.size.height+2*ScreenHeightFactor;
    
    UITextView *textDesc=[[UITextView alloc]initWithFrame:CGRectMake(tickView.frame.size.width+2*cellPadding,yy,self.frame.size.width-tickView.frame.size.width-(tickView.frame.size.width+2*cellPadding),ScreenHeightFactor*200)];
    [textDesc setText:[dict objectForKey:@"Description"]];
    [textDesc setDelegate:nil];
    [textDesc setEditable:NO];
    [textDesc setSelectable:NO];
    [textDesc setTextColor:cellBlackColor_9];
    [textDesc setFont:[UIFont fontWithName:RobotoRegular size:10*ScreenFactor]];
    [textDesc setBackgroundColor:[UIColor clearColor]];
    textDesc.textAlignment=NSTextAlignmentLeft;
    [textDesc resignFirstResponder];
    [textDesc setEditable:NO];
    [self addSubview:textDesc];

}


@end
