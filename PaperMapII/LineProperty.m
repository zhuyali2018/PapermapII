//
//  LineProperty.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/31/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "LineProperty.h"

@implementation LineProperty
@synthesize red,green,blue,alpha,lineWidth;

+ (LineProperty *)sharedDrawingLineProperty{
    static LineProperty *sharedDrawingLineProperty = nil;
    @synchronized(self) {
        if (sharedDrawingLineProperty == nil){
            sharedDrawingLineProperty = [[self alloc] init];
            [sharedDrawingLineProperty loadPreSavedDrawingLineSettings];
        }
    }
    return sharedDrawingLineProperty;
}
+ (LineProperty *)sharedGPSTrackProperty{
    static LineProperty *sharedGPSTrackProperty = nil;
    @synchronized(self) {
        if (sharedGPSTrackProperty == nil){
            sharedGPSTrackProperty = [[self alloc] init];
            [sharedGPSTrackProperty loadPreSavedGPSTrackSettings];
        }
    }
    return sharedGPSTrackProperty;
}
+(NSString *)dataFilePath:(NSString *)filename{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:filename];
}
-(void)loadPreSavedDrawingLineSettings{
    //initialize arrAllTracks
    NSString * filePath=[LineProperty dataFilePath:@"DrawingLineProperty.sav"];
    //NSLog(@"data file path=%@",filePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        LineProperty *lp=[unarchiver decodeObjectForKey:@"DrawingLineProperty"];
        red=lp.red;green=lp.green;blue=lp.blue;alpha=lp.alpha;lineWidth=lp.lineWidth;
        [unarchiver finishDecoding];
    }else{
        //first time use, should set some default values here
        red=0;green=0.8;blue=0.2;alpha=0.8;lineWidth=3;
    }
}
-(void)loadPreSavedGPSTrackSettings{
    //initialize arrAllTracks
    NSString * filePath=[LineProperty dataFilePath:@"GPSTrackProperty.sav"];
    //NSLog(@"data file path=%@",filePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        LineProperty *lp=[unarchiver decodeObjectForKey:@"GPSTrackProperty"];
        red=lp.red;green=lp.green;blue=lp.blue;alpha=lp.alpha;lineWidth=lp.lineWidth;
        [unarchiver finishDecoding];
    }else{
        //first time use, should set some default values here
        red=0;green=0.2;blue=0.8;alpha=0.8;lineWidth=3;
    }
}
-(void)saveDrawingLineSettings{
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    LineProperty *lp=self;
    [archiver encodeObject:lp forKey:@"DrawingLineProperty"];
    [archiver finishEncoding];
    
    [data writeToFile:[LineProperty dataFilePath:@"DrawingLineProperty.sav"] atomically:YES];
}
-(void)saveGPSTrackSettings{
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    LineProperty *lp=self;
    [archiver encodeObject:lp forKey:@"GPSTrackProperty"];
    [archiver finishEncoding];
    
    [data writeToFile:[LineProperty dataFilePath:@"GPSTrackProperty.sav"] atomically:YES];
}
+ (LineProperty *)loadSettings:(NSString *)key{
    NSString * filePath=[LineProperty dataFilePath:key];
    //NSLog(@"data file path=%@",filePath);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData * data=[[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        LineProperty *lp=[unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
        return lp;
    }else{
        //first time use, should set some default values here
        LineProperty *lp=[[LineProperty alloc]initWithRed:0 green:0.2 blue:0.8 alpha:0.8 linewidth:2];
        return lp;
    }
    return NULL;
}
- (void)saveSettings:(NSString *)key{
    NSMutableData * data=[[NSMutableData alloc] init];
    NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    LineProperty *lp=self;
    [archiver encodeObject:lp forKey:key];
    [archiver finishEncoding];
    
    [data writeToFile:[LineProperty dataFilePath:key] atomically:YES];
}
- (id)initWithRed:(float)red1 green:(float)green1 blue:(float) blue1 alpha:(float) alpha1 linewidth:(int)width {
	self.red=red1;
	self.green=green1;
    self.blue=blue1;
    self.alpha=alpha1;
    self.lineWidth=width;
	return self;
}
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super init]){
		self.red  =[coder decodeFloatForKey:@"RED"];
		self.green=[coder decodeFloatForKey:@"GREEN"];
		self.blue =[coder decodeFloatForKey:@"BLUE"];
		self.alpha=[coder decodeFloatForKey:@"ALPHA"];
		self.lineWidth=[coder decodeFloatForKey:@"LINEWIDTH"];
	}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
	[coder encodeFloat:self.red   forKey:@"RED"];
	[coder encodeFloat:self.green forKey:@"GREEN"];
	[coder encodeFloat:self.blue  forKey:@"BLUE"];
	[coder encodeFloat:self.alpha forKey:@"ALPHA"];
	[coder encodeFloat:self.lineWidth forKey:@"LINEWIDTH"];
}
-(id)copyWithZone:(NSZone *)zone {
	LineProperty * FTcopy=[[[self class] allocWithZone:zone] init];
	FTcopy.red  =self.red;
	FTcopy.green=self.green;
	FTcopy.blue =self.blue;
	FTcopy.alpha=self.alpha;
	FTcopy.lineWidth=self.lineWidth;
	
	return FTcopy;
}

@end
