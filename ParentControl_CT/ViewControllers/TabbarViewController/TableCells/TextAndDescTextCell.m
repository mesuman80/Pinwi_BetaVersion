//
//  TextAndDescTextCell.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 22/09/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import "TextAndDescTextCell.h"
#import "PC_DataManager.h"

@implementation TextAndDescTextCell
@synthesize textlabel1,descTextLabel;
@synthesize arrowImageView;
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
        descTextLabel=[[UILabel alloc]init];
        arrowImageView=[[UIImageView alloc]init];
        self.backgroundColor=appBackgroundColor;
        
        [self.contentView addSubview:textlabel1];
        [self.contentView addSubview:descTextLabel];
        [self.contentView addSubview:arrowImageView];
    }
    return self;
}


-(void)addText:(NSString *)text andDesc:(NSString*)desc withTextColor:(UIColor*)textColor andDecsColor:(UIColor*)descTextColor andType:(NSString*)type
{
    //NSDictionary *subDict=[subDictionary objectForKey:@"Data"];
    [self resetText];
    NSString *sub=text;
    CGSize displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12*ScreenFactor]}];
     textlabel1.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
    if(screenWidth>700)
    {
         textlabel1.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    }
   
    textlabel1.text=sub;
    textlabel1.frame=CGRectMake(cellPadding,0,ScreenWidthFactor*150,displayValueSize.height);
    [textlabel1 sizeToFit];
    textlabel1.center=CGPointMake(textlabel1.center.x,ScreenHeightFactor*20);
    if([type isEqualToString:@"Banner"])
    {
        textlabel1.center=CGPointMake(textlabel1.center.x,ScreenHeightFactor*15);
    }
    textlabel1.textColor=textColor;
    textlabel1.alpha=1.0f;
    
    if(desc)
    {
        sub=desc;
        displayValueSize = [sub sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12*ScreenFactor]}];
        descTextLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
        if(screenWidth>700)
        {
             descTextLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
        }
        descTextLabel.text=sub;
        descTextLabel.frame=CGRectMake(cellPadding,0,ScreenWidthFactor*70,displayValueSize.height);
        [descTextLabel sizeToFit];
        descTextLabel.center=CGPointMake(screenWidth-descTextLabel.frame.size.width/2-cellPadding,ScreenHeightFactor*20);
        descTextLabel.textColor=descTextColor;
        descTextLabel.textAlignment=NSTextAlignmentRight;
        descTextLabel.alpha=1.0f;
    }
    if([type isEqualToString:@"Banner"] || [type isEqualToString:@"Switch"]){
        
    }
    else
    {
        arrowImageView.alpha = 1.0f;
        arrowImageView.frame=CGRectMake(0, 0, ScreenWidthFactor*10, ScreenWidthFactor*10);
        arrowImageView.image=[UIImage imageNamed:isiPhoneiPad(@"grayArrow.png")];
        arrowImageView.center=CGPointMake(screenWidth-arrowImageView.frame.size.width/2-cellPadding, ScreenHeightFactor*20);
        
        
    }
    
    //[subjectLabel sizeToFit];
}

-(void)resetText
{
    textlabel1.alpha=0.0f;
    descTextLabel.alpha=0.0f;
    arrowImageView.alpha=0.0f;
    [arrowImageView setImage:nil];
}


@end
