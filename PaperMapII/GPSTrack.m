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

@end
