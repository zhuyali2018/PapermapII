//
//  MapSources.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/23/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PM2Protocols.h"
@interface MapSources: NSObject <PM2MapSourceDelegate>{
    @public
    BOOL bSatMap;
}
    -(UIImage *)mapLevel:(int)mapLevel row:(int)row col:(int)col;
@end
