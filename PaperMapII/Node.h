//
//  Node.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject<NSCopying,NSCopying>
@property     int x;   //col
@property     int y;   //row
@property     int r;   //resolution

-(id)initWithPoint:(CGPoint)pt mapLevel:(int)maplevel;
-(id)copyWithZone:(NSZone *)zone;
-(id)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)coder;
@end
