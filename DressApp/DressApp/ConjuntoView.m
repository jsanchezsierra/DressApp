//
//  ConjuntoView.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 11/2/11.
//  Copyright (c) 2011 Javier Sanchez Sierra. All rights reserved.
//
// This file is part of DressApp.

// DressApp is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// DressApp is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//
// Permission is hereby granted, free of charge, to any person obtaining 
// a copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation the 
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
// sell copies of the Software, and to permit persons to whom the Software is furnished 
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//https://github.com/jsanchezsierra/DressApp


#import "ConjuntoView.h"
#import "Conjunto.h"
#import "StyleDressApp.h"

@implementation ConjuntoView
@synthesize itemImageView;
@synthesize delegate;
@synthesize isSelected;
@synthesize conjunto; 
@synthesize offset,offsetItem;

- (id)initWithFrame:(CGRect)frame andOffset:(NSInteger)newOffset
{
    self = [super initWithFrame:frame];
    if (self) {
        self.offset=newOffset;
    }
    return self;
}


-(void) initView
{
    isSelected=NO;
    selectedColor= [[UIColor alloc]initWithRed:0.3 green:0.3 blue:0. alpha:0.4 ];
    
    resetFrame=self.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startVibrationAnimation) name:@"startVibrationAnimation" object:nil]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVibrationAnimation) name:@"stopVibrationAnimation" object:nil]; 
    
    CGRect imageViewFrame= CGRectMake( (CGFloat) offset, (CGFloat)offset, (CGFloat)self.frame.size.width-2*offset, (CGFloat)self.frame.size.height-2*offset);
    
    frameImageView = [[UIImageView alloc] initWithFrame:imageViewFrame ];
    [frameImageView setContentMode:UIViewContentModeScaleToFill];
    [frameImageView setAlpha:1.0];
    frameImageView.image=[StyleDressApp imageWithStyleNamed:@"COMainItemsViewFrame"];
    [self addSubview:frameImageView];

    offsetItem=offset+7;
    CGRect imageViewItem= CGRectMake( (CGFloat) offsetItem, (CGFloat)offsetItem, (CGFloat)self.frame.size.width-2*offsetItem, (CGFloat)self.frame.size.height-2*offsetItem);

    itemImageView = [[UIImageView alloc] initWithFrame:imageViewItem ];
    [itemImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:itemImageView];
    
}

 
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isSelected==NO) 
    {
        [delegate ConjuntoViewControlDelegate:self didChooseItem:conjunto];
        isSelected=YES;
    }
}


@end
