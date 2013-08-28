//
//  MapCenterIndicator.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/18/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCenterIndicator : UIControl{
    bool bShowCenter;
}
@property(nonatomic,assign)bool bShowCenter;
+ (id)sharedMapCenter:(CGRect)frame;
+ (id)sharedMapCenter;
@end
