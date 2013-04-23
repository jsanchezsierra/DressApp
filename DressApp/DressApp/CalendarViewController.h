//
//  CalendarViewController.h
//  DressApp
//
//  Created by Javier Sanchez Sierra on 11/21/11.
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
#import "MenuProtocolDelegate.h"
#import "CalendarMonthViewController.h"
#import "ConjuntosViewController.h"
#import "CalendarDayDetailVC.h"

 
@interface CalendarViewController : UIViewController <UIScrollViewDelegate, CalendarMonthVCDelegate,ConjuntosViewControllerDelegate,CalendarDayDetailVCDelegate>
{   
    NSInteger numberOfPages;
    NSString *cachesDirectory;
    NSFileManager *fileManager;
    BOOL checkScrollXPosition;
    BOOL creatingNoteForToday;
    BOOL viewDidAlreadyLoad;
}

//Delegate
@property (nonatomic, assign) id<MenuProtocolDelegate>delegate;

//Container View
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong ) IBOutlet UIView *leftLineView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *myViewActivity;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

//CoreData managedObjectContext
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) NSInteger currentPage; 
@property (nonatomic, assign) BOOL isRight;
@property (nonatomic, strong) NSDate *selectedDate;

-(void) loadScrollViewWithPage:(int)page;
-(void) unLoadScrollViewWithPage:(int)page;
-(void) changeToPrendasVC;
-(void) changeToConjuntosVC;
-(void) changeToCalendarVC;
-(void) loadUnloadViews;
-(void) unloadAllViews;
-(void) viewInitCalendar;

@end

 
