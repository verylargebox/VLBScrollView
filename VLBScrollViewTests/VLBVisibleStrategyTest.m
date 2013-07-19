//
//  VLBVisibleStrategyTest.m
//  VLBScrollView
//
//  Created by Markos Charatzas on 19/04/2012.
//  Copyright (c) 2012 www.verylargebox.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <SenTestingKit/SenTestingKit.h>
#import "VLBVisibleStrategy.h"
#import "VLBVisibleStrategy.h"
#import "OCMock.h"
#import "OCMArg.h"

@interface VLBVisibleStrategy (Testing)
-(NSInteger)minimumVisibleIndex;
-(NSInteger)maximumVisibleIndex;
@end

@interface VLBVisibleStrategyTest : SenTestCase {
}
@end

@implementation VLBVisibleStrategyTest

-(void)testGivenNegativeMinimumIndexAssertFlooredToZero
{
    VLBVisibleStrategy *visibleStrategy = [[VLBVisibleStrategy alloc] init];
    [visibleStrategy minimumVisibleIndexShould:[ceilVisibleIndexAt(0) copy]];
    [visibleStrategy maximumVisibleIndexShould:[floorVisibleIndexAt(1) copy]];

    id partiallyMockedVisibleStrategy = [OCMockObject partialMockForObject:visibleStrategy];
    
    NSInteger negativeOne = -1;
    [[[partiallyMockedVisibleStrategy expect] andReturnValue:OCMOCK_VALUE(negativeOne)] minimumVisible:CGPointZero];
    
    [visibleStrategy layoutSubviews:CGRectZero];
    
    STAssertTrue(0 == [partiallyMockedVisibleStrategy minimumVisibleIndex], @"expected: 0 actual: %d", [partiallyMockedVisibleStrategy minimumVisibleIndex]);
}

-(void)testGivenGreaterMaximumIndexAssertCeil
{
    VLBVisibleStrategy *visibleStrategy = [[VLBVisibleStrategy alloc] init];
    [visibleStrategy minimumVisibleIndexShould:[ceilVisibleIndexAt(0) copy]];
    [visibleStrategy maximumVisibleIndexShould:[floorVisibleIndexAt(1) copy]];
    
    id partiallyMockedVisibleStrategy = [OCMockObject partialMockForObject:visibleStrategy];
    
    NSInteger two = 2;
    [[[partiallyMockedVisibleStrategy expect] andReturnValue:OCMOCK_VALUE(two)] maximumVisible:CGRectZero];
    
    [visibleStrategy layoutSubviews:CGRectZero];
    
    STAssertTrue(0 == [partiallyMockedVisibleStrategy maximumVisibleIndex], @"expected: 0 actual: %d", [partiallyMockedVisibleStrategy maximumVisibleIndex]);
}


@end
