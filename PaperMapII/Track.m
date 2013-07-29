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
@implementation Track
@synthesize filename;
@synthesize nodes,lineProperty;
//@synthesize title;
@synthesize timestamp;
//@synthesize visible;

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
- (id)init {
    self = [super initWithTitle:@"-"];  //this line is important, or not menu will show up
    if (self) {
        // Initialize self.
        visible=true;
        _version=0;
        [self InitializeFilenameAndTitle];
        [super initInternalItems];
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
}
#pragma mark ----------------
-(id)initWithCoder:(NSCoder *)coder{
    if(self=[super initWithCoder:coder]){
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
        self.version    =CURRENTVERSION;      //version 2.0 for saving
        [super initInternalItems];
    }
	return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
	//[coder encodeObject:self.nodes          forKey:@"NODES"];
    if(self.version==2.0)
        [self saveNodes];
    if(self.version==CURRENTVERSION){
        //[coder encodeObject:self.nodes          forKey:@"NODES"];  //TODO: Remove this line after confirming no data loss
        [self saveNodes];
    }
    if (self.version==0) {
        [coder encodeObject:self.nodes          forKey:@"NODES"];
    }
    [coder encodeFloat:self.version          forKey:@"VERSION"];
	[coder encodeObject:self.lineProperty   forKey:@"LINEPROPERTY"];
    [coder encodeBool:self.visible          forKey:@"VISIBLE"];
    [coder encodeObject:self.filename       forKey:@"FILENAME"];
    [coder encodeObject:self.title          forKey:@"TITLE"];
    [coder encodeObject:self.timestamp      forKey:@"TIMESTAMP"];
}
-(id)copyWithZone:(NSZone *)zone {
	Track * tkCopy=[[[self class] allocWithZone:zone] init];
	tkCopy.lineProperty  =[self.lineProperty copyWithZone:zone];
    tkCopy.nodes=[[NSArray alloc]initWithArray:self.nodes];
    tkCopy.version=self.version;
    tkCopy.visible=self.visible;
    tkCopy.filename=self.filename;
    tkCopy.title=self.title;
    tkCopy.timestamp=self.timestamp;
	return tkCopy;
}
-(bool)saveNodes{
    if (!nodes) {
        return true; //no saving of null to overwrite possible data
    }
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:nodes forKey:@"TRACKNODES"];
    [archiver finishEncoding];
    
    return [data writeToFile:[self dataFilePath] atomically:YES];
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
@end
