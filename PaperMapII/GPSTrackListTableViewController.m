//
//  GPSTrackListTableViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "GPSTrackListTableViewController.h"
#import "Recorder.h"
#import "GPSTrack.h"
#import "GPSTrackViewController.h"
#import "MapScrollView.h"
#import "DrawableMapScrollView.h"
#import "GPSNode.h"
#import "MainQ.h"
#import "GPSTrackPOIBoard.h"

@interface GPSTrackListTableViewController ()

@end

@implementation GPSTrackListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithType:(ListType)listType
{
    self = [super init];
    if (self) {
        // Custom initialization
        _listType=listType;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Will will appear - GPSTrackListTableView");
    [self.tableView reloadData];
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
    if (_listType==DRAWLIST) {
        return [[Recorder sharedRecorder].trackArray count];
    }
    return [[Recorder sharedRecorder].gpsTrackArray count];
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
    if (_listType==DRAWLIST) {
        GPSTrack * tk=[Recorder sharedRecorder].trackArray[indexPath.row];
        //cell.textLabel.text=tk.title;
        cell.textLabel.text=[[NSString alloc]initWithFormat:@"%3d - %@",indexPath.row,tk.title];
        return cell;
    }
    //configure the cell for GPS Track list
    GPSTrack * tk=[Recorder sharedRecorder].gpsTrackArray[indexPath.row];
    if (tk.visible) {
        cell.textLabel.textColor=[UIColor blackColor];
    }else
        cell.textLabel.textColor=[UIColor lightGrayColor];
    //cell.textLabel.text=tk.title;
    cell.textLabel.text=[[NSString alloc]initWithFormat:@"%3d - %@",indexPath.row,tk.title];
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

//delete button is pressed in the table view
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete Confirmation" message:@"Are You Sure ?" delegate:nil cancelButtonTitle:@"Cancel"otherButtonTitles:@"OK", nil];
//        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            // handle the button click
//        }];
        if (_listType==DRAWLIST) {
            [[Recorder sharedRecorder].trackArray removeObjectAtIndex:indexPath.row];
        }else{
            [[Recorder sharedRecorder].gpsTrackArray removeObjectAtIndex:indexPath.row];
        }
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if (_listType==DRAWLIST) {
        Track * tk=[Recorder sharedRecorder].trackArray[indexPath.row];
        if ([tk.nodes count]>0) {
            Node * node=tk.nodes[0];
            [self centerMapToDrawNode:node];
        }
    }else{
        GPSTrack * tk=[Recorder sharedRecorder].gpsTrackArray[indexPath.row];
        
        GPSTrackViewController * gpsTrackViewCtrlr=[[GPSTrackViewController alloc]initWithNibName:@"GPSTrackViewController" bundle:nil];
        gpsTrackViewCtrlr.gpsTrack=tk;
        [gpsTrackViewCtrlr setTitle:tk.title];
        if ([tk.nodes count]>0) {
            GPSNode * node=tk.nodes[0];
            [self centerMapTo:node];
        }
        [self.navigationController pushViewController:gpsTrackViewCtrlr animated:YES];
    }
}
//TODO: did not do mode adjust
-(void)centerMapTo:(GPSNode *)node{
    MapScrollView * map=((MapScrollView *)[DrawableMapScrollView sharedMap]);
    int res=map.maplevel;
    //x,y used to center the map below
	int x=pow(2,res)*0.711111111*(node.longitude+180);                      //256/360=0.7111111111
	int y=pow(2,res)*1.422222222*(90-[[Recorder sharedRecorder] GetScreenY:node.latitude]);		 //256/180=1.4222222222
	
    //center the current position
    [[Recorder sharedRecorder] centerPositionAtX:x Y:y];
}
//TODO: not working properly
-(void)centerMapToDrawNode:(Node *)node{
    MainQ * mQ=[MainQ sharedManager];
    GPSTrackPOIBoard * gb =(GPSTrackPOIBoard *)[mQ getTargetRef:GPSTRACKPOIBOARD];
    int mapL=gb.maplevel;
    int x=node.x*pow(2,mapL-node.r);
    int y=node.y*pow(2,mapL-node.r);
    [[Recorder sharedRecorder] centerPositionAtX:x Y:y];
}
@end
