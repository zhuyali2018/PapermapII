//
//  Settings.h
//  PaperMapII
//
//  Created by Yali Zhu on 8/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {SHOW_SCALE_RULLER,
    SHOW_MAP_CENTER,
    HIDE_STATUSBAR,
    DIRECTION_UP,
    CACHED_MAP_ONL,
    INTERNET_MAP_ONLY,
    SHOW_MAP_LEVEL,
    HIDE_SPEED_METER,
    HIDE_ALT_METER,
    HIDE_TRIP_METER,
    HIDE_TRIP_TIMER} Setting;

@interface Settings : NSObject
@property(nonatomic,strong)NSMutableArray * settingArray;
+ (Settings *)sharedSettings;
-(bool)getSetting:(int)index;
@end
