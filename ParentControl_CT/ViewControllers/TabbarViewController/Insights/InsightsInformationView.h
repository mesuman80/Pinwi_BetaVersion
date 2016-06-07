//
//  InsightsInformationView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 27/10/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InformationProtocol <NSObject>

-(void)removeInformationView;

@end

@interface InsightsInformationView : UIView
@property id<InformationProtocol>infoDeledgate;
-(void)drawUi:(NSString *)head andIndex:(int)index;
@end
