//
//  Track.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
//  a group of lines connected together wich such additoinal properties as
//  name, title, visible

#import <Foundation/Foundation.h>
@class LineProperty;
@interface Track : NSObject<NSCoding,NSCopying>

@property (nonatomic,strong) NSArray * nodes;
@property (nonatomic,strong) LineProperty * lineProperty;
@property bool visible;
@property (nonatomic,copy) NSString * filename;
@property (nonatomic,copy) NSString * title;

//-(void)InitializeFilenameAndTitle;
@end
