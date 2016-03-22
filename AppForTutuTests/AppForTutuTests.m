//
//  AppForTutuTests.m
//  AppForTutuTests
//
//  Created by EnzoF on 18.02.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSONData.h"

@interface AppForTutuTests : XCTestCase
@property(strong,nonatomic)JSONData *jsondata;

@end

@implementation AppForTutuTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
@end
