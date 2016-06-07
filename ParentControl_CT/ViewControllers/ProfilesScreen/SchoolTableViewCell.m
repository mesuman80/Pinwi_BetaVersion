//
//  SchoolTableViewCell.m
//  ParentControl_CT
//
//  Created by Priyanka on 01/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "SchoolTableViewCell.h"
#import "Constant.h"

@implementation SchoolTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
        self.labelSchool  = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 30)];
        self.labelSchool.textColor = [UIColor blackColor];
        self .labelSchool.font = [UIFont fontWithName:RobotoRegular size:12.0f];
        
        [self addSubview:self.labelSchool];
    }
    return self;
}

@end
