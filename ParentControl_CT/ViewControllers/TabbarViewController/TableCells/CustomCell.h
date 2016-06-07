//
//  SubjectDetailCell.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 22/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"

@interface CustomCell : UITableViewCell
{
    UILabel *cellName;
    UILabel *cellDescName;
    UIImageView *cellImage;
    UIButton *cellButton;
}


-(void)generateCell:(NSMutableDictionary*)dictionary;

@end
