//
//  ConjuntoDetailViewController.h
//  DressApp
//
//  Created by Javier Sanchez Sierra on 11/1/11.
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
#import "Conjunto.h"
#import "ConjuntoPrendaView.h"
#import "PrendasViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ConjuntoDetailSetCategoriaVC.h"
#import "ConjuntoDetailNotes.h"
 
@protocol ConjuntoDetailVCDelegate;

@interface ConjuntoDetailViewController : UIViewController  <UIAlertViewDelegate,ConjuntoPrendaViewDelegate,PrendasViewControllerDelegate, UIActionSheetDelegate,ConjuntoDetailSetCategoriaVCDelegate, ConjuntoDetailNotesVCDelegate,UIAlertViewDelegate>
{
    NSString *cachesDirectory;
    NSFileManager *fileManager;
    ConjuntoPrendas * conjuntoPrendaToRemove;
    ConjuntoPrendaView * conjuntoPrendaViewToRemove;
    UIImageView *imageViewRemoveControl;
    UIImageView *imageViewMoveControl;
    UIImageView *imageViewScaleControl;
}


@property (nonatomic, assign) id <ConjuntoDetailVCDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) ConjuntoCategoria *categoria;
@property (nonatomic, strong) ConjuntoPrendaView* currentSelectedConjuntoPrendaView;
@property (nonatomic, strong) Conjunto *conjunto;
@property (nonatomic, assign) NSInteger currentConjuntoPage; 
@property (nonatomic, assign) BOOL isSaveNeededForDetail;
@property (nonatomic, strong) UIView *drawingView;
@property (nonatomic, strong) UIActionView *myActionViewMoveToTrash;
@property (nonatomic, strong) UIView *myNavigationViewBackground;

@property (nonatomic, strong) IBOutlet UIView *drawingViewControls;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewSlider;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewSliderFinger;


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withConjunto:(Conjunto*)tempConjunto andPage:(NSInteger)page;

-(void) addPrendasList;
-(void) crearConjuntoPrendas;
-(void) addConjuntoViews;
-(void) saveImageThumbnail;
-(IBAction)openActionSheet;
-(IBAction) setConjuntoCategoria;
-(IBAction) setNotesAndDates;
-(void) saveDataBeforeClosing;
-(void) removePrendaFromContainerView;
-(void) doNotRemovePrendaFromContainerView;
-(UIImage*) createThumbnailFromImage:(UIImage*)imageToThumbnail withSize:(NSInteger)thumbnailSize;

@end


@protocol ConjuntoDetailVCDelegate

-(void) updateConjuntoDetailContainerView;
-(void) enableScrollInContainerView:(BOOL)scrollEnabled;
-(IBAction) moveToTrash :(UIBarButtonItem*) barButton;
-(void) moveConjuntoPrendaToTrash;
-(void) activateCalendarViewFlag;

@end
