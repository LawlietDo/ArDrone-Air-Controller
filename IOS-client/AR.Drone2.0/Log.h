//
//  Log.h
//  SooYa
//
//  Created by Jeason on 14-9-4.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#ifndef SooYa_Log_h
#define SooYa_Log_h

//A better version of NSLog
#define NSLog(format, ...) do {                                                         \
fprintf(stderr, "<%s : %d> %s\n",                 /*print to consoal*/                  \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],/*filename*/  \
__LINE__, __func__);/*line, func*/                                                      \
(NSLog)((format), ##__VA_ARGS__);/*Cocoa NSLog*/                                        \
fprintf(stderr, "-------\n");                                                           \
} while (0) //for some higher order function

#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)

#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)

#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)

#define NSLogIndexPath(indexPath) NSLog(@"%s section: %ld, row: %ld", #indexPath, \
indexPath.section, indexPath.row)

#endif
