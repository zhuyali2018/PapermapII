//
//  GPSTrack.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/24/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "GPSTrack.h"

@implementation GPSTrack

@synthesize tripmeter;

#pragma mark ----------------
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super initWithCoder:coder]){
        self.tripmeter =[coder decodeIntForKey:@"TRIPMETER"];
    }
	return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
	[coder encodeInt:self.tripmeter forKey:@"TRIPMETER"];
}
-(id)copyWithZone:(NSZone *)zone {
	GPSTrack * tkCopy=[super copyWithZone:zone];
	tkCopy.tripmeter  =self.tripmeter;
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
-(NSString *)dataFilePathWith:(int)segCount{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
    NSString * segFilename=[[NSString alloc] initWithFormat:@"%@_%03d",self.filename,segCount];
    return [documentsDirectory stringByAppendingPathComponent:segFilename];
}
@end
