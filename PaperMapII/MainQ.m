//
//  MainQ.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/25/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "MainQ.h"

@implementation MainQ
@synthesize mainQ;
+ (MainQ *)sharedManager {
    static MainQ *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (id)init {
    if (self = [super init]) {
        //mainQ = [[NSMutableArray alloc] initWithCapacity:10];
        mainQ = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
    return self;
}
-(void) register:(NSObject *)itemView withID:(ITEMID)id{
    int sz=[mainQ count];
    if(sz>id)
        [mainQ replaceObjectAtIndex:id withObject:itemView];
}

-(NSObject *)getTargetRef:(ITEMID)id{
    return mainQ[id];
}
@end
