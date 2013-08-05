//
//  MenuNode.h
//  CollapsableMenu
//
//  Created by Yali Zhu on 7/21/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpandableMenuViewController.h"
#import "MenuDataSource.h"

@interface MenuNode : NSObject<NSCopying,NSCopying>

@property (nonatomic,strong)NSString* mainText;
@property bool folder;
@property bool open;    //if folder is open or not
@property bool selected;    // if the item is selected or not
@property bool infolder;    // if the item is at root or under a folder
@property int rootArrayIndex;   //keeping track of its position in original array
@property NSDate * cdate;       //creating date and time
@property (nonatomic,strong) UIButton * checkbox;
@property (nonatomic,strong) UILabel * mainLabel;
@property (nonatomic,strong) UILabel * subLabel;
@property (nonatomic,strong) UIImageView * openFolder;
@property (nonatomic,strong) UIImageView * closeFolder;
@property (nonatomic,strong) UIImageView * iconTrail;
@property (nonatomic,strong) UIView * icon;
@property (nonatomic,weak) ExpandableMenuViewController * emvc;

@property (weak) id<MenuDataSource> dataSource;

- (id) initWithTitle:(NSString *)title;
- (id) initWithTitle:(NSString *)title asFolder:(bool)asFolder;
-(id)initWithCoder:(NSCoder *)coder;
-(void) initInternalItems;

-(void)encodeWithCoder:(NSCoder *)coder;
-(void)updateAppearance;
@end
