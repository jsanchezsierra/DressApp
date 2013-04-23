//
//  ConjuntoDetailContainerVC.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 12/14/11.
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


#import "ConjuntoDetailContainerVC.h"
#import "StyleDressApp.h"
#import "AppDelegate.h"
#import "ShareFacebookTwitter.h"
#import "ConjuntoHistoricoRemove.h"
#import "ConjuntoPrendas.h"
#import "Prenda.h"
#import "PrendaMarca.h"
#import "Authenticacion.h"


@implementation ConjuntoDetailContainerVC

@synthesize scrollView,viewControllers;
@synthesize conjuntosArray,managedObjectContext,delegate;
@synthesize currentPage,currentConjunto;
@synthesize myViewActivity;
@synthesize btnNotas,btnCategoria,btnTrash,btnCompartir;
@synthesize myActionView;
@synthesize myNavigationViewBackground;
@synthesize myActionViewMoveToTrash;
@synthesize titleLabel;
@synthesize isSaveNeededForNewConjunto,myActionViewMoveConjuntoPrendaToTrash;
@synthesize myToolBar,trashButton,myActivity; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
 
#pragma mark - View lifecycle
-(void) completeBeforePopViewController
{
    [myActivity startAnimating];
    int myIndex=0;
    for (id thisVC in viewControllers) 
    {
        if ( [thisVC isKindOfClass: [ConjuntoDetailViewController class]] ) 
            [thisVC saveDataBeforeClosing];

        myIndex++;
    }
    [self.delegate updateCalendarView:updateCalendarViewNeeded];
}

- (void)viewDidLoad
{
    updateCalendarViewNeeded=NO;
    numberOfPages= [conjuntosArray count];
   [myActivity stopAnimating];
    
    NSInteger counter= [[[NSUserDefaults standardUserDefaults] objectForKey:@"showConjuntosSliderCounter"] intValue];
    if ( counter>0 && numberOfPages>1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"showConjuntosSlider"];
        [ [NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:counter-1] forKey:@"showConjuntosSliderCounter" ];
    }

    self.currentConjunto=[conjuntosArray objectAtIndex:currentPage]; 
    
    //Prepare file manager && cachesDirectory
    cachesDirectory= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    fileManager = [NSFileManager defaultManager];
    
    [myToolBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
    [self.view  setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCODetailBackground]];
    [self.scrollView  setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCODetailBackground]];
    
    
    UIFont *myFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:22];

    //set title
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 260,44)];
    [titleLabel setFont:myFont];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
     [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCODetailHeader]];
    [titleLabel setText:[NSString stringWithFormat:@"%@ %d %@ %d",  NSLocalizedString(@"Conjunto", @""),currentPage+1, NSLocalizedString(@"de", @""),numberOfPages] ];
    [self.navigationItem setTitleView:titleLabel];
        
    
    UIBarButtonItem *righBarButtonWithViews=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPrendasList)];
    
    self.navigationItem.rightBarButtonItem = righBarButtonWithViews; 

    //Create buttons toolbar
    UILabel *btnCategoriaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 33)];
    [btnCategoriaLabel setText:NSLocalizedString(@"ConjuntoCategoria",@"")];
    [btnCategoriaLabel setBackgroundColor:[UIColor clearColor]];
    [btnCategoriaLabel setTextAlignment:UITextAlignmentCenter];
    [btnCategoriaLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:12]];
    [self.btnCategoria addSubview:btnCategoriaLabel];
 
    UILabel *btnNotasLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 33)];
    [btnNotasLabel setText:NSLocalizedString(@"ConjuntoNotas",@"")];
    [btnNotasLabel setBackgroundColor:[UIColor clearColor]];
    [btnNotasLabel setTextAlignment:UITextAlignmentCenter];
    [btnNotasLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:12]];
    [self.btnNotas addSubview:btnNotasLabel];
    
    UILabel *btnCompartirLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 33)];
    [btnCompartirLabel setText:NSLocalizedString(@"ConjuntoCompartir",@"")];
    [btnCompartirLabel setBackgroundColor:[UIColor clearColor]];
    [btnCompartirLabel setTextAlignment:UITextAlignmentCenter];
    [btnCompartirLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:12]];
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
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < numberOfPages; i++)
        [controllers addObject:[NSNull null]];

    self.viewControllers = controllers;
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numberOfPages, 371);
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    //load and unload new Views
    [self performSelector:@selector(loadUnloadViews) withObject:nil afterDelay:0.01];
    [scrollView setContentOffset:CGPointMake( scrollView.frame.size.width * currentPage, 0)];
 
}



#pragma mark - UIScrollViewDelegate methods

-(void) scrollViewDidScroll:(UIScrollView *)thisScrollView
{
    
    CGFloat pageWidth = thisScrollView.frame.size.width;
    int page = floor((thisScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page < 0 || page >= numberOfPages)
        return;
    
    currentPage=page;

    //set title
    [titleLabel setText:[NSString stringWithFormat:@"%@ %d %@ %d",  NSLocalizedString(@"Conjunto", @""),currentPage+1, NSLocalizedString(@"de", @""),numberOfPages] ];

    //change UIActivityIndicatorView frame position 
    self.myViewActivity.frame=CGRectMake(pageWidth*page + pageWidth/2,170, 20,20); 
    [myViewActivity startAnimating];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)thisScrollView
{
    CGFloat pageWidth = thisScrollView.frame.size.width;
    int page = floor((thisScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page < 0 || page >= numberOfPages)
        return;
    
    currentPage=page;
    self.currentConjunto=[conjuntosArray objectAtIndex:currentPage]; 
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
    
    //Solamente grabo el primer conjuntoDetail que cargo
    if (isSaveNeededForNewConjunto==YES) 
        isSaveNeededForNewConjunto=NO;
    
    scrollView.frame = CGRectMake(0,0,320,372);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numberOfPages, 371);
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    [self.scrollView setContentOffset:CGPointMake( scrollView.frame.size.width * currentPage, 0)];
    [scrollView flashScrollIndicators];
    
}

#pragma mark - load ViewControllers
- (void)loadScrollViewWithPage:(int)page
{
    
    if (page < 0 || page >= numberOfPages)
        return;

    // replace the placeholder if necessary
    ConjuntoDetailViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller=  [[ConjuntoDetailViewController alloc] initWithNibName:@"ConjuntoDetailViewController" bundle:[NSBundle mainBundle] withConjunto: [conjuntosArray objectAtIndex:page] andPage:page];
        controller.managedObjectContext=self.managedObjectContext;
        if (isSaveNeededForNewConjunto==YES) 
            controller.isSaveNeededForDetail=YES;
        else
            controller.isSaveNeededForDetail=NO;
        controller.view.tag=page;
        controller.delegate=self;
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = CGRectMake(0, 0, 320, 372); //scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
    }
}


- (void)unLoadScrollViewWithPage:(int)page
{
    if (page < 0 || page >= numberOfPages)
        return;
    
    if ( [[viewControllers objectAtIndex:page] isKindOfClass: [ConjuntoDetailViewController class]] ) 
        [[viewControllers objectAtIndex:page] saveDataBeforeClosing];
    [viewControllers replaceObjectAtIndex:page withObject:[NSNull null]];
 
}


#pragma mark - ConjuntoDetailContainerViewController delegate

-(void) updateConjuntoDetailContainerView
{
    [self.delegate updateConjuntoView];
}

-(void) activateCalendarViewFlag
{
    updateCalendarViewNeeded=YES;
}


-(void) enableScrollInContainerView:(BOOL)scrollEnabled
{
    [self.scrollView setScrollEnabled:scrollEnabled];
}

#pragma mark - add Items - PrendasViewController

-(void) addPrendasList
{
    [myActivity startAnimating];
    [self performSelector:@selector(addingPrendasList) withObject:nil afterDelay:0.05];

}


-(void) addingPrendasList
{
    PrendasViewController *newVC= [[PrendasViewController alloc] initWithNibName:@"PrendasViewController" bundle:[NSBundle mainBundle]];
    [newVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [newVC setManagedObjectContext:self.managedObjectContext];
    [newVC setIsChoosingPrendasForConjunto:YES];
    [newVC setDelegateConjunto:self];
    [self presentModalViewController:newVC animated:YES];
}


#pragma mark - PrendasViewController delegate

-(void) cancelChoosingPrendasForConjunto
{
    [myActivity stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
    
}

//El usuario ha añadido una prenda a un conjunto ya existente 
-(void) finishChoosingPrendasForConjunto:(NSMutableArray *)prendasForConjuntoArray
{
    [myActivity stopAnimating];

    //Cierro vista modal
    [self dismissModalViewControllerAnimated:YES];

    //Añado prendas a la tabla ConjuntoPrendas para el conjunto actual 
    [self.delegate crearConjuntoPrendas:prendasForConjuntoArray forConjunto:currentConjunto];
    
    //Actualizo vista de detalle para que aparezcan las nuevas prendas
    [[[viewControllers objectAtIndex:currentPage] conjunto] setNeedsSynchronize:[NSNumber numberWithBool: YES]];
    [[[viewControllers objectAtIndex:currentPage] conjunto] setNeedsSynchronizeImage:[NSNumber numberWithBool: YES]];
    [[viewControllers objectAtIndex:currentPage] addConjuntoViews];

    
    //activo el FLAG que indica que el conjunto ha de salvarse, si se ha modificado
    if ((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage] !=nil) 
    {
        //Marco el conjunto como que tiene que salvarse
        ((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage]).isSaveNeededForDetail=YES;

        //Lo salvo ahora, ya que puede pasar que añada algo y no dé al botón de volver, sino que salga de la App.
        [((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage]) saveDataBeforeClosing];
        
    }
       
    if ( [ [[viewControllers objectAtIndex:currentPage] conjunto].calendarConjunto count]>0 ) 
        updateCalendarViewNeeded=YES;
}


-(IBAction)btnPressed:(UIButton*)sender
{
    if (sender==btnCategoria) 
        [self setConjuntoCategoria];
    else if (sender==btnNotas) 
        [self setNotesAndDates];
    else if (sender==btnTrash) 
        [self moveToTrash:sender];
    else if (sender==btnCompartir) 
        [self openActionSheet];
    
}


#pragma mark - moveToTrash - remove item from dataBase 
-(void) moveToTrash :(UIButton*) barButton
{
    
    //Cancel userInteraction
    [scrollView setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    
    //Open ActionView
    self.myActionViewMoveToTrash = [[UIActionView alloc] initWithFrame:CGRectMake(0,480,320,416)];
    [myActionViewMoveToTrash setMyFontSize:20];
    [myActionViewMoveToTrash setDelegate:self];
    [myActionViewMoveToTrash setButtonsTextArray:[NSMutableArray arrayWithObjects:NSLocalizedString(@"SI", @""),  NSLocalizedString(@"NO", @""), nil]];
    [myActionViewMoveToTrash setSelectedIndex:1];
    if (barButton==nil) 
        [myActionViewMoveToTrash setActionViewTitle: NSLocalizedString(@"MoveConjuntoToTrashEmptyMsg", @"")];
    else
        [myActionViewMoveToTrash setActionViewTitle: NSLocalizedString(@"MoveConjuntoToTrashMsg", @"")];
    [myActionViewMoveToTrash initView];
    [self.view addSubview:myActionViewMoveToTrash];
    
    //Add background view - opaque view para que el fondo quede oscuro al abrir el actionView
    myNavigationViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -44,320,44)];
    [myNavigationViewBackground setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:myNavigationViewBackground];

     
}


#pragma mark - moveToTrash - remove item from dataBase 
-(void) moveConjuntoPrendaToTrash 
{
    
    //Cancel userInteraction
    [scrollView setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    
    //Open ActionView
    self.myActionViewMoveConjuntoPrendaToTrash = [[UIActionView alloc] initWithFrame:CGRectMake(0,480,320,416)];
    [myActionViewMoveConjuntoPrendaToTrash setMyFontSize:20];
    [myActionViewMoveConjuntoPrendaToTrash setDelegate:self];
    [myActionViewMoveConjuntoPrendaToTrash setButtonsTextArray:[NSMutableArray arrayWithObjects:NSLocalizedString(@"SI", @""),  NSLocalizedString(@"NO", @""), nil]];
    [myActionViewMoveConjuntoPrendaToTrash setSelectedIndex:1];
    [myActionViewMoveConjuntoPrendaToTrash setActionViewTitle: NSLocalizedString(@"MoveConjuntoPrendaToTrashMsg", @"")];
    [myActionViewMoveConjuntoPrendaToTrash initView];
    [self.view addSubview:myActionViewMoveConjuntoPrendaToTrash];
    
    //Add background view - opaque view para que el fondo quede oscuro al abrir el actionView
    myNavigationViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -44,320,44)];
    [myNavigationViewBackground setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:myNavigationViewBackground];
    
    
}



#pragma mark - UIActionSheet

- (void)openActionSheet
{
    //Cancel userInteraction
    [scrollView setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];

    //Open ActionView
    self.myActionView = [[UIActionView alloc] initWithFrame:CGRectMake(0,480,320,416)];
    [myActionView setMyFontSize:20];
    [myActionView setDelegate:self];
    [myActionView setButtonsTextArray:[NSMutableArray arrayWithObjects:NSLocalizedString(@"saveToAlbum", @""),  NSLocalizedString(@"facebook", @""),NSLocalizedString(@"twitter", @""),NSLocalizedString(@"email", @""),NSLocalizedString(@"cancelar", @""), nil]];
    [myActionView setSelectedIndex:4];
    [myActionView setActionViewTitle: NSLocalizedString(@"actionViewConjuntoTitle", @"")];
    [myActionView initView];
    [self.view addSubview:myActionView];
    
    //Add background view - opaque view para que el fondo quede oscuro al abrir el actionView
    myNavigationViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -44,320,44)];
    [myNavigationViewBackground setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:myNavigationViewBackground];
    
}

#pragma mark - actionView delegate methods

-(void) actionView:(UIActionView *)actionView didSelectIndex:(NSInteger)actionIndex
{
    //Remove views from superview
    [actionView removeFromSuperview];
    [self.myNavigationViewBackground removeFromSuperview];
    
    //User interaction enabled
    [scrollView setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
 
    if (actionView==myActionView) //Do album, facebook, etc,etc
    {
        if (actionIndex==0)  // guardar en album
            [self saveConjuntoToLibrary];
        else if(actionIndex==1)  //Facebook
            [self sendConjuntoToFacebook];  //using authorization dialog
            
        else if(actionIndex==2)  //Twitter
            [self sendConjuntoToTwitter];
        else if(actionIndex==3)  //Email
            [self sendConjuntoToEmail];
        
    } else if (actionView==myActionViewMoveToTrash && actionIndex==0)  //Move to trash
    {
        [self removeConjuntoFromDatabase];
    }  //Move ConjuntoView to trash
    else if (actionView ==myActionViewMoveConjuntoPrendaToTrash && actionIndex==0) //Acepto borrado
    {
        
        if ((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage] !=nil) 
        {

            if ( [ [[viewControllers objectAtIndex:currentPage] conjunto].calendarConjunto count]>0 ) 
                updateCalendarViewNeeded=YES;

            //Borro la prenda seleccionada del conjunto
            [(ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage] removePrendaFromContainerView];
        }
    }    
    else if (actionView ==myActionViewMoveConjuntoPrendaToTrash && actionIndex==1) //Cancelo borrado
    {
        if ((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage] !=nil) 
        {
            //no Borro la prenda seleccionada del conjunto, restablezco settings
            [(ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage] doNotRemovePrendaFromContainerView];
        }

    }
    
}

#pragma mark - POST Picture to Twitter


-(void) sendConjuntoToTwitter
{
    [myActivity startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    ShareFacebookTwitter *myVC = [[ShareFacebookTwitter alloc] initWithNibName:@"ShareFacebookTwitter" bundle:nil];
    myVC.delegate=self;
    
    NSString *dressAppMsg=NSLocalizedString(@"TwitterMsg", @"");
    
    
    if ([currentConjunto.urlPictureServer isEqualToString:@""]) //El usuario no tiene imagen en el conjunto
        dressAppMsg=NSLocalizedString(@"TwitterMsg", @"");
    else  //Si el usuario tiene una imagen con la URL de la prenda
        dressAppMsg=[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"TwitterMsgConjunto", @""),currentConjunto.urlPictureServer];
    
    NSString *webURL=[ NSString stringWithFormat: @"https://mobile.twitter.com/home?status=%@",[self getUrlEncoded:dressAppMsg]  ];
    
    myVC.webUrl=webURL;
    [myVC.view setBackgroundColor:[ StyleDressApp colorWithStyleForObject:StyleColorCODetailBackground] ];
    [myVC.myWebView setBackgroundColor:[ StyleDressApp colorWithStyleForObject:StyleColorCODetailBackground] ];
    
    [self presentModalViewController:myVC animated:YES];
    
}


-(NSString *) getUrlEncoded:(NSString*)inputString
{
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    NULL,
                                                                    (__bridge CFStringRef)inputString,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                    kCFStringEncodingUTF8 );
    return (__bridge NSString *)urlString ;
}



-(void) dismissShareFacebookTwitterWebView
{
    [myActivity stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - POST Picture to Facebook

-(void) sendConjuntoToFacebook
{
 }




#pragma mark - sendEmail


-(void) sendConjuntoToEmail
{
    
    if ([MFMailComposeViewController canSendMail]) 
    {
        [self.view setUserInteractionEnabled:NO];
        [myActivity startAnimating];
        
        ((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage]).drawingView.backgroundColor=[UIColor clearColor];
        UIGraphicsBeginImageContext(  ((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage]).drawingView.bounds.size );
        [((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage]).drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        ((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage]).drawingView.backgroundColor=[StyleDressApp colorWithStyleForObject:StyleColorCODetailBackground];
        
        NSData *imageData = UIImagePNGRepresentation( viewImage );
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:@"DressApp"];
        
        NSMutableString *emailBody= [[NSMutableString alloc] init];
        [emailBody appendString:NSLocalizedString(@"emailBodyConjunto1", @"")];
        
        
        //Generate marcas Array
        NSMutableArray *marcaArray =[[NSMutableArray alloc] init];
        for (ConjuntoPrendas *thisConjuntoPrenda in currentConjunto.prendas) 
        {
            //Solamente añado la marca al array si es diferente de "0"-->(marca=Otra) y si la marca no está en el array
            if (![thisConjuntoPrenda.prenda.marca.idMarca isEqualToString:@"0"] && ![marcaArray containsObject:thisConjuntoPrenda.prenda.marca.descripcion] )
                [marcaArray addObject:thisConjuntoPrenda.prenda.marca.descripcion];
        } 
        
        if ([marcaArray count] ==0 )  //Si no tengo marcas
            [emailBody appendString:[NSString stringWithFormat:@"<p>%@</p>", NSLocalizedString(@"emailBodyConjunto2", @"")] ];
        else if ([marcaArray count]==1) //Si tengo solo una marca
             [emailBody appendString:[NSString stringWithFormat:@"<p>%@ %@</p>", NSLocalizedString(@"emailBodyConjunto2", @""),NSLocalizedString(@"emailBodyConjunto3a", @"")] ];
        else //Si tengo varias marcas
            [emailBody appendString:[NSString stringWithFormat:@"<p>%@ %@</p>", NSLocalizedString(@"emailBodyConjunto2", @""),NSLocalizedString(@"emailBodyConjunto3b", @"")] ];
        
        //Añado marcas al emailBody
        NSInteger marcaIndex=1;
        for (NSString *thisMarca in marcaArray) 
        {
            [emailBody appendString:thisMarca];
            if (marcaIndex!=[marcaArray count]) [emailBody appendString:@", "]; 
                else [emailBody appendString:@". "]; 
            marcaIndex++;
        }
         
        [emailBody appendString:[NSMutableString stringWithFormat:@"%@ <a href = '%@'> %@ </a>",NSLocalizedString(@"emailBodyConjunto4", @""),DRESSAPP_ITUNESLINK,NSLocalizedString(@"emailBodyConjunto5", @"")]]; 

        [emailBody appendString:[NSMutableString stringWithFormat:@"<p> <a href = '%@'> %@ </a></p>",DRESSAPP_GOOGLEPLAY,NSLocalizedString(@"emailBodyConjunto6", @"")]]; 

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
    [myActivity stopAnimating];
    
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


#pragma mark - save to Library

-(void) saveConjuntoToLibrary
{
    
    [self.view setUserInteractionEnabled:NO];
    [myActivity startAnimating];
    
    ((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage]).drawingView.backgroundColor=[UIColor clearColor];

    UIGraphicsBeginImageContext(  ((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage]).drawingView.bounds.size );
    [((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage]).drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    ((ConjuntoDetailViewController*)[viewControllers objectAtIndex:currentPage]).drawingView.backgroundColor=[StyleDressApp colorWithStyleForObject:StyleColorCODetailBackground];

    NSData* imageData = UIImageJPEGRepresentation(viewImage, 1.0);
    UIImage *imageToSave= [UIImage imageWithData:imageData];
    
    UIImageWriteToSavedPhotosAlbum(imageToSave, self, 
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
    [self.view setUserInteractionEnabled:YES];
    [myActivity stopAnimating];
    
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




-(void) actionView:(UIActionView *)actionView changeAlpha:(CGFloat)newAlpha toState:(MainViewState)newState
{
    [scrollView setAlpha:newAlpha];
    if (newState==MainViewStateBegin) 
        [self.navigationController.navigationBar setAlpha:newAlpha];
       
    else if (newState==MainViewStateEnd) 
       [self.navigationController.navigationBar  setAlpha:1.0];
     
}

-(void) removeConjuntoFromDatabase
{
    self.currentConjunto=[conjuntosArray objectAtIndex:currentPage]; 
    [Authenticacion removeFromCachesDirectoryImageWithName:currentConjunto.urlPicture];
    
    if ([currentConjunto.firstBackup boolValue]==NO) 
    {
        //Añado conjunto a borrar al historico de prendas
        NSDictionary *conjuntoDictionaryHistorico = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                   
                                                   [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"username",
                                                   currentConjunto.idConjunto,@"idConjunto",
                                                   nil] ;
        //Creo nuevo item en la base de datos
        [ConjuntoHistoricoRemove  conjuntoHistoricoWithData:conjuntoDictionaryHistorico inManagedObjectContext:self.managedObjectContext  ];
    }

    for (CalendarConjunto *thisCalendarConjunto in currentConjunto.calendarConjunto) 
        [self.managedObjectContext deleteObject:thisCalendarConjunto]; 
    
    
    [conjuntosArray removeObjectAtIndex:currentPage];

    BOOL updateCalendarViewNeededLocal=NO;
    if ( [currentConjunto.calendarConjunto count]>0 ) 
        updateCalendarViewNeededLocal=YES;

    
    //Borro conjunto de base de datos
    [self.managedObjectContext deleteObject: currentConjunto ];
    
    // Save the context. 
    NSError *error;
    if (![self.managedObjectContext save:&error]) 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

    //Actualiza conjunto en delegado
    [self.delegate updateConjuntoView];

    if ([conjuntosArray count]<=0) 
        [self.navigationController popViewControllerAnimated:YES];
    else 
    {
        if (currentPage >=[conjuntosArray count])
            currentPage=[conjuntosArray count]-1;
        [self viewDidLoad];
    }    
    
    if (updateCalendarViewNeededLocal==YES) 
        updateCalendarViewNeeded=YES;

    
}

#pragma mark - setCategoria

-(void) setConjuntoCategoria
{
    ConjuntoDetailSetCategoriaVC *newVC= [[ConjuntoDetailSetCategoriaVC alloc] init];
    newVC.conjunto=currentConjunto;
    newVC.delegate=self;
    newVC.managedObjectContext=self.managedObjectContext;
    [self presentModalViewController:newVC animated:YES];
    
}

-(void) dismissConjuntoDetailSetCategoriaVC
{
    
    [self.delegate updateConjuntoView];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - setNotes

-(void) setNotesAndDates;
{
    
    ConjuntoDetailNotes *newVC= [[ConjuntoDetailNotes alloc] init];
    newVC.conjunto=currentConjunto;
    newVC.delegate=self;
    newVC.managedObjectContext=self.managedObjectContext;
    [self presentModalViewController:newVC animated:YES];
}


-(void) dismissConjuntoDetailNotesVCDelegate
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any stronged subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
