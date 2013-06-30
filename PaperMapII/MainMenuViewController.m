//
//  MainMenuViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/26/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize drawingMenuItems;
@synthesize gpsMenuItems;
@synthesize poiMenuItems;
@synthesize helpMenuItems;

@synthesize gpsTrackMenuItem;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        drawingMenuItems=[[NSArray alloc]initWithObjects:[[MenuItem alloc]initWithTitle:@"Save Drawing As"],
                                                         [[MenuItem alloc]initWithTitle:@"Load Drawing"],
                                                         [[MenuItem alloc]initWithTitle:@"Add Drawing from File"], nil];
        gpsMenuItems=[[NSArray alloc]initWithObjects:gpsTrackMenuItem=[[MenuItem alloc]initWithTitle:@"GPS Tracks"],
                      [[MenuItem alloc]initWithTitle:@"Config GPS"],
                      [[MenuItem alloc]initWithTitle:@"Start GPS"],
                      [[MenuItem alloc]initWithTitle:@"Load GPS Track From"],
                      [[MenuItem alloc]initWithTitle:@"Unload GPS Track"],
                      [[MenuItem alloc]initWithTitle:@"Load GPS Track As Drawing"],
                      [[MenuItem alloc]initWithTitle:@"Send GPS Track File"], nil];

        poiMenuItems=[[NSArray alloc]initWithObjects:[[MenuItem alloc]initWithTitle:@"Create POI"],
                      [[MenuItem alloc]initWithTitle:@"Modify POI"],
                      [[MenuItem alloc]initWithTitle:@"Move a POI"],
                      [[MenuItem alloc]initWithTitle:@"Goto a POI"],
                      [[MenuItem alloc]initWithTitle:@"Goto an Address"],
                      [[MenuItem alloc]initWithTitle:@"Hide POIs"],
                      [[MenuItem alloc]initWithTitle:@"Unload all POIs"],
                      [[MenuItem alloc]initWithTitle:@"Save POIs to File"],
                      [[MenuItem alloc]initWithTitle:@"Load POIs from File"],
                      [[MenuItem alloc]initWithTitle:@"Send POI File"], nil];

        helpMenuItems=[[NSArray alloc]initWithObjects:[[MenuItem alloc]initWithTitle:@"Help"],
                      [[MenuItem alloc]initWithTitle:@"Send Email to Developer"],
                      [[MenuItem alloc]initWithTitle:@"Receive File"],
                      [[MenuItem alloc]initWithTitle:@"About Paper Map II"], nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    gpsTrackMenuItem.menuItemHandler=@selector(showGPSTrackList:);
}
-(void)showGPSTrackList:(NSString *) menuTitle{
    //NSString * menuTitle=sender;
    NSLOG10(@"executing showGPSTrackList from %@",menuTitle);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#define DRAW_SECTION 0
#define  GPS_SECTION 1
#define  POI_SECTION 2
#define  HELP_SECTION 3
#define PRCIN_SECTION 5
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==DRAW_SECTION) {
		return @"Drawing";
	}else if (section==GPS_SECTION) {
        return @"GPS Tracks";
	}else if (section==POI_SECTION) {
		return @"Points of Interest (POI)";
	}else if (section==HELP_SECTION) {
		return @"Help";
	}else if (section==4) {
		return @"Precinct Map Settings";
	}
    return 0;
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section==DRAW_SECTION) {
		return [drawingMenuItems count];
	}else if (section==GPS_SECTION) {
        return [gpsMenuItems count];
	}else if (section==POI_SECTION) {
		return [poiMenuItems count];
	}else if (section==HELP_SECTION) {
		return [helpMenuItems count];
	}else if (section==4) {
		return 10;
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section=indexPath.section;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
     */
    // Configure the cell...
    //cell.textLabel.text=@"sha bi";
    
    UILabel * label=(UILabel *)[cell viewWithTag:66];
	UILabel * labe1=(UILabel *)[cell viewWithTag:64];
	//BOOL newlyAlloc=FALSE;
	if(!label){
		label=[[UILabel alloc] initWithFrame:CGRectMake(15,0,380,45)]; label.tag=66; [cell.contentView addSubview:label];
		labe1=[[UILabel alloc] initWithFrame:CGRectMake(0,0,15,45)];   labe1.tag=64; [cell.contentView addSubview:labe1];
	}
    
    if (section==DRAW_SECTION) {
		label.text=((MenuItem *)drawingMenuItems[indexPath.row]).text;
	}else if (section==GPS_SECTION) {
        label.text=((MenuItem *)gpsMenuItems[indexPath.row]).text;
	}else if (section==POI_SECTION) {
		label.text=((MenuItem *)poiMenuItems[indexPath.row]).text;
	}else if (section==HELP_SECTION) {
		label.text=((MenuItem *)helpMenuItems[indexPath.row]).text;
	}else if (section==4) {
		
	}
    
    //backgroud color settings for different sections
	if (section==DRAW_SECTION) {
		label.backgroundColor=[UIColor colorWithRed:0.2 green:0.8 blue:0.0 alpha:0.4];
	}else if (section==GPS_SECTION) {
		label.backgroundColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.8 alpha:0.4];
	}else if (section==POI_SECTION) {
		label.backgroundColor=[UIColor colorWithRed:0.2 green:0.0 blue:0.2 alpha:0.4];
	}else if (section==PRCIN_SECTION) {
		label.backgroundColor=[UIColor colorWithRed:0.6 green:0.3 blue:0.0 alpha:0.4];
	}else  //HELP_SECTION
		label.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.0 alpha:0.4];
    labe1.backgroundColor=label.backgroundColor;
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSInteger section=indexPath.section;
    if (section==DRAW_SECTION) {
		
	}else if (section==GPS_SECTION) {
        //[gpsMenuItems[indexPath.row] menuItemHandler];
        MenuItem * clickedItem=gpsMenuItems[indexPath.row];
        [self performSelector:clickedItem.menuItemHandler withObject:clickedItem.text];
	}else if (section==POI_SECTION) {
		
	}else if (section==HELP_SECTION) {
		
	}else if (section==4) {
		
	}
}

@end
