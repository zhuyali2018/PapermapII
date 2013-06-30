//
//  MenuItem.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/27/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject
@property (nonatomic,strong)NSString * text;
@property SEL menuItemHandler;
- (id) initWithTitle:(NSString *)title;

//- (void) menuItemHandler;
- (void) test:(NSNumber *)n;
- (void) test2:(NSNumber *)n;
-(void) myTest;
@end
