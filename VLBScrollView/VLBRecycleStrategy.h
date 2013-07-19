//
//  VLBecycleStrategy.h
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

#import <UIKit/UIKit.h>

/*
 * Use this class to recycle views that go outside of given bounds
 *
 * @see recycle:bounds
 *
 */
@interface VLBRecycleStrategy : NSObject

@property(nonatomic, strong) NSMutableSet *recycledViews;

-(id)init;

/** Stores the given views and makes them available in #dequeueReusableView
 
 @param views the UIView(s) to make available for dequeuing 
 */
-(void)recycle:(NSArray *)views;

/*
 * Any view from the array that is not within the specified bounds will be placed
 * in the recycled views and subsequently removed from the it's superview
 *
 * @param the subviews to recycle
 * @param the visible bounds
 */
-(void)recycle:(NSArray *)views bounds:(CGRect) bounds;

/*
 * Returns a UIView from the recycled views. The UIView is not guarranteed to be in any specific state.
 * The caller needs to make sure that any relevant state is configured.
 *
 * e.g.
 *	frame
 *	contentSize
 *
 * @return a view
 */
-(UIView *)dequeueReusableView;

@end
