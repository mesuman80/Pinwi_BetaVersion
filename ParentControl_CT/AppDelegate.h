//
//  AppDelegate.h
//  ParentControl_CT
//
//  Created by Priyanka on 2/23/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AddPassCode.h"
#import "AccessProfileViewController.h"
#import "SignUpViewController.h"
#import "CheckDeviceIDExists.h"
#import <EventKit/EventKit.h>
#import <AVFoundation/AVFoundation.h>

static BOOL is4InchRetina() {
    if ((![UIApplication sharedApplication].statusBarHidden && (int)[[UIScreen mainScreen] applicationFrame].size.height == 548) || ([UIApplication sharedApplication].statusBarHidden && (int)[[UIScreen mainScreen] applicationFrame].size.height == 568))
        return YES;
    return NO;
}

@interface AppDelegate : UIResponder <UIApplicationDelegate,UrlConnectionDelegate>

@property EKEventStore *eventStore;
@property UITabBar *tabBar;
@property UITabBarController *tabBarCtrl;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) AVAudioPlayer *backgroundMusic;
-(void)initializeSound;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
-(void)reminderpermission;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end

