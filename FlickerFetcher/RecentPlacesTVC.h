//
//  RecentPlacesTVC.h
//  FlickerFetcher
//
//  Created by Austin Emser on 8/1/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecentPlacesTVC;
@protocol RecentPlacesTVCDelegate <NSObject>

@optional
-(void)recentPlacesTVC:(RecentPlacesTVC *)sender
         choseImageURL:(NSURL *)imageURL;
@end

@interface RecentPlacesTVC : UITableViewController
@property (nonatomic, strong) NSArray *recentPlaces;
@property (nonatomic, weak) id <RecentPlacesTVCDelegate> delegate;
@end
