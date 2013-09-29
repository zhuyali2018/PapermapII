//
//  SaveItem.h
//  PaperMapII
//
//  Created by Yali Zhu on 9/24/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveItem : NSObject<NSCoding,NSCopying>

@property(nonatomic,strong) NSString * displayname;
@property(nonatomic,strong) NSString * filename;

-(void)encodeWithCoder:(NSCoder *)coder;
-(id)copyWithZone:(NSZone *)zone;
-(id)initWithCoder:(NSCoder *)coder;
- (id)initWithFilename:(NSString *)fn extension:(NSString *)ext;
-(NSString *)getAbsolutePathFilename;
+(NSString *)absolutePath:(NSString *)fn;
@end
