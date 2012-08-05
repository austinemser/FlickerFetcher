//
//  PhotosInPlaceTVC.h
//  FlickerFetcher
//
//  Created by Austin Emser on 7/31/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosInPlaceTVC : UITableViewController
@property (nonatomic, strong) NSDictionary *place;
@property (nonatomic, strong) NSArray *photosInPlace;
@end
