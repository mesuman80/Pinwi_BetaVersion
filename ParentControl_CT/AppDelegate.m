//
//  AppDelegate.m
//  ParentControl_CT
//
//  Created by Priyanka on 2/23/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AppDelegate.h"
#import "PC_DataManager.h"
#import <GooglePlus/GooglePlus.h>
#import "TabBarViewController.h"

#import "NotificationViewController.h"
#import "ChildActivities_VC.h"
#import "AllyProfileController.h"
#import "NetworkViewController.h"
#import "InternetConnection.h"


#import "WelcomeScreenViewController.h"
//#import "MoreViewController.h"
//#import "AppDelegate.h"

#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]



@interface AppDelegate ()

@end

@implementation AppDelegate
{
    SignUpViewController *sign;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];

  
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    [self enableRemoteNotification:application];

    self.window =  [[ UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];
    [self.window makeKeyWindow];
    [self initializeSound];
    
    NSLog(@"log in value= %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"isLoggedOut"]);
       [[PC_DataManager sharedManager] loadLiveDataFromCoreData];
    

//   [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isLoggedOut"];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLoggedOut"] isEqualToString:@"1"])
    {
        sign=[[SignUpViewController alloc]init];
        UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:sign];
        [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
    }
    
    else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"RegistrationCompleted"]boolValue])
    {
        AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
        UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
        [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
        // [[[UIApplication sharedApplication]keyWindow].rootViewController presentViewController:naviCtrl animated:NO completion:nil];
        
    }
    else
    {
          if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Confirmed"] isEqualToString:@"1"])
         {
             sign=[[SignUpViewController alloc]init];
             UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:sign];
             [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
         }
        
         else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Confirmed"] isEqualToString:@"2"])
         {
         ChildProfileController *sign2=[[ChildProfileController alloc]init];
         UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:sign2];
             [naviCtrl.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
             [naviCtrl.navigationController.navigationBar setTitleTextAttributes:
              [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
         [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
         }
         
         else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Confirmed"] isEqualToString:@"3"])
         {
         AllyProfileController *sign3=[[AllyProfileController alloc]init];
         UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:sign3];
             [naviCtrl.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
             [naviCtrl.navigationController.navigationBar setTitleTextAttributes:
              [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];

             
         [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
         }
           else
         {
        sign=[[SignUpViewController alloc]init];
        UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:sign];
        [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
        }

    }
    
    
    InternetConnection *internetConnection  = [InternetConnection sharedInstance];
    [internetConnection setDelegate:nil];


    [PC_DataManager sharedManager].parentObjectInstance.deviceToken=@"Testing_Iphone_PinWi";

    if(sign)
    
    {
        [sign checkDeviceToken:[PC_DataManager sharedManager].parentObjectInstance.deviceToken];
    }

    return YES;
}

-(void)enableRemoteNotification:(UIApplication *)application
{
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        // use registerUserNotificationSettings
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }
    else
    {
        // use registerForRemoteNotifications
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
}


#ifdef  __IPHONE_8_0
- (void)application:(UIApplication  * )application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
    
    //NSLog(@"device Token  %@", deviceToken);
    
    
}

-(void)application:(UIApplication  *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //NSLog(@"Not able to get remoteNotification =%@",error.localizedDescription);
}
#endif
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *str = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *newString = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSString *udidStr= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSLog(@"DEVICE UDID  %@", udidStr);
    NSLog(@"DEVICE TOKEN  %@", newString);
    
    [PC_DataManager sharedManager].parentObjectInstance.deviceToken=newString;
    [sign checkDeviceToken:newString];
    if( [[[NSUserDefaults standardUserDefaults]valueForKey:@"isLoggedOut"]boolValue])
    {
        [self checkDeviceToken:newString];
    }
     [[PC_DataManager sharedManager]writeParentObjToDisk];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"ss"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    [[NSUserDefaults standardUserDefaults]setObject:dateString forKey:@"AutoLockPswdTime"];
    
    [self pauseSound];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self pauseSound];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self resumeSound];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [self resumeSound];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"RegistrationCompleted"]boolValue] && [[[NSUserDefaults standardUserDefaults]valueForKey:@"isLoggedOut"]isEqualToString:@"0"])
    {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"doesPswdExist"]boolValue]) {
    
        /*    NSString *setTimeVal2=[[NSUserDefaults standardUserDefaults]objectForKey:@"AutoLockTime"];
            int time1=[setTimeVal2 intValue]*60;
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"ss"];
            NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
            int newTime=[dateString intValue];
            
            NSString *setTimeVal1=[[NSUserDefaults standardUserDefaults]objectForKey:@"AutoLockPswdTime"];
            int oldTime=[setTimeVal1 intValue];

            if(newTime-oldTime >= time1)
            {*/
//            AddPassCode *add=[[AddPassCode alloc]initwithEnablePswd:NO changePswd:NO deletePswd:NO key:kCAUserInfoUsernameKey];
//            add.parentClass=PasscodeParentIsDelegate;
//            [[[UIApplication sharedApplication]keyWindow].rootViewController presentViewController:add animated:NO completion:nil ];
            //}
        }

    }
    
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        [self openActiveSessionWithPermissions:nil allowLoginUI:NO];
    }
    
    [FBAppCall handleDidBecomeActive];
   // [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%i",0] forKey:@"ActivityCompleted"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self pauseSound];
    [self saveContext];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    if([[PC_DataManager sharedManager]faceBookTouched]==YES)
    {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }
    else if ([PC_DataManager sharedManager].googleTouched==YES)
    {
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return nil;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Parentcontrol.CT.ParentControl_CT" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ParentControl_CT" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ParentControl_CT.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}




#pragma mark facebook method
/*
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        //  FBRequest *request=[FBRequest requestForMyFriends];
        
        //[self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        // [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        //[FBSession.activeSession closeAndClearTokenInformation];
    }
}
 
 */
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}




//

#pragma mark - Public method implementation

-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      // Create a NSDictionary object and set the parameter values.
                                      NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                        session, @"session",
                                                                        [NSNumber numberWithInteger:status], @"state",
                                                                        error, @"error",
                                                                        nil];
                                      
                                      // Create a new notification, add the sessionStateInfo dictionary to it and post it.
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangeNotification"
                                                                                          object:nil
                                                                                        userInfo:sessionStateInfo];
                                  }];
}

#pragma mark GoogLePlusSignIn



#pragma mark DEVICE TOKEN CHECK
-(void)checkDeviceToken:(NSString *)string
{
    //isDeviceTokenExist=YES;
    CheckDeviceIDExists *check=[[CheckDeviceIDExists alloc]init];
        [check initService:@{
                            @"DeviceID":string
                             }];
        [check setDelegate:self];
        check.serviceName=@"CheckDeviceIDExists";
       // [self addLoaderView];
}

-(void)ifAlreadyExist:(BOOL)isExist
{
    //SignUpViewController *sign1=[[SignUpViewController alloc]init];
    [sign isDeviceTokenExist:isExist];
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSLog(@"here i am  %@", dictionary);
    if([connection.serviceName isEqualToString:@"CheckDeviceIDExists"])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"CheckDeviceIDExistsResponse" resultKey:@"CheckDeviceIDExistsResult"];
        if([dict isKindOfClass:[NSArray class]])
        {
            
            NSMutableArray *errDict= dict.mutableCopy;
            NSDictionary *dictionary  = [errDict firstObject];
            if([[dictionary valueForKey:@"ErrorDesc"]isEqualToString:@"Device ID Already Exists."])
            {
                [self ifAlreadyExist:YES];
            }
            else
            {
                [self ifAlreadyExist:NO];
            }
        }
    }
}


#pragma mark tab bar ctrl
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    switch (tabBarController.tabBarItem.tag) {
        case 0:
            //
            break;
            
        case 1:
            // <#statements#>
            break;
            
        case 2:
            //
            break;
            
        case 3:
            //
            break;
    }
}
#pragma mark MusicPlayerSpecificFuncitons
-(void)initializeSound
{
//    if(!self.backgroundMusic)
//    {
//        NSURL *musicFile = [[NSBundle mainBundle] URLForResource:@"Jaunty Gumption"
//                                                   withExtension:@"mp3"];
//        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile
//                                                                      error:nil];
//        self.backgroundMusic.numberOfLoops = -1;
//        [self.backgroundMusic prepareToPlay];
//        [self.backgroundMusic play];
//    }
//    else
//    {
//        [self resumeSound];
//    }
   
}

-(void)pauseSound
{
     //[self.backgroundMusic pause];
}
-(void)resumeSound
{
   // [self.backgroundMusic play];
}
-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    
}
-(void)reminderpermission
{
    self.eventStore = [[EKEventStore alloc]init];
    if ([_eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        /* iOS Settings > Privacy > Calendars > MY APP > ENABLE | DISABLE */
        [_eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error)
         {
             if ( granted )
             {
                 NSLog(@"User has granted permission!");
             }
             else
             {
                 NSLog(@"User has not granted permission!");
             }
         }];
    }

}
@end
