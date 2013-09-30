//
//  ListViewController.h
//  PaperMapII
//
//  Created by Yali Zhu on 9/24/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum { DRAWTRACKLIST,GPSTRACKLIST,POIFILELIST} ListType;

@interface ListViewController : UITableViewController
@property bool dirty;
@property (nonatomic) NSArray * list;   //node list table (drawing)
@end
