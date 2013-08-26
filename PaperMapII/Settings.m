//
//  Settings.m
//  PaperMapII
//
//  Created by Yali Zhu on 8/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "Settings.h"
#import "SettingItem.h"

@implementation Settings
@synthesize settingArray;

+ (Settings *)sharedSettings{
    static Settings *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
-(id)init{
    self = [super init];
    if (self) {
            NSArray *settingArray1=[[NSArray alloc]initWithObjects:
                            [[SettingItem alloc]initWithTitle:@"Show Scale Ruler"],
                            [[SettingItem alloc]initWithTitle:@"Show Map Center"],
                            [[SettingItem alloc]initWithTitle:@"Hide Status Bar"],
                            [[SettingItem alloc]initWithTitle:@"Direction Up On GPS"],
                            [[SettingItem alloc]initWithTitle:@"Use Cached Map Only"],
                            [[SettingItem alloc]initWithTitle:@"Use Internet Map Only"],
                            [[SettingItem alloc]initWithTitle:@"Show Map Level"],
                            [[SettingItem alloc]initWithTitle:@"Hide Speed Meter"],
                            [[SettingItem alloc]initWithTitle:@"Hide Altitude Meter"],
                            [[SettingItem alloc]initWithTitle:@"Hide Trip Meter"],
                            [[SettingItem alloc]initWithTitle:@"Hide Trip Timer"],
                            nil];
        settingArray=[[NSMutableArray alloc]initWithCapacity:11];
        [settingArray addObjectsFromArray:settingArray1];
    }
    return self;
}
-(bool)getSetting:(int)index{
    return ((SettingItem *)settingArray[index]).selected;
}
@end
