//
//  GPSTrack.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/24/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "GPSTrack.h"
#import "Recorder.h"

@implementation GPSTrack

@synthesize tripmeter;
@synthesize closed;
#pragma mark ----------------
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super initWithCoder:coder]){
        self.tripmeter =[coder decodeIntForKey:@"TRIPMETER"];
        self.closed =[coder decodeBoolForKey:@"CLOSED"];
    }
	return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
	[coder encodeInt:self.tripmeter forKey:@"TRIPMETER"];
    [coder encodeBool:self.closed forKey:@"CLOSED"];
}
-(id)copyWithZone:(NSZone *)zone {
	GPSTrack * tkCopy=[super copyWithZone:zone];
	tkCopy.tripmeter  =self.tripmeter;
    tkCopy.closed  =self.closed;
	return tkCopy;
}
//================
-(bool)saveNodesToFile:(int)segCount{
    if (!self.nodes) {
        return true; //no saving of null to overwrite possible data
    }
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.nodes forKey:@"TRACKSEGNODES"];
    [archiver finishEncoding];
    
    return [data writeToFile:[self dataFilePathWith:segCount] atomically:YES];
}
-(bool)readNodes{
    if (self.nodes) {
        return true;        //nodes already loaded
    }
    if (!self.closed) {  //if not closed yet
        return [self readNodesFromSegmentedFiles];
    }
    NSString * filePath=[self dataFilePath];
    //NSLog(@"data file path=%@",filePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.nodes=[unarchiver decodeObjectForKey:@"TRACKNODES"];
        [unarchiver finishDecoding];
        return self.nodes;
    }
    if(!self.nodes)
        self.nodes=[[NSMutableArray alloc]initWithCapacity:2];
    return self.nodes;
}

-(bool)readNodesFromSegmentedFiles{
    //NSFileManager * manager=[NSFileManager defaultManager];
    //NSError * error=nil;
    int i=0;
    do {
        NSArray * thisSegNodes;
        NSString * filePath=[self dataFilePathWith:i];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
            NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            thisSegNodes=[unarchiver decodeObjectForKey:@"TRACKSEGNODES"];
            [unarchiver finishDecoding];
        }else{
            break;
        }
        //add segnodes to total nodes
        if(!self.nodes)
            self.nodes=[[NSMutableArray alloc]initWithCapacity:2];
        
        NSMutableArray * mutableNodes=(NSMutableArray *)self.nodes;
        [mutableNodes addObjectsFromArray:thisSegNodes];
        self.nodes=mutableNodes;
        i++;
    } while (true);
    
    self.closed=true;
    [self saveNodes];
    //[[Recorder sharedRecorder] saveAllGpsTracks]; //so that closed status is also saved;
    
    //remove all the segmented files after loaded them all
    NSError *error = nil;
    for(int j=0;j<i;j++){
        NSString * tempFilenameWithPath=[self dataFilePathWith:j];
        [[NSFileManager defaultManager] removeItemAtPath:tempFilenameWithPath error:&error];
    }
    return self.nodes;
}
-(NSString *)dataFilePathWith:(int)segCount{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
    NSString * segFilename=[[NSString alloc] initWithFormat:@"%@_%03d",self.filename,segCount];
    return [documentsDirectory stringByAppendingPathComponent:segFilename];
}
@end
