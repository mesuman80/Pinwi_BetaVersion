//
//  ViewController.m
//  CircleAnim
//
//  Created by Suman Bhattacharyya on 19/04/15.
//  Copyright (c) 2015 Suman Bhattacharyya. All rights reserved.
//

#import "PinWiRotationViewController.h"
#import "PinwiWheel.h"
#import "ActivityElementList.h"
#import "ShowActivityLoadingView.h"
#import "CustomActivitiesViewController.h"

@interface PinWiRotationViewController ()


{
    // JUST COPY THESE 2 METHODS
    
    PinwiWheel * pinwiWheel;
    ActivityElementList *activityList;
    UIImageView *img;
    NSMutableArray *subjects;
    int subCounter, waitCnt;
    

    @private CGFloat imageAngle;
    @private OneFingerRotationGestureRecognizer *gestureRecognizer;
    
    GetSubjectActivities *getSubjectActivities;
    ShowActivityLoadingView *loaderView;
}

@end

@implementation PinWiRotationViewController
{
    
}
@synthesize child;


- (void)viewDidLoad {
    [super viewDidLoad];

    [[PC_DataManager sharedManager]getWidthHeight];
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    

    imageAngle = 0;
    self.view.backgroundColor=appBackgroundColor;
    
    [self childNameLabel];
    [self getSubjects];
    
  //  [self setupPinwheel];
    
    // Do any additional setup after loading the view, typically from a nib.
}


// JUST COPY THESE 2 METHODS

-(void)getSubjects
{
    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetSubjectActivities"];
    if(dict)
    {
        [self loadTableDataWith:dict];
    }else{
        
        getSubjectActivities=[[GetSubjectActivities alloc]init];
    
    [getSubjectActivities initService:@{
        
    }];
    
    [getSubjectActivities setDelegate:self];
    [self addLoaderView];
    }
}

-(void)childNameLabel
{
    
     self.title=@"Scheduler";
    UILabel *label=[[UILabel alloc]init];
    UILabel *label1=[[UILabel alloc]init];
    UILabel *label2=[[UILabel alloc]init];

    
    
    NSString *str=self.child.firstName;
    CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];

    label.font=[UIFont fontWithName:RobotoRegular size:13.0f];
    label.text=str;
    label.frame=CGRectMake(0,0,displayValueSize.width+30,displayValueSize.height+5);
    label.textAlignment=NSTextAlignmentCenter;
    label.center=CGPointMake(screenWidth/2, .06*screenHeight);
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=labelBgColor;
    label.layer.cornerRadius=10;
    label.clipsToBounds=YES;
    //[label sizeToFit];
    [self.view addSubview:label];
    
    label1.font=[UIFont fontWithName:RobotoLight size:13.0f];
    label1.text=@"Rotate the PinWi to select a Subject";
    label1.frame=CGRectMake(0,.16 *screenHeight,screenWidth,displayValueSize.height);
    label1.textAlignment=NSTextAlignmentCenter;
    //label.backgroundColor=activityHeading1Code;
    label1.textColor=activityHeading1FontCode;
    //[label1 sizeToFit];
    [self.view addSubview:label1];
    
    label2.font=[UIFont fontWithName:RobotoRegular size:20.0f];
    label2.text=@"   Subject Calender";
    label2.frame=CGRectMake(0,.09*screenHeight,screenWidth,displayValueSize.height+20);
  //  label2.textAlignment=NSTextAlignmentLeft;
    label2.backgroundColor=activityHeading1Code;
    label2.textColor=activityHeading1FontCode;
    //[label1 sizeToFit];
    [self.view addSubview:label2];

    
}

-(void)setupPinwheel
{
    pinwiWheel = [[PinwiWheel alloc]initWithFrame:CGRectMake(0, 0, screenWidth*.85, screenWidth*.85)andImage:[UIImage imageNamed:@"pinwi-logo.png"]];
    pinwiWheel.center= CGPointMake(screenWidth/2, screenHeight*.55);//*.8- pinwiWheel.frame.size.height/2);
    [self.view addSubview:pinwiWheel];
    pinwiWheel.userInteractionEnabled= YES;
    pinwiWheel.mainVc = self;
    
    // subjects = [[NSMutableArray alloc]initWithObjects:@"Maths", @"Physics",@"Science",@"Biology",@"Stat",@"Geo",@"Social Science",@"History", nil];
    
    activityList = [[ActivityElementList alloc]initWithFrame:CGRectMake(screenWidth*.1, 0, screenWidth*.9, screenHeight*.1)];
    activityList.center= CGPointMake(screenWidth/2, screenHeight*.25);
    NSString *sub=[subjects objectAtIndex:0];
    activityList.subjectName.text = sub;
    activityList.subjectTitle.text = [sub substringToIndex:1];
    [self.view addSubview:activityList];
    
   
    subCounter = 0;
    waitCnt = 0;
    
 
    imageAngle = 0;
    pinwiWheel.transform = CGAffineTransformIdentity;

    
    [self setupGestureRecognizer];
   // [self addCustomSubject];
    
}

-(void)addCustomSubject
{
    NSString *str=@"Can't find activity? Create custom";
    UIButton  *customButton=[UIButton buttonWithType:UIButtonTypeSystem];
    customButton.tintColor=activityHeading2FontCode;
    
    NSMutableAttributedString *yourString = [[NSMutableAttributedString alloc]initWithString:str];
    [yourString addAttribute:NSForegroundColorAttributeName value:radiobuttonSelectionColor range:NSMakeRange(21,13)];
//    [yourString addAttribute:(NSString*)kCTForegroundColorAttributeName
//                   value:(id)[radiobuttonSelectionColor CGColor]
//                   range:NSMakera];
    [customButton setAttributedTitle:yourString forState:UIControlStateNormal];
//    customButton.tintColor=radiobuttonSelectionColor;
    customButton.backgroundColor=[UIColor clearColor];
    [customButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    customButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.018*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [customButton sizeToFit];
    customButton.frame=CGRectMake(.2*screenWidth, .8*screenHeight, .73*screenWidth, .07*screenHeight);
    customButton.center=CGPointMake(screenWidth*.5,pinwiWheel.center.y+pinwiWheel.frame.size.height/2+.02*screenHeight);
    [customButton addTarget:self action:@selector(customBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customButton];
}

-(void)customBtnTouched
{
    CustomActivitiesViewController *custom=[[CustomActivitiesViewController alloc]init];
    custom.child=self.child;
    [self.navigationController pushViewController:custom animated:YES];
    
    
    
//    ActivitySubjectDetailCal *details=[[ActivitySubjectDetailCal alloc]init];
//    [self.navigationController pushViewController:details animated:YES];
}

///////////////////////////////////////

- (void) rotation: (CGFloat) angle
{
    NSLog(@"angle   %f", angle);
    
    if(angle>0)
    {
        [self updateElements];
    }
    else
    {
        [self reverseUpdateElements];
    }
    
    // calculate rotation angle
    imageAngle += angle;
    if (imageAngle > 360)
    {
        imageAngle -= 360;
    }
    else if (imageAngle < -360)
    {
        imageAngle += 360;
    }
    
    // rotate image and update text field
    pinwiWheel.transform = CGAffineTransformMakeRotation(imageAngle *  M_PI / 180);
    
    //[self updateElements];
    
}


- (void) reverseUpdateElements
{
    waitCnt--;
    if(waitCnt == -20 &&  subCounter>=0)
    {
        NSString *sub=[subjects objectAtIndex:subCounter];
        activityList.subjectName.text = sub;
        activityList.subjectTitle.text = [sub substringToIndex:1];
        waitCnt=0;
        
        subCounter--;
        if(subCounter <0){
            subCounter=(int)subjects.count-1;
        }
    }
    
    NSLog(@"WAIT    COUNTER     :   %i", waitCnt);
    NSLog(@"Subject COUNTER     :   %i", subCounter);
    NSLog(@"Subject LABEL       :   %@", activityList.subjectName.text);
}


- (void) updateElements
{
    waitCnt++;
    if(waitCnt == 20 &&  subCounter < subjects.count)
    {
        NSString *sub=[subjects objectAtIndex:subCounter];
        activityList.subjectName.text = sub;
        activityList.subjectTitle.text = [sub substringToIndex:1];
        waitCnt=0;
 
        subCounter++;
        if(subCounter >subjects.count-1){
            subCounter=0;
        }
        
    }
    
    NSLog(@"WAIT  Reverse  COUNTER      :   %i", waitCnt);
    NSLog(@"Subject COUNTER             :   %i", subCounter);
    NSLog(@"Subject LABEL               :   %@", activityList.subjectName.text);
}





/*
- (void) updateElements
{
    waitCnt++;
    if(waitCnt == subjects.count)
    {
        subCounter++;
        if(subCounter == subjects.count){
            subCounter=0;
        }
        NSString *sub=[subjects objectAtIndex:subCounter];
        activityList.subjectName.text = sub;
        activityList.subjectTitle.text = [sub substringToIndex:1];
        waitCnt=0;
        
        
        
    }
    
    NSLog(@"WAIT    COUNTER     :   %i", waitCnt);
    NSLog(@"Subject COUNTER     :   %i", subCounter);
    NSLog(@"Subject LABEL       :   %@", activityList.subjectName.text);
}

*/
- (void) setupGestureRecognizer
{
    // calculate center and radius of the control
    CGPoint midPoint = CGPointMake(pinwiWheel.frame.origin.x + pinwiWheel.frame.size.width / 2, pinwiWheel.frame.origin.y + pinwiWheel.frame.size.height / 2);
    CGFloat outRadius = 200;
    
    // outRadius / 3 is arbitrary, just choose something >> 0 to avoid strange
    // effects when touching the control near of it's center
    gestureRecognizer = [[OneFingerRotationGestureRecognizer alloc] initWithMidPoint: midPoint
                                                                         innerRadius: 10
                                                                         outerRadius: outRadius
                                                                              target: self];
    [pinwiWheel addGestureRecognizer: gestureRecognizer];
}

#pragma mark CONNECTION DELEGATES

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
    
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetSubjectActivitiesResponse" resultKey:@"GetSubjectActivitiesResult"];
    [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:@"GetSubjectActivities"];
    [self loadTableDataWith:dict];
    [self removeLoaderView];
    
}

-(void)loadTableDataWith:(NSDictionary*)dict{
   subjects = [[NSMutableArray alloc]init];
    for (NSDictionary *subDict in dict) {
        [subjects addObject:[subDict objectForKey:@"SubjectName"]];
    }
   [self setupPinwheel];
    
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    
    if(CGRectContainsPoint(activityList.frame, loc))
        {
            UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [[self navigationItem] setBackBarButtonItem:newBackButton];
            self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
            
            ActivitySubjectDetailCal *details=[[ActivitySubjectDetailCal alloc]init];
            details.child=self.child;
            details.subjectID=subCounter+1;
            details.subject=[subjects objectAtIndex:subCounter];
            
            [self.navigationController pushViewController:details animated:YES];
        }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ADD / REMOVE LOADER
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}

@end
