//
//  PicViewController.h
//  KingYun
//
//  Created by Line_Hu on 14-5-12.
//  Copyright (c) 2014年 Cartman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicViewController : UIViewController
@property (strong, nonatomic) NSData *imgData;
- (id)initWithData:(NSData *)imageData;
@end
