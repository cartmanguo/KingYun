//
//  ViewController.m
//  KingYun
//
//  Created by Cartman on 14-5-7.
//  Copyright (c) 2014年 Cartman. All rights reserved.
//

#import "ViewController.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "GTMBase64.h"
#import "NSString+Encode.h"
#import "AuthViewController.h"
#import "PicViewController.h"

@interface ViewController ()<DismissVCDelegate>
{
    NSArray *numbers;
    AuthViewController *aut;
}
@property (copy, nonatomic) NSString *verStr;
@property (copy, nonatomic) NSString *unAuth_token;
@property (copy, nonatomic) NSString *auth_secret;
@property (copy, nonatomic) NSString *authedToken;
@property (copy, nonatomic) NSString *authedSecret;
@property (copy, nonatomic) NSString *uploadUrl;
@end

@implementation ViewController
- (void)viewDidLoad
{
     aut = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Auth"];
//    NSString *secret = [@"q51A9BRu9eSOHEHF&" stringByAppendingString:@"6dffe69389b9426c915d982ca820684d"];
//    NSString *rt = [self hmac:@"POST&http%3A%2F%2Fp4.dfs.kuaipan.cn%2Fcdlnode%2F1%2Ffileops%2Fupload_file&oauth_consumer_key%3DxcNZwXroR0jZrImI%26oauth_nonce%3DERDVF3wz%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1399859031%26oauth_token%3D03d442ef4c316c4c51967b1d%26oauth_version%3D1.0%26overwrite%3Dtrue%26path%3D%252Fabc.txt%26root%3Dapp_folder" withKey:secret];
//    NSString *encodedString = [rt stringByURLEncodingStringParameter];
//    NSLog(@"enc:%@",encodedString);
    [super viewDidLoad];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"tokenKey"]!= nil)
    {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenKey"];
        _authedToken = token;
        NSString *sec = [[NSUserDefaults standardUserDefaults] objectForKey:@"secKey"];
        _authedSecret = sec;
    }
    numbers = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@0];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)createRandomNumber
{
    NSString *s = @"";
    for (int i = 0; i<=6; i++)
    {
        int rdIndex = arc4random()%10;
        int num = [[numbers objectAtIndex:rdIndex] integerValue];
        s = [s stringByAppendingString:[NSString stringWithFormat:@"%d",num]];
    }
    return [s integerValue];
}

- (NSString *)encodeSrcString:(NSString *)srcString withSecret:(NSString *)secret
{
    NSString *signa = [self hmac:srcString withKey:secret];
    NSLog(@"signa:%@",signa);
    NSString *encodedString = [signa stringByURLEncodingStringParameter];
    NSLog(@"enc:%@",encodedString);
    return encodedString;
}

- (void)createFolder
{
    NSString *s = @"";
    for (int i = 0; i<=6; i++)
    {
        int rdIndex = arc4random()%10;
        int num = [[numbers objectAtIndex:rdIndex] integerValue];
        s = [s stringByAppendingString:[NSString stringWithFormat:@"%d",num]];
    }
    NSInteger nonce = [s integerValue];
    NSTimeInterval timeSince = [[NSDate date] timeIntervalSince1970];
    NSString *src = [NSString stringWithFormat:@"GET&http%%3A%%2F%%2Fopenapi.kuaipan.cn%%2F1%%2Ffileops%%2Fcreate_folder&oauth_consumer_key%%3DxcNZwXroR0jZrImI%%26oauth_nonce%%3D%d%%26oauth_signature_method%%3DHMAC-SHA1%%26oauth_timestamp%%3D%.0f%%26oauth_token%%3D%@%%26oauth_version%%3D1.0%%26path%%3Dtestdemo%%26root%%3Dapp_folder",nonce,timeSince,_authedToken];
    NSLog(@"src:%@",src);
    NSString *secret = [@"q51A9BRu9eSOHEHF&" stringByAppendingString:_authedSecret];
    NSLog(@"%@",secret);
    NSString *signa = [self hmac:src withKey:secret];
    NSLog(@"signa:%@",signa);
    NSString *encodedString = [signa stringByURLEncodingStringParameter];
    NSLog(@"enc:%@",encodedString);
    NSString *reqStr = [NSString stringWithFormat:@"http://openapi.kuaipan.cn/1/fileops/create_folder?oauth_signature=%@&oauth_consumer_key=xcNZwXroR0jZrImI&oauth_nonce=%d&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%.0f&oauth_token=%@&oauth_version=1.0&path=testdemo&root=app_folder",encodedString,nonce,timeSince,_authedToken];
    NSLog(@"req:%@",reqStr);
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:reqStr] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"rt:%@",result);
}

- (IBAction)download:(id)sender
{
    NSInteger random = [self createRandomNumber];
    NSTimeInterval timeSince = [[NSDate date] timeIntervalSince1970];
    NSString *secret = [@"q51A9BRu9eSOHEHF&" stringByAppendingString:_authedSecret];

    NSString *src = [NSString stringWithFormat:@"GET&http%%3A%%2F%%2Fapi-content.dfs.kuaipan.cn%%2F1%%2Ffileops%%2Fdownload_file&oauth_consumer_key%%3DxcNZwXroR0jZrImI%%26oauth_nonce%%3D%d%%26oauth_signature_method%%3DHMAC-SHA1%%26oauth_timestamp%%3D%.0f%%26oauth_token%%3D%@%%26oauth_version%%3D1.0%%26path%%3D%%252Ftestdemo%%252Fqb.jpg%%26root%%3Dapp_folder",random,timeSince,_authedToken];
    
    NSString *encodeSig = [self encodeSrcString:src withSecret:secret];
    NSString *reqStr = [NSString stringWithFormat:@"http://api-content.dfs.kuaipan.cn/1/fileops/download_file?oauth_signature=%@&oauth_consumer_key=xcNZwXroR0jZrImI&oauth_nonce=%d&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%.0f&oauth_token=%@&oauth_version=1.0&path=%%2Ftestdemo%%2Fqb.jpg&root=app_folder",encodeSig,random,timeSince,_authedToken];
    NSURLRequest *downloadReq = [NSURLRequest requestWithURL:[NSURL URLWithString:reqStr]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:downloadReq completionHandler:^(NSURL *location,NSURLResponse *resp,NSError *err)
      {
          if (!err)
          {
              NSLog(@"download ok");
              dispatch_async(dispatch_get_main_queue(), ^{
                  PicViewController *pic = [[PicViewController alloc] initWithData:[NSData dataWithContentsOfURL:location]];
                  [self.navigationController pushViewController:pic animated:YES];
              });
              
          }
          [session invalidateAndCancel];
      }];
    [downloadTask resume];
}

- (IBAction)createF:(id)sender
{
    [self createFolder];
}

- (void)uploadTest
{
    NSString *s = @"";
    for (int i = 0; i<=6; i++)
    {
        int rdIndex = arc4random()%10;
        int num = [[numbers objectAtIndex:rdIndex] integerValue];
        s = [s stringByAppendingString:[NSString stringWithFormat:@"%d",num]];
    }
    NSInteger nonce = [s integerValue];
    NSTimeInterval timeSince = [[NSDate date] timeIntervalSince1970];
    NSString *src = [NSString stringWithFormat:@"GET&http%%3A%%2F%%2Fapi-content.dfs.kuaipan.cn%%2F1%%2Ffileops%%2Fupload_locate&oauth_consumer_key%%3DxcNZwXroR0jZrImI%%26auth_token%%3D%@%%26oauth_nonce%%3D%d%%26oauth_signature_method%%3DHMAC-SHA1%%26oauth_timestamp%%3D%.0f%%26oauth_version%%3D1.0",_authedToken,nonce,timeSince];
    NSString *secret = [@"q51A9BRu9eSOHEHF&" stringByAppendingString:_authedSecret];
    NSString *signa = [self hmac:src withKey:secret];
    NSLog(@"signa:%@",signa);
    NSString *encodedString = [signa stringByURLEncodingStringParameter];
    NSLog(@"enc:%@",encodedString);
    NSString *reqStr = [NSString stringWithFormat:@"http://api-content.dfs.kuaipan.cn/1/fileops/upload_locate?oauth_consumer_key=xcNZwXroR0jZrImI&auth_token=%@&oauth_nonce=%d&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%.0f&oauth_version=1.0",_authedToken,nonce,timeSince];
    NSLog(@"req:%@",reqStr);
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:reqStr] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"rt:%@",result);
    if(result)
    {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSString *uploadUrlStr = [[json objectForKey:@"url"] stringByAppendingString:@"1/fileops/upload_file"];
    _uploadUrl = [uploadUrlStr stringByURLEncodingStringParameter];
    NSLog(@"%@",_uploadUrl);
    NSString *host = [[json objectForKey:@"url"] substringFromIndex:7];
        NSInteger index = [host rangeOfString:@"/"].location;
        NSLog(@"loc:%d",index);
        host = [host substringToIndex:index];
        NSLog(@"host:%@",host);
    NSString *boundary =@"Boundary+2D3851CB1EFDDF18";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSData *body = [self prepareDataForUpload];
        
        NSString *s = @"";
        for (int i = 0; i<=6; i++)
        {
            int rdIndex = arc4random()%10;
            int num = [[numbers objectAtIndex:rdIndex] integerValue];
            s = [s stringByAppendingString:[NSString stringWithFormat:@"%d",num]];
        }
        NSTimeInterval timeSince = [[NSDate date] timeIntervalSince1970];
        NSInteger nonce = [s integerValue];
        NSString *src = [NSString stringWithFormat:@"POST&%@&oauth_consumer_key%%3DxcNZwXroR0jZrImI%%26oauth_nonce%%3D%d%%26oauth_signature_method%%3DHMAC-SHA1%%26oauth_timestamp%%3D%.0f%%26oauth_token%%3D%@%%26oauth_version%%3D1.0%%26overwrite%%3Dtrue%%26path%%3D%%252Ftestdemo%%252Fmh.jpg%%26root%%3Dapp_folder",_uploadUrl,nonce,timeSince,_authedToken];
        NSLog(@"src:%@",src);
       
        NSString *secret = [@"q51A9BRu9eSOHEHF&" stringByAppendingString:_authedSecret];
        NSString *signa = [self hmac:src withKey:secret];
        NSLog(@"signa:%@",signa);
        NSString *encodedString = [signa stringByURLEncodingStringParameter];
        NSString *reqStr = [NSString stringWithFormat:@"%@?oauth_signature=%@&oauth_consumer_key=xcNZwXroR0jZrImI&oauth_nonce=%d&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%.0f&oauth_token=%@&oauth_version=1.0&overwrite=true&path=%%2Ftestdemo%%2Fmh.jpg&root=app_folder",uploadUrlStr,encodedString,nonce,timeSince,_authedToken];
        NSLog(@"req:%@",reqStr);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:reqStr]];
        [request setHTTPMethod:@"POST"];
         
        //NSURLSessionUploadTask不会自动添加Content-Type头
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d",[body length]] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
        [request setValue:host forHTTPHeaderField:@"Host"];//YOU!!!!!!host处需要填返回的上传url//
        [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
        //[request setValue:@"klive" forHTTPHeaderField:@"User-Agent"];
        //NSLog(@"123:%@",[request HTTPMethod]);
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            if (error)
            {
                NSLog(@"err:%@",[error localizedDescription]);
            }
            NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"message: %@", message);
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            if([json objectForKey:@"size"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OK"
                                                                    message:@"Upload ok"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                });
                
            }
            [session invalidateAndCancel];
        }];
        [uploadTask resume];
    });
    }

}

- (NSData*) prepareDataForUpload
{
    NSString *uploadFilePath = [[NSBundle mainBundle] pathForResource:@"mh" ofType:@"jpg"];
    NSString *fileName = [uploadFilePath lastPathComponent];
    //NSLog(@"%@",fileName);
    NSMutableData *body = [NSMutableData data];
    
    NSData *dataOfFile = [NSData dataWithContentsOfFile:uploadFilePath];
    NSString *boundary =@"Boundary+2D3851CB1EFDDF18";
    if (dataOfFile) {
        NSString *fileParam = @"file";
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileParam, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: Multipart/form-data\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //注意Content-Type后还需要加一个\r\n,然后才放数据部分
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:dataOfFile];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%d",[body length]);
    return body;
}

- (IBAction)upload:(id)sender
{
    [self uploadTest];
}

- (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [GTMBase64 stringByEncodingData:HMAC];
    
    return hash;
}



- (IBAction)getToken:(id)sender
{
    NSString *s = @"";
    for (int i = 0; i<=6; i++)
    {
        int rdIndex = arc4random()%10;
        int num = [[numbers objectAtIndex:rdIndex] integerValue];
        s = [s stringByAppendingString:[NSString stringWithFormat:@"%d",num]];
    }
    NSInteger nonce = [s integerValue];
    NSTimeInterval timeSince = [[NSDate date] timeIntervalSince1970];
    NSString *src = [NSString stringWithFormat:@"GET&https%%3A%%2F%%2Fopenapi.kuaipan.cn%%2Fopen%%2FrequestToken&oauth_consumer_key%%3DxcNZwXroR0jZrImI%%26oauth_nonce%%3D%d%%26oauth_signature_method%%3DHMAC-SHA1%%26oauth_timestamp%%3D%.0f%%26oauth_version%%3D1.0",nonce,timeSince];
    NSString *secret = @"q51A9BRu9eSOHEHF&";
    NSLog(@"src:%@",src);
    NSString *signa = [self hmac:src withKey:secret];
    NSLog(@"signa:%@",signa);
    NSString *encodedString = [signa stringByURLEncodingStringParameter];
    NSLog(@"enc:%@",encodedString);
    NSString *reqStr = [NSString stringWithFormat:@"https://openapi.kuaipan.cn/open/requestToken?oauth_signature=%@&oauth_consumer_key=xcNZwXroR0jZrImI&oauth_nonce=%d&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%.0f&oauth_version=1.0",encodedString,nonce,timeSince];
    NSLog(@"req:%@",reqStr);
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:reqStr] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"rt:%@",result);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"json:%@",json);
    NSString *tempToken = [json objectForKey:@"oauth_token"];
    _auth_secret = [json objectForKeyedSubscript:@"oauth_token_secret"];
    
    aut.tempToken = tempToken;
    _unAuth_token = tempToken;
    aut.delegate = self;

    [self presentViewController:aut animated:YES completion:nil];
}

- (void)passVerStr:(NSString *)verStr
{
    _verStr = verStr;
    
    NSString *s = @"";
    for (int i = 0; i<=6; i++)
    {
        int rdIndex = arc4random()%10;
        int num = [[numbers objectAtIndex:rdIndex] integerValue];
        s = [s stringByAppendingString:[NSString stringWithFormat:@"%d",num]];
    }
    NSInteger nonce = [s integerValue];
    NSTimeInterval timeSince = [[NSDate date] timeIntervalSince1970];
    NSString *secret = [@"q51A9BRu9eSOHEHF&" stringByAppendingString:_auth_secret];
    NSLog(@"sec:%@",secret);
    NSString *src = [NSString stringWithFormat:@"GET&https%%3A%%2F%%2Fopenapi.kuaipan.cn%%2Fopen%%2FaccessToken&oauth_consumer_key%%3DxcNZwXroR0jZrImI%%26oauth_nonce%%3D%d%%26oauth_signature_method%%3DHMAC-SHA1%%26oauth_timestamp%%3D%.0f%%26oauth_token%%3D%@%%26oauth_version%%3D1.0",nonce,timeSince,_unAuth_token];
    NSLog(@"src:%@",src);
    NSString *signa = [self hmac:src withKey:secret];
    NSLog(@"signa:%@",signa);
    NSString *encodedString = [signa stringByURLEncodingStringParameter];
    NSLog(@"enc:%@",encodedString);
    NSString *reqStr = [NSString stringWithFormat:@"https://openapi.kuaipan.cn/open/accessToken?oauth_signature=%@&oauth_consumer_key=xcNZwXroR0jZrImI&oauth_nonce=%d&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%.0f&oauth_token=%@&oauth_version=1.0",encodedString,nonce,timeSince,_unAuth_token];
    NSLog(@"reqStr:%@",reqStr);
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:reqStr] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"rt:%@",result);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSString *authToken = [json objectForKey:@"oauth_token"];
    NSString *authTokenSecret = [json objectForKey:@"oauth_token_secret"];
    NSString *dir = [json objectForKey:@"charged_dir"];
    _authedToken = authToken;
    _authedSecret = authTokenSecret;
    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:@"tokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:authTokenSecret forKey:@"secKey"];
    [[NSUserDefaults standardUserDefaults] setObject:dir forKey:@"dirKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//GET&https%3A%2F%2Fopenapi.kuaipan.cn%2Fopen%2FaccessToken&oauth_consumer_key%3DxcNZwXroR0jZrImI%26oauth_nonce%3D1605917%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1399538911%26oauth_token%3D7d7049fdd02d4596b122801fcf2ac680%26oauth_version%3D1.0%26oauth_verifier%3D502922482
//GET&https%3A%2F%2Fopenapi.kuaipan.cn%2Fopen%2FaccessToken&oauth_consumer_key%3DxcNZwXroR0jZrImI%26oauth_nonce%3Db1wBd19k%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1399536557%26oauth_token%3D4f3df68caa4d4210adaa447bc9e39221%26oauth_version%3D1.0
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
