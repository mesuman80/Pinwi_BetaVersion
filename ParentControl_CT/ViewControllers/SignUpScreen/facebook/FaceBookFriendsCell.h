//
//  FaceBookFriendsCell.h
//  Amgine
//
//  Created by Yogesh Gupta on 09/02/15.
//
//

#import <UIKit/UIKit.h>
#import "FaceBookFriends.h"
@interface FaceBookFriendsCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)drawUI:(FaceBookFriends *)faceBookFriends;
@property UIImageView *profilePic;
@end
