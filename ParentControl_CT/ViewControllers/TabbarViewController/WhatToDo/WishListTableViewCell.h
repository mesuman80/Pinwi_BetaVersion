//
//  WishListTableViewCell.h
//  ParentControl_CT
//
//  Created by Tripta Garg on 16/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishListTableViewCell : UITableViewCell
-(void)addWishList:(NSString*)subjectName childCount:(NSString*)childrenCount cellHeight:(CGFloat)cellHeight isScheduled:(BOOL)isScheduled;
-(void)addActivityList:(NSString*)subjectName childCount:(NSString*)childrenCount cellHeight:(CGFloat)cellHeight isScheduled:(BOOL)isScheduled isWished:(BOOL)isWished;
@end
