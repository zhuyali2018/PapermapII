//
//  GPSTrackNodesViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "GPSTrackNodesViewController.h"
#import "GPSNode.h"
#import "GPSNodeViewController.h"
#import "MapScrollView.h"
#import "DrawableMapScrollView.h"
#import "Recorder.h"

@interface GPSTrackNodesViewController ()

@end

@implementation GPSTrackNodesViewController
@synthesize gpsTrack;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [gpsTrack.nodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    GPSNode * node=gpsTrack.nodes[indexPath.row];
    NSString * tm=[NSDateFormatter localizedStringFromDate:node.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    cell.textLabel.text=[[NSString alloc]initWithFormat:@"%3d - %@",indexPath.row,tm];
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
    GPSNodeViewController *nodeViewer=[[GPSNodeViewController alloc]initWithNibName:@"GPSNodeViewController" bundle:nil];
    GPSNode * node=gpsTrack.nodes[indexPath.row];
    [self centerMapTo:node];
    nodeViewer.node=node;
    NSString * tm=[NSDateFormatter localizedStringFromDate:nodeViewer.node.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    [nodeViewer setTitle:tm];
    [self.navigationController pushViewController:nodeViewer animated:YES];
}
-(void)centerMapTo:(GPSNode *)node{
    MapScrollView * map=((MapScrollView *)[DrawableMapScrollView sharedMap]);
    int res=map.maplevel;
    //x,y used to center the map below
	int x=pow(2,res)*0.711111111*(node.longitude+180);                      //256/360=0.7111111111
	int y=pow(2,res)*1.422222222*(90-[[Recorder sharedRecorder] GetScreenY:node.latitude]);		 //256/180=1.4222222222
	
    //center the current position
    [[Recorder sharedRecorder] centerPositionAtX:x Y:y];
}
@end
