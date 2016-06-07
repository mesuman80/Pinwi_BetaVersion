//
//  ImageUpload.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 17/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ImageUpload.h"

@interface ImageUpload()

@end

@implementation ImageUpload

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void)imageSelection
{
UIActionSheet *actionSheet = [[UIActionSheet alloc]
                              initWithTitle:nil
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"Take Photo",@"Camera Roll",nil];

[actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // NSLog(@"media state=%u",media.state);
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Take Photo"])
    {
        [self takePhotoOrVideo];
        
    }
    else if([buttonTitle isEqualToString:@"Camera Roll"])
    {
        [self pickImage];
    }
}
 
 */
 
 
-(void)takePhotoOrVideo
{
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:imagePicker animated:YES completion:nil];
       // }
        
        // imagePickerController=imagePicker;
        //newMedia = YES;
    }
}


-(void)pickImage
{
    if ([self hasValidAPIKey])
    {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [imagePicker setDelegate:self];
        
       // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:imagePicker animated:YES completion:nil];
       // }
    }
}

 -(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
 {
           NSString *mediaType = info[UIImagePickerControllerMediaType];
          [self dismissViewControllerAnimated:YES completion:nil];
 // imagePickerController=nil;
        UIImage *image = info[UIImagePickerControllerOriginalImage];
 //  [self compressImage:image];
 
 
 }
 
 -(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
 {
 if (error)
 {
     UIAlertView *alert = [[UIAlertView alloc]
                           initWithTitle: @"Save failed"
                           message: @"Go To Settings/Privacy/photos-allow to Save photo On Gallery"
                           delegate: nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
     [alert show];
 }
 }
 -(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
 {
 //imagePickerController=nil;
 [self dismissViewControllerAnimated:YES completion:nil];
 }


#pragma mark - Status Bar Style

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Helper Methods

- (BOOL) hasValidAPIKey
{
    return YES;
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
