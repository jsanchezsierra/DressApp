//
//  PrendasAlbumViewController.m
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


#import "PrendasAlbumViewController.h"
#import "StyleDressApp.h"
#import "AppDelegate.h"
#import "ShareFacebookTwitter.h"
#import "PrendaHistoricoRemove.h"
#import "Conjunto.h"
#import "Authenticacion.h"

@implementation PrendasAlbumViewController
@synthesize scrollView,viewControllers;
@synthesize prendasArray,managedObjectContext,delegate;
@synthesize isMultiselection,multipleSelectionDictionary;
@synthesize currentPage,currentPrenda;
@synthesize isfullScreen;
@synthesize myViewActivity;
@synthesize btnNotas,btnTrash,btnCompartir,btnCategoria;
@synthesize titleLabel;
@synthesize myActionViewCompartir,myActionViewDisponibilidad,myActionViewMoveToTrash,myNavigationViewBackground,myActionViewSetCategoria;
@synthesize myActionViewActivity,myToolBar;
@synthesize myBackButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.isfullScreen=NO;
    }
    return self;
}



#pragma mark - View lifecycle
- (void)viewDidLoad
{
     
    nullString=@"-------";

    numberOfPages= [prendasArray count];
    if (isMultiselection)
        numberOfPages=1;
    
    NSInteger counter= [[[NSUserDefaults standardUserDefaults] objectForKey:@"showPrendasSliderCounter"] intValue];
    if ( counter>0 && numberOfPages>1 )
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"showPrendasSlider"];
        [ [NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:counter-1] forKey:@"showPrendasSliderCounter" ];
    }
    
    isAnyActionViewOpened=NO;
    [myActionViewActivity stopAnimating];
    self.currentPrenda=[prendasArray objectAtIndex:currentPage]; 

    //Prepare file manager && cachesDirectory
    cachesDirectory= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    fileManager = [NSFileManager defaultManager];

    
    [myToolBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainToolBar]];
    [self.view  setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRDetailBackground]];
    [self.scrollView  setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRDetailBackground]];


    UIBarButtonItem *righBarButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPrenda)];
    self.navigationItem.rightBarButtonItem = righBarButton; 

    //Set font for tittle
    UIFont *myFontTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:24];
    //set title
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 200,44)];
    [titleLabel setFont:myFontTitle];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRDetailHeader]];
    if (isMultiselection) 
        [titleLabel setText:[NSString stringWithFormat:@"%@",  NSLocalizedString(@"MultiplesPrendas", @"")] ];
    else
        [titleLabel setText:[NSString stringWithFormat:@"%@ %d %@ %d",  NSLocalizedString(@"Prenda", @""),currentPage+1, NSLocalizedString(@"de", @""),numberOfPages] ];
    [self.navigationItem setTitleView:titleLabel];

        
    //Create buttons toolbar
    UILabel *btnCategoriaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 33)];
    [btnCategoriaLabel setBackgroundColor:[UIColor clearColor]];
    [btnCategoriaLabel setTextAlignment:UITextAlignmentCenter];
    [btnCategoriaLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontBottomBtns AndSize:12]];
    [self.btnCategoria addSubview:btnCategoriaLabel];
    
    
    UILabel *btnNotasLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 33)];
    [btnNotasLabel setBackgroundColor:[UIColor clearColor]];
    [btnNotasLabel setTextAlignment:UITextAlignmentCenter];
    [btnNotasLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontBottomBtns AndSize:12]];
    [self.btnNotas addSubview:btnNotasLabel];
    
    
    UILabel *btnCompartirLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 33)];
    [btnCompartirLabel setBackgroundColor:[UIColor clearColor]];
    [btnCompartirLabel setTextAlignment:UITextAlignmentCenter];
    [btnCompartirLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontBottomBtns AndSize:12]];
    [self.btnCompartir addSubview:btnCompartirLabel];
    
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        [btnCategoriaLabel setText:NSLocalizedString(@"ConjuntoCategoria",@"")];
        [btnNotasLabel setText:NSLocalizedString(@"ConjuntoNotas",@"")];
        [btnCompartirLabel setText:NSLocalizedString(@"ConjuntoCompartir",@"")];
        
        //Self toolbar buttons images
        [self.btnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"CODetailBtnOFF" ] forState:UIControlStateNormal]; 
        
        [self.btnNotas setImage:[StyleDressApp imageWithStyleNamed:@"CODetailBtnOFF" ] forState:UIControlStateNormal]; 
        [self.btnTrash setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailBtnTrashOFF" ] forState:UIControlStateNormal]; 
        
        [self.btnCompartir setImage:[StyleDressApp imageWithStyleNamed:@"CODetailBtnOFF" ] forState:UIControlStateNormal]; 
    }else  if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        
        [btnCategoriaLabel setText:@""];
        [btnNotasLabel setText:@""];
        [btnCompartirLabel setText:@""];
        
        //Self toolbar buttons images
        [self.btnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailBtnCatOFF" ] forState:UIControlStateNormal]; 
        [self.btnNotas setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailBtnNotesOFF" ] forState:UIControlStateNormal]; 
        [self.btnTrash setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailBtnTrashOFF" ] forState:UIControlStateNormal]; 
        [self.btnCompartir setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailBtnShareOFF" ] forState:UIControlStateNormal]; 
    }
    
    self.multipleSelectionDictionary= [ [NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"", @"multipleCategoria",
                                       @"", @"multipleSubCategoria",
                                       @"", @"multipleMarca",
                                       @"", @"multipleColor",
                                       @"", @"multipleTienda",
                                       @"", @"multipleTemporada",
                                       @"", @"multipleRating",
                                       @"", @"multipleRating",
                                       @"", @"multipleTalla1",
                                       @"", @"multipleTalla2",
                                       @"", @"multipleTalla3",
                                       @"", @"multiplePrecio",
                                       @"", @"multipleEstado",
                                       @"", @"multipleComposicion",
                                       @"", @"multipleNotas",
                                       @"", @"multipleTag1",
                                       @"", @"multipleTag2",
                                       @"", @"multipleTag3",
                                       @"", @"multipleFecha",
                                       nil];
    @autoreleasepool 
    {
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        for (unsigned i = 0; i < numberOfPages; i++)
            [controllers addObject:[NSNull null]];
        self.viewControllers = controllers;
    }
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numberOfPages, 371);
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
 
    //load and unload new Views
    [self performSelector:@selector(loadUnloadViews) withObject:nil afterDelay:0.01];
    [self.scrollView setContentOffset:CGPointMake( scrollView.frame.size.width * currentPage, 0)];
 
 }
 


-(void) changeImageViewToFullScreen:(BOOL)isImageViewFullScreen
{
    self.isfullScreen=isImageViewFullScreen;
    for (PrendaDetailViewController *tempVC in viewControllers) 
    {
        if (![(NSNull *)tempVC isKindOfClass:[NSNull class] ])
        {
            if (self.isfullScreen) 
                [tempVC ImageViewHasChangedToFullScreen];
            else
                [tempVC ImageViewHasChangedFromFullScreen];
        }
    }
}


-(void) addNewPrenda
{
    [self.delegate addNewPrendaWithCategory:currentPrenda.categoria.idCategoria];    
}



#pragma mark - UIScrollViewDelegate methods

-(void) scrollViewDidScroll:(UIScrollView *)thisScrollView
{

    CGFloat pageWidth = thisScrollView.frame.size.width;
    int page = floor((thisScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page < 0 || page >= numberOfPages)
        return;

    currentPage=page;
    
    //update title
    if (isMultiselection) 
        [titleLabel setText:[NSString stringWithFormat:@"%@",  NSLocalizedString(@"MultiplesPrendas", @"")] ];
    else
        [titleLabel setText:[NSString stringWithFormat:@"%@ %d %@ %d",  NSLocalizedString(@"Prenda", @""),currentPage+1, NSLocalizedString(@"de", @""),numberOfPages] ];
    
    //change UIActivityIndicatorView frame position 
    self.myViewActivity.frame=CGRectMake(pageWidth*page + pageWidth/2,170, 20,20);
    [myViewActivity startAnimating];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)thisScrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page < 0 || page >= numberOfPages)
        return;

    currentPage=page;
    self.currentPrenda=[prendasArray objectAtIndex:currentPage]; 
    
    //load and unload new Views
    [self performSelector:@selector(loadUnloadViews) withObject:nil afterDelay:0.01];
    
}

-(void) loadUnloadViews
{
    [self unLoadScrollViewWithPage:currentPage-2];
    [self loadScrollViewWithPage:currentPage-1];
    [self loadScrollViewWithPage:currentPage];
    [self loadScrollViewWithPage:currentPage+1];
    [self unLoadScrollViewWithPage:currentPage+2];    

    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numberOfPages, 371);
    scrollView.frame = CGRectMake(0,0,320,372);
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    [self.scrollView setContentOffset:CGPointMake( scrollView.frame.size.width * currentPage, 0)];


}


#pragma mark - load ViewControllers
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0 || page >= numberOfPages)
        return;

    // replace the placeholder if necessary
    PrendaDetailViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[PrendaDetailViewController alloc] initWithNibName:@"PrendaDetailViewController" bundle:[NSBundle mainBundle] withPrendasArray:prendasArray andPage:page  ];
        controller.isMultiselection=isMultiselection;
        controller.managedObjectContext=self.managedObjectContext;
        controller.multipleSelectionDictionary=multipleSelectionDictionary;
        controller.isFullScreen=self.isfullScreen;
        controller.view.tag=page;
        controller.delegate=self;
      [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view if it doesn't exist
    if (controller.view.superview == nil)
    {
        CGRect frame = CGRectMake(0, 0, 320, 416); //scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }else
    {
        if ( ![ [ [viewControllers objectAtIndex:page] etiquetaView] isHidden] )
            [ [viewControllers objectAtIndex:page] btnEtiquetaClosePressed];
        if ( ![ [ [viewControllers objectAtIndex:page] notesView] isHidden] )
            [[viewControllers objectAtIndex:page] btnNotesClosePressed];
    }
    
}


- (void)unLoadScrollViewWithPage:(int)page
{
    if (page < 0 || page >= numberOfPages)
        return;
    
    //Elimino el controlador del array de controladores
    [viewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
    
    //Elimino la vista de scrollView
    for (int i=0; i<[self.scrollView.subviews count];i++  ) 
    {
        if ([[self.scrollView.subviews objectAtIndex:i] tag]==page) 
            [[self.scrollView.subviews objectAtIndex:i] removeFromSuperview];
    }
    
}


-(IBAction)btnPressed:(UIButton*)sender
{
    if (sender==btnCategoria) 
        [self openSubcategoryModalView];
    else if (sender==btnNotas) 
        [[viewControllers objectAtIndex:currentPage] btnNotesPressed];
    else if (sender==btnTrash) 
        [self openMoveToTrashActionSheet];
    else if (sender==btnCompartir) 
      [self openActionSheet];
    
}



#pragma mark - enableToolBarButtons 
-(void) enableToolBarButtons:(BOOL)showButtons;
{
    
    [self.btnCategoria setEnabled:showButtons];
    [self.btnNotas setEnabled:showButtons];
    [self.btnTrash setEnabled:showButtons];
    [self.btnCompartir setEnabled:showButtons];
    
    [self.navigationItem.rightBarButtonItem setEnabled:showButtons];

    if (showButtons) 
    {
        UIBarButtonItem *leftBarButton = [  [UIBarButtonItem alloc] initWithCustomView:myBackButton ];
        self.navigationItem.leftBarButtonItem= leftBarButton; 
    }else
    {
        UIView *emptyView = [  [UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) ];
        UIBarButtonItem *leftBarButton = [  [UIBarButtonItem alloc] initWithCustomView:emptyView ];
        self.navigationItem.leftBarButtonItem= leftBarButton; 

    }
 }


#pragma mark - change properties

-(void) openSubcategoryModalView
{

    if ( [[viewControllers objectAtIndex:currentPage] isMultiselection] ) 
    {
        if (! [[[[viewControllers objectAtIndex:currentPage] multipleSelectionDictionary] objectForKey:@"multipleCategoria"] isEqualToString:nullString]) 
        [self changeSubcategoria:nil];
    }else
        [self changeSubcategoria:nil];

}

-(void) openMarcasModalView
{
    [self changeMarca:nil];
}


#pragma mark - Tallas VC

-(void) openTallasModalView
{
    PrendasTallaViewController *newVC= [[PrendasTallaViewController alloc] initWithNibName:@"PrendasTallaViewController" bundle:[NSBundle mainBundle]];
    newVC.prenda=currentPrenda;
    newVC.isMultiselection=isMultiselection;
    newVC.multipleSelectionDictionary=multipleSelectionDictionary;
    newVC.prendasArray=prendasArray;                      
    newVC.delegate=self;
    newVC.managedObjectContext=self.managedObjectContext;
    [self presentModalViewController:newVC animated:YES];

}

-(void) dismissTallasVC
{
    if (isMultiselection)
        [[viewControllers objectAtIndex:currentPage] checkMultiselectionFields ];
    else
        [[viewControllers objectAtIndex:currentPage] updateLabels ];
    
    [self dismissModalViewControllerAnimated:YES];

    //update ScrollView on Main PrendaViewController
    [self.delegate updateScrollViewsFromPrendaDetailAlbum];

}


#pragma mark - Precio VC

-(void) openPrecioModalView
{
    PrendasPrecioViewController *newVC= [[PrendasPrecioViewController alloc] initWithNibName:@"PrendasPrecioViewController" bundle:[NSBundle mainBundle]];
    newVC.prenda=currentPrenda;
    newVC.isMultiselection=isMultiselection;
    newVC.multipleSelectionDictionary=multipleSelectionDictionary;
    newVC.prendasArray=prendasArray;                      
    newVC.delegate=self;
    newVC.managedObjectContext=self.managedObjectContext;
    [self presentModalViewController:newVC animated:YES];
    
}


-(void) dismissPrecioVC
{
    if (isMultiselection)
        [[viewControllers objectAtIndex:currentPage] checkMultiselectionFields ];
    else
        [[viewControllers objectAtIndex:currentPage] updateLabels ];
    
    [self dismissModalViewControllerAnimated:YES];

    //update ScrollView on Main PrendaViewController
    [self.delegate updateScrollViewsFromPrendaDetailAlbum];

}


#pragma mark - Composicion VC

-(void) openComposicionModalView
{
    PrendasComposicionViewController *newVC= [[PrendasComposicionViewController alloc] initWithNibName:@"PrendasComposicionViewController" bundle:[NSBundle mainBundle]];
    newVC.prenda=currentPrenda;
    newVC.isMultiselection=isMultiselection;
    newVC.multipleSelectionDictionary=multipleSelectionDictionary;
    newVC.prendasArray=prendasArray;                      
    newVC.delegate=self;
    newVC.managedObjectContext=self.managedObjectContext;
    [self presentModalViewController:newVC animated:YES];

}



-(void) dismissComposicionVC
{
    if (isMultiselection)
        [[viewControllers objectAtIndex:currentPage] checkMultiselectionFields ];
    else
        [[viewControllers objectAtIndex:currentPage] updateLabels ];
    
    [self dismissModalViewControllerAnimated:YES];
  
    //update ScrollView on Main PrendaViewController
    [self.delegate updateScrollViewsFromPrendaDetailAlbum];

}

#pragma mark - Fecha VC

-(void) openFechaModalView
{
    PrendasFechaViewController *newVC= [[PrendasFechaViewController alloc] initWithNibName:@"PrendasFechaViewController" bundle:[NSBundle mainBundle]];
    newVC.prenda=currentPrenda;
    newVC.isMultiselection=isMultiselection;
    newVC.multipleSelectionDictionary=multipleSelectionDictionary;
    newVC.prendasArray=prendasArray;                      
    newVC.delegate=self;
    newVC.isViewOpenedFromProfile=NO;
    newVC.managedObjectContext=self.managedObjectContext;
    [self presentModalViewController:newVC animated:YES];

}

-(void) dismissFechaVC
{
    if (isMultiselection)
        [[viewControllers objectAtIndex:currentPage] checkMultiselectionFields ];
    else
        [[viewControllers objectAtIndex:currentPage] updateLabels ];
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - UIActionSheet Categoria View

-(void) openCategoryActionWithSelectedIndex:(NSInteger)selectedIndex
{
    if (isAnyActionViewOpened==NO) 
    {
        isAnyActionViewOpened=YES;
        //Cancel userInteraction
        [scrollView setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        
        //Open ActionView
        self.myActionViewSetCategoria = [[UIActionView alloc] initWithFrame:CGRectMake(0,480,320,416)];
        [self.myActionViewSetCategoria setMyFontSize:20];
        [self.myActionViewSetCategoria setDelegate:self];
        [self.myActionViewSetCategoria setButtonsTextArray:[NSMutableArray arrayWithObjects:NSLocalizedString(@"categoria1", @""),  NSLocalizedString(@"categoria2", @""),NSLocalizedString(@"categoria3", @""),NSLocalizedString(@"categoria4", @""),NSLocalizedString(@"cancelar", @""), nil]];
        [self.myActionViewSetCategoria setSelectedIndex:selectedIndex];
        [self.myActionViewSetCategoria setActionViewTitle: NSLocalizedString(@"categoriaActionTitle", @"")];
        [self.myActionViewSetCategoria initView];
        [self.view addSubview:myActionViewSetCategoria];
        
        //Add background view - opaque view para que el fondo quede oscuro al abrir el actionView
        myNavigationViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -44,320,44)];
        [myNavigationViewBackground setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:myNavigationViewBackground];
    }
 
}




#pragma mark - UIActionSheet Disponibilidad View

-(void) openDisponibilidadActionWithSelectedIndex:(NSInteger)selectedIndex
{
    if (isAnyActionViewOpened==NO) 
    {
        isAnyActionViewOpened=YES;

        //Cancel userInteraction
        [scrollView setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        
        //Open ActionView
        self.myActionViewDisponibilidad = [[UIActionView alloc] initWithFrame:CGRectMake(0,480,320,416)];
        [self.myActionViewDisponibilidad setMyFontSize:20];
        [self.myActionViewDisponibilidad setDelegate:self];
        [self.myActionViewDisponibilidad setButtonsTextArray:[NSMutableArray arrayWithObjects:NSLocalizedString(@"btnDisponibilidadDisponible", @""),  NSLocalizedString(@"btnDisponibilidadPrestada", @""),NSLocalizedString(@"btnDisponibilidadDeseo", @""),NSLocalizedString(@"btnDisponibilidadColada", @""),NSLocalizedString(@"btnCancel", @""), nil]];
        [self.myActionViewDisponibilidad setSelectedIndex:selectedIndex];
        [self.myActionViewDisponibilidad setActionViewTitle: NSLocalizedString(@"disponibilidadActionTitle", @"")];
        [self.myActionViewDisponibilidad initView];
        [self.view addSubview:myActionViewDisponibilidad];
        
        //Add background view - opaque view para que el fondo quede oscuro al abrir el actionView
        myNavigationViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -44,320,44)];
        [myNavigationViewBackground setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:myNavigationViewBackground];
        
    }
    
}

#pragma mark - UIActionSheet Compartir View
- (void)openActionSheet
{
     
    if (isAnyActionViewOpened==NO && ![[viewControllers objectAtIndex:currentPage] isMultiselection]) 
    {
        isAnyActionViewOpened=YES;

        //Cancel userInteraction
        [scrollView setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        
        //Open ActionView
        self.myActionViewCompartir = [[UIActionView alloc] initWithFrame:CGRectMake(0,480,320,416)];
        [self.myActionViewCompartir setMyFontSize:20];
        [self.myActionViewCompartir setDelegate:self];
        [self.myActionViewCompartir setButtonsTextArray:[NSMutableArray arrayWithObjects:NSLocalizedString(@"saveToAlbum", @""),  NSLocalizedString(@"facebook", @""), NSLocalizedString(@"twitter", @""),NSLocalizedString(@"email", @""), NSLocalizedString(@"cancelar", @""),  nil]];
        [self.myActionViewCompartir setSelectedIndex:4];
        [self.myActionViewCompartir setActionViewTitle: NSLocalizedString(@"actionViewConjuntoTitle", @"")];
        [self.myActionViewCompartir initView];
        [self.view addSubview:myActionViewCompartir];
        
        //Add background view - opaque view para que el fondo quede oscuro al abrir el actionView
        myNavigationViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -44,320,44)];
        [myNavigationViewBackground setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:myNavigationViewBackground];

    }    
}


- (void)openMoveToTrashActionSheet
{
    if (isAnyActionViewOpened==NO) 
    {
        isAnyActionViewOpened=YES;
        
        //Cancel userInteraction
        [scrollView setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        
        //Open ActionView
        self.myActionViewMoveToTrash = [[UIActionView alloc] initWithFrame:CGRectMake(0,480,320,416)];
        [self.myActionViewMoveToTrash setDelegate:self];
        [self.myActionViewMoveToTrash setButtonsTextArray:[NSMutableArray arrayWithObjects:NSLocalizedString(@"SI", @""),  NSLocalizedString(@"NO", @"") , nil]];
        [self.myActionViewMoveToTrash setSelectedIndex:1];
        
        if (isMultiselection) 
        {
            //chequeo si alguna de las prendas a borrar está asociada a algún conjunto, así aviso al usuario
            BOOL anyPrendaWithConjunto=NO;
            for (Prenda *thisPrenda in prendasArray)
                if ([thisPrenda.conjuntoPrenda count]>0)
                    anyPrendaWithConjunto=YES;
            
            if (anyPrendaWithConjunto==YES) 
            {
                [self.myActionViewMoveToTrash setMyFontSize:17];
                [self.myActionViewMoveToTrash setActionViewTitle: NSLocalizedString(@"MoveItemsToTrashMsgWithWarning", @"")];
            }else
            {
                [self.myActionViewMoveToTrash setMyFontSize:20];
                [self.myActionViewMoveToTrash setActionViewTitle: NSLocalizedString(@"MoveItemsToTrashMsg", @"")];
            }   
        }else
        {
            //chequeo si la prenda a borrar está asociada a algún conjunto, así aviso al usuario
            if ([currentPrenda.conjuntoPrenda count]>0) 
            {
                [self.myActionViewMoveToTrash setMyFontSize:17];
                [self.myActionViewMoveToTrash setActionViewTitle: NSLocalizedString(@"MoveItemToTrashMsgWithWarning", @"")];
            }else
            {
                [self.myActionViewMoveToTrash setMyFontSize:20];
                [self.myActionViewMoveToTrash setActionViewTitle: NSLocalizedString(@"MoveItemToTrashMsg", @"")];
            }
        }
        
        [self.myActionViewMoveToTrash initView];
        [self.view addSubview:myActionViewMoveToTrash];
        
        myNavigationViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -44,320,44)];
        [myNavigationViewBackground setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:myNavigationViewBackground];
    }      
}




#pragma mark - actionView delegate methods

-(void) actionView:(UIActionView *)actionView didSelectIndex:(NSInteger)actionIndex
{
    isAnyActionViewOpened=NO;
    
    //Remove views from superview
    [actionView removeFromSuperview];
    [self.myNavigationViewBackground removeFromSuperview];
    
    //User interaction enabled
    [scrollView setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    
    if (actionView==myActionViewCompartir) //Do album, facebook, etc,etc
    {
     
        if (actionIndex==0)  // guardar en album
            [self savePrendaToLibrary];
        else if(actionIndex==1)  //Facebook
            [self sendPrendaToFacebook];  //using authorization dialog
        else if(actionIndex==2)  //Twitter
            [self sendPrendaToTwitter];
        else if(actionIndex==3)  //Email
            [self sendPrendaToEmail];
        
    }
    else if (actionView==myActionViewDisponibilidad )  //acepto cambio de disponibilidad
    {
     
        if (actionIndex<4) //El cancelar se queda como está
        {
            
            NSFetchRequest *requestEstado = [[NSFetchRequest alloc] init];
            [requestEstado setEntity:[NSEntityDescription entityForName:@"PrendaEstado" inManagedObjectContext:self.managedObjectContext]];
            NSString *strEstado= [NSString stringWithFormat:@"%d",actionIndex];
            requestEstado.predicate =[NSPredicate predicateWithFormat:@"idEstado == %@",strEstado];
            NSError *errorEstado = nil;
            PrendaEstado *myPrendaEstado = [[self.managedObjectContext executeFetchRequest:requestEstado error:&errorEstado] objectAtIndex:0];
            
            if (isMultiselection)
            {
                for (Prenda *myPrenda in prendasArray) 
                {
                    myPrenda.estado=myPrendaEstado;
                    myPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
                }
                //Actualizo campos del detalle de la vista multiseleccion
                [[viewControllers objectAtIndex:currentPage] checkMultiselectionFields ];
            }
            else    
            {
                self.currentPrenda.estado=myPrendaEstado;
                self.currentPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
                
                //Actualizo campos del detalle de la vista actual
                [[viewControllers objectAtIndex:currentPage] updateLabels ];
                
            }
            
            //Salvo datos en database
            NSError *errorSave = nil;
            if (![self.managedObjectContext save:&errorSave])
                NSLog(@"Unresolved error %@, %@", errorSave, [errorSave userInfo]);
            
            //update ScrollView on Main PrendaViewController
            [self.delegate updateScrollViewsFromPrendaDetailAlbum];
        }
    }else if (actionView==myActionViewMoveToTrash && actionIndex==0)  //Move to trash
    {
        [myActionViewActivity startAnimating];
        [self performSelector:@selector(moveCurrentPrendaToTrash) withObject:nil afterDelay:0.05];
     } else if (actionView==myActionViewSetCategoria)  //Fijo categoria elejida
     {
         
         if (actionIndex<4)
         {
             PrendaCategoria *myPrendaCategoria=nil;
             PrendaSubCategoria *myPrendaSubcategoria=nil;
             
             //GET PrendaCategoria Array with subcategoria NINGUNO!
             NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
             [fetchRequest setEntity:[NSEntityDescription entityForName:@"PrendaCategoria" inManagedObjectContext:self.managedObjectContext]];
             NSString *strCategoria= [NSString stringWithFormat:@"%d",actionIndex+1];
             fetchRequest.predicate =[NSPredicate predicateWithFormat:@"idCategoria == %@",strCategoria];
             NSError *error = nil;
             NSArray *prendaCategoriasArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
             if ([prendaCategoriasArray count]>0) 
                 myPrendaCategoria= [prendaCategoriasArray objectAtIndex:0];
             
             //GET PrendaSubCategoria Array
             fetchRequest = [[NSFetchRequest alloc] init];
             fetchRequest.entity = [NSEntityDescription entityForName:@"PrendaSubCategoria" inManagedObjectContext:self.managedObjectContext];
             fetchRequest.predicate =[NSPredicate predicateWithFormat:@"categoria == %@", myPrendaCategoria ];
             NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idSubcategoria" ascending:YES];
             NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
             [fetchRequest setSortDescriptors:sortDescriptors];
             error = nil;
             NSArray *prendaSubCategoriaArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
             if ([prendaSubCategoriaArray count]>0) 
                 myPrendaSubcategoria= [prendaSubCategoriaArray objectAtIndex:0];
             
             //Asigno nueva categoria y subcategoria
             if (isMultiselection)
             {
                 for (Prenda *myPrenda in prendasArray) 
                 {
                     myPrenda.categoria=myPrendaCategoria;
                     myPrenda.subcategoria=myPrendaSubcategoria;
                     myPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
                     
                 }
                 [multipleSelectionDictionary setObject: [ [(Prenda*)[prendasArray lastObject] subcategoria] idSubcategoria]    forKey:@"multipleSubCategoria"];
                 [multipleSelectionDictionary setObject: [ [(Prenda*)[prendasArray lastObject] categoria] idCategoria ] forKey:@"multipleCategoria"];
             }
             else //No multiseleccion
             {
                 self.currentPrenda=[prendasArray objectAtIndex:currentPage]; 
                 self.currentPrenda.categoria=myPrendaCategoria;
                 self.currentPrenda.subcategoria=myPrendaSubcategoria;
                 self.currentPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
             }
             
             
             //Salvo datos en database
             NSError *errorSave = nil;
             if (![self.managedObjectContext save:&errorSave])
                 NSLog(@"Unresolved error %@, %@", errorSave, [errorSave userInfo]);
             
             
             //Actualizo campos del detalle de la vista anterior
             [self.delegate updateScrollViewsFromPrendaDetailAlbum];
             if (isMultiselection)
                 [[viewControllers objectAtIndex:currentPage] checkMultiselectionFields ];
             else
                 [[viewControllers objectAtIndex:currentPage] updateLabels ];
             
         }
         
     }
    
}

-(void) logPrendas
{
    NSFetchRequest *fetchPrendaRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *prendaEntity = [NSEntityDescription entityForName:@"Prenda"
                                                    inManagedObjectContext:self.managedObjectContext];
    [fetchPrendaRequest setEntity:prendaEntity];
    
    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        fetchPrendaRequest.predicate = [NSPredicate predicateWithFormat:@"(usuario == %@) ",
                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ] ];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        fetchPrendaRequest.predicate = [NSPredicate predicateWithFormat:@"(usuario == %@) OR (usuario == %@) OR (usuario == %@) ",
                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"] ];
    
}

#pragma mark - POST Picture to Twitter

    
-(void) sendPrendaToTwitter
{
    [myActionViewActivity startAnimating];
    [self.view setUserInteractionEnabled:NO];

    ShareFacebookTwitter *myVC = [[ShareFacebookTwitter alloc] initWithNibName:@"ShareFacebookTwitter" bundle:nil];
    myVC.delegate=self;
    
    NSString *dressAppMsg;
    
    if ([currentPrenda.urlPictureServer isEqualToString:@""]) //El usuario no tiene imagen
        dressAppMsg=NSLocalizedString(@"TwitterMsg", @"");
    else  //Si el usuario tiene una imagen con la URL de la prenda
        dressAppMsg=[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"TwitterMsgPrenda", @""),currentPrenda.urlPictureServer];
    
    NSString *webURL=[ NSString stringWithFormat: @"https://mobile.twitter.com/home?status=%@",[self getUrlEncoded:dressAppMsg]  ];
    
    myVC.webUrl=webURL;
    [myVC.view setBackgroundColor:[ StyleDressApp colorWithStyleForObject:StyleColorPRDetailBackground] ];
    [myVC.myWebView setBackgroundColor:[ StyleDressApp colorWithStyleForObject:StyleColorPRDetailBackground] ];
    
    [self presentModalViewController:myVC animated:YES];
    
}


-(NSString *) getUrlEncoded:(NSString*)inputString
{
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
            NULL, (__bridge CFStringRef)inputString, NULL,
            (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",kCFStringEncodingUTF8 );

    return (__bridge NSString *)urlString ;
}



-(void) dismissShareFacebookTwitterWebView
{
    [myActionViewActivity stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - POST Picture to Facebook

-(void) sendPrendaToFacebook
{
    
   
}



#pragma mark - sendEmail


-(void) sendPrendaToEmail
{
    if ([MFMailComposeViewController canSendMail]) 
    {
        [self.view setUserInteractionEnabled:NO];
        [myActionViewActivity startAnimating];
        
        NSData *imageData = UIImagePNGRepresentation([[[viewControllers objectAtIndex:currentPage] myImageView] image ] );

        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:@"DressApp"];
        NSMutableString *emailBody= [[NSMutableString alloc] init];
        [emailBody appendString:NSLocalizedString(@"emailBodyPrenda1", @"")];
        [emailBody appendString:[NSMutableString stringWithFormat:@" <a href = '%@'> %@ </a>",DRESSAPP_ITUNESLINK,NSLocalizedString(@"emailBodyPrenda2", @"")]]; 
        [emailBody appendString:[NSMutableString stringWithFormat:@"<p> <a href = '%@'> %@ </a></p>",DRESSAPP_GOOGLEPLAY,NSLocalizedString(@"emailBodyPrenda3", @"")]]; 
        
        [picker setMessageBody:emailBody isHTML:YES];
        
        [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"picture"];
        [self presentModalViewController:picker animated:YES];
            
    }else
    {
        UIAlertView *emailNotExistAlert=[[ UIAlertView alloc] initWithTitle:NSLocalizedString(@"emailNotExistTitle", "") message:NSLocalizedString(@"emailNotExistMsg", "") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", "") otherButtonTitles:nil  , nil];
        [emailNotExistAlert show];
    }
    
}


#pragma mark - sendEmail delegates
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
    
    [self.view setUserInteractionEnabled:YES];
    [myActionViewActivity stopAnimating];
	[self dismissModalViewControllerAnimated:YES];
    
    if (result==MFMailComposeResultSent)
    {
        UIAlertView *alertViewSendEmail = [[UIAlertView alloc] initWithTitle:
                                                 NSLocalizedString(@"SendPrendaToEmailOKTittle", @"")
                        message:NSLocalizedString(@"SendPrendaToEmailOKMsg", @"")                                                           delegate:self
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
        [alertViewSendEmail show];
        
    }
    
}

#pragma mark - update Prendas

-(void) updateScrollViewsFromPrendaDetail
{
    [self.delegate updateScrollViewsFromPrendaDetailAlbum];
}

#pragma mark - save to Library

-(void) savePrendaToLibrary
{
    
    [self.view setUserInteractionEnabled:NO];
    [myActionViewActivity startAnimating];

    
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",currentPrenda.urlPicture] ]; 
    
    UIImage *imageFromPrenda;
    if ( [fileManager fileExistsAtPath:imagePath] ) 
         imageFromPrenda= [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]  ] ;

    NSData* imageData = UIImageJPEGRepresentation(imageFromPrenda, 1.0);
    UIImage *imageToSave= [UIImage imageWithData:imageData];
    
    UIImageWriteToSavedPhotosAlbum(imageToSave, self, 
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
 
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
    [self.view setUserInteractionEnabled:YES];
    [myActionViewActivity stopAnimating];

    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        
    }
    else  // No errors
    {
        UIAlertView *alertViewSavePrendaToLibrary = [[UIAlertView alloc] initWithTitle:
                                           NSLocalizedString(@"SavePrendaToLibraryOKTittle", @"")
                                                                     message:NSLocalizedString(@"SavePrendaToLibraryOKMsg", @"")                                                           delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
        [alertViewSavePrendaToLibrary show];
    }
}



-(void) moveCurrentPrendaToTrash
{
    if (isMultiselection)  //Borro todas las prendas a la vez
    {
        for (Prenda *myPrenda in prendasArray) 
        {
            
            //Remove prenda pictures from cachesDirectory
            NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",myPrenda.urlPicture] ]; 
            NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",myPrenda.urlPicture] ]; 
            NSError * removeError;
            [fileManager  removeItemAtPath:imagePath error:&removeError];
            [fileManager  removeItemAtPath:imagePathSmall error:&removeError];
            
            //Actualiza la imagen del conjunto si borro esta prenda y pertenece a algún conjunto
            [self updateConjuntosImageWhenThisPrendaIsMovedToTrash:myPrenda];
            
            //Solamente la añado al histórico si ha sido subida al servidor
            //Por lo tanto, añado prenda solamente si NO es el primer backup y la prenda está en el servidor
            if ([myPrenda.firstBackup boolValue]==NO) 
            {
                //Añado prenda a borrar al historico de prendas
                NSDictionary *prendaDictionaryHistorico = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                           
                                                           [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"username",
                                                           myPrenda.idPrenda,@"idPrenda",
                                                           nil] ;
                //Creo nuevo item en la base de datos
                [PrendaHistoricoRemove prendaHistoricoWithData:prendaDictionaryHistorico inManagedObjectContext:self.managedObjectContext];
            }

            BOOL updateCalendar=NO;
            //Elimino esta prenda de ConjuntoPrendas y fuerzo a que se sincronicen los conjuntos asociados
            for (ConjuntoPrendas *thisConjuntoPrenda in  myPrenda.conjuntoPrenda)
            {
                //fuerzo a que se sincronicen los conjuntos
                thisConjuntoPrenda.conjunto.needsSynchronize=[NSNumber numberWithBool:YES];
                thisConjuntoPrenda.conjunto.needsSynchronizeImage=[NSNumber numberWithBool:YES];

                //Solo actualizo el calendario si el conjunto tiene notas
                if ([thisConjuntoPrenda.conjunto.calendarConjunto count]>0) 
                    updateCalendar=YES;
                

                //Si es la última prenda que queda en el conjunto, borro el conjunto
                if ( [thisConjuntoPrenda.conjunto.prendas count] ==1)
                {
                                        
                    //Pero antes marco este conjunto como borrado en el historico de conjuntos
                    //Solo lo marco, si antes ha sido subido al armario
                    if ([thisConjuntoPrenda.conjunto.firstBackup boolValue]==NO) 
                    {
                        //Añado conjunto a borrar al historico de prendas
                        NSDictionary *conjuntoDictionaryHistorico = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                     
                                                                     [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"username",
                                                                     thisConjuntoPrenda.conjunto.idConjunto,@"idConjunto",
                                                                     nil] ;
                        //Creo nuevo item en la base de datos
                        [ConjuntoHistoricoRemove  conjuntoHistoricoWithData:conjuntoDictionaryHistorico inManagedObjectContext:self.managedObjectContext  ];
                        
                    }
                    
                    //Y BORRO TODAS LAS NOTAS DEL CALENDARIO ASOCIADAS A ESTE CONJUNTO
                    for (CalendarConjunto *thisCalendarConjunto in thisConjuntoPrenda.conjunto.calendarConjunto) 
                        [self.managedObjectContext deleteObject:thisCalendarConjunto]; 
                    
                    //Borro la imagen del conjunto en el disco
                    [Authenticacion removeFromCachesDirectoryImageWithName:thisConjuntoPrenda.conjunto.urlPicture];

                    //Y finalmente Borro el conjunto
                    [self.managedObjectContext deleteObject:thisConjuntoPrenda.conjunto];
                
                }
                
                //Borro la relacción de la prenda con los conjuntos
                [self.managedObjectContext deleteObject:thisConjuntoPrenda];
            }

            //Borro la imagen de la prenda del disco
            [Authenticacion removeFromCachesDirectoryImageWithName:myPrenda.urlPicture];

            // Delete the managed object for the given index path
            [self.managedObjectContext deleteObject: myPrenda ];
        }
        
        // Save the context. 
        NSError *error;
        if (![self.managedObjectContext save:&error]) 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

        [self.delegate prendaDetailVCDeletePrenda:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else   //Borra solamente la prenda actual
    {

        [myActionViewActivity startAnimating];
        
        //Remove prenda pictures from cachesDirectory
        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",currentPrenda.urlPicture] ]; 
        NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",currentPrenda.urlPicture] ]; 
        NSError * removeError;
        [fileManager  removeItemAtPath:imagePath error:&removeError];
        [fileManager  removeItemAtPath:imagePathSmall error:&removeError];
        
        //Actualiza la imagen del conjunto si borro esta prenda y pertenece a algún conjunto
        [self updateConjuntosImageWhenThisPrendaIsMovedToTrash:currentPrenda];

        //Solamente la añado al histórico si ha sido subida al servidor
        //Por lo tanto, añado prenda solamente si NO es el primer backup y la prenda está en el servidor
        if ([currentPrenda.firstBackup boolValue]==NO) 
        {
            //Añado prenda a borrar al historico de prendas
            NSDictionary *prendaDictionaryHistorico = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                       
                                                       [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"username",
                                                       currentPrenda.idPrenda,@"idPrenda",
                                                       nil] ;
            //Creo nuevo item en la base de datos
            [PrendaHistoricoRemove prendaHistoricoWithData:prendaDictionaryHistorico inManagedObjectContext:self.managedObjectContext];
        }

        //Elimino esta prenda de ConjuntoPrendas y fuerzo a que se sincronicen los conjuntos asociados
        for (ConjuntoPrendas *thisConjuntoPrenda in  currentPrenda.conjuntoPrenda)
        {
            //fuerzo a que se sincronicen los conjuntos
            thisConjuntoPrenda.conjunto.needsSynchronize=[NSNumber numberWithBool:YES];
            thisConjuntoPrenda.conjunto.needsSynchronizeImage=[NSNumber numberWithBool:YES];

            //si borro el conjunto, se tiene que enterar el calendar
            //Solo actualizo el calendario si el conjunto tiene notas
            if ([thisConjuntoPrenda.conjunto.calendarConjunto count]>0) 
            {
                
            }

            //Si es la última prenda que queda en el conjunto, borro el conjunto
            if ( [thisConjuntoPrenda.conjunto.prendas count] ==1)
            {

                //Pero antes marco este conjunto como borrado en el historico de conjuntos
                //Solo lo marco, si antes ha sido subido al armario
                if ([thisConjuntoPrenda.conjunto.firstBackup boolValue]==NO) 
                {
                    //Añado conjunto a borrar al historico de prendas
                    NSDictionary *conjuntoDictionaryHistorico = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                 
                                                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"username",
                                                                 thisConjuntoPrenda.conjunto.idConjunto,@"idConjunto",
                                                                 nil] ;
                    //Creo nuevo item en la base de datos
                    [ConjuntoHistoricoRemove  conjuntoHistoricoWithData:conjuntoDictionaryHistorico inManagedObjectContext:self.managedObjectContext  ];
                
                }

                //Y BORRO TODAS LAS NOTAS DEL CALENDARIO ASOCIADAS A ESTE CONJUNTO
                for (CalendarConjunto *thisCalendarConjunto in thisConjuntoPrenda.conjunto.calendarConjunto) 
                    [self.managedObjectContext deleteObject:thisCalendarConjunto]; 

                //Borro la imagen del conjunto en el disco
                [Authenticacion removeFromCachesDirectoryImageWithName:thisConjuntoPrenda.conjunto.urlPicture];

                //Y finalmente Borro el conjunto
                [self.managedObjectContext deleteObject:thisConjuntoPrenda.conjunto];
            }
            
            //Borro la relacción de la prenda con los conjuntos
            [self.managedObjectContext deleteObject:thisConjuntoPrenda];
            
        } //End conjuntos remove
        

        //Borro la imagen de la prenda del disco
        [Authenticacion removeFromCachesDirectoryImageWithName:currentPrenda.urlPicture];

        // Delete the managed object for the given index path
        [self.managedObjectContext deleteObject: currentPrenda ];
        
        // Save the context. 
        NSError *error;
        if (![self.managedObjectContext save:&error]) 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            
        [prendasArray removeObjectAtIndex:currentPage];
        
        if (currentPage>=[prendasArray count])
            currentPage=[prendasArray count]-1;

        [myActionViewActivity stopAnimating];

        [self.delegate prendaDetailVCDeletePrenda:nil];

        if ([prendasArray count]<=0) 
            [self.navigationController popViewControllerAnimated:YES];
        else
            [self viewDidLoad];


        
    }

    //REVIEW
    //AppDelegate *delegateApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[[delegateApp conjuntosViewController] updateConjuntoView];
  
}


-(void) updateConjuntosImageWhenThisPrendaIsMovedToTrash:(Prenda*)thisPrenda
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ConjuntoPrendas" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(prenda == %@) AND (usuario == %@)", thisPrenda,[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(prenda == %@) AND  ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )", thisPrenda,[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects != nil && fetchedObjects>0) 
    {
        @autoreleasepool 
        {
            //Busco los conjunto donde va montado la prenda que deseo borrar
            for (ConjuntoPrendas *thisConjuntoPrendas in fetchedObjects) 
            {

                //Este es uno de los conjuntos que monta la prenda a borrar
                Conjunto *thisConjunto= thisConjuntoPrendas.conjunto;
                
                UIView *tempDrawingView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
                
                //Busco todas las prendas de ese conjunto y las monto en UIView
                for (ConjuntoPrendas *thisPrenda in thisConjunto.prendas ) //Aqui tengo todas las prendas del conjunto 
                {

                    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",thisPrenda.prenda.urlPicture] ]; 
                    UIImageView *thisImageView=[[UIImageView alloc] initWithFrame:CGRectMake([thisPrenda.x floatValue],[thisPrenda.y floatValue],[thisPrenda.width floatValue],[thisPrenda.height floatValue])];
                    [thisImageView setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]  ] ];
                    [tempDrawingView addSubview:thisImageView];
                }
                
                
                UIGraphicsBeginImageContext(tempDrawingView.bounds.size);
                [tempDrawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",thisConjunto.urlPicture] ]; 
                UIImage *thumbnailImage=[self createThumbnailFromImage:viewImage withSize:PIC_CONJUNTO];
                NSData *data = [[NSData alloc] initWithData: UIImagePNGRepresentation(thumbnailImage) ];
                
                NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",thisConjunto.urlPicture] ]; 
                UIImage *thumbnailImageSmall=[self createThumbnailFromImage:viewImage withSize:PIC_CONJUNTO_SMALL];
                NSData *dataSmall = [[NSData alloc] initWithData: UIImagePNGRepresentation(thumbnailImageSmall) ];
                
                [data writeToFile:imagePath atomically:YES];    
                [dataSmall writeToFile:imagePathSmall atomically:YES];    
                
                thisConjunto.needsSynchronize=[NSNumber numberWithBool: YES];
                thisConjunto.needsSynchronizeImage=[NSNumber numberWithBool: YES];
            }

        }
    }

}

-(UIImage*) createThumbnailFromImage:(UIImage*)imageToThumbnail withSize:(NSInteger)thumbnailSize
{
    // Create a thumbnail version of the image for the recipe object.
    CGSize size = imageToThumbnail.size;
    CGFloat ratio = 0;
    if (size.width > size.height) 
        ratio = thumbnailSize / size.width;
    else 
        ratio = thumbnailSize / size.height;
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
    UIGraphicsBeginImageContext(rect.size);
    [imageToThumbnail drawInRect:rect];
    UIImage *thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnailImage;
}


-(void) actionView:(UIActionView *)actionView changeAlpha:(CGFloat)newAlpha toState:(MainViewState)newState
{
    if (newState==MainViewStateBegin) 
        [self.navigationController.navigationBar setAlpha:newAlpha];
    else if (newState==MainViewStateEnd) 
        [self.navigationController.navigationBar  setAlpha:1.0];
    
}


-(void)changeSubcategoria:(UIBarButtonItem*)sender
{
    PrendaCategoriasViewController *newVC= [[PrendaCategoriasViewController alloc] initWithNibName:@"PrendaCategoriasViewController" bundle:[NSBundle mainBundle]];
    newVC.prenda=currentPrenda;
    newVC.isMultiselection=isMultiselection;
    newVC.multipleSelectionDictionary=multipleSelectionDictionary;
    newVC.prendasArray=prendasArray;                                      
    newVC.delegate=self;
    newVC.managedObjectContext=self.managedObjectContext;
    [self presentModalViewController:newVC animated:YES];

}

-(IBAction)changeMarca:(UIBarButtonItem*)sender
{
    PrendasMisMarcasViewController *newVC= [[PrendasMisMarcasViewController alloc] initWithNibName:@"PrendasMisMarcasViewController"  bundle:nil];
    newVC.prenda=currentPrenda;
    newVC.isMultiselection=isMultiselection;
    newVC.multipleSelectionDictionary=multipleSelectionDictionary;
    newVC.prendasArray=prendasArray;                      
    newVC.prendasDelegate=self;
    newVC.isChoosingMarcaForPrenda=YES;
    newVC.managedObjectContext=self.managedObjectContext;
    [self presentModalViewController:newVC animated:YES];

}

#pragma mark PrendaCategoriasVCDelegate delegate

-(void) categoriaChangedForPrenda:(Prenda *)updatedPrenda
{
    [self dismissModalViewControllerAnimated:YES];
    if (isMultiselection)
        [[viewControllers objectAtIndex:currentPage] checkMultiselectionFields ];
    else
        [[viewControllers objectAtIndex:currentPage] updateLabels ];
    [self.delegate updateScrollViewsFromPrendaDetailAlbum];

}

-(void)dismissCategoryVC
{
    if (isMultiselection)
        [[viewControllers objectAtIndex:currentPage] checkMultiselectionFields ];
    else
        [[viewControllers objectAtIndex:currentPage] updateLabels ];
   
    [self dismissModalViewControllerAnimated:YES];
}


-(void)dismissMisMarcasVC
{
    //Actualizo marcas en todos los viewcontrollers que estén abiertos
    for (PrendaDetailViewController *tempVC in viewControllers) 
    {
        if (![(NSNull *)tempVC isKindOfClass:[NSNull class] ])
            [tempVC updateAllInDetailsVC];
    }
    
    //update ScrollView on Main PrendaViewController
    [self.delegate updateScrollViewsFromPrendaDetailAlbum];

    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)dismissTiendasVC
{
    if (isMultiselection)
        [[viewControllers objectAtIndex:currentPage] checkMultiselectionFields ];
    else
        [[viewControllers objectAtIndex:currentPage] updateLabels ];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
