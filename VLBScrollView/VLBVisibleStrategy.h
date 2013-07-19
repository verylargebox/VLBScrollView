//
//  VLBVisibleStrategy.h
//  VLBScrollView
//
//  Created by Markos Charatzas on 27/11/2010.
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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "VLBSize.h"

typedef NSInteger(^VisibleIndexPrecondition)(NSInteger, NSInteger);

CG_INLINE
VisibleIndexPrecondition acceptAnyVisibleIndex()
{
    VisibleIndexPrecondition precondition = ^(NSInteger currentVisibleIndex, NSInteger visibleIndex){
        return visibleIndex;
    };
    
    return precondition;
}

CG_INLINE
VisibleIndexPrecondition ceilVisibleIndexAt(NSInteger ceil)
{
    VisibleIndexPrecondition precondition = ^(NSInteger currentVisibleIndex, NSInteger visibleIndex)
    {
        if(visibleIndex < ceil){
            return ceil;
        }
        
        return visibleIndex;
    };
    
    return precondition;
}

CG_INLINE
VisibleIndexPrecondition floorVisibleIndexAt(NSInteger floor)
{
    VisibleIndexPrecondition precondition = ^(NSInteger currentVisibleIndex, NSInteger visibleIndex)
    {
        if(visibleIndex > floor){
            return floor;
        }
        
        return visibleIndex;
    };
    
    return precondition;
}

@protocol VisibleStrategyDelegate<NSObject>

/*
 * @return the view corresponding to the index
 */
-(UIView *)shouldBeVisible:(int)index;

/**
 @param minimumVisibleIndex the minimum visible index to appear in the next cycle
 @param maximumVisibleIndex the maximum visible index to appear in the next cycle
 */
-(void)viewsShouldBeVisibleBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex;

@end


@protocol VLBVisibleStrategy <NSObject>

- (NSInteger)minimumVisible:(CGPoint)bounds;

- (NSInteger)maximumVisible:(CGRect)bounds;

-(BOOL)isVisible:(NSInteger) index;

/**
 Calculates indexes based on bounds.
 
 For every visible index a call to VisibleStrategyDelegate#shouldBeVisible
 will be made if the index is not already visible from a prior call.
  
 @postcondion the minimum visible index is set
 @postcondion the maximum visible index is set to maximumVisibleIndex - 1
 @param bounds the visible bounds
 @see newVisibleStrategyOn:
 */
- (void)layoutSubviews:(CGRect) bounds;

/**
 Applies a precondition to the maximum visible index. If the maximum visible index as calculated by 
 the bounds given in willAppear: doesn't satisfy the precondition, the last maximum visible index is used.
 
 @param conformToPrecondition the precondition that the maximum visible index should apply to
 @see ceilMaximumVisibleIndexAt
 */
-(void)minimumVisibleIndexShould:(VisibleIndexPrecondition)conformToPrecondition;

-(void)maximumVisibleIndexShould:(VisibleIndexPrecondition)conformToPrecondition;

@property(nonatomic, unsafe_unretained) id<VisibleStrategyDelegate> delegate;

@required
@property(nonatomic, retain) NSMutableSet *visibleViews;
@property(nonatomic, assign) NSInteger minimumVisibleIndex;
@property(nonatomic, assign) NSInteger maximumVisibleIndex;

@end

#define VLB_MINIMUM_VISIBLE_INDEX    NSIntegerMax
#define VLB_MAXIMUM_VISIBLE_INDEX    NSIntegerMin
/*
 * Use to normalise the bounds to an index of what's to show while also
 * keeping track of the minimum and maximum visible view based on it's index
 */
@interface VLBVisibleStrategy : NSObject <VLBVisibleStrategy>
{
@private
    NSInteger minimumVisibleIndex;
    NSInteger maximumVisibleIndex;
}
@property(nonatomic) id<VLBDimension> dimension;

+(VLBVisibleStrategy *)newVisibleStrategyOnWidth:(CGFloat) width;
+(VLBVisibleStrategy *)newVisibleStrategyOnHeight:(CGFloat) height;
+(VLBVisibleStrategy *)newVisibleStrategyOn:(id<VLBDimension>) dimension;
+(VLBVisibleStrategy *)newVisibleStrategyFrom:(VLBVisibleStrategy *) visibleStrategy;

- (NSInteger)minimumVisible:(CGPoint)bounds;

- (NSInteger)maximumVisible:(CGRect)bounds;

@end
