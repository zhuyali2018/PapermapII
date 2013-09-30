//
//  ListViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 9/24/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "ListViewController.h"
#import "SaveItem.h"
#import "PM2OnScreenButtons.h"
#import "AllImports.h"

@interface ListViewController ()

@end

@implementation ListViewController

@synthesize list;
@synthesize dirty;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        dirty=false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"ListViewController viewDidDisappear animated:%d",animated);
    [self saveListTable];
}
-(void) saveListTable{
    if (dirty) {
        NSString * key;
        NSString * filename;
        if (self.view.tag==DRAWLIST){
            key=@"drawinglistTable";
            filename=@"drawinglistTable.tbl";
        }else if (self.view.tag==GPSLIST){
            key=@"drawinglistTable";
            filename=@"drawinglistTable.tbl";
        }else{  //if tag is not specified, do not save
            return;
        }
        //need to save to file here to avoid losing changes on possible app crash
        NSMutableData * data=[[NSMutableData alloc] init];
        NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        [archiver encodeObject:list forKey:key];
        [archiver finishEncoding];
        NSString * filePath=[SaveItem absolutePath:filename];
        [data writeToFile:filePath atomically:YES];
        dirty=false;
    }
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
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([list count]==0) {
        return nil;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text=((SaveItem *)[list objectAtIndex:indexPath.row]).displayname;
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
// for adding an item
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(!editing) {  //if clicked on done button, save the change
        NSLog(@"save the change on Drawing list");
        [self saveListTable];
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"Delete code goes here for row %d",indexPath.row);
        SaveItem * sitem=[list objectAtIndex:indexPath.row];
        [self deleteFile:[sitem getAbsolutePathFilename]];
        NSMutableArray * mList=[[NSMutableArray alloc] initWithArray:list];
		[mList removeObjectAtIndex:[indexPath row]];
		list=mList;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        dirty=true;;
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(BOOL)deleteFile:(NSString *)filePath{
    NSLog(@"Deleting file %@",filePath);
	NSError * err;  // = [[NSError alloc]init];
	if(![[NSFileManager defaultManager] removeItemAtPath:filePath error:&err]){
		NSLog(@"Error deleting file:%@",filePath);
        return FALSE;
	}
    NSLog(@"Delete successful");
	return TRUE;
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray * mList=[[NSMutableArray alloc] initWithArray:list];
    id object = [mList objectAtIndex:fromIndexPath.row];
    [mList removeObjectAtIndex:fromIndexPath.row];
    [mList insertObject:object atIndex:toIndexPath.row];
    list=mList;
    dirty=true;
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You selected row %d, load file:%@",indexPath.row,((SaveItem *)[list objectAtIndex:indexPath.row]).displayname);
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    SaveItem * saveItem=((SaveItem *)[list objectAtIndex:indexPath.row]);
    if (self.view.tag==DRAWLIST) {
        [[Recorder sharedRecorder] loadAllTracksFrom:[saveItem getAbsolutePathFilename]];
    }else if (self.view.tag==GPSLIST){
        [[Recorder sharedRecorder] loadAllGPSTracksFrom:[saveItem getAbsolutePathFilename]];
    }else if (self.view.tag==POILIST){
        [[Recorder sharedRecorder] loadAllPOIsFrom:[saveItem getAbsolutePathFilename]];
    }
    [[DrawableMapScrollView sharedMap] refresh];
}
/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
