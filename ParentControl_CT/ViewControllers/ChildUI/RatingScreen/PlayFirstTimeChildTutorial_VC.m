//
//  PlayFirstTimeChildTutorial_VC.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 06/11/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import "PlayFirstTimeChildTutorial_VC.h"
#import "Constant.h"
#import "PC_DataManager.h"
#import "TutorialPlayView.h"

@interface PlayFirstTimeChildTutorial_VC () <TutorialProtocol>

@end

@implementation PlayFirstTimeChildTutorial_VC

- (void)viewDidLoad {
    [super viewDidLoad];
     NSString *str=[NSString stringWithFormat:@"ChildTutorial4-%@",self.childObj.child_ID];
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:str]isEqualToString:@"1"])
    {
        TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
        tutorial.tutorialName=@"Child Tutorial";
        tutorial.loadIndexVal=childTutIndex;
        tutorial.isSoundPlaying=YES;
        tutorial.delegate=self;
        [self presentViewController:tutorial animated:YES completion:nil];
       // [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:str];
    }

    // Do any additional setup after loading the view.
}

-(void)SkipTouched
{
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.gotoClass isEqualToString:@"Rating"])
        {
            
        }
        else if([self.gotoClass isEqualToString:@"DashBoard"])
        {
            
        }

        NSLog(@"dismissed");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
