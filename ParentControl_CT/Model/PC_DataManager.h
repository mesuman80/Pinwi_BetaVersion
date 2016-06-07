//
//  PC_DataManager.h
//  ParentControl_CT
//
//  Created by Priyanka on 2/23/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#define buttonGreenColor [UIColor colorWithRed:172.0f/255 green:193.0f/255 blue:55.0f/255 alpha:1.0f]
//#define textBlueColor [UIColor colorWithRed:28.0f/255 green:62.0f/255 blue:116.0f/255 alpha:1.0]
#define textBgColor [UIColor colorWithRed:250.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]
#define radiobuttonSelectionColor [UIColor colorWithRed:58.0f/255 green:143.0f/255 blue:197.0f/255 alpha:1.0f]
#define radiobuttonBgColor [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f]

#define appBackgroundColor [UIColor colorWithRed:240.0f/255 green:242.0f/255 blue:245.0f/255 alpha:1.0f]
#define labelBgColor [UIColor colorWithRed:241.0f/255 green:112.0f/255 blue:107.0f/255 alpha:1.0f]

#define logintextGreyColor [UIColor colorWithRed:255.0f/255 green:232.0f/255 blue:241.0f/255 alpha:1.0f]
#define logintextGreyPlaceholderColor [UIColor colorWithRed:107.0f/255 green:158.0f/255 blue:199.0f/255 alpha:1.0f]
#define lineTextColor [UIColor colorWithRed:207.0f/255 green:209.0f/255 blue:212.0f/255 alpha:1.0f]
#define lineColor [UIColor colorWithRed:105.0f/255 green:154.0f/255 blue:200.0f/255 alpha:1.0f]
#define confirmcolorcode [UIColor colorWithRed:96.0f/255 green:97.0f/255 blue:98.0f/255 alpha:1.0f]
#define secondbuttonBordercolor  [UIColor colorWithRed:57.0f/255 green:136.0f/255 blue:192.0f/255 alpha:1.0f]
#define welcomelinecolorCode  [UIColor colorWithRed:191.0f/255 green:191.0f/255 blue:191.0f/255 alpha:1.0f]

#define childNameColorCode  [UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f]
#define activityHeading1Code  [UIColor colorWithRed:225.0f/255 green:228.0f/255 blue:232.0f/255 alpha:1.0f]
#define activityHeading1FontCode [[UIColor blackColor]colorWithAlphaComponent:0.8f]
//#define activityHeading1FontCode  [UIColor colorWithRed:45.0f/255 green:46.0f/255 blue:46.0f/255 alpha:1.0f]
#define activityHeading2Code  [UIColor colorWithRed:216.0f/255 green:220.0f/255 blue:226.0f/255 alpha:1.0f]
#define activityHeading2FontCode  [UIColor colorWithRed:109.0f/255 green:114.0f/255 blue:122.0f/255 alpha:1.0f]

#define ActivityDaysColor  [UIColor colorWithRed:85.0f/255 green:86.0f/255 blue:86.0f/255 alpha:1.0f]
//#define congratulationscolorcode [UIColor colorWithRed:96.0f/255 green:97.0f/255 blue:98.0f/255 alpha:1.0f]


#define PasscodeParentIsDelegate        @"Appdelegate"
#define ParentIsSchoolPlan              @"SchoolPlan"
#define ParentIsAfetrSchoolPlan         @"AfetrSchoolPlan"

#define phoneAcceptableCharacter        @"0123456789"

#define kCAUserInfoUsernameKey          @"parentname"
#define kCAChildInfoUsernameKey         @"child"


#define PinWiParentProfileEntity        @"ParentProfileEntity"
#define PinWiChildProfileEntity         @"ChildProfileEntity"
#define PinWiAllyProfileEntity          @"AllyProfileEntity"


//#define MyGoogleMapKey                  @"AIzaSyAUc-wu6h8-pBbk-VaW7r6ABsbGVSFidO0"



#define isPadAir ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && [UIScreen mainScreen].bounds.size.height == 1024 && [UIScreen mainScreen].scale==2.0f)
#define iPadAirImageNamed(image) (isPadAir ? [NSString stringWithFormat:@"%@@2x~ipad.%@", [image stringByDeletingPathExtension], [image pathExtension]] : [NSString stringWithFormat:@"%@~ipad.%@", [image stringByDeletingPathExtension], [image pathExtension]])
//#define iPadAirImage(image) ([UIImage imageNamed:iPadAirImageNamed(image)])


#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define isPhone667 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)
#define iPhone568ImageNamed(image) (isPhone667 ? [NSString stringWithFormat:@"%@-667h.%@", [image stringByDeletingPathExtension], [image pathExtension]]:[NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]])

#define isiPhoneiPad(image) (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? iPhone568ImageNamed(image):iPadAirImageNamed(image))


//#define iPhone667ImageNamed(image) (isPhone5 ? [NSString stringWithFormat:@"%@-568h.%@", [image stringByDeletingPathExtension], [image pathExtension]] : image)


//#define iPhone667Image(image) ([UIImage imageNamed:iPhone667ImageNamed(image)])


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ScreenInfo.h"
#import "AppDelegate.h"
#import "ParentProfileEntity.h"
#import "ChildProfileEntity.h"
#import "AllyProfileEntity.h"
#import "ParentProfileObject.h"


@interface PC_DataManager : NSObject
{
  //  float screenWidth,screenHeight;
}
@property (nonatomic, strong) ParentProfileObject *parentObjectInstance;
@property NSMutableArray *activities;
@property NSMutableArray *calTableActivitybyDateArray;
@property NSMutableDictionary *serviceDictionary;
@property NSString *badgeCount;
+(instancetype)sharedManager;
-(void)addBorderToView:(UIView *)view BorderWidth:(float)borderWidth Radius:(float)radius Color:(UIColor *)color;
-(UIView*)drawLineView_withXPos:(float)x andYPos:(float)y withScrnWid:(float)w withScrnHt:(float)h ofColor:(UIColor*)colour;
-(BOOL)NSStringIsValidEmail:(NSString *)emailId;
-(BOOL)isIllegalCharacter:(NSString*)stringVal;
-(NSString*)encodeImage:(UIImage*)image;
-(UIImage*)decodeImage:(NSString*)string;

// Child data Save and Edit
-(void)saveChildData:(NSMutableDictionary*)childDict;
-(void)removeChildDataWithID:(NSString*)childId andParentID:(NSString*)parentId;
-(void)editChildDataWithID:(NSString*)childId andParentID:(NSString*)parentId;

-(ParentProfileEntity *)getParentEntity;

// Ally data Save and Edit
-(void)saveAllyDataWithID:(NSMutableDictionary*)allyDict;
-(void)removeAllyDataWithID:(NSString*)allyId andParentID:(NSString*)parentId;
-(void)editAllyDataWithID:(NSString*)allyId andParentID:(NSString*)parentId;

//CoreData Saving

-(void)writeParentObjToDisk;
-(BOOL)retrieveDataAtLogin;

-(void)manageParentPersistentData;
-(void)manageChildPersistentData;
-(void)manageAllyPersistentData;

//Core Data Retrieve


//Core Data Delete


// activityUpdates
-(NSMutableArray*)updateCalendarTableByDate:(NSDictionary*)dict ofType:(NSString*)type;
-(NSMutableArray*)makeArrayOfdaysFromseparateostring:(NSMutableDictionary*)subject;
-(NSString*) daysFromDate:(NSDate *) startDate toDate:(NSDate *) endDate;
@property NSMutableString *repeatDaysString;
@property NSMutableString *actRatingString;
@property NSString *flatText;
@property NSString *streettext;
@property BOOL faceBookTouched;
@property BOOL googleTouched;

// array Methods
-(void)getWidthHeight;
-(void)signUpLabel;
-(void)checkBox;
-(void)profileLabel;
-(void)radioButton;
-(void)profileSetUp2;
-(void)childProfile;
-(void)AllyProfile;
-(void)confirmProfile;
-(void)welcomeScreen;
-(void)viewProfile;
-(void)appEnterCode;
-(void)activityCalendar;
-(void)childdashBoard;
-(void)MenuList;
-(void)InviteList;
-(void)RatingList;
-(void)NotificationList;
-(void)TutorialImages;
-(void)InsightsArrays;
-(NSString *)getDateStringFromString:(NSString *)dateStr format:(NSString *)format;
-(int)returnMonthVlaue;
-(int)returnDayValue;
-(NSMutableArray *)sortArrayWithArray:(NSMutableArray*)array withKey:(NSString*)keyString;
-(NSString *)convertDateInToString:(NSDate *)date withFormat:(NSString *)dateFormat;
-(NSDate *)convertStringIntoDate:(NSString *)dateString withFormat:(NSString *)dateFormat;
-(UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size1;
-(NSMutableArray*)makeDaysOneSubject:(NSArray *)subjectArray;
-(void)resetSegmentColor:(UISegmentedControl*)sgmntCtrl withTintColor:(UIColor*)color;
-(UIImage*)getImageSize:(UIImage *)image1 isLandScape:(BOOL)isLandScape isImageContentMode:(BOOL)mode;
-(void)loadLiveDataFromCoreData;
-(BOOL)islegalCharacterWithoutNumbers:(NSString*)stringVal;

@end

float screenWidth,screenHeight;

//signUp screen
NSArray *labelSignUpArray, *signUpTextFieldsArray, *signUpTextAttsArray, *labelProfileArray, *profileTextFieldArray, *radioLabelArray;

NSMutableArray
// signup label array
                *labelSignUpPosPxArray,
                *labelSignUpPosPyArray,
                *signUpLabelSize,
//textfield array
                *signUpTextFieldPosPXArray,
                *signUpTextFieldPosPYArray,
                *signUpTextFieldSizeArray,
// attributed text array
                *signUpTextAttsPosPXArray,
                *signUpTextAttsPosPYArray,
                *signUpTextAttsSizeArray,



// profile label array
                *labelProfilePosPxArray,
                *labelProfilePosPyArray,
                *profileLabelSize,

// profile text Field array
                *profileTextFieldPosPXArray,
                *profileTextFieldPosPYArray,
                *profileTextFieldSizeArray,

//Radio Button positon array
                *radioButtonPosPXArray,
                *radioButtonPosPYArray,

// label radio button
                *labelRadioPosPXArray,
                *labelRadioPosPYArray,
                *radioLabelSize,

// Checkbox array
                *checkboxPosPXArray,
                *checkboxPosPYArray;

// profile Setup 2 screen
NSArray *profileSetUp2Array;
NSMutableArray  *profileSetUpPosPXArray,
                *profileSetUpPosPYArray,
                *profileSetUpSizeArray;



// Child Profile Setup Screen

NSArray *childprofileSetUpArray;
NSMutableArray  *childprofileSetUpPosPXArray,
                *childprofileSetUpPosPYArray,
                *childprofileSetUpSizeArray;

// ally profile setup

NSArray *allyProfileArray;
NSMutableArray  *allyProfilePosPXArray,
                *allyProfilePosPYArray,
                *allyProfileSizeArray;

// Confirmatiom profile Array

NSArray *confirmationprofileArray;
NSMutableArray *confirmProfilePosPXArray,
                *confirmProfilePosPYArray,
                *confirmProfileSizeArray;


//Welcome Screen
NSArray        *welcomeScreenArray;
NSMutableArray *welcomecreenPosPXArray,
               *welcomeScreenPosPYArray,
                *welcomeScreenSizeArray;

// view Profile screen
NSArray *viewProfileArray,*viewProfileLabelArray;

// Activity Calendar

NSArray         *activityCalendarLabelArray;
NSMutableArray  *activityCalendarPosPXArray,
                *activityCalendarPosPYArray,
                *activityCalendarSizeArray;


// chidl dashboard array
NSArray         *childDashBoardArray, *childRatingArray, *childRatingSelArray;
NSMutableArray  *childDashBoardPosArray;

// Menu list array
NSArray         *menuListArray,*menuListNameArray, *inviteListArray, *ratingListArray, *notificationListArray;

// Tutorial
NSArray         *tutorialNameListArray,*tutorialAfterSchoolListArray,*tutorialSchoolListArray,*tutorialSchedularListArray,
                *tutorialChildListArray,*tutorialChildList2Array,*tutorialInsightsListArray,*tutorialPinwiWorksArray,*tutorialChildSounds,
                *tutorialListArray7,*tutorialListArray8,*tutorialListArray9,*tutorialListArray10, *tutorialChildSoundsOpening, *tutorialTextOpeningArray;
NSMutableArray  *tutorialListArrayComplete;

// Insights
NSArray         *qualityBadgeArray, *interestDriversArray, *interestPatternArray, *delightsTrendsArray, *insightsInfoArray,*insightsInfoArray1,*insightsInfoArray2,*insightsInfoArray3,*insightsInfoArray4,*insightsInfoArray5;


















