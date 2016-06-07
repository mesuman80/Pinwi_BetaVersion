//
//  TimePicker.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AutoLockPicker.h"
#import "CancelDoneToolBar.h"

@implementation AutoLockPicker
{
    NSMutableArray *pickerData;
    NSDictionary *autoLockTime;
    NSString *type;
}
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self getAutolocktime];
        return self;
    }
    return nil;
}


-(void)getAutolocktime
{
    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetAutolockTime"];
    if(dict)
    {
        [self loadTableDataWith:dict];
    }else{
    
    GetAutolockTime *getAutolock=[[GetAutolockTime alloc]init];
    [getAutolock initService:@{
                               
                               }];
    getAutolock.serviceName=@"GetAutolockTime";
    [getAutolock setDelegate:self];
    }
    
    
   
}
-(void)loadTableDataWith:(NSDictionary*)dict{
    
    NSLog(@"Country....:   %@", dict);
    pickerData = [[NSMutableArray alloc]init];
    for (NSDictionary *cityDict in dict) {
        [pickerData addObject:cityDict];
    }// Store in the dictionary using the data as the key
  //  [self pickerView:@"Autolock"];
    
    
     autoLockTime  = [pickerData objectAtIndex:0];
    
}

-(void)pickerView:(NSString*)pickerType
{
//    type=pickerType;
//  //  autoLockTime = @"0";
//    
//    pickerData = [[NSMutableArray alloc]init];
//    
//    if([type isEqualToString:@"Autolock"])
//    {
//    pickerData = [@[@"1",@"3",@"5",@"10",@"15",@"30",@"45" ]mutableCopy];
//        
//        
//    }
    [self getAutolocktime];
    CancelDoneToolBar *cancelDoneToolBar = [[CancelDoneToolBar alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,50)];
    [cancelDoneToolBar setBackgroundColor:[UIColor whiteColor]];
    [cancelDoneToolBar setDelegate:self];
    [cancelDoneToolBar drawButtons];
    [self addSubview:cancelDoneToolBar];
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,50,self.frame.size.width,self.frame.size.height)];
    [pickerView setBackgroundColor:[UIColor grayColor]];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
     pickerView.showsSelectionIndicator = YES;
    [self addSubview:pickerView];
    [pickerView setBackgroundColor:[UIColor whiteColor]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
    {
        return pickerData.count;
    }
    else
    {
        return 1;
    }
    
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
    {
      return [pickerData[row] objectForKey:@"TimeValue"];
    }
    else
    {
        if([type isEqualToString:@"Autolock"]){
            return @"min(s)";
        }
    
        else if ([type isEqualToString:@"Radius"])
        {
            return @"Km(s)";
        }
    }
    return nil;
}
   

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    if(component==0)
        autoLockTime  = [pickerData objectAtIndex:row];
}
#pragma mark toolBar Specific Functions
-(void)touchAtDoneButton:(CancelDoneToolBar *)cancelDoneToolBar
{
    NSArray *arr=[[autoLockTime objectForKey:@"TimeValue"] componentsSeparatedByString:@" "];
    [[NSUserDefaults standardUserDefaults]setObject:[arr firstObject] forKey:@"AutoLockTime"];
    
    self.textField.text  = [autoLockTime objectForKey:@"TimeValue"];
    self.autoDict=[autoLockTime mutableCopy];
    [self.autoDelegate autoLock:self.autoDict];
    [self.textField resignFirstResponder];
}
-(void)touchAtCancelButton:(CancelDoneToolBar *)cancelDoneToolBar
{
    [self.textField resignFirstResponder];
}


#pragma mark connection delegates
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    //[self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetAutolockTimeResponse" resultKey:@"GetAutolockTimeResult"];
    [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:@"GetAutolockTime"];
    
    [self loadTableDataWith:dict];
    //[self removeLoaderView];
    
}



@end
