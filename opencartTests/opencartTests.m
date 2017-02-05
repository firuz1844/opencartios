//
//  opencartTests.m
//  opencartTests
//
//  Created by Firuz Narzikulov on 4/11/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MoneyHelper.h"

@interface opencartTests : XCTestCase

@end

@implementation opencartTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testGetNumberFromPriceString {
    NSString *priceString = @"150,34 руб.";
    NSNumber *result = [MoneyHelper getNumberFromPriceString:priceString];
    XCTAssertEqual(result, @(150.43f), @"Test passed");
    
}
@end
