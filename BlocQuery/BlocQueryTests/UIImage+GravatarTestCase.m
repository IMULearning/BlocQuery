//
//  UIImage+GravatarTestCase.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-15.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIImage+Gravatar.h"

@interface UIImage_GravatarTestCase : XCTestCase

@end

@implementation UIImage_GravatarTestCase

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGravatarImage {
    XCTAssertNotNil([UIImage imageWithGravatarEmail:@"davidiamyou@gmail.com" size:80 fallbackImage:nil]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
