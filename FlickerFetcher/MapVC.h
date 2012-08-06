//
//  MapVC.h
//  FlickerFetcher
//
//  Created by Austin Emser on 8/6/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapVC;

@protocol MapVCDelegate <NSObject>

-(UIImage *)mapVC:(MapVC *)sender imageForAnnotation:(id <MKAnnotation>)annotation;

@end

@interface MapVC : UIViewController
@property (nonatomic, strong) NSArray *annotations; //type id annotation
@property (nonatomic, weak) id <MapVCDelegate> delegate;
@end
