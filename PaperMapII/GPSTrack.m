//
//  GPSTrack.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "GPSTrack.h"

@implementation GPSTrack
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super initWithCoder:coder]){
        self.gpsNodes=[coder decodeObjectForKey:@"GPSNODES"];
	}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
	[coder encodeObject:self.gpsNodes forKey:@"GPSNODES"];
}
-(id)copyWithZone:(NSZone *)zone {
	GPSTrack * tkCopy=[super copyWithZone:zone];
	tkCopy.gpsNodes =[[NSArray alloc]initWithArray:self.gpsNodes];
    return tkCopy;
}

@end
