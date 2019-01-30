//
//  SSLSocketsLoggerTests.m
//  SSLSocketsIOSTests
//
//  Created by Oleksandr Hordiienko on 1/29/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SSLServerSocket.h"
#import "SSLClientSocket.h"
#import "SSLSocketsManager.h"


@interface SSLSocketsLoggerTests : XCTestCase


@end

@implementation SSLSocketsLoggerTests

- (void)setUp {
//    [SSLSocketsManager addLoggingInConsoleWithIdentifier:@"ConsoleLogging" andMinimalPriority:SSLLoggingPriorityLog];
//    [SSLSocketsManager addLoggingInFileWithName:@"LogFile.txt" identifier:@"file1" andMinimalPriority:SSLLoggingPriorityLog];
//    [SSLSocketsManager addLoggingInFileWithName:@"WarningFile.txt" identifier:@"file2" andMinimalPriority:SSLLoggingPriorityWarning];
//    [SSLSocketsManager addLoggingInFileWithName:@"ErrorFile.txt" identifier:@"file3" andMinimalPriority:SSLLoggingPriorityLog];
//    [SSLSocketsManager addLoggingInFileWithName:@"FatalErrorFile.txt" identifier:@"file4" andMinimalPriority:SSLLoggingPriorityLog];
//    [SSLSocketsManager addLoggingInFileWithName:@"SomeFile.txt" identifier:@"file5" andMinimalPriority:SSLLoggingPriorityLog];
}


- (void)testSSLLogger {
    // Settings
    NSInteger clientsCount = 8;
    NSInteger messagesCount = 1000;
    
    
    // Configuring signing manager
    [SSLSocketsManager configureCertificatesWithCountry:@"UA"
                                                  state:@"Kyiv"
                                               location:@"Kyiv"
                                           organization:@"SoftServe"
                                       organizationUnit:@"IACSender"
                                             commonName:@"com.softserve.iacsender"
                                           emailAddress:@"ohord2@softserveinc.com"];
    
    // Creating server socket
    int port = 1 + arc4random_uniform(65535);
    SSLServerSocket *serverSocket = [[SSLServerSocket alloc] initWithPort:port];
    XCTAssert([serverSocket startSocket], "ServerSocket should be successfully started");
    
    // Creating client sockets
    NSMutableArray *clientsPool = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < clientsCount; i++) {
        SSLClientSocket *client = [[SSLClientSocket alloc] initWithPort:port];
        XCTAssert([client startSocket], "ClientSocket should be successfully connected");
        [clientsPool addObject:client];
    }
    
    // Spamming
    for (NSInteger message = 0; message < messagesCount; message++) {
        NSUInteger idx = arc4random_uniform((int)clientsCount);
        SSLClientSocket *randomClient = [clientsPool objectAtIndex:idx];
        NSString *testMessage = [NSString stringWithFormat:@"Test message number %ld", message];
        XCTAssert([randomClient sendData:testMessage], "Message should be successfully sent");
    }
    NSLog(@"Spamming stopped");
    
    
    // Destroying client sockets
    for (NSInteger i = 0; i < clientsCount; i++) {
        SSLClientSocket *client = [clientsPool objectAtIndex:i];
        [client stopSocket];
    }
    
    // Destroying server socket
    [serverSocket stopSocket];
}

- (void)tearDown {
    NSLog(@"tearDown");
    [SSLSocketsManager stopLogging];
}

@end
