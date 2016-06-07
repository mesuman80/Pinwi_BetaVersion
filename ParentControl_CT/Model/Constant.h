//
//  Constant.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 24/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Constant : NSObject

//********************************** screen factors **************************************************
//#define GooglePlusKey                   @"987598936725-h6rnun8e6ciq5neuu3de1iequrj8r7g3.apps.googleusercontent.com"
//#define GooglePlusUrlScheme             @"com.googleusercontent.apps.987598936725-h6rnun8e6ciq5neuu3de1iequrj8r7g3"
//#define GoogleiOSMapKeyScheme           @"AIzaSyCM77D-pjDWoNrPyciL1DToaAkJi1Qr8Yk"
//#define GoogleServerKey                 @"AIzaSyCeXXAYunybniPWKR4ZJPP5j065qAPm5O8"
#define GooglePlusKey                   @"25079778482-q617ebke4s5i0d4tp9a0i1t88ncs8r3s.apps.googleusercontent.com"
#define GooglePlusUrlScheme             @"com.googleusercontent.apps.25079778482-q617ebke4s5i0d4tp9a0i1t88ncs8r3s"
#define GoogleiOSMapKeyScheme           @"AIzaSyDFdnlaZBXha1R8DLoGKQdph8uVwIns3Fw"
#define GoogleServerKey                 @"AIzaSyD6T1iEqfHRy2-vCBexKVBPN0JFXq1Ajx8"

#define PinWiWebServiceUrlScheme        @"http://api.pinwi.in:2015/PinWiService.asmx"
//#define PinWiWebServiceUrlScheme        @"http://166.78.47.124:2015/PinWiService.asmx"
//#define PinWiWebServiceUrlScheme        @"http://173.203.70.172:2020/PinWiService.asmx"
//#define PinWiWebServiceUrlScheme        @"http://api.pinwi.in/PinWiService.asmx"
//#define PinWiWebServiceUrlScheme        @"http://beta.convergenttec.com/ws/PinWiService.asmx"
#define PinWiWsID                       @"pinwistars"
#define PiniWiWsPswd                    @"appconnect@$2015"
#define appCurrentDate                  [NSDate date]

//********************************** screen factors **************************************************
#define ScreenWidthFactor       [UIScreen mainScreen].bounds.size.width/320
#define ScreenHeightFactor      [UIScreen mainScreen].bounds.size.height/568
#define ScreenFactor            sqrt(pow([UIScreen mainScreen].bounds.size.width/320, 2)+pow([UIScreen mainScreen].bounds.size.height/568, 2))
#define cellPadding             ScreenWidthFactor*12
#define cellPaddingReg          ScreenWidthFactor*15

//********************************** Font Style **************************************************
#define RobotoRegular       @"Roboto-Regular"
#define RobotoLight         @"Roboto-Light"
#define GothamMedium        @"Gotham Medium"
#define RobotoBold          @"Roboto-Bold"
#define Gotham              @"Gotham Book"
#define KGTheLastTime       @"KGTheLastTime"    
#define gothamExtralight    @"gothamExtralight"
#define gothamLight         @"gothamLight"
#define gothamThin          @"gothamThin"    

//****************************************Parent Class Name ******************************************
#define NoChildTouchForMenu         @"NoChildTouchForMenu"
#define FlatText                    @"Flat no/Building"
#define StreetText                  @"Street/Locality"
//****************************************************************************************************
//********************************** Font Colors **************************************************


//********************************** Sign up Screen **************************************************
#define placeHolderSignUp  [UIColor colorWithRed:215.0f/255 green:228.0f/255 blue:240.0f/255 alpha:1.0f]
#define placeHolderReg     [UIColor colorWithRed:146.0f/255 green:146.0f/255 blue:146.0f/255 alpha:1.0f]
#define Aboutuscolor       [UIColor colorWithRed:145.0f/255 green:181.0f/255 blue:214.0f/255 alpha:1.0f]
#define AddPictureColor    [UIColor colorWithRed:221.0f/255 green:223.0f/255 blue:225.0f/255 alpha:1.0f]
#define textBlueColor      [UIColor colorWithRed:057.0f/255 green:139.0f/255 blue:192.0f/255 alpha:1.0f]

#define SegmentedSelectedBlueAttibute   [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,placeHolderReg, NSForegroundColorAttributeName, nil];

#define SegmentedUnSelectedAttibute     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];

#define SegmentedSelectedGreenAttibute   [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,placeHolderReg, NSForegroundColorAttributeName, nil];

#define SegmentedUnSelectedAttibute     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];

//********************************** Schedular Screen **************************************************
#define cellTextColor      [UIColor colorWithRed:68.0f/255 green:68.0f/255 blue:68.0f/255 alpha:1.0f]
#define cellBlackColor_9   [[UIColor blackColor]colorWithAlphaComponent:0.9f]
#define cellBlackColor_8   [[UIColor blackColor]colorWithAlphaComponent:0.8f]
#define cellBlackColor_7   [[UIColor blackColor]colorWithAlphaComponent:0.7f]
#define cellBlackColor_6   [[UIColor blackColor]colorWithAlphaComponent:0.6f]
#define cellBlackColor_5   [[UIColor blackColor]colorWithAlphaComponent:0.5f]
#define cellBlackColor_4   [[UIColor blackColor]colorWithAlphaComponent:0.4f]
#define cellBlackColor_3   [[UIColor blackColor]colorWithAlphaComponent:0.3f]
#define cellBlackColor_2   [[UIColor blackColor]colorWithAlphaComponent:0.2f]
#define cellBlackColor_1   [[UIColor blackColor]colorWithAlphaComponent:0.1f]

//********************************** Insights Screen **************************************************
#define ExhilaratorPurple   [UIColor colorWithRed:106.0f/255.0f green:24.0f/255.0f blue:182.0/255.0f alpha:1.0f]
#define NonInfluencerGreen  [UIColor colorWithRed:144.0f/255.0f green:179.0f/255.0f blue:22.0/255.0f alpha:1.0f]
#define AmusersRed          [UIColor colorWithRed:255.0f/255.0f green:108.0f/255.0f blue:0.0/255.0f alpha:1.0f]
#define HoHummersOrange     [UIColor colorWithRed:255.0f/255.0f green:174.0f/255.0f blue:0.0/255.0f alpha:1.0f]
#define BlankstersGray      [UIColor colorWithRed:130.0f/255.0f green:131.0f/255.0f blue:132.0/255.0f alpha:1.0f]

//********************************** Notifications Screen **************************************************
#define unReadNotification      [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0/255.0f alpha:1.0f]
#define ReadNotification        [UIColor colorWithRed:236.0f/255.0f green:238.0f/255.0f blue:242.0/255.0f alpha:1.0f]
#define NotificationTimeColor   [UIColor colorWithRed:133.0f/255.0f green:142.0f/255.0f blue:153.0/255.0f alpha:1.0f]

//********************************** Child Screen **************************************************
#define childDashBoardOrange1   [UIColor colorWithRed:210.0f/255 green:148.0f/255 blue:16.0f/255 alpha:1.0f]
#define childDashBoardOrange2   [UIColor colorWithRed:253.0f/255 green:184.0f/255 blue:19.0f/255 alpha:1.0f]
#define cellWhiteColor_8        [[UIColor whiteColor]colorWithAlphaComponent:0.8f]
#define cellWhiteColor_7        [[UIColor whiteColor]colorWithAlphaComponent:0.7f]
#define cellWhiteColor_6        [[UIColor whiteColor]colorWithAlphaComponent:0.6f]
#define cellWhiteColor_5        [[UIColor whiteColor]colorWithAlphaComponent:0.5f]

//********************************** Tutorial Indeces **************************************************
#define pinwiWorksIndex         0
#define schedularIndex          1
#define schoolIndex             2
#define afterSchoolIndex        3
#define insightsIndex           4
#define childTutIndex           5
#define childTutNextIndex       15

//**********************************Forget Password Related WebServices**************************************************
#define PinWiForgetPassword                 @"ForgetPassword"
#define PinWiForgetPasswordResult           @"ForgetPasswordResult"
#define PinWiForgetPasswordResponse         @"ForgetPasswordResponse"

#define PinWiResetPassword                  @"ResetPassword"
#define PinWiResetPasswordResult            @"ResetPasswordResult"
#define PinWiResetPasswordResponse          @"ResetPasswordResponse"

#define PinWiCheckPassword                  @"CheckPassword"
#define PinWiCheckPasswordResult            @"CheckPasswordResult"
#define PinWiCheckPasswordResponse          @"CheckPasswordResponse"

//********************************** Profile Setup Related WebServices **************************************************
#define PinWiUpdateParent   @"UpdateParentProfile"
#define PinWiCreateParent   @"CreateParentProfile"
#define PinWiCreateChild    @"CreateChildProfile"
#define PinWiUpdateChild    @"UpdateChildProfile"
#define PinWiCreateNewChild @"CreateNewChildProfile"
#define PinWiCreateAlly     @"CreateAllyProfile"
#define PinWiUpdateAlly     @"UpdateAllyProfile"
#define PinWiCreateNewAlly  @"CreateNewAllyProfile"
#define PinWiDeleteChild    @"DeleteChild"
#define PinWiDeleteAlly     @"DeleteAlly"
#define PinWiGetChildren    @"GetListofChildsByParentID"
#define PinWiGetAllies      @"GetListofAllysByParentID"

//********************************** Child rating Related WebServices **************************************************
#define PinWiGetSubjectByChildID                @"PinWiGetSubjectByChildID"
#define PinWiGetAfterSchoolActivityByChildId    @"PinWiGetAfterSchoolActivityByChildId"
#define PinWiGetCurrentDayRatingStatus          @"GetCurrentDayRatingStatus"
#define PinWiAddActivityRating                  @"AddActivityRating"
#define PinWiAddPointsEarned                    @"AddPointsEarned"
#define PinWiGetPointsInfoByChildID             @"GetPointsInfoByChildID"
#define PinWiGetPastDaysRatingStatus            @"GetPastDaysRatingStatus"

//**********************************Insight Related WebServices**************************************************
#define PinWiGetInsightBatchDetailsByChildID                @"GetInsightBatchDetailsByChildID"
#define PinWiGetInsightBatchDetailsByChildIDResult          @"GetBadgeDetailsByChildIDOnInsightResult"
#define PinWiGetInsightBatchDetailsByChildIDResponse        @"GetBadgeDetailsByChildIDOnInsightResponse"

#define PinWiGetInterestTraitsByChildIDOnInsight            @"GetInterestTraitsByChildIDOnInsight"
#define PinWiGetInterestTraitsByChildIDOnInsightResult      @"GetInterestTraitsByChildIDOnInsightResult"
#define PinWiGetInterestTraitsByChildIDOnInsightResponse    @"GetInterestTraitsByChildIDOnInsightResponse"

#define PinWiGetDelightTraitsByChildIDOnInsight             @"GetDelightTraitsByChildIDOnInsight"
#define PinWiGetDelightTraitsByChildIDOnInsightResult       @"GetDelightTraitsByChildIDOnInsightResult"
#define PinWiGetDelightTraitsByChildIDOnInsightResponse     @"GetDelightTraitsByChildIDOnInsightResponse"

#define PinWiGetPointsInfoByChildIDOnInsights               @"GetPointsInfoByChildIDOnInsights"
#define PinWiGetPointsInfoByChildIDOnInsightsResult         @"GetPointsInfoByChildIDOnInsightsResult"
#define PinWiGetPointsInfoByChildIDOnInsightsResponse       @"GetPointsInfoByChildIDOnInsightsResponse"

#define PinWiGetDelightTraitsByActivity                     @"GetDelightTraitsByActivity"
#define PinWiGetDelightTraitsByActivityResult               @"GetDelightTraitsByActivityResult"
#define PinWiGetDelightTraitsByActivityResponse             @"GetDelightTraitsByActivityResponse"

#define PinWiInsightReportActiveStatus                      @"InsightReportActiveStatus"
#define PinWiInsightReportActiveStatusResult                @"InsightReportActiveStatusResult"
#define PinWiInsightReportActiveStatusResponse              @"InsightReportActiveStatusResponse"

//**********************************Notifications Related WebServices**************************************************
#define PinWiGetNotificationListByParentID                  @"GetNotificationListByParentID"
#define PinWiGetNotificationListByParentIDResponse          @"GetNotificationListByParentIDResponse"
#define PinWiGetNotificationListByParentIDResult            @"GetNotificationListByParentIDResult"

#define PinWiGetNewNotificationCount                        @"GetNewNotificationCount"
#define PinWiGetNewNotificationCountResponse                @"GetNewNotificationCountResponse"
#define PinWiGetNewNotificationCountResult                  @"GetNewNotificationCountResult"

#define PinWiGetNotificationSettingsByProfileID             @"GetNotificationSettingsByProfileID"
#define PinWiGetNotificationSettingsByProfileIDResponse     @"GetNotificationSettingsByProfileIDResponse"
#define PinWiGetNotificationSettingsByProfileIDResult       @"GetNotificationSettingsByProfileIDResult"

#define PinWiAddNotificationSettingsByProfileID             @"AddNotificationSettingsByProfileID"
#define PinWiAddNotificationSettingsByProfileIDResponse     @"AddNotificationSettingsByProfileIDResponse"
#define PinWiAddNotificationSettingsByProfileIDResult       @"AddNotificationSettingsByProfileIDCountResult"

//********************************** Menu Related WebServices **************************************************
#define PinWiGetProfileDetails                              @"GetAllProfilesDetails"
#define PinWiGetInviteURL                                   @"GetInviteURL"
#define PinWiGetInviteURLResponse                           @"GetInviteURLResponse"
#define PinWiGetInviteURLResult                             @"GetInviteURLResult"
#define PinWiRequestAddOnVersion                            @"RequestAddOnVersion"
#define PinWiRequestAddOnVersionResponse                    @"RequestAddOnVersionResponse"
#define PinWiRequestAddOnVersionResult                      @"RequestAddOnVersionResult"

//********************************** Activity Related WebServices **************************************************
#define PinWiDeleteActivity                                 @"DeleteScheduledActivityByActChildID"
#define PinWiDeleteActivityResponse                         @"DeleteScheduledActivityByActChildIDResponse"
#define PinWiDeleteActivityResult                           @"DeleteScheduledActivityByActChildIDResult"

#define PinWiGetListOfScheduledAllys                        @"GetListOfAllysOnActivityByChildIDAct"
#define PinWiGetListOfScheduledAllysResponse                @"GetListOfAllysOnActivityByChildIDActResponse"
#define PinWiGetListOfScheduledAllysResult                  @"GetListOfAllysOnActivityByChildIDActResult"

#define PinWiAddAllyInformationOnActivity                   @"AddAllyInformationOnActivity"
#define PinWiAddAllyInformationOnActivityResponse           @"AddAllyInformationOnActivityResponse"
#define PinWiAddAllyInformationOnActivityResult             @"AddAllyInformationOnActivityResult"

//**************************************** Calender Object Type ******************************************

#define PinWiCalenderHolidayObjectType @"HolidayCalender"
#define PinWiAddHolidaysByChildID @"AddHolidaysByChildID"
#define PinWiAddHolidaysByChildIDResponse @"AddHolidaysByChildIDResponse"
#define PinWiAddHolidaysByChildIDResult @"AddHolidaysByChildIDResult"

#define PinWiGetHolidayByChildID @"GetHolidaysByChildID"
#define PinWiGetHolidayByChildIDResult @"GetHolidaysByChildIDResult"
#define PinWiGetHolidayByChildIDResponse @"GetHolidaysByChildIDResponse"


#define PinWiGetListofHolidaysByChildID   @"GetListofHolidaysByChildID"


#define PinWiGetListofHolidaysByChildIDResponse   @"GetListofHolidaysByChildIDResponse"

#define PinWiGetListofHolidaysByChildIDResult @"GetListofHolidaysByChildIDResult"

#define PinWiAddHolidayByChildId           @"AddHolidaysByChildID"
#define PinWiAddHolidayByChildIdResponse   @"AddHolidaysByChildIDResponse"
#define PinWiAddHolidayByChildIdResult     @"AddHolidaysByChildIDResult"


#define PinWiDeleteHolidayByHolidayDesc     @"DeleteHolidayByHolidayDesc"
#define PinWiDeleteHolidayByHolidayDescResponse  @"DeleteHolidayByHolidayDescResponse"
#define PinWiDeleteHolidayByHolidayDescResult    @"DeleteHolidayByHolidayDescResult"

#define PinWiGetHolidayDetailsByHolidayDesc            @"GetHolidayDetailsByHolidayDesc"
#define PinWiGetHolidayDetailsByHolidayDescResponse    @"GetHolidayDetailsByHolidayDescResponse"
#define PinWiGetHolidayDetailsByHolidayDescResult      @"GetHolidayDetailsByHolidayDescResult"


typedef enum {
    CellTypeText     =  0 ,
    CellTypeNone     =  1 ,
    CellTypeDate     =  2
} CellType;

//********************************** Network Related WebServices **************************************************
#define PinWiGetFriendsListByLoggedID                         @"GetFriendsListByLoggedID"
#define PinWiGetFriendsListByLoggedIDResponse                 @"GetFriendsListByLoggedIDResponse"
#define PinWiGetFriendsListByLoggedIDResult                   @"GetFriendsListByLoggedIDResult"

#define PinWiGetListOfPendingRequestsByLoggedID               @"GetListOfPendingRequestsByLoggedID"
#define PinWiGetListOfPendingRequestsByLoggedIDResponse       @"GetListOfPendingRequestsByLoggedIDResponse"
#define PinWiGetListOfPendingRequestsByLoggedIDResult         @"GetListOfPendingRequestsByLoggedIDResult"

#define PinWiGetPeopleYouMayKnowListByLoggedID                @"GetPeopleYouMayKnowListByLoggedID"
#define PinWiGetPeopleYouMayKnowListByLoggedIDResponse        @"GetPeopleYouMayKnowListByLoggedIDResponse"
#define PinWiGetPeopleYouMayKnowListByLoggedIDResult          @"GetPeopleYouMayKnowListByLoggedIDResult"

#define PinWiGetProfileDetailsByLoggedID                      @"GetProfileDetailsByLoggedID"
#define PinWiGetProfileDetailsByLoggedIDResponse              @"GetProfileDetailsByLoggedIDResponse"
#define PinWiGetProfileDetailsByLoggedIDResult                @"GetProfileDetailsByLoggedIDResult"

#define PinWiGetFriendDetailsByFriendID                       @"GetFriendDetailsByFriendID"
#define PinWiGetFriendDetailsByFriendIDResponse               @"GetFriendDetailsByFriendIDResponse"
#define PinWiGetFriendDetailsByFriendIDResult                 @"GetFriendDetailsByFriendIDResult"

#define PinWiGetChildDetailsByChildID                         @"GetChildDetailsByChildID"
#define PinWiGetChildDetailsByChildIDResponse                 @"GetChildDetailsByChildIDResponse"
#define PinWiGetChildDetailsByChildIDResult                   @"GetChildDetailsByChildIDResult"

#define PinWiGetExhilaratorsListByChildID                     @"GetExhilaratorsListByChildID"
#define PinWiGetExhilaratorsListByChildIDResponse             @"GetExhilaratorsListByChildIDResponse"
#define PinWiGetExhilaratorsListByChildIDResult               @"GetExhilaratorsListByChildIDResult"

#define PinWiUpdateStatusOnAction                             @"UpdateStatusOnAction"
#define PinWiUpdateStatusOnActionResponse                     @"UpdateStatusOnActionResponse"
#define PinWiUpdateStatusOnActionResult                       @"UpdateStatusOnActionResult"

#define PinWiSendFriendRequest                                @"SendFriendRequest"
#define PinWiSendFriendRequestResponse                        @"SendFriendRequestResponse"
#define PinWiSendFriendRequestResult                          @"SendFriendRequestResult"

#define PinWiSearchFriendListGlobally                         @"SearchFriendListGlobally"
#define PinWiSearchFriendListGloballyResponse                 @"SearchFriendListGloballyResponse"
#define PinWiSearchFriendListGloballyResult                   @"SearchFriendListGloballyResult"


#define PinWiGetListOfPinWiNetworksByLoggedID                 @"GetListOfPinWiNetworksByLoggedID"
#define PinWiGetListOfPinWiNetworksByLoggedIDResponse         @"GetListOfPinWiNetworksByLoggedIDResponse"
#define PinWiGetListOfPinWiNetworksByLoggedIDResult           @"GetListOfPinWiNetworksByLoggedIDResult"


//********************************** What To Do Related WebServices **************************************************

#define PinWiGetListOfClustersOnRecommendedByChildID          @"GetListOfClustersOnRecommendedByChildID"
#define PinWiGetListOfClustersOnRecommendedByChildIDResponse  @"GetListOfClustersOnRecommendedByChildIDResponse"
#define PinWiGetListOfClustersOnRecommendedByChildIDResult    @"GetListOfClustersOnRecommendedByChildIDResult"

#define PinWiGetListOfClustersOnNetworkByChildID              @"GetListOfClustersOnNetworkByChildID"
#define PinWiGetListOfClustersOnNetworkByChildIDResponse      @"GetListOfClustersOnNetworkByChildIDResponse"
#define PinWiGetListOfClustersOnNetworkByChildIDResult        @"GetListOfClustersOnNetworkByChildIDResult"

#define PinWiGetListOfClustersOnExploreByChildID              @"GetListOfClustersOnExploreByChildID"
#define PinWiGetListOfClustersOnExploreByChildIDResponse      @"GetListOfClustersOnExploreByChildIDResponse"
#define PinWiGetListOfClustersOnExploreByChildIDResult        @"GetListOfClustersOnExploreByChildIDResult"

#define PinWiGetWishListsByChildID                            @"GetWishListsByChildID"
#define PinWiGetWishListsByChildIDResponse                    @"GetWishListsByChildIDResponse"
#define PinWiGetWishListsByChildIDResult                      @"GetWishListsByChildIDResult"

#define PinWiSearchWishListByChildID                          @"SearchWishListByChildID"
#define PinWiSearchWishListByChildIDResponse                  @"SearchWishListByChildIDResponse"
#define PinWiSearchWishListByChildIDResult                    @"SearchWishListByChildIDResult"

#define PinWiGetListOfActivitiesOnRecommendedByClusterID              @"GetListOfActivitiesOnRecommendedByClusterID"
#define PinWiGetListOfActivitiesOnRecommendedByClusterIDResponse      @"GetListOfActivitiesOnRecommendedByClusterIDResponse"
#define PinWiGetListOfActivitiesOnRecommendedByClusterIDResult        @"GetListOfActivitiesOnRecommendedByClusterIDResult"

#define PinWiGetListOfActivitiesOnNetworkByClusterID                  @"GetListOfActivitiesOnNetworkByClusterID"
#define PinWiGetListOfActivitiesOnNetworkByClusterIDResponse          @"GetListOfActivitiesOnNetworkByClusterIDResponse"
#define PinWiGetListOfActivitiesOnNetworkByClusterIDResult            @"GetListOfActivitiesOnNetworkByClusterIDResult"

#define PinWiSearchActivitiesByChildID                        @"SearchActivitiesByChildID"
#define PinWiSearchActivitiesByChildIDResponse                @"SearchActivitiesByChildIDResponse"
#define PinWiSearchActivitiesByChildIDResult                  @"SearchActivitiesByChildIDResult"

#define PinWiGetChildsDetailsOnRecommendedByActivityID         @"GetChildsDetailsOnRecommendedByActivityID"
#define PinWiGetChildsDetailsOnRecommendedByActivityIDResponse @"GetChildsDetailsOnRecommendedByActivityIDResponse"
#define PinWiGetChildsDetailsOnRecommendedByActivityIDResult   @"GetChildsDetailsOnRecommendedByActivityIDResult"

#define PinWiSearchActivitiesOnNetworkByClusterID              @"SearchActivitiesOnNetworkByClusterID"
#define PinWiSearchActivitiesOnNetworkByClusterIDResponse      @"SearchActivitiesOnNetworkByClusterIDResponse"
#define PinWiSearchActivitiesOnNetworkByClusterIDResult        @"SearchActivitiesOnNetworkByClusterIDResult"
@end
