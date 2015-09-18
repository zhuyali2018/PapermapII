//
//  Settings.h
//  PaperMapII
//
//  Created by Yali Zhu on 8/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class CheckBoxHandler;
#import "SettingItem.h"
typedef enum  {SHOW_SCALE_RULLER,
    SHOW_MAP_CENTER,
    HIDE_STATUSBAR,
    DIRECTION_UP,
    CACHED_MAP_ONLY,
    INTERNET_MAP_ONLY,
    SHOW_MAP_LEVEL,
    HIDE_SPEED_METER,
    HIDE_ALT_METER,
    HIDE_TRIP_METER,
    HIDE_TRIP_TIMER,
    SHOW_MAP_CHINESE} Setting;

@interface Settings : NSObject<CheckBoxHandler>
@property(nonatomic,strong)NSMutableArray * settingArray;
+ (Settings *)sharedSettings;
-(bool)getSetting:(int)index;
-(void)setSetting:(int)index to:(bool)show;
-(void)saveMapLaugnage:(bool)chineseMap;
@end
