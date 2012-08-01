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

@interface TopPlaceTVC ()

@end

@implementation TopPlaceTVC

@synthesize flickrTopPlaces = _flickrTopPlaces;

-(NSArray *)flickrTopPlaces
{
    if(!_flickrTopPlaces)
    {
        _flickrTopPlaces = [FlickrFetcher topPlaces];
    }
    return _flickrTopPlaces;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *arraySort = [[NSMutableArray alloc] init];
    arraySort = [self.flickrTopPlaces mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"_content" ascending:YES];
    [arraySort sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    self.flickrTopPlaces = [arraySort copy];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        NSArray *photosInPlace = [FlickrFetcher photosInPlace:place maxResults:50];
        
        //set the title of the new window to the city
        NSArray *location = [[place valueForKey:@"_content"] componentsSeparatedByString:@","];
        NSString *title = [location objectAtIndex:0];
        
        [segue.destinationViewController setPhotosInPlace:photosInPlace];
        [segue.destinationViewController setTitle:title];
        
    }
}

@end
