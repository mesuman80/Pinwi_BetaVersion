//
//  ToggleSwitchCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 22/09/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import "ToggleSwitchCell.h"
#import "PC_DataManager.h"

@implementation ToggleSwitchCell
@synthesize textlabel1,switchView;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        textlabel1=[[UILabel alloc]init];
        self.backgroundColor=appBackgroundColor;
        [self.contentView addSubview:textlabel1];
    }
    return self;
}


@end
