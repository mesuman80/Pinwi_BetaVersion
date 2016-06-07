//
//  NameAndTextButton.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 05/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NameTextProtocol;

@interface NameAndTextButton : UIView
@property id<NameTextProtocol> delegate;
-(void)drawUi:(NSString*)head andImage:(NSString*)imgName;
@end

@protocol NameTextProtocol <NSObject>

-(void)TouchAtNameTextView:(NameAndTextButton*)touchView;

@end