//
//  DrawableMapScrollView.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "TappableMapScrollView.h"

@interface DrawableMapScrollView : TappableMapScrollView

+ (DrawableMapScrollView *)sharedMap;
-(void)refresh;
-(void)refreshDrawingBoard;
-(void)centerMapTo:(Node *)node;
-(void)setPreDraw:(bool)predraw;
-(void)clearAll;
@end
