//
//  NotificationViewItem.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 25/09/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import "NotificationViewItem.h"
#import "Constant.h"
#import "PC_DataManager.h"

@implementation NotificationViewItem
{
    int yy;
    UILabel *label;
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
    self.dataDict=dict;
    [[PC_DataManager sharedManager]NotificationList];
    NSString *str;
    
 
    NSInteger num = [[dict valueForKey:@"Status"] integerValue];

    
    if (num == 0) {
        str=[NSString stringWithFormat:@"notificationScheduler-568h@2x.png"];
    }
    else if (num == 1) {
        str=[NSString stringWithFormat:@"notificationProfile-568h@2x.png"];
    }
    else if (num == 2) {
        str=[NSString stringWithFormat:@"notificationSettings-568h@2x.png"];
    }
    else if (num == 3) {
        str=[NSString stringWithFormat:@"notificationInsights-568h@2x.png"];
    }
    
    yy=10*ScreenHeightFactor;
    
    UIImageView *tickView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:str]];
    [tickView setFrame:CGRectMake(cellPadding,yy,ScreenWidthFactor*25,ScreenWidthFactor*25)];
    tickView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:tickView];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(tickView.frame.size.width+2*cellPadding,yy, self.frame.size.width-tickView.frame.size.width-2*cellPadding -5,ScreenHeightFactor*40)];
    label.textColor=cellBlackColor_6;
    [label setFont:[UIFont systemFontOfSize:9.0*ScreenFactor]];
    str =[dict objectForKey:@"Description"];
    [label setText:str];
    label.numberOfLines = 2;
    //label.lineBreakMode = NSLineBreakByWordWrapping;
    //[label sizeToFit];
    label.center=CGPointMake(label.center.x, label.center.y);
    [label setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:label];
    
    yy+=tickView.frame.size.height+10*ScreenHeightFactor;
    
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(tickView.frame.size.width+2*cellPadding,yy,self.frame.size.width-tickView.frame.size.width-2*cellPadding,ScreenHeightFactor*30)];
    labelTime.textColor=NotificationTimeColor;
    [labelTime setFont:[UIFont systemFontOfSize:8.0*ScreenFactor]];
    str =[dict objectForKey:@"Time"];
    [labelTime setText:str];
    [labelTime sizeToFit];
    labelTime.center=CGPointMake(labelTime.center.x,self.frame.size.height- labelTime.frame.size.height/2-7*ScreenHeightFactor);
    [labelTime setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:labelTime];
    
    
    
    NSString *notiStatus=[NSString stringWithFormat:@"Notification-%@-%@",self.childObject.child_ID,[dict objectForKey:@"NotificationID"]];
   //  [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:notiStatus];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:notiStatus]isEqualToString:@"1"])
    {
        self.backgroundColor=[UIColor clearColor];//ReadNotification;
        label.textColor=activityHeading1FontCode;
    }
    else{
        self.backgroundColor=unReadNotification;
        label.textColor=textBlueColor;
        
    }

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notiTouch)];
    [self addGestureRecognizer:tapGesture];
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1*ScreenHeightFactor, self.frame.size.width, 1*ScreenHeightFactor)];
    [lineView setBackgroundColor:cellBlackColor_2];
    [self addSubview:lineView];
}

-(void)notiTouch
{
    if(self.notificationDelegate)
    {
        [self setAlpha:0.1f];
        [self performSelector:@selector(callDelegate) withObject:nil afterDelay:0.1];
    }
}

-(void)callDelegate
{
    [self setAlpha:1.0];
    self.backgroundColor=ReadNotification;
    label.textColor=activityHeading1FontCode;
    NSString *notiStatus=[NSString stringWithFormat:@"Notification-%@-%@",self.childObject.child_ID,[self.dataDict objectForKey:@"NotificationID"]];
    [self.notificationDelegate notificationTouch:self];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:notiStatus];
}


@end
