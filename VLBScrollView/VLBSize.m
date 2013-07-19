//
//  VLBSize.m
//  VLBScrollView
//
//  Created by Markos Charatzas on 13/12/2010.
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

#import "VLBSize.h"

@implementation VLBHeight

+(VLBHeight *) newHeight:(CGFloat)height{
    return [[VLBHeight alloc] init:height];
}

@synthesize value;

-(id)init:(CGFloat) aHeight
{
	self = [super init];
	
	if (self) {
		value = aHeight;
	}	
	
return self;
}

-(NSInteger)floorIndexOf:(CGPoint)point
{
    if(point.y < 0){
        return 0;
    }
    
return floorf( point.y / value);
}

-(NSInteger)ceilIndexOf:(CGRect)rect
{
	NSInteger visibleWindowStart = rect.origin.y;
	NSInteger visibleWindowHeight = CGRectGetHeight(rect);
	
return ceilf((visibleWindowStart + visibleWindowHeight) / value);
}

- (CGPoint)ceilOriginOf:(CGRect)bounds toContentSize:(CGSize)contentSize
{
    NSUInteger originY = MIN(CGRectGetMinY(bounds) + bounds.size.height, contentSize.height) - bounds.size.height;

return CGPointMake(CGRectGetWidth(bounds), originY);
}

-(CGRect)frameOf:(CGRect)bounds atIndex:(NSUInteger)index {
return CGRectMake(bounds.origin.x, index * self.value, bounds.size.width, self.value);
}

-(CGPoint)pointOf:(NSUInteger)index {
return CGPointMake(0, self.value * index);
}

-(CGPoint)pointOf:(NSUInteger)index offset:(UIEdgeInsets)edgeInsets {
    return CGPointMake((self.value * index) - edgeInsets.top, 0);
}

-(void)moveCloserToWhole:(inout CGPoint*)point offset:(UIEdgeInsets)edgeInsets
{
    float average = self.value / 2.0;
    
    float mod = fmod(point->y + edgeInsets.top, self.value);
    float whole = point->y - mod;
    
    if(mod <= average){
        point->y = whole;
    return;
    }
    
    point->y = whole + self.value;
}

-(void)moveCloserToWhole:(inout CGPoint*)point
{
    float average = self.value / 2.0;
    
    float mod = fmod(point->y, self.value);
    float whole = point->y - mod;
    
    if(mod <= average){
        point->y = whole;
        return;
    }
    
    point->y = whole + self.value;
}

-(NSString *) description{
return [NSString stringWithFormat:@"%f", value];
}

@end

@implementation VLBWidth

+(VLBWidth *) newWidth:(CGFloat)width{
    return [[VLBWidth alloc] init:width];
}

@synthesize value;

-(id)init:(CGFloat) aWidth
{
	self = [super init];
	
	if (self) {
		value = aWidth;
	}	
	
return self;
}

-(NSInteger)floorIndexOf:(CGPoint)point {
    if(point.x < 0)
        return 0;
    
return floorf( point.x / value);
}

-(NSInteger)ceilIndexOf:(CGRect)rect
{
	NSInteger visibleWindowStart = CGRectGetMinX(rect);
	NSInteger visibleWindowWidth = CGRectGetWidth(rect);
	
return ceilf((visibleWindowStart + visibleWindowWidth) / value);
}

- (CGPoint)ceilOriginOf:(CGRect)bounds toContentSize:(CGSize)contentSize
{
    NSUInteger originX = MIN(CGRectGetMinX(bounds) + bounds.size.width, contentSize.width) - bounds.size.width;

return CGPointMake(originX, CGRectGetHeight(bounds));
}

-(CGRect)frameOf:(CGRect)bounds atIndex:(NSUInteger)index {
return CGRectMake(index * self.value, bounds.origin.y, self.value, bounds.size.height);
}

-(CGPoint)pointOf:(NSUInteger)index {
return CGPointMake(self.value * index, 0);
}

-(CGPoint)pointOf:(NSUInteger)index offset:(UIEdgeInsets)edgeInsets {
    return CGPointMake((self.value * index) - edgeInsets.left, 0);
}

-(void)moveCloserToWhole:(inout CGPoint*)point
{
    float average = self.value / 2.0;
    
    float mod = fmod(point->x, self.value);
    float whole = point->x - mod;
    
    if(mod <= average){
        point->x = whole;
    return;
    }
    
    point->x = whole + self.value;
}

-(void)moveCloserToWhole:(inout CGPoint*)point  offset:(UIEdgeInsets)edgeInsets
{
    float average = self.value / 2.0;
    
    float mod = fmod(point->x + edgeInsets.left, self.value);
    float whole = point->x - mod;
    
    if(mod <= average){
        point->x = whole;
        return;
    }
    
    point->x = whole + self.value;
}

-(NSString *) description{
return [NSString stringWithFormat:@"%f", value];
}

@end


@implementation VLBSizeInHeight

@synthesize size;

-(id)initWithSize:(CGSize) theSize
{
	self = [super init];
	
	if (self) 
	{
		self.size = theSize;
	}
	
return self;
}

-(CGSize)sizeOf:(NSUInteger)noOfRows size:(CGFloat)height
{
    if(noOfRows == 0){
		return CGSizeZero;
	}
    
	float noOfRowsInHeight = self.size.height / height;
	
    return CGSizeMake(
                      self.size.width, 
                      ((float)noOfRows / (float)noOfRowsInHeight) * self.size.height);
}

/*
 * @return a dimension on height
 */
-(id<VLBDimension>)dimension{
return [[VLBHeight alloc] init:self.size.height];
}

@end

@implementation VLBSizeInWidth

@synthesize size;

-(id)initWithSize:(CGSize) theSize
{
	self = [super init];
	
	if (self) 
	{
		self.size = theSize;
	}
	
    return self;
}

-(CGSize)sizeOf:(NSUInteger)noOfColumns size:(CGFloat)width
{
    if(noOfColumns == 0){
		return CGSizeZero;
	}

	float nofOfColumnsInWidth = self.size.width / width;
	
return CGSizeMake(
		  ((float)noOfColumns / (float)nofOfColumnsInWidth) * self.size.width,
		  self.size.height);
}

/*
 * @return a dimension on width
 */
-(id<VLBDimension>)dimension{
    return [[VLBWidth alloc] init:self.size.width];
}

@end
