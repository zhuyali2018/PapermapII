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


#define PI 3.1415926f
#define MAPMODE [[DrawableMapScrollView sharedMap] getMode]
@implementation Recorder

@synthesize trackArray,gpsTrackArray;
@synthesize lastGpsNode;
@synthesize POICreating;
@synthesize poiArray;

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
- (void)gpsStart{
    if (_gpsRecording) {
        return;
    }
    //initialize track
    _gpsTrack=[[GPSTrack alloc] init];
    if (!_gpsTrack) {
        return;
    }
    _gpsTrack.selected=true;  //auto select new GPS Track !
    _gpsRecording=true;
    self.gpsTrack.lineProperty=[[LineProperty sharedGPSTrackProperty] copy];   //TODO: change to GPS used line property
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
    n=0;
    [self saveAllGpsTracks];  //to provent from crashing and losing data during GPS Recording
}
-(void) startNewTrack{
    //initialize a track
    if (!_track) return;                    //if track not initialized, return;
    LineProperty *lp=_track.lineProperty;   //save the line property 
    _track=[[Track alloc] init];
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
-(void) startNewGpsTrack{
    //initialize a track
    if (!_gpsTrack) return;                     //if track not initialized, return;
    LineProperty *lp=_gpsTrack.lineProperty;    //save the line property
    _gpsTrack=[[GPSTrack alloc] init];
    if (!_gpsTrack) return;                     //return if failed
    _gpsTrack.lineProperty=lp;                  //TODO: this may need to get from setings directly
    if(!self.gpsTrackArray){   //when first time starting recorder, ini track array
        self.gpsTrackArray=[[NSMutableArray alloc]initWithCapacity:5];
        [self.gpsTrackArray addObject:self.gpsTrack];
    }else{
        [self.gpsTrackArray addObject:self.gpsTrack];
    }
}
- (void)stop{
    _recording=false;
}
//stop GPS Recording
- (void)gpsStop{    
    _gpsRecording=false;
    if(lastGpsNode){
        lastGpsNode.x=0;
        lastGpsNode.y=0;
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
     NSMutableData * data=[[NSMutableData alloc] init];
     NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
     [archiver encodeObject:trackArray forKey:@"trackArray"];
     [archiver finishEncoding];
     
     [data writeToFile:[self dataFilePath] atomically:YES];
}
-(void) saveAllGpsTracks{
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:gpsTrackArray forKey:@"gpsTrackArray"];
    [archiver finishEncoding];

    [data writeToFile:[self gpsDataFilePath] atomically:YES];
}
-(void) saveAllPOIs{
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:poiArray forKey:@"poiArray"];
    [archiver finishEncoding];
    
    [data writeToFile:[self poiFilePath] atomically:YES];
}
-(void)initializeAllTracks{
    //initialize arrAllTracks
    NSString * filePath=[self dataFilePath];
    //NSLog(@"data file path=%@",filePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];

        trackArray=[unarchiver decodeObjectForKey:@"trackArray"];
        [unarchiver finishDecoding];
    }
    if(!trackArray)
        trackArray=[[NSMutableArray alloc]initWithCapacity:2];
}
-(void)initializeAllGpsTracks{
    //initialize arrAllTracks
    NSString * filePath=[self gpsDataFilePath];
    //NSLog(@"data file path=%@",filePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];

        gpsTrackArray=[unarchiver decodeObjectForKey:@"gpsTrackArray"];
        [unarchiver finishDecoding];
    }

    if(!gpsTrackArray)
        gpsTrackArray=[[NSMutableArray alloc]initWithCapacity:2];
}
-(void)initializeAllPOIs{
    //initialize arrAllTracks
    NSString * filePath=[self poiFilePath];
    //NSLog(@"data file path=%@",filePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        poiArray=[unarchiver decodeObjectForKey:@"poiArray"];
        [unarchiver finishDecoding];
    }
    
    if(!poiArray)
        poiArray=[[NSMutableArray alloc]initWithCapacity:2];
}
-(void) createPOI:(CGPoint)poiPoint{
	POI *poi=[[POI alloc] initWithPoint:poiPoint];
	poi.res=[DrawableMapScrollView sharedMap].maplevel;
	poi.title=nil;
    
    if(!poiArray){   //when first time starting recorder, ini poi array
        poiArray=[[NSMutableArray alloc]initWithCapacity:5];
    }
    [poiArray addObject:poi];
    [[DrawableMapScrollView sharedMap] refresh];
}
#pragma mark ------------------PM2RecordingDelegate method---------

- (void)mapLevel:(int)maplevel singleTapAtPoint:(CGPoint)tapPoint{
    if(POICreating){
        [self createPOI:tapPoint];
		POICreating=FALSE;
		//[self showHelpMessages:USEPINCH];
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
    [self.track saveNodes];     //save it for every nodes
    [[DrawableMapScrollView sharedMap] refresh];
}
- (BOOL)getPOICreating{
    return POICreating;
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
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self displayAccuracy:newLocation];
    if(!_gpsRecording){   //if not recording, do not create the node
        return;
    }
    //if(self.gpsTrack.timestamp < newLocation.timestamp)
    //    return; //do not record those before the track was created
    
     //========Accuracy is enough, go ahead and record it=================
    double Lat=newLocation.coordinate.latitude;
	double Long=newLocation.coordinate.longitude;
	
	//int res=((MapScrollView *)[DrawableMapScrollView sharedMap]).maplevel;
	int resM=18;   //use max resolution for best accuracy  //v163
	
	int xM=pow(2,resM)*0.711111111*(Long+180);						 //256/360=0.7111111111
	int yM=pow(2,resM)*1.422222222*(90-[self GetScreenY:Lat]);		 //256/180=1.4222222222
	
    //x,y used to center the map below
	//int x=pow(2,res)*0.711111111*(Long+180);						 //256/360=0.7111111111
	//int y=pow(2,res)*1.422222222*(90-[self GetScreenY:Lat]);		 //256/180=1.4222222222
	
     //show speed panel
    [self showSpeed:newLocation.speed];
    [self showAltitude:newLocation.altitude];
    
    if(newLocation.horizontalAccuracy>10){ //if acuracy is not accurate enough, do nothing further
        return;
	}
    
	CGPoint GPSPoint;
	GPSPoint.x=xM;
	GPSPoint.y=yM;
    GPSNode *node=[[GPSNode alloc]initWithPoint:GPSPoint mapLevel:resM];
    
    //center the current position
    if(centerPos)
        //[self centerPositionAtX:x Y:y];
        [[DrawableMapScrollView sharedMap] centerMapTo:node];

    //add a gps node to our node array for gps track
    [self addGpsNode:node with:newLocation];   
    [self.gpsTrack saveNodes];        //TODO: may need to change to saving every 5 nodes or more for performance
    [self showTripMeter];
    [self updateArrowDirection:newLocation.course*PI/180];
}
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
    MainQ * mQ=[MainQ sharedManager];
    UILabel * lb=(UILabel *)[mQ getTargetRef:TRIPMETER];
    if(!lb) return;
    NSString *tripString;
    if (totalTrip<1000) {
        tripString=[[NSString alloc] initWithFormat:@"%4.1fm (%.0f ft)", totalTrip,totalTrip*3.28084];
    }else if (totalTrip<1600) {
        tripString=[[NSString alloc] initWithFormat:@"%4.1fkm ", totalTrip/1000];
    }else{
        tripString=[[NSString alloc] initWithFormat:@"%4.1fmiles", totalTrip/1609.344];
    }
    [lb setText:tripString];
}
-(void)showAltitude:(CLLocationDistance)altitude{
    MainQ * mQ=[MainQ sharedManager];
    UILabel * lb=(UILabel *)[mQ getTargetRef:ALTITUDELABEL];
    if(!lb) return;
    NSString *altString;
    altString=[[NSString alloc] initWithFormat:@"%4.1fm (%.0f ft) ", altitude, altitude*3.28084];
    [lb setText:altString];
}
-(void)showSpeed:(CLLocationSpeed)speed{
    MainQ * mQ=[MainQ sharedManager];
    UILabel * lb=(UILabel *)[mQ getTargetRef:SPEEDLABEL];
    //UILabel * altlb=(UILabel *)[mQ getTargetRef:ALTITUDELABEL];
    //UILabel * trplb=(UILabel *)[mQ getTargetRef:TRIPMETER];
    if(!lb) return;
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
		lb.hidden=NO;
	}else{
		lb.hidden=YES;  //<==YES;
	}
    //altlb.hidden=trplb.hidden=lb.hidden;
	//---------------
}
bool bStartGPSNode;
CLLocation *lastLoc;
CLLocation *currentLocation;
CLLocationDistance totalTrip;
int n=0;  //gps node counter
-(void) addGpsNode:(GPSNode *)node with:(CLLocation *)newLocation{
    bool bFarEnough=false;
    
    CLLocationSpeed speed=newLocation.speed;
    int minDistance=20;
	if(speed>0.6){                 //>1.34 mph
		//speed sensitive point distance on gps track, added on 10/24/2010
		if (speed<2) {			 //about 4 mph
			minDistance=4;       //max accuracy is 5 meters
		}else if (speed<5) {	 //about 11 mph
			minDistance=5;
		}else if (speed > 20) {  //about 45 mph
			minDistance=20;
        }else if (speed > 30) {  //about 63 mph
			minDistance=30;
		}else if (speed > 100) {  //about 225 mph, for airplane
            minDistance=500;
        }
    }
    
    if(bStartGPSNode){
        bFarEnough=true;        //log the first location
        lastLoc=newLocation;
        bStartGPSNode=false;    //missed this, so that distance never got added up
    }else{			// if not first node, check the minimu distance traveled before add a node:
		CLLocationDistance distance=[newLocation distanceFromLocation:lastLoc];
		if(distance>minDistance){
			lastLoc=newLocation;
			bFarEnough=true;
            totalTrip+=distance;        //calculate the trip distance
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
        self.gpsTrack.nodes=[self addGPSNode:node to:self.gpsTrack.nodes];
        self.gpsTrack.tripmeter=totalTrip;
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
//-(void)centerPositionAtX:(int) x Y:(int) y{
//    DrawableMapScrollView * mapWindow=[DrawableMapScrollView sharedMap];
//    int adjX=[mapWindow.gpsTrackPOIBoard ModeAdjust:x res:mapWindow.maplevel];
//    CGRect  visibleBounds = [mapWindow bounds];     //Check this should return a size of 1280x1280 instead of 1024x768 for rotating purpose
//	CGFloat zm=[mapWindow zoomScale];
//	CGPoint offset=CGPointMake(adjX*zm-visibleBounds.size.width/2, y*zm-visibleBounds.size.height/2);
//	[mapWindow setContentOffset:offset animated:YES];   //this is where it makes map move smoothly
//}
/*
-(void) addGPSNode:(GPSNode *)node{
    if(!_gpsRecording){   //if not recording, do not create the node for the node
        return;
    }
    if (!self.gpsTrack.gpsNodes) {
        self.gpsTrack.gpsNodes=[[NSArray alloc]initWithObjects:node,nil];
    }else{
        self.gpsTrack.gpsNodes=[self.gpsTrack.gpsNodes arrayByAddingObject:node];
    }
}
 */
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
    if(!lb) return;
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
@end
