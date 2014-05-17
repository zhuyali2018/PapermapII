//
//  PaperMapIITests.m
//  PaperMapIITests
//
//  Created by Yali Zhu on 5/15/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "PaperMapIITests.h"
#import "Node.h"
#import "LineProperty.h"
#import "Track.h"
#import "Node.h"
@implementation PaperMapIITests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCopyNode{
    Node *node=[[Node alloc] init];
    node.x=1;
    node.y=2;
    node.r=3;
    Node *ACopyNode=node;
    Node *SecCopyNode=[node copy];
    XCTAssertEqual(ACopyNode.r,node.r, @"Node Copy to ACopyNode Failed");
    XCTAssertEqual(SecCopyNode.r,node.r, @"Node Copy Failed");
}
- (void)testCopyLineProperty{
    LineProperty *lp=[[LineProperty alloc]init];
    lp.red=0.68;
    lp.green=0.55;
    LineProperty *lp1=[lp copy];
    XCTAssertEqual(lp1.red,lp.red, @"LineProperty Copying Failed");
}
//- (void)testCopyLine{
//    Track * line=[[Track alloc]init];
//    line.nodes=[[NSArray alloc]initWithObjects:[[Node alloc]initWithPoint:CGPointMake(1.0,2.0)] mapLevel:3, nil];
//    line.lineProperty=[[LineProperty alloc]init];
//    line.lineProperty.red=0.66f;
//    Track * line2=[line copy];
//    STAssertEquals(line.lineProperty.red,line2.lineProperty.red, @"LineProperty element Copying Failed");
//    Node *node=[line.nodes objectAtIndex:0];
//    Node *node2=[line2.nodes objectAtIndex:0];
//    STAssertEquals(node.y,node2.y, @"node element Copying Failed");
//}
@end
