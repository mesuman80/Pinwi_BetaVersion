//
//  SplitTextController_VC.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 30/09/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import "SplitTextController_VC.h"
#import "Constant.h"
#import "PC_DataManager.h"
#import "HeaderView.h"

@interface SplitTextController_VC ()<UITextFieldDelegate, HeaderViewProtocol>

@end

@implementation SplitTextController_VC
{
    int yy;
    HeaderView *headerView;
    UITextField *textField;
    BOOL isTextFieldEmpty;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:appBackgroundColor];
    [self drawHeaderView];
    [self setUpTextField];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:@"Save"];
        [headerView setCentreImgName:@"Location_header.png"];
        [headerView drawHeaderViewWithTitle:self.headString isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
        
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+30*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }
    }
}

-(void)setUpTextField
{
   textField=[[UITextField alloc]initWithFrame:CGRectMake(cellPadding, 150*ScreenHeightFactor, ScreenWidthFactor*320-2*cellPadding, 60*ScreenHeightFactor)];
    [textField setValue:placeHolderReg forKeyPath:@"_placeholderLabel.textColor"];
    [textField setText:[self textString1]];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setFont:[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor]];
    [self.view addSubview:textField];
    textField.delegate=self;
   
    UIView *lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:textField.center.x andYPos:textField.frame.size.height+textField.frame.origin.y-1*ScreenHeightFactor withScrnWid:screenWidth withScrnHt:1*ScreenHeightFactor ofColor:lineTextColor];
    [self.view addSubview:lineView];
    
   lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:textField.center.x andYPos:textField.frame.origin.y withScrnWid:screenWidth withScrnHt:1*ScreenHeightFactor ofColor:lineTextColor];
    [self.view addSubview:lineView];
    
    [textField becomeFirstResponder];
    
}


- (BOOL)textField:(UITextField *)textField1 shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if(textField1.text.length>=50)
    {
        [textField1 resignFirstResponder];
        return NO;
    }
    
   
    return YES;
}


-(void)touchAtBackButton
{
    // [self textString];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getMenuTouches
{
    [self textString];
     [self.navigationController popViewControllerAnimated:YES];
}

-(NSString*)textString1
{
    if([self.parentName isEqualToString:FlatText])
    {
        return  [PC_DataManager sharedManager].flatText;
    }
    else if([self.parentName isEqualToString:StreetText])
    {
        return [PC_DataManager sharedManager].streettext;
    }
    return nil;
}

-(NSString*)textString
{
    if([self.parentName isEqualToString:FlatText])
    {
        if ((textField.text == NULL)) {
            [PC_DataManager sharedManager].parentObjectInstance.flatBuilding= @"";
            return [PC_DataManager sharedManager].flatText = @"";
        }
        else{
            [PC_DataManager sharedManager].parentObjectInstance.flatBuilding=textField.text;
            return [PC_DataManager sharedManager].flatText = textField.text;
        }
    }
    else if([self.parentName isEqualToString:StreetText])
    {
        if ((textField.text == NULL)) {
            [PC_DataManager sharedManager].parentObjectInstance.streetLocality= @"";
            return [PC_DataManager sharedManager].streettext = @"";
         }
        else{
            [PC_DataManager sharedManager].parentObjectInstance.streetLocality=textField.text;
            return [PC_DataManager sharedManager].streettext = textField.text;
        }
    }
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
