//
//  RedLabelView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 21/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@interface RedLabelView : UIView

-(id)initWithFrame:(CGRect)frame withChildStr:(NSString *)str;
-(void)drawRedBgLabel:(NSString*)str;
@end
