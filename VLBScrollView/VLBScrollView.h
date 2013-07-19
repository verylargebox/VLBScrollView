//
//  VLBScrollView.h
//  VLBScrollView
//
//  Created by Markos Charatzas on 07/02/2011.
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

#import "VLBVisibleStrategy.h"
#import "VLBCanIndexLocationInView.h"
@class VLBRecycleStrategy;
@class VLBVisibleStrategy;
@class VLBScrollView;
@class VLBSize;
@protocol VLBDimension;

typedef void(^VLBScrollViewConfig)(VLBScrollView *scrollView, BOOL cancelsTouchesInView);
typedef void(^VLBScrollViewOrientation)(VLBScrollView *scrollView);

/// Use to allow for user 'tappable' pages
extern VLBScrollViewConfig const VLBScrollViewAllowSelection;
/// Creates a new scroll view which scrolls on the vertical axis.
extern VLBScrollViewOrientation const VLBScrollViewOrientationVertical;
/// Creates a new scroll view which scrolls on the horizontal axis.
extern VLBScrollViewOrientation const VLBScrollViewOrientationHorizontal;

@protocol VLBScrollViewDatasource <NSObject>

@required

/**
 Return the number of views in the scroll view.
 
 @param scrollView the scroll view this datasource was set to
 */
-(NSUInteger)numberOfViewsInScrollView:(VLBScrollView *)scrollView;


/**
 Implementation should return a UIView subclass to be used by the VLBScrollView as the page.
 
 This view will be passed in VLBScrollViewDelegate#viewInScrollView:willAppear:atIndex: for customisation.
 
 Indexes are in sequential order starting from 0 up to the number of views as returned by #numberOfViewsInScrollView: minus 1.
 
 @param scrollView the scroll view this datasource was set to
 @param frame the frame of the view in the given index
 @param index the index which identifies the view
 */
- (UIView *)viewInScrollView:(VLBScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSUInteger)index;

@end

@protocol VLBScrollViewDelegate

/**
Implementation must return the desired orientation for the scroll view.

@see VLBScrollViewOrientationVertical
@see VLBScrollViewOrientationHorizontal
*/
-(VLBScrollViewOrientation)orientation:(VLBScrollView*)scrollView;

/**
Depending on the orientation returned by #orientation: the returned value represents either the height or the width of the page,
while the page expands at the size of the scroll view in the other dimension.

@return the width/height of the view returned in VLBScrollViewDatasource#viewInScrollView:ofFrame:atIndex:
*/
-(CGFloat)viewsOf:(VLBScrollView *)scrollView;
/**
 Will get a callback if #setNeedsLayout has been called on the next #layoutSubviews.
 
 @param scrollView the VLBScrollView associated with the delegate
 */
-(void)didLayoutSubviews:(VLBScrollView*)scrollView;

/**
 Implementations should customise the appearance of the view.
 
 The view might be a recycled view or a new instance.
 
 @param scrollView the VLBScrollView associated with the delegate
 @param view the UIView subclass as returned by the VLBScrollViewDatasource#viewInScrollView:ofFrame:atIndex:
 @param the index of the view that will appear
 */
- (void)viewInScrollView:(VLBScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index;

/**
 @param scrollView the VLBScrollView associated with the delegate
 @param minimumVisibleIndex the minimum index of the view that will appear in the next cycle
 @param maximumVisibleIndex the maximum index of the view that will appear in the next cycle
 @see viewInScrollView:willAppear:atIndex:
 */
- (void)viewInScrollView:(VLBScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex;

/**
 @param scrollView the VLBScrollView associated with the delegate
 @param index the index at which the scrollView will come at a stop
 */
-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index;

@optional

/**
Implement when using VLBScrollViewAllowSelection to get a callback.

@param scrollView the scrollview this delegate is assigned to
@param idnex the index of the page that was tapped
@param point the point at which it was tapped
*/
-(void)didSelectView:(VLBScrollView *)scrollView atIndex:(NSUInteger)index point:(CGPoint)point;

@end

/**
 An implementation of UIScrollView which is divived mentally in many views.
 e.g. a VLBScrollView with a frame of 320x480 and contentSize of 320x588
 divided in views of 196px will yield:
 
 320px
 -    |---------------|          -
 |    |               |          |
 |    |               |          |
 |    |               |          |
 |    |               |  196px   |
 |    |               |          |
 |    |               |          |
 |    |---------------|          |
 |    |               |          |
 |    |               |          |
 480px|               |  196px   |
 |    |               |          |
 |    |               |         588px
 |    |               |          |
 |    |---------------|          |
 |    |               |          |
 |    |               |          |
 |    |               |          |
 -    |               |  196px   |
 			|               |          |
		  |               |          |
		  |---------------|          _
 
 
 Preconditions to use VLBScrollView is to assign a datasource and a delegate and implement their required methods.
 
 VLBScrollView will calculate its contentSize based on the number of views as returned by
 VLBScrollViewDatasource#numberOfViewsInScrollView:
 
 VLBScrollView will lazy query (VLBScrollViewDatasource#viewOf:atIndex:) for a view at the "point" where it becomes visible
 and will "recycle" it as it scrolls past its bounds. Each subsequent pass through will query for the view again.
 
 VLBScrollView will handle bounces of the scrollview gracefully.
 
 To use VLBScrollView in IB, drag a UIScrollView, change its type to VLBScrollView and set its datasource and scrollViewDelegate IBOutlets.

 The pages can be made 'tappable' so that the scrollViewDelegate can get a callback. 
 
 To programmatically create one, use one of the following factory methods
 @see #newVerticalScrollView:config: to create a VLBScrollView scrolling on the vertical axis
 @see #newHorizontalScrollView:config: to create a VLBScrollView scrolling on the horizontal axis
 */
@interface VLBScrollView : UIScrollView <VisibleStrategyDelegate, VLBCanIndexLocationInView, UIScrollViewDelegate>

/**
 Creates a new scroll view which scrolls on the vertical axis.
 The width of the scrollview is based on the given frame while the height of each view shown in the scrollview is
 
 @param frame the frame of the scrollview
 @param config any custom setup to the scrollview
 @see VLBScrollViewAllowSelection to allow for user 'tapable' pages
 */
+(VLBScrollView *) newVerticalScrollView:(CGRect)frame config:(VLBScrollViewConfig)config;
/**
 Creates a new scroll view which scrolls on the horizontal axis.
 
 @param frame the frame of the scroll view
 @param config any custom setup to the scrollview
 @see VLBScrollViewAllowSelection to allow for user 'tapable' pages
 */
+(VLBScrollView *) newHorizontalScrollView:(CGRect)frame config:(VLBScrollViewConfig)config;

@property(nonatomic, weak) IBOutlet id <VLBScrollViewDatasource> datasource;
@property(nonatomic, weak) IBOutlet id <VLBScrollViewDelegate> scrollViewDelegate;

/// when set to YES, the scrollview will 'seek' the edge of a view before coming to a halt under inertial scrolling
@property(nonatomic, assign, getter = isSeekingEnabled) BOOL enableSeeking;

/**
	Causes the scroll view to query its delegate and datasource in order to layout its pages. 

	Use this method when the underlying datasource holds more recent data since the last call to setNeedsLayout
	@see UIScrollView#setNeedsLayout
 */
-(void)setNeedsLayout;

/**
 Scrolls to the bounds of the scroll view where the page of the given index is visible.

@param index the index of the page to be visible after scrolling stops
@param animated YES to animate the scrolling
 */
-(void)scrollIndexToVisible:(NSUInteger)index animated:(BOOL)animated;


@end
