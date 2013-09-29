//
//  SaveItem.m
//  PaperMapII
//
//  Created by Yali Zhu on 9/24/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "SaveItem.h"

#define kTitleKey  @"title"
#define kFnameKey  @"Fname"

@implementation SaveItem
@synthesize displayname;
@synthesize filename;

- (id)initWithFilename:(NSString *)fn extension:(NSString *)ext{
    if ((self = [super init])) {
        // Initialization code
        displayname=fn;
        NSDate * theDate1=[NSDate date];
        NSCalendar * cal=[NSCalendar currentCalendar];
        NSDateComponents *date=[cal components:kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:theDate1];
        filename=[[NSString alloc]initWithFormat:@"%@-%02d%02d%02d-%02d%02d%02d.%@",fn,[date year],[date month],[date day],[date hour],[date minute],[date second],ext];
    }
    return self;
}
-(NSString *)getAbsolutePathFilename{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:filename];
}
+(NSString *)absolutePath:(NSString *)fn{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString * documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:fn];
}
#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)coder{
	[coder encodeObject:self.displayname    forKey:kTitleKey];
	[coder encodeObject:self.filename       forKey:kFnameKey];
}
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super init]){
		self.displayname   =[coder decodeObjectForKey:kTitleKey];
		self.filename      =[coder decodeObjectForKey:kFnameKey];
	}
	return self;
}
-(id)copyWithZone:(NSZone *)zone {
	SaveItem * nodeCopy=[[[self class] allocWithZone:zone] init];
	nodeCopy.displayname   =[self.displayname   copy];
	nodeCopy.filename      =[self.filename      copy];
	return nodeCopy;
}
@end
