//
//  MapVC.m
//  FlickerFetcher
//
//  Created by Austin Emser on 8/6/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import "MapVC.h"
#import "ImageVC.h"
#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher/FlickrFetcher.h"

@interface MapVC () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapVC
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

-(void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)updateMapView
{
    if(self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if(self.annotations) [self.mapView addAnnotations:self.annotations];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("Download Queue", NULL);
    dispatch_async(downloadQueue, ^{
        NSDictionary *image = [self.delegate mapVC:self imageForAnnotation:aView.annotation];
        dispatch_async(dispatch_get_main_queue(),  ^{
            if([aView.annotation.title isEqualToString:[image objectForKey:@"id"]]){
                [(UIImageView *)aView.leftCalloutAccessoryView setImage:[image objectForKey:@"image"]];
            }
        });
    });
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"Accessory Tapped Segue" sender:view.annotation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Accessory Tapped Segue"])
    {
        FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)sender;
        NSDictionary *photo = fpa.photo;
        [segue.destinationViewController setImageURL:[FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.mapView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
