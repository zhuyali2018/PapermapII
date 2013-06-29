//
//  DrawingBoard.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/3/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrawingBoard : UIView



@property bool preDraw;
@property CGPoint firstPt;
@property CGPoint lastPt;
@ property NSArray	* ptList;

-(void) addNode:(CGPoint) pt;
-(void) clearAll;

@end
