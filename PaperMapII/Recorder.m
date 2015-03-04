//
//  Recorder.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "Recorder.h"
#import "Track.h"
#import "LineProperty.h"
#import "Node.h"
#import "GPSNode.h"
#import "PM2OnScreenButtons.h"
#import "DrawableMapScrollView.h"
#import "GPSTrackPOIBoard.h"
#import "GPSTrack.h"
#import "MainQ.h"
#import "GPSTrackPOIBoard.h"
#import "PM2AppDelegate.h"
#import "PM2ViewController.h"
#import "POI.h"
#import "Settings.h"
#import "OnScreenMeter.h"

#define PI 3.1415926f
#define MAPMODE [[DrawableMapScrollView sharedMap] getMode]
@implementation Recorder

@synthesize trackArray,gpsTrackArray;
@synthesize lastGpsNode;
@synthesize POICreating,POIMoving;
@synthesize poiArray;
@synthesize userBusy;

// --- for safety saving------
@synthesize currentTrackSegment,currentTrackSegmentNodeCount,trackSegmentCount;

bool centerPos;

+ (Recorder *)sharedRecorder{
    static Recorder *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        _recording=false;
        if (trackArray) 
            self.trackArray=[[NSMutableArray alloc]initWithCapacity:5];  //initialize track array here
        if(gpsTrackArray)
            gpsTrackArray=[[NSMutableArray alloc]initWithCapacity:5];  //initialize track array here
    }
    return self;
}

- (void)start{
    if (_recording) {
        return;
    }
    //initialize track
    _track=[[Track alloc] init];
    if (!_track) {
        return;
    }
    _track.selected=true;   //auto select new drawing, of course !
    _recording=true;
    self.track.lineProperty=[[LineProperty sharedDrawingLineProperty] copy];
    if(!self.trackArray){   //when first time starting recorder, ini track array
        self.trackArray=[[NSMutableArray alloc]initWithCapacity:5];
        [self.trackArray addObject:self.track];
    }else{
        [self.trackArray addObject:self.track];
    }
}
-(void)addAMonthNamedFolder{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM"];
    NSDate * now = [NSDate date];
    NSString * yearMonth=[outputFormatter stringFromDate:now];
    MenuNode * nd=[[MenuNode alloc]initWithTitle:yearMonth asFolder:YES];
    
    //following 2 settings should be set from inside emvc
    //nd.dataSource=self;     //important,or the display / hide of track wont work
    //nd.emvc=self;           //very important, or children's checkbox wont work with parent
    
    nd.open=true;           //newly added folder is open (not important)
    
    if(!self.gpsTrackArray){   //when first time starting recorder, ini track array
        self.gpsTrackArray=[[NSMutableArray alloc]initWithCapacity:5];
        [self.gpsTrackArray addObject:nd];
    }else{
        [self.gpsTrackArray addObject:nd];
    }
    
    nd.rootArrayIndex=(int)[gpsTrackArray count]-1;      //it is the last one that is added
    //[menuList addObject:nd];
    //[self.tableView reloadData];
}
-(bool)monthFolderExist{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM"];
    NSDate * now = [NSDate date];
    NSString * yearMonth=[outputFormatter stringFromDate:now];
    
    int sz=(int)[gpsTrackArray count];
    for (int i=sz-1; i>=0; i--) {
        MenuNode * nd=[gpsTrackArray objectAtIndex:i];
        if (!nd.folder) {
            continue;    //looking for lowest folder
        }
        if ([nd.mainText compare:yearMonth]==NSOrderedSame) {
            return true;
        }
        break;      //return false if the lowerest folder name does not match
    }
    return false;
}
- (void)gpsStart{
    if (_gpsRecording) {
        return;
    }
    
    userBusy = FALSE;
    //need to show timer ?
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	bool showTimer=[defaults boolForKey:@"Show Trip Timer"];
    UILabel *lb=((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).timerLabel;
    lb.hidden=!showTimer;
    
    _gpsStartTime=[NSDate date];
    
    //initialize track
    _gpsTrack=[[GPSTrack alloc] init];
    if (!_gpsTrack) {
        return;
    }
    _gpsTrack.selected=true;  //auto select new GPS Track !
    _gpsTrack.closed=false;   // means still adding nodes, open for adding nodes
    _gpsTrack.infolder=true;
    _gpsRecording=true;
    self.gpsTrack.lineProperty=[[LineProperty sharedGPSTrackProperty] copy];   //TODO: change to GPS used line property
    if (![self monthFolderExist]) {
        [self addAMonthNamedFolder];
    }
    
    if(!self.gpsTrackArray){   //when first time starting recorder, ini track array
        self.gpsTrackArray=[[NSMutableArray alloc]initWithCapacity:5];
        [self.gpsTrackArray addObject:self.gpsTrack];
    }else{
        [self.gpsTrackArray addObject:self.gpsTrack];
    }
    
    //init some vars for the gpsrecorded trip:
    bStartGPSNode=true;
    lastLoc=0;
    currentLocation=0;
    totalTrip=0;
    totalTripRealTime=0;
    n=0;
    //just started the trip, no need to save here !!!
    //initial vars for segment saving:
    currentTrackSegmentNodeCount=0;
    trackSegmentCount=0;
    //newly added
    [self saveAllGpsTracks];        //save the gps track info first, so that if it crashes, it can have gpsTrack info and recover from segmentedly saved 100-node files
}
//starting a new track for drawing
-(void) startNewTrack{
    //initialize a track
    if (!_track) return;                    //if track not initialized, return;
    LineProperty *lp=_track.lineProperty;   //save the line property from previous track for new track
    _track=[[Track alloc] init];            //create a new track
    if (!_track) return;                    //return if failed
    _track.selected=true;                   //was using the default which is false, drawing not showing !!!
    _track.lineProperty=lp;                 //TODO: this may need to get from setings directly
    if(!self.trackArray){   //when first time starting recorder, ini track array
        self.trackArray=[[NSMutableArray alloc]initWithCapacity:5];
        [self.trackArray addObject:self.track];
    }else{
        [self.trackArray addObject:self.track];
    }    
}
//TODO: Delete following method if not used
//-(void) startNewGpsTrack{
//    //initialize a track
//    if (!_gpsTrack) return;                     //if track not initialized, return;
//    LineProperty *lp=_gpsTrack.lineProperty;    //save the line property
//    _gpsTrack=[[GPSTrack alloc] init];
//    if (!_gpsTrack) return;                     //return if failed
//    _gpsTrack.lineProperty=lp;                  //TODO: this may need to get from setings directly
//    if(!self.gpsTrackArray){   //when first time starting recorder, ini track array
//        self.gpsTrackArray=[[NSMutableArray alloc]initWithCapacity:5];
//        [self.gpsTrackArray addObject:self.gpsTrack];
//    }else{
//        [self.gpsTrackArray addObject:self.gpsTrack];
//    }
//}
- (void)stop{
    _recording=false;
    //when drawing stops, needs to save to file
    if (!self.track.nodes) { //if nothing drawn, no need to go further
        return;
    }
    //when drawing Stops, needs to save to file:
    [self.track saveNodes];
    [self saveAllTracks];
}
//stop GPS Recording
- (void)gpsStop{    
    _gpsRecording=false;
    if(lastGpsNode){
        lastGpsNode.x=0;
        lastGpsNode.y=0;
    }
    if (!self.gpsTrack.nodes) { //if nothing recorded, no need to go further
        return;
    }
    //when GPS Stops, needs to save to file:
    if([self.gpsTrack saveNodes]){
        [self deleteTempFiles];      //delete the crash recoverable gps track segment files
    }
    self.gpsTrack.closed=true;
    [self saveAllGpsTracks];
}
- (void)deleteTempFiles{
    NSFileManager * manager=[NSFileManager defaultManager];
    NSError * error=nil;
    for(int i=0;i<trackSegmentCount;i++){
        NSString * tempFilenameWithPath=[self.gpsTrack dataFilePathWith:i];
        [manager removeItemAtPath:tempFilenameWithPath error:&error];
    }
}
-( void)undo{
    NSMutableArray *tar=[[NSMutableArray alloc] initWithArray:self.track.nodes];
    [tar removeLastObject];
    self.track.nodes = tar;
}
-(void)unloadTracks{
    [self stop];
    [self gpsStop];
    [trackArray removeAllObjects];
    [gpsTrackArray removeAllObjects];
}
-(void)unloadGPSTracks{
    [self gpsStop];
    [gpsTrackArray removeAllObjects];
}
-(void)unloadDrawings{
    [self stop];
    [trackArray removeAllObjects];
}

-(NSString *)dataFilePath{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"DrawList.plist"];
}
-(NSString *)gpsDataFilePath{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"GpsList.plist"];
}
-(NSString *)poiFilePath{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"PoiList.plist"];
}
-(void) saveAllTracks{
    [self saveAllTracksTo:[self dataFilePath]];
}
- (void)saveAllTracksTo:(NSString *)filePath{
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:trackArray forKey:@"trackArray"];
    [archiver finishEncoding];
    
    [data writeToFile:filePath atomically:YES];
}
-(void) saveAllGpsTracks{
    [self saveAllGpsTracksTo:[self gpsDataFilePath]];
}
-(void) saveAllGpsTracksTo:(NSString *)filePath{
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:gpsTrackArray forKey:@"gpsTrackArray"];
    [archiver finishEncoding];

    [data writeToFile:filePath atomically:YES];
}
-(void) saveAllPOIs{
    [self saveAllPOIsTo:[self poiFilePath]];
}
-(void) saveAllPOIsTo:(NSString *)filePath{
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:poiArray forKey:@"poiArray"];
    [archiver finishEncoding];
    
    [data writeToFile:filePath atomically:YES];
}
-(void)initializeAllTracks{
    if (trackArray) {
        NSLog(@"something is wrong, drawing track array is not nil !!!!");
        return;
    }
    //initialize arrAllTracks
    NSString * filePath=[self dataFilePath];
    [self loadAllTracksFrom:filePath];
}
-(void)loadAllTracksFrom:(NSString *)filePath{
    NSMutableArray * trackArray2=[Recorder loadMutableArrayFrom:filePath withKey:@"trackArray"];
    if (trackArray2) {
        if (trackArray) {
            [trackArray addObjectsFromArray:(NSArray *)trackArray2];
        }else{
            trackArray=trackArray2;
        }
    }
    if(!trackArray)
        trackArray=[[NSMutableArray alloc]initWithCapacity:2];
}
+(NSMutableArray *)loadMutableArrayFrom:(NSString *)filePath withKey:(NSString *)key{
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        NSMutableArray * trackArray1=[unarchiver decodeObjectForKey:key];
        return trackArray1;
    }
    return nil;
}

-(void)initializeAllGpsTracks{
    if (gpsTrackArray) {
        NSLog(@"something is wrong, gps track array is not nil !!!!");
        return;
    }
    //initialize arrAllTracks
    NSString * filePath=[self gpsDataFilePath];
    [self loadAllGPSTracksFrom:filePath];
}
-(void)loadAllGPSTracksFrom:(NSString *)filePath{
    NSMutableArray * trackArray2=[Recorder loadMutableArrayFrom:filePath withKey:@"gpsTrackArray"];
    if (trackArray2) {
        if (gpsTrackArray) {
            [gpsTrackArray addObjectsFromArray:(NSArray *)trackArray2];
        }else{
            gpsTrackArray=trackArray2;
        }
    }
    if(!gpsTrackArray)
        gpsTrackArray=[[NSMutableArray alloc]initWithCapacity:2];
}

-(void)initializeAllPOIs{
    if (poiArray) {
        NSLog(@"something is wrong, poi array is not nil !!!!");
        return;
    }
    //initialize poiArray
    NSString * filePath=[self poiFilePath];
    [self loadAllPOIsFrom:filePath];
}
-(void)loadAllPOIsFrom:(NSString *)filePath{
    NSMutableArray * poiArray2=[Recorder loadMutableArrayFrom:filePath withKey:@"poiArray"];
    if (poiArray2) {
        if (poiArray) {
            [poiArray addObjectsFromArray:(NSArray *)poiArray2];
        }else{
            poiArray=poiArray2;
        }
    }
    if(!poiArray)
        poiArray=[[NSMutableArray alloc]initWithCapacity:2];
}
//-(void)loadAllTracksFrom_ORG:(NSString *)filePath{
//    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
//        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//
//        NSMutableArray * trackArray1=[unarchiver decodeObjectForKey:@"trackArray"];
//        [unarchiver finishDecoding];
//        if (trackArray) {
//            [trackArray addObjectsFromArray:(NSArray *)trackArray1];
//        }else{
//            trackArray=trackArray1;
//        }
//    }
//    if(!trackArray)
//        trackArray=[[NSMutableArray alloc]initWithCapacity:2];
//}

//-(void)initializeAllGpsTracks_ORG{
//    //initialize arrAllTracks
//    NSString * filePath=[self gpsDataFilePath];
//    //NSLog(@"data file path=%@",filePath);
//    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
//        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//
//        gpsTrackArray=[unarchiver decodeObjectForKey:@"gpsTrackArray"];
//        [unarchiver finishDecoding];
//    }
//
//    if(!gpsTrackArray)
//        gpsTrackArray=[[NSMutableArray alloc]initWithCapacity:2];
//}
//-(void)initializeAllPOIs_ORG{
//    //initialize arrAllTracks
//    NSString * filePath=[self poiFilePath];
//    //NSLog(@"data file path=%@",filePath);
//    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
//        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//        
//        poiArray=[unarchiver decodeObjectForKey:@"poiArray"];
//        [unarchiver finishDecoding];
//    }
//    
//    if(!poiArray)
//        poiArray=[[NSMutableArray alloc]initWithCapacity:2];
//}
-(void) createPOI:(CGPoint)poiPoint{
	POI *poi=[[POI alloc] initWithPoint:poiPoint];
	poi.res=[DrawableMapScrollView sharedMap].maplevel;
	poi.title=nil;
    poi.selected=true;
    
    if(!poiArray){   //when first time starting recorder, ini poi array
        poiArray=[[NSMutableArray alloc]initWithCapacity:5];
    }
    [poiArray addObject:poi];
    [[DrawableMapScrollView sharedMap] refresh];
}
#pragma mark ------------------PM2RecordingDelegate method---------
-(BOOL)closeEnoughForCurrentRes:(POI *) poi from:(CGPoint)tapPoint{
    if (poi.folder) {
        return FALSE;
    }
	if (poi.res==[DrawableMapScrollView sharedMap].maplevel) {
		if((abs(poi.x-tapPoint.x)<50)&&((abs(poi.y-tapPoint.y)<50))){
			poi.x=tapPoint.x-0;
			poi.y=tapPoint.y-0;
			return TRUE;
		}
		return FALSE;
	}
	CGFloat totalPixOld=256*pow(2,poi.res);
	CGFloat totalPixCur=256*pow(2,[DrawableMapScrollView sharedMap].maplevel);
	CGFloat x=poi.x*totalPixCur/totalPixOld;
	CGFloat y=poi.y*totalPixCur/totalPixOld;
	if((abs(x-tapPoint.x)<50)&&((abs(y-tapPoint.y)<50))){
		poi.res=[DrawableMapScrollView sharedMap].maplevel;
		poi.x=tapPoint.x-0;
		poi.y=tapPoint.y-0;
		return TRUE;
	}
	return FALSE;
}

- (void)mapLevel:(int)maplevel singleTapAtPoint:(CGPoint)tapPoint{
    if(POICreating){
        [self createPOI:tapPoint];
		POICreating=FALSE;
		//[self showHelpMessages:USEPINCH];
		return; 
    }else if(POIMoving){
        for (POI *poi in poiArray) {
            if (!poi.selected) {
                continue;
            }
			if ([self closeEnoughForCurrentRes:poi from:tapPoint]) {
				[[DrawableMapScrollView sharedMap] refresh];
				break;
			}
		}
        return;
    }
    ////////////////drawing code follows///////////////////////////
    if(!_recording){   //if not recording, do not create the node for the tappoint
        return;
    }
    if((tapPoint.x==0)||(tapPoint.y==0)){   //signal for starting a new track
        [self startNewTrack];
        return;
    }
    Node *node=[[Node alloc]initWithPoint:tapPoint mapLevel:maplevel];
    self.track.nodes=[self addAnyModeAdjustedNode:self.track.nodes Node:node Mode:MAPMODE];
    self.track.nodesDirtyFlag=true;
    [self.track saveNodes];     //save it for every nodes
    [[DrawableMapScrollView sharedMap] refresh];
}
- (BOOL)getPOICreating{
    return POICreating;
}
- (BOOL)getPOIMoving{
    return POIMoving;
}
//=====add a node to array arrNodes=================
-(NSArray *) addAnyModeAdjustedNode:(NSArray*)arrNodes Node:(Node *)node Mode:(bool)mode{
    if ([arrNodes count]<1) {
        return [self addNode:node to:arrNodes];
    }
    Node * lastNode=[arrNodes lastObject];
    int maplevel=node.r;
    if(lastNode.r==maplevel){
        int middleVerticalLine=TSIZE*pow(2, maplevel-1);
        if(((lastNode.x<middleVerticalLine)&&(node.x<middleVerticalLine)) ||
           ((lastNode.x>=middleVerticalLine)&&(node.x>=middleVerticalLine))){
            arrNodes=[self addNode:node to:arrNodes];
        }else{
             if (!MAPMODE) {  //mapmode adjust x of node and last node;
                Node * adjNode=[node copy];
                Node * adjLastNode=[lastNode copy];
                 
                adjNode.x    =[self ModeAdjust:node.x res:node.r];
                adjLastNode.x=[self ModeAdjust:lastNode.x res:lastNode.r];
                                 
                Node * LNode=[self getLNode:adjNode lastNode:adjLastNode mapLevel:maplevel];
                Node * RNode=[self getRNode:adjNode lastNode:adjLastNode mapLevel:maplevel];
                //adjust back before adding to array
                LNode.x=[self ModeAdjust:LNode.x res:lastNode.r];
                RNode.x=[self ModeAdjust:RNode.x res:lastNode.r];
                Node * TerminateNode=[[Node alloc]initWithPoint:CGPointMake(0, 0) mapLevel:maplevel];   //y==0 means last node is a terminating node
                if(adjLastNode.x<middleVerticalLine){
                    arrNodes=[self addNode:LNode to:arrNodes];
                    arrNodes=[self addNode:TerminateNode to:arrNodes];
                    arrNodes=[self addNode:RNode to:arrNodes];
                    arrNodes=[self addNode:node to:arrNodes];
                }else{
                    arrNodes=[self addNode:RNode to:arrNodes];
                    arrNodes=[self addNode:TerminateNode to:arrNodes];
                    arrNodes=[self addNode:LNode to:arrNodes];
                    arrNodes=[self addNode:node to:arrNodes];
                }
                return arrNodes; //return for Eastern map mode
            }
            //for Western map mode
            Node * LNode=[self getLNode:node lastNode:lastNode mapLevel:maplevel];
            Node * RNode=[self getRNode:node lastNode:lastNode mapLevel:maplevel];
            Node * TerminateNode=[[Node alloc]initWithPoint:CGPointMake(0, 0) mapLevel:maplevel];  //y==0 means last node is a terminating node
            if(lastNode.x<middleVerticalLine){
                arrNodes=[self addNode:LNode to:arrNodes];
                arrNodes=[self addNode:TerminateNode to:arrNodes];
                arrNodes=[self addNode:RNode to:arrNodes];
                arrNodes=[self addNode:node to:arrNodes];
            }else{
                arrNodes=[self addNode:RNode to:arrNodes];
                arrNodes=[self addNode:TerminateNode to:arrNodes];
                arrNodes=[self addNode:LNode to:arrNodes];
                arrNodes=[self addNode:node to:arrNodes];
            }
            return arrNodes;
        }        
    }else//if not the same maplevel, just simply add the node for now, which might create a problem for across hemisphare lines
        arrNodes=[self addNode:node to:arrNodes];
    return arrNodes;
}
-(Node *)getLNode:(Node *)node lastNode:(Node *)lastNode  mapLevel:(int)maplevel{
    int Xm=TSIZE*pow(2, maplevel-1)-1;
    int Ym=(Xm-lastNode.x)*(node.y-lastNode.y)/(node.x-lastNode.x)+lastNode.y;
    return [[Node alloc]initWithPoint:CGPointMake(Xm, Ym) mapLevel:maplevel];
}
-(Node *)getRNode:(Node *)node lastNode:(Node *)lastNode  mapLevel:(int)maplevel{
    int Xm=TSIZE*pow(2, maplevel-1);//+1;
    int Ym=(Xm-lastNode.x)*(node.y-lastNode.y)/(node.x-lastNode.x)+lastNode.y;
    return [[Node alloc]initWithPoint:CGPointMake(Xm, Ym) mapLevel:maplevel];
}
-(NSArray *) addNode:(Node *)node to:(NSArray *)arrNodes{
    if (!arrNodes) {
        arrNodes=[[NSArray alloc]initWithObjects:node,nil];
    }else{
        arrNodes=[arrNodes arrayByAddingObject:node];
    }
    return arrNodes;
}
-(int)ModeAdjust:(int)x res:(int)r{
    if(MAPMODE)
        return x;
    int H=TSIZE*pow(2,r-1);
    if(x<H)
        return x+H;
    return x-H;
}
#pragma mark ------------------ CLLocationManagerDelegate method -------------
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    @synchronized(self) {
		if(userBusy)return;
 	}
    if([DrawableMapScrollView sharedMap].zooming) return;   //if zooming, do nothing to improve performance
    if([DrawableMapScrollView sharedMap].dragging||[DrawableMapScrollView sharedMap].tracking)return; //do nothing if it has started dragging.
    if (((PM2AppDelegate *)[UIApplication sharedApplication].delegate).viewController.orientationChanging) return;

    if(!_gpsRecording){   //if not recording, do not create the node
        return;
    }
    
    NSUInteger size=locations.count;
    if (size <=0 ) {
        return;
    }
    for (int i=0; i<size; i++) {
        CLLocation * newLocation=[locations objectAtIndex:i];
        
        [self displayAccuracy:newLocation];
        
        double Lat=newLocation.coordinate.latitude;
        double Long=newLocation.coordinate.longitude;
        
        int resM=18;   //use max resolution for best accuracy  //v163
        
        int xM=pow(2,resM)*0.711111111*(Long+180);						 //256/360=0.7111111111
        int yM=pow(2,resM)*1.422222222*(90-[self GetScreenY:Lat]);		 //256/180=1.4222222222
        
        //show speed panel
        [self showSpeed:newLocation.speed];         //speed update every second
        [self showAltitude:newLocation.altitude];   //alt update every second
        [self showTripTimer];
        if(newLocation.horizontalAccuracy>10){ //if acuracy is not accurate enough, do nothing further for this location
            continue;
        }
        //========Accuracy is enough, go ahead and record it=================
        CGPoint GPSPoint;
        GPSPoint.x=xM;
        GPSPoint.y=yM;
        GPSNode *node=[[GPSNode alloc]initWithPoint:GPSPoint mapLevel:resM];
            
        if(centerPos||[[Settings sharedSettings] getSetting:DIRECTION_UP]){
            [[DrawableMapScrollView sharedMap] centerMapTo:node];
        }

        //add a gps node to our node array for gps track
        [self addGpsNode:node with:newLocation];
        //hide this saveing task in addGpsNode
        //[self.gpsTrack saveNodes];        //TODO: may need to change to saving every 5 nodes or more for performance
        if (i>=(size-1)) {              //only update trip meter and change orientation at the newest location
            [self showTripMeter];
            if (!((PM2AppDelegate *)[UIApplication sharedApplication].delegate).viewController.orientationChanging) {
                [self adjustMapRotateDegree:newLocation.course];
            }
        }
    }
}
//update the map rotating degree every second
-(void)adjustMapRotateDegree:(CLLocationDirection )course{
    if ([[Settings sharedSettings] getSetting:DIRECTION_UP]) {
        CGAffineTransform transform = CGAffineTransformMakeRotation(-1*course*3.1415926f/180);
        [UIView beginAnimations:nil context:NULL];
        [DrawableMapScrollView sharedMap].transform = transform;    //rotate map
        [UIView commitAnimations];
        [self updateArrowDirection:0];              //both lines work
        //[self updateArrowDirection:course*PI/180];
        ((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).compassBn.direction=-1*course*3.1415926f/180;
    }else{
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        [UIView beginAnimations:nil context:NULL];
        [DrawableMapScrollView sharedMap].transform = transform;    //rotate map
        [UIView commitAnimations];
        [self updateArrowDirection:course*PI/180];
        ((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).compassBn.direction=0;
    }
    [((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).compassBn setNeedsDisplay];
}
//
//-(void)updateMapRotateDegree{
//    CGRect windowfr = [[UIScreen mainScreen] bounds];
//    if ([[Settings sharedSettings] getSetting:DIRECTION_UP]) {
//        directionUp=true;
//        int W=windowfr.size.width;
//        int H=windowfr.size.height;
//        //int M=W>H?W:H;
//        [[DrawableMapScrollView sharedMap] setFrame:CGRectMake((W-1280)/2,(H-1280)/2,1280,1280)];
//        zmc=1.3;
//    }else {
//        directionUp=false;
//        int W=windowfr.size.width;
//        int H=windowfr.size.height;
//        [[DrawableMapScrollView sharedMap] setFrame:CGRectMake(0,0,W,H)];
//        zmc=1.0;
//    }
//}
//-(void)updateMapRotateDegree2:(CLLocationDirection )course{
//    CGAffineTransform transform = CGAffineTransformMakeRotation(-1*course*3.1415926f/180);
//    [UIView beginAnimations:nil context:NULL];
//    [DrawableMapScrollView sharedMap].transform = transform;    //rotate map
//    [UIView commitAnimations];
//}
bool centerCurrentLocation = TRUE;   //TODO: move this to property settings
bool directionUp=FALSE;              //TODO: move this to property settings
float mapLeftThereDirection=0;       //TODO: assign and keep it an appropriate value
-(void)updateArrowDirection:(float)direction{
	//update arrow direction
	CGAffineTransform transform = CGAffineTransformMakeRotation(-3.1415926f/2+direction);
	if (directionUp&&centerCurrentLocation) {
		transform = CGAffineTransformMakeRotation(-3.1415926f/2);
	}else if (directionUp&&!centerCurrentLocation) {
		transform = CGAffineTransformMakeRotation(-3.1415926f/2+direction-mapLeftThereDirection);
	}
    MainQ * mQ=[MainQ sharedManager];
    UIImageView * arrow =(UIImageView *)[mQ getTargetRef:GPSARROW];
    if ([arrow isEqual:@"0"]) {
        return;
    }
    GPSTrackPOIBoard * trackBoard=[DrawableMapScrollView sharedMap].gpsTrackPOIBoard; //(GPSTrackPOIBoard *)[mQ getTargetRef:GPSTRACKPOIBOARD];
    arrow.transform=transform;
    
    //update the arrow position
    CGPoint arrowCenter;
    if ((lastGpsNode.x>0)&&(lastGpsNode.y>0)) {
        arrowCenter=[trackBoard ConvertPoint:lastGpsNode];
    }else{
        arrowCenter=[trackBoard ConvertPoint:(GPSNode *)[self.gpsTrack.nodes lastObject]];
    }
    PM2AppDelegate * appD=[[UIApplication sharedApplication] delegate];
	CGPoint arrowCenter0=[trackBoard  convertPoint:arrowCenter toView:appD.viewController.view];
    
    //No Animation !!!
//    [UIView beginAnimations:@"MoveArrow" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelay:0];
        arrow.center=arrowCenter0;
//    [UIView commitAnimations];
}
-(void)showTripMeter{
    if(!_gpsRecording)return;
    //MainQ * mQ=[MainQ sharedManager];
    //UILabel * lb=(UILabel *)[mQ getTargetRef:TRIPMETER];
    OnScreenMeter *lb=((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).tripLabel;
    
    NSString *tripString;
    
    bool bMetric=false;
    if (bMetric) {
        if (totalTripRealTime<10000)  //less than 10km
            tripString=[[NSString alloc] initWithFormat:@" %4.3f ", totalTripRealTime/1000];
        else if (totalTripRealTime<20000)  //less than 20km
            tripString=[[NSString alloc] initWithFormat:@" %4.2f", totalTripRealTime/1000];
        else
            tripString=[[NSString alloc] initWithFormat:@" %4.1f", totalTripRealTime/1000];
    }else{
        if (totalTripRealTime<10000)  //less than 10km
            tripString=[[NSString alloc] initWithFormat:@" %.3f", totalTripRealTime/1609.344];
        else if (totalTripRealTime<20000)  //less than 20km
            tripString=[[NSString alloc] initWithFormat:@" %.2f", totalTripRealTime/1609.344];
        else
            tripString=[[NSString alloc] initWithFormat:@" %.1f", totalTripRealTime/1609.344];
    }
    [lb setText:tripString];
}
-(void)showAltitude:(CLLocationDistance)altitude{
    //MainQ * mQ=[MainQ sharedManager];
    //UILabel * lb=(UILabel *)[mQ getTargetRef:ALTITUDELABEL];
    UILabel *lb=((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).heightLabel;
    if ([lb isEqual:@"0"]) {
        return;
    }
    NSString *altString;
    bool bMetric=false;
    if (bMetric) {
        altString=[[NSString alloc] initWithFormat:@"%4.1f", altitude];
    }else
        altString=[[NSString alloc] initWithFormat:@"%.0f", altitude*3.28084];
    [lb setText:altString];
}
-(void)showTripTimer{
    NSDate * now = [NSDate date];
    NSTimeInterval tm=[now timeIntervalSinceDate:_gpsStartTime];
    UILabel *lb=((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).timerLabel;
    NSString * altString=[[NSString alloc]initWithFormat:@"%02.0f:%02.0f:%02.0f",floor(tm/3600),fmod(floor(tm/60),60),fmod(tm,60)];
    [lb setText:altString];
}
-(void)showSpeed:(CLLocationSpeed)speed{
    //MainQ * mQ=[MainQ sharedManager];
    //UILabel * lb=(UILabel *)[mQ getTargetRef:SPEEDLABEL];
    //UILabel * altlb=(UILabel *)[mQ getTargetRef:ALTITUDELABEL];
    //UILabel * trplb=(UILabel *)[mQ getTargetRef:TRIPMETER];
    UILabel *lb=(UILabel *)((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).speedLabel;
    UILabel *lb1=(UILabel *)((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).heightLabel;
    UILabel *lb2=(UILabel *)((PM2OnScreenButtons *)[PM2OnScreenButtons sharedBnManager]).tripLabel;
    if ([lb isEqual:@"0"]) {
        lb1.hidden=YES;
        lb2.hidden=YES;
        return;
    }
    bool bMetric=false;
    if(speed>0.6){    //> 1.34 mph
        if(bMetric){
			float howfast=speed*(3600.00/1000);
			NSString *speedString;
			if(howfast>100)
				speedString=[[NSString alloc] initWithFormat:@"%4.0f  ", howfast];
			else
				speedString=[[NSString alloc] initWithFormat:@"%4.1f  ", howfast];
			[lb setText:speedString];
		}else{
			float howfast=speed*(3600.00/1609.344);
			NSString *speedString;
			if(howfast>100)
				speedString=[[NSString alloc] initWithFormat:@"%4.0f  ", howfast];
			else
				speedString=[[NSString alloc] initWithFormat:@"%4.1f  ", howfast];
			[lb setText:speedString];
		}
        lb.hidden=(![[Settings sharedSettings] getSetting:HIDE_SPEED_METER]);  //speed
        lb1.hidden=(![[Settings sharedSettings] getSetting:HIDE_ALT_METER]);   //height
        lb2.hidden= (![[Settings sharedSettings] getSetting:HIDE_TRIP_METER]);  //trip meter
	}else{
		lb.hidden=YES;  //<==YES;
        //lb1.hidden=YES;  //<==YES;  Altitude panel should not hide with speed panel when speed gets to 0 at traffic lights
        //lb2.hidden=YES;  //<==YES;  Tripmeter panel should not hide with speed panel when speed gets to 0 at traffic lights
	}
}
bool bStartGPSNode;
CLLocation *lastLoc;
CLLocation *currentLocation;
CLLocationDistance totalTrip;
CLLocationDistance totalTripRealTime;
int n=0;  //gps node counter
-(void) addGpsNode:(GPSNode *)node with:(CLLocation *)newLocation{
    bool bFarEnough=false;
    
    CLLocationSpeed speed=newLocation.speed;
    int minDistance=15; //in meters
	if(speed>0.6){                 //>1.34 mph
		//speed sensitive point distance on gps track, added on 10/24/2010
        if (speed<5) {	 //about 11 mph
			minDistance=10;
        }else if (speed > 10) {  //about 22.37 mph
            minDistance=15;
        }else if (speed > 15) {  //about 33.56 mph
            minDistance=25;
        }else if (speed > 20) {  //about 45 mph
			minDistance=25;
        }else if (speed > 30) {  //about 63 mph
			minDistance=30;
		}else if (speed > 100) {  //about 225 mph, for airplane about to land or just taking off
            minDistance=500;
        }else if (speed > 200) {  //about 447 mph, for airplane normal long distance crusing
            minDistance=2000;
        }
    }
    CLLocationDistance distance=0;
    if(bStartGPSNode){
        bFarEnough=true;        //log the first location
        lastLoc=newLocation;
        bStartGPSNode=false;    //missed this, so that distance never got added up
    }else{			// if not first node, check the minimu distance traveled before add a node:
		distance=[newLocation distanceFromLocation:lastLoc];
		if(distance>minDistance){
			lastLoc=newLocation;
			bFarEnough=true;
            totalTrip+=distance;        //calculate the trip distance
            totalTripRealTime=totalTrip;
            node.distanceFromLastNode=distance;  //distanceFromLastNode is set here
		}
    }
    
    node.timestamp=newLocation.timestamp;
    node.altitude=newLocation.altitude;
    node.speed=newLocation.speed;
    node.longitude=newLocation.coordinate.longitude;
    node.latitude=newLocation.coordinate.latitude;
    node.direction=newLocation.course;
    node.distanceFromStart=totalTrip;
    if(bFarEnough){
        self.gpsTrack.nodes=[self addGPSNode:node to:self.gpsTrack.nodes];       //this add looks stupid, but it embeds the mode adjustment to each node!
        self.gpsTrack.tripmeter=totalTrip;
        self.gpsTrack.nodesDirtyFlag=true;
        //////////////////////////////////////segments saving to file ////////////
        self.currentTrackSegment.nodes=[self addGPSNode:node to:self.currentTrackSegment.nodes];        //<===added to save to a small file
        self.currentTrackSegment.nodesDirtyFlag=true;
        self.currentTrackSegment.tripmeter=totalTrip;
        [self.currentTrackSegment saveNodesToFile:trackSegmentCount];    //save to current seg related file depending on the trackSegmentCount; save to a file on every new incomming node to the same file for 100 new nodes
        currentTrackSegmentNodeCount++;
        if(currentTrackSegmentNodeCount>100){       //<===this number should be adjusted according to performace. if it was too slow, make the number smaller
            trackSegmentCount++;  //increase index      // increate count number so that the temp file name could be different for every 100 nodes!
                                                        //(should clear temp file when all trip have been successfully saved,done yet ? TODO:)
                                                        //=========>[currentTrackSegment.nodes removeAllObjects];
            NSMutableArray * temp=[[NSMutableArray alloc] initWithArray:currentTrackSegment.nodes];
            [temp removeAllObjects];
            currentTrackSegment.nodes=temp;
            currentTrackSegmentNodeCount=0;
        }
        //////////////////////////////////////end of saving block////////////////
    }else{ //not far enough
        self.gpsTrack.tripmeter=totalTrip+distance;   //not far enough, but still need to update every seconds the trip meter!
        totalTripRealTime=totalTrip+distance;
    }
    if (_gpsRecording==true) {
        lastGpsNode=[node copy];  //TODO: handle the lastGPSNode properly, if no need, just delete it!
    }else{
        lastGpsNode.x=0;
        lastGpsNode.y=0;
    }
    //NSLOG10(@"Recorder.lastGpsNode=(%d,%d)",lastGpsNode.x,lastGpsNode.y);
    //[[DrawableMapScrollView sharedMap].gpsTrackPOIBoard setNeedsDisplay];
    [[DrawableMapScrollView sharedMap] refresh];
}
-(NSArray *) addGPSNode:(GPSNode *)node to:(NSArray *)arrGpsNodes{
    if(!_gpsRecording){   //if not recording, do not create the node for the node
        return arrGpsNodes;
    }
    return [self addAnyModeAdjustedNode:arrGpsNodes Node:node Mode:MAPMODE];
}
//#define PI 3.1415926
-(double)GetScreenY:(double)lat{
	double y1=lat*PI/180;
	double y=0.5*log((1+sin(y1))/(1-sin(y1)));
	return y*180/PI/2;
}
-(void)displayAccuracy:(CLLocation *)newLocation{
    MainQ * mQ=[MainQ sharedManager];
    UILabel * lb=(UILabel *)[mQ getTargetRef:MESSAGELABEL];
    if ([lb isEqual:@"0"]) {
        return;
    }
    n++;
    float accuracy=newLocation.horizontalAccuracy;
    NSString * msg=[[NSString alloc]initWithFormat:@"Starting GPS, Accuracy=%3.1f meters (%d)",accuracy,n];
    [lb setText:msg];
    if(accuracy>50){  //if acuracy is not accurate enough, do nothing
        [lb setTextColor:[UIColor redColor]];
    }else{
        [lb setTextColor:[UIColor greenColor]];
    }
}
//---------Received emailed file loading----------------------------------
-(void) addDrawingFile:(NSString *)fn{}
-(void) loadGPSTrackFromFile:(NSString *)fn{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString * documentsDirectory=[paths objectAtIndex:0];
    NSString * filePath=[documentsDirectory stringByAppendingPathComponent:fn];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //NSMutableArray * tmp=[[NSMutableArray alloc] initWithArray:gpsTrackArray];
        //GPSTrack * gpsTrack=[unarchiver decodeObjectForKey:@"gpsTrackOnly"];
        NSMutableArray * receivedGpsTrackArray=[unarchiver decodeObjectForKey:@"gpsTrackOnly"];
        //[tmp addObjectsFromArray:array];
        //nodeList=tmp;    //  albums=array;  //=>this will crash the app.
        [unarchiver finishDecoding];
        if(!self.gpsTrackArray){  //when first time starting recorder, ini track array
            self.gpsTrackArray=[[NSMutableArray alloc]initWithCapacity:5];
        }
        [self.gpsTrackArray addObjectsFromArray:receivedGpsTrackArray];
    }
    //[self saveAllGpsTracks];   //may not need it since it is handled in gpstrack decode method
}
-(void) loadPOIFile:(NSString *)fn{}

@end
