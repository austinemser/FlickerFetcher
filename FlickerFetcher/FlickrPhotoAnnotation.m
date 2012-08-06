//
//  FlickrPhotoAnnotation.m
//  FlickerFetcher
//
//  Created by Austin Emser on 8/6/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher/FlickrFetcher.h"

@implementation FlickrPhotoAnnotation

@synthesize photo = _photo;

+(FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo
{
    FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}

- (NSString *)title
{
    return [self.photo objectForKey:@"id"];
}

- (NSString *)subtitle
{
    return [self.photo valueForKeyPath:@"id"];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}


@end
