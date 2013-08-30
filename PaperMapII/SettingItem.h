//
//  SettingItem.h
//  PaperMapII
//
//  Created by Yali Zhu on 8/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "MenuNode.h"

@class settings;

@protocol CheckBoxHandler <NSObject>
@optional
- (void)onCheckBox:(int)index changedTo:(bool)gotSelected;
@end

@interface SettingItem : MenuNode<NSCoding,NSCopying,MenuDataSource,CheckBoxHandler>

@property int idx;
@property (weak) id<CheckBoxHandler> checkBoxHandler;

- (id) initWithTitle:(NSString *)title with:(int)id andCheckBoxHandler:(id)handler;
-(bool)save;
-(bool)load;
@end
