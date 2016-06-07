//
//  OverLayView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 08/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OverLayProtocol <NSObject>

-(void)continueTouched;

@end

@interface OverLayView : UIView

@property id<OverLayProtocol>overLayDelegate;
-(id)initWithFrame:(CGRect)frame withInfoText:(NSString*)info AndButtonText:(NSString*)buttonTitle;
-(id)initWithFrame:(CGRect)frame withInfoText:(NSString*)info AndButtonText:(NSString*)buttonTitle withHEading:(NSString *)headingStr
;
@end
