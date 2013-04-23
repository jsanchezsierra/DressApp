//
//  CalendarDayView.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 12/8/11.
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


#import "CalendarDayView.h"
#import "StyleDressApp.h"

@implementation CalendarDayView
@synthesize dayText,dayImage;
@synthesize backgroundRectColor,dayTextColor,backgroundLineColor;
@synthesize backgroundLineOffset,backgroundLineWidth,backgroundLineRadius;
@synthesize drawFill;
@synthesize textLabel,dayImageView;
@synthesize dayTypeStyle;
@synthesize delegate;
@synthesize dayDate;


- (id)initWithFrame:(CGRect)frame //text:(NSString*)text andImage:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) initView
{
    
    isButtonFocused=NO;
    
    //Set white for background color with alpha=0
    self.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0];

    [self assignColors];
        
    //set red for fill color
    backgroundLineWidth=1;
    backgroundLineOffset=1;
    backgroundLineRadius=1;
    drawFill=NO;

    //Control TextLabel
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(23,2,15,12) ];
    textLabel.backgroundColor=[UIColor clearColor];
    textLabel.textAlignment=UITextAlignmentRight;
    textLabel.textColor =dayTextColor;
    textLabel.text=dayText;
    textLabel.font=[UIFont systemFontOfSize:12 ];
    [self addSubview:self.textLabel];
    
    self.dayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3,12,29,29) ];
    [dayImageView setContentMode:UIViewContentModeScaleToFill];
    [dayImageView setImage:dayImage];
    [self addSubview:self.dayImageView];

}


-(void) assignColors
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDate  = [formatter stringFromDate:dayDate];
    NSString *today  = [formatter stringFromDate:[NSDate date] ];

    if ([currentDate isEqualToString:today]) 
        dayTypeStyle=CalendarDayTypeStyleToday;

    if (dayTypeStyle==CalendarDayTypeStyleNormal) {
        self.dayTextColor = [StyleDressApp colorWithStyleForObject:StyleColorCalendarDay];
        self.backgroundLineColor = [UIColor colorWithRed:0. green:0. blue:.0 alpha:.8];
        self.backgroundRectColor = [StyleDressApp colorWithStyleForObject:StyleColorCalendarFillNormalDay];
    } else if (dayTypeStyle == CalendarDayTypeStyleWeekend)
    {
        self.dayTextColor = [StyleDressApp colorWithStyleForObject:StyleColorCalendarWeekendDay];
        self.backgroundLineColor = [UIColor colorWithRed:0. green:0. blue:.0 alpha:.8];
        self.backgroundRectColor = [StyleDressApp colorWithStyleForObject:StyleColorCalendarFillNormalDay];
    } else if (dayTypeStyle == CalendarDayTypeStyleOtherMonth)
    {
        self.dayTextColor = [StyleDressApp colorWithStyleForObject:StyleColorCalendarOtherMonthDay];
        self.backgroundLineColor = [UIColor colorWithRed:0. green:0. blue:.0 alpha:.2];
        self.backgroundRectColor = [StyleDressApp colorWithStyleForObject:StyleColorCalendarFillOtherMonthDay];
        
    }else if (dayTypeStyle == CalendarDayTypeStyleToday)
    {
        self.dayTextColor = [StyleDressApp colorWithStyleForObject:StyleColorCalendarDay];
        self.backgroundLineColor = [UIColor colorWithRed:0. green:0. blue:.0 alpha:.2];
        self.backgroundRectColor = [StyleDressApp colorWithStyleForObject:StyleColorCalendarFillToday];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code


    CGContextRef    context = UIGraphicsGetCurrentContext();
    
    float fw, fh; 
    float ovalWidth=backgroundLineRadius;
    float ovalHeight=backgroundLineRadius;
    
    
    //Box draw external Line 
    CGContextSetLineWidth(context,backgroundLineWidth);
    CGContextSetStrokeColorWithColor(context, backgroundLineColor.CGColor);
    CGRect boxRect= CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGContextSaveGState(context); 
    CGContextTranslateCTM (context, CGRectGetMinX(boxRect), 
                           CGRectGetMinY(boxRect)); 
    CGContextScaleCTM (context, ovalWidth, ovalHeight); 
    fw = CGRectGetWidth (boxRect) / ovalWidth;
    fh = CGRectGetHeight (boxRect) / ovalHeight; 
    CGContextMoveToPoint(context, fw, fh/2); 
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); 
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); 
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); 
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); 
    CGContextClosePath(context); 
    CGContextRestoreGState(context); 
    CGContextStrokePath(context);
 
    //Asigna un color diferente a los dias del mes o de otros meses
    [self assignColors];

    if (drawFill) 
        self.backgroundRectColor = [StyleDressApp colorWithStyleForObject:StyleColorCalendarSelectedDay];

    
    //Box Fill 
    CGContextSetLineWidth(context,0);
    const CGFloat* components = CGColorGetComponents(backgroundRectColor.CGColor);
    CGContextSetFillColor(context, components);
    CGRect insideRect= CGRectMake(backgroundLineOffset, backgroundLineOffset, self.frame.size.width-2*backgroundLineOffset, self.frame.size.height-2*backgroundLineOffset);
    CGContextSaveGState(context); 
    CGContextTranslateCTM (context, CGRectGetMinX(insideRect), 
                           CGRectGetMinY(insideRect)); 
    CGContextScaleCTM (context, ovalWidth, ovalHeight); 
    fw = CGRectGetWidth (insideRect) / ovalWidth;
    fh = CGRectGetHeight (insideRect) / ovalHeight; 
    CGContextMoveToPoint(context, fw, fh/2); 
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); 
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); 
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); 
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); 
    CGContextClosePath(context); 
    CGContextRestoreGState(context); 
    CGContextFillPath(context);    
    


}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint location;
    
    if ([touches count] > 0) 
    {
        for (UITouch *touch in touches) 
        {
            location = [touch locationInView: self];
            if ( (dayTypeStyle != CalendarDayTypeStyleOtherMonth) && (location.x< self.frame.size.width) && (location.x>0)&& (location.y< self.frame.size.height) && (location.y>0) && isButtonFocused==NO)  //Capturo el primer touch dentro
            {
                isButtonFocused=YES;
                initialTouch=touch;
                drawFill=YES;
                [self setNeedsDisplay];
            }
        }
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location;
    
    if ([touches count] > 0) {
        for (UITouch *touch in touches) {

            location = [touch locationInView: self];
            
            if ((dayTypeStyle != CalendarDayTypeStyleOtherMonth) && (location.x< self.frame.size.width) && (location.x>0)&& (location.y< self.frame.size.height) && (location.y>0) && isButtonFocused==NO)  //Capture Firts Touch Moved inside
            {
                initialTouch=touch;
                drawFill=YES;
                [self setNeedsDisplay];
                isButtonFocused=YES;

            }
            else if ((dayTypeStyle != CalendarDayTypeStyleOtherMonth) &&  touch==initialTouch &&  isButtonFocused==YES && !( (location.x< self.frame.size.width) && (location.x>0)&& (location.y< self.frame.size.height) && (location.y>0) )   )
            {
                initialTouch=nil;
                drawFill=NO;
                [self setNeedsDisplay];
                isButtonFocused=NO;
            }
        }
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    initialTouch=nil;
    drawFill=NO;
    [self setNeedsDisplay];
    isButtonFocused=NO;


}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location;
    
    if ([touches count] > 0) 
    {
        for (UITouch *touch in touches) 
        {
            location = [touch locationInView: self];
            
            if ((dayTypeStyle != CalendarDayTypeStyleOtherMonth) && touch==initialTouch &&  isButtonFocused==YES &&  (location.x< self.frame.size.width) && (location.x>0)&& (location.y< self.frame.size.height) && (location.y>0)    )
            {
                [self.delegate calendarDaySelectedForDate:self.dayDate];
                initialTouch=nil;
                drawFill=NO;
                [self setNeedsDisplay];
                isButtonFocused=NO;

            }
        
        }
    }
}


@end
