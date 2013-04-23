//
//  PrendasPrecioViewController.h
//  DressApp
//
//  Created by Javier Sanchez Sierra on 1/31/12.
//  Copyright (c) 2012 Javier Sanchez Sierra. All rights reserved.
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
#import "Prenda.h"

@protocol PrendasComposicionVCDelegate;

@interface PrendasComposicionViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
        NSString *nullString;
}

@property (nonatomic, assign) id <PrendasComposicionVCDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Prenda  *prenda; 
@property (nonatomic, strong) NSMutableArray *prendasArray; 
@property (nonatomic, strong) NSMutableDictionary *multipleSelectionDictionary; 
@property (nonatomic, assign) BOOL isMultiselection; 
@property (nonatomic, strong) UIPickerView	*myPickerView;
@property (nonatomic, strong) NSMutableArray *composicionArray;

@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *myActivity;
@property (nonatomic,strong) IBOutlet UINavigationBar *myNavigationBar;
@property (nonatomic,strong) IBOutlet UIImageView *myImageViewBackground;
@property (nonatomic,strong) IBOutlet UINavigationItem *myNavigationTitle;


-(IBAction) doneButton;
-(IBAction) cancelButton;
-(void) initCompositionArray;
-(NSInteger) getPickerRowForCompositionID:(NSInteger)compID;

@end

@protocol PrendasComposicionVCDelegate
- (void) dismissComposicionVC;
@end
