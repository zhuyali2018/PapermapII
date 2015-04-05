//
//  POI.m
//  TwoDGPS
//
//  Created by zhuyali on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "POI.h"
#import "AllImports.h"
#import "DrawableMapScrollView.h"

@implementation POI

@synthesize res, x,y;
@synthesize nType,lat,lon;
//@synthesize title,
@synthesize description;//,imageView;

-(void)setTitle:(NSString *)title1{
    self.mainText=title1;
}
-(NSString *)title{
    return self.mainText;
}


- (id)initWithPoint:(CGPoint)pt{
    self = [super initWithTitle:nil];
    if (self) {
        x=pt.x;
        y=pt.y;
        //[super initInternalItems];
        self.dataSource=self;
    }
	return self;
}
#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
	[coder encodeInt:self.res forKey:@"res"];
	[coder encodeInt:self.x forKey:@"pointx"];
	[coder encodeInt:self.y forKey:@"pointy"];
	[coder encodeInt:(int)self.nType forKey:@"nType"];
	
	[coder encodeFloat:self.lat forKey:@"lat"];
	[coder encodeFloat:self.lon forKey:@"lon"];
	[coder encodeObject:self.description forKey:@"description"];
    [coder encodeObject:self.title forKey:@"title"];
	//[coder encodeObject:imageView forKey:@"imageView"];
	
}
-(id)initWithCoder:(NSCoder *)coder{
    if(self=[super initWithCoder:coder]){
        self.dataSource=self;
		self.res=[coder decodeIntForKey:@"res"];
		self.x=[coder decodeIntForKey:@"pointx"];
		self.y=[coder decodeIntForKey:@"pointy"];
		self.nType=(int)[coder decodeIntForKey:@"nType"];
		
		self.lat=[coder decodeFloatForKey:@"lat"];
		self.lon=[coder decodeFloatForKey:@"lon"];
		self.description=[coder decodeObjectForKey:@"description"];
		self.title=[coder decodeObjectForKey:@"title"];
		//self.imageView=[coder decodeObjectForKey:@"imageView"];
	}
	return self;
	//return [self autorelease];
}
-(id)copyWithZone:(NSZone *)zone {
	//POI * nodeCopy=[[[self class] allocWithZone:zone] init];
    POI * nodeCopy=[super copyWithZone:zone];
	nodeCopy.res=self.res;
	nodeCopy.x=self.x;
	nodeCopy.y=self.y;
	nodeCopy.nType=self.nType;
	
	nodeCopy.lat=self.lat;
	nodeCopy.lon=self.lon;
	nodeCopy.description=[self.description copy];
	//nodeCopy.title=[self.title copy];
	//nodeCopy.imageView=[self.imageView copy];
	return nodeCopy;
}
-(void)onCheckBox{      //execute when the menu item is tapped
    NSLog(@"Center map on my POI node position");
//    if (!self.folder) {   //folder may not contain such POI properties as nodes array
//        [[DrawableMapScrollView sharedMap] centerMapToPOI:self];
//    }
    [[DrawableMapScrollView sharedMap] refresh];  //for track update
}
-(NSDate *)getTimeStamp{
    return self.cdate;
}
@end
