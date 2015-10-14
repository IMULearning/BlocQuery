//
//  NSString+ValidatorTestCase.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Validator.h"

@interface NSString_ValidatorTestCase : XCTestCase

@end

@implementation NSString_ValidatorTestCase

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) testValidEmail {
    XCTAssertTrue([@"davidiamyou@gmail.com" isValidEmailWithStrictFilter:NO]);
}

- (void) testWithInvalidEmail {
    XCTAssertFalse([@"davidiamyou" isValidEmailWithStrictFilter:NO]);
}

- (void) testWithGoogleFilterEmail {
    XCTAssertTrue([@"davidiamyou+blocquery@gmail.com" isValidEmailWithStrictFilter:YES]);
}

- (void) testValidPassword {
    XCTAssertTrue([@"zxcvasdf1" isValidPassword]);
}

- (void) testInvalidPasswordMissingNumeric {
    XCTAssertFalse([@"zxcvasdf" isValidPassword]);
}

- (void) testInvalidPasswordShorterThanMinLength {
    XCTAssertFalse([@"zxcva" isValidPassword]);
}

- (void) testInvalidPasswordLongerThanMaxLength {
    XCTAssertFalse([@"zxcvaasdasdazxcvaasdasda" isValidPassword]);
}

@end
