//
//  NSString+HashTestCase.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-15.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Hash.h"

@interface NSString_HashTestCase : XCTestCase

@end

@implementation NSString_HashTestCase

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testMD5Hash {
    XCTAssertEqualObjects([@"01e578e6497c32c6fff0601b517f6693" uppercaseString], [[@"davidiamyou@gmail.com" MD5] uppercaseString]);
}

@end
