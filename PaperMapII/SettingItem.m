//
//  SettingItem.m
//  PaperMapII
//
//  Created by Yali Zhu on 8/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "SettingItem.h"

@implementation SettingItem
- (id) initWithTitle:(NSString *)title{
     self=[super initWithTitle:title];
     if(self){
         self.dataSource=self;      //so it can response to checkbox clicking by itself
         [self load];
     }
    return self;
}
-(id)initWithCoder:(NSCoder *)coder{
    if(self=[super initWithCoder:coder]){
        [super initInternalItems];
         self.dataSource=self;      //so it can response to checkbox clicking by itself
        [self load];                //load previous setting
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
}
-(bool)save{
    if (!self.mainText) {
        return false;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.selected forKey:self.mainText];
    return true;
}
-(bool)load{
    if (!self.mainText) {
        return false;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.selected=[defaults boolForKey:self.mainText];
    if(self.selected)
        [self.checkbox setImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];
    else
        [self.checkbox setImage:[UIImage imageNamed:@"checkbox0.png"] forState:UIControlStateNormal];
    
    return true;
}
#pragma mark --------Menu datasource properties------------
-(void)onCheckBox{      //execute when checkbox of the menu item is tapped
    NSLog(@"check box tapped, save new setting");
    [self save];
}
-(NSDate *)getTimeStamp{
    return NULL;
}
@end
