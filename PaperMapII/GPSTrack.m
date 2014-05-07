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

@end
