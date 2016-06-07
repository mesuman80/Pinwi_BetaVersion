//
//  AppEnterTableViewCell.m
//  ParentControl_CT
//
//  Created by Priyanka on 01/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AppEnterTableViewCell.h"

@implementation AppEnterTableViewCell


@synthesize userImageView;
@synthesize nameLabel;
@synthesize earned,pending;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [[PC_DataManager sharedManager]getWidthHeight];
        
        
        

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}

-(void) addNewItems
{
    [self.nameLabel removeFromSuperview];
    [self.imageView removeFromSuperview];
    [self. earned removeFromSuperview];
    [self.pending removeFromSuperview];
    
    
    userImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"face_icon.png"]];
    userImageView.frame=CGRectMake(0,0,40,40);
    userImageView.center=CGPointMake(25, 22);
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 150, 44)];
     nameLabel.font=[UIFont fontWithName:RobotoRegular size:15.0f];
    
    
    earned=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.16f, screenHeight*.04f,screenWidth, screenHeight*.04f)];
    pending=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth*0.20f, screenHeight*.04f,screenWidth, screenHeight*.04f)];


    [self.contentView addSubview:userImageView];
    [self.contentView addSubview:nameLabel];
    
    [self.contentView addSubview:earned];
    [self.contentView addSubview:pending];
   // [self.contentView addSubview:descriptionLabel];

    
}


@end
