//
//  AllyRelationshipTableViewCell.m
//  ParentControl_CT
//
//  Created by Priyanka on 31/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AllyRelationshipTableViewCell.h"
#import "Constant.h"
@implementation AllyRelationshipTableViewCell

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
      self.labelRelationship  = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 30)];
         self.labelRelationship.textColor = [UIColor blackColor];
       self .labelRelationship.font = [UIFont fontWithName:RobotoRegular size:12.0f];
        
        [self addSubview:self.labelRelationship];
    }
    return self;
}


@end
