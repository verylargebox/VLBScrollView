//
//  VLBecycleStrategy.m
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

#import "VLBRecycleStrategy.h"

@implementation VLBRecycleStrategy

@synthesize recycledViews;


-(id)init
{
	self = [super init];
	
	if (self) 
	{
		self.recycledViews = [NSMutableSet new];
	}
	
	return self;
}

-(void)recycle:(NSArray *)views {
    [recycledViews addObjectsFromArray:views];
}

-(void)recycle:(NSArray *)views bounds:(CGRect) bounds
{	
	for (UIView *visibleView in views) 
	{
		if(!CGRectIntersectsRect(visibleView.frame, bounds))
		{
			DDLogVerbose(@"recycle view %@", visibleView);
			[recycledViews addObject:visibleView];
			[visibleView removeFromSuperview];			
		}
	}
}

-(UIView *)dequeueReusableView
{
	UIView *view = [self.recycledViews anyObject];
    __strong UIView* copy = view;
    if (view) {
        [self.recycledViews removeObject:view];
    }

	DDLogVerbose(@"dequeueReusableView %@", view);
	
return copy;
}

@end
