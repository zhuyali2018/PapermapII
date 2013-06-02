//
//  LineProperty.h
//  PaperMapII
//
//  Created by Yali Zhu on 5/31/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineProperty : NSObject<NSCoding,NSCopying>
@property CGFloat  red;
@property CGFloat  green;
@property CGFloat  blue;
@property CGFloat  alpha;
@property CGFloat  lineWidth;

- (id)initWithRed:(float)red green:(float)green blue:(float) blue alpha:(float) alpha linewidth:(int)width;
@end
