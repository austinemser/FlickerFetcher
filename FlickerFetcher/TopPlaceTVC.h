//
//  TopPlaceTVC.h
//  FlickerFetcher
//
//  Created by Austin Emser on 7/30/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface TopPlaceTVC : UITableViewController <UISplitViewControllerDelegate, SplitViewBarButtonItemPresenter>
@property (nonatomic, strong) NSArray *flickrTopPlaces;
@end
