//
//  WebPageViewController.h
//  Pin_Tel
//
//  Created by Veenus Chhabra on 06/10/14.
//  Copyright (c) 2014 mvn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebPageViewController : UIView<UIWebViewDelegate>
{
    UIWebView *webView;
}
-(id)initWithWebString:(NSString *)str frame:(CGRect)frame;
- (void)drawWebView:(NSString *)link;
@end
