//
//  PhotosInPlaceTVC.m
//  FlickerFetcher
//
//  Created by Austin Emser on 7/31/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import "PhotosInPlaceTVC.h"
#import "ImageVC.h"
#import "FlickrFetcher/FlickrFetcher.h"
#import "MapVC.h"
#import "FlickrPhotoAnnotation.h"

@interface PhotosInPlaceTVC ()

@end

@implementation PhotosInPlaceTVC

@synthesize place = _place;
@synthesize photosInPlace = _photosInPlace;

-(void)setPhotosInPlace:(NSArray *)photosInPlace
{
    if(_photosInPlace != photosInPlace)
    {
        _photosInPlace = photosInPlace;
        [self.tableView reloadData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photosInPlace count]];
    for(NSDictionary *photo in self.photosInPlace)
    {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner hidesWhenStopped];
    [spinner startAnimating];
    UIBarButtonItem *mapButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t loadQueue = dispatch_queue_create("photos in place", NULL);
    dispatch_async(loadQueue, ^{
        NSArray *tempArray = [FlickrFetcher photosInPlace:self.place maxResults:50];
        dispatch_async(dispatch_get_current_queue(), ^{
            self.photosInPlace = tempArray;
            [spinner stopAnimating];
            self.navigationItem.rightBarButtonItem = mapButton;
        });
    });
    dispatch_release(loadQueue);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(NSDictionary *)mapVC:(MapVC *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    NSURL *imageURL = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:data];
    [dict setObject:image forKey:@"image"];
    [dict setObject:[fpa.photo objectForKey:@"id"] forKey:@"id"];
    
    return dict;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photosInPlace count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *photo = [self.photosInPlace objectAtIndex:indexPath.row];
    NSString *title = [photo valueForKey:@"title"];
    NSDictionary *descriptionDict = [photo valueForKey:@"description"];
    NSString *description = [descriptionDict valueForKey:@"_content"];
    
    if(title)
    {
        
    }
    else if(!title && description)
    {
        title = description;
        description = @"";
    }
    else
    {
        title = @"Unknown";
        description = @"";
    }
    
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL addObject = YES;
    NSDictionary *photo = [self.photosInPlace objectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentPlaces = [[defaults objectForKey:@"recent"] mutableCopy];
    if (!recentPlaces) recentPlaces = [NSMutableArray array];
    
    
    for(int i=0; i<recentPlaces.count; i++)
    {
        NSDictionary *dict = [recentPlaces objectAtIndex:i];
        if([[dict objectForKey:@"id"] isEqualToString:[photo objectForKey:@"id"]])
        {
            [recentPlaces removeObject:dict];
            i--;
        }
    }
    
    if(addObject)
    {
        [recentPlaces insertObject:photo atIndex:0];
    }
    [defaults setObject:recentPlaces forKey:@"recent"];
    [defaults synchronize];
    
    if([self splitViewController])
    {
        id ivc = [self.splitViewController.viewControllers lastObject];
        if([ivc isKindOfClass:[ImageVC class]])
        {
            ivc = (ImageVC *)ivc;
            [ivc setImageURL:[FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge]];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Image Segue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *photo = [self.photosInPlace objectAtIndex:indexPath.row];
        [segue.destinationViewController setImageURL:[FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge]];
    }
    else if([segue.identifier isEqualToString:@"Map Segue"])
    {
        [segue.destinationViewController setAnnotations:[self mapAnnotations]];
        [segue.destinationViewController setDelegate:self];
    }
}

@end


