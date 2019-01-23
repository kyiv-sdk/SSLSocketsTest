//
//  FileManagement.mm
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef FileManagement_h
#define FileManagement_h

#import "FileManagement.h"
#import <Foundation/Foundation.h>

const char *pathForFile(const char *filename) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileString = [NSString stringWithCString:filename encoding:NSASCIIStringEncoding];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileString];
    return [path cStringUsingEncoding:NSASCIIStringEncoding];
}

FILE *iosfopen(const char *filename, const char *mode) {
    const char *filePath = pathForFile(filename);
    return fopen(filePath, mode);
}

#endif /* FileManagement_h */
