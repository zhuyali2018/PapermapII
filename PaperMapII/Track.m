//
//  Track.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/1/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "Track.h"
#import "LineProperty.h"
@implementation Track
@synthesize filename;
@synthesize nodes,lineProperty;
@synthesize title;
@synthesize timestamp;
- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        _visible=true;
        [self InitializeFilenameAndTitle];
    }
    return self;
}
-(void)InitializeFilenameAndTitle{
    NSDate * now = [NSDate date];
    timestamp=now;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    title = [outputFormatter stringFromDate:now];
    [outputFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss-SSS.trk"];
    filename = [outputFormatter stringFromDate:now];
}
#pragma mark ----------------
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super init]){
        self.nodes          =[coder decodeObjectForKey:@"NODES"];
		self.lineProperty   =[coder decodeObjectForKey:@"LINEPROPERTY"];
        self.visible        =[coder decodeBoolForKey:@"VISIBLE"];
        self.filename       =[coder decodeObjectForKey:@"FILENAME"];
        self.title          =[coder decodeObjectForKey:@"TITLE"];
        self.timestamp      =[coder decodeObjectForKey:@"TIMESTAMP"];
	}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
	[coder encodeObject:self.nodes          forKey:@"NODES"];
	[coder encodeObject:self.lineProperty   forKey:@"LINEPROPERTY"];
    [coder encodeBool:self.visible          forKey:@"VISIBLE"];
    [coder encodeObject:self.filename       forKey:@"FILENAME"];
    [coder encodeObject:self.title          forKey:@"TITLE"];
    [coder encodeObject:self.timestamp      forKey:@"TIMESTAMP"];
}
-(id)copyWithZone:(NSZone *)zone {
	Track * tkCopy=[[[self class] allocWithZone:zone] init];
	tkCopy.lineProperty  =[self.lineProperty copyWithZone:zone];
    tkCopy.nodes=[[NSArray alloc]initWithArray:self.nodes];
    tkCopy.visible=self.visible;
    tkCopy.filename=self.filename;
    tkCopy.title=self.title;
    tkCopy.timestamp=self.timestamp;
	return tkCopy;
}

@end
