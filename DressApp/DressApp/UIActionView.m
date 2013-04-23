//
//  UIActionView.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 12/30/11.
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


#import "UIActionView.h"
#import "StyleDressApp.h"

@implementation UIActionView
@synthesize buttonsTextArray;
@synthesize actionViewBackgroundImageView;
@synthesize delegate;
@synthesize selectedIndex;
@synthesize actionViewTitle,myFontSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) initView
{
 
    initialButtonsPositionY=80;
    LabelHeight=60;
    buttonsSpace=60;
    UIFont *myFont= [StyleDressApp fontWithStyleNamed:StyleFontActionView AndSize:myFontSize];
    
    self.opaque=NO;
    self.backgroundColor=[StyleDressApp colorWithStyleForObject:StyleColorActionViewBackground];
    
    //BAckground Image - strip
    UIImageView *backgroundImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width,self.frame.size.height)];
    backgroundImageView.image=[StyleDressApp imageWithStyleNamed:@"GEActionSheetBackground"];
    backgroundImageView.alpha=0.90;
    [self addSubview:backgroundImageView];

    //ActionView Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, LabelHeight)];
    [titleLabel setTextAlignment:UITextAlignmentCenter]; 
    [titleLabel setNumberOfLines:0];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    titleLabel.text= actionViewTitle;
    titleLabel.font=myFont;
    titleLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorActionViewTitle];
    [self addSubview:titleLabel];

    //Adding buttons
    for (int i=0;i<[buttonsTextArray count]; i++) 
    {
        //Add button
        UIButton *tempButton = [[UIButton alloc] initWithFrame:CGRectMake(35, initialButtonsPositionY+i*buttonsSpace, 250, 54)];
        [tempButton setTag:10+i];
        [tempButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        if (i==selectedIndex)
            [tempButton setImage:[StyleDressApp imageWithStyleNamed:@"GEActionSheetButtonSelected"] forState:UIControlStateNormal]; 
         else
             [tempButton setImage:[StyleDressApp imageWithStyleNamed:@"GEActionSheetButton"] forState:UIControlStateNormal];
        
        //Add textLabel
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 220, 45)];
        [tempLabel setTextAlignment:UITextAlignmentCenter]; 
        [tempLabel setBackgroundColor:[UIColor clearColor]];
         tempLabel.text= [buttonsTextArray objectAtIndex:i];
        tempLabel.font=myFont;
        if (i==selectedIndex)
            tempLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorActionViewCellSelected];
        else
            tempLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorActionViewCell];
        [tempButton addSubview:tempLabel];
        [self addSubview:tempButton];
        
    }

    //Start animation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    self.frame=CGRectMake(0,436-LabelHeight-buttonsSpace*(1+[buttonsTextArray count]),self.frame.size.width,self.frame.size.height);
    [self.delegate actionView:self changeAlpha:0.5 toState:MainViewStateBegin];
    [UIView commitAnimations];
    
}

-(void) buttonPressed:(UIButton*)sender
{
    selectedIndex=[sender tag]-10;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationViewFinished:finished:context:)];
    self.frame=CGRectMake(0,480,self.frame.size.width,self.frame.size.height);
    [self.delegate actionView:self changeAlpha:1.0 toState:MainViewStateEnd];
    [UIView commitAnimations];

}

- (void)animationViewFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    [self.delegate actionView:self didSelectIndex:selectedIndex];
    
}

@end
