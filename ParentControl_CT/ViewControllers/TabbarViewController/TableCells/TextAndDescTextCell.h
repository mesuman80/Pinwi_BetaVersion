//
//  TextAndDescTextCell.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 22/09/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextAndDescTextCell : UITableViewCell
@property UILabel *textlabel1;
@property UILabel *descTextLabel;
@property UIImageView *arrowImageView;
-(void)addText:(NSString *)text andDesc:(NSString*)desc withTextColor:(UIColor*)textColor andDecsColor:(UIColor*)descTextColor andType:(NSString*)type;
@end
