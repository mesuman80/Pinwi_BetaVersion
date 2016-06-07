//
//  HolidayCell.h
//  ParentControl_CT
//
//  Created by Yogesh on 09/01/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface HolidayCell : UITableViewCell
-(void)cellInitialization:(BOOL)isTouchEnable;
-(void)cellLayout:(NSDictionary *)data
   isTouchEnable :(BOOL)isTouchEnable  ;
-(void)cellSize :(CGSize )size ;
-(void)cellType :(CellType)type;
-(NSString *)subTitleText;
-(NSDate *)date ;
-(void)editable ;
-(NSString *)text ;
-(CellType)cellType ;
@end
