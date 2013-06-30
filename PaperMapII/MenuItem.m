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
@end
