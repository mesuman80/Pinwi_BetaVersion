//
//  ParentViewObject.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 31/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentViewObject : UIView


-(void)implementViewWithImage:(NSString*)imageName withLabel:(NSString*)labelStr;
-(void)updateViewWithBadgeCount:(NSString *)badgeCount;
@end
