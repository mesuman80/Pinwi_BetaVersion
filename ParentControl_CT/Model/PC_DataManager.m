//
//  PC_DataManager.m
//  ParentControl_CT
//
//  Created by Priyanka on 2/23/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "PC_DataManager.h"
#import "ParentProfileEntity.h"
//#import "HeaderView.h"

@implementation PC_DataManager {
    
    ParentProfileEntity *parentEntityObj;
}


@synthesize parentObjectInstance;
@synthesize activities;
@synthesize calTableActivitybyDateArray;
@synthesize serviceDictionary;
@synthesize repeatDaysString;
@synthesize actRatingString;
@synthesize flatText;
@synthesize streettext;

static PC_DataManager *manager=nil;


+(instancetype)sharedManager
{
    if(!manager){
        manager = [[PC_DataManager alloc] init];
    }
    return manager;
}

-(id)init
{
    if (self=[super init])
    {
        [self initObjs];
        if(!activities)
        {
            repeatDaysString=@"";
            activities=[[NSMutableArray alloc]init];
            serviceDictionary=[[NSMutableDictionary alloc]init];
        }
    }
    return self;
}


-(void) initObjs{
    if(!parentObjectInstance)
    {
        parentObjectInstance = [[ParentProfileObject alloc]init];
        NSLog(@"parentObjectInstance  %@", parentObjectInstance);
    }
}

-(ParentProfileEntity *)getParentEntity
{
    NSArray *arr =[self getArrayFromEntity:PinWiParentProfileEntity];
     if(!arr || arr.count==0)
     {
         return nil;
     }
    
    parentEntityObj = [arr objectAtIndex:0];
    
    return parentEntityObj;
}
-(NSString *)convertDateInToString:(NSDate *)date withFormat:(NSString *)dateFormat
{
    NSDateFormatter *userFormatter = [[NSDateFormatter alloc] init];
    [userFormatter setDateFormat:dateFormat];
    [userFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateConverted = [userFormatter stringFromDate:date];
    return dateConverted;
}
-(NSDate *)convertStringIntoDate:(NSString *)dateString withFormat:(NSString *)dateFormat
{
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:dateFormat];
     NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

-(void)writeParentObjToDisk
{
    [self initObjs];
    BOOL isChildExisting=NO;
    BOOL isAllyExisting=NO;
    ChildProfileEntity *childEntity1=nil;
    NSMutableOrderedSet *childrenOrderSet;
    AllyProfileEntity *allyEntity1=nil;
    NSMutableOrderedSet *allyOrderSet;
    NSArray *arr =[self getArrayFromEntity:PinWiParentProfileEntity];
    ParentProfileEntity *parentEntity =nil;
    if(!arr || arr.count<1)
    {
        parentEntity =[NSEntityDescription insertNewObjectForEntityForName:PinWiParentProfileEntity inManagedObjectContext:[self getContext]];
    }
    else
    {
        parentEntity = [arr objectAtIndex:0];
    }
    parentEntity.firstName = parentObjectInstance.firstName;
    parentEntity.lastName       = parentObjectInstance.lastName;
    parentEntity.emailAdd       = parentObjectInstance.emailAdd;
    parentEntity.passwd         = parentObjectInstance.passwd;
    parentEntity.dob            = parentObjectInstance.dob;
    parentEntity.passcode       = parentObjectInstance.passcode;
    parentEntity.autoLockTime   = parentObjectInstance.autoLockTime;
    parentEntity.autolockID     = parentObjectInstance.autoLockID;
    parentEntity.flatNum        = parentObjectInstance.flatBuilding;
    parentEntity.streetLocality = parentObjectInstance.streetLocality;
    parentEntity.relation       = parentObjectInstance.relation;
    parentEntity.image          = parentObjectInstance.image;
    parentEntity.contactNo      = parentObjectInstance.contactNo;
    parentEntity.city           = parentObjectInstance.city;
    parentEntity.cityId         = parentObjectInstance.cityID;
    parentEntity.country        = parentObjectInstance.country;
    parentEntity.countryId      = parentObjectInstance.countryID;
    parentEntity.googleMapAdd   = parentObjectInstance.googleAddress;
    parentEntity.latitude       = parentObjectInstance.latitude;
    parentEntity.longitude      = parentObjectInstance.longitute;
    parentEntity.gender         = parentObjectInstance.gender;
    parentEntity.neighbourRad   = parentObjectInstance.neighourRad;
    parentEntity.neighbourID    = parentObjectInstance.neighourID;
    parentEntity.deviceId       = parentObjectInstance.deviceId;
    parentEntity.deviceToken    = parentObjectInstance.deviceToken;
    parentEntity.parentID       = parentObjectInstance.parentId;
    
    
   for( int i=0; i < parentObjectInstance.childrenProfiles.count; i++){
        
        ChildProfileObject *childObj =(ChildProfileObject*) [parentObjectInstance.childrenProfiles objectAtIndex:i];
        if([childObj isKindOfClass:[NSDictionary class]]) NSLog(@"nsDictionary class");
       
       NSLog(@"parentObjectInstance.name   %@", childObj.firstName);
           NSLog(@"parentObjectInstance.name   %@", childObj.lastName);
        childrenOrderSet =[[NSMutableOrderedSet alloc] initWithOrderedSet:parentEntity.childrenProfiles];
        for(ChildProfileEntity *childEntity in childrenOrderSet){
            if((childEntity.child_ID == childObj.child_ID))
            {
                isChildExisting=YES;
                childEntity1=childEntity;
                break;
            }
        }
        
        if(!isChildExisting){

            childEntity1 =[NSEntityDescription insertNewObjectForEntityForName:PinWiChildProfileEntity inManagedObjectContext:[self getContext]];
            [ childrenOrderSet addObject: childEntity1 ];
            parentEntity.childrenProfiles =childrenOrderSet;
            
        }

         NSLog(@"here it is   %@", childObj.firstName);
        NSLog(@"here it is   %@", childObj.lastName);

        childEntity1.child_ID       = childObj.child_ID;
        childEntity1.parent_ID      = childObj.parent_ID;
        childEntity1.firstName      = childObj.firstName;
        childEntity1.lastName       = childObj.lastName;
        childEntity1.nick_Name      = childObj.nick_Name;
        childEntity1.dob            = childObj.dob;
        childEntity1.gender         = childObj.gender;
        childEntity1.school_Name    = childObj.school_Name;
        childEntity1.school_ID      = childObj.school_ID;
        childEntity1.passcode       = childObj.passcode;
        childEntity1.autolock_Time  = childObj.autolock_Time;
        childEntity1.autolockID     = childObj.autolock_ID;
        childEntity1.profile_pic    = childObj.profile_pic;
        childEntity1.earnedPts      = childObj.earnedPts;
        childEntity1.pendingPts     = childObj.pendingPts;
        isChildExisting= NO;
        
    }
    
    
    for( int i=0; i < parentObjectInstance.allyProfiles.count; i++){
        
        AllyProfileObject *allyObj =(AllyProfileObject*) [parentObjectInstance.allyProfiles objectAtIndex:i];
        if([allyObj isKindOfClass:[NSDictionary class]]) NSLog(@"nsDictionary class");
        
        
        NSLog(@"parentObjectInstance.name   %@", allyObj.firstName);
        NSLog(@"parentObjectInstance.name   %@", allyObj.lastName);

        
        allyOrderSet =[[NSMutableOrderedSet alloc] initWithOrderedSet:parentEntity.allyProfiles];
        for(AllyProfileEntity *allyEntity in allyOrderSet){
            if(allyEntity.ally_ID == allyObj.ally_ID)
            {
                isAllyExisting=YES;
                allyEntity1=allyEntity;
                break;
            }
        }
        
        if(!isAllyExisting){
            
            allyEntity1 =[NSEntityDescription insertNewObjectForEntityForName:PinWiAllyProfileEntity inManagedObjectContext:[self getContext]];
            [allyOrderSet addObject: allyEntity1 ];
            parentEntity.allyProfiles =allyOrderSet;
            
        }

        allyEntity1.ally_ID         = allyObj.ally_ID;
        allyEntity1.parent_ID       = allyObj.parent_ID;
        allyEntity1.firstName       = allyObj.firstName;
        allyEntity1.lastName        = allyObj.lastName;
        allyEntity1.contact_no      = allyObj.contact_no;
        allyEntity1.relationship    = allyObj.relationship;
        allyEntity1.relationship_ID = allyObj.relationship_ID;
        allyEntity1.profilePic      = allyObj.profilePic;
        allyEntity1.emailAdd        = allyObj.emailAdd;
        
        isAllyExisting= NO;
        
    }

     NSLog(@"Parent Entity = %@",parentEntity);
     [self writeToDisk];
}

-(void)manageParentPersistentData
{
   // AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    

    
   
}



-(void)loadLiveDataFromCoreData{
    
    
    parentEntityObj = [self getParentEntity];
    
    if(parentEntityObj)
    {
       parentObjectInstance.deviceId        =[parentEntityObj deviceToken];
       parentObjectInstance.deviceToken     =[parentEntityObj deviceToken];
       parentObjectInstance.firstName       =[parentEntityObj firstName];
       parentObjectInstance.lastName        =[parentEntityObj lastName];
       parentObjectInstance.dob             =[parentEntityObj dob];
       parentObjectInstance.passwd          =[parentEntityObj passwd];
       parentObjectInstance.emailAdd        =[parentEntityObj emailAdd];
       parentObjectInstance.contactNo       =[parentEntityObj contactNo];
       parentObjectInstance.autoLockTime    =[parentEntityObj autoLockTime];
       parentObjectInstance.autoLockID      =[parentEntityObj autolockID];
       parentObjectInstance.passcode        =[parentEntityObj passcode];
       parentObjectInstance.relation        =[parentEntityObj relation];
       parentObjectInstance.gender          =[parentEntityObj gender];
       parentObjectInstance.flatBuilding    =[parentEntityObj flatNum];
       parentObjectInstance.streetLocality  =[parentEntityObj streetLocality];
       parentObjectInstance.city            =[parentEntityObj city];
       parentObjectInstance.country         =[parentEntityObj country];
       parentObjectInstance.latitude        =[parentEntityObj latitude];
       parentObjectInstance.longitute       =[parentEntityObj longitude];
       parentObjectInstance.googleAddress   =[parentEntityObj googleMapAdd];
       parentObjectInstance.neighourRad     =[parentEntityObj neighbourRad];
       parentObjectInstance.neighourID      =[parentEntityObj neighbourID];
       parentObjectInstance.cityID          =[parentEntityObj cityId];
       parentObjectInstance.countryID       =[parentEntityObj countryId];
       parentObjectInstance.parentId        =[parentEntityObj parentID];
       parentObjectInstance.image           =[parentEntityObj image];
       
  /*      for(ChildProfileEntity *childEntity in parentEntityObj.childrenProfiles){
            
            ChildProfileObject * childObj = [[ChildProfileObject alloc]init];
            childObj.child_ID       = childEntity.child_ID;
            childObj.parent_ID      = parentEntityObj.parentID;
            childObj.firstName      = childEntity.firstName;
            childObj.lastName        = childEntity.lastName;
            childObj.nick_Name      = childEntity.nick_Name;
            childObj.dob            = childEntity.dob;
            childObj.gender         = childEntity.gender;
            childObj.school_Name    = childEntity.school_Name;
            childObj.passcode       = childEntity.passcode;
            childObj.autolock_Time  = childEntity.autolock_Time;
            childObj.autolock_ID    = childEntity.autolockID;
            childObj.profile_pic    = childEntity.profile_pic;
            childObj.earnedPts      = childEntity.earnedPts;
            childObj.pendingPts     = childEntity.pendingPts;
            
            [parentObjectInstance.childrenProfiles addObject:childObj];
        }
        
        for(AllyProfileEntity *allyEntity in parentEntityObj.allyProfiles){
            
            AllyProfileObject * allyObj = [[AllyProfileObject alloc]init];
            allyObj.ally_ID         = allyEntity.ally_ID;
            allyObj.parent_ID       = allyEntity.parent_ID;
            allyObj.firstName       = allyEntity.firstName;
            allyObj.lastName        = allyEntity.lastName;
            allyObj.contact_no      = allyEntity.contact_no;
            allyObj.relationship    = allyEntity.relationship;
            allyObj.profilePic      = allyEntity.profilePic;
            allyObj.emailAdd        = allyEntity.emailAdd;
            
            [parentObjectInstance.allyProfiles addObject:allyObj];
        }*/
    }
}


-(void)manageChildPersistentData:(NSString*)childID
{
    BOOL isChildExisting=NO;
    
    ChildProfileEntity *childEntity1=nil;
    
    ParentProfileEntity *parentEntity = [[self getArrayFromEntity:PinWiParentProfileEntity] objectAtIndex:0];
    NSMutableOrderedSet *orderedSet = [[NSMutableOrderedSet alloc] initWithOrderedSet:parentEntity.childrenProfiles];
    if(parentEntity.childrenProfiles.count == orderedSet.count)
    {
        return;
    }

    for(ChildProfileEntity *child in parentEntity.childrenProfiles)
    {
        if((child.child_ID == childID))
        {
            isChildExisting=YES;
            childEntity1=child;
            break;
        }
    }
    
    if(!isChildExisting)
    {
            childEntity1 = [NSEntityDescription insertNewObjectForEntityForName:PinWiChildProfileEntity inManagedObjectContext:[self getContext]];
    }
        ChildProfileObject *childInstance = [parentObjectInstance.childrenProfiles lastObject];
        childEntity1.child_ID       =childInstance.child_ID;
        childEntity1.firstName      =childInstance.firstName;
        childEntity1.lastName       =childInstance.lastName;

        childEntity1.nick_Name      =childInstance.nick_Name;
        childEntity1.dob            =childInstance.dob;
        childEntity1.gender         =childInstance.gender;
        childEntity1.school_Name    =childInstance.school_Name;
        childEntity1.passcode       =childInstance.passcode;
        childEntity1.autolock_Time  =childInstance.autolock_Time;
        childEntity1.earnedPts      =childInstance.earnedPts;
        childEntity1.pendingPts     =childInstance.pendingPts;

        [orderedSet addObject:childEntity1];
    
    parentEntity.childrenProfiles = orderedSet;
    
    [self writeToDisk];
}

-(void)manageAllyPersistentData
{
    ParentProfileEntity *parentEntity = [[self getArrayFromEntity:PinWiParentProfileEntity] objectAtIndex:0];
    NSMutableOrderedSet *orderedSet = [[NSMutableOrderedSet alloc] initWithOrderedSet:parentEntity.childrenProfiles];
    if(parentEntity.childrenProfiles.count == orderedSet.count)
    {
        return;
    }
    
    AllyProfileObject *allyInstance = [parentObjectInstance.allyProfiles lastObject];
    AllyProfileEntity *allyEntity = [orderedSet lastObject];
    if(!(allyEntity.ally_ID == allyInstance.ally_ID))
    {
        AllyProfileEntity *allyEntity1 = [NSEntityDescription insertNewObjectForEntityForName:PinWiAllyProfileEntity inManagedObjectContext:[self getContext]];
        allyEntity1.ally_ID     =allyInstance.ally_ID;
        allyEntity1.firstName   =allyInstance.firstName;
        allyEntity1.lastName    =allyInstance.lastName;

        allyEntity1.relationship=allyInstance.relationship;
        allyEntity1.contact_no  =allyInstance.contact_no;
        allyEntity1.parent_ID   =allyInstance.parent_ID;
        
        [orderedSet addObject:allyEntity1];
    }
    parentEntity.allyProfiles = orderedSet;
    [self writeToDisk];
}

-(NSManagedObjectContext *)getContext
{
    AppDelegate *appDelegate = [self appDelegateInstance];
     NSLog(@"appDelegate.managedObjectContext =%@", appDelegate);
     NSLog(@"appDelegate.managedObjectContext =%@", appDelegate.managedObjectContext);
    return appDelegate.managedObjectContext;
}

-(AppDelegate *)appDelegateInstance
{
    return[UIApplication sharedApplication].delegate;
    
}

-(BOOL)retrieveDataAtLogin
{
    NSArray *arr1 =[self getArrayFromEntity:PinWiParentProfileEntity];
    for(ParentProfileEntity *parentEntity in arr1)
    {
        NSLog(@"loginEntity =%@",parentEntity.firstName);
        NSLog(@"loginEntity =%@",parentEntity.lastName);

        NSLog(@"%@",parentEntity.relation);
        NSLog(@"%@",parentEntity.childrenProfiles);
        NSLog(@"%@",parentEntity.allyProfiles);
        
        for(AllyProfileEntity *alli in parentEntity.allyProfiles)
        {
            NSLog(@"%@",alli);
        }
        
        return YES;
    }
    return NO;
}

-(NSArray*)getArrayFromEntity:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self getContext]];
    [fetchRequest setEntity:entity];
    //[fetchRequest set];
    NSError* error;
    NSArray *fetchedRecords = [[self getContext] executeFetchRequest:fetchRequest error:&error];
    if(error)
    {
        NSLog(@"error=%@",error.localizedDescription);
    }
    return fetchedRecords;
}

-(void)writeToDisk
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        
        NSError *error=nil;
        [[self getContext] setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        @try
        {
            if (![[self getContext] save:&error])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"!ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                NSLog(@"successful save:passenger=%@",error.debugDescription);
            }
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"exception=%@",exception);
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            NSLog(@"successful save");
        });
    });
    
}


-(void)getWidthHeight
{

    screenHeight=[ScreenInfo getScreenHeight];
    screenWidth=[ScreenInfo getScreenWidth];
}

-(BOOL)NSStringIsValidEmail:(NSString *)emailId
{
    BOOL stricterFilter = NO;
    
    
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    NSLog(@"email id = %@",emailId);
    NSLog(@"email test = %@",emailTest);
    
    return [emailTest evaluateWithObject:emailId];
}

-(BOOL)isIllegalCharacter:(NSString*)stringVal
{
    stringVal=[self trimWhiteSpaces:stringVal];
    
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_@."];
    s=[s invertedSet];
    
    NSRange r = [stringVal rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return NO;
    }
    return YES;
}

-(BOOL)islegalCharacterWithoutNumbers:(NSString*)stringVal
{
    stringVal=[self trimWhiteSpaces:stringVal];
    
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    s=[s invertedSet];
    
    NSRange r = [stringVal rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return NO;
    }
    return YES;
}

-(NSString*)trimWhiteSpaces:(NSString*)string
{
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return trimmedString;
}

-(UIView*)drawLineView_withXPos:(float)x andYPos:(float)y withScrnWid:(float)w withScrnHt:(float)h ofColor:(UIColor*)colour
{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, w,h)];
    lineView.center=CGPointMake(x, y);
    lineView.backgroundColor=colour;
    return lineView;//[scrollView addSubview:lineView];
}

#pragma mark IMAGE RESIZE

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size1
{
    CGFloat newSize=120*ScreenHeightFactor; //size = CGSizeMake(120*ScreenHeightFactor, 120*ScreenHeightFactor);
    
        CGAffineTransform scaleTransform;
        CGPoint origin;
        
        if (image.size.width > image.size.height)
        {
            CGFloat scaleRatio = newSize / image.size.height;
            scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
            
            origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
        }
        else
        {
            CGFloat scaleRatio = newSize / image.size.width;
            scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
            
            origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
        }
        
        CGSize size = CGSizeMake(newSize, newSize);
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        {
            UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        }
        else {
            UIGraphicsBeginImageContext(size);
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextConcatCTM(context, scaleTransform);
        
        [image drawAtPoint:origin];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    

//    if(image==nil)
//    {
//        image=[UIImage imageNamed:isiPhoneiPad(@"profile_header.png")];
//    }
    
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return destImage;
//}


#pragma mark Reset Colors for segment
-(void)resetSegmentColor:(UISegmentedControl*)sgmntCtrl withTintColor:(UIColor*)color
{
    for (int i=0; i<[sgmntCtrl.subviews count]; i++)
    {
        if ([[sgmntCtrl.subviews objectAtIndex:i]isSelected] )
        {
            //segmentedControl.tintColor = radiobuttonSelectionColor;
            [[sgmntCtrl.subviews objectAtIndex:i] setTintColor:color];
        }
        else
        {
            [[sgmntCtrl.subviews objectAtIndex:i] setTintColor:[UIColor clearColor]];
        }
    }
}

#pragma mark Uilabel as in welcome screen
//-(UILabel*)drawLabelWithText:(NSString*)title andColor:(UIColor*)color andFont:(UIFont*)font
//{
//    UILabel *label = [[UILabel alloc]init];
//    //[label setText:title];
//    [label setTextColor:color];
//    [label setFont:font];
//    [label setNumberOfLines:0];
//    // CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
//    label.text=title;
//    CGSize  size = {self.frame.size.width - 60, 10000.0};
//    CGRect frame = [label.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
//                                         attributes:@{NSFontAttributeName:label.font}
//                                            context:nil];
//    
//    [label setFrame:CGRectMake(10*ScreenFactor,yCord, frame.size.width, frame.size.height)];
//    // [label setFrame:CGRectMake(10*ScreenFactor,yCord, size.width, size.height)];
//    [self addSubview:label];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    
//    return label;
//}




#pragma mark return days
-(NSString*) daysFromDate:(NSDate *) startDate toDate:(NSDate *) endDate
{
    NSString *type =nil;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSCalendarUnit units=NSEraCalendarUnit | NSYearCalendarUnit |
    NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *comp1=[gregorian components:units fromDate:startDate];
    NSDateComponents *comp2=[gregorian components:units fromDate:endDate];
    [comp1 setHour:12];
    [comp2 setHour:12];
    NSDate *date1=[gregorian dateFromComponents: comp1];
    NSDate *date2=[gregorian dateFromComponents: comp2];
    
    NSInteger numberOfDays =[[gregorian components:NSWeekdayCalendarUnit fromDate:date1 toDate:date2 options:0] weekday];
    if(numberOfDays == 0)
    {
        type=[NSString stringWithFormat:@"%i",(int)comp2.weekday];
        //type = @"Today";
    }
//    else if(numberOfDays == 1)
//    {
//        type=[NSString stringWithFormat:@"%i,%i",(int)[comp1 weekday],(int)(comp2.weekday+)];
//        
//        //type = @"yesterday";
//    }
    else if (numberOfDays<6)
    {
        int i=0;
        int addDate=0;
        while (i<=numberOfDays) {
            
            addDate=(int)(comp1.weekday++);
            
            if(type.length>0)
            {
                if(addDate>6)
                {
                    addDate=addDate-7;
                }
                type=[type stringByAppendingString:[NSString stringWithFormat:@",%i",addDate]];
            }
            else
            {
                type=[NSString stringWithFormat:@"%i",addDate];
            }
            i++;
        }
        //type = @"WeekDays";
    }
    
    NSLog(@"type: %@",type);
    if(type ==nil)
    {
        type = @"0,1,2,3,4,5,6";
    }
    return type;
}

#pragma mark Get All days and months of current year
-(int)returnMonthVlaue
{
    NSDateFormatter *formatterMonth=[[NSDateFormatter alloc]init];
    [formatterMonth setDateFormat:@"MM"];
    
    NSString *month=[formatterMonth stringFromDate:[NSDate date]];
    
    return (12-[month intValue]);
}

-(int)returnDayValue
{
   // NSDate *today = [NSDate date]; //Get a date object for today's date
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:[NSDate date]];
    
    NSDateFormatter *formatterDay=[[NSDateFormatter alloc]init];
    [formatterDay setDateFormat:@"dd"];
    NSString *day=[formatterDay stringFromDate:[NSDate date]];
    return (days.length-[day intValue]);
}

#pragma mark Sort Arrays
-(NSMutableArray *)sortArrayWithArray:(NSMutableArray*)array withKey:(NSString*)keyString
{
   NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:keyString ascending:YES];
   NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
   NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortedArray mutableCopy];
}

#pragma mark Make Days
-(NSMutableArray*)makeDaysOneSubject:(NSMutableArray *)subjectArray
{
    NSMutableArray *completeArray=[[NSMutableArray alloc]init];
    for(NSDictionary *subject in subjectArray)
    {
        NSMutableArray * newArr= [[NSMutableArray alloc]init];
        NSString *str=[NSString stringWithFormat:@"%@",[subject objectForKey:@"dayid"]];
        // str=@"3,5,6";
        if(str){
            NSArray *days=[str componentsSeparatedByString:@","];
            
            NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:days];
            days = [orderedSet array];
            
            days = [days sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
            }];
            
            int cnt=0;
            for(NSString * str1 in days)
            {
                int val = [str1 intValue];
                val = val - cnt;
                //cnt=0;
                for(int i=1; i<val;i++){
                    [newArr addObject:@"0"];
                    cnt++;
                }
                [newArr addObject:@"1"];
                cnt++;
            }
            NSLog(@"newArr  %@", newArr);
            if(newArr.count<7){
                for(int val=(int)newArr.count; val<7; val++){
                    [newArr addObject:@"0"];
                }
            }
        }
//        [newArr addObject:[newArr lastObject]];
//        [newArr removeLastObject];
        [completeArray addObject:@{
                                           @"CellType"  : @"Activity",
                                           @"ActivityName" : [subject objectForKey:@"Name"],
                                           @"ActivityID": [subject objectForKey:@"ActivityID"],
                                           @"IsVerified" :[NSString stringWithFormat:@"%@",[subject objectForKey:@"IsVerified"]],
                                           @"repeat"    : newArr
                                           }];
        NSLog(@"complete activity dictionary for days:\n %@",completeArray);
        
    }
     return completeArray;
}



-(NSString*)encodeImage:(UIImage*)image
{
//    if(image==nil)
//    {
//        image=[UIImage imageNamed:isiPhoneiPad(@"profile_header.png")];
//
    
    
   NSString *str= [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return str;
}

-(UIImage*)decodeImage:(NSString*)string
{
//    if(string== nil){
//        return [UIImage imageNamed:isiPhoneiPad(@"profile_header.png")];
//    }
//    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
   
    UIImage *image=[UIImage imageWithData:data];
    return image;
}

-(UIImage*)getImageSize:(UIImage *)image1 isLandScape:(BOOL)isLandScape isImageContentMode:(BOOL)mode
{

    int large=0;
    int small=0;
    int difference;
     if(image1.size.width>image1.size.height)
     {
         large=image1.size.width;
         small=image1.size.height;
         difference=(large-small)/2;
     }
     else if(image1.size.width<image1.size.height)
     {
         small=image1.size.width;
         large=image1.size.height;
         difference=(large-small)/2;
     }
    
    
    
  //  CGSize *imageSize=CGSizeMake(image1.size.width/2, <#CGFloat height#>)
    
    
    
    return nil;
}



#pragma mark SAVE DATA
-(void)saveChildData:(NSMutableDictionary *)childDict
{
    ChildProfileEntity *childEntity=[NSEntityDescription insertNewObjectForEntityForName:PinWiChildProfileEntity inManagedObjectContext:[self getContext]];
}

#pragma mark SAVE ACTIVITY

-(void)saveAndUpdateActivityList:(NSDictionary*)activityDict isUpdate:(BOOL)isUpdate
{
    
}

#pragma mark  CALENDAR TABLE
-(NSMutableArray*)updateCalendarTableByDate:(NSDictionary*)resultDict ofType:(NSString*)type
{
    calTableActivitybyDateArray=[[NSMutableArray alloc]init];
    
    if([type isEqualToString:@"School"])
    {
        
//        [calTableActivitybyDateArray addObject:@{
//                                                 @"Type"      :@"Heading",
//                                                 @"Heading"   :@"School"
//                                                 }];
        
        for(NSDictionary *dict in resultDict)
        {
            NSMutableArray *newArr=[self makeArrayOfdaysFromseparateostring:(NSMutableDictionary*)dict];
            [calTableActivitybyDateArray addObject:@{
                                                     @"Type"         :@"School",
                                                     @"ActivityID"   :[dict objectForKey:@"ActivityID"],
                                                     @"Name"         :[dict objectForKey:@"Name"],
                                                     @"DayID"        :[dict objectForKey:@"DayID"],
                                                     @"IsVerified"   :[NSString stringWithFormat:@"%@",[dict objectForKey:@"IsVerified"]],
                                                     @"repeat"       :newArr
                                                     }];
        }
    }
    else if([type isEqualToString:@"AfterSchool"])
    {
//        [calTableActivitybyDateArray addObject:@{
//                                                 @"Type"      :@"Heading",
//                                                 @"Heading"   :@"After School"
//                                                 }];
        for(NSDictionary *dict in resultDict)
        {
            NSMutableArray *newArr=[self makeArrayOfdaysFromseparateostring:(NSMutableDictionary*)dict];
            [calTableActivitybyDateArray addObject:@{
                                                     @"Type"         :@"After School",
                                                     @"ActivityID"   :[dict objectForKey:@"ActivityID"],
                                                     @"Name"         :[dict objectForKey:@"Name"],
                                                     @"DayID"        :[dict objectForKey:@"DayID"],
                                                     @"StartTime"    :[dict objectForKey:@"StartTime"],
                                                     @"EndTime"      :[dict objectForKey:@"EndTime"],
                                                     @"IsVerified"   :[NSString stringWithFormat:@"%@",[dict objectForKey:@"IsVerified"]],
                                                     @"IsSpecial"   :[NSString stringWithFormat:@"%@",[dict objectForKey:@"IsSpecial"]],
                                                     @"IsPrivate"   :[NSString stringWithFormat:@"%@",[dict objectForKey:@"IsPrivate"]],
                                                     @"repeat"       :newArr
                                                     }];
        }
    }
    
    return calTableActivitybyDateArray;
}


-(NSMutableArray*)makeArrayOfdaysFromseparateostring:(NSMutableDictionary*)subject
{
    
        NSMutableArray * newArr= [[NSMutableArray alloc]init];
        NSString *str=[NSString stringWithFormat:@"%@",[subject objectForKey:@"DayID"]];
        // str=@"3,5,6";
        if(str)
        {
            NSArray *days=[str componentsSeparatedByString:@","];
            NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:days];
            days = [orderedSet array];
            
            days = [days sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
            }];
            
            int cnt=0;
            for(NSString * str1 in days)
            {
                int val = [str1 intValue];
                val = val - cnt;
                //cnt=0;
                for(int i=1; i<val;i++){
                    [newArr addObject:@"0"];
                    cnt++;
                }
                [newArr addObject:@"1"];
                cnt++;
            }
            NSLog(@"newArr  %@", newArr);
            if(newArr.count<7)
            {
                for(int val=(int)newArr.count; val<7; val++)
                {
                    [newArr addObject:@"0"];
                }
            }
        }
        return newArr;
}


//=========================================================================================================================
//=========================================================================================================================


#pragma mark ARRAY ELEMENTS
//=========================================================================================================================
-(void)signUpLabel
{
    [self getWidthHeight];
    
    labelSignUpArray=@[@"Map and Manage what Drives your Child's Interests.",@"Login in with",@"Sign up with"];
    labelSignUpPosPxArray = [[NSMutableArray alloc]initWithObjects:
                           [NSNumber numberWithFloat:0.05*screenWidth],
                             [NSNumber numberWithFloat:0.2*screenWidth],
                             [NSNumber numberWithFloat:0.2*screenWidth],nil];
    
    labelSignUpPosPyArray = [[NSMutableArray alloc]initWithObjects:
                           [NSNumber numberWithFloat:0.255*screenHeight],
                           [NSNumber numberWithFloat:0.81*screenHeight],
                             [NSNumber numberWithFloat:0.71*screenHeight],nil];
    
    signUpLabelSize = [[NSMutableArray alloc]initWithObjects:
                     [NSNumber numberWithFloat:.021*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                     [NSNumber numberWithFloat:.015*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                       [NSNumber numberWithFloat:.015*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],nil];
    
    
    
    signUpTextFieldsArray=@[@"Email",@"Password"];
    signUpTextFieldPosPXArray=[[NSMutableArray alloc]initWithObjects:
                               [NSNumber numberWithFloat:0.2*screenWidth],
                               [NSNumber numberWithFloat:0.2*screenWidth],nil];
    
    signUpTextFieldPosPYArray=[[NSMutableArray alloc]initWithObjects:
                               [NSNumber numberWithFloat:0.4*screenHeight],
                               [NSNumber numberWithFloat:0.47*screenHeight],nil];
    
    signUpTextFieldSizeArray=[[NSMutableArray alloc]initWithObjects:
                              [NSNumber numberWithFloat:.05*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                              [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],nil];
    
    
    
    
    signUpTextAttsArray=@[@"Forgot Password?",/* @"Sign In using Facebook/Google+",*/@"New here? Sign Up"];
    signUpTextAttsPosPXArray=[[NSMutableArray alloc]initWithObjects:
                              [NSNumber numberWithFloat:0.1*screenWidth],
                              //  [NSNumber numberWithFloat:0.07*screenWidth],
                              [NSNumber numberWithFloat:0.6*screenWidth],nil];
    
    signUpTextAttsPosPYArray=[[NSMutableArray alloc]initWithObjects:
                              [NSNumber numberWithFloat:0.83*screenHeight],
                              // [NSNumber numberWithFloat:0.75*screenHeight],
                              [NSNumber numberWithFloat:0.83*screenHeight],nil];
    
    signUpTextAttsSizeArray=[[NSMutableArray alloc]initWithObjects:
                             [NSNumber numberWithFloat:.018*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                             //    [NSNumber numberWithFloat:.03*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                             [NSNumber numberWithFloat:.018*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],nil];
    
}
-(void)checkBox
{
    
    checkboxPosPXArray= [[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:cellPaddingReg+.01*screenWidth],[NSNumber numberWithFloat:cellPaddingReg+.01*screenWidth],nil];
    checkboxPosPYArray=  [[NSMutableArray alloc]initWithObjects:
                             [NSNumber numberWithFloat:0.55*screenHeight], [NSNumber numberWithFloat:0.7*screenHeight],nil];
    

    
}

-(void)profileLabel
{
    labelProfileArray=@[@"Set Profile Pic"];
    
    labelProfilePosPxArray=[[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:0.15*screenWidth],nil];
    
    labelProfilePosPyArray=[[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:0.08*screenHeight],nil];
    
    profileLabelSize= [[NSMutableArray alloc]initWithObjects:
                       [NSNumber numberWithFloat:.020*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                       nil];
    
    profileTextFieldArray=@[@"First Name",@"Last Name",@"Email",@"Password",@"DOB",@"Phone",@"* * * *" ,@"AutoLock Time"];
    profileTextFieldPosPXArray=[[NSMutableArray alloc]initWithObjects:
                                [NSNumber numberWithFloat:cellPaddingReg],
                                [NSNumber numberWithFloat:0.5*screenWidth],
                                [NSNumber numberWithFloat:cellPaddingReg],
                                [NSNumber numberWithFloat:cellPaddingReg],
                                [NSNumber numberWithFloat:cellPaddingReg],
                                [NSNumber numberWithFloat:0.1*screenWidth+cellPaddingReg],
                                [NSNumber numberWithFloat:cellPaddingReg],
                                [NSNumber numberWithFloat:0.5*screenWidth],
                                 nil];
    
    profileTextFieldPosPYArray=[[NSMutableArray alloc]initWithObjects:
                                [NSNumber numberWithFloat:0.1*screenHeight],
                                [NSNumber numberWithFloat:0.1*screenHeight],
                                [NSNumber numberWithFloat:0.17*screenHeight],
                                [NSNumber numberWithFloat:0.24*screenHeight],
                                [NSNumber numberWithFloat:0.31*screenHeight],
                                [NSNumber numberWithFloat:0.47*screenHeight],
                                [NSNumber numberWithFloat:0.6*screenHeight],
                                [NSNumber numberWithFloat:0.6*screenHeight],nil];
    
    profileTextFieldSizeArray= [[NSMutableArray alloc]initWithObjects:
                                [NSNumber numberWithFloat:.02*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                                nil];
}



-(void) radioButton
{
    
    radioLabelArray=@[@"Female",@"Male",@" Boy",@" Girl",@" SMS",@"Email"];
    radioButtonPosPXArray= [[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:0.13*screenWidth],
                            [NSNumber numberWithFloat:0.47*screenWidth],
                            [NSNumber numberWithFloat:0.16*screenWidth],
                            [NSNumber numberWithFloat:0.47*screenWidth],
                            [NSNumber numberWithFloat:0.2*screenWidth],
                            [NSNumber numberWithFloat:0.5*screenWidth],
                            nil];
    radioButtonPosPYArray=  [[NSMutableArray alloc]initWithObjects:
                             [NSNumber numberWithFloat:0.65*screenHeight],
                             [NSNumber numberWithFloat:0.65*screenHeight],
                             [NSNumber numberWithFloat:0.35*screenHeight],
                             [NSNumber numberWithFloat:0.35*screenHeight],
                             [NSNumber numberWithFloat:0.5*screenHeight],
                             [NSNumber numberWithFloat:0.5*screenHeight],nil];
    
    labelRadioPosPXArray=  [[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:0.23*screenWidth],
                            [NSNumber numberWithFloat:0.57*screenWidth],
                            [NSNumber numberWithFloat:0.24*screenWidth],
                            [NSNumber numberWithFloat:0.55*screenWidth],
                            [NSNumber numberWithFloat:0.21*screenWidth],
                            [NSNumber numberWithFloat:0.53*screenWidth],nil];
    
    labelRadioPosPYArray=  [[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:0.66*screenHeight],
                            [NSNumber numberWithFloat:0.66*screenHeight],
                            [NSNumber numberWithFloat:0.36*screenHeight],
                            [NSNumber numberWithFloat:0.36*screenHeight],
                            [NSNumber numberWithFloat:0.35*screenHeight],
                            [NSNumber numberWithFloat:0.35*screenHeight],nil];
    
    
    radioLabelSize= [[NSMutableArray alloc]initWithObjects:
                     [NSNumber numberWithFloat:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                     [NSNumber numberWithFloat:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                     [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                     [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                     [NSNumber numberWithFloat:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                     [NSNumber numberWithFloat:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                     nil];
    
}

-(void)profileSetUp2
{
    profileSetUp2Array=@[@"Country",@"City",@"Street/Locality",@"Flat no/Building",@"Select Neighbourhood",@" Search your Location",@"Neighbourhood Radius (in Kms)"];
    profileSetUpPosPXArray=[[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:.5*screenWidth-cellPaddingReg],
                            [NSNumber numberWithFloat:.5*screenWidth-cellPaddingReg],
                            [NSNumber numberWithFloat:.5*screenWidth-cellPaddingReg],
                            [NSNumber numberWithFloat:.5*screenWidth-cellPaddingReg],
                            [NSNumber numberWithFloat:.5*screenWidth-cellPaddingReg],
                            [NSNumber numberWithFloat:.5*screenWidth-cellPaddingReg],
                            [NSNumber numberWithFloat:cellPaddingReg],nil];
    
    profileSetUpPosPYArray=[[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:0.03*screenHeight],
                            [NSNumber numberWithFloat:0.1*screenHeight],
                            [NSNumber numberWithFloat:0.17*screenHeight],
                            [NSNumber numberWithFloat:0.24*screenHeight],
                            [NSNumber numberWithFloat:0.4*screenHeight],
                            [NSNumber numberWithFloat:0.44*screenHeight],
                            [NSNumber numberWithFloat:0.87*screenHeight],nil];
    
    profileSetUpSizeArray=[[NSMutableArray alloc]initWithObjects:
                           [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                           [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                           [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                           [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                           [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],nil];
}
-(void)childProfile

{
    childprofileSetUpArray=@[@"First Name",@" Last Name",@"Nickname",@"DOB",@"Name of School",@"* * * *",@"Auto Lock Time",@"Add Another Child Profile"];
    childprofileSetUpPosPXArray=[[NSMutableArray alloc]initWithObjects:
                           [NSNumber numberWithFloat:cellPaddingReg],
                           [NSNumber numberWithFloat:0.5*screenWidth],
                                 [NSNumber numberWithFloat:cellPaddingReg],
                            [NSNumber numberWithFloat:cellPaddingReg],
                            [NSNumber numberWithFloat:cellPaddingReg],
                            [NSNumber numberWithFloat:cellPaddingReg],
                            [NSNumber numberWithFloat:0.5*screenWidth],
                            [NSNumber numberWithFloat:screenWidth*.1+cellPaddingReg],
                            nil];
    
    childprofileSetUpPosPYArray=[[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:0.19*screenHeight],
                            [NSNumber numberWithFloat:0.19*screenHeight],
                            [NSNumber numberWithFloat:0.12*screenHeight],
                            [NSNumber numberWithFloat:0.26*screenHeight],
                            [NSNumber numberWithFloat:0.45*screenHeight],
                            [NSNumber numberWithFloat:0.58*screenHeight],
                            [NSNumber numberWithFloat:0.58*screenHeight],
                            [NSNumber numberWithFloat:0.66*screenHeight],nil];
    
    childprofileSetUpSizeArray=[[NSMutableArray alloc]initWithObjects:
                                [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                                [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                                [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                                [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                                [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                                [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                                [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                                [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],nil];
    
}
-(void)AllyProfile
{
    allyProfileArray=@[@"First Name",@"Last Name",@"Type of Ally",@"Email",@"Phone",@"Add Another Ally"];
    allyProfilePosPXArray=[[NSMutableArray alloc]initWithObjects:
                            //text field- name
                            [NSNumber numberWithFloat:cellPaddingReg],
                            [NSNumber numberWithFloat:0.5*screenWidth],//text field- relation
                            [NSNumber numberWithFloat:cellPaddingReg],//text field- email
                            [NSNumber numberWithFloat:cellPaddingReg],//text field- phone num
                            [NSNumber numberWithFloat:cellPaddingReg],
                            [NSNumber numberWithFloat:0.1*screenWidth+cellPaddingReg],nil];//add another ally label
    
    allyProfilePosPYArray=[[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:0.12*screenHeight],
                           [NSNumber numberWithFloat:0.12*screenHeight],
                           [NSNumber numberWithFloat:0.19*screenHeight],
                            [NSNumber numberWithFloat:0.26*screenHeight],
                            [NSNumber numberWithFloat:0.33*screenHeight],
                            [NSNumber numberWithFloat: 0.405*screenHeight],nil];
    
    allyProfileSizeArray=[[NSMutableArray alloc]initWithObjects:
                          [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                            [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                           [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                           [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                           [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                           [NSNumber numberWithFloat:.02*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],nil];
}


-(void)confirmProfile
{
confirmationprofileArray=@[@"You are almost done. For security reasons we would like you to confirm your details.\nWe are currently geared up to send the verification code in your mailbox. Tap send to receive an email with the code.",@"Receive Confirmation Through: ",@"Enter Code",@"I agree with Terms & conditions"];
    
    confirmProfilePosPXArray=[[NSMutableArray alloc]initWithObjects:
                              [NSNumber numberWithFloat:cellPaddingReg],
                              [NSNumber numberWithFloat:cellPaddingReg],
                              [NSNumber numberWithFloat:cellPaddingReg],
                              [NSNumber numberWithFloat:0.1*screenWidth+cellPaddingReg],nil];
    
    confirmProfilePosPYArray=[[NSMutableArray alloc]initWithObjects:
                              [NSNumber numberWithFloat:0.015*screenHeight],
                              [NSNumber numberWithFloat:0.285*screenHeight],
                              [NSNumber numberWithFloat:0.545*screenHeight],
                              [NSNumber numberWithFloat:0.635*screenHeight],nil];
    
    confirmProfileSizeArray=[[NSMutableArray alloc]initWithObjects:
                             [NSNumber numberWithFloat:.020*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                             [NSNumber numberWithFloat:.020*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                             [NSNumber numberWithFloat:.015*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                             [NSNumber numberWithFloat:.020*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],nil];


      
}
-(void)welcomeScreen
{
    welcomeScreenArray=@[@"Welcome",@"The ultimate app to help you map what drives your child's interest while managing their life better on-the-go. It’s easy, intuitive and insightful. You can stay now up-to-date with your child's ever evolving interests with our Interest Mapping Reports and ensure you make smarter more interest focused choices."];
   
    welcomecreenPosPXArray=[[NSMutableArray alloc]initWithObjects:
                            [NSNumber numberWithFloat:0.37*screenWidth],
                            [NSNumber numberWithFloat:0.07
                             *screenWidth],nil];
    
    welcomeScreenPosPYArray=[[NSMutableArray alloc]initWithObjects:
                              [NSNumber numberWithFloat:0.18
                               *screenHeight],[NSNumber numberWithFloat:0.5*screenHeight],nil];
   
    welcomeScreenSizeArray=[[NSMutableArray alloc]initWithObjects:
                             [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],[NSNumber numberWithFloat:.019*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],nil];
}

-(void)viewProfile
{
    viewProfileArray=@[@"whattodo.png",@"insight.png",@"network.png",@"notification.png",@"activity.png"];
    
    viewProfileLabelArray=@[@"What-to-do",@"Insights",@"Network",@"Notifications",@"Scheduler"];
}

-(void) activityCalendar
{
    activityCalendarLabelArray=@[@"Scheduler", @"Name"];
    activityCalendarPosPXArray=[[NSMutableArray alloc]initWithObjects:
                                 [NSNumber numberWithFloat:0.42*screenWidth],
                                 [NSNumber numberWithFloat:0.44*screenWidth],
                                  nil];
    
    activityCalendarPosPYArray=[[NSMutableArray alloc]initWithObjects:
                                 [NSNumber numberWithFloat:0.03*screenHeight],
                                 [NSNumber numberWithFloat:0.13*screenHeight],nil];
    
    activityCalendarSizeArray=[[NSMutableArray alloc]initWithObjects:
                                [NSNumber numberWithFloat:.03*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],
                                [NSNumber numberWithFloat:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))],nil];
    
}




-(void)childdashBoard
{
 childRatingArray=@[@"rating-1.png",@"rating-2.png",@"rating-3.png",@"rating-4.png",@"rating-5.png",@"rating-6.png",@"rating-7.png",@"rating-8.png",@"rating-9.png",@"rating-10.png"];
    
    childRatingSelArray=@[@"rating-Selected-1.png",@"rating-Selected-2.png",@"rating-Selected-3.png",@"rating-Selected-4.png",@"rating-Selected-5.png",@"rating-Selected-6.png",@"rating-Selected-7.png",@"rating-Selected-8.png",@"rating-Selected-9.png",@"rating-Selected-10.png"];
    
    childDashBoardArray=@[@"child-notification.png",@"child-wall.png",@"child-buddies.png",@"child-whats-new.png",@"child-activity.png",@"child-what-to-do.png"];
    
    childDashBoardPosArray = [[NSMutableArray alloc]initWithObjects:
                              [NSValue valueWithCGPoint:CGPointMake(screenWidth*.25, screenHeight*.35)],
                              [NSValue valueWithCGPoint:CGPointMake(screenWidth*.75, screenHeight*.35)],
                              [NSValue valueWithCGPoint:CGPointMake(screenWidth*.25, screenHeight*.55)],
                              [NSValue valueWithCGPoint:CGPointMake(screenWidth*.75, screenHeight*.55)],
                              [NSValue valueWithCGPoint:CGPointMake(screenWidth*.25, screenHeight*.75)],
                              [NSValue valueWithCGPoint:CGPointMake(screenWidth*.75, screenHeight*.75)],
                              nil];
}

-(void)MenuList
{
    menuListArray=@[@"About Us",/*@"FAQs",*/@"Tutorial",/*@"Invite Friend",*/@"Contact Us",@"Settings",/*@"Add On App",*/@"Logout"];
    
    menuListNameArray=@[@"AboutUs",/*@"Support",*/@"Tutorial",/*@"InviteFriend",*/@"ContactUs",@"Settings"/*,@"addOn"*/,@"Logout"];

}
-(void)InsightsArrays
{
    qualityBadgeArray         =@[
                               @"The Only Way is Up!",
                               @"Steady as you go!",
                               @"Half Way There!",
                               @"The Last Mile!",
                               @"Isn't this Awesome!!"
                               ];
    
   /* qualityBadgeArray       =@[
                               @"Based on the consistency and quality of rating data, this report is currently at Level 1. Level 5 reports are most realistic and reliable.",
                               @"Based on the consistency and quality of rating data, this report is currently at Level 2. Level 5 reports are most realistic and reliable.",
                               @"Based on the consistency and quality of rating data, this report is currently at Level 3. Level 5 reports are the most realistic and reliable",
                               @"Based on the consistency and frequency of rating data, this report is currently at Level 4. Level 5 reports are the most realistic and reliable.",
                               @"Based on the consistency and quality of rating data, this report is now at Level 5. It doesn’t get any better than this."];
    */
    
    interestDriversArray    =@[
                               @"Exhilarators are key Interest Drivers common across activities that make your child most happy. These are the primary building blocks of activities your child consistently rates higher on the scale.",
                               @"Amusers are key Interest Drivers common across activities that keep your child amused and occupied. These are the primary building blocks of activities your child consistently rates medium on the scale. ",
                               @"Unexciting are key Interest Drivers common across activities that are not in your child's good books. These are the primary building blocks of activities your child consistently rates lower on the scale.",
                               @"Non-influencers are Interest Drivers that are essential but not influential in defining your child's interests. These are secondary building blocks recurring across all the activities that your child does.",
                               @"Unexplored are Interest Drivers or building blocks present in categories of activities your child has never been exposed to."];
    
    interestPatternArray    =@[];
    
    delightsTrendsArray     =@[];
    
    insightsInfoArray1       =@[@"Insights are driven by the data received from you and your children.",
                                @"Data Quality Badge is a ranking that indicates the quality of the data based on consistency and frequency of the activity rating data received from children.",
                                @"The higher the data quality badge, the more realistic and reliable the Insights will be.",
                                @"Add more activities and Encourage your children to rate regularly to improve the report rank."];
    
    insightsInfoArray2       =@[@"Interest Drivers are the factors that stimulate children when they do various activities.",
                                @"Children are stimulated (or not) by these factors across different levels of delight.",
                                @"In this section of Insights, you can view Interest Drivers that exhilarate your child, those that amuse them and those they find unexciting.",
                                @"You can also view Interest Drivers that are non-influencing or those your child has never explored."];
    
    insightsInfoArray3       =@[@"Delight Trends reflect a list of top 10 activities based on their activity rating over a period of 30 days.",
                                @"Know how consistently (or not) this activity makes your child happy."];
    
    insightsInfoArray4       =@[@"Children earn PiNWi points everyday when they rate activities",
                                @"Points are awarded to keep children interested in the rating process.",
                                @"These points can be used in future to get gifts and games.",
                                @"To encourage authenticity of rating data, we encourage rating everyday.",
                                @"However, rating can be done for up to 7 days in the past.",
                                @"Points will be lost for days the activities were not rated."];
    
    insightsInfoArray=@[insightsInfoArray1,insightsInfoArray2,insightsInfoArray3,insightsInfoArray4];
    
}
-(void)TutorialImages
{
        tutorialListArrayComplete=[[NSMutableArray alloc]init];
    
        tutorialNameListArray=@[@"How PiNWi Works",@"How To Use The Scheduler",@"Add A New School Activity",@"Add A New After School Activity",@"How To Read Insights?",@"How do children rate activities?"];
    
        tutorialTextOpeningArray=@[@"No Activities to Rate!!",@"Great Job Rating Activities!!",@"Rate Activities for Today",@"No Activities to Rate!!",@"Great Job Rating Activities!!",@"Rate Activities for Yesterday"];
    
        tutorialChildSoundsOpening=@[@"VO_Status0_3",@"VO_Status1_4",@"VO_Status2",@"VO_Status0_3",@"VO_Status1_4",@"VO_Status5"];
    
        tutorialChildSounds=@[@"VO1_1",@"VO1_2",@"VO1_3",@"VO1_4",@"VO1_5",@"VO1_6",@"VO1_7",@"VO1_8",@"VO8"];
    
        tutorialPinwiWorksArray=@[@"tutWorks1.png",@"tutWorks2.png",@"tutWorks3.png",@"tutWorks4.png"];

    tutorialSchoolListArray=@[@"tutAtSchool1.png",@"tutAtSchool2.png",@"tutAtSchool3.png",@"tutAtSchool4.png",@"tutAtSchool5.png",@"tutAtSchool6.png",];
    
    tutorialAfterSchoolListArray=@[@"tutAfterSchool1.png",@"tutAfterSchool2.png",@"tutAfterSchool3.png",@"tutAfterSchool4.png",@"tutAfterSchool5.png",@"tutAfterSchool6.png",@"tutAfterSchool7.png"];
    
    tutorialSchedularListArray=@[@"tutScheduler1.png",@"tutScheduler2.png",@"tutScheduler3.png",@"tutScheduler4.png",@"tutScheduler5.png",@"tutScheduler6.png",@"tutScheduler7.png",@"tutScheduler8.png"];
    
    tutorialInsightsListArray=@[@"tutInsights1.png",@"tutInsights2.png",@"tutInsights3.png",@"tutInsights4.png",@"tutInsights5.png",@"tutInsights6.png"];
    
    tutorialChildListArray=@[@"slide1.png",@"slide2.png",@"slide3.png",@"slide4.png",@"slide5.png",@"slide6.png",@"slide7.png",@"slide8.png"];
   
        tutorialChildList2Array=@[@"tutBg.png",];
    
    
    
    [tutorialListArrayComplete addObject:tutorialPinwiWorksArray];
    [tutorialListArrayComplete addObject:tutorialSchedularListArray];
    [tutorialListArrayComplete addObject:tutorialSchoolListArray];
    [tutorialListArrayComplete addObject:tutorialAfterSchoolListArray];
    [tutorialListArrayComplete addObject:tutorialInsightsListArray];
    [tutorialListArrayComplete addObject:tutorialChildListArray];
}

-(void)InviteList
{
    inviteListArray=@[@"Email",@"SMS",@"WhatsApp"/*,@"Facebook",@"Google+"*/];
}

-(void)RatingList
{
    ratingListArray=@[@"rating-1.png",@"rating-2.png",@"rating-3.png",@"rating-4.png",@"rating-5.png"];
}

-(void)NotificationList
{
    notificationListArray=@[@"notificationInsights.png",@"notificationProfile.png",@"notificationScheduler.png",@"notificationSettings.png"];
}

-(void)addBorderToView:(UIView *)view BorderWidth:(float)borderWidth Radius:(float)radius Color:(UIColor *)color
{
    [view.layer setBorderColor:[color CGColor]];
    [view.layer setBorderWidth:borderWidth];
    view.layer.cornerRadius =radius;
    view.clipsToBounds = YES;
}

-(NSString *)getDateStringFromString:(NSString *)dateStr format:(NSString *)format {
    NSDate *date  = [self convertStringIntoDate:dateStr withFormat:format];
    NSString *dateString = [self convertDateInToString:date withFormat:@"MMM d,y"];
    return dateString;
}
@end
