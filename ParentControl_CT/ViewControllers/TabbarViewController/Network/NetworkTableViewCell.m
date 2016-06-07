//
//  NetworkTableViewCell.m
//  ParentControl_CT
//
//  Created by Sakshi on 29/02/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "NetworkTableViewCell.h"

#import "SendFriendRequest.h"
#import "UpdateStatusOnAction.h"

#import "ImageView.h"
#import "AppDelegate.h"
#import "ChildNetworkDetailViewController.h"



@implementation NetworkTableViewCell {
    UIImage *cellImage;
}


@synthesize profileImage,parentName,childrenLabel,statusButton,FriendStatus,cityNameLabel,addressLabel,networkButton,childId;
@synthesize childNameLabel,childAgeLabel,childDobLabel,childSchoolLabel,connectionsLabel,connectionCountLabel,friendId,loggedId, removeFriendDelegate;



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        profileImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [profileImage setImage:nil];
        profileImage.layer.masksToBounds = YES;
        profileImage.layer.borderWidth = 0;
        profileImage.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:profileImage];
        
        
        parentName = [[UILabel alloc] init];
        parentName.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
        parentName.textColor=textBlueColor;
        [parentName sizeToFit];
        [self.contentView addSubview:parentName];
        
        childrenLabel = [[UILabel alloc] init];
        childrenLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
        [self.contentView addSubview:childrenLabel];
        
        statusButton = [[UIButton alloc] init];
        [self.contentView addSubview:statusButton];
        
        networkButton = [[UIButton alloc] init];
        [self.contentView addSubview:networkButton];
        
        cityNameLabel =[[UILabel alloc] init];
        [self.contentView addSubview:cityNameLabel];
        
        addressLabel =[[UILabel alloc] init];
        [self.contentView addSubview:addressLabel];
        
        childNameLabel =[[UILabel alloc] init];
        [self.contentView addSubview:childNameLabel];
        
        childAgeLabel =[[UILabel alloc] init];
        [self.contentView addSubview:childAgeLabel];
        
        childDobLabel =[[UILabel alloc] init];
        [self.contentView addSubview:childDobLabel];
        
        childSchoolLabel =[[UILabel alloc] init];
        [self.contentView addSubview:childSchoolLabel];
        
        connectionsLabel =[[UILabel alloc] init];
        [self.contentView addSubview:connectionsLabel];
        
        connectionCountLabel =[[UILabel alloc] init];
        [self.contentView addSubview:connectionCountLabel];
        
        self.backgroundColor=appBackgroundColor;
        
        [profileImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImage:)];
        [profileImage addGestureRecognizer:gestureRecognizer];
        
    }
    return self;
}

-(void)resetData
{
    [profileImage setImage:nil];
    parentName.alpha=0.0;
    childrenLabel.alpha=0.0;
    statusButton.alpha=0.0;
}

-(void)resetDataShow
{
    profileImage.alpha=1.0;
    parentName.alpha=1.0;
    childrenLabel.alpha=1.0;
    statusButton.alpha=1.0;
}

-(void)addFriendsCredential:(NSString*)name profileImage:(UIImage*)image childName:(NSString*)children fStatus:(NSString*)status cellHeight:(CGFloat)cellHeight
{
    
    [self resetData];
    cellImage  = image;
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    profileImage.frame=CGRectMake(cellPadding/2, ScreenHeightFactor, ScreenHeightFactor*48, ScreenHeightFactor*48);
    [profileImage setImage:image];
    profileImage.center=CGPointMake(profileImage.center.x,cellHeight/2);
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    //[profileImage setBackgroundColor:[UIColor redColor]];
    
    parentName.text=name;
    if (screenWidth>700) {
        parentName.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor,displayValueSize.width,displayValueSize.height);
        parentName.center=CGPointMake(parentName.center.x,ScreenHeightFactor*20);
    }
    else{
        parentName.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*30,displayValueSize.width,displayValueSize.height);
        parentName.center=CGPointMake(parentName.center.x,ScreenHeightFactor*30);
    }
    
   
    NSString *str = @"Children: ";
    str = [str stringByAppendingString:children];
    childrenLabel.text=str;
    if (screenWidth>700) {
        childrenLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*3,displayValueSize.width+120,displayValueSize.height);
        childrenLabel.center=CGPointMake(childrenLabel.center.x,ScreenHeightFactor*40);
    }
    else{
        childrenLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*50,displayValueSize.width+35,displayValueSize.height);
        childrenLabel.center=CGPointMake(childrenLabel.center.x,ScreenHeightFactor*50);
    }
    
    childrenLabel.textColor=[UIColor grayColor];

    
    
    FriendStatus = [status intValue];
    NSLog(@"fstatus %ld width = %f disaplyValuesze = %f",(long)FriendStatus,[UIScreen mainScreen].bounds.size.width,displayValueSize.width/2);
    
    if (screenWidth>700) {
        statusButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-180,ScreenHeightFactor,125,ScreenHeightFactor*30);
        statusButton.center=CGPointMake([UIScreen mainScreen].bounds.size.width-statusButton.frame.size.width*1.2,cellHeight/2);
       
    }
    else{
    statusButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-80,ScreenHeightFactor-10,60,ScreenHeightFactor*30);
    statusButton.center=CGPointMake([UIScreen mainScreen].bounds.size.width-statusButton.frame.size.width,cellHeight/2);
    }
    
    statusButton.titleLabel.font = [UIFont fontWithName:RobotoBold size:10*ScreenHeightFactor];
     [statusButton.layer setBorderWidth:1.0f];
    
    switch (FriendStatus) {
        
        case 0:
            [statusButton setTitle:@"Sent" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:textBlueColor.CGColor];
            [statusButton setTitleColor:textBlueColor forState:UIControlStateNormal];

            break;
        case 1:
            [statusButton setTitle:@"Remove" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:[UIColor redColor].CGColor];
            [statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

            break;
        case 2:
            [statusButton setTitle:@"Accept" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:buttonGreenColor.CGColor];
            [statusButton setTitleColor:buttonGreenColor forState:UIControlStateNormal];
            
            break;
            
        case 5:
            [statusButton setTitle:@"Add" forState:UIControlStateNormal];
            [statusButton.layer setBorderColor:textBlueColor.CGColor];
            [statusButton setTitleColor:textBlueColor forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    [statusButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self resetDataShow];
}


-(void)addFoundFriendsCredential:(NSString*)name profileImage:(UIImage*)image fStatus:(NSString*)status cellHeight:(CGFloat)cellHeight
{
    [self resetData];
    cellImage  = image;
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    profileImage.frame=CGRectMake(cellPadding/2, ScreenHeightFactor, ScreenHeightFactor*48, ScreenHeightFactor*48);
    [profileImage setImage:image];
    profileImage.center=CGPointMake(profileImage.center.x,cellHeight/2);
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    //[profileImage setBackgroundColor:[UIColor redColor]];
    
    parentName.text=name;
    if (screenWidth>700) {
        parentName.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor,displayValueSize.width,displayValueSize.height);
        parentName.center=CGPointMake(parentName.center.x,ScreenHeightFactor*30);
    }
    else{
        parentName.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*30,displayValueSize.width,displayValueSize.height);
        parentName.center=CGPointMake(parentName.center.x,ScreenHeightFactor*30);
    }
    
    FriendStatus = [status intValue];
    NSLog(@"fstatus %ld width = %f disaplyValuesze = %f",(long)FriendStatus,[UIScreen mainScreen].bounds.size.width,displayValueSize.width/2);
    
    if (screenWidth>700) {
        statusButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-180,ScreenHeightFactor,125,displayValueSize.height+10);
        statusButton.center=CGPointMake([UIScreen mainScreen].bounds.size.width-statusButton.frame.size.width*1.2,cellHeight/2);
        
    }
    else{
        statusButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-80,ScreenHeightFactor-10,60,ScreenHeightFactor*30);
        statusButton.center=CGPointMake([UIScreen mainScreen].bounds.size.width-statusButton.frame.size.width,cellHeight/2);

    }
    
     statusButton.titleLabel.font = [UIFont fontWithName:RobotoBold size:10*ScreenHeightFactor];
    [statusButton.layer setBorderWidth:1.0f];
    childrenLabel.frame = CGRectZero;
    switch (FriendStatus) {
            
        case 0:
            [statusButton setTitle:@"Sent" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:textBlueColor.CGColor];
            [statusButton setTitleColor:textBlueColor forState:UIControlStateNormal];
            
            break;
        case 1:
            [statusButton setTitle:@"Remove" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:[UIColor redColor].CGColor];
            [statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            break;
        case 2:
            [statusButton setTitle:@"Accept" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:buttonGreenColor.CGColor];
            [statusButton setTitleColor:buttonGreenColor forState:UIControlStateNormal];
            
            break;
            
        case 5:
            [statusButton setTitle:@"Add" forState:UIControlStateNormal];
            [statusButton.layer setBorderColor:textBlueColor.CGColor];
            [statusButton setTitleColor:textBlueColor forState:UIControlStateNormal];
            break;
            
        default:
            break;

    }
    [statusButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self resetDataShow];
}


-(void)addParentCredential:(NSString*)name profileImage:(UIImage*)image cityName:(NSString*)city parentAddress:(NSString*)address cellHeight:(CGFloat)cellHeight
{
    [self resetData];
    cellImage  = image;
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    profileImage.frame=CGRectMake(cellPadding/2, ScreenHeightFactor, ScreenHeightFactor*48, ScreenHeightFactor*48);
    profileImage.image=image;
    profileImage.center=CGPointMake(profileImage.center.x,cellHeight/2);
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 0;
    profileImage.contentMode=UIViewContentModeScaleAspectFill;
    
    parentName.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    parentName.text=name;
    parentName.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor,displayValueSize.width,displayValueSize.height);
    parentName.center=CGPointMake(parentName.center.x,ScreenHeightFactor*20);
    parentName.textColor=[UIColor blackColor];
    [parentName sizeToFit];
    
    cityNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    cityNameLabel.text=city;
    cityNameLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor,displayValueSize.width+120,displayValueSize.height);
    cityNameLabel.center=CGPointMake(cityNameLabel.center.x,ScreenHeightFactor*40);
    cityNameLabel.textColor=[UIColor grayColor];
    
    addressLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    NSString *str = @"Address: ";
    str = [str stringByAppendingString:address];
    addressLabel.text=str;
    addressLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*2,displayValueSize.width+120,displayValueSize.height);
    addressLabel.center=CGPointMake(addressLabel.center.x,ScreenHeightFactor*60);
    addressLabel.textColor=[UIColor grayColor];
    
//    NSLog(@"fstatus %d width = %f disaplyValuesze = %f",FriendStatus,[UIScreen mainScreen].bounds.size.width,displayValueSize.width/2);
    statusButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-200,ScreenHeightFactor,125,displayValueSize.height+10);
    statusButton.center=CGPointMake(statusButton.center.x,cellHeight/2);
    [statusButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [statusButton.layer setBorderWidth:1.0f];
    [statusButton.layer setBorderColor:[UIColor blueColor].CGColor];
    [statusButton setTitle:@"Setting" forState:UIControlStateNormal];
    statusButton.titleLabel.font = [UIFont fontWithName:RobotoBold size:10*ScreenHeightFactor];
    
    [self resetDataShow];
}

-(void)addChildCredential:(NSString*)name profileImage:(UIImage*)image childAge:(NSString*)age childDob:(NSString*)dob childSchool:(NSString*)school pinwiConnections:(NSString*)connections cellHeight:(CGFloat)cellHeight
{
    [self resetData];
    cellImage  = image;
    
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    profileImage.frame=CGRectMake(cellPadding+10, ScreenHeightFactor, ScreenHeightFactor*48, ScreenHeightFactor*48);
    profileImage.image=image;
    profileImage.center=CGPointMake(profileImage.center.x,cellHeight/2);
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 0;
    profileImage.contentMode=UIViewContentModeScaleAspectFill;
    
    childNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    if(name.length>20)
    {
        name = [name substringToIndex:19];
        name = [name stringByAppendingString:@"...."];
    }
    childNameLabel.text=name;
    if (screenWidth>700) {
        childNameLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*20,displayValueSize.width,displayValueSize.height);
        childNameLabel.center=CGPointMake(childNameLabel.center.x,ScreenHeightFactor*20);
    }
    else{
        childNameLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*20,displayValueSize.width,displayValueSize.height);
        childNameLabel.center=CGPointMake(childNameLabel.center.x,ScreenHeightFactor*20);
    }
    
    childNameLabel.textColor=[UIColor blackColor];
    [childNameLabel sizeToFit];
    
    childAgeLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    NSString *str = @" Years Old";
    age = [NSString stringWithFormat:@"%@", age];
    
    age = [age stringByAppendingString:str];
    childAgeLabel.text=age;
    if (screenWidth>700) {
        childAgeLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*35,displayValueSize.width+120,displayValueSize.height);
        childAgeLabel.center=CGPointMake(childAgeLabel.center.x,ScreenHeightFactor*35);
    }
    else{
        childAgeLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*40,displayValueSize.width+120,displayValueSize.height);
        childAgeLabel.center=CGPointMake(childAgeLabel.center.x,ScreenHeightFactor*40);
    }
       childAgeLabel.textColor=[UIColor grayColor];
    
    childDobLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    NSString *strDob = @"Born on: ";
    strDob = [strDob stringByAppendingString:dob];
    childDobLabel.text=strDob;
    if (screenWidth>700) {
        childDobLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*53,displayValueSize.width+120,displayValueSize.height);
        childDobLabel.center=CGPointMake(childDobLabel.center.x,ScreenHeightFactor*53);
    }
    else{
        childDobLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*60,displayValueSize.width+120,displayValueSize.height);
        childDobLabel.center=CGPointMake(childDobLabel.center.x,ScreenHeightFactor*60);
    }
    
    childDobLabel.textColor=[UIColor grayColor];
    
    childSchoolLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    NSString *strSchool = @"School: ";
    strSchool = [strSchool stringByAppendingString:school];
    childSchoolLabel.text=strSchool;
    if (screenWidth>700) {
        childSchoolLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*72,displayValueSize.width+230,displayValueSize.height);
        childSchoolLabel.center=CGPointMake(childSchoolLabel.center.x,ScreenHeightFactor*72);
    }
    else{
        childSchoolLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*80,displayValueSize.width+120,displayValueSize.height);
        childSchoolLabel.center=CGPointMake(childSchoolLabel.center.x,ScreenHeightFactor*80);
    }
    
    childSchoolLabel.textColor=[UIColor grayColor];
    
    connectionsLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    NSString *strConnections = @"Connections: ";
    connectionsLabel.text=strConnections;
    if (screenWidth>700) {
        connectionsLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*88,displayValueSize.width+200,displayValueSize.height);
        connectionsLabel.center=CGPointMake(connectionsLabel.center.x,ScreenHeightFactor*88);
    }
    else{
        connectionsLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*100,displayValueSize.width+120,displayValueSize.height);
        connectionsLabel.center=CGPointMake(connectionsLabel.center.x,ScreenHeightFactor*100);
    }
    connectionsLabel.textColor=[UIColor grayColor];
    
    
    if (screenWidth>700) {
        networkButton.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,connectionsLabel.frame.size.height + connectionsLabel.frame.origin.y + 3,144,displayValueSize.height+20);
        networkButton.center=CGPointMake(networkButton.center.x,networkButton.center.y);
     
    }
    else{
        networkButton.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,connectionsLabel.frame.size.height + connectionsLabel.frame.origin.y + 3,80,displayValueSize.height+10);
        networkButton.center=CGPointMake(networkButton.center.x,networkButton.center.y);

    }

    networkButton.titleLabel.font = [UIFont fontWithName:RobotoBold size:12*ScreenHeightFactor];
       [networkButton.layer setBorderWidth:1.0f];
    [networkButton setTitleColor:textBlueColor forState:UIControlStateNormal];
    
    [networkButton.layer setBorderColor:textBlueColor.CGColor];
    [networkButton setTitle:@"Network" forState:UIControlStateNormal];
    
    connectionCountLabel.font=[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor];
    connectionCountLabel.text= [NSString stringWithFormat:@"%@", connections];
    CGSize  connectionCountSize = [connectionCountLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ScreenHeightFactor]}];
    
    if (screenWidth>700) {
        connectionCountLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,networkButton.frame.origin.y -10,ScreenHeightFactor*25,ScreenHeightFactor*15);
        connectionCountLabel.center=CGPointMake(networkButton.center.x,connectionCountLabel.center.y);
    }
    else{
        connectionCountLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,networkButton.frame.origin.y - 7,connectionCountSize.width + 10,connectionCountSize.height + 2);
        connectionCountLabel.center=CGPointMake(networkButton.center.x,connectionCountLabel.center.y);
    }
    
    
    connectionCountLabel.layer.cornerRadius = connectionCountLabel.frame.size.height/2;
    connectionCountLabel.layer.masksToBounds = YES;
    connectionCountLabel.backgroundColor = textBlueColor;
    connectionCountLabel.textAlignment = NSTextAlignmentCenter;
    connectionCountLabel.textColor = [UIColor whiteColor];

    
    
    [self resetDataShow];
}

-(void)addFriendsDetails:(NSString*)name profileImage:(UIImage*)image cityName:(NSString*)city fStatus:(NSInteger*)status cellHeight:(CGFloat)cellHeight
{
    [self resetData];
    cellImage  = image;
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    profileImage.frame=CGRectMake(cellPadding/2, ScreenHeightFactor, ScreenHeightFactor*48, ScreenHeightFactor*48);
    profileImage.image=image;
    profileImage.center=CGPointMake(profileImage.center.x,cellHeight/2);
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 0;
    profileImage.contentMode=UIViewContentModeScaleAspectFill;
    
    parentName.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    parentName.text=name;
    parentName.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor,displayValueSize.width,displayValueSize.height);
    parentName.center=CGPointMake(parentName.center.x,ScreenHeightFactor*20);
    parentName.textColor=[UIColor blueColor];
    [parentName sizeToFit];
    
    cityNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    cityNameLabel.text=city;
    cityNameLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*3,displayValueSize.width+120,displayValueSize.height);
    cityNameLabel.center=CGPointMake(cityNameLabel.center.x,ScreenHeightFactor*40);
    cityNameLabel.textColor=[UIColor grayColor];
    //    [childrenLabel sizeToFit];
    
    
    FriendStatus = *status ;
    NSLog(@"fstatus %ld width = %f disaplyValuesze = %f",(long)FriendStatus,[UIScreen mainScreen].bounds.size.width,displayValueSize.width/2);
    statusButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-200,ScreenHeightFactor,125,displayValueSize.height+10);
    statusButton.center=CGPointMake(statusButton.center.x,cellHeight/2);
    [statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [statusButton.layer setBorderWidth:1.0f];
    [statusButton.layer setBorderColor:[UIColor redColor].CGColor];
     statusButton.titleLabel.font = [UIFont fontWithName:RobotoBold size:10*ScreenHeightFactor];
    
    switch (FriendStatus) {
            
        case 0:
            [statusButton setTitle:@"Sent" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:textBlueColor.CGColor];
            [statusButton setTitleColor:textBlueColor forState:UIControlStateNormal];
            
            break;
        case 1:
            [statusButton setTitle:@"Remove" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:[UIColor redColor].CGColor];
            [statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            break;
        case 2:
            [statusButton setTitle:@"Accept" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:buttonGreenColor.CGColor];
            [statusButton setTitleColor:buttonGreenColor forState:UIControlStateNormal];
            
            break;
            
        case 5:
            [statusButton setTitle:@"Add" forState:UIControlStateNormal];
            [statusButton.layer setBorderColor:textBlueColor.CGColor];
            [statusButton setTitleColor:textBlueColor forState:UIControlStateNormal];
            break;
            
        default:
            break;

    }
    [statusButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchDown];
    [self resetDataShow];
}

-(void)addFriendsChildDetails:(NSString*)name profileImage:(UIImage*)image childAge:(NSString*)age cellHeight:(CGFloat)cellHeight
{
    [self resetData];
    cellImage  = image;
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    
    profileImage.frame=CGRectMake(cellPadding/2+5, ScreenHeightFactor, ScreenHeightFactor*48, ScreenHeightFactor*48);
    profileImage.image=image;
    profileImage.center=CGPointMake(profileImage.center.x,cellHeight/2);
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 0;
    profileImage.contentMode=UIViewContentModeScaleAspectFill;
    
    childNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    childNameLabel.text=name;
    childNameLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*30,displayValueSize.width,displayValueSize.height);
    childNameLabel.center=CGPointMake(childNameLabel.center.x,ScreenHeightFactor*30);
    childNameLabel.textColor=[UIColor blackColor];
    [childNameLabel sizeToFit];
    
    childAgeLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    NSString *str = @" Years Old";
    age = [NSString stringWithFormat:@"%@", age];
    
    age = [age stringByAppendingString:str];
    childAgeLabel.text=age;
    childAgeLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*50,displayValueSize.width+120,displayValueSize.height);
    childAgeLabel.center=CGPointMake(childAgeLabel.center.x,ScreenHeightFactor*50);
    childAgeLabel.textColor=[UIColor grayColor];
    
    
}

-(void)onButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *fStatus = button.titleLabel.text;
    if([fStatus isEqualToString:@"Add"])
    {
        SendFriendRequest *sendFriendRequest = [[SendFriendRequest alloc] init];
        [sendFriendRequest setServiceName:PinWiSendFriendRequest  ];
        [sendFriendRequest initService:@{
                                                @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                                @"FriendID":self.friendId
                                                }];
        
        
        [sendFriendRequest setDelegate:self];

        
        [statusButton setTitle:@"Sent" forState:UIControlStateNormal];
        statusButton.enabled = NO;
        statusButton.alpha = 0.80f;
       
    }
    
    if([fStatus isEqualToString:@"Remove"])
    {
        
        NSString *message = @"Are you sure you want to remove this connection from your network?";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        [alertView show];
        
        
    }
    
    if([fStatus isEqualToString:@"Accept"])
    {
        // NSString *actionFlag = [NSString stringWithFormat:@"%ld",(long)FriendStatus];
        UpdateStatusOnAction *updateStatusOnAction = [[UpdateStatusOnAction alloc] init];
        [updateStatusOnAction setServiceName:PinWiUpdateStatusOnAction  ];
        [updateStatusOnAction initService:@{
                                            @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                            @"FriendID":self.friendId,
                                            @"actionFlag":@"1"
                                            }];
        
        
        [updateStatusOnAction setDelegate:self];
        
                statusButton.enabled = NO;
        //        statusButton.alpha = 0.80f;
        
    }

    
}

-(void)addChildConnectionDetails:(NSString*)name profileImage:(UIImage*)image parentName:(NSString*)pName cellHeight:(CGFloat)cellHeight{
    
    [self resetData];
    cellImage  = image;
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    profileImage.image=image;
    if (screenWidth>700) {
        profileImage.frame=CGRectMake(cellPadding/2+5, ScreenHeightFactor*10, ScreenHeightFactor*48, ScreenHeightFactor*48);
        profileImage.center=CGPointMake(profileImage.center.x,cellHeight/2+10);
    }else{
        profileImage.frame=CGRectMake(cellPadding/2+5, ScreenHeightFactor*10, ScreenHeightFactor*48, ScreenHeightFactor*48);
        profileImage.center=CGPointMake(profileImage.center.x,cellHeight/2);
    }
   
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 0;
    profileImage.contentMode=UIViewContentModeScaleAspectFill;

    
    
    childNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    childNameLabel.text=name;
    if (screenWidth>700) {
        childNameLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*40,displayValueSize.width,displayValueSize.height);
        childNameLabel.center=CGPointMake(childNameLabel.center.x,ScreenHeightFactor*40);
    }else{
    childNameLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*30,displayValueSize.width,displayValueSize.height);
    childNameLabel.center=CGPointMake(childNameLabel.center.x,ScreenHeightFactor*30);
    }
    childNameLabel.textColor=[UIColor blackColor];
    [childNameLabel sizeToFit];
    
    statusButton = [[UIButton alloc] init];
    
    childAgeLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    childAgeLabel.text=pName;
    if (screenWidth>700) {
        childAgeLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*60,displayValueSize.width+120,displayValueSize.height);
        childAgeLabel.center=CGPointMake(childAgeLabel.center.x,ScreenHeightFactor*60);
    }else{
    childAgeLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*50,displayValueSize.width+120,displayValueSize.height);
    childAgeLabel.center=CGPointMake(childAgeLabel.center.x,ScreenHeightFactor*50);
    }
    childAgeLabel.textColor=[UIColor grayColor];
}



-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:PinWiSendFriendRequest]) {
        NSLog(@"PinWiSendFriendRequest error message %@",errorMessage);
    }
    if ([connection.serviceName isEqualToString:PinWiUpdateStatusOnAction]) {
        NSLog(@"PinWiUpdateStatusOnAction error message %@",errorMessage);
    }
    
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary *dict;
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:PinWiSendFriendRequest])
    {
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiSendFriendRequestResponse resultKey:PinWiSendFriendRequestResult];
    }
    
    if ([connection.serviceName isEqualToString:PinWiUpdateStatusOnAction])
    {
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiUpdateStatusOnActionResponse resultKey:PinWiUpdateStatusOnActionResult];

        if(self.removeFriendDelegate){
            connection = nil;
            [self.removeFriendDelegate updateList];
        }
        
       // [self removeFromSuperview];
    }
  
    
}


-(void)touchImage:(id)sender {
    
    
     // [imageView setFrame:];
    
    ImageView *imageView  =[[ImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [imageView drawImage:cellImage];
    
    AppDelegate *appDelegate  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate window]addSubview:imageView];
    [imageView setAlpha:0.0f];
    
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        //[imageView setFrame:[UIScreen mainScreen].bounds];
        [imageView setAlpha:1.0f];
    }completion:^(BOOL finished){
        
    }];
    
}





-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 1) {
        UpdateStatusOnAction *updateStatusOnAction = [[UpdateStatusOnAction alloc] init];
        [updateStatusOnAction setServiceName:PinWiUpdateStatusOnAction  ];
        [updateStatusOnAction initService:@{
                                            @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                            @"FriendID":self.friendId,
                                            @"actionFlag":@"3"
                                            }];
        
        
        [updateStatusOnAction setDelegate:self];
        
    }
    else
    {
        
        
    }
}

@end
