//
//  AuthViewController.m
//  KingYun
//
//  Created by Cartman on 14-5-8.
//  Copyright (c) 2014年 Cartman. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *authurl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.kuaipan.cn/api.php?ac=open&op=authorise&oauth_token=%@",self.tempToken]];
    self.webView.delegate = self;
    NSURLRequest *req = [NSURLRequest requestWithURL:authurl];
    [self.webView loadRequest:req];
    // Do any additional setup after loading the view from its nib.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('div')[6].innerHTML";
    
    NSString *HTMLSource = [self.webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    
    NSLog(@"%@",HTMLSource);
    NSString *s = @"授权码";
    //NSLog(@"len:%d",[HTMLSource length]);
    s = [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if([HTMLSource rangeOfString:s].location > 0&&[HTMLSource length] == 30)
    {
        NSString *authCodeStr = [HTMLSource substringFromIndex:12];
        NSLog(@"step1:%@",authCodeStr);
        NSString *finalCode = [authCodeStr substringToIndex:9];
        NSLog(@"final:%@",finalCode);
        self.verStr = finalCode;
        [self.delegate passVerStr:_verStr];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",[[request URL] absoluteString]);
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //self.webView = nil;
}

- (IBAction)dismissVC:(id)sender {
    NSLog(@"ready to dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.webView loadHTMLString:@"" baseURL:nil];
}
@end
