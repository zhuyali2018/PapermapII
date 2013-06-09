//
//  AllImports.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/4/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#ifndef PaperMapII_AllImports_h
#define PaperMapII_AllImports_h

const static bool showLog=false;
#define NSLOG(fmt, ...) if(showLog) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog1=true;   //redrawn
#define NSLOG1(fmt, ...) if(showLog1) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog2=false;   //touch handler log
#define NSLOG2(fmt, ...) if(showLog2) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog3=false;   //New Log
#define NSLOG3(fmt, ...) if(showLog3) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

const static bool showLog4=true;   //New Log
#define NSLOG4(fmt, ...) if(showLog4) NSLog((@"%s " fmt), __PRETTY_FUNCTION__,##__VA_ARGS__)

#endif
