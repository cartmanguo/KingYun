//
//  AuthViewController.h
//  KingYun
//
//  Created by Cartman on 14-5-8.
//  Copyright (c) 2014年 Cartman. All rights reserved.
//
@protocol DismissVCDelegate <NSObject>
@optional
- (void)passVerStr:(NSString *)verStr;
@end
#import <UIKit/UIKit.h>

@interface AuthViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *wb;
}
@property (weak, nonatomic) id<DismissVCDelegate>delegate;
@property (copy, nonatomic) NSString *tempToken;
@property (copy, nonatomic) NSString *verStr;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)dismissVC:(id)sender;
@end
