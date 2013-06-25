//
//  GPSNode.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "Node.h"
#import<CoreLocation/CoreLocation.h>

@interface GPSNode : Node
@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;
@property CLLocationDirection direction;
@property CLLocationDistance altitude;
@property CLLocationSpeed speed;
@property NSDate * timestamp;
@property CLLocationDistance distanceFromLastNode;
@property CLLocationDistance distanceFromStart;

-(id)initWithPoint:(CGPoint)pt mapLevel:(int)maplevel;
-(id)copyWithZone:(NSZone *)zone;
-(id)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)coder;

@end
