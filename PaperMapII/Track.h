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
#import "MenuDataSource.h"
#import "MenuNode.h"
@class LineProperty;
@interface Track : MenuNode<NSCoding,NSCopying,MenuDataSource>{
    NSString * title;
    bool visible;
    //bool nodesDirtyFlag;        //tracking the nodes change
@public
    CGPoint	CTMapErr;             //Creating Time's map type's Map Error
    int     CTResolution;           //Creating Time's map type's Map Resolution
}
@property (nonatomic,strong) NSArray * nodes;
@property (nonatomic,strong) LineProperty * lineProperty;
//@property bool visible;
@property float version;                //track class version, for saving purpose
@property (nonatomic,copy) NSString * filename;
@property NSDate * timestamp;
@property bool nodesDirtyFlag;
@property CGPoint CTMapErr;
@property int CTResolution;


-(bool)saveNodes;
-(bool)readNodes;
//-(void)InitializeFilenameAndTitle;

-(void)setTitle:(NSString *)title1;
-(NSString *)title;

-(void)setVisible:(bool)v;
-(bool)visible;
-(NSString *)dataFilePath;
@end
