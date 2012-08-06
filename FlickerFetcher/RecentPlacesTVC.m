//
//  RecentPlacesTVC.m
//  FlickerFetcher
//
//  Created by Austin Emser on 8/1/12.
//  Copyright (c) 2012 Austin Emser. All rights reserved.
//

#import "RecentPlacesTVC.h"
#import "ImageVC.h"
#import "FlickrFetcher/FlickrFetcher.h"

@interface RecentPlacesTVC ()

@end

@implementation RecentPlacesTVC
@synthesize recentPlaces = _recentPlaces;
@synthesize delegate = _delegate;

-(void) setRecentPlaces:(NSArray *)recentPlaces
{
    if(_recentPlaces != recentPlaces)
    {
        _recentPlaces = recentPlaces;
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

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.recentPlaces = [defaults objectForKey:@"recent"]; //need this call, setter reloads data
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.recentPlaces = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.recentPlaces = nil;
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
    return [self.recentPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *photo = [self.recentPlaces objectAtIndex:indexPath.row];
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *place = [self.recentPlaces objectAtIndex:indexPath.row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *newPlaces = [[defaults objectForKey:@"recent"] mutableCopy];
        [newPlaces removeObject:place];
        self.recentPlaces = [newPlaces copy];
        [defaults setObject:self.recentPlaces forKey:@"recent"];
        [defaults synchronize];
    }   
 
}


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
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        NSDictionary *place = [self.recentPlaces objectAtIndex:indexPath.row];
        NSURL *imageURL = [FlickrFetcher urlForPhoto:place format:FlickrPhotoFormatLarge];
        [self.delegate recentPlacesTVC:self choseImageURL:imageURL];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *photo = [self.recentPlaces objectAtIndex:indexPath.row];
    
    [segue.destinationViewController setImageURL:[FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge]];
}

@end
