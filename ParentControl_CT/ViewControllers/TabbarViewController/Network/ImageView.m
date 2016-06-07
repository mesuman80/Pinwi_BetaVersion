//
//  ImageView.m
//  ParentControl_CT
//
//  Created by Yogesh on 11/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawImage:(UIImage *)image {
    [self setBackgroundColor:[UIColor whiteColor]];
     UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [imageView setImage:image];
    [self addSubview:imageView];
    [self cancel];
}

-(void)cancel {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-80, 10, 70, 70)];
    [button setTintColor:[UIColor blueColor]];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchAtCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void)touchAtCancel:(id)sender {
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        //[imageView setFrame:[UIScreen mainScreen].bounds];
        [self setAlpha:0.0f];
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end
