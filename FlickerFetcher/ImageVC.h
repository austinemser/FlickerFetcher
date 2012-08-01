//
//  ImageVC.h
//  FlickerFetcher
//
//  Created by Austin Emser on 8/1/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageVC : UIViewController
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, weak) UIImage *image;
@end
