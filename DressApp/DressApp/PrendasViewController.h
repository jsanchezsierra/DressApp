//
//  PrendasViewController.h
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
#import "Prenda.h"
#import "PrendaDetailViewController.h"
#import "PrendasAlbumViewController.h"
#import "PreviewImagePicker.h"
#import "PortraitImagePickerController.h"

@protocol PrendasViewControllerDelegate;

typedef enum {
    PhotoTypeCamera,    
    PhotoTypeLibrary  
} CapturedPhotoType;

typedef enum {
    sortTypeMarca,    
    sortTypeCategoria,
    sortTypeFecha,
    sortTypePrecio,
    sortTypeTemporada,
    sortTypeComposicion
} SortTypeCriteria;


@interface PrendasViewController : UIViewController <UIImagePickerControllerDelegate,UIScrollViewDelegate,PrendaDetailVCDelegate,PrendasAlbumViewControllerDelegate, PreviewImagePickerDelegate, UITableViewDataSource,UITableViewDelegate>
{
    BOOL multipleSelectionEnabled;
    NSString *cachesDirectory;
    NSFileManager *fileManager;
    
    
    UIActivityIndicatorView *cameraActivityView;
    UISegmentedControl *cameraSegmentedControl;
    
    NSInteger numberOfTopViews;
    NSInteger currentTopView;
    
    CapturedPhotoType photoType;
    
    SortTypeCriteria sortType;
    BOOL sortViewHiddenState;
    BOOL isSortNeeded;
    BOOL ascending;
}


//Filter Views
@property (nonatomic,strong ) IBOutlet UIView *sortView;
@property (nonatomic,strong ) IBOutlet UITableView *sortTable;

@property (nonatomic,strong ) UIBarButtonItem *sortBarBtnItemShowNotes;
@property (nonatomic,strong ) UIBarButtonItem *sortBarBtnAscending;
@property (nonatomic,strong ) UILabel *sortLabel;


@property (nonatomic,strong ) IBOutlet UIView *leftLineView; 
@property (nonatomic, assign) BOOL didSelectRow;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *myActivityView;
@property (nonatomic, strong) IBOutlet UILabel  *labelParteArriba;
@property (nonatomic, strong) IBOutlet UILabel *labelParteAbajo;
@property (nonatomic, strong) IBOutlet UILabel *labelZapatos;
@property (nonatomic, strong) IBOutlet UILabel *labelComplementos;

//CoreData managedObjectContext
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) PrendasAlbumViewController *prendasAlbumVC;

//Data
@property (nonatomic, strong) NSMutableArray *prendasTopsArray;
@property (nonatomic, strong) NSMutableArray *prendasBottomsArray;
@property (nonatomic, strong) NSMutableArray *prendasShoesArray;
@property (nonatomic, strong) NSMutableArray *prendasAccesoriesArray;
@property (nonatomic, strong) NSMutableArray *multipleSelectionPrendasArray;

//IBOutlets UIButtons addPrendas
@property (nonatomic,strong ) IBOutlet UIButton *addTopPrenda;
@property (nonatomic,strong ) IBOutlet UIButton *addBottomPrenda;
@property (nonatomic,strong ) IBOutlet UIButton *addShoesPrenda;
@property (nonatomic,strong ) IBOutlet UIButton *addAccesoriesPrenda;

//UIImageViews for Strips
@property (nonatomic,strong ) IBOutlet UIImageView *strip1ImageView;
@property (nonatomic,strong ) IBOutlet UIImageView *strip2ImageView;
@property (nonatomic,strong ) IBOutlet UIImageView *strip3ImageView;
@property (nonatomic,strong ) IBOutlet UIImageView *strip4ImageView;

//UIImageViews for backgrounds
@property (nonatomic,strong ) IBOutlet UIImageView *strip1ForegroundImageView;
@property (nonatomic,strong ) IBOutlet UIImageView *strip2ForegroundImageView;
@property (nonatomic,strong ) IBOutlet UIImageView *strip3ForegroundImageView;
@property (nonatomic,strong ) IBOutlet UIImageView *strip4ForegroundImageView;


//Container View
@property (nonatomic, strong) IBOutlet UIView *containerView;

//UITableViews
@property (nonatomic, strong) IBOutlet UITableView *myTableViewTop;
@property (nonatomic, strong) IBOutlet UITableView *myTableViewBottom;
@property (nonatomic, strong) IBOutlet UITableView *myTableViewShoes;
@property (nonatomic, strong) IBOutlet UITableView *myTableViewAccesories;

//Delegate
@property (nonatomic, assign) id<MenuProtocolDelegate>delegate;

//Others
@property (nonatomic) BOOL isRight;
@property (nonatomic,strong) PrendaCategoria *myPrendaCategoria;

//ChoosingPrendaForConjunto
@property (nonatomic, assign) BOOL isChoosingPrendasForConjunto;
@property (nonatomic, strong) IBOutlet UIView *sideControlsView;
@property (nonatomic, strong) IBOutlet UINavigationBar *myNavigationBar;
@property (nonatomic, strong) IBOutlet UINavigationItem *myNavigationItem;
@property (nonatomic, strong) IBOutlet UIToolbar *mainToolbar;
@property (nonatomic, assign) id <PrendasViewControllerDelegate> delegateConjunto;

//Activity View
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) IBOutlet UIImageView *loadingImageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivityView;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;

//Camera View
@property (nonatomic,strong) PortraitImagePickerController *cameraImagePicker;
@property (nonatomic,strong) UIImageView *camaraPrendaView;

//own methods
-(void) popMainMenuViewController;
-(void) prendaRequest;
 -(void) updateScrollViews;
 
-(void)activateMultipleSelection;
-(void) multipleSelectionAceptar;
-(void) multipleSelectionCancelar;
-(IBAction)addPrenda:(UIButton*)myButton;
-(void)openAlbumWithCategory:(NSString*)currentCategoria andPrenda:(Prenda*)myPrenda;
-(UIImage*) createThumbnailFromImage:(UIImage*)imageToThumbnail withSize:(NSInteger)thumbnailSize;

-(void) changeToPrendasVC;
-(void) changeToConjuntosVC;
-(void) changeToCalendarVC;

-(void) openCamaraModalView: (UIButton*) myButton;

-(void) changeCameraSegmentedControl:(UISegmentedControl*)thisSegmentedControl;
-(void) changeCameraOverlayPicture :(NSInteger) selectedPrendaIndex;
-(void)addHeaderCenterView;

-(void) loadPreloadData;
-(void) createCoreDataMainTables;
-(void)createCoreDataDefaultPrendas;
- (void)loadScrollViewWithPage:(int)page;
- (void)unLoadScrollViewWithPage:(int)page;
-(void) openPhotoLibrary;

-(void) addAttributesToMarcas;
-(void) openFilterVC;
-(NSInteger) removeRestoreUnfinishedObjects;

-(void) initTableViewsTransform;
 -(void) refreshTableViews;
-(void) scrollTableViewsToBottom;
-(void) setToolbarItemsAll;
-(void) setToolbarItemsSort;
-(void) btnSortPressed;
-(void) btnSortShowNotesPressed;
-(IBAction) btnSortAscendingPressed;
-(void) setToolbarItemsForConjuntoAll;

@end

@protocol PrendasViewControllerDelegate

-(void) cancelChoosingPrendasForConjunto;
-(void) finishChoosingPrendasForConjunto:(NSMutableArray*)prendasForConjuntoArray;

@end