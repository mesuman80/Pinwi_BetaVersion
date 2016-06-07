//
//  LogoutView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 12/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "LogoutView.h"

@implementation LogoutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame])
    {
        [self drawLogoutView];
        return self;
    }
    return nil;
}

-(void)drawLogoutView
{
    UIActionSheet *logoutAction = [[UIActionSheet alloc] initWithTitle:@"Featured!" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:@"Main Menu" otherButtonTitles:@"Logout", nil];
    logoutAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [logoutAction showInView:self];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex)
    {
     case 0:
            
            [self.logoutDelegate mainMenuClicked];
     break;
     case 1:
            [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isLoggedOut"];
            exit(1);
     break;
     case 2:
            //[self.logoutDelegate cancelClicked];
     break;
    
     }
}

@end
