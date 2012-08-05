//
//  TopPlaceTVC.m
//  FlickerFetcher
//
//  Created by Austin Emser on 7/30/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import "TopPlaceTVC.h"
#import "FlickrFetcher.h"
#import "PhotosInPlaceTVC.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface TopPlaceTVC ()

@end

@implementation TopPlaceTVC

@synthesize flickrTopPlaces = _flickrTopPlaces;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

-(void)setFlickrTopPlaces:(NSArray *)flickrTopPlaces
{
    if(_flickrTopPlaces != flickrTopPlaces)
    {
        _flickrTopPlaces = flickrTopPlaces;
        [self.tableView reloadData];
    }
}

- (void)awakeFromNib  // always try to be the split view's delegate
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if(![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)])
    {
        detailVC = nil;
    }
    return detailVC;
}

-(BOOL)splitViewController:(UISplitViewController *)svc
  shouldHideViewController:(UIViewController *)vc
             inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}
-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"Test");
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Top Places";
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner hidesWhenStopped];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t loadQueue = dispatch_queue_create("load initial queue", NULL);
    dispatch_async(loadQueue, ^{
        NSMutableArray *arraySort = [[NSMutableArray alloc] init];
        arraySort = [[FlickrFetcher topPlaces] mutableCopy];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"_content" ascending:YES];
        [arraySort sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        dispatch_async(dispatch_get_current_queue(), ^{
            [spinner stopAnimating];
            self.flickrTopPlaces = [arraySort copy];
        });
    });
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.flickrTopPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Places Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSDictionary *place = [self.flickrTopPlaces objectAtIndex:indexPath.row];
    NSArray *location = [[place valueForKey:@"_content"] componentsSeparatedByString:@","];
    NSString *state = [location objectAtIndex:1];
    NSString *country;
    if([location count] > 2)
        country = [location objectAtIndex:2];
    else
        country = @"";
    cell.textLabel.text = [location objectAtIndex:0];
    cell.detailTextLabel.text = [state stringByAppendingString:[NSString stringWithFormat:@", %@", country]];
    
    
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
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"Photos In Place"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *place = [self.flickrTopPlaces objectAtIndex:indexPath.row];
        
        
        //set the title of the new window to the city
        NSArray *location = [[place valueForKey:@"_content"] componentsSeparatedByString:@","];
        NSString *title = [location objectAtIndex:0];
        
        [segue.destinationViewController setPlace:place];
        [segue.destinationViewController setTitle:title];
        
    }
}

@end
