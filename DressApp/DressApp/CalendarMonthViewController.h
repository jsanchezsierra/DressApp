//
//  CalendarMonthViewController.h
//  DressApp
//
//  Created by Javier Sanchez Sierra on 12/5/11.
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


#import <UIKit/UIKit.h>
#import "CalendarDayView.h"

@protocol CalendarMonthVCDelegate;

@interface CalendarMonthViewController : UIViewController <CalendarDayViewDelegate>

{
    NSString *cachesDirectory;
    NSFileManager *fileManager;
    
    NSInteger numberOfDaysInCurrentMonth;
    NSInteger numberOfDaysInPrevMonth;
    NSInteger numberOfDaysInNextMonth;

    NSInteger currentMonth;
    NSInteger currentYear;
    
    NSCalendar *myCalendar;
    
    NSDate *firstDayOfMonth;
    NSDate *lastDayOfMonth;
    
    NSInteger weekdayOfFirstDayOfMonth;
    NSInteger weekdayOfLastDayOfMonth;  
    
    NSInteger weekOfFirstDayOfMonth;
    NSInteger weekOfLastDayOfMonth;

    NSInteger firstDayForFirstRow;
    NSInteger firstDayForSecondRow;
    
    IBOutlet UILabel *weekDay1;
    IBOutlet UILabel *weekDay2;
    IBOutlet UILabel *weekDay3;
    IBOutlet UILabel *weekDay4;
    IBOutlet UILabel *weekDay5;
    IBOutlet UILabel *weekDay6;
    IBOutlet UILabel *weekDay7;

    IBOutlet UIButton *nextMonthButton;
    IBOutlet UIButton *prevMonthButton;
}

@property (nonatomic, strong) IBOutlet UILabel *monthLabel;
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIImageView *monthYearImageView;
@property (nonatomic, assign) id <CalendarMonthVCDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UIActivityIndicatorView *myViewActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMonth:(NSInteger)mes;
-(void) drawCalendar;
-(NSString*) calculateDayOfMonthForRow:(NSInteger)row andColumn:(NSInteger)column forDay:(CalendarDayView*)dayView;
-(void) dateAndImageForMonthDay:(NSInteger)dayMonth forDayView:(CalendarDayView*)dayView;
-(IBAction) goToPreviousMonth;
-(IBAction) goToNextMonth;
-(void) drawCalendarWeekDays;

@end

@protocol CalendarMonthVCDelegate

-(void) calendarCreateNewEntryForDay:(NSDate*)dayDate;
-(void) calendarEditEntryForDay:(NSDate*)dayDate;
-(void) previousMonthAnimated:(BOOL)isAnimated;
-(void) nextMonthAnimated:(BOOL)isAnimated;


@end