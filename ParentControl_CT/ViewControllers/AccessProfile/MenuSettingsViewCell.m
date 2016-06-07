//
//  AccessProfileCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 29/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "MenuSettingsViewCell.h"

@implementation MenuSettingsViewCell

@synthesize nameLabel;
@synthesize userImage;

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        userImage=[[UIImageView alloc]init];
        [self addSubview:userImage];
        
         nameLabel=[[UILabel alloc]init];
         [self addSubview:nameLabel];

        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

-(void)addMenuCredential:(NSString*)name image:(UIImage*)image
{
   // userImage.center=CGPointMake(userImage.center.x,self.frame.size.height*);
    userImage.image=image;
    userImage.frame=CGRectMake(10*ScreenWidthFactor, 0,30*ScreenHeightFactor,30*ScreenHeightFactor);
    userImage.center=CGPointMake(userImage.center.x,screenHeight*.04);
    userImage.userInteractionEnabled=NO;
//    userImage.layer.cornerRadius = userImage.frame.size.width/2;
//    userImage.layer.borderWidth = 0.5f;
//    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
//    userImage.clipsToBounds = YES;

    
    nameLabel.font=[UIFont fontWithName:RobotoRegular size:15.0f * ScreenHeightFactor];
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:nameLabel.font}];
    nameLabel.text=name;
    nameLabel.frame=CGRectMake(ScreenWidthFactor*20+30*ScreenHeightFactor,self.frame.size.height*.05,displayValueSize.width,displayValueSize.height);
    nameLabel.center=CGPointMake(nameLabel.center.x,screenHeight*.04);
    nameLabel.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.8f];
    nameLabel.userInteractionEnabled=NO;
    
//    if(screenWidth>700)
//    {
//        nameLabel.center=CGPointMake(nameLabel.center.x,self.frame.size.height/2);
//    }
    
    //nameLabel.textAlignment=NSTextAlignmentCenter;
}


-(void)addInviteCredential:(NSString*)name image:(UIImage*)image
{
    userImage.image=image;
    userImage.frame=CGRectMake(20*ScreenWidthFactor,0,60*ScreenHeightFactor,60*ScreenHeightFactor);
    userImage.center=CGPointMake(userImage.center.x,40*ScreenHeightFactor);
    userImage.userInteractionEnabled=NO;

    //CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f *ScreenHeightFactor]}];
    nameLabel.font=[UIFont fontWithName:RobotoRegular size:20.0f * ScreenHeightFactor];
    nameLabel.text=name;
    nameLabel.frame=CGRectMake(90*ScreenWidthFactor,20*ScreenHeightFactor,screenWidth-90*ScreenWidthFactor,60*ScreenHeightFactor);
    nameLabel.center=CGPointMake(nameLabel.center.x,40*ScreenHeightFactor);
    nameLabel.textColor=cellBlackColor_6;
    nameLabel.userInteractionEnabled=NO;

    self.backgroundColor=appBackgroundColor;
}


@end
