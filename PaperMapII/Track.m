//
//  Track.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#define CURRENTVERSION 2.1f

#import "Track.h"
#import "LineProperty.h"
#import "DrawableMapScrollView.h"
#import "GPSNode.h"
#import "Recorder.h"
#import "MapSources.h"

@implementation Track
@synthesize filename;
@synthesize nodes,lineProperty;
//@synthesize title;
@synthesize timestamp;
//@synthesize visible;
@synthesize nodesDirtyFlag;
@synthesize CTResolution,CTMapErr,CTMapType;

-(void)setTitle:(NSString *)title1{
    self.mainText=title1;
}
-(NSString *)title{
    return self.mainText;
}

-(void)setVisible:(bool)v{
    self.selected=v;
}
-(bool)visible{
    return self.selected;
}
//-(void)setNodesDirtyFlag:(bool)v{
//    self.nodesDirtyFlag=v;
//}
//-(bool)nodesDirtyFlag{
//    return self.nodesDirtyFlag;
//}
- (id)init {
    self = [super initWithTitle:@"-"];  //this line is important, or no menu will show up
    if (self) {
        // Initialize self.
        visible=true;
        _version=0;
        [self InitializeFilenameAndTitle];
        [super initInternalItems];
        self.dataSource=self;
    }
    return self;
}
-(void)InitializeFilenameAndTitle{
    NSDate * now = [NSDate date];
    timestamp=now;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    self.title = [outputFormatter stringFromDate:now];
    [outputFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss-SSS"];
    filename = [[outputFormatter stringFromDate:now] stringByAppendingString:@".trk"];
    nodesDirtyFlag=false;
    //newly added for track going with errored map:
    //if ([[MapSources sharedManager] getMapSourceType] == googleMap){
        CTResolution = [DrawableMapScrollView sharedMap]->mapErrResolution;
        CTMapErr =[DrawableMapScrollView sharedMap]->mapMapErr;
    //}else{
    //    CTResolution = [DrawableMapScrollView sharedMap]->satErrResolution;
    //    CTMapErr =[DrawableMapScrollView sharedMap]->satMapErr;
    //}
    CTMapType=[[MapSources sharedManager] getMapSourceType];
}
#pragma mark ----------------
-(id)initWithCoder:(NSCoder *)coder{
    if(self=[super initWithCoder:coder]){
        self.dataSource=self;
        self.CTMapErr       =[coder decodeCGPointForKey:@"CTMAPERR"];
        self.CTResolution   =[coder decodeIntForKey:@"CTRESOLUTION"];
        self.CTMapType      =[coder decodeBoolForKey:@"CTMAPTYPE"];
        self.lineProperty   =[coder decodeObjectForKey:@"LINEPROPERTY"];
        self.filename       =[coder decodeObjectForKey:@"FILENAME"];
        self.title          =[coder decodeObjectForKey:@"TITLE"];
        self.timestamp      =[coder decodeObjectForKey:@"TIMESTAMP"];
        self.visible        =[coder decodeBoolForKey:@"VISIBLE"];
        self.version        =[coder decodeFloatForKey:@"VERSION"];
        if (!self.version) {  //if no version, load the nodes the old way
            self.nodes      =[coder decodeObjectForKey:@"NODES"];
        }else if(self.version==2.0f){
            self.nodes      =[coder decodeObjectForKey:@"NODES"];
        }else if(self.version==CURRENTVERSION){
            //if(visible)
            if(self.selected)       //on initialization, load those that are visible
                [self readNodes];
        }
        if (self.version!=CURRENTVERSION) {    // important or email received track will lose nodes on restart
            //NSLog(@"Save nodes to a separate file on loading because version = %f, setting version to %f",self.version,CURRENTVERSION);
            self.nodesDirtyFlag = true;         //important, or saveNodes wont save
            [self saveNodes];
        }
        self.version    =CURRENTVERSION;      //version 2.1 for saving which saves nodes separately
        [super initInternalItems];
        self.nodesDirtyFlag=false;
    }
	return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
	//[coder encodeObject:self.nodes          forKey:@"NODES"];
    if(self.version==2.0f)
        [coder encodeObject:self.nodes        forKey:@"NODES"];
    if(self.version==CURRENTVERSION){           //version 2.1 for saving which saves nodes separately
         [self saveNodes];
        //NSLog(@"Nodes saved to a separate file");
    }
    if (self.version==0) {
        if (!self.nodes) {
            [self readNodes];
        }
        [coder encodeObject:self.nodes          forKey:@"NODES"];
        //NSLog(@"Nodes saved to a single file");
    }
    [coder encodeFloat:self.version         forKey:@"VERSION"];
	[coder encodeObject:self.lineProperty   forKey:@"LINEPROPERTY"];
    [coder encodeInt:self.CTResolution      forKey:@"CTRESOLUTION"];
    [coder encodeCGPoint:self.CTMapErr      forKey:@"CTMAPERR"];
    [coder encodeBool:self.CTMapType        forKey:@"CTMAPTYPE"];
    [coder encodeBool:self.visible          forKey:@"VISIBLE"];
    [coder encodeObject:self.filename       forKey:@"FILENAME"];
    [coder encodeObject:self.title          forKey:@"TITLE"];
    [coder encodeObject:self.timestamp      forKey:@"TIMESTAMP"];
}
-(id)copyWithZone:(NSZone *)zone {
	Track * tkCopy=[[[self class] allocWithZone:zone] init];
	tkCopy.lineProperty  =[self.lineProperty copyWithZone:zone];
    tkCopy.CTMapErr = CGPointMake(self.CTMapErr.x,self.CTMapErr.y);
    tkCopy.CTResolution =self.CTResolution;
    tkCopy.CTMapType=self.CTMapType;
    tkCopy.nodes=[[NSArray alloc]initWithArray:self.nodes];
    tkCopy.version=self.version;
    tkCopy.visible=self.visible;
    tkCopy.filename=self.filename;
    tkCopy.title=self.title;
    tkCopy.timestamp=self.timestamp;
    tkCopy.nodesDirtyFlag=self.nodesDirtyFlag;   //correct ?
	return tkCopy;
}
-(bool)saveNodes{
    if (!nodesDirtyFlag) {
        return true;
    }
    
    if (!nodes) {
        return true; //no saving of null to overwrite possible data
    }
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:nodes forKey:@"TRACKNODES"];
    [archiver finishEncoding];
    
    bool successful=[data writeToFile:[self dataFilePath] atomically:YES];
    if (successful) {
        nodesDirtyFlag=false;
    }
    return successful;
}
-(bool)readNodes{
    if (nodes) {
        return true;        //nodes already loaded
    }
    NSString * filePath=[self dataFilePath];
    //NSLog(@"data file path=%@",filePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        nodes=[unarchiver decodeObjectForKey:@"TRACKNODES"];
        [unarchiver finishDecoding];
        return nodes;
    }
    if(!nodes)
        nodes=[[NSMutableArray alloc]initWithCapacity:2];
    return nodes;
}
-(NSString *)dataFilePath{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:filename];
}
//-(void)centerMapTo:(Node *)node1{
//    MapScrollView * map=((MapScrollView *)[DrawableMapScrollView sharedMap]);
//    int res=map.maplevel;
//    int r=node1.r;
//    int x=node1.x*pow(2, res-r);
//    int y=node1.y*pow(2, res-r);
//    //center the current position
//    [[Recorder sharedRecorder] centerPositionAtX:x Y:y];
//}
//-(void)centerMapTo:(GPSNode *)node1{
//    MapScrollView * map=((MapScrollView *)[DrawableMapScrollView sharedMap]);
//    int res=map.maplevel;
//    //x,y used to center the map below
//	int x=pow(2,res)*0.711111111*(node1.longitude+180);                      //256/360=0.7111111111
//	int y=pow(2,res)*1.422222222*(90-[[Recorder sharedRecorder] GetScreenY:node1.latitude]);		 //256/180=1.4222222222
//	
//    //center the current position
//    [[Recorder sharedRecorder] centerPositionAtX:x Y:y];
//}
#pragma mark --------Menu datasource properties------------
-(void)loadNodes{
    [self readNodes];
}//reading in the nodes array from file
-(NSUInteger)numberOfNodes{
    if (self.nodes) {
        return [nodes count];
    }
    return 0;
}
-(void)onCheckBox{      //execute when the menu item is tapped
    NSLog(@"Center map on my first node position");
    if (!self.folder) {   //folder may not contain such Track properties as nodes array
        //[self centerMapTo:nodes[0]];
        if ([nodes count]>0) {
            [[DrawableMapScrollView sharedMap] centerMapTo:nodes[0]];
        }
    }
    [[DrawableMapScrollView sharedMap] refresh];  //for track update
}
//-(NSString *)getMenuTitle{
//    return title;
//}
-(NSDate *)getTimeStamp{
    return timestamp;
}
@end
