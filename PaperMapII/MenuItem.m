//
//  MenuItem.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/27/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "MenuItem.h"

@implementation MenuItem
@synthesize menuItemHandler;

- (id) initWithTitle:(NSString *)title{
    self=[super init];
    if(self){
        self.text=[title copy];
    }
    return self;
}
//- (void) menuItemHandler{
//    NSLog(@"executing menuItemHandler for:%@",self.text);
//    [self performSelector:mySelector withObject:nil];
//}

- (void) test:(NSNumber *)n  {
    NSLog(@"test test = %d",[n integerValue]);
}
- (void) test2:(NSNumber *)n  {
    NSLog(@"test2 test2 = %d",[n integerValue]);
}
-(void) myTest{
    SEL aSelector;
    int n=1;
    if (n==1) {
        aSelector=@selector(test:);
    }else {
        aSelector=@selector(test2:);
    }
    [self performSelector:aSelector withObject:[NSNumber numberWithInt:6]];
}

-(void)showGPSTrackList:(id) sender{
    //MenuItem * menuItem=sender;
    //NSLOG10(@"executing MenuItem.showGPSTrackList from %@",menuItem.text);
    NSLOG10(@"executing MenuItem.showGPSTrackList");
}
@end
