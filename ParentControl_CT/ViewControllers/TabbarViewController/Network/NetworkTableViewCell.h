//
//  NetworkTableViewCell.h
//  ParentControl_CT
//
//  Created by Sakshi on 29/02/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@protocol removeFriendDelegate;
@interface NetworkTableViewCell : UITableViewCell <UrlConnectionDelegate,removeFriendDelegate>


@property(nonatomic, strong) UIImageView *profileImage;
@property UILabel *parentName;
@property UILabel *childrenLabel;
@property UIButton *statusButton;
@property NSInteger FriendStatus;
@property UILabel *cityNameLabel;
@property UILabel *addressLabel;
@property UILabel *childNameLabel;
@property UILabel *childAgeLabel;
@property UILabel *childDobLabel;
@property UILabel *childSchoolLabel;
@property UILabel *connectionsLabel;
@property UILabel *connectionCountLabel;
@property NSString *friendId;
@property UIButton *networkButton;


@property int childId;
@property int loggedId;
@property (nonatomic, assign)id<removeFriendDelegate>removeFriendDelegate;


-(void)addFriendsCredential:(NSString*)name profileImage:(UIImage*)image childName:(NSString*)children fStatus:(NSString*)status cellHeight:(CGFloat)cellHeight;
-(void)addParentCredential:(NSString*)name profileImage:(UIImage*)image cityName:(NSString*)city parentAddress:(NSString*)address cellHeight:(CGFloat)cellHeight;
-(void)addChildCredential:(NSString*)name profileImage:(UIImage*)image childAge:(NSString*)age childDob:(NSString*)dob childSchool:(NSString*)school pinwiConnections:(NSString*)connections cellHeight:(CGFloat)cellHeight;
-(void)addFriendsDetails:(NSString*)name profileImage:(UIImage*)image cityName:(NSString*)city fStatus:(NSInteger*)status cellHeight:(CGFloat)cellHeight;
-(void)addFriendsChildDetails:(NSString*)name profileImage:(UIImage*)image childAge:(NSString*)age cellHeight:(CGFloat)cellHeight;
-(void)addFoundFriendsCredential:(NSString*)name profileImage:(UIImage*)image fStatus:(NSString*)status cellHeight:(CGFloat)cellHeight;
-(void)addChildConnectionDetails:(NSString*)name profileImage:(UIImage*)image parentName:(NSString*)pName cellHeight:(CGFloat)cellHeight;

@end

@protocol removeFriendDelegate<NSObject>
-(void)updateList;
@end