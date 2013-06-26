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
    MapType mapType;
}
+ (id)sharedManager;
- (void)mapTile:(MapTile *)tile1;
- (void)setMapSourceType:(MapType)mapType;
@end
