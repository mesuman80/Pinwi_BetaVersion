//
//  HeaderView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChildViewProtocol <NSObject>

-(void)touchAtBackButton;
-(void)getSoundTouches;

@end


@interface ChildHeaderView : UIView
@property id<ChildViewProtocol>headerViewdelegate;
@property UIViewController *rootViewController;
@property NSString *rightType;
-(void)drawHeaderViewWithTitle:(NSString*)title isBackBtnReq:(BOOL)backBtn BackImage:(NSString*)backImageName;
@property NSString *centreImgName;




@end
