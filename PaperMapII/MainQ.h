//
//  MainQ.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {MESSAGELABEL,SPEEDLABEL,ALTITUDELABEL,TRIPMETER,
    MAPLEVEL,MAPSOURCE,GPSTRACKPOIBOARD,DRAWINGBOARD,PREDRAW,GPSARROW} ITEMID;  //no more than ten times here

@interface MainQ : NSObject
@property (nonatomic,strong)NSMutableArray * mainQ;
+ (MainQ *)sharedManager;
-(void) register:(NSObject *)itemView withID:(ITEMID)id;
-(NSObject *)getTargetRef:(ITEMID)id;
@end
