//
//  DrawableMapScrollView.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "TappableMapScrollView.h"

@interface DrawableMapScrollView : TappableMapScrollView
//-(void)registTracksToBeDrawn:(NSMutableArray*)tracks;
//-(void)registGpsTracksToBeDrawn:(NSMutableArray*)tracks;

+ (DrawableMapScrollView *)sharedMap;
@end
