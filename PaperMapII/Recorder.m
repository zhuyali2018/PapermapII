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

@implementation Recorder

@synthesize trackArray,gpsTrackArray;

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
        self.mapMode=*[DrawableMapScrollView sharedMap].zoomView.gpsTrackPOIBoard.pMode;;
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
    _recording=true;
    self.track.lineProperty=[LineProperty sharedDrawingLineProperty];
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
    _gpsTrack=[[Track alloc] init];
    if (!_gpsTrack) {
        return;
    }
    _gpsRecording=true;
    self.gpsTrack.lineProperty=[LineProperty sharedDrawingLineProperty];   //TODO: change to GPS used line property
    if(!self.gpsTrackArray){   //when first time starting recorder, ini track array
        self.gpsTrackArray=[[NSMutableArray alloc]initWithCapacity:5];
        [self.gpsTrackArray addObject:self.gpsTrack];
    }else{
        [self.gpsTrackArray addObject:self.gpsTrack];
    }
}
-(void) startNewTrack{
    //initialize a track
    if (!_track) return;                    //if track not initialized, return;
    LineProperty *lp=_track.lineProperty;   //save the line property
    _track=[[Track alloc] init];
    if (!_track) return;                    //return if failed
    _track.lineProperty=lp;
    if(!self.trackArray){   //when first time starting recorder, ini track array
        self.trackArray=[[NSMutableArray alloc]initWithCapacity:5];
        [self.trackArray addObject:self.track];
    }else{
        [self.trackArray addObject:self.track];
    }    
}
-(void) startNewGpsTrack{
    //initialize a track
    if (!_gpsTrack) return;                    //if track not initialized, return;
    LineProperty *lp=_gpsTrack.lineProperty;      //save the line property
    _gpsTrack=[[Track alloc] init];
    if (!_gpsTrack) return;                    //return if failed
    _gpsTrack.lineProperty=lp;
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
    [[DrawableMapScrollView sharedMap].zoomView.gpsTrackPOIBoard setNeedsDisplay];
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

#pragma mark ------------------PM2RecordingDelegate method---------

- (void)mapLevel:(int)maplevel singleTapAtPoint:(CGPoint)tapPoint{
    //NSLOG3(@"gotSingleTapAtPoint in recoder - need to store the tapped point here");
    if(!_recording){   //if not recording, do not create the node for the tappoint
        return;
    }
    if((tapPoint.x==0)||(tapPoint.y==0)){   //signal for starting a new track
        [self startNewTrack];
        return;
    }
    Node *node=[[Node alloc]initWithPoint:tapPoint mapLevel:maplevel];
    self.track.nodes=[self addAnyModeAdjustedNode:self.track.nodes Node:node Mode:self.mapMode];
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
             if (!self.mapMode) {  //mapmode adjust x of node and last node;
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
    if(self.mapMode)
        return x;
    int H=TSIZE*pow(2,r-1);
    if(x<H)
        return x+H;
    return x-H;
}
#pragma mark ------------------ CLLocationManagerDelegate method -------------
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self displayAccuracy:newLocation];
    if(!_gpsRecording){   //if not recording, do not create the node for the node
        return;
    }
    
    double Lat=newLocation.coordinate.latitude;
	double Long=newLocation.coordinate.longitude;
	
	int res=((MapScrollView *)[DrawableMapScrollView sharedMap]).maplevel;
	int resM=18;   //use max resolution for best accuracy  //v163
	
	int xM=pow(2,resM)*0.711111111*(Long+180);						 //256/360=0.7111111111
	int yM=pow(2,resM)*1.422222222*(90-[self GetScreenY:Lat]);		 //256/180=1.4222222222
	
    //x,y used to center the map
	int x=pow(2,res)*0.711111111*(Long+180);						 //256/360=0.7111111111
	int y=pow(2,res)*1.422222222*(90-[self GetScreenY:Lat]);		 //256/180=1.4222222222
	
	CGPoint GPSPoint;
	GPSPoint.x=xM;
	GPSPoint.y=yM;
    GPSNode *node=[[GPSNode alloc]initWithPoint:GPSPoint mapLevel:resM];
    node.timestamp=newLocation.timestamp;
    node.altitude=newLocation.altitude;
    node.distanceFromLastNode=[newLocation distanceFromLocation:oldLocation];
    node.speed=newLocation.speed;
    node.longitude=newLocation.coordinate.longitude;
    node.latitude=newLocation.coordinate.latitude;
    node.direction=newLocation.course;
    self.gpsTrack.nodes=[self addGPSNode:node to:self.gpsTrack.nodes];
    [[DrawableMapScrollView sharedMap].zoomView.gpsTrackPOIBoard setNeedsDisplay];
}
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
    return [self addAnyModeAdjustedNode:arrGpsNodes Node:node Mode:self.mapMode];
}
#define PI 3.1415926
-(double)GetScreenY:(double)lat{
	double y1=lat*PI/180;
	double y=0.5*log((1+sin(y1))/(1-sin(y1)));
	return y*180/PI/2;
}
-(void)displayAccuracy:(CLLocation *)newLocation{
    static int n=0;
    n++;
    PM2OnScreenButtons * bns=[PM2OnScreenButtons sharedBnManager];
    float accuracy=newLocation.horizontalAccuracy;
    NSString * msg=[[NSString alloc]initWithFormat:@"Starting GPS, Accuracy=%3.1f meters (%d)",accuracy,n];
    [bns.messageLabel setText:msg];
    if(accuracy>50){  //if acuracy is not accurate enough, do nothing
        [bns.messageLabel setTextColor:[UIColor redColor]];
    }else{
        [bns.messageLabel setTextColor:[UIColor greenColor]];
    }
}
@end
