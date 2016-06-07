//
//  AccessProfileCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 29/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AccessProfileCell.h"

@implementation AccessProfileCell

@synthesize nameLabel;
@synthesize earnedPoints;
@synthesize pendingPoints;
@synthesize userImage;
@synthesize earnedImage;
@synthesize pendingImage;
@synthesize arrowImgView;

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
        userImage=[[UIImageView alloc]init];
        [self addSubview:userImage];
        
         nameLabel=[[UILabel alloc]init];
         [self addSubview:nameLabel];
        
        earnedImage=[[UIImageView alloc]init];
        [self addSubview:earnedImage];
        
        pendingImage=[[UIImageView alloc]init];
        [self addSubview:pendingImage];
        
        earnedPoints=[[UILabel alloc]init];
        [self addSubview:earnedPoints];
        
        pendingPoints=[[UILabel alloc]init];
        [self addSubview:pendingPoints];
        
        arrowImgView=[[UIImageView alloc]init];
        [self addSubview:arrowImgView];
        
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)addParentCredential:(NSString*)name image:(UIImage*)image
{
   // userImage.center=CGPointMake(userImage.center.x,self.frame.size.height*);
    
    [self resetData];
    if(!image)
    {
        image=[UIImage imageNamed:isiPhoneiPad(@"parentDefaultImage.png")];
    }

    [self drawImageIcon:image];
    
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    nameLabel.font=[UIFont fontWithName:RobotoRegular size:20*ScreenHeightFactor];
    nameLabel.text=name;
    nameLabel.frame=CGRectMake(ScreenWidthFactor*10+userImage.frame.origin.x+userImage.frame.size.width,ScreenHeightFactor*2,displayValueSize.width,displayValueSize.height);
    nameLabel.center=CGPointMake(nameLabel.center.x,ScreenHeightFactor*45);
    nameLabel.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.8f];
    [nameLabel sizeToFit];
    
    [self drawArrowIcon];
    
   
}


-(void)addChildCredential:(NSString*)name image:(UIImage*)image earnedPoints:(NSString*)earned pendingPOints:(NSString*)pending
{
    [self resetData];
    if(!image)
    {
        image=[UIImage imageNamed:isiPhoneiPad(@"childDefaultImage.png")];
    }

    [self drawImageIcon:image];
//    userImage.frame=CGRectMake(cellPadding*2, ScreenHeightFactor*2 , ScreenHeightFactor*70, ScreenHeightFactor*70);
//    userImage.image=image;
//    userImage.center=CGPointMake(userImage.center.x,ScreenHeightFactor*50);
//    userImage.layer.cornerRadius = userImage.frame.size.width/2;
//    //userImage.layer.borderWidth = 0.5f;
//   // userImage.layer.borderColor = [UIColor whiteColor].CGColor;
//    //userImage.clipsToBounds = YES;
//    
//    userImage.layer.cornerRadius = userImage.frame.size.height /2;
//    userImage.layer.masksToBounds = YES;
//    userImage.layer.borderWidth = 0;
//    userImage.contentMode=UIViewContentModeScaleAspectFill;
    
    
    
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    nameLabel.font=[UIFont fontWithName:RobotoRegular size:18*ScreenHeightFactor];
    nameLabel.text=name;
    nameLabel.frame=CGRectMake(ScreenWidthFactor*10+userImage.frame.origin.x+userImage.frame.size.width,ScreenHeightFactor*2,displayValueSize.width,displayValueSize.height);
    nameLabel.center=CGPointMake(nameLabel.center.x,userImage.frame.origin.y+nameLabel.frame.size.height/2+10*ScreenHeightFactor    );
    nameLabel.textColor=[UIColor whiteColor];
    [nameLabel sizeToFit];
    
    int yy=nameLabel.frame.size.height+ScreenHeightFactor*5;
    
    [earnedImage removeFromSuperview];
    earnedImage.frame=CGRectMake(nameLabel.frame.origin.x,yy, ScreenFactor*16, ScreenFactor*16);
    earnedImage.center=CGPointMake(earnedImage.center.x,userImage.center.y+earnedImage.frame.size.height/2+7*ScreenHeightFactor);
    earnedImage.image=[UIImage imageNamed:isiPhoneiPad(@"earnedCup.png")];
    [self addSubview:earnedImage];

   
    pendingImage.frame=CGRectMake(ScreenWidthFactor*200,yy, ScreenFactor*16, ScreenFactor*16);
    pendingImage.center=CGPointMake(pendingImage.center.x,userImage.center.y+pendingImage.frame.size.height/2+7*ScreenHeightFactor);
    pendingImage.image=[UIImage imageNamed:isiPhoneiPad(@"pendingCup.png")];
  
    
    displayValueSize = [earned sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9*ScreenFactor]}];
    earnedPoints.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    earnedPoints.text=earned;//[NSString stringWithFormat:@"Earned: %@",earned];;
    earnedPoints.frame=CGRectMake(cellPadding+earnedImage.frame.size.width+earnedImage.frame.origin.x,yy,displayValueSize.width,displayValueSize.height);
    earnedPoints.center=CGPointMake(earnedPoints.center.x, earnedImage.center.y);
    earnedPoints.textColor=[UIColor whiteColor];
    [earnedPoints sizeToFit];
    
    displayValueSize = [pending sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9*ScreenFactor]}];
    pendingPoints.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    pendingPoints.text=pending;//[NSString stringWithFormat:@"Pending: %@",pending];
    pendingPoints.frame=CGRectMake(cellPadding+pendingImage.frame.size.width+pendingImage.frame.origin.x,yy,displayValueSize.width,displayValueSize.height);
    pendingPoints.center=CGPointMake(pendingPoints.center.x,pendingImage.center.y);
    pendingPoints.textColor=[UIColor whiteColor] ;
    [pendingPoints sizeToFit];
    [self resetDataShow];
    
    [self drawArrowIcon];
}

-(void)drawImageIcon:(UIImage*)profileImg
{
    userImage.frame=CGRectMake(cellPadding*2, ScreenHeightFactor*2 , ScreenHeightFactor*70, ScreenHeightFactor*70);
    userImage.image=profileImg;
    userImage.center=CGPointMake(userImage.center.x,ScreenHeightFactor*50);
    userImage.layer.cornerRadius = userImage.frame.size.width/2;
    userImage.layer.cornerRadius = userImage.frame.size.height /2;
    userImage.layer.masksToBounds = YES;
    userImage.layer.borderWidth = 0;
    userImage.contentMode=UIViewContentModeScaleAspectFill;
}

-(void)drawArrowIcon
{
    arrowImgView.frame=CGRectMake(screenWidth-cellPadding*2, ScreenHeightFactor*2 , ScreenHeightFactor*20, ScreenHeightFactor*20);
    arrowImgView.image=[UIImage imageNamed:isiPhoneiPad(@"parentAccessArrow.png")];
    arrowImgView.center=CGPointMake(screenWidth- arrowImgView.frame.size.width/2 -cellPadding*2,nameLabel.center.y);
}


-(void)resetData
{
    earnedImage.alpha=0.0;
    pendingImage.alpha=0.0;
    earnedPoints.alpha=0.0;
    pendingPoints.alpha=0.0;
}

-(void)resetDataShow
{
    earnedImage.alpha=1.0;
    pendingImage.alpha=1.0;
    earnedPoints.alpha=1.0;
    pendingPoints.alpha=1.0;
}


@end
