//
//  VLBDimensionTest.m
//  VLBScrollView
//
//  Created by Markos Charatzas on 12/01/2013.
//  Copyright (c) 2013 www.verylargebox.com
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
#import "VLBSize.h"

@interface VLBDimensionTest : SenTestCase

@end

@implementation VLBDimensionTest

- (void) testMoveCloserToWholeZero
{
	CGFloat width = 100;
    VLBWidth *dimension = [VLBWidth newWidth:width];
    
    CGPoint point = CGPointMake(0, 0);
    [dimension moveCloserToWhole:&point];
    
	STAssertTrue(point.x == 0, nil);
}

- (void) testMoveCloserToWholeDown
{
	CGFloat width = 100;
    VLBWidth *dimension = [VLBWidth newWidth:width];
    
    CGPoint point = CGPointMake(50.0, 0);
    [dimension moveCloserToWhole:&point];
    
	STAssertTrue(point.x == 0, nil);
}

- (void) testMoveCloserToWholeUp
{
	CGFloat width = 100;
    VLBWidth *dimension = [VLBWidth newWidth:width];
    
    CGPoint point = CGPointMake(50.1, 0);
    [dimension moveCloserToWhole:&point];
    
	STAssertTrue(point.x == 100, nil);
}

- (void) testMoveCloserToWholeHundred
{
	CGFloat width = 100;
    VLBWidth *dimension = [VLBWidth newWidth:width];
    
    CGPoint point = CGPointMake(100, 0);
    [dimension moveCloserToWhole:&point];
    
	STAssertTrue(point.x == 100, nil);
}

- (void) testMoveCloserToWholeThousand
{
	CGFloat width = 100;
    VLBWidth *dimension = [VLBWidth newWidth:width];
    
    CGPoint point = CGPointMake(1000, 0);
    [dimension moveCloserToWhole:&point];
    
	STAssertTrue(point.x == 1000, nil);
}


@end
