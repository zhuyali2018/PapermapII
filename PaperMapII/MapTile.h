//
//  MapTile.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{googleMap,googleSat,gingMap,bingSat,YahooMap,yahoosat} MapType;

@interface MapTile : UIImageView

@property int row;
@property int col;
@property int res;
@property int modeCol;   //mode adjusted col
@property MapType mType;
@end
