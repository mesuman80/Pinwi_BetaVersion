//
//  interestCell.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 10/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterestDriverProtocol;

@interface InterestCell : UIView
@property id<InterestDriverProtocol>interestDriverDelegate;
@property NSDictionary *dataDict;
-(void)drawUI:(NSDictionary *)dataDictionary withColor:(UIColor *)color;
@end

@protocol InterestDriverProtocol <NSObject>

-(void)interestDriverTouched:(InterestCell *)interestCell;

@end
