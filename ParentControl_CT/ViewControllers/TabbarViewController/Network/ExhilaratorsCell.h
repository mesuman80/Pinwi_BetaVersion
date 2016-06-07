//
//  ExhilaratorsCell.h
//  ParentControl_CT
//
//  Created by Sakshi on 01/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterestDriverProtocol;

@interface ExhilaratorsCell : UIView
@property id<InterestDriverProtocol>interestDriverDelegate;
@property NSDictionary *dataDict;
-(void)drawUI:(NSDictionary *)dataDictionary withColor:(UIColor *)color;
@end
@protocol InterestDriverProtocol <NSObject>

-(void)interestDriverTouched:(ExhilaratorsCell *)ExhilaratorsCell;

@end
