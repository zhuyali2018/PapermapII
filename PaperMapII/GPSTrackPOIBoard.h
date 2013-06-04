//
//  GPSTrackPOIBoard.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/3/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
//equivelant to DrawingBoard in old code

#import <UIKit/UIKit.h>
@class DrawingBoard;    //equivlant to FreeDrawBoard in old code
@interface GPSTrackPOIBoard : UIView
@property (nonatomic) DrawingBoard * drawingBoard;
@end
