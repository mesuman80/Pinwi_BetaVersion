//
//  HeaderView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewProtocol <NSObject>

-(void)touchAtBackButton;
-(void)getMenuTouches;

@end


@interface HeaderView : UIView
@property id<HeaderViewProtocol>headerViewdelegate;
@property (nonatomic, assign) BOOL rightButtonDisable ;
@property UIViewController *rootViewController;
@property NSString *rightType;
-(void)drawHeaderViewWithTitle:(NSString*)title isBackBtnReq:(BOOL)backBtn BackImage:(NSString*)backImageName;
@property NSString *centreImgName;
@property UIView *viewBack;
@end
