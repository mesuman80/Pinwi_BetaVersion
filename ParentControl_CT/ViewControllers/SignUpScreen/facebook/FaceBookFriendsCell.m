//
//  FaceBookFriendsCell.m
//  Amgine
//
//  Created by Yogesh Gupta on 09/02/15.
//
//

#import "FaceBookFriendsCell.h"
//#import "Data.h"
//#import "Contacts.h"
//#import "ContactData.h"

@implementation FaceBookFriendsCell
{
    UILabel *nameLabel;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *addRemovebuttonView;
    UILabel *addRemoveLabel;
    FaceBookFriends *fbFriends;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:nameLabel];
        
        self.profilePic =[[UIImageView alloc]init];
        [self.contentView addSubview:self.profilePic];
        
        activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.center = CGPointMake(30, 30);
        [self.contentView addSubview:activityIndicatorView];
        
        
         addRemovebuttonView =[[UIView alloc]initWithFrame:CGRectMake(230, 0,80,30)];
     //   [[Data sharedData]addBorderToUiView:addRemovebuttonView withBorderWidth:1.0 cornerRadius:0.0f Color:[UIColor lightGrayColor]];
        [self.contentView addSubview:addRemovebuttonView];
        
        addRemoveLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
       // [addRemoveLabel setFont:[UIFont fontWithName:AmgineFont size:12.0f]];
        [addRemovebuttonView addSubview:addRemoveLabel];

        UITapGestureRecognizer *tapAtAddRemoveButton=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAtCell:)];
        [addRemovebuttonView addGestureRecognizer:tapAtAddRemoveButton];
       
        
        return self;
    }
    return nil;
}
-(void)drawUI:(FaceBookFriends *)faceBookFriends
{
    self.profilePic.image=nil;
    fbFriends=faceBookFriends;
    if(!faceBookFriends.imageData)
    {
        [activityIndicatorView startAnimating];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:faceBookFriends.profilePicUrl]];
            UIImage *image = [UIImage imageWithData:data];
            faceBookFriends.imageData=data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self drawImage1:image];
            });
        });
    }
    else{
        [self drawImage:faceBookFriends];
    }
    NSString *labelText = faceBookFriends.userName;
  //  [nameLabel setFont:[UIFont fontWithName:AmgineFont size:14.0f]];
    if(labelText.length>25)
    {
        labelText=[labelText substringToIndex:22];
        labelText =[labelText stringByAppendingString:@"...."];
    }
    [nameLabel setText:labelText];
    CGSize labelsize = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:nameLabel.font}];
    [nameLabel setFrame:CGRectMake(50,8, labelsize.width, labelsize.height)];
    [self addRemoveButtonSetup:faceBookFriends isFromTap:NO];
    
}
-(void)drawImage:(FaceBookFriends *)faceBookFriends
{
     [activityIndicatorView stopAnimating];
    self.profilePic.image=[UIImage imageWithData:faceBookFriends.imageData];
    [self.profilePic setFrame:CGRectMake(2, 2, 40, 40)];
    [self.profilePic setCenter:CGPointMake(self.profilePic.center.x, 30)];
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    self.profilePic.clipsToBounds = YES;
     fbFriends=faceBookFriends;
    
}
-(void)drawImage1:(UIImage *)image
{
     [activityIndicatorView stopAnimating];
    self.profilePic.image=image;
    [self.profilePic setFrame:CGRectMake(2, 2, 40, 40)];
    [self.profilePic setCenter:CGPointMake(self.profilePic.center.x, 30)];
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    self.profilePic.clipsToBounds = YES;
    // fbFriends=faceBookFriends;
}
-(void)addRemoveTextSetUp :(NSString *)textStr
{
    [addRemoveLabel setText:textStr];
    CGSize addRemoveLabelSize=[addRemoveLabel.text sizeWithAttributes:@{NSFontAttributeName :addRemoveLabel.font}];
    [addRemoveLabel setFrame:CGRectMake(0,0, addRemoveLabelSize.width, addRemoveLabelSize.height)];
    [addRemovebuttonView setCenter:CGPointMake(addRemovebuttonView.center.x, self.frame.size.height/2.0f)];
    [addRemoveLabel setCenter:CGPointMake(addRemovebuttonView.frame.size.width/2.0f, addRemovebuttonView.frame.size.height/2.0f)];
}
-(void)addRemoveButtonSetup:(FaceBookFriends *)faceBookFriends isFromTap:(BOOL)isFromTap
{
    if(isFromTap)
    {
        faceBookFriends.isAddInFriendList=!faceBookFriends.isAddInFriendList;
    }
    if(faceBookFriends.isAddInFriendList)
    {
        [self addRemoveTextSetUp:@"Remove"];
        faceBookFriends.isAddInFriendList=YES;
       // [self saveContactsInLocal:faceBookFriends];
    }
    else
    {
        [self addRemoveTextSetUp:@"Add"];
        if(isFromTap)
        {
          //  [self deleteContacts:faceBookFriends];
        }
        
        faceBookFriends.isAddInFriendList=NO;
    }
    
     fbFriends=faceBookFriends;
}
-(void)tapAtCell:(UITapGestureRecognizer *)gestureRecognizer
{
    [self addRemoveButtonSetup:fbFriends isFromTap:YES];
}/*
-(void)saveContactsInLocal:(FaceBookFriends *)faceBookFriends
{
    BOOL isExist=NO;
    ContactData *contactData=[[Data sharedData]checkContactEntityExist:AmgineContactsData passengerName:faceBookFriends.userName withFriendType:AmgineFaceBookFriends withFriendId:faceBookFriends.faceBookId];
    
    NSManagedObjectContext *context=[[Data sharedData]getContext];
    NSMutableOrderedSet *set=[[NSMutableOrderedSet alloc]init];
    if(!contactData)
    {
        isExist=NO;
        contactData=[NSEntityDescription insertNewObjectForEntityForName:AmgineContactsData inManagedObjectContext:context];
    }
    else
    {
        isExist=YES;
    }
    contactData.friend_id=faceBookFriends.faceBookId;
    contactData.friendType= AmgineFaceBookFriends;
    contactData.name=faceBookFriends.userName;
    Contacts *contacts=nil;
    if(!isExist)
    {
        contacts =[NSEntityDescription insertNewObjectForEntityForName:AmgineContacts inManagedObjectContext:context];
    }
    else{
        contacts =[contactData.contacts objectAtIndex:0];
    }
    if(faceBookFriends.imageData)
    {
        contacts.imageData = faceBookFriends.imageData;
    }
    contacts.firstName= faceBookFriends.userName;
    contacts.friendfrom=AmgineFaceBookFriends;
    contacts.friend_id=faceBookFriends.faceBookId;
    [set addObject:contacts];
    contactData.contacts=set;
    [[Data sharedData]writeToDisk];
}
-(void)deleteContacts:(FaceBookFriends *)faceBookFriends
{
    ContactData *contactData=[[Data sharedData]checkContactEntityExist:AmgineContactsData passengerName:faceBookFriends.userName withFriendType:AmgineFaceBookFriends withFriendId:faceBookFriends.faceBookId];
    if(contactData)
    {
        NSManagedObjectContext *context=[[Data sharedData]getContext];
        [context deleteObject:contactData];
        [[Data sharedData] writeToDisk];

    }
    
}

*/

@end
