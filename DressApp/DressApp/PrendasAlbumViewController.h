//
//  PrendasAlbumViewController.h
//  DressApp
//
//  Created by Javier Sanchez Sierra on 11/28/11.
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


#import <Foundation/Foundation.h>
#import "Prenda.h"
#import "PrendaCategoriasViewController.h"
#import "PrendasMisMarcasViewController.h"
#import "PrendaDetailViewController.h"
#import "UIActionView.h"
#import "PrendaEstado.h"
#import "PrendasTallaViewController.h"
#import "PrendasComposicionViewController.h"
#import "PrendasFechaViewController.h"
#import "PrendaSubCategoria.h"
#import <MessageUI/MessageUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ShareFacebookTwitter.h"
#import "ConjuntoPrendas.h"
#import "PrendasPrecioViewController.h"
#import "ConjuntoHistoricoRemove.h"

@protocol PrendasAlbumViewControllerDelegate;

@interface PrendasAlbumViewController : UIViewController <UIScrollViewDelegate,PrendaCategoriasVCDelegate,PrendasMisMarcasVCDelegate,PrendaDetailVCDelegate,UIActionSheetDelegate, UIActionViewDelegate,PrendasTallaVCDelegate, PrendasComposicionVCDelegate,PrendasFechaVCDelegate,MFMailComposeViewControllerDelegate, ShareFacebookTwitterDelegate,PrendasPrecioVCDelegate>
{       
    NSInteger numberOfPages;
    NSString *cachesDirectory;
    NSFileManager *fileManager;
    BOOL isAnyActionViewOpened;
    NSString *nullString;
}

@property (nonatomic, assign) id <PrendasAlbumViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *prendasArray;
@property (nonatomic, strong) Prenda *currentPrenda; 

//HEADER CONTROLS
@property (nonatomic, strong) UIButton *myBackButton;
@property (nonatomic, strong) UILabel *titleLabel;

//IBOUTLETS
@property (nonatomic, strong) IBOutlet UIToolbar *myToolBar;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *myViewActivity;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *myActionViewActivity;
@property (nonatomic, strong) IBOutlet UIButton *btnNotas;
@property (nonatomic, strong) IBOutlet UIButton *btnCategoria;
@property (nonatomic, strong) IBOutlet UIButton *btnTrash;
@property (nonatomic, strong) IBOutlet UIButton *btnCompartir;


//UIActionView
@property (nonatomic, strong) UIActionView *myActionViewCompartir;
@property (nonatomic, strong) UIActionView *myActionViewDisponibilidad;
@property (nonatomic, strong) UIActionView *myActionViewMoveToTrash;
@property (nonatomic, strong) UIActionView *myActionViewSetCategoria;
@property (nonatomic, strong) UIView *myNavigationViewBackground;


@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic, assign) BOOL isMultiselection; 
@property (nonatomic, assign) BOOL isfullScreen;

@property (nonatomic, assign) NSInteger currentPage; 
@property (nonatomic, strong) NSMutableDictionary *multipleSelectionDictionary; 

- (void)loadScrollViewWithPage:(int)page;
- (void)unLoadScrollViewWithPage:(int)page;
-(void)changeSubcategoria:(UIBarButtonItem*)sender;
-(IBAction)changeMarca:(UIButton*)sender;
-(IBAction)openActionSheet;
-(IBAction)openMoveToTrashActionSheet;
-(void) loadUnloadViews;
-(void) moveCurrentPrendaToTrash;
-(void) accessFacebookAPIForPostingPrendaImage;
-(void) accessFacebookFailed;
-(void) sendPrendaToEmail;
-(void) sendPrendaToFacebook;
-(void) sendPrendaToTwitter;
-(void) savePrendaToLibrary;
-(NSString *) getUrlEncoded:(NSString*)inputString;
-(void) updateConjuntosImageWhenThisPrendaIsMovedToTrash:(Prenda*)thisPrenda;
-(UIImage*) createThumbnailFromImage:(UIImage*)imageToThumbnail withSize:(NSInteger)thumbnailSize;
-(void) logPrendas;
-(IBAction)btnPressed:(UIButton*)sender;
-(void) openSubcategoryModalView;
-(void) addNewPrenda;

@end

@protocol PrendasAlbumViewControllerDelegate
    -(void) prendasArrayAlbumVCDidFinish;
    -(void) prendaDetailVCDeletePrenda:(Prenda*)prenda;
    -(void) addNewPrendaWithCategory:(NSString*)categ;
    -(void) updateScrollViewsFromPrendaDetailAlbum;
@end