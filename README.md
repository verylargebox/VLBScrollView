# Introduction
A UIScrollView that introduces the concept of 'pages', has built-in page recycling and support for both vertical and horizontal orientations.

# VLBScrollView
VLBScrollView divides a scrollview in equally sized views, each given an index so that it can be backed by a datasource.

e.g a vertical VLBScrollView of 3 with 196px for each view, yields the following:

<pre>
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
 

</pre>

The VLBScrollView is homogeneous, thus every view is of equal size and of the same type.

While scrolling, VLBScrollView will either use a recycled view or create an existing one if none available.
 
# What is included

* VLBScrollView
The 'VLBScrollView.xcodeproj' builds a static library 'libVLBScrollView.a'

# CocoaPods

-> VLBScrollView (1.0)
   A UIScrollView that introduces the concept of 'pages', has built-in recycling and support for both vertical and horizontal orientations.
   - Homepage: https://github.com/qnoid/VLBScrollView
   - Source:   https://github.com/qnoid/VLBScrollView.git
   - Versions: 1.0 [master repo]

# Versions
1.0 initial version. Support pages, horizontal/vertical orientation, tapable views, seeking.

# How to use

## Under Interface Builder
* Drag a UIView in the xib and change its type to VLBScrollView.
* Set its scrollViewdelegate property to a class that implements VLBScrollViewDelegate.
* Set its datasource property to a class that implements VLBScrollViewDatasource.
* Implement any @required methods to both protocols

## Under code

    VLBScrollView *verticalScrollView = [VLBScrollView newVerticalScrollView:self.view.frame config:^(VLBScrollView *scrollView, BOOL cancelsTouchesInView) {
        scrollView.datasource = self;
        scrollView.scrollViewDelegate = self;
    }];

		//scrollview will seek a 'page' so that it's always in full view
    scrollView.enableSeeking = YES;

		//every 'page' can be tapped to get a callback
    VLBScrollViewAllowSelection(scrollView, NO);


# Demo

See [VLBScrollViewApp][1].

# Future Work

Push a UINavigationBar out of the way on scroll  
Have a persistent header on scroll.

Improve the API; when constructing a new VLBScrollView enforce the precondition to set a datasource/scrollViewDelegate.  
Improve the API; make only the minimum implementation fall under the @required directive.

# Licence

VLBScrollView published under the MIT license:

Copyright (C) 2013, www.verylargebox.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[1]: https://github.com/qnoid/VLBScrollViewApp
