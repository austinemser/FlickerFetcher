//
//  FlickrPhotoAnnotation.h
//  FlickerFetcher
//
//  Created by Austin Emser on 8/6/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

+(FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo;

@property (nonatomic, strong) NSDictionary *photo;

@end
