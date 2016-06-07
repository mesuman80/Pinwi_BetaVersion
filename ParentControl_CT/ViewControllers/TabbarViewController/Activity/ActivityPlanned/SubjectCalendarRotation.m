//
//  SubjectCalendarRotation.m
//  ParentControl_CT
//
//  Created by Priyanka on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "SubjectCalendarRotation.h"
#import "ActivityElementList.h"
#import "PinwiWheel.h"


@interface SubjectCalendarRotation ()

{   PinwiWheel * pinwiWheel;
    ActivityElementList *activityList;
    UIImageView *img;
    NSMutableArray *subjects;
    int subCounter, waitCnt;
    UIScrollView *scrollView;

    
}

@end

@implementation SubjectCalendarRotation
@synthesize index;

- (void)viewDidLoad {
    [super viewDidLoad];
  self.index=1;
    
    [[PC_DataManager sharedManager] getWidthHeight];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = appBackgroundColor;
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    
    scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight*.05);
    
    [self.view addSubview:scrollView];

    [self addContinueButton];
    [self setupPinwheel];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addContinueButton
{
    
        
  UIButton  *continueButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    continueButton.tintColor=[UIColor blackColor];
    continueButton.backgroundColor=buttonGreenColor;
    [continueButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    continueButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.018*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [continueButton sizeToFit];
    continueButton.frame=CGRectMake(.2*screenWidth, .8*screenHeight, .73*screenWidth, .07*screenHeight);
    continueButton.center=CGPointMake(screenWidth*.5,screenHeight*.75);
    [continueButton addTarget:self action:@selector(continueBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueButton];
}
-(void)continueBtnTouched
{
    
        ActivityDetails *details=[[ActivityDetails alloc]init];
    

    
        [self.navigationController pushViewController:details animated:YES];

    
}

-(void)setupPinwheel
{
    
    
    pinwiWheel = [[PinwiWheel alloc]initWithFrame:CGRectMake(0, 0, 270, 270)];
    pinwiWheel.center= CGPointMake(screenWidth/2, screenHeight-pinwiWheel.image.size.height);
    [self.view addSubview:pinwiWheel];
    pinwiWheel.userInteractionEnabled= YES;
   // pinwiWheel.subjectRotation = self;
    
    activityList = [[ActivityElementList alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    activityList.center= CGPointMake(160, 100);
    [self.view addSubview:activityList];
    
    subjects = [[NSMutableArray alloc]initWithObjects:@"Maths", @"Physics",@"Science",@"Biology",@"Stat",@"Geo",@"Social Science",@"History", nil];
    subCounter = 0;
    waitCnt = 0;
    
    
}


-(void)onValueChange:(float)value{
    NSLog(@"value  %f", value);
    
    waitCnt++;
    
    if(waitCnt == 8)
    {
        
        NSString *sub=[subjects objectAtIndex:subCounter];
        activityList.subjectName.text = sub;
        activityList.subjectTitle.text = [sub substringToIndex:1];
        waitCnt=0;
        
        subCounter++;
        if(subCounter == subjects.count){
            subCounter=0;
        }
    }
    
    
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
