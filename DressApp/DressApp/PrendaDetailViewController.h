//
//  PrendaDetailViewController.h
//  DressApp
//
//  Created by Javier Sanchez Sierra on 10/25/11.
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
#import "Prenda.h"
#import "PrendaCategoriasViewController.h"
#import "PrendaCategoria.h"
#import "ConjuntoPrendas.h"
#import "Conjunto.h"
#import "CalendarConjunto.h"
#import <QuartzCore/QuartzCore.h>

@protocol PrendaDetailVCDelegate;

typedef enum {
    PrendaTemporadaInvierno=0 ,    
    PrendaTemporadaPrimavera=1 ,
    PrendaTemporadaVerano=2 ,
    PrendaTemporadaOtono=3,
    PrendaTemporadaNO=4,
} Temporada;


typedef enum {
    PrendaDisponibilidadDisponible=0 ,    
    PrendaDisponibilidadPrestada=1 ,
    PrendaDisponibilidadDeseo=2 ,
    PrendaDisponibilidadColada=3,
    PrendaDisponibilidadNO=4,
} Disponibilidad;



@interface PrendaDetailViewController : UIViewController <UIImagePickerControllerDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate, PrendaCategoriasVCDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource >
{
    IBOutlet UIActivityIndicatorView *myViewActivity;
    UIAlertView *alertViewMoveToTrash;
    NSString *cachesDirectory;
    NSFileManager *fileManager;
    BOOL isUpdatingToFullScreen;
    NSString *nullString;
    Disponibilidad currentDisponibilidadState;
    NSArray *tallas1;
    NSArray *tallas2;
    BOOL isTemporadaChanging;
    NSInteger rowHeight;
}


//Details View
@property (nonatomic,strong) IBOutlet UIView *mainView;
@property (nonatomic,strong) IBOutlet UIImageView *myBackgroundImage;
@property (nonatomic,strong) IBOutlet UIImageView *myMarcoImage;
@property (nonatomic,strong) IBOutlet UIImageView *myMarcoImageDetail;
@property (nonatomic,strong) IBOutlet UIButton *myEtiquetaBtn;
@property (nonatomic,strong) IBOutlet UIButton *myPrecioBtn;
@property (nonatomic,strong) IBOutlet UILabel *precioLabel;

@property (nonatomic, assign) id <PrendaDetailVCDelegate> delegate;

@property (nonatomic, assign) BOOL isFullScreen;

//details view
@property (nonatomic,strong) IBOutlet UIView *detailsView;
@property (nonatomic,strong) IBOutlet UIImageView *myImageView;
@property (nonatomic,strong) IBOutlet UIScrollView *myScrollViewBackground;
@property (nonatomic,strong) IBOutlet UIButton *myBtnZoom;
@property (nonatomic,strong) IBOutlet UIButton *myBtnImageZoom;
@property (nonatomic,strong) IBOutlet UIButton *BtnCategoria;


@property (nonatomic,strong) IBOutlet UIButton *BtnMarca;
@property (nonatomic,strong) UILabel *marcaLabel;



@property (nonatomic, strong) IBOutlet UIImageView *imageViewSlider;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewSliderFinger;

//Boton Temporada
@property (nonatomic,strong) IBOutlet UILabel *tempTitle;


//Temporada View
@property (nonatomic,strong) IBOutlet UIButton *BtnInvierno;
@property (nonatomic,strong) IBOutlet UIButton *BtnPrimavera;
@property (nonatomic,strong) IBOutlet UIButton *BtnVerano;
@property (nonatomic,strong) IBOutlet UIButton *BtnOtono;


//Etiqueta View
@property (nonatomic,strong) IBOutlet UIView *etiquetaView;
@property (nonatomic,strong) IBOutlet UIImageView *etiquetaImageView;
@property (nonatomic,strong) IBOutlet UIButton *etiquetasCloseView;
@property (nonatomic,strong) IBOutlet UILabel *etiqTiendaTitle;
@property (nonatomic,strong) IBOutlet UILabel *etiqTiendaValue;
@property (nonatomic,strong) IBOutlet UILabel *etiqTallaTitle;
@property (nonatomic,strong) IBOutlet UILabel *etiqTallaValue;
@property (nonatomic,strong) IBOutlet UILabel *etiqColorTitle;
@property (nonatomic,strong) IBOutlet UITextField *etiqColorTextField;
@property (nonatomic,strong) IBOutlet UILabel *etiqComposicionTitle;
@property (nonatomic,strong) IBOutlet UILabel *etiqComposicionValue;
@property (nonatomic,strong) IBOutlet UIScrollView *myScrollViewEtiqueta;

//Notes View
@property (nonatomic,strong) IBOutlet UIView *notesView;
@property (nonatomic,strong) IBOutlet UILabel *notesViewTitle;
@property (nonatomic,strong) IBOutlet UIImageView *notesImageView;
@property (nonatomic,strong) IBOutlet UIButton *notesCloseView;
@property (nonatomic,strong) IBOutlet UILabel *notesNotasTitle;
@property (nonatomic,strong) IBOutlet UITextField *notesTextField;
@property (nonatomic,strong) IBOutlet UILabel *notesEstadoTitle;
@property (nonatomic,strong) IBOutlet UIScrollView *myNotesScrollView;
@property (nonatomic,strong) IBOutlet UILabel *notesDatesUsed;
@property (nonatomic, strong) IBOutlet UITableView *notesTableView;
@property (nonatomic, strong)  NSMutableArray *datesUsedArray;

@property (nonatomic,strong) IBOutlet UIButton *BtnDisponibilidad;
@property (nonatomic,strong)  UILabel *disponibilidadLabel;


@property (nonatomic,strong) IBOutlet UIImageView *notasImageViewLine1;


@property (nonatomic,strong) IBOutlet UIImageView *miEtiquetaImageViewLine1;
@property (nonatomic,strong) IBOutlet UIImageView *miEtiquetaImageViewLine2;
@property (nonatomic,strong) IBOutlet UIImageView *miEtiquetaImageViewLine3;
@property (nonatomic,strong) IBOutlet UIImageView *miEtiquetaImageViewLine4;


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Prenda *prenda; 
@property (nonatomic, strong) PrendaCategoria *prendaCategoria; 
@property (nonatomic, assign) BOOL isMultiselection; 
@property (nonatomic, assign) NSInteger currentPrendaPage; 
@property (nonatomic, strong) NSMutableArray *prendasArray; 
@property (nonatomic, strong) NSMutableDictionary *multipleSelectionDictionary; 


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPrendasArray:(NSMutableArray*)tempPrendasArray andPage:(NSInteger)page;
 
- (void) updateLabels;
- (void) updateMultipleSelectionLabelsWithDictionary;
- (IBAction) swithToFullScreen;
- (void)finishSwitchToFullScreen:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context; 
-(void) ImageViewHasChangedToFullScreen;
-(void) ImageViewHasChangedFromFullScreen;
-(IBAction)btnEtiquetaPressed;
-(IBAction)btnEtiquetaClosePressed;
-(IBAction)btnNotesPressed;
-(IBAction)btnNotesClosePressed;
-(void) activateView:(UIView*)thisView andShow:(BOOL)activateView;

//-(IBAction)btnTemporadaPressed;
//-(IBAction)btnTemporadaClosePressed;
-(IBAction)changeBtnTemporada:(UIButton*)sender;
-(void) selectBtnTemporada:(NSInteger) temporadaIndex;

-(void) setDisponibilidadLabelForIndex:(NSInteger) disponibilidadIndex;

-(void) checkMultiselectionFields;


-(void) openCompartirAction;
-(void) openDisponibilidadAction;
-(IBAction)openCategoriaModalView;
-(IBAction)openSubcategoriaModalView;
-(IBAction)openMarcaModalView;
-(IBAction)openTallaModalView;
-(IBAction)openComposicionModalView;
-(IBAction)openFechaModalView;
-(void) updateAllInDetailsVC;
-(void) textFieldUpdate:(UITextField *)textField;
-(void)btnNotesPressed;
-(void) fetchDatesUsed;
-(IBAction)btnPrecioPressed;


@end

@protocol PrendaDetailVCDelegate

-(void) changeImageViewToFullScreen:(BOOL)isFullScreen;
-(void) openMarcasModalView;
-(void) openTallasModalView;
-(void) openComposicionModalView;
-(void) openPrecioModalView;
-(void) openFechaModalView;
-(void) openDisponibilidadActionWithSelectedIndex:(NSInteger)selectedIndex;
-(void) openCategoryActionWithSelectedIndex:(NSInteger)selectedIndex;
-(void) enableToolBarButtons:(BOOL)showButtons;
-(void) updateScrollViewsFromPrendaDetail;
 @end
