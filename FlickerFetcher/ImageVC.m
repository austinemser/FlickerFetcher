//
//  ImageVC.m
//  FlickerFetcher
//
//  Created by Austin Emser on 8/1/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import "ImageVC.h"

@interface ImageVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ImageVC
@synthesize scrollView;
@synthesize imageView;
@synthesize imageURL;
@synthesize image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
    self.image = [UIImage imageWithData:imageData];
    self.imageView.image = self.image;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0,0, self.imageView.image.size.width, self.imageView.image.size.height);
    
}

- (void)viewDidUnload
{
    self.imageURL = nil;
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
