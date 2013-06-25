//
//  GPSNode.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "GPSNode.h"

@implementation GPSNode
@synthesize latitude,longitude,altitude,direction,distanceFromLastNode,timestamp,speed;
@synthesize distanceFromStart;

-(id)copyWithZone:(NSZone *)zone {
    GPSNode * nodeCopy=[super copyWithZone:zone];
    nodeCopy.latitude=self.latitude;
    nodeCopy.longitude=self.longitude;
    nodeCopy.altitude=self.altitude;
    nodeCopy.direction=self.direction;
    nodeCopy.distanceFromLastNode=self.distanceFromLastNode;
    nodeCopy.distanceFromStart=self.distanceFromStart;
    nodeCopy.timestamp=self.timestamp;
    nodeCopy.speed=self.speed;
    return nodeCopy;
}

- (id)initWithPoint:(CGPoint)pt  mapLevel:(int) maplevel{
    if (self=[super initWithPoint:pt  mapLevel:maplevel]){
        //other init code here
    }
	return self;
}
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super initWithCoder:coder]){
        self.latitude=[coder decodeDoubleForKey:@"latitude"];;
		self.longitude=[coder decodeDoubleForKey:@"longitude"];;
		self.altitude=[coder decodeDoubleForKey:@"altitude"];
		self.direction=[coder decodeDoubleForKey:@"direction"];
        self.distanceFromLastNode=[coder decodeDoubleForKey:@"distanceFromLastNode"];
        self.distanceFromStart=[coder decodeDoubleForKey:@"distanceFromStart"];
		self.timestamp=(NSDate *)[coder decodeObjectForKey:@"timestamp"];
		self.speed=[coder decodeDoubleForKey:@"speed"];
	}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
    [coder encodeDouble:latitude forKey:@"latitude"];
    [coder encodeDouble:longitude forKey:@"longitude"];
    [coder encodeDouble:altitude forKey:@"altitude"];
    [coder encodeDouble:direction forKey:@"direction"];
    [coder encodeDouble:distanceFromLastNode forKey:@"distanceFromLastNode"];
    [coder encodeDouble:distanceFromStart forKey:@"distanceFromStart"];
    [coder encodeDouble:speed forKey:@"speed"];
    [coder encodeObject:timestamp forKey:@"timestamp"];
}

@end
