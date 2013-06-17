//
//  Node.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "Node.h"

@implementation Node
@synthesize x,y,r;
-(id)copyWithZone:(NSZone *)zone {
    Node * nodeCopy=[[[self class]allocWithZone:zone]init];
    nodeCopy.x=self.x;
    nodeCopy.y=self.y;
    nodeCopy.r=self.r;
    return nodeCopy;
}

- (id)initWithPoint:(CGPoint)pt  mapLevel:(int) maplevel{
	self.x=pt.x;
	self.y=pt.y;
    self.r=maplevel;
	return self;
}
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super init]){
		self.r=[coder decodeIntForKey:@"res"];
		self.x=[coder decodeIntForKey:@"pointx"];
		self.y=[coder decodeIntForKey:@"pointy"];
	}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
	[coder encodeInt:x forKey:@"pointx"];
	[coder encodeInt:y forKey:@"pointy"];
    [coder encodeInt:r forKey:@"res"];
}
@end
