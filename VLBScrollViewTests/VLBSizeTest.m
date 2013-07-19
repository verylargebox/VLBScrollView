//
//  VLBSizeTest.m
//  VLBScrollView
//
//  Created by Markos Charatzas on 04/04/2011.
//  Copyright (c) 2011 www.verylargebox.com
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

@interface VLBSizeTest : SenTestCase
{
}

@end


@implementation VLBSizeTest

- (void) testContentSizeOfRowsZero
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInHeight alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:0 size:196];
	
	STAssertEquals(actual, CGSizeZero, @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeZero));
	
}

- (void) testContentSizeOfRowsOne
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInHeight alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:1 size:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(320, 196)));
	
}

- (void) testContentSizeOfRowsTwo
{
	CGSize size = CGSizeMake(320, 196);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInHeight alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:2 size:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 2), nil);
	
}

- (void) testContentSizeOfRowsOdd
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInHeight alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:3 size:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 3), nil);
	
}


- (void) testContentSizeOfRowsEven
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInHeight alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:4 size:196];
	
	STAssertEquals(actual, CGSizeMake(320, 196 * 4), nil);
	
}

- (void) testContentSizeOfColumnsZero
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInWidth alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:0 size:160];
	
	STAssertEquals(actual, CGSizeZero, @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeZero));
	
}

- (void) testContentSizeOfColumnsOne
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInWidth alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:1 size:160];
	
	STAssertEquals(actual, CGSizeMake(160, 392), @"actual: %@ expected: %@", NSStringFromCGSize(actual), NSStringFromCGSize(CGSizeMake(160, 392)));
	
}

- (void) testContentSizeOfColumnsTwo
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInWidth alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:2 size:160];
	
	STAssertEquals(actual, CGSizeMake(160*2, 392), nil);
	
}

- (void) testContentSizeOfColumnsdd
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInWidth alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:3 size:160];
	
	STAssertEquals(actual, CGSizeMake(160*3, 392), nil);
	
}


- (void) testContentSizeOfColumnsEven
{
	CGSize size = CGSizeMake(320, 392);
	NSObject<VLBSize> *theBoxSize = [[VLBSizeInWidth alloc] initWithSize:size];
	
	CGSize actual = [theBoxSize sizeOf:4 size:160];
	
	STAssertEquals(actual, CGSizeMake(160*4, 392), nil);
	
}


@end
