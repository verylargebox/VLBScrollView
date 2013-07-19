//
//  VLBScrollViewTest.m
//  VLBScrollView
//
//  Created by Markos Charatzas on 27/04/2012.
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
#import <OCMock/OCMock.h>
#import <Kiwi/Kiwi.h>
#import "VLBScrollView.h"
#import "VLBSize.h"
#import "VLBRecycleStrategy.h"
#import "VLBVisibleStrategy.h"

@interface VLBScrollView (Testing)
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) VLBSize *size;
@property(nonatomic, strong) id<VLBDimension> dimension;

-(void)setVisibleStrategy:(id<VLBVisibleStrategy>)visibleStrategy;
-(id<VLBVisibleStrategy>)visibleStrategy;
-(void)setRecycleStrategy:(VLBRecycleStrategy *)recycleStrategy;
-(void)setContentView:(UIView*)contentView;
-(void)setTheBoxSize:(VLBSize *)size;
@end

@interface VLBScrollViewTest : SenTestCase {
	
}
@end

@implementation VLBScrollViewTest

-(void)testGivenDelegateDatasourceSizeAssertTheBoxSizeOfIsCalledLayoutSubview
{
    id mockedDelegate = [OCMockObject niceMockForProtocol:@protocol(VLBScrollViewDelegate)];
    id mockedDatasource = [OCMockObject niceMockForProtocol:@protocol(VLBScrollViewDatasource)];
    id mockedSize = [OCMockObject niceMockForClass:[VLBSizeInWidth class]];

    CGFloat size = 160;

    VLBScrollView *theBoxScrollView = [[VLBScrollView alloc] initWithFrame:CGRectZero];
    theBoxScrollView.size = mockedSize;
    theBoxScrollView.dimension = [VLBWidth newWidth:size];
    
    theBoxScrollView.scrollViewDelegate = mockedDelegate;
    theBoxScrollView.datasource = mockedDatasource;
    
    NSUInteger one = 1;
    [[[mockedDatasource expect] andReturnValue:OCMOCK_VALUE(one)] numberOfViewsInScrollView:theBoxScrollView];
    
    CGSize expectedContentSize = CGSizeMake(0, 0);
    [[[mockedSize expect] andReturnValue:OCMOCK_VALUE(expectedContentSize)] sizeOf:one size:size];

    [theBoxScrollView layoutSubviews];
    
    [mockedSize verify];
    STAssertTrue(CGSizeEqualToSize(theBoxScrollView.contentSize, expectedContentSize), @"actual: %s expected: %s", NSStringFromCGSize(theBoxScrollView.contentSize), NSStringFromCGSize(expectedContentSize));
}

-(void)testGivenSetNeedsLayoutAssertContentSubviewsRecycleAndRemovedFromSuperview
{
    UIView* contentView = [[UIView alloc] init];
    [contentView addSubview:[[UIView alloc] init]];
    [contentView addSubview:[[UIView alloc] init]];
    id mockedVisibleStrategy = [OCMockObject niceMockForClass:[VLBVisibleStrategy class]];
    id mockedRecycleStrategy = [OCMockObject mockForClass:[VLBRecycleStrategy class]];

    VLBScrollView *theBoxScrollView = [[VLBScrollView alloc] init];
    [theBoxScrollView setVisibleStrategy:mockedVisibleStrategy];
    [theBoxScrollView setRecycleStrategy:mockedRecycleStrategy];    
    [theBoxScrollView setContentView:contentView];
    
    [[[mockedVisibleStrategy expect] andReturn:nil] dimension];
    [[mockedRecycleStrategy expect] recycle:[contentView subviews]];
    [[mockedVisibleStrategy expect] delegate];
     
    [theBoxScrollView setNeedsLayout];
    
    STAssertTrue(0 == [[contentView subviews] count], @"expected: 0 actual: %d", [[contentView subviews] count] );
    STAssertEquals(theBoxScrollView, [[theBoxScrollView visibleStrategy] delegate], @"actual: %@", [[theBoxScrollView visibleStrategy] delegate]);
    
}
@end
