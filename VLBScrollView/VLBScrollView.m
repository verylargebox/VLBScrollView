//
//  VLBScrollView.m
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

#import "VLBScrollView.h"
#import "VLBRecycleStrategy.h"
#import "VLBVisibleStrategy.h"
#import "VLBSize.h"
#import <QuartzCore/QuartzCore.h>
#import "DDLog.h"
#import "VLBMacros.h"

@interface VLBScrollView ()
/* Apparently a UIScrollView needs another view as its content view else it messes up the scrollers.
 * Interface Builder uses a private _contentView instead.
 */
@property(nonatomic, strong) IBOutlet UIView *contentView;

@property(nonatomic, assign) BOOL needsLayout;
@property(nonatomic, strong) VLBRecycleStrategy *recycleStrategy;
@property(nonatomic, strong) id<VLBVisibleStrategy> visibleStrategy;

@property(nonatomic, strong) NSObject<VLBSize> *size;
@property(nonatomic, strong) NSObject<VLBDimension> *dimension;

-(void)didTapOnScrollView:(id)sender;
@end

VLBScrollViewOrientation const VLBScrollViewOrientationVertical = ^(VLBScrollView *scrollView)
{
    scrollView.size= [[VLBSizeInHeight alloc] initWithSize:scrollView.frame.size];
    scrollView.dimension = [VLBHeight newHeight:[scrollView.scrollViewDelegate viewsOf:scrollView]];
    scrollView.recycleStrategy = [[VLBRecycleStrategy alloc] init];
    scrollView.visibleStrategy = [VLBVisibleStrategy newVisibleStrategyOnHeight:[scrollView.scrollViewDelegate viewsOf:scrollView]];
    scrollView.visibleStrategy.delegate = scrollView;
};

VLBScrollViewOrientation const VLBScrollViewOrientationHorizontal = ^(VLBScrollView *scrollView)
{
    scrollView.size = [[VLBSizeInWidth alloc] initWithSize:scrollView.frame.size];
    scrollView.dimension = [VLBWidth newWidth:[scrollView.scrollViewDelegate viewsOf:scrollView]];
    scrollView.recycleStrategy = [[VLBRecycleStrategy alloc] init];
    scrollView.visibleStrategy = [VLBVisibleStrategy newVisibleStrategyOnWidth:[scrollView.scrollViewDelegate viewsOf:scrollView]];
    scrollView.visibleStrategy.delegate = scrollView;
};

VLBScrollViewConfig const VLBScrollViewConfigEmpty = ^(VLBScrollView *scrollView, BOOL cancelsTouchesInView){};

VLBScrollViewConfig const VLBScrollViewAllowSelection = ^(VLBScrollView *scrollView, BOOL cancelsTouchesInView)
{
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:scrollView action:@selector(didTapOnScrollView:)];
    
    tapGestureRecognizer.cancelsTouchesInView = cancelsTouchesInView;
    [scrollView addGestureRecognizer:tapGestureRecognizer];
};

@implementation VLBScrollView

@synthesize contentView;

+(VLBScrollView *) newVerticalScrollView:(CGRect)frame config:(VLBScrollViewConfig)config
{
	VLBScrollView *scrollView = [[VLBScrollView alloc] initWithFrame:frame];
	config(scrollView, NO);
    
	VLBScrollViewOrientationVertical(scrollView);
    
return scrollView;
}

+(VLBScrollView *) newHorizontalScrollView:(CGRect)frame config:(VLBScrollViewConfig)config
{
	VLBScrollView *scrollView = [[VLBScrollView alloc] initWithFrame:frame];
	config(scrollView, NO);
    
	VLBScrollViewOrientationHorizontal(scrollView);
    
return scrollView;
}

#pragma mark private fields

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    VLB_LOAD_VIEW();
    
    self.scrollsToTop = NO;
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    
return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    VLB_LOAD_VIEW();
    
    self.scrollsToTop = NO;
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    
return self;
}

-(void)awakeFromNib
{
	[self.scrollViewDelegate orientation:self](self);
}

-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    self.contentView.frame = CGRectMake(CGPointZero.x, CGPointZero.y,
                                        self.contentSize.width, self.contentSize.height);
}

-(void)recycleVisibleViewsWithinBounds:(CGRect)bounds {
	[self.recycleStrategy recycle:[self.visibleStrategy.visibleViews allObjects] bounds:bounds];
}

-(void)removeRecycledFromVisibleViews {
	[self.visibleStrategy.visibleViews minusSet:self.recycleStrategy.recycledViews];
}

/**
  The Visible strategy uses VLBDimension which will ceilf the bounds as to catch any partially visible cells.
  However, reaching at the edge of the scrollview, will cause the bounds to include the "bouncing" part of the view which
  shouldn't be taken into account as something partially visible. Therefore need to keep the width at a maximum.
 
  Visible bounds should be at maximum the original width and height
 
  @see VLBDimension#maximumVisible:
 */
-(void)displayViewsWithinBounds:(CGRect)bounds
{
    [self.visibleStrategy layoutSubviews:bounds];
}

/** Called whenever the scroll view is scrolled.
 
 http://stackoverflow.com/questions/2760309/uiscrollview-calls-layoutsubviews-each-time-its-scrolled
 
 Calculates the content size.
 Recycles any visible views within its bounds
 Removes any non visible views
 Shows views within bounds
 */
-(void) layoutSubviews
{
    NSUInteger numberOfViews = [self.datasource numberOfViewsInScrollView:self];
    if(numberOfViews == 0){
        return;
    }
    
	[self.visibleStrategy minimumVisibleIndexShould:ceilVisibleIndexAt(0)];
	[self.visibleStrategy maximumVisibleIndexShould:floorVisibleIndexAt(numberOfViews)];
    self.contentSize = [self.size sizeOf:numberOfViews size:self.dimension.value];
	
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
	DDLogVerbose(@"frame %@", NSStringFromCGRect(self.frame));
	DDLogVerbose(@"contentSize %@", NSStringFromCGSize(self.contentSize));
    
    CGRect bounds = [self bounds];
    DDLogVerbose(@"layoutSubviews on bounds %@", NSStringFromCGRect(bounds));
    
	[self recycleVisibleViewsWithinBounds:bounds];
	[self removeRecycledFromVisibleViews];
	[self displayViewsWithinBounds:bounds];
    
    if(self.needsLayout){
        [self.scrollViewDelegate didLayoutSubviews:self];
        self.needsLayout = NO;
    }
}
/*
 Call this method will recycle any subviews that where added as part of
 VLBScrollView#viewInScrollView:atIndex: effectively removing them from this view.
 
 Any previously visible views are invalidated.
*/
-(void)setNeedsLayout
{
    [super setNeedsLayout];
    self.needsLayout = YES;
    NSArray* subviews = [self.contentView subviews];
    
    [self.recycleStrategy recycle:subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    VLBVisibleStrategy *aVisibleStrategy =
    [VLBVisibleStrategy newVisibleStrategyFrom:self.visibleStrategy];
	
	aVisibleStrategy.delegate = self;
	
	self.visibleStrategy = aVisibleStrategy;
}

-(UIView *)viewWithTag:(NSInteger)tag {
    return [self.contentView viewWithTag:tag];
}

-(NSArray *)subviews{
    return [self.contentView subviews];
}

/*
 * No need to remove dequeued view from superview since it's removed when recycled
 */
-(UIView*)dequeueReusableView {
    return [self.recycleStrategy dequeueReusableView];
}

-(NSUInteger)indexOf:(CGPoint)point {
    return [self.dimension floorIndexOf:point];
}

-(void)viewsShouldBeVisibleBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex
{
    [self.scrollViewDelegate viewInScrollView:self willAppearBetween:minimumVisibleIndex to:maximumVisibleIndex];
}

-(UIView *)shouldBeVisible:(int)index
{
    CGRect frame = [self.dimension frameOf:self.bounds atIndex:index];
    
    UIView* view = [self dequeueReusableView];
    view.frame = frame;
    
    if(view == nil){
        view = [self.datasource viewInScrollView:self ofFrame:frame atIndex:index];
    }
    else
    {
        /* This is really required due to VLBGridView design and not mandated by UIKit.
         VLBGridView currently uses VLBScrollView for its rows, hence when a view
         is dequeued it needs to have its subviews removed and recycled for reuse.
         
         This behavior should really be on VLBGridView, as a result of
         a view being dequeued.
         */
        [view setNeedsLayout];
    }
    
    [self.scrollViewDelegate viewInScrollView:self willAppear:view atIndex:index];
    
	/*
	 * Adding subviews to self places them side by side which
	 * causes scrollers to appear and disappear as if overlapping.
	 * Thus another scrollview is used as an mediator.
	 */
	[self.contentView addSubview:view];
    
    DDLogVerbose(@"added %@ as subview to %@", view, self);
    return view;
}

-(void)didTapOnScrollView:(id)sender
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer*)sender;
    CGPoint locationInView = [tapGestureRecognizer locationInView:self];
    NSUInteger index = [self indexOf:locationInView];
    DDLogVerbose(@"%u", index);
    
    NSUInteger numberOfViews = [self.datasource numberOfViewsInScrollView:self];
    
    if(index >= numberOfViews){
        return;
    }
    
    CGPoint point = [self.dimension pointOf:index offset:self.contentInset];
    
    [self.scrollViewDelegate didSelectView:self atIndex:index point:point];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(!self.isSeekingEnabled){
        return;
    }
    
    [self.dimension moveCloserToWhole:targetContentOffset offset:self.contentInset];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = CGPointMake(scrollView.bounds.origin.x + self.contentInset.left,
                                scrollView.bounds.origin.y + self.contentInset.top);
    
    [self.scrollViewDelegate scrollView:scrollView willStopAt:[self indexOf:point]];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGPoint point = CGPointMake(scrollView.bounds.origin.x + self.contentInset.left,
                                scrollView.bounds.origin.y + self.contentInset.top);
    
    
    [self.scrollViewDelegate scrollView:scrollView willStopAt:[self indexOf:point]];
}

-(void)scrollIndexToVisible:(NSUInteger)index animated:(BOOL)animated
{
    CGRect rect = [self.dimension frameOf:self.bounds atIndex:index];
    [super scrollRectToVisible:rect animated:animated];
}
@end
