//
//  FaceBookFriendsViewController.h
//  Amgine
//
//  Created by Yogesh Gupta on 09/02/15.
//
//

#import <UIKit/UIKit.h>
@class FaceBookFriendsCell;
@class FaceBookFriends;

@interface FaceBookFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property UITableView *friendsTableView;
-(FaceBookFriendsCell *)cellTableView :(UITableView *)tableView withData:(FaceBookFriends *)faceBookFriends;
@end
