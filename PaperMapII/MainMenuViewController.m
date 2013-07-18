//
//  MainMenuViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/26/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "MainMenuViewController.h"
#import "GPSTrackListTableViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

@synthesize menuMatrix;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSArray * drawingMenu=[[NSArray alloc]initWithObjects:
                    [[MenuItem alloc]initWithTitle:@"Drawings"],
                    [[MenuItem alloc]initWithTitle:@"Load Drawing"],
                    [[MenuItem alloc]initWithTitle:@"Add Drawing from File"], nil];
        
        NSArray * gpsMenu=[[NSArray alloc]initWithObjects:
                    [[MenuItem alloc]initWithTitle:@"GPS Tracks"],
                    [[MenuItem alloc]initWithTitle:@"Config GPS"],
                    [[MenuItem alloc]initWithTitle:@"Start GPS"],
                    [[MenuItem alloc]initWithTitle:@"Load GPS Track From"],
                    [[MenuItem alloc]initWithTitle:@"Unload GPS Track"],
                    [[MenuItem alloc]initWithTitle:@"Load GPS Track As Drawing"],
                    [[MenuItem alloc]initWithTitle:@"Send GPS Track File"], nil];

        NSArray * poiMenu=[[NSArray alloc]initWithObjects:
                    [[MenuItem alloc]initWithTitle:@"Create POI"],
                    [[MenuItem alloc]initWithTitle:@"Modify POI"],
                    [[MenuItem alloc]initWithTitle:@"Move a POI"],
                    [[MenuItem alloc]initWithTitle:@"Goto a POI"],
                    [[MenuItem alloc]initWithTitle:@"Goto an Address"],
                    [[MenuItem alloc]initWithTitle:@"Hide POIs"],
                    [[MenuItem alloc]initWithTitle:@"Unload all POIs"],
                    [[MenuItem alloc]initWithTitle:@"Save POIs to File"],
                    [[MenuItem alloc]initWithTitle:@"Load POIs from File"],
                    [[MenuItem alloc]initWithTitle:@"Send POI File"], nil];

        NSArray * helpMenu=[[NSArray alloc]initWithObjects:
                    [[MenuItem alloc]initWithTitle:@"Help"],
                    [[MenuItem alloc]initWithTitle:@"Send Email to Developer"],
                    [[MenuItem alloc]initWithTitle:@"Receive File"],
                    [[MenuItem alloc]initWithTitle:@"About Paper Map II"], nil];
        
        menuMatrix=[[NSArray alloc]initWithObjects:drawingMenu,gpsMenu,poiMenu,helpMenu,nil];
    }
    return self;
}

#define DRAW_SECTION 0
#define  GPS_SECTION 1
#define  POI_SECTION 2
#define  HELP_SECTION 3
#define PRCIN_SECTION 5

#define GPSTRACKS 0
#define DRAWINGS  0
- (void)viewDidLoad
{
    [super viewDidLoad];
    ((MenuItem *)menuMatrix[GPS_SECTION][GPSTRACKS]).menuItemHandler=@selector(showGPSTrackList:);
    
    ((MenuItem *)menuMatrix[DRAW_SECTION][DRAWINGS]).menuItemHandler=@selector(showDrawingList:);
}
#pragma mark - -------------menu item handlers-------------------
-(void)showGPSTrackList:(NSString *) menuTitle{
    NSLOG10(@"executing showGPSTrackList from %@",menuTitle);
    GPSTrackListTableViewController * gpsV=[[GPSTrackListTableViewController alloc] init];
    [gpsV setTitle:menuTitle];
    [self.navigationController pushViewController:gpsV animated:YES];
}
-(void)showDrawingList:(NSString *) menuTitle{
    NSLOG10(@"executing showDrawingList from %@",menuTitle);
    GPSTrackListTableViewController * gpsV=[[GPSTrackListTableViewController alloc] initWithType:DRAWLIST];
    [gpsV setTitle:menuTitle];
    [self.navigationController pushViewController:gpsV animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


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
    // Return the number of sections.
    return [menuMatrix count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuMatrix[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section=indexPath.section;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel * label=(UILabel *)[cell viewWithTag:66];
	UILabel * labe1=(UILabel *)[cell viewWithTag:64];

	if(!label){
		label=[[UILabel alloc] initWithFrame:CGRectMake(15,0,380,45)]; label.tag=66; [cell.contentView addSubview:label];
		labe1=[[UILabel alloc] initWithFrame:CGRectMake(0,0,15,45)];   labe1.tag=64; [cell.contentView addSubview:labe1];
	}
    
    label.text=((MenuItem *)menuMatrix[section][indexPath.row]).text;
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MenuItem * clickedItem=menuMatrix[indexPath.section][indexPath.row];
    if (clickedItem.menuItemHandler) {
        [self performSelector:clickedItem.menuItemHandler withObject:clickedItem.text];
    }
}

@end
