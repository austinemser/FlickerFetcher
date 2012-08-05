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
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation ImageVC
@synthesize scrollView;
@synthesize imageView;
@synthesize toolBar;
@synthesize imageURL = _imageURL;
@synthesize image = _image;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

-(void)setImageURL:(NSURL *)imageURL
{
    if(_imageURL != imageURL)
    {
        _imageURL = imageURL;
        [self viewDidLoad];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if(_splitViewBarButtonItem != splitViewBarButtonItem){
        NSMutableArray *toolBarItems = [self.toolBar.items mutableCopy];
        if(_splitViewBarButtonItem) [toolBarItems removeObject:_splitViewBarButtonItem];
        if(splitViewBarButtonItem) [toolBarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolBar.items = toolBarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner hidesWhenStopped];
    [spinner startAnimating];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    }
	dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
        dispatch_async(dispatch_get_current_queue(), ^{
            [spinner stopAnimating];
            self.image = [UIImage imageWithData:imageData];
            self.imageView.image = self.image;
            self.scrollView.delegate = self;
            self.imageView.frame = CGRectMake(0,0, self.imageView.image.size.width, self.imageView.image.size.height);
            self.scrollView.contentSize = self.imageView.image.size;
        });
    });
    dispatch_release(downloadQueue);
}

- (void)viewDidUnload
{
    self.imageURL = nil;
    [self setScrollView:nil];
    [self setImageView:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
