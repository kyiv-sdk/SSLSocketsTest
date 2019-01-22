//
//  Constants.m
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

int const FirstElementIndex = 0;
int const CharSize = sizeof(char);
int const BufferSize = 50 * CharSize;
int const BufSize = CharSize;

char const NullTerminalSymbol = '\0';
char const STXSymbol = '\x02';
char const EOTSymbol = '\x04';

int const FAIL_CODE = -1;
int const SSL_CTX_ONOFF_STATE = 1;
int const STXSymbolCode = (int)STXSymbol;
int const EOTSymbolCode = (int)EOTSymbol;


