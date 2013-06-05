//
//  DrawingBoard.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/3/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Track;
@interface DrawingBoard : UIView
@property (nonatomic,strong) NSArray * ptrToTracksArray;   //array of pointers to tracks which is also an array of tracks

//-(void)registTrack:(Track*)track;
@end
