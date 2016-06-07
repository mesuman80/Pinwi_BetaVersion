//
//  HolidayCell.m
//  ParentControl_CT
//
//  Created by Yogesh on 09/01/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "HolidayCell.h"
#import "Constant.h"
#import "PC_DataManager.h"
#import "DatePicker.h"

@interface HolidayCell  () {
    
}

@end



@implementation HolidayCell {
    UILabel *titleLabel   ;
    UITextField *subtitleLabel;
    UIImageView *arrowImage ;
    CGSize cellSize;
    CellType cellType ;
    DatePicker *pickerView ;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellSize:(CGSize )size {
    cellSize  = size;
}

-(void)cellType :(CellType)type {
    cellType  = type;
}

-(CellType)cellType {
    return cellType;
}

-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier {
    if(self  = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        return self;
    }
    return nil;
}

-(void)cellInitialization:(BOOL)isTouchEnable {
    UIFont *font  = (cellSize.width>700) ?
    [UIFont fontWithName:RobotoRegular size:9*ScreenFactor]
    :[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
    
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [titleLabel setFont:font];
    [self.contentView addSubview:titleLabel];
    
    subtitleLabel = [[UITextField alloc]initWithFrame:CGRectZero];
    [subtitleLabel setInputView  :nil];
    [subtitleLabel setFont       : font];
    [subtitleLabel setTextColor  : cellTextColor];
    [self.contentView addSubview : subtitleLabel];
    
    if(isTouchEnable) {
        [subtitleLabel setEnabled:YES];
        [subtitleLabel setReturnKeyType:UIReturnKeyDone];
        [subtitleLabel setDelegate:self];
    }
    else {
        [subtitleLabel setEnabled:NO];
    }
    
    [self drawArrayImage];
}

-(void)drawArrayImage {
//    arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:isiPhoneiPad(@"grayArrow.png")]];
//    arrowImage.frame  = CGRectMake(cellSize.width - ScreenWidthFactor*15, 0, ScreenWidthFactor*10,
//                                    ScreenWidthFactor*10);
//    [arrowImage setCenter:CGPointMake(arrowImage.center.x, cellSize.height/2.0f)];
//    [self.contentView addSubview:arrowImage];
}

-(void)cellLayout:(NSDictionary *)data isTouchEnable :(BOOL)isTouchEnable {
    [titleLabel    setText:[data valueForKey:@"Title"]];
    CGSize titleSize  = [self getTextSize:[titleLabel text] font:[titleLabel font]];
    [titleLabel setFrame:CGRectMake(10*ScreenWidthFactor,0, titleSize.width, titleSize.height)];
    [titleLabel setCenter:CGPointMake(titleLabel.center.x, cellSize.height/2.0f)];
    
    [subtitleLabel setText:[data valueForKey:@"SubTitle"]];
    CGSize subTitleSize  = [self getTextSize:[subtitleLabel text] font:[subtitleLabel font]];
    [subtitleLabel setFrame:CGRectMake(cellSize.width - arrowImage.frame.size.width-
                                       100*ScreenWidthFactor -10*ScreenWidthFactor ,
                                       0,100*ScreenWidthFactor, subTitleSize.height)];
    [subtitleLabel setCenter:CGPointMake(subtitleLabel.center.x, cellSize.height/2.0f)];
    
    if(isTouchEnable)[self setInputView];
}

-(void)editable {
    [subtitleLabel becomeFirstResponder];
}

-(void)setInputView {
    if(cellType == CellTypeText) {
        [subtitleLabel setInputView:nil];
    }
    else if(cellType == CellTypeDate) {
        if(!pickerView) {
           pickerView  =[[DatePicker alloc]initWithFrame:CGRectMake(0, screenHeight*.6, screenWidth, screenHeight*.4)];
            [pickerView drawPicker];
        }
        [subtitleLabel setInputView:pickerView];
        [pickerView   textField    :subtitleLabel];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(CGSize ) getTextSize :(NSString *)text font:(UIFont *)font {
    return [text sizeWithAttributes:@{NSFontAttributeName : font}];
}

-(NSString *)text {
    if(cellType == CellTypeDate) {
        return [pickerView dateInFormat:@"dd/MM/yyyy"];
    }
    return subtitleLabel.text;
}
-(NSString *)subTitleText {
   // NSLog(@" subtitleLabel.text = %@" , subtitleLabel.text);
    return subtitleLabel.text;
}

-(NSDate *)date {
    return [pickerView date];
}


@end
