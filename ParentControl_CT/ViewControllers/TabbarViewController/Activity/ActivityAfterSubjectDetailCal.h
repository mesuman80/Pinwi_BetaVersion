//
//  ActivitySubjectDetailCal.h
//  ParentControl_CT
//
//  Created by Priyanka on 19/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"
#import "AddSubjectActivity.h"
#import "ActivityData.h"

@interface ActivitySubjectDetailCal : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UrlConnectionDelegate>

@property int subjectID;
@property NSString *subject;
@property ChildProfileObject *child;
@end
