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
        if (sharedDrawingLineProperty == nil)
            sharedDrawingLineProperty = [[self alloc] init];
    }
    return sharedDrawingLineProperty;
}
+ (LineProperty *)sharedGPSTrackProperty{
    static LineProperty *sharedGPSTrackProperty = nil;
    @synchronized(self) {
        if (sharedGPSTrackProperty == nil)
            sharedGPSTrackProperty = [[self alloc] init];
    }
    return sharedGPSTrackProperty;
}

//- (id)initWithRed:(float)red1 green:(float)green1 blue:(float) blue1 alpha:(float) alpha1 linewidth:(int)width {
//	self.red=red1;
//	self.green=green1;
//    self.blue=blue1;
//    self.alpha=alpha1;
//    self.lineWidth=width;
//	return self;
//}
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
