//
//  HolidayFooterView.h
//  ParentControl_CT
//
//  Created by Sakshi on 05/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>


//@protocol <#protocol name#> <NSObject>
//
//<#methods#>
//
//@end
@protocol FooterViewDelegate;

@interface HolidayFooterView : UIView
-(void)drawUI ;
@property (nonatomic, weak) id<FooterViewDelegate>delegate;
@property (nonatomic, weak) NSString *childId;
@end

@protocol FooterViewDelegate <NSObject>
-(void)touchAtFooterView:(NSString *)childId;
@end