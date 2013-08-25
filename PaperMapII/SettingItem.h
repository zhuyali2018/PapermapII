//
//  SettingItem.h
//  PaperMapII
//
//  Created by Yali Zhu on 8/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "MenuNode.h"

@interface SettingItem : MenuNode<NSCoding,NSCopying,MenuDataSource>

-(bool)save;
-(bool)load;
@end
