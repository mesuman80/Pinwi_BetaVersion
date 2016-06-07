//
//  ListOfHolidayCell.m
//  ParentControl_CT
//
//  Created by Yogesh on 10/01/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "ListOfHolidayCell.h"
#import "Constant.h"

@implementation ListOfHolidayCell {
    UILabel *textLabel;
    CGSize cellSize;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        return self;
    }
    return nil;
}

-(void)initialization:(CGSize) size {
    UIFont *font  = (size.width>700) ?
    [UIFont fontWithName:RobotoRegular size:9*ScreenFactor]
    :[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
    
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [textLabel setFont:font];
    [self.contentView addSubview:textLabel];

    cellSize = size;
}

-(void)updateUI :(NSString *)text {
    [textLabel setText:text];
    CGSize titleSize  = [self getTextSize:[textLabel text] font:[textLabel font]];
    [textLabel setFrame:CGRectMake(10*ScreenWidthFactor,0, titleSize.width, titleSize.height)];
    [textLabel setCenter:CGPointMake(textLabel.center.x, cellSize.height/2.0f)];
}

-(CGSize ) getTextSize :(NSString *)text font:(UIFont *)font {
    return [text sizeWithAttributes:@{NSFontAttributeName : font}];
}
@end
