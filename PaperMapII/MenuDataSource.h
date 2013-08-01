//
//  MenuDataSource.h
//  PaperMapII
//
//  Created by Yali Zhu on 7/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MenuDataSource <NSObject>
-(void)loadNodes;           //reading in the nodes array from file
-(NSUInteger)numberOfNodes;
-(void)onCheckBox;      //execute when the menu item checkbox is clicked
-(NSDate *)getTimeStamp;
//-(NSString *)getMenuTitle;
@end
