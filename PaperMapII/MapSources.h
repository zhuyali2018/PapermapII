//
//  MapSources.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/23/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PM2Protocols.h"
#import "MapTile.h"
#import "MainQ.h"
@interface MapSources: NSObject <PM2MapSourceDelegate>{
@public MapType mapType;
}
@property MapType mapType;
@property UInt32 lockCount;
@property(nonatomic, strong)NSLock *myLock;


//+ (id)sharedManager;
+ (MapSources *)sharedManager;
- (void)mapTile:(MapTile *)tile1;
- (bool)setMapSourceType:(MapType)mapType;
- (MapType)getMapSourceType;
- (void)lock;
- (void)unlock;
@end
