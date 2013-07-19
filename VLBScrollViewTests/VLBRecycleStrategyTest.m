//
//  VLBRecycleStrategyTest.m
//  VLBScrollView
//
//  Created by Markos Charatzas on 15/12/2010.
//  Copyright (c) 2010 www.verylargebox.com
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
#import "VLBRecycleStrategy.h"
#import "VLBTestViews.h"

@interface VLBRecycleStrategyTest : SenTestCase {
	
}

@end

@implementation VLBRecycleStrategyTest

-(void)assertNotRecycled:(VLBRecycleStrategy *) cellRecycleStrategy;
{
	STAssertTrue(0 == cellRecycleStrategy.recycledViews.count, @"view is recycled although still visible");
}

-(void)assertRecycled:(VLBRecycleStrategy *) recycleStrategy count:(NSUInteger)count;
{
	STAssertTrue(count == recycleStrategy.recycledViews.count, [NSString stringWithFormat:@"expected: %d actual: %d", count, recycleStrategy.recycledViews.count]);
}

-(CGRect)scrollVertical:(CGRect)bounds by:(int)diff{
return CGRectMake(bounds.origin.x, bounds.origin.y + diff, bounds.size.width, bounds.size.height);
}

/*
 *
 */
-(VLBRecycleStrategy *)recycleViewsBounds:(CGRect) frame visibleBounds:(CGRect) visibleBounds;
{
	UIView *view = [[UIView alloc] initWithFrame:frame];
	NSArray *views = [NSArray arrayWithObject:view];
	
	VLBRecycleStrategy *recycleStrategy = [[VLBRecycleStrategy alloc] init];
	
	[recycleStrategy recycle:views bounds:visibleBounds];
	
return recycleStrategy;
}


/* 
 *			320  
 *		---------
 *	196 |section|
 *		---------
 *	196 |section|
 *		---------
 */
-(void)testRecycleViewsBoundsForMultipleSections
{
	NSValue *first = [NSValue valueWithCGRect:CGRectMake(0, 0, 320, 196)];
	NSValue *second = [NSValue valueWithCGRect:CGRectMake(0, 196, 320, 196)];
	NSValue *third = [NSValue valueWithCGRect:CGRectMake(0, 392, 320, 196)];
	NSValue *forth = [NSValue valueWithCGRect:CGRectMake(0, 588, 320, 196)];
	NSValue *fifth = [NSValue valueWithCGRect:CGRectMake(0, 784, 320, 196)];
	
    NSArray* frames = [NSArray arrayWithObjects:first, second, third, forth, fifth, nil];
    
	NSArray *views = [[[VLBTestViews alloc] init]of:frames];
	
	VLBRecycleStrategy *recycleStrategy = [[VLBRecycleStrategy alloc] init];
	
	CGRect visibleBounds = CGRectMake(0, 0, 320, 392);
    CGFloat height = 196;

	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertRecycled:recycleStrategy count:3];
	
	visibleBounds = [self scrollVertical:visibleBounds by:height];
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertRecycled:recycleStrategy count:4];
    
   	visibleBounds = [self scrollVertical:visibleBounds by:height];
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertRecycled:recycleStrategy count:5]; 
}

-(void)testRecycleViewsBoundsForMultipleSectionsInverse
{
	NSValue *first = [NSValue valueWithCGRect:CGRectMake(0, 0, 320, 196)];
	NSValue *second = [NSValue valueWithCGRect:CGRectMake(0, 196, 320, 196)];
	NSValue *third = [NSValue valueWithCGRect:CGRectMake(0, 392, 320, 196)];
	NSValue *forth = [NSValue valueWithCGRect:CGRectMake(0, 588, 320, 196)];
	NSValue *fifth = [NSValue valueWithCGRect:CGRectMake(0, 784, 320, 196)];
	
    NSArray* frames = [NSArray arrayWithObjects:first, second, third, forth, fifth, nil];
    
	NSArray *views = [[[VLBTestViews alloc] init]of:frames];
	
	VLBRecycleStrategy *recycleStrategy = [[VLBRecycleStrategy alloc] init];
	
	CGRect visibleBounds = CGRectMake(0, 588, 320, 392);
    CGFloat height = -196;
    
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertRecycled:recycleStrategy count:3];
	
	visibleBounds = [self scrollVertical:visibleBounds by:height];
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertRecycled:recycleStrategy count:4];
    
   	visibleBounds = [self scrollVertical:visibleBounds by:height];
	[recycleStrategy recycle:views bounds:visibleBounds];	
	[self assertRecycled:recycleStrategy count:5]; 
}


-(void)testGivenViewIsRecycledAssertIsRemovedFromSuperview
{
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 196, 320, 196)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 196)];
    [superView addSubview:view];
    	
	VLBRecycleStrategy *recycleStrategy = [[VLBRecycleStrategy alloc] init];
	CGRect visibleBounds = CGRectMake(0, 197, 320, 392);
	
    [recycleStrategy recycle:[NSArray arrayWithObject:view] bounds:visibleBounds];
    
    NSLog(@"%@", [view superview]);
    STAssertNil([view superview], nil);
}

-(void)testRecycleViewsBoundsForSingleView
{
	CGRect view = CGRectMake(0, 0, 320, 196);
	CGRect visibleBounds = CGRectMake(0, 0, 320, 196);
	
	VLBRecycleStrategy *recycleStrategy = [self recycleViewsBounds:view visibleBounds:visibleBounds];
	[self assertNotRecycled:recycleStrategy];
	
	visibleBounds = [self scrollVertical:visibleBounds by:196];
	recycleStrategy = [self recycleViewsBounds:view visibleBounds:visibleBounds];
	[self assertRecycled:recycleStrategy count:1];		
	
	visibleBounds = [self scrollVertical:visibleBounds by:-1];
	
	recycleStrategy = [self recycleViewsBounds:view visibleBounds:visibleBounds];
	[self assertNotRecycled:recycleStrategy];		
	
	visibleBounds = [self scrollVertical:visibleBounds by:1];
	
	recycleStrategy = [self recycleViewsBounds:view visibleBounds:visibleBounds];
	[self assertRecycled:recycleStrategy count:1];		    
}


-(void)testDequeueReusableSection
{
	CGRect frame = CGRectMake(0, 0, 320, 196);
	UIView *cell = [[UIView alloc] initWithFrame:frame];
	NSArray *views = [NSArray arrayWithObjects:cell, nil];
	
	VLBRecycleStrategy *recycleStrategy = [[VLBRecycleStrategy alloc] init];
	
	CGRect visibleBounds = CGRectMake(0, 197, 320, 196);
	
	[recycleStrategy recycle:views bounds:visibleBounds];
	
	STAssertNotNil([recycleStrategy dequeueReusableView], @"view should have been recycled");	
	STAssertNil([recycleStrategy dequeueReusableView], @"there shouldn't be any more recycled views");	
}

-(void)testIsVisible
{
	
}

@end
