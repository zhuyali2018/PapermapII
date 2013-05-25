//
//  PM2Protocols.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/23/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PM2MapSourceDelegate <NSObject>
@optional
- (UIImage *)mapLevel:(int)mapLevel row:(int)row col:(int)col;
@end
