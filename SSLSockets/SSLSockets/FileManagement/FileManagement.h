//
//  FileManagement.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef FileManagement_h
#define FileManagement_h

const char *pathForFile(const char *filename);
FILE *iosfopen(const char *filename, const char *mode);

#endif /* FileManagement_h */
