//
//  MainMenuViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/26/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
//#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <GameKit/GameKit.h>
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
#import "SaveItem.h"

@interface MainMenuViewController ()
@end

@implementation MainMenuViewController

@synthesize menuMatrix;
@synthesize fileListView;    //list of drawing files saved
@synthesize session;
@synthesize peerID;
@synthesize menuSettings;
@synthesize menuPOIs;
@synthesize menuDrawings;
@synthesize menuGPSTracks;
@synthesize adjustingMap;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSArray * drawingMenu=[[NSArray alloc]initWithObjects:
                    [[MenuItem alloc]initWithTitle:@"Drawings"],
                    [[MenuItem alloc]initWithTitle:@"Save All Drawings To File"],
                    [[MenuItem alloc]initWithTitle:@"Load Drawings from File"],
                    [[MenuItem alloc]initWithTitle:@"Unload All Drawings"],
                    [[MenuItem alloc]initWithTitle:@"Send Drawing File"], nil];
        NSArray * gpsMenu=[[NSArray alloc]initWithObjects:
                    [[MenuItem alloc]initWithTitle:@"GPS Tracks"],
                    [[MenuItem alloc]initWithTitle:@"Save GPS Tracks To File"],
                    [[MenuItem alloc]initWithTitle:@"Start GPS"],
                    [[MenuItem alloc]initWithTitle:@"Start GPS By Connect iPhone"],
                    [[MenuItem alloc]initWithTitle:@"Load GPS Track From"],
                    [[MenuItem alloc]initWithTitle:@"Unload All GPS Tracks"],
                    [[MenuItem alloc]initWithTitle:@"Send GPS Track File"], nil];

        NSArray * poiMenu=[[NSArray alloc]initWithObjects:
                    [[MenuItem alloc]initWithTitle:@"Create POI"],
                    [[MenuItem alloc]initWithTitle:@"Modify POI"],
                    [[MenuItem alloc]initWithTitle:@"Move a POI"],
                    [[MenuItem alloc]initWithTitle:@"Goto a POI"],
                    [[MenuItem alloc]initWithTitle:@"Goto an Address"],
                    [[MenuItem alloc]initWithTitle:@"Hide POIs"],
                    [[MenuItem alloc]initWithTitle:@"Save POIs to File"],
                    [[MenuItem alloc]initWithTitle:@"Load POIs from File"],
                    [[MenuItem alloc]initWithTitle:@"Unload all POIs"],
                    [[MenuItem alloc]initWithTitle:@"Send POI File"], nil];

        NSArray * helpMenu=[[NSArray alloc]initWithObjects:
                    [[MenuItem alloc]initWithTitle:@"Pick Color"],
                    [[MenuItem alloc]initWithTitle:@"Settings"],
                    [[MenuItem alloc]initWithTitle:@"Adjust Map Aligning Error"],
                    [[MenuItem alloc]initWithTitle:@"Reset Map Error"],
                    [[MenuItem alloc]initWithTitle:@"Help"],
                    [[MenuItem alloc]initWithTitle:@"Send Email to Developer"],
                    [[MenuItem alloc]initWithTitle:@"About Paper Map II (2015.3.26.I)"], nil];
        
        menuMatrix=[[NSArray alloc]initWithObjects:drawingMenu,gpsMenu,poiMenu,helpMenu,nil];
        fileListView=[[ListViewController alloc]initWithStyle:UITableViewStylePlain];
    }
    return self;
}
typedef enum{SAVEDRAWINGDLG=1000,SAVEGPSTRACKSDLG,SAVEPOISDLG, UNLOADDRAWCONFIRMDLG,UNLOADGPSCONFIRMDLG,UNLOADPOICONFIRMDLG} DLGID;

// section definitions
#define DRAW_SECTION 0
#define  GPS_SECTION 1
#define  POI_SECTION 2
#define  HELP_SECTION 3
#define PRCIN_SECTION 5

// Drawing Section
#define DRAWINGS        0
#define SAVEDRAWING     1
#define LOADDRAWING     2
#define UNLOADDRAWING   3
#define SENDDRAWINGS    4

// GPS Section
#define GPSTRACKS       0
#define SAVEGPSTRACKS   1
#define STARTGPS        2
#define CONNECTIPHONE   3
#define LOADGPSTRACKS   4
#define UNLOADGPSTRACKS 5
#define SENDGPSTRACKS   6
// POI Section
#define CREATEPOI   0
#define MODIFYPOI   1
#define MOVEAPOI    2
#define GOTOAPOI    3
#define SAVEPOIS    6
#define LOADPOIS    7
#define UNLOADPOIS  8
#define SEDNPOIFILE 9
// Help Section
#define PICKCOLOR   0
#define SETTINGS    1
#define ADJMAPERR   2
#define RSTMAPERR   3

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Drawing Section
    ((MenuItem *)menuMatrix[DRAW_SECTION][DRAWINGS]).menuItemHandler=@selector(showDrawingList:);
    ((MenuItem *)menuMatrix[DRAW_SECTION][SAVEDRAWING]).menuItemHandler=@selector(saveDrawingsToFile:);
    ((MenuItem *)menuMatrix[DRAW_SECTION][LOADDRAWING]).menuItemHandler=@selector(loadDrawingsFromFile:);
    ((MenuItem *)menuMatrix[DRAW_SECTION][UNLOADDRAWING]).menuItemHandler=@selector(unloadDrawings:);
    ((MenuItem *)menuMatrix[DRAW_SECTION][SENDDRAWINGS]).menuItemHandler=@selector(showDrawListToSendFrom:);
    //GPS Section
    ((MenuItem *)menuMatrix[GPS_SECTION][GPSTRACKS]).menuItemHandler=@selector(showGPSTrackList:);
    ((MenuItem *)menuMatrix[GPS_SECTION][SAVEGPSTRACKS]).menuItemHandler=@selector(saveGPSTracksToFile:);
    ((MenuItem *)menuMatrix[GPS_SECTION][CONNECTIPHONE]).menuItemHandler=@selector(connectiPhoneGPS);
    ((MenuItem *)menuMatrix[GPS_SECTION][LOADGPSTRACKS]).menuItemHandler=@selector(loadGpsTracksFromFile:);
    ((MenuItem *)menuMatrix[GPS_SECTION][UNLOADGPSTRACKS]).menuItemHandler=@selector(unloadGpsTracks:);
    ((MenuItem *)menuMatrix[GPS_SECTION][SENDGPSTRACKS]).menuItemHandler=@selector(showGPSTrackListToSendFrom:);
    //POI Section
    ((MenuItem *)menuMatrix[POI_SECTION][CREATEPOI]).menuItemHandler=@selector(CreatePoi);
    ((MenuItem *)menuMatrix[POI_SECTION][MODIFYPOI]).menuItemHandler=@selector(ModifyPoi:);
    ((MenuItem *)menuMatrix[POI_SECTION][MOVEAPOI]).menuItemHandler=@selector(MoveAPoi:);
    ((MenuItem *)menuMatrix[POI_SECTION][GOTOAPOI]).menuItemHandler=@selector(GotoAPoi:);
    
    ((MenuItem *)menuMatrix[POI_SECTION][SAVEPOIS]).menuItemHandler=@selector(savePOIsToFile:);
    ((MenuItem *)menuMatrix[POI_SECTION][LOADPOIS]).menuItemHandler=@selector(loadPOIsFromFile:);
    ((MenuItem *)menuMatrix[POI_SECTION][UNLOADPOIS]).menuItemHandler=@selector(unloadAllPOIs:);
    ((MenuItem *)menuMatrix[POI_SECTION][SEDNPOIFILE]).menuItemHandler=@selector(showPOIListToSendFrom:);
    
    //Help Section
    ((MenuItem *)menuMatrix[HELP_SECTION][PICKCOLOR]).menuItemHandler=@selector(PickColor);
    ((MenuItem *)menuMatrix[HELP_SECTION][SETTINGS]).menuItemHandler=@selector(Settings:);
    ((MenuItem *)menuMatrix[HELP_SECTION][ADJMAPERR]).menuItemHandler=@selector(AdjustMapError:);
    ((MenuItem *)menuMatrix[HELP_SECTION][RSTMAPERR]).menuItemHandler=@selector(ResetMapError:);

}
#pragma mark - -------------menu item handlers-------------------
bool connectedToIphone;
-(void)connectiPhoneGPS{
    
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    connectedToIphone=!connectedToIphone;
    if(connectedToIphone){ //if connecting to iphone
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        //MCBrowserViewController * picker=[[MCBrowserViewController alloc] init];
        GKPeerPickerController * picker=[[GKPeerPickerController alloc] init];
		picker.delegate=self;
		picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
		[picker show];
        NSLog(@"Connecting iPhone for GPS signals");
        ((MenuItem *)menuMatrix[GPS_SECTION][CONNECTIPHONE]).text=@"Disconnect iPhone and stop GPS";
        [self.tableView reloadData];
    }else{  //if already connected, that means user has tapped for disconnection
        [session disconnectFromAllPeers];
        session = nil;
        [[Recorder sharedRecorder] gpsStop];
        NSLog(@"disconnecting iPhone for GPS signals");
        MenuItem * mi=((MenuItem *)menuMatrix[GPS_SECTION][CONNECTIPHONE]);
        mi.text=@"Start GPS By Connect iPhone";
        [self.tableView reloadData];
    }
}

//delegate methods set right above
//==========================================
#pragma mark -
#pragma mark GameKit Peer Picker Delegate Methods
-(GKSession*)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
    NSLog(@"create a session for it");
	GKSession *theSession=[[GKSession alloc] initWithSessionID:@"YaliGPSReceiverSession" displayName:nil sessionMode:GKSessionModePeer];
    //GKSession *theSession=[[GKSession alloc] initWithSessionID:@"YaliMapTileReceiverSession" displayName:nil sessionMode:GKSessionModePeer];
	return theSession;
}
-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)thePeerID toSession:(GKSession *)theSession{
    NSLog(@"Did connected peer to session");
	self.peerID=thePeerID;
	self.session=theSession;
	self.session.delegate=self;
	[self.session setDataReceiveHandler:self withContext:NULL];
	[picker dismiss];
    [[Recorder sharedRecorder] gpsStart];
}
-(void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
	picker.delegate = nil;
    connectedToIphone=false;
    MenuItem * mi=((MenuItem *)menuMatrix[GPS_SECTION][CONNECTIPHONE]);
    mi.text=@"Start GPS By Connect iPhone";
    [self.tableView reloadData];
    NSLog(@"User canceled bluetooth connection atempt!");
}
//bluetooth GPS data receiving method?
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
    NSLog(@"data handler");
    CLLocation *location = (CLLocation *)[NSKeyedUnarchiver unarchiveObjectWithData:data];  //convert received data into CLLocation instance
    
    NSArray * locations=[NSArray arrayWithObject:location];
    [[Recorder sharedRecorder] locationManager:nil didUpdateLocations:locations];
    
    //[[Recorder sharedRecorder] locationManager:nil didUpdateToLocation:location fromLocation:nil];
}
//==========================================
#pragma mark -
#pragma mark GKSession Delegate methods
-(void)session:(GKSession *) theSession didFailWithError:(NSError *)error{
    NSLog(@"session did fail with error");
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Connecting!" message:@"Unable to establish the connection." delegate:nil cancelButtonTitle:@"Bummer" otherButtonTitles:nil];
	[alert show];
	theSession.available=NO;
	[theSession disconnectFromAllPeers];
	theSession.delegate=nil;
	[theSession setDataReceiveHandler:nil withContext:nil];
	self.session=nil;
}
-(void)session:(GKSession *) theSession peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)inState{
    if(inState==GKPeerStateConnected){
        NSLog(@"session did change state: Connected");
    }else if(inState==GKPeerStateDisconnected){
        NSLog(@"session did change state: Disconnected");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Peer Disconnected!" message:@"The otherside is disconnected,The Connection has been lost!" delegate:nil cancelButtonTitle:@"Bummer" otherButtonTitles:nil];
		[alert show];
		
		theSession.available=NO;
		[theSession disconnectFromAllPeers];
		theSession.delegate=nil;
		[theSession setDataReceiveHandler:nil withContext:nil];
		self.session=nil;
    }else if(inState==GKPeerStateAvailable){
        NSLog(@"session did change state: GKPeerStateAvailable");
    }else if(inState==GKPeerStateUnavailable){
        NSLog(@"session did change state: GKPeerStateUnavailable");
    }else if(inState==GKPeerStateConnecting){
        NSLog(@"session did change state: connecting");

    }
}
//==========================================
-(void)unloadDrawings:(NSString *) menuTitle{
    NSLOG10(@"unloadDrawings %@",menuTitle);
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    //ask user to confirm the deletion (unloading) of all drawings on map
    UIAlertView * removeConfirmDlg = [[UIAlertView alloc] initWithTitle:@"Removal Confirmation" message:@"Are you sure to remove all the drawings from the map ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    
    //saveDrawingDlg.alertViewStyle = UIAlertViewStylePlainTextInput;
    removeConfirmDlg.tag=UNLOADDRAWCONFIRMDLG;
    [removeConfirmDlg show];
}
-(void)unloadGpsTracks:(NSString *) menuTitle{
    NSLOG10(@"unloadGpsTracks %@",menuTitle);
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    
    //ask user to confirm the deletion (unloading) of all GPS Tracks on map
    UIAlertView * removeConfirmDlg = [[UIAlertView alloc] initWithTitle:@"Removal Confirmation" message:@"Are you sure to remove all the GPS Tracks from the map ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    
    //saveDrawingDlg.alertViewStyle = UIAlertViewStylePlainTextInput;
    removeConfirmDlg.tag=UNLOADGPSCONFIRMDLG;
    [removeConfirmDlg show];
}
-(void) unloadAllPOIs:(NSString *) menuTitle{
    NSLOG10(@"unloadAllPOIs %@",menuTitle);
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    
    //ask user to confirm the deletion (unloading) of all POIs on map
    UIAlertView * removeConfirmDlg = [[UIAlertView alloc] initWithTitle:@"Removal Confirmation" message:@"Are you sure to remove all the POIs from the map ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    
    removeConfirmDlg.tag=UNLOADPOICONFIRMDLG;
    [removeConfirmDlg show];
}
-(void)loadDrawingsFromFile:(NSString *) menuTitle{
    NSLOG10(@"loadDrawingsFromFile %@",menuTitle);
    [self loadDrawingFileList];
    [fileListView setTitle:menuTitle];
    [self.navigationController pushViewController:fileListView animated:YES];
}
-(void)loadGpsTracksFromFile:(NSString *) menuTitle{
    NSLOG10(@"loadGpsTracksFromFile %@",menuTitle);
    [self loadGpsFileList];
    [fileListView setTitle:menuTitle];
    [self.navigationController pushViewController:fileListView animated:YES];
    [fileListView refreshControl];
}
-(void)loadPOIsFromFile:(NSString *) menuTitle{
    NSLOG10(@"loadPOIsFromFile %@",menuTitle);
    [self loadPoiFileList];
    [fileListView setTitle:menuTitle];
    [self.navigationController pushViewController:fileListView animated:YES];
}
-(void)saveDrawingsToFile:(NSString *) menuTitle{
    NSLog(@"saveDrawingsToFile");
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    UIAlertView * saveDrawingDlg = [[UIAlertView alloc] initWithTitle:@"Save Drawing As" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];

    saveDrawingDlg.alertViewStyle = UIAlertViewStylePlainTextInput;
    saveDrawingDlg.tag=SAVEDRAWINGDLG;
    [saveDrawingDlg show];
}
-(void)saveGPSTracksToFile:(NSString *) menuTitle{
    NSLog(@"saveGPSTracksToFile");
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    UIAlertView * saveGPSDlg = [[UIAlertView alloc] initWithTitle:@"Save GPS Tracks As" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
    
    saveGPSDlg.alertViewStyle = UIAlertViewStylePlainTextInput;
    saveGPSDlg.tag=SAVEGPSTRACKSDLG;
    [saveGPSDlg show];
}
-(void)savePOIsToFile:(NSString *) menuTitle{
    NSLog(@"savePOIsToFile");
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    UIAlertView * savePOIDlg = [[UIAlertView alloc] initWithTitle:@"Save POIs As" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
    
    savePOIDlg.alertViewStyle = UIAlertViewStylePlainTextInput;
    savePOIDlg.tag=SAVEPOISDLG;
    [savePOIDlg show];
}
-(void)AdjustMapError:(NSString *)menuTitle{
    NSLog(@"Tap on Adjusting Map Error");
    
    //dismiss the menu
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }

    [DrawableMapScrollView sharedMap].adjustingMap=true;
    [DrawableMapScrollView sharedMap].isFirstTouchPoint=true;
    [[DrawableMapScrollView sharedMap] setScrollEnabled:NO];
    [self hideIPhoneMainMenu];
}
-(void)ResetMapError:(NSString *)menuTitle{
    NSLog(@"Tap on Resetting Map Error");
    //dismiss the menu
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    
    [DrawableMapScrollView sharedMap]->posErr=CGPointZero;
    [DrawableMapScrollView sharedMap]->posErr1=CGPointZero;
    [DrawableMapScrollView sharedMap]->mapMapErr=CGPointZero;
    [DrawableMapScrollView sharedMap]->satMapErr=CGPointZero;
    //[[DrawableMapScrollView sharedMap] refreshTilePositions];
    [[DrawableMapScrollView sharedMap] reloadData];
    [self hideIPhoneMainMenu];
}
-(void)Settings:(NSString *)menuTitle{
    NSLog(@"Tap on Settings");
    if (menuSettings == nil) {
        menuSettings =[[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
        menuSettings.trackList=[Settings sharedSettings].settingArray;
        menuSettings.readOnly=YES;
        //xmvc.trackHandlerDelegate=self;  //this line is not needed because settings should not lead to a new tableview
        NSLOG10(@"executing settings from %@",menuTitle);
        [menuSettings setTitle:menuTitle];
    }
    menuSettings.id=SETTING;
    [self.navigationController pushViewController:menuSettings animated:YES];
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
-(void)hideIPhoneMainMenu{
    if ([[DrawableMapScrollView sharedMap].iPhoneTapDelegate respondsToSelector:@selector(singleTapAtPoint:)]){
            [[DrawableMapScrollView sharedMap].iPhoneTapDelegate singleTapAtPoint:CGPointZero];
    }
}
-(void)CreatePoi{
    NSLog(@"Tap on the map to Create a POI");
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    [self hideIPhoneMainMenu];
    Recorder * recorder=[Recorder sharedRecorder];
    recorder.POICreating=true;
    [self dismissViewControllerAnimated:YES completion:NULL];  //for iphone
}
-(void)ModifyPoi:(NSString *) menuTitle{
    NSLog(@"Tap on the map to Modify a POI");
    //Showing POI list
    if (menuPOIs == nil) {
        menuPOIs =[[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        menuPOIs.trackList=[Recorder sharedRecorder].poiArray;
        menuPOIs.trackHandlerDelegate=self;
    }
    [menuPOIs setTitle:menuTitle];
    menuPOIs.id=POILIST;
    [self.navigationController pushViewController:menuPOIs animated:YES];
}
-(void)MoveAPoi:(NSString *) menuTitle{
    NSLog(@"Tap on and Hold a POI and Move to destination and then let your fingure go");
    
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.menuPopover isPopoverVisible]){
        [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    [self hideIPhoneMainMenu];
    Recorder * recorder=[Recorder sharedRecorder];
    recorder.POIMoving=true;
    [[DrawableMapScrollView sharedMap] setScrollEnabled:NO];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)GotoAPoi:(NSString *) menuTitle{
    NSLog(@"Tap on the map to GOTO a POI");
    //Showing POI list
    if (menuPOIs == nil) {
        menuPOIs =[[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        menuPOIs.trackList=[Recorder sharedRecorder].poiArray;
        menuPOIs.trackHandlerDelegate=self;
    }
    [menuPOIs setTitle:menuTitle];
    menuPOIs.id=GOTOPOI;
    [self.navigationController pushViewController:menuPOIs animated:YES];
    [self hideIPhoneMainMenu];
}
-(void)showGPSTrackList:(NSString *) menuTitle{
    if (menuGPSTracks == nil) {
        menuGPSTracks =[[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        menuGPSTracks.trackList=[Recorder sharedRecorder].gpsTrackArray;
        menuGPSTracks.trackHandlerDelegate=self;
    }
    menuGPSTracks.id=GPSLIST;  //<== why not thisline ?
    [menuGPSTracks setTitle:menuTitle];
    NSLOG10(@"executing showGPSTrackList from %@",menuTitle);
    [self.navigationController pushViewController:menuGPSTracks animated:YES];
}
-(void)showGPSTrackListToSendFrom:(NSString *) menuTitle{
    if (menuGPSTracks == nil) {
        menuGPSTracks =[[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        menuGPSTracks.trackList=[Recorder sharedRecorder].gpsTrackArray;
        menuGPSTracks.trackHandlerDelegate=self;
    }
    menuGPSTracks.id=SENDGPSTRACK;  //<== why not thisline ?
    [menuGPSTracks setTitle:menuTitle];
    NSLOG10(@"executing showGPSTrackListToSendFrom from %@",menuTitle);
    [self.navigationController pushViewController:menuGPSTracks animated:YES];
}
-(void)showDrawListToSendFrom:(NSString *) menuTitle{
    if (menuDrawings == nil) {
        menuDrawings =[[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        menuDrawings.trackList=[Recorder sharedRecorder].trackArray;
        menuDrawings.trackHandlerDelegate=self;
    }
    menuDrawings.id=SENDDRAWING;
    [menuDrawings setTitle:menuTitle];
    NSLOG10(@"executing showDrawListToSendFrom from %@",menuTitle);
    [self.navigationController pushViewController:menuDrawings animated:YES];
}
-(void)showPOIListToSendFrom:(NSString *) menuTitle{
    if (menuPOIs == nil) {
        menuPOIs =[[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        menuPOIs.trackList=[Recorder sharedRecorder].poiArray;
        menuPOIs.trackHandlerDelegate=self;
    }
    menuPOIs.id=SENDPOI;
    [menuPOIs setTitle:menuTitle];
    NSLOG10(@"executing showDrawListToSendFrom from %@",menuTitle);
    [self.navigationController pushViewController:menuPOIs animated:YES];
}

- (void)tappedOnIndexPath:(int)row ID:(int)myid{
    NSLog(@"you clicked on row %d",row);
    
    GPSTrackViewController * gpsTrackViewCtrlr=[[GPSTrackViewController alloc]initWithNibName:@"GPSTrackViewController" bundle:nil];
    //GPSTrack * tk;
    MenuNode * tk;
    
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
        tk=[Recorder sharedRecorder].poiArray[row];
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
        tk=(GPSTrack *)poi;
    }else if (myid==SETTING) {
        return; //do nothing for settings here
    }else if (myid==GPSLIST) {
        gpsTrackViewCtrlr.listType=GPSLIST;
        tk=[Recorder sharedRecorder].gpsTrackArray[row];
    }else if (myid==SENDGPSTRACK) {
        gpsTrackViewCtrlr.listType=SENDGPSTRACK;
        tk=[Recorder sharedRecorder].gpsTrackArray[row];
        gpsTrackViewCtrlr.Mtype=MGPSTRACK;
    }else if (myid==SENDDRAWING) {
        gpsTrackViewCtrlr.listType=SENDDRAWING;
        tk=[Recorder sharedRecorder].trackArray[row];
        gpsTrackViewCtrlr.Mtype=MTRACK;     //Let the GpsTrackViewController know it is holding a drawing track, not a GPS Track
    }else if (myid==SENDPOI) {
        gpsTrackViewCtrlr.listType=SENDPOI;
        tk=[Recorder sharedRecorder].poiArray[row];
        gpsTrackViewCtrlr.Mtype=MPOI;     //Let the GpsTrackViewController know it is holding a POI, not a GPS Track
    }
    
    gpsTrackViewCtrlr.gpsTrackPOI=tk;
    [gpsTrackViewCtrlr setTitle:tk.mainText];
    if(!tk.folder) {
        if(myid==SENDPOI) {
            [[DrawableMapScrollView sharedMap] centerMapToPOI:(POI *)tk];
        } else
        if ([((Track *)tk).nodes count]>0) {
            GPSNode * node=((Track *)tk).nodes[0];
            [[DrawableMapScrollView sharedMap] centerMapTo:node];
        }
    }
    [self.navigationController pushViewController:gpsTrackViewCtrlr animated:YES];
}
- (void)onFolderCheckBox{
    NSLog(@"onFolderCheckBox");
    [[DrawableMapScrollView sharedMap] refresh];
}
-(void)showDrawingList:(NSString *) menuTitle{
    if (menuDrawings == nil) {
        menuDrawings =[[ExpandableMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        menuDrawings.trackList=[Recorder sharedRecorder].trackArray;
        menuDrawings.trackHandlerDelegate=self;
    }
    menuDrawings.id=DRAWLIST;
    [menuDrawings setTitle:menuTitle];
    NSLOG10(@"executing showDrawingList from %@",menuTitle);
    [self.navigationController pushViewController:menuDrawings animated:YES];
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

#pragma mark ----------- Table view delegate ------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MenuItem * clickedItem=menuMatrix[indexPath.section][indexPath.row];
    if (clickedItem.menuItemHandler) {
        [self performSelector:clickedItem.menuItemHandler withObject:clickedItem.text];
    }
}
#pragma mark --------- UITextField Delegate methods--------------
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //Save DrawingDlg
	if (SAVEDRAWINGDLG==actionSheet.tag) {
		if (buttonIndex == 0){
			NSLog(@"Saving drawing cancelled");
		}else{
            UITextField * filenameField=[actionSheet textFieldAtIndex:0];
			[self saveDrawings:filenameField.text];
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Saving successful"
                message:@"Drawing saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];[alert show];
		}		
		return;
	}else if (SAVEGPSTRACKSDLG==actionSheet.tag) {
		if (buttonIndex == 0){
			NSLog(@"Saving GPS Tracks cancelled");
		}else{
            UITextField * filenameField=[actionSheet textFieldAtIndex:0];
			[self saveGPSTracks:filenameField.text];
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Saving successful"
                                                          message:@"GPS Tracks saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];[alert show];
		}		
		return;
	}else if (UNLOADDRAWCONFIRMDLG==actionSheet.tag) {
		if (buttonIndex == 0){
			NSLog(@"Removing Drawing cancelled");
		}else{  //unload drawings
            [Recorder sharedRecorder].trackArray=nil;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unload All Drawings"
                                                          message:@"All Drawings have been cleared from map" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];[alert show];
            [[DrawableMapScrollView sharedMap] refresh];
            [[Recorder sharedRecorder] saveAllTracks];      //commit the changes
        }
    }else if (UNLOADGPSCONFIRMDLG==actionSheet.tag) {
		if (buttonIndex == 0){
			NSLog(@"Removing GPS Tracks cancelled");
		}else{  //unload gps tracks
            [Recorder sharedRecorder].gpsTrackArray=nil;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unload All GPS Tracks"
                                                          message:@"All GPS Tracks have been cleared from map" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];[alert show];
            [[DrawableMapScrollView sharedMap] refresh];
            [[Recorder sharedRecorder] saveAllGpsTracks];      //commit the changes
        }
    }else if(SAVEPOISDLG==actionSheet.tag){
        if (buttonIndex == 0){
			NSLog(@"Saving POIs To File cancelled");
		}else{  //save POIs to file
            UITextField * filenameField=[actionSheet textFieldAtIndex:0];
			[self savePOIs:filenameField.text];
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Saving successful"
                                                          message:@"POIs saved to file" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];[alert show];        }
    }else if (UNLOADPOICONFIRMDLG==actionSheet.tag){
        if (buttonIndex == 0){
			NSLog(@"Unloading POIs from map cancelled");
		}else{
            [Recorder sharedRecorder].poiArray=nil;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unload All POIs"
                                                          message:@"All POIs have been cleared from map" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];[alert show];
            [[DrawableMapScrollView sharedMap] refresh];
            [[Recorder sharedRecorder] saveAllPOIs];      //commit the changes
        }
    }
}
-(void) loadDrawingFileList{
    NSString * filePath=[SaveItem absolutePath:@"drawinglistTable.tbl"];    //current version use drawinglistTable.tbl
	fileListView.list=[Recorder loadMutableArrayFrom:filePath withKey:@"drawinglistTable"];
    fileListView.view.tag=DRAWLIST;
}
-(void) loadGpsFileList{
    NSString * filePath=[SaveItem absolutePath:@"GPSTrackTable.tbl"];
	fileListView.list=[Recorder loadMutableArrayFrom:filePath withKey:@"GPSTrackTable"];
    fileListView.view.tag=GPSLIST;
}
-(void) loadPoiFileList{
    NSString * filePath=[SaveItem absolutePath:@"poiArrayTable.tbl"];
	fileListView.list=[Recorder loadMutableArrayFrom:filePath withKey:@"poiArrayTable"];
    fileListView.view.tag=POILIST;
}

//save the drawing displayname to drawing list for later retrieval
//-(void)saveToList_ORG:(SaveItem *) saveItem{
//	NSArray * drawingListTable=nil;
//    NSString * filePath=[SaveItem absolutePath:@"drawinglistTable.tbl"];    //current version use drawinglistTable.tbl
//	//if file exists
//	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//		NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
//		NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//        NSMutableArray *array=[unarchiver decodeObjectForKey:@"drawinglistTable"];      //current version use drawinglistTable
//		drawingListTable=[[NSArray alloc]initWithArray:array];    //  albums=array;  //=>this will crash the app.
//		[unarchiver finishDecoding];
//		// add the drawing
//		drawingListTable=[drawingListTable arrayByAddingObject:saveItem];   //if there was one, merger new entries with old one
//	}else{
//		drawingListTable=[[NSArray alloc] initWithObjects:saveItem,nil];    //if this is the first time saving, create a new table with the entry
//	}
//	//by now, the drawingListTable is loaded. Now save it:
//	NSMutableData * data=[[NSMutableData alloc] init];
//	NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//	
//	[archiver encodeObject:drawingListTable forKey:@"drawinglistTable"];
//	[archiver finishEncoding];
//	
//	[data writeToFile:filePath atomically:YES];
//}
-(void)saveToList:(SaveItem *) saveItem andFile:(NSString *)tblFn withKey:(NSString *)key listType:(int)listType{
	NSArray * drawingListTable=nil;
    NSString * filePath=[SaveItem absolutePath:tblFn];    //current version use drawinglistTable.tbl
	//if file exists
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
		NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
		NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableArray *array=[unarchiver decodeObjectForKey:key];      //current version use drawinglistTable
		drawingListTable=[[NSArray alloc]initWithArray:array];    //  albums=array;  //=>this will crash the app.
		[unarchiver finishDecoding];
		// add the drawing
		drawingListTable=[drawingListTable arrayByAddingObject:saveItem];   //if there was one, merger new entries with old one
	}else{
		drawingListTable=[[NSArray alloc] initWithObjects:saveItem,nil];    //if this is the first time saving, create a new table with the entry
	}
	//by now, the drawingListTable is loaded. Now save it:
	NSMutableData * data=[[NSMutableData alloc] init];
	NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[archiver encodeObject:drawingListTable forKey:key];
	[archiver finishEncoding];
	
	[data writeToFile:filePath atomically:YES];
}

-(void)saveDrawings:(NSString *)filename{
    NSLog(@"in SaveDrawings:filename = %@",filename);
	SaveItem * drawing=[[SaveItem alloc] initWithFilename:filename extension:@"draw"];
	[[Recorder sharedRecorder] saveAllTracksTo:[drawing getAbsolutePathFilename]];            //save the drawing file
    [self saveToList:drawing andFile:@"drawinglistTable.tbl" withKey:@"drawinglistTable" listType:DRAWLIST];
}
-(void)saveGPSTracks:(NSString *)filename{
    NSLog(@"in saveGPSTracks:filename = %@",filename);
	SaveItem * gpstrack=[[SaveItem alloc] initWithFilename:filename extension:@"gps"];
	[[Recorder sharedRecorder] saveAllGpsTracksTo:[gpstrack getAbsolutePathFilename]];            //save the drawing file
    [self saveToList:gpstrack andFile:@"GPSTrackTable.tbl" withKey:@"GPSTrackTable" listType:GPSLIST];
}
-(void)savePOIs:(NSString *)filename{
    NSLog(@"in savePOIs:filename = %@",filename);
	SaveItem * poi=[[SaveItem alloc] initWithFilename:filename extension:@"poi"];
	[[Recorder sharedRecorder] saveAllPOIsTo:[poi getAbsolutePathFilename]];            //save the POIs to file
    [self saveToList:poi andFile:@"poiArrayTable.tbl" withKey:@"poiArrayTable" listType:POILIST];
}
@end
