//
//  StarsRating.h
//  CircleAnim
//
//  Created by Veenus Chhabra on 30/04/15.
//  Copyright (c) 2015 Suman Bhattacharyya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarsRating : UIView
{
    UIImageView *star;
    UIImageView *starFill;
}
-(id)initWithFrame:(CGRect)frame withImage:(UIImage*)image;

-(void)drawStars :(UIImage*)starImg;
-(void)fillStars;
-(void)removeStars;


@end
