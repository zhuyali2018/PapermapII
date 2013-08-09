//
//  DrawableMapScrollView.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "TappableMapScrollView.h"
@class POI;
@interface DrawableMapScrollView : TappableMapScrollView

+ (DrawableMapScrollView *)sharedMap;
-(void)refresh;
-(void)refreshDrawingBoard;
-(void)centerMapTo:(Node *)node;
-(void)centerMapToPOI:(POI *)node;
-(void)setPreDraw:(bool)predraw;
-(void)clearAll;
@end
