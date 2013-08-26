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
#import "Recorder.h"
#import "GPSTrackViewController.h"
#import "MapScrollView.h"
#import "DrawableMapScrollView.h"
#import "GPSNode.h"
#import "PM2OnScreenButtons.h"
#import "POIEditViewController.h"
#import "LinePropertyViewController.h"
#import "SettingItem.h"
#import "Settings.h"
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
                    [[MenuItem alloc]initWithTitle:@"Pick Color"],
                    [[MenuItem alloc]initWithTitle:@"Settings"],
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

#define GPSTRACKS   0
#define DRAWINGS    0

#define CREATEPOI   0
#define MODIFYPOI   1
#define MOVEAPOI    2
#define GOTOAPOI    3

#define PICKCOLOR   0
#define SETTINGS    1
- (void)viewDidLoad
{
    [super viewDidLoad];
    ((MenuItem *)menuMatrix[GPS_SECTION][GPSTRACKS]).menuItemHandler=@selector(showGPSTrackList:);
    
    ((MenuItem *)menuMatrix[DRAW_SECTION][DRAWINGS]).menuItemHandler=@selector(showDrawingList:);
    
    ((MenuItem *)menuMatrix[POI_SECTION][CREATEPOI]).menuItemHandler=@selector(CreatePoi);
    ((MenuItem *)menuMatrix[POI_SECTION][MODIFYPOI]).menuItemHandler=@selector(ModifyPoi:);
    ((MenuItem *)menuMatrix[POI_SECTION][MOVEAPOI]).menuItemHandler=@selector(MoveAPoi:);
    ((MenuItem *)menuMatrix[POI_SECTION][GOTOAPOI]).menuItemHandler=@selector(GotoAPoi:);
    ((MenuItem *)menuMatrix[HELP_SECTION][PICKCOLOR]).menuItemHandler=@selector(PickColor);
    ((MenuItem *)menuMatrix[HELP_SECTION][SETTINGS]).menuItemHandler=@selector(Settings:);
}
#pragma mark - -------------menu item handlers-------------------
-(void)Settings:(NSString *)menuTitle{
    NSLog(@"Tap on Settings");
//    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
//    if([OSB.menuPopover isPopoverVisible]){
//        [OSB.menuPopover dismissPopoverAnimated:YES];
//    }
    
//    NSArray * settingArray=[[NSArray alloc]initWithObjects:
//                        [[SettingItem alloc]initWithTitle:@"Show Scale Ruler"],
//                        [[SettingItem alloc]initWithTitle:@"Show Map Center"],
//                        [[SettingItem alloc]initWithTitle:@"Hide Status Bar"],
//                        [[SettingItem alloc]initWithTitle:@"Auto Rotate"],
//                        [[SettingItem alloc]initWithTitle:@"Direction Up On GPS"],
//                        [[SettingItem alloc]initWithTitle:@"Use Cached Map Only"],
//                        [[SettingItem alloc]initWithTitle:@"Use Internet Map Only"],
//                        [[SettingItem alloc]initWithTitle:@"Show Map Level"],
//                        [[SettingItem alloc]initWithTitle:@"Hide Speed Meter"],
//                        [[SettingItem alloc]initWithTitle:@"Hide Altitude Meter"],
//                        [[SettingItem alloc]initWithTitle:@"Hide Trip Meter"],
//                        nil];
//                     
    ExpandableMenuViewController *xmvc = [[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    xmvc.trackList=[Settings sharedSettings].settingArray;
    //xmvc.trackHandlerDelegate=self;  //this line is not needed becaus settings should not lead to a new tableview
    xmvc.id=SETTING;
    NSLOG10(@"executing settings from %@",menuTitle);
    [xmvc setTitle:menuTitle];
    [self.navigationController pushViewController:xmvc animated:YES];
}
-(void)PickColor{
    NSLog(@"Tap on the PickColor");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self dismissViewControllerAnimated:NO completion:NULL];
        PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
        [OSB colorPicker];
    }else{
        PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
        if([OSB.menuPopover isPopoverVisible]){
            [OSB.menuPopover dismissPopoverAnimated:YES];
        }
        [OSB colorPicker];
    }
}
-(void)CreatePoi{
    NSLog(@"Tap on the map to Create a POI");
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    Recorder * recorder=[Recorder sharedRecorder];
    recorder.POICreating=true;
    [self dismissViewControllerAnimated:YES completion:NULL];  //for iphone
}
-(void)ModifyPoi:(NSString *) menuTitle{
    NSLog(@"Tap on the map to Modify a POI");
    //Showing POI list
    ExpandableMenuViewController *xmvc = [[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    xmvc.trackList=[Recorder sharedRecorder].poiArray;
    xmvc.trackHandlerDelegate=self;
    xmvc.id=POILIST;
    [xmvc setTitle:menuTitle];
    [self.navigationController pushViewController:xmvc animated:YES];
}
-(void)MoveAPoi:(NSString *) menuTitle{
    NSLog(@"Tap on and Hold a POI and Move to destination and then let your fingure go");
    
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    Recorder * recorder=[Recorder sharedRecorder];
    recorder.POIMoving=true;
    [[DrawableMapScrollView sharedMap] setScrollEnabled:NO];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)GotoAPoi:(NSString *) menuTitle{
    NSLog(@"Tap on the map to GOTO a POI");
    //Showing POI list
    ExpandableMenuViewController *xmvc = [[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    xmvc.trackList=[Recorder sharedRecorder].poiArray;
    xmvc.trackHandlerDelegate=self;
    xmvc.id=GOTOPOI;
    [xmvc setTitle:menuTitle];
    [self.navigationController pushViewController:xmvc animated:YES];
}
-(void)showGPSTrackList:(NSString *) menuTitle{
    ExpandableMenuViewController *xmvc = [[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    xmvc.trackList=[Recorder sharedRecorder].gpsTrackArray;
    xmvc.trackHandlerDelegate=self;
    NSLOG10(@"executing showGPSTrackList from %@",menuTitle);
    [xmvc setTitle:menuTitle];
    [self.navigationController pushViewController:xmvc animated:YES];
}
- (void)tappedOnIndexPath:(int)row ID:(int)myid{
    NSLog(@"you clicked on row %d",row);
    
    GPSTrackViewController * gpsTrackViewCtrlr=[[GPSTrackViewController alloc]initWithNibName:@"GPSTrackViewController" bundle:nil];
    
    GPSTrack * tk;
    if (myid==DRAWLIST) {
        tk=[Recorder sharedRecorder].trackArray[row];
        gpsTrackViewCtrlr.listType=DRAWLIST;
    }else if (myid==POILIST) {
        POI * poi=[Recorder sharedRecorder].poiArray[row];
        if (!poi.folder) {
             POIEditViewController * poiEditViewController=[[POIEditViewController alloc]initWithNibName:@"POIEditViewController" bundle:nil];
            //poiEditViewController.rootView=parent;
            [poiEditViewController setTitle:@"Modify POI"];
            poiEditViewController.poi=poi;
            [self.navigationController pushViewController:poiEditViewController animated:YES];
            return;
        }
        tk=(MenuNode *)[Recorder sharedRecorder].poiArray[row];
    }else if (myid==GOTOPOI) {
        POI * poi=[Recorder sharedRecorder].poiArray[row];
        if (!poi.folder) {
            [[DrawableMapScrollView sharedMap] centerMapToPOI:poi];
            PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
            if([OSB.menuPopover isPopoverVisible]){
                [OSB.menuPopover dismissPopoverAnimated:YES];
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
            return;
        }
        //if folder on POI list
        tk=poi;
    }else if (myid==SETTINGS) {
        return; //do nothing for settings here
    }else
        tk=[Recorder sharedRecorder].gpsTrackArray[row];
    
    gpsTrackViewCtrlr.gpsTrack=tk;
    if (tk.folder) {
        [gpsTrackViewCtrlr setTitle:tk.mainText];
    }else{
        [gpsTrackViewCtrlr setTitle:tk.mainText];
        if ([tk.nodes count]>0) {
            GPSNode * node=tk.nodes[0];
            [[DrawableMapScrollView sharedMap] centerMapTo:node];
        }
    }
    [self.navigationController pushViewController:gpsTrackViewCtrlr animated:YES];
}
- (void)onFolderCheckBox{
    NSLog(@"onFolderCheckBox");
    [[DrawableMapScrollView sharedMap] refresh];
}
//-(void)showGPSTrackList:(NSString *) menuTitle{
//    NSLOG10(@"executing showGPSTrackList from %@",menuTitle);
//    GPSTrackListTableViewController * gpsV=[[GPSTrackListTableViewController alloc] init];
//    [gpsV setTitle:menuTitle];
//    [self.navigationController pushViewController:gpsV animated:YES];
//}
//-(void)showDrawingList:(NSString *) menuTitle{
//    NSLOG10(@"executing showDrawingList from %@",menuTitle);
//    GPSTrackListTableViewController * gpsV=[[GPSTrackListTableViewController alloc] initWithType:DRAWLIST];
//    [gpsV setTitle:menuTitle];
//    [self.navigationController pushViewController:gpsV animated:YES];
//}
-(void)showDrawingList:(NSString *) menuTitle{    
    ExpandableMenuViewController *xmvc = [[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    xmvc.trackList=[Recorder sharedRecorder].trackArray;
    xmvc.trackHandlerDelegate=self;
    xmvc.id=DRAWLIST;
    NSLOG10(@"executing showDrawingList from %@",menuTitle);
    [xmvc setTitle:menuTitle];
    [self.navigationController pushViewController:xmvc animated:YES];
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
