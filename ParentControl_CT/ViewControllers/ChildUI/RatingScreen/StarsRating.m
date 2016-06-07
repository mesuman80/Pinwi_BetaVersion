//
//  StarsRating.m
//  CircleAnim
//
//  Created by Veenus Chhabra on 30/04/15.
//  Copyright (c) 2015 Suman Bhattacharyya. All rights reserved.
//

#import "StarsRating.h"

@implementation StarsRating
{
    NSMutableArray *posArr;
    NSString *val;
}

-(id)initWithFrame:(CGRect)frame withImage:(UIImage*)image 
{
    if(self =[super initWithFrame:frame])
    {
        self.frame=frame;
       // val=val1;
        [self drawStars:image];
        return self;
    }
    return nil;
}

-(id)init
{
    if(self ==[super init])
    {
        return self;
    }
    return nil;
}


-(void)drawStars :(UIImage*)starImg
{
    star=[[UIImageView alloc]initWithImage:starImg];
    star.frame=CGRectMake(0, 0, starImg.size.width, starImg.size.height);
    [self addSubview:star];
    
    
 //   return star.frame;
//    starFill=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fillStar.png"]];
//    starFill.frame=self.frame;
//    [self addSubview:starFill];
//    starFill.alpha=0.0f;
}

-(void)fillStars
{
    starFill.alpha=1.0f;
    star.alpha=0.0f;
}


-(void)removeStars
{
    starFill.alpha=0.0f;
    star.alpha=1.0f;
}

@end
