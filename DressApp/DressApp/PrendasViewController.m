//
//  PrendasViewController.m
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


#import "PrendasViewController.h"
#import "PrendaCategoria.h"
#import "PrendaTienda.h"
#import "PrendasAlbumViewController.h"
#import "StyleDressApp.h"
#import "PrendaMarca.h"

#import "Marcas.h"
#import "ConjuntoCategoria.h"
#import "PrendaTemporada.h"
#import "PrendaEstado.h"
#import "PrendaMarca.h"
#import "PrendaSubCategoria.h"
#import "Authenticacion.h"
#import "DataSortPrendas.h"

@implementation PrendasViewController
@synthesize managedObjectContext;
@synthesize delegate,isRight;
@synthesize containerView;
@synthesize prendasTopsArray,prendasBottomsArray,prendasShoesArray,prendasAccesoriesArray;
@synthesize addTopPrenda,addBottomPrenda,addShoesPrenda,addAccesoriesPrenda;
@synthesize multipleSelectionPrendasArray;
@synthesize myPrendaCategoria;
@synthesize isChoosingPrendasForConjunto;
@synthesize sideControlsView;
@synthesize myNavigationBar;
@synthesize myNavigationItem;
@synthesize delegateConjunto;
@synthesize mainToolbar;
@synthesize strip1ImageView,strip2ImageView,strip3ImageView,strip4ImageView;
@synthesize cameraImagePicker,camaraPrendaView;
@synthesize prendasAlbumVC;
@synthesize myActivityView, labelZapatos,labelParteAbajo,labelParteArriba,labelComplementos;
@synthesize loadingView,loadingLabel,loadingImageView,loadingActivityView;
@synthesize leftLineView;
@synthesize didSelectRow;
@synthesize myTableViewTop,myTableViewShoes,myTableViewBottom,myTableViewAccesories;
@synthesize strip1ForegroundImageView,strip2ForegroundImageView,strip3ForegroundImageView,strip4ForegroundImageView;
@synthesize sortView, sortTable;
@synthesize sortBarBtnItemShowNotes,sortBarBtnAscending;
@synthesize sortLabel;

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

-(void) loadPreloadData
{
    
    [self.view setUserInteractionEnabled:NO];
    
    //Creo main Tables
    [self createCoreDataMainTables];
    
    //Si la key @"CreateDefaultPrendas" es YES, creo las prendas
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"CreateDefaultPrendas"] isEqualToString: @"YES"] )
        [self createCoreDataDefaultPrendas];
    
    NSError *errorSave = nil;
    if (![self.managedObjectContext save:&errorSave])
        NSLog(@"Unresolved error %@, %@", errorSave, [errorSave userInfo]);
    
    
    [self.view setUserInteractionEnabled:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"LoadPreloadData"];
    
    [self prendaRequest];
     [self.loadingView setHidden:YES];

}

- (void)viewDidLoad
{

    isSortNeeded=NO;
    sortViewHiddenState=YES;
    [self.sortView setFrame:CGRectMake(0, 70+44, 320, 350-44)];
    [self.view addSubview:self.sortView];
    [self.sortView setHidden:sortViewHiddenState];
    sortType= [[ [NSUserDefaults standardUserDefaults] objectForKey:@"sortType"] integerValue] ;
    
    //The view Controller is not in Right position
    isRight=NO;
    multipleSelectionEnabled=NO;
    didSelectRow=NO;
    [leftLineView setHidden:YES];
    [self.loadingView setHidden:YES];
   

    //Prepare file manager && cachesDirectory
    cachesDirectory= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    
    fileManager = [NSFileManager defaultManager];
    
    //Set background Color
    [self.containerView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRBackground]];
    
    
    //Set sortView parameters
    [self.sortView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorSortBackground] ];
    [self.sortTable setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorSortCellBackground]];
    
   
    //Create sort label
    UIFont *myFontSortLabel= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:30];
    self.sortLabel=[[UILabel alloc] initWithFrame:CGRectMake(100,0,0,32)];
    self.sortLabel.font=myFontSortLabel;
    //[self.sortLabel setAlpha:0];
    self.sortLabel.textAlignment=UITextAlignmentCenter;
    self.sortLabel.backgroundColor=[UIColor clearColor];
    self.sortLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorSortTitleColor];
    [self.sortLabel setText:NSLocalizedString(@"sortViewTitle", @"")];
    [self.view addSubview:self.sortLabel];
 
    
    //Create BarButtonItem for ShowNotes
    self.sortBarBtnItemShowNotes= [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(btnSortShowNotesPressed)];
    
    if ( [[ [NSUserDefaults standardUserDefaults] objectForKey:@"showSortNotes"] boolValue] ==YES)
        [self.sortBarBtnItemShowNotes setTitle:NSLocalizedString(@"sortBtnTitleHide", @"") ];
    else
        [self.sortBarBtnItemShowNotes setTitle:NSLocalizedString(@"sortBtnTitleShow", @"") ];


    //Create BarButtonItem for SortAscending
    self.sortBarBtnAscending = [[UIBarButtonItem alloc]  init];
    [self.sortBarBtnAscending setTarget:self];
    [self.sortBarBtnAscending setAction:@selector(btnSortAscendingPressed)];
    [self.sortBarBtnAscending setStyle:UIBarButtonItemStyleBordered];
    [self.sortBarBtnAscending setWidth:40];    
    if ( [[ [NSUserDefaults standardUserDefaults] objectForKey:@"PRSortAscending"] boolValue] ==YES)
        [self.sortBarBtnAscending setImage:[StyleDressApp imageWithStyleNamed:@"PRSortDescending"] ];
    else
        [self.sortBarBtnAscending setImage:[StyleDressApp imageWithStyleNamed:@"PRSortAscending"] ];
    
    
    //SortTableFrame
    UIImageView *imageViewTableFrame= [[UIImageView alloc] initWithFrame:CGRectMake(15,72-44,290,230)];
    imageViewTableFrame.image = [StyleDressApp imageWithStyleNamed:@"PRSortTableFrame"];
    [self.sortView addSubview:imageViewTableFrame];
    if ([StyleDressApp getStyle] == StyleTypeVintage )
        [sortTable setFrame:CGRectMake(30 ,80-44,260,210)] ;        
    else if ([StyleDressApp getStyle] == StyleTypeModern )
        [sortTable setFrame:CGRectMake(30-13 ,80-7-44,260+26,210+7)] ;
    
    //Set main add Buttons imageContent
    [self.addTopPrenda setImage:[StyleDressApp imageWithStyleNamed:@"PR1AddTopPart"] forState:UIControlStateNormal];
    [self.addBottomPrenda setImage:[StyleDressApp imageWithStyleNamed:@"PR1AddBottonPart"] forState:UIControlStateNormal];
    [self.addShoesPrenda setImage:[StyleDressApp imageWithStyleNamed:@"PR1AddShoes"] forState:UIControlStateNormal];
    [self.addAccesoriesPrenda setImage:[StyleDressApp imageWithStyleNamed:@"PR1AddAccessories"] forState:UIControlStateNormal];

    
    //Self strip background images
    [self.strip1ImageView setImage:[StyleDressApp imageWithStyleNamed:@"PR1StripBackgroundTop"]];
    [self.strip2ImageView setImage:[StyleDressApp imageWithStyleNamed:@"PR1StripBackgroundBotton"]];
    [self.strip3ImageView setImage:[StyleDressApp imageWithStyleNamed:@"PR1StripBackgroundShoes"]];
    [self.strip4ImageView setImage:[StyleDressApp imageWithStyleNamed:@"PR1StripBackgroundAccessories"]];

    
    //Self strip background images
    [self.strip1ForegroundImageView setImage:[StyleDressApp imageWithStyleNamed:@"PR1StripForegroundTop"]];
    [self.strip2ForegroundImageView setImage:[StyleDressApp imageWithStyleNamed:@"PR1StripForegroundBotton"]];
    [self.strip3ForegroundImageView setImage:[StyleDressApp imageWithStyleNamed:@"PR1StripForegroundShoes"]];
    [self.strip4ForegroundImageView setImage:[StyleDressApp imageWithStyleNamed:@"PR1StripForegroundAccessories"]];

    float alphaStripForeground=0.45;
    [self.strip1ForegroundImageView setAlpha:alphaStripForeground];
    [self.strip2ForegroundImageView setAlpha:alphaStripForeground];
    [self.strip3ForegroundImageView setAlpha:alphaStripForeground];
    [self.strip4ForegroundImageView setAlpha:alphaStripForeground];
    
    //Draw lines separating sections
    for (int i=1;i<=3; i++) 
    {
        UIView *lineView= [[UIView alloc] initWithFrame:CGRectMake(0, 93*i , 320, 1)];
        [lineView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRSectionSeparator]];
        [self.containerView addSubview:lineView];
    }
    
    UIFont *myFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:32];
    
    //asigno font a Labels "parte de arriba"...
    [labelParteArriba setFont:myFont];
    [labelParteAbajo setFont:myFont];
    [labelZapatos setFont:myFont];
    [labelComplementos setFont:myFont];
    
    //asigno text a Labels "parte de arriba"...
    [labelParteArriba setText:NSLocalizedString(@"categoria1",@"")];
    [labelParteAbajo setText:NSLocalizedString(@"categoria2",@"")];
    [labelZapatos setText:NSLocalizedString(@"categoria3",@"")];
    [labelComplementos setText:NSLocalizedString(@"categoria4",@"")];

    //asigno hidden a Labels "parte de arriba"...
    [labelParteArriba setHidden:YES];
    [labelParteAbajo setHidden:YES];
    [labelZapatos setHidden:YES];
    [labelComplementos setHidden:YES];

    
    [labelParteArriba setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREmptyCategoria]];
    [labelParteAbajo setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREmptyCategoria]];
    [labelZapatos setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREmptyCategoria]];
    [labelComplementos setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREmptyCategoria]];

    //Si no estoy en modo conjunto
    if (isChoosingPrendasForConjunto==NO) {
        
        [self.containerView setFrame:CGRectMake(0,0,320,416)];
        
        [myNavigationBar setHidden:YES];
        [sideControlsView setHidden:NO];
        
        UIBarButtonItem *leftBarButtonItem= [[UIBarButtonItem alloc] init];
        [leftBarButtonItem setImage:[StyleDressApp imageWithStyleNamed:@"GEBtnMainMenu" ] ];
        [leftBarButtonItem setTarget:self];
        [leftBarButtonItem setStyle:UIBarButtonItemStyleBordered];
        [leftBarButtonItem setAction:@selector(popMainMenuViewController)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem; 
        
        UIBarButtonItem *rigthBarButtonItem= [[UIBarButtonItem alloc] init];
        [rigthBarButtonItem setImage:[StyleDressApp imageWithStyleNamed:@"PRBtnProfile" ] ];
        [rigthBarButtonItem setTarget:self];
        [rigthBarButtonItem setStyle:UIBarButtonItemStyleBordered];
        [rigthBarButtonItem setAction:@selector(changeToProfileVC)];
        self.navigationItem.rightBarButtonItem = rigthBarButtonItem; 
    
        [self setToolbarItemsAll];
               
        //Addd title to navigation Controller
        self.title=NSLocalizedString(@"Prendas",@"");
        [self.navigationController.navigationBar setTintColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];
        [self.mainToolbar setTintColor: [ StyleDressApp colorWithStyleForObject:StyleColorMainToolBar] ];
        
        [self addHeaderCenterView];

        //Chequeo si he de abrir "LoadPreloadData"
        //Quizás no haría falta chequearlo, ya que en viewDidLoad solo entre una vez
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoadPreloadData"] isEqualToString:@"YES"] ) 
        {
            [self.loadingView setHidden:NO];
            [self.loadingLabel setText:NSLocalizedString(@"loading",@"")];
            [self.loadingImageView setImage:[StyleDressApp imageWithStyleNamed:@"Activity"]]; 
            
            [self performSelector:@selector(loadPreloadData) withObject:nil afterDelay:0.1];
        }else
            [self addAttributesToMarcas];   

    }
    else if (isChoosingPrendasForConjunto==YES) //Choosing for conjunto
    {
        
        [self setToolbarItemsForConjuntoAll];
        [myNavigationBar setHidden:NO];
        [sideControlsView setHidden:NO];
        
        [myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
        
        [mainToolbar  setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];

        
        [self.containerView setFrame:CGRectMake(0,44,320,416)];
        
         UIFont *myFontTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:24];
        
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,180,32)];
        titleLabel.font=myFontTitle;
        titleLabel.text=NSLocalizedString(@"addPrendas", @"");
        titleLabel.textAlignment=UITextAlignmentCenter;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorPRHeader];
      
        [myNavigationItem setTitleView:titleLabel ];
        
                
        //Defino imagen de botones "ok" y "cancel"
        UIBarButtonItem *OKButtomItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChoosingPrendaForConjunto)];
        
        UIBarButtonItem *cancelButtomItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChoosingPrendaForConjunto)];
        
        
        [self.myNavigationItem setLeftBarButtonItem:cancelButtomItem];
        [self.myNavigationItem setRightBarButtonItem:OKButtomItem];
        
        self.multipleSelectionPrendasArray= nil;
        self.multipleSelectionPrendasArray= [[NSMutableArray alloc] init ];
        
        //Activo seleccion multiple cuando estoy eligiendo prendas para conjunto
        multipleSelectionEnabled=YES;
         self.multipleSelectionPrendasArray= nil;
        self.multipleSelectionPrendasArray= [[NSMutableArray alloc] init ];
        
        [self prendaRequest];
        
        [self scrollTableViewsToBottom];

    }
     
    [self prendaRequest];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    
     myTableViewTop.transform = CGAffineTransformMakeRotation(+M_PI_2);
     myTableViewBottom.transform = CGAffineTransformMakeRotation(+M_PI_2);
     myTableViewShoes.transform = CGAffineTransformMakeRotation(+M_PI_2);
     myTableViewAccesories.transform = CGAffineTransformMakeRotation(+M_PI_2);
     
     myTableViewTop.frame = CGRectMake(0,0, 320,93);
     myTableViewBottom.frame = CGRectMake(0,93, 320,93);
     myTableViewShoes.frame = CGRectMake(0,186, 320,93);
     myTableViewAccesories.frame = CGRectMake(0,279,320,93);


    myTableViewTop.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTableViewBottom.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTableViewShoes.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTableViewAccesories.separatorStyle=UITableViewCellSeparatorStyleNone;
    
   
 }



-(void) setToolbarItemsSort
{
    UIBarButtonItem *spaceBarButtom = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    
    [mainToolbar setItems:[NSArray arrayWithObjects:self.sortBarBtnItemShowNotes,spaceBarButtom,sortBarBtnAscending,nil]];
}

-(void) setToolbarItemsForConjuntoAll
{
    
    UIBarButtonItem *spaceBarButtom = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *sortBarButtomItem = [[UIBarButtonItem alloc]  init];
    [sortBarButtomItem setImage:[StyleDressApp imageWithStyleNamed:@"PRSortBtn" ] ];
    [sortBarButtomItem setTarget:self];
    [sortBarButtomItem setAction:@selector(btnSortPressed)];
    [sortBarButtomItem setStyle:UIBarButtonItemStyleBordered];
    [sortBarButtomItem setWidth:40];
    
    [mainToolbar setItems:[NSArray arrayWithObjects:spaceBarButtom,sortBarButtomItem,nil]];

}

-(void) setToolbarItemsAll
{
    UIBarButtonItem *multiselectionBarButtomItem = [[UIBarButtonItem alloc]  init];
    [multiselectionBarButtomItem setImage:[StyleDressApp imageWithStyleNamed:@"PR1BtnMultiselection" ] ];
    [multiselectionBarButtomItem setTarget:self];
    [multiselectionBarButtomItem setAction:@selector(activateMultipleSelection)];
    [multiselectionBarButtomItem setStyle:UIBarButtonItemStyleBordered];
    [multiselectionBarButtomItem setWidth:40];
    
    UIBarButtonItem *spaceBarButtom = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *sortBarButtomItem = [[UIBarButtonItem alloc]  init];
    [sortBarButtomItem setImage:[StyleDressApp imageWithStyleNamed:@"PRSortBtn" ] ];
    [sortBarButtomItem setTarget:self];
    [sortBarButtomItem setAction:@selector(btnSortPressed)];
    [sortBarButtomItem setStyle:UIBarButtonItemStyleBordered];
    [sortBarButtomItem setWidth:40];
    
    [mainToolbar setItems:[NSArray arrayWithObjects:multiselectionBarButtomItem,spaceBarButtom,sortBarButtomItem,nil]];

}


-(void) btnSortShowNotesPressed
{
    
    BOOL sortShowNotesState = [[ [NSUserDefaults standardUserDefaults] objectForKey:@"showSortNotes"] boolValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!sortShowNotesState] forKey:@"showSortNotes"];

    if ( [[ [NSUserDefaults standardUserDefaults] objectForKey:@"showSortNotes"] boolValue] ==YES)
        [self.sortBarBtnItemShowNotes setTitle:NSLocalizedString(@"sortBtnTitleHide", @"") ];
    else
        [self.sortBarBtnItemShowNotes setTitle:NSLocalizedString(@"sortBtnTitleShow", @"") ];
        
    [self btnSortPressed];
    
}

-(IBAction) btnSortAscendingPressed
{
    
    BOOL sortAscendingState = [[ [NSUserDefaults standardUserDefaults] objectForKey:@"sortAscending"] boolValue];

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!sortAscendingState] forKey:@"sortAscending"];
    
    if ( [[ [NSUserDefaults standardUserDefaults] objectForKey:@"sortAscending"] boolValue] ==YES)
        [self.sortBarBtnAscending setImage:[StyleDressApp imageWithStyleNamed:@"PRSortDescending"] ];
    else
        [self.sortBarBtnAscending setImage:[StyleDressApp imageWithStyleNamed:@"PRSortAscending"] ];

    isSortNeeded=YES;
    
    [self btnSortPressed];

}

-(void)btnSortPressed
{
    NSInteger yOffsset=0;
    if (isChoosingPrendasForConjunto==YES) yOffsset=44;
 
    sortViewHiddenState=!sortViewHiddenState;
    UIView *thisView = [self.sortBarBtnItemShowNotes valueForKey:@"view"];
    CGFloat barButtonWidth = thisView? [thisView frame].size.width : (CGFloat)0.0;
    if (barButtonWidth<10) barButtonWidth=120;
    
    NSInteger labelSortPosX=6+barButtonWidth;
    NSInteger labelSortWidth=320-6-46-barButtonWidth;
    
    if (sortViewHiddenState==NO) //SHOW SORT VIEW
    {
        isSortNeeded=NO;
 
        UIView *emptyTitleView=[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        self.navigationItem.titleView=emptyTitleView;

        [self setToolbarItemsSort];
        [self.myTableViewTop setUserInteractionEnabled:NO];
        [self.myTableViewBottom setUserInteractionEnabled:NO];
        [self.myTableViewShoes setUserInteractionEnabled:NO];
        [self.myTableViewAccesories setUserInteractionEnabled:NO];

        //desactivo la interacción con boton de menu y botones de añadir prendas/camara
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [self.addTopPrenda setEnabled:NO];
        [self.addBottomPrenda setEnabled:NO];
        [self.addAccesoriesPrenda setEnabled:NO];
        [self.addShoesPrenda setEnabled:NO];

        [self.sortView setHidden:NO];
        [self.sortView setFrame:CGRectMake(0, 436+yOffsset, 320, 360)];
        [self.sortLabel setFrame :CGRectMake(labelSortPosX,372,labelSortWidth,44)];
        [self.sortLabel setAlpha:0.0];

        //Animate showSortView Entrance
        [UIView beginAnimations:@"ShowSortView" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationViewFinished:finished:context:)];
        [self.sortLabel setAlpha:1.0];
        [self.sortView setFrame:CGRectMake(0, 85+yOffsset+44, 320, 360-44)];
        [self.mainToolbar setFrame:CGRectMake(0, 85+yOffsset, 320, 44)];
        [self.sortLabel setFrame :CGRectMake(labelSortPosX,85+yOffsset,labelSortWidth,44)];
        [self.myTableViewTop setAlpha:0.5];
        [self.myTableViewBottom setAlpha:0.5];
        [self.myTableViewShoes setAlpha:0.5];
        [self.myTableViewAccesories setAlpha:0.5];
        [self.strip1ForegroundImageView setAlpha:0.2];
        [self.strip2ForegroundImageView setAlpha:0.2];
        [self.strip3ForegroundImageView setAlpha:0.2];
        [self.strip4ForegroundImageView setAlpha:0.2];

        [UIView commitAnimations];

    }else  //HIDE SORT VIEW
    {
        //Animate showSortView fadeOut
        [UIView beginAnimations:@"FadeOutSortView" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationViewFinished:finished:context:)];

        [self.sortView setAlpha:1];
        [self.sortLabel setAlpha:0.0];
         [self.sortView setFrame:CGRectMake(0, 436+yOffsset, 320, 360)];
        [self.mainToolbar setFrame:CGRectMake(0, 372+yOffsset, 320, 44)];
        [self.sortLabel setFrame:CGRectMake(labelSortPosX, 372+yOffsset, labelSortWidth, 44)];
        [self.myTableViewTop setAlpha:1.0];
        [self.myTableViewBottom setAlpha:1.0];
        [self.myTableViewShoes setAlpha:1.0];
        [self.myTableViewAccesories setAlpha:1.0];
        float alphaStripForeground=0.45;
        [self.strip1ForegroundImageView setAlpha:alphaStripForeground];
        [self.strip2ForegroundImageView setAlpha:alphaStripForeground];
        [self.strip3ForegroundImageView setAlpha:alphaStripForeground];
        [self.strip4ForegroundImageView setAlpha:alphaStripForeground];

        [UIView commitAnimations];

    }

}

- (void)animationViewFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    
    if ([animationID isEqualToString:@"FadeOutSortView"]) 
    {
        if (isChoosingPrendasForConjunto==NO)
            [self setToolbarItemsAll];
        else
            [self setToolbarItemsForConjuntoAll];
        
        [self.myTableViewTop setUserInteractionEnabled:YES];
        [self.myTableViewBottom setUserInteractionEnabled:YES];
        [self.myTableViewShoes setUserInteractionEnabled:YES];
        [self.myTableViewAccesories setUserInteractionEnabled:YES];
        
        
        [self.navigationItem.titleView setHidden:NO]; 
        [self addHeaderCenterView];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [self.addTopPrenda setEnabled:YES];
        [self.addBottomPrenda setEnabled:YES];
        [self.addAccesoriesPrenda setEnabled:YES];
        [self.addShoesPrenda setEnabled:YES];
        
        [self.sortView setHidden:NO];
    
    }
    [self.sortView setHidden:sortViewHiddenState];

    if (isSortNeeded==YES)
        [self updateScrollViews];  
    
    [self.sortTable reloadData];
    [self refreshTableViews];

}
 
 -(void)addHeaderCenterView
{
    
    //Add centerView
    UIButton *prendasButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prendasButton setFrame:CGRectMake(5, 5, 45, 30)];
    [prendasButton setImage:[StyleDressApp imageWithStyleNamed:@"HeaderIconPrendas"] forState:UIControlStateNormal];
    [prendasButton setTitle:@"Pre" forState:UIControlStateNormal];
    [prendasButton setHighlighted:YES];
    [prendasButton setUserInteractionEnabled:NO];

    UIButton *conjuntosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [conjuntosButton setFrame:CGRectMake(55, 5, 45, 30)];
    [conjuntosButton addTarget:self action:@selector(changeToConjuntosVC) forControlEvents:UIControlEventTouchUpInside];
    [conjuntosButton setImage:[StyleDressApp imageWithStyleNamed:@"HeaderIconConjuntos"] forState:UIControlStateNormal];
    [conjuntosButton setTitle:@"Con" forState:UIControlStateNormal];
    
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarButton setFrame:CGRectMake(105, 5, 45, 30)];
    [calendarButton addTarget:self action:@selector(changeToCalendarVC) forControlEvents:UIControlEventTouchUpInside];
    [calendarButton setImage:[StyleDressApp imageWithStyleNamed:@"HeaderIconCalendar"] forState:UIControlStateNormal];
    [calendarButton setTitle:@"Cal" forState:UIControlStateNormal];
    
    UIView *centerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150,40)];
    [centerView addSubview:prendasButton];
    [centerView addSubview:conjuntosButton];
    [centerView addSubview:calendarButton];
    
    self.navigationItem.titleView = centerView; 

    
   }

#pragma mark - Change to other VC's
-(void) changeToPrendasVC
{
    
}


-(void) changeToConjuntosVC
{
    [self.view setUserInteractionEnabled:YES];
    [self.delegate changeToVC:2];
    
}


-(void) changeToCalendarVC
{
    [self.view setUserInteractionEnabled:YES];
    [self.delegate changeToVC:3];
}


-(void) changeToProfileVC
{
    
    [self.view setUserInteractionEnabled:YES];
    [self.delegate changeToVC:5];
}


 
#pragma mark - ViewController flow 

 

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) cancelChoosingPrendaForConjunto
{
    multipleSelectionEnabled=NO;
    [self.delegateConjunto cancelChoosingPrendasForConjunto]; 
}

-(void) doneChoosingPrendaForConjunto
{
    multipleSelectionEnabled=NO;
    [self.delegateConjunto finishChoosingPrendasForConjunto:multipleSelectionPrendasArray]; 
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)activateMultipleSelection
{
    [self.view setUserInteractionEnabled:YES];
    
    //Cambio titleView por texto multiedicion
    UIFont *titleHeaderFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:26];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,160,32)];
    titleLabel.font=titleHeaderFont;
    titleLabel.text=NSLocalizedString(@"EditPrendas", @"");
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorPRHeader];
    self.navigationItem.titleView=titleLabel;

 
    //desactivo la interacción con boton de menu y botones de añadir prendas/camara
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
     [self.addTopPrenda setEnabled:NO];
    [self.addBottomPrenda setEnabled:NO];
    [self.addAccesoriesPrenda setEnabled:NO];
    [self.addShoesPrenda setEnabled:NO];
    
    [self.strip1ForegroundImageView setAlpha:0.2];
    [self.strip2ForegroundImageView setAlpha:0.2];
    [self.strip3ForegroundImageView setAlpha:0.2];
    [self.strip4ForegroundImageView setAlpha:0.2];
    
    //Cambio modo de selección a multipleSelection
    multipleSelectionEnabled=YES;
     
    //Inicializo array de prendas seleccionadas
    self.multipleSelectionPrendasArray= nil;
    self.multipleSelectionPrendasArray= [[NSMutableArray alloc] init ];
    
     
    //Defino imagen de botones "ok" y "cancel"
    UIBarButtonItem *multiselectionOKButtomItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(multipleSelectionAceptar)];

    UIBarButtonItem *multiselectionCancelButtomItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(multipleSelectionCancelar)];

    [mainToolbar setItems:[NSArray arrayWithObjects:multiselectionOKButtomItem,multiselectionCancelButtomItem,nil]];

    [self refreshTableViews];
    
}


-(void) multipleSelectionAceptar
{
    //Hability botones de la vista
    [self.navigationItem.titleView setHidden:NO]; 
    [self addHeaderCenterView];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.addTopPrenda setEnabled:YES];
    [self.addBottomPrenda setEnabled:YES];
    [self.addAccesoriesPrenda setEnabled:YES];
    [self.addShoesPrenda setEnabled:YES];

    float alphaStripForeground=0.45;
    [self.strip1ForegroundImageView setAlpha:alphaStripForeground];
    [self.strip2ForegroundImageView setAlpha:alphaStripForeground];
    [self.strip3ForegroundImageView setAlpha:alphaStripForeground];
    [self.strip4ForegroundImageView setAlpha:alphaStripForeground];
    
    //Create multipleSelection Item button
    [self setToolbarItemsAll];
    
    multipleSelectionEnabled=NO;
    
    if ([multipleSelectionPrendasArray count]>0) {
        
        self.prendasAlbumVC= [[PrendasAlbumViewController alloc] initWithNibName:@"PrendasAlbumViewController" bundle:[NSBundle mainBundle]];
        self.prendasAlbumVC.isMultiselection=YES;
        self.prendasAlbumVC.currentPage=0;
        self.prendasAlbumVC.prendasArray=multipleSelectionPrendasArray;
        self.prendasAlbumVC.delegate=self;
        self.prendasAlbumVC.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:self.prendasAlbumVC animated:YES];
        
    }
        
    [self refreshTableViews];

}

-(void) multipleSelectionCancelar
{
    //Hability botones de la vista
    [self.navigationItem.titleView setHidden:NO]; 
    [self addHeaderCenterView];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.addTopPrenda setEnabled:YES];
    [self.addBottomPrenda setEnabled:YES];
    [self.addAccesoriesPrenda setEnabled:YES];
    [self.addShoesPrenda setEnabled:YES];

    float alphaStripForeground=0.45;
    [self.strip1ForegroundImageView setAlpha:alphaStripForeground];
    [self.strip2ForegroundImageView setAlpha:alphaStripForeground];
    [self.strip3ForegroundImageView setAlpha:alphaStripForeground];
    [self.strip4ForegroundImageView setAlpha:alphaStripForeground];
    
    multipleSelectionEnabled=NO;
    
    //Create multipleSelection Item button
    [self setToolbarItemsAll];
    [self refreshTableViews];

}


-(void) popMainMenuViewController
{
    [self.view setUserInteractionEnabled:YES];

    if (!isRight) 
        [self.delegate moveMainViewToRight:YES];
    else
        [self.delegate moveMainViewToRight:NO];
    
    isRight = !isRight;
    
}

#pragma mark - prendaRequest - Create Prendas Array
-(void) prendaRequest
{
    
    if (self.prendasTopsArray!=nil)
        [prendasTopsArray removeAllObjects];
    if (self.prendasBottomsArray!=nil)
        [prendasBottomsArray removeAllObjects];
    if (self.prendasShoesArray!=nil)
        [prendasShoesArray removeAllObjects];
    if (self.prendasAccesoriesArray!=nil)
        [prendasAccesoriesArray removeAllObjects];
    
    self.prendasTopsArray=nil;
    self.prendasBottomsArray=nil;
    self.prendasShoesArray=nil;
    self.prendasAccesoriesArray=nil;
    
    //Init itemsArray
    self.prendasTopsArray= [[NSMutableArray alloc] init];
    self.prendasBottomsArray= [[NSMutableArray alloc] init];
    self.prendasShoesArray= [[NSMutableArray alloc] init];
    self.prendasAccesoriesArray= [[NSMutableArray alloc] init];
    
         
    
    //Lanzo consulta a la base de datos preguntando por las PRENDAS
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Prenda" inManagedObjectContext:self.managedObjectContext];
    
    
    //Con estas dos lineas puedo hacer que solo aparezcan las prendas del usuario registrado
    
    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        request.predicate = [NSPredicate predicateWithFormat:@"usuario==%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        request.predicate = [NSPredicate predicateWithFormat:@"(usuario = %@) OR (usuario = %@) OR (usuario = %@)",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ], DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
    
    NSArray *sortDescriptors;
    
    BOOL sortAscendingState = [[ [NSUserDefaults standardUserDefaults] objectForKey:@"sortAscending"] boolValue];
    
    if (sortType==sortTypeFecha) ///OK
    {
        //Ordeno por fechaCompra, que es cuando se sacó la foto, un timestamp
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fechaCompra" ascending:!sortAscendingState];
        sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    }else if (sortType==sortTypePrecio) ///OK
    {
        //Ordeno por fechaCompra, que es cuando se sacó la foto, un timestamp
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"precio" ascending:sortAscendingState  ];
        sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        
    }else {
        //Ordeno por defecto por fechaCompra, que es cuando se sacó la foto, un timestamp
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fechaCompra" ascending:!sortAscendingState];
        sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        
    }
    
    
    
    [request setSortDescriptors:sortDescriptors];
    
    
    //[request setPredicate: [NSPredicate predicateWithFormat:@"categoria == %@", myCategoria ] ];
    
    NSError *error = nil;
    
    
    //Ejecturo consulta de prendas para la categoria actual
    NSMutableArray *tempPrendasArray = [[NSMutableArray alloc] initWithArray:[self.managedObjectContext executeFetchRequest:request error:&error] ]; 
    
    //Creo un nuevo array "sortPrendasArray" a partir de tempPrendasArray
    NSMutableArray *sortPrendasArray=[[NSMutableArray alloc] init];
    for (Prenda *thisP in tempPrendasArray ) 
    {
        DataSortPrendas *sortPrenda=[[DataSortPrendas alloc] init];
        sortPrenda.sortPrenda=thisP;
        if (sortType==sortTypeCategoria)
            sortPrenda.sortDescriptorPrenda=thisP.subcategoria.descripcion;
        if (sortType==sortTypeMarca)  
            sortPrenda.sortDescriptorPrenda=thisP.marca.descripcion;
        if (sortType==sortTypeTemporada)
            sortPrenda.sortDescriptorPrenda=thisP.temporada.idTemporada;
        if (sortType==sortTypePrecio)
            sortPrenda.sortDescriptorPrenda=@"";
        if (sortType==sortTypeFecha)
            sortPrenda.sortDescriptorPrenda=@"";
        if (sortType==sortTypeComposicion)
        {
            NSString *composicionLocalizedKey= [NSString stringWithFormat:@"composition%d",[thisP.composicion intValue]]; 
            sortPrenda.sortDescriptorPrenda= [NSString stringWithFormat:@"%@", NSLocalizedString(composicionLocalizedKey, @"")];
        }
        [sortPrendasArray addObject:sortPrenda];
    }
    
    //Solo ordeno si no es por fecha o precio
    if ( !(sortType==sortTypeFecha || sortType==sortTypePrecio)) 
    {
        NSSortDescriptor *sortDataDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortDescriptorPrenda" ascending:sortAscendingState];
        NSArray *sortDataDescriptors = [[NSArray alloc] initWithObjects:&sortDataDescriptor count:1];
        
        [sortPrendasArray sortUsingDescriptors:sortDataDescriptors];
    }
    
    //Dependiendo del tipo de categoría, lo almaceno en su array correspondiente
    if ([sortPrendasArray count]>0 )
    {
        for (DataSortPrendas *thisSortPrendas in sortPrendasArray) 
        {
            Prenda *myPrenda=thisSortPrendas.sortPrenda;
            NSString *miCategoriaID=myPrenda.categoria.idCategoria;
            if ( [miCategoriaID isEqualToString:@"1"]) [prendasTopsArray addObject:myPrenda];        
            if ( [miCategoriaID isEqualToString:@"2"]) [prendasBottomsArray addObject:myPrenda];        
            if ( [miCategoriaID isEqualToString:@"3"]) [prendasShoesArray addObject:myPrenda];        
            if ( [miCategoriaID isEqualToString:@"4"]) [prendasAccesoriesArray addObject:myPrenda];        
        }
    }
    
    
    
    //Refresco tablas
    [self refreshTableViews];
    
    if ([prendasTopsArray count]<=0) 
        [labelParteArriba setHidden:NO];
    else
        [labelParteArriba setHidden:YES];
    
    if ([prendasBottomsArray count]<=0) 
        [labelParteAbajo setHidden:NO];
    else
        [labelParteAbajo setHidden:YES];
    
    if ([prendasShoesArray count]<=0) 
        [labelZapatos setHidden:NO];
    else 
        [labelZapatos setHidden:YES];
    
    if ([prendasAccesoriesArray count]<=0) 
        [labelComplementos setHidden:NO];
    else
        [labelComplementos setHidden:YES];
    
    
}

-(void) refreshTableViews
{
    [myTableViewTop reloadData];
    [myTableViewBottom reloadData];
    [myTableViewShoes reloadData];
    [myTableViewAccesories reloadData];
    
    if ([myTableViewTop numberOfRowsInSection:0] <4) 
        [myTableViewTop setContentInset:UIEdgeInsetsMake((4-[myTableViewTop numberOfRowsInSection:0])*64, 0, 64, 0)];
    else
        [myTableViewTop setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];

    
    if ([myTableViewBottom numberOfRowsInSection:0] <4) 
        [myTableViewBottom setContentInset:UIEdgeInsetsMake((4-[myTableViewBottom numberOfRowsInSection:0])*64, 0, 64, 0)];
    else
        [myTableViewBottom setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];

    
    if ([myTableViewShoes numberOfRowsInSection:0] <4) 
        [myTableViewShoes setContentInset:UIEdgeInsetsMake((4-[myTableViewShoes numberOfRowsInSection:0])*64, 0, 64, 0)];
    else
        [myTableViewShoes setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];

    
    if ([myTableViewAccesories numberOfRowsInSection:0] <4) 
        [myTableViewAccesories setContentInset:UIEdgeInsetsMake((4-[myTableViewAccesories numberOfRowsInSection:0])*64, 0, 64, 0)];
    else
        [myTableViewAccesories setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];

    
    if (!multipleSelectionEnabled) 
        [self scrollTableViewsToBottom];
    
}

-(void) scrollTableViewsToBottom
{
    if ([myTableViewTop numberOfRowsInSection:0] >0)
        [myTableViewTop scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[myTableViewTop numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    if ([myTableViewBottom numberOfRowsInSection:0] >0)
        [myTableViewBottom scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[myTableViewBottom numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    if ([myTableViewShoes numberOfRowsInSection:0] >0)
        [myTableViewShoes scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[myTableViewShoes numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    if ([myTableViewAccesories numberOfRowsInSection:0] >0)
        [myTableViewAccesories scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[myTableViewAccesories numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    
}


#pragma mark -
#pragma mark TableViewDelegate methods


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    
    if (tableView==myTableViewTop) 
        numberOfRows=[prendasTopsArray count];
    else if (tableView==myTableViewBottom) 
        numberOfRows=[prendasBottomsArray count];
    else if (tableView==myTableViewShoes) 
        numberOfRows=[prendasShoesArray count];
    else if (tableView==myTableViewAccesories) 
        numberOfRows=[prendasAccesoriesArray count];
    else if (tableView==sortTable)
        numberOfRows=6;
    else return 0;
    
    return numberOfRows;
}


-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==myTableViewTop || tableView==myTableViewBottom || tableView==myTableViewShoes || tableView==myTableViewAccesories ) 
        return 64; //Realmente este es el ancho de la imagen!!
    else if (tableView==sortTable )
        return 36;
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==myTableViewTop || tableView==myTableViewBottom || tableView==myTableViewShoes || tableView==myTableViewAccesories ) 
    {
        static NSString *cellIdentifier = @"thisCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
            
            
            //[cell set
            UIImageView *cellImage= [[UIImageView alloc] init];
            cellImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
            cellImage.frame=CGRectMake(8, 5, 72, 54);
            cellImage.tag=1;
            [cellImage setContentMode:UIViewContentModeScaleAspectFit];
            
            [cell addSubview:cellImage];
            
            UIImageView *cellCheckboxImage= [[UIImageView alloc] init];
            cellCheckboxImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
            cellCheckboxImage.frame=CGRectMake(58, 3, 27, 25);
            cellCheckboxImage.tag=2;
            [cell addSubview:cellCheckboxImage];
            
            UIView *sortNoteImage= [[UIView alloc] init];
            sortNoteImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
            sortNoteImage.frame=CGRectMake(65, 60, 18, -55);
            sortNoteImage.backgroundColor=[StyleDressApp colorWithStyleForObject:StyleColorSortNotesBackground];
            sortNoteImage.tag=3;
            [cell addSubview:sortNoteImage];

           
            UIFont *myFontDescription= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:10];
            UILabel *sortNoteText=[[UILabel alloc] initWithFrame:CGRectMake(58, 60, 60, 12)];
            sortNoteText.transform = CGAffineTransformMakeRotation(-M_PI_2);
            sortNoteText.frame=CGRectMake(65, 57, 18, -52);
            sortNoteText.font=myFontDescription;
            sortNoteText.tag=4;
            sortNoteText.textAlignment=UITextAlignmentCenter;
            sortNoteText.backgroundColor=[UIColor clearColor];
            sortNoteText.textColor=[StyleDressApp colorWithStyleForObject:StyleColorSortNotesCellText];
            [cell addSubview:sortNoteText];
         
        }
        
        
        if (multipleSelectionEnabled)
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        else
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        
        UIImageView *cellImage= (UIImageView*)[cell viewWithTag:1];
        UIImageView *cellCheckboxImage= (UIImageView*)[cell viewWithTag:2];
        UIView *sortNoteImage= (UIView*)[cell viewWithTag:3];
        UILabel *sortNoteText= (UILabel*)[cell viewWithTag:4];
        
        
        NSInteger rowIndex=indexPath.row;
        
        rowIndex=[tableView numberOfRowsInSection:indexPath.section] -indexPath.row-1;
        
        //Get Prenda data of current Prenda
        Prenda *prenda;
        
        if (tableView==myTableViewTop)
            prenda= [ prendasTopsArray  objectAtIndex:rowIndex];  //-1
        else if (tableView==myTableViewBottom)
            prenda= [ prendasBottomsArray  objectAtIndex:rowIndex];
        else if (tableView==myTableViewShoes)
            prenda= [ prendasShoesArray  objectAtIndex:rowIndex];
        else if (tableView==myTableViewAccesories)
            prenda= [ prendasAccesoriesArray  objectAtIndex:rowIndex];
        
        
        //if ([self.sortBtnShowNotes isSelected])
        if ( [[ [NSUserDefaults standardUserDefaults] objectForKey:@"showSortNotes"] boolValue] ==YES)
        {
            
            cellCheckboxImage.frame=CGRectMake(8, 3, 27, 25);
            
            NSString *noteText;
            
            if (sortType==sortTypeMarca)
                noteText=prenda.marca.descripcion;
            if (sortType==sortTypeCategoria)
                noteText=prenda.subcategoria.descripcion;
            if (sortType==sortTypeFecha)
            {   
                NSDateFormatter *myDateFormat= [[NSDateFormatter alloc] init] ;
                NSLocale *myLocale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"locale", @"")];
                [myDateFormat setLocale: myLocale] ;
                [myDateFormat setDateStyle:NSDateFormatterShortStyle]; //
                noteText = [myDateFormat stringFromDate:prenda.fechaCompra];    
            }
            if (sortType==sortTypePrecio)
                noteText=[NSString stringWithFormat:@"%d", [prenda.precio intValue]];
            if (sortType==sortTypeTemporada)
                noteText=prenda.temporada.descripcion;
            if (sortType==sortTypeComposicion)
            {
                NSString *composicionLocalizedKey= [NSString stringWithFormat:@"composition%d",[prenda.composicion intValue]]; 
                noteText= [NSString stringWithFormat:@"%@", NSLocalizedString(composicionLocalizedKey, @"")];
            }
            [sortNoteImage setHidden:NO];
            sortNoteText.text=noteText;
        }
        else
        {
            cellCheckboxImage.frame=CGRectMake(58, 3, 27, 25);
            [sortNoteImage setHidden:YES];
            sortNoteText.text=@"";
        }
        
        if (multipleSelectionEnabled) 
        {
            if ([multipleSelectionPrendasArray containsObject:prenda]) 
            {
                [cellCheckboxImage setImage:[StyleDressApp imageWithStyleNamed:@"PRMultiselectionCheckboxON"]];
                
            }else
            {
                [cellCheckboxImage setImage:[StyleDressApp imageWithStyleNamed:@"PRMultiselectionCheckboxOFF"]];
                
            }
            
        }
        else
            [cellCheckboxImage setImage:nil];
        
        //Recupero imagen del disco
        NSString *urlPicture= prenda.urlPicture;
        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",urlPicture] ]; 
        if ( [fileManager fileExistsAtPath:imagePath] ) 
            cellImage.image= [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath] ];
        
        
        //cell.imageView.image
        return cell;

    }else if (tableView==sortTable)
    {
        static NSString *filterCellIdentifier = @"filterCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:filterCellIdentifier];
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:filterCellIdentifier] ;
            
            UIFont *myFontDescription= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:18];
            UILabel *labelDescription=[[UILabel alloc] initWithFrame:CGRectMake(10,0,180,32)];
            labelDescription.font=myFontDescription;
            labelDescription.tag=1;
            labelDescription.textAlignment=UITextAlignmentLeft;
            labelDescription.backgroundColor=[UIColor clearColor];
            labelDescription.textColor=[StyleDressApp colorWithStyleForObject:StyleColorSortCellText];
            
            [cell addSubview:labelDescription];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            
        }
        
        
        if (indexPath.row!=0)
        {
            
            if ([StyleDressApp getStyle] == StyleTypeVintage )
            {
                UIView *myLineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,1)];
                [myLineViewBottom setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRCategoriaCellSeparatorLine ]];
                [cell.contentView addSubview:myLineViewBottom];
                
            }else if ([StyleDressApp getStyle] == StyleTypeModern )
            {
                UIView *myLineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,1)];
                [myLineViewBottom setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRCategoriaCellSeparatorLine ]];
                [cell.contentView addSubview:myLineViewBottom];
                
            }else
            {
                UIImageView *myLineViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,1)];
                [myLineViewBottom setImage:[StyleDressApp imageWithStyleNamed:@"CODetailCategoriaTableCellSeparator"] ];
                [cell.contentView addSubview:myLineViewBottom];
                
            }
            
        }

        UILabel *labelDescription= (UILabel*) [cell viewWithTag:1];
        labelDescription.text=[NSString stringWithFormat:@"Fila %d",indexPath.row];
        
        NSString *filterKey= [NSString stringWithFormat:@"sortTitle%d",indexPath.row];
        labelDescription.text= [NSString stringWithFormat:@"%@", NSLocalizedString(filterKey, @"")];

        if (indexPath.row==sortType) 
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else
            [cell setAccessoryType:UITableViewCellAccessoryNone];

        return cell;
        
    }
    
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView==myTableViewTop || tableView==myTableViewBottom || tableView==myTableViewShoes || tableView==myTableViewAccesories ) 
    {
        Prenda *thisPrenda;
        
        NSInteger rowIndex=[tableView numberOfRowsInSection:indexPath.section] -indexPath.row-1;
        
        if (multipleSelectionEnabled) 
        {
            if (tableView==myTableViewTop)
            {
                thisPrenda= [ prendasTopsArray  objectAtIndex:rowIndex];  //-1
            }else if (tableView==myTableViewBottom)
            {
                thisPrenda= [ prendasBottomsArray  objectAtIndex:rowIndex];
            }else if (tableView==myTableViewShoes)
            {
                thisPrenda= [ prendasShoesArray  objectAtIndex:rowIndex];
            }else if (tableView==myTableViewAccesories)
            {
                thisPrenda= [ prendasAccesoriesArray  objectAtIndex:rowIndex];
            }
            
            if (![multipleSelectionPrendasArray containsObject:thisPrenda]) 
            {
                [multipleSelectionPrendasArray addObject:thisPrenda];
                [self refreshTableViews];
            }else
            {
                [multipleSelectionPrendasArray removeObject:thisPrenda];
                [self refreshTableViews];
            }
            
        } 
        
        return indexPath;

    }else
        return indexPath;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==myTableViewTop || tableView==myTableViewBottom || tableView==myTableViewShoes || tableView==myTableViewAccesories ) 
    {
       
        if (multipleSelectionEnabled) 
        {
            
            
        }else
        {
            Prenda *thisPrenda;
            
            NSInteger rowIndex=[tableView numberOfRowsInSection:indexPath.section] -indexPath.row-1;
            
            if(didSelectRow==NO)
            {
                didSelectRow=YES;
                
                if (tableView==myTableViewTop)
                {
                    thisPrenda= [ prendasTopsArray  objectAtIndex:rowIndex];  //-1
                }else if (tableView==myTableViewBottom)
                {
                    thisPrenda= [ prendasBottomsArray  objectAtIndex:rowIndex];
                }else if (tableView==myTableViewShoes)
                {
                    thisPrenda= [ prendasShoesArray  objectAtIndex:rowIndex];
                }else if (tableView==myTableViewAccesories)
                {
                    thisPrenda= [ prendasAccesoriesArray  objectAtIndex:rowIndex];
                }
                
                [self openAlbumWithCategory:thisPrenda.categoria.idCategoria andPrenda:thisPrenda];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }else if (tableView ==sortTable)
    {
        //Es necesario llamar a updateScrollviews y reordenar todo
        isSortNeeded=YES;
        
        sortType=indexPath.row;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:sortType] forKey:@"sortType"];
        [self.sortTable deselectRowAtIndexPath:indexPath animated:YES];
        [self btnSortPressed];
        
        
    }

    
}

 



-(void) addNewPrendaWithCategory:(NSString*)categ;
{
    [myActivityView startAnimating];

    [self.navigationController popViewControllerAnimated:YES];
    
    if ([categ isEqualToString:@"1"])
        [self performSelector:@selector(openCamaraModalView:) withObject:addTopPrenda afterDelay:0.05];
    else if ([categ isEqualToString:@"2"])
        [self performSelector:@selector(openCamaraModalView:) withObject:addBottomPrenda afterDelay:0.05];
    else if ([categ isEqualToString:@"3"])
        [self performSelector:@selector(openCamaraModalView:) withObject:addShoesPrenda afterDelay:0.05];
    else if ([categ isEqualToString:@"4"])
        [self performSelector:@selector(openCamaraModalView:) withObject:addAccesoriesPrenda afterDelay:0.05];

}

 

#pragma mark - UIImagePickerController- Activates Camera
-(IBAction)addPrenda:(UIButton*)myButton
{
    
    [myActivityView startAnimating];

    [self performSelector:@selector(openCamaraModalView:) withObject:myButton afterDelay:0.05];
    
}

-(void) openCamaraModalView: (UIButton*) myButton
{
     
    //Add segmentedControl to cameraOverlayView
    NSArray *segmentedControlItems= [ NSArray  arrayWithObjects:@"Top",@"Botton",@"Shoes",@"Access.", nil];
    cameraSegmentedControl = [[UISegmentedControl alloc]  initWithItems:segmentedControlItems];
    [cameraSegmentedControl setBackgroundColor:[UIColor clearColor]];
    [cameraSegmentedControl setImage:[StyleDressApp imageWithStyleNamed:@"PRCameraCategoria1"] forSegmentAtIndex:0];
    [cameraSegmentedControl setImage:[StyleDressApp imageWithStyleNamed:@"PRCameraCategoria2"] forSegmentAtIndex:1];
    [cameraSegmentedControl setImage:[StyleDressApp imageWithStyleNamed:@"PRCameraCategoria3"] forSegmentAtIndex:2];
    [cameraSegmentedControl setImage:[StyleDressApp imageWithStyleNamed:@"PRCameraCategoria4"] forSegmentAtIndex:3];
    [cameraSegmentedControl setFrame:CGRectMake(10,10,300,44)];
    [cameraSegmentedControl setSelectedSegmentIndex:[myButton tag]-51];
    [cameraSegmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar]; //Bar
    [cameraSegmentedControl setTintColor:[UIColor lightGrayColor]];
    [cameraSegmentedControl setAlpha:0.5];
    [cameraSegmentedControl addTarget:self action:@selector(changeCameraSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    
    //Set default values for segmentedControl
    if (myButton==nil) 
    {
        [cameraSegmentedControl setSelectedSegmentIndex:0];
        [self changeCameraOverlayPicture:0];  //0
    }else
    {   
        [cameraSegmentedControl setSelectedSegmentIndex:[myButton tag]-51];
        [self changeCameraOverlayPicture:[myButton tag]-51];  //Tags 51 52 53 54
    }
    
        
    //Si la camara está disponible
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) 
    {
        photoType=PhotoTypeCamera;
        
        self.cameraImagePicker=nil;
        self.cameraImagePicker = [[PortraitImagePickerController alloc] init];
        self.cameraImagePicker.delegate = self;
        [cameraImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        //overlay image (cannot dynamically switch from vertical to horizontal in here)
        UIView *cameraOverlayView= [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
        
        
        
        //My Camera Toolbar
        UIToolbar *myCameraToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,425,320,55)];
        [myCameraToolBar  setTintColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainToolBar] ];
        
        //My Camera Toolbar Cancel
        UIBarButtonItem *myCameraCancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCameraImagePicker)];
        
        //My Camera Toolbar TakePicture  
        UIButton *myCameraTakePictureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,100,43)];
        [myCameraTakePictureButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        [myCameraTakePictureButton setImage:[StyleDressApp imageWithStyleNamed:@"PRCameraTakePicture"] forState:UIControlStateNormal] ;
        UIBarButtonItem *myCameraTakePictureBarButton = [[UIBarButtonItem alloc] initWithCustomView:myCameraTakePictureButton];
        
        //My Camera photoLibrary Button
        UIBarButtonItem *photoLibraryBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"PhotoLibrary", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(openPhotoLibrary) ];
        
        
        //My Camera Toolbar addItems to Toolbar  
        NSArray *items=[NSArray arrayWithObjects:
                        myCameraCancelBarButton,
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil] ,
                        myCameraTakePictureBarButton,
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil] ,
                        photoLibraryBarButton,
                        nil];
        [myCameraToolBar setItems:items];
        
        
        //Create UIActivityView
        cameraActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [cameraActivityView setFrame:CGRectMake(141,180,31,31)];
        [cameraActivityView setHidesWhenStopped:YES];
        [cameraActivityView stopAnimating];
        [cameraOverlayView addSubview:cameraActivityView];
        
        
        //My Camera View addToolbar  
        //[cameraImagePicker.view addSubview:myCameraToolBar];
        [cameraOverlayView addSubview:myCameraToolBar];
        
        
        //La imagen de fondo no ocupa el 100% de la pantalla, dejo un 5% de borde
        CGFloat borderPercentage=5;
        CGFloat widthWithOffset=320*(1-2*borderPercentage/100);
        CGFloat heightWithOffset=widthWithOffset*436./320.;
        CGFloat borderOffsetX= 320.*borderPercentage/100.;
        CGFloat borderOffsetY=(436- heightWithOffset)/2;
        
        //Add camara View
        self.camaraPrendaView= [[UIImageView alloc] initWithFrame:CGRectMake(borderOffsetX, borderOffsetY, widthWithOffset,heightWithOffset)];            
        
        
  
        [cameraOverlayView addSubview:cameraSegmentedControl];
        
        [cameraOverlayView addSubview:camaraPrendaView];
        
        //Set default values for segmentedControl
        if (myButton==nil) 
        {
            [cameraSegmentedControl setSelectedSegmentIndex:0];
            [self changeCameraOverlayPicture:0];  //0
        }else
        {   
            [cameraSegmentedControl setSelectedSegmentIndex:[myButton tag]-51];
            [self changeCameraOverlayPicture:[myButton tag]-51];  //Tags 51 52 53 54
        }

    
        //Camera settings
        self.cameraImagePicker.showsCameraControls=NO;
        
        //cameraImagePicker.allowsEditing=YES;
        self.cameraImagePicker.cameraOverlayView = cameraOverlayView;
        
        [self presentModalViewController:self.cameraImagePicker animated:YES];
        
    }
    else
        [self openPhotoLibrary];
    
}


- (BOOL)_isSupportedInterfaceOrientation:(UIDeviceOrientation)orientation
{
    return UIDeviceOrientationIsPortrait(orientation);
 
}

-(void) changeCameraOverlayPicture:(NSInteger) selectedPrendaIndex
{
    
    NSString *currentCategoria=[NSString stringWithFormat:@"%d",selectedPrendaIndex+1];

    if (selectedPrendaIndex  ==0) 
        camaraPrendaView.image = [StyleDressApp imageWithStyleNamed:@"PRCameraTop"];            
    if (selectedPrendaIndex  ==1) 
        camaraPrendaView.image = [StyleDressApp imageWithStyleNamed:@"PRCameraBottom"];            
    if (selectedPrendaIndex  ==2) 
        camaraPrendaView.image = [StyleDressApp imageWithStyleNamed:@"PRCameraShoes"];            
    if (selectedPrendaIndex  ==3) 
        camaraPrendaView.image = [StyleDressApp imageWithStyleNamed:@"PRCameraAccessories"];            
    
    //GET PrendaCategoria Array
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"PrendaCategoria" inManagedObjectContext:self.managedObjectContext]];
    fetchRequest.predicate =[NSPredicate predicateWithFormat:@"idCategoria == %@",currentCategoria];
	NSError *error = nil;
	NSArray *prendaCategoriasArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([prendaCategoriasArray count]>0) 
        self.myPrendaCategoria= [prendaCategoriasArray objectAtIndex:0];
}

-(void) changeCameraSegmentedControl:(UISegmentedControl*)thisSegmentedControl;
{
    [self changeCameraOverlayPicture:[thisSegmentedControl selectedSegmentIndex]];
    
}

-(void) takePicture
{
    [cameraActivityView startAnimating];
    [self.cameraImagePicker takePicture];
}

-(void) cancelCameraImagePicker
{
    [myActivityView stopAnimating];    
    [self dismissModalViewControllerAnimated:YES];
    [self updateScrollViews];
}


-(void) openPhotoLibrary
{
    
    photoType=PhotoTypeLibrary;
    [self dismissModalViewControllerAnimated:NO];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [self presentModalViewController:imagePicker animated:YES];
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

#pragma mark - UIImagePicker delegates

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [myActivityView stopAnimating];
    [self dismissModalViewControllerAnimated:YES];    
}

 
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:NO];
    [myActivityView stopAnimating];
    
    //original picture
    UIImage *pickedImage = [ info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (pickedImage.imageOrientation==0) //Right
        pickedImage = [[UIImage alloc] initWithCGImage: pickedImage.CGImage
                scale: 1.0 orientation: UIImageOrientationRight];
    else if (pickedImage.imageOrientation==1) //Left
    
        pickedImage = [[UIImage alloc] initWithCGImage: pickedImage.CGImage
                scale: 1.0 orientation: UIImageOrientationRight];
    else if (pickedImage.imageOrientation==2) //UpsideDown
        pickedImage = [[UIImage alloc] initWithCGImage: pickedImage.CGImage
                                                 scale: 1.0
                                           orientation: UIImageOrientationRight];
    
    PreviewImagePicker *previewImageVC= [[PreviewImagePicker alloc] initWithNibName:@"PreviewImagePicker" bundle:[NSBundle mainBundle] ];
    [previewImageVC setPreviewCameraImage:pickedImage];
    [previewImageVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [previewImageVC setDelegate:self];
    [self presentModalViewController:previewImageVC animated:NO];

}


-(void) previewRetakePicture
{
    [UIApplication sharedApplication].statusBarHidden=NO;
    [self dismissModalViewControllerAnimated:NO];
    [self openCamaraModalView:nil];
}

-(void) previewDidFinishWithImage:(UIImage *)previewImage

{
    [UIApplication sharedApplication].statusBarHidden=NO;
    [self dismissModalViewControllerAnimated:YES];
        
    //reduce image size
    UIImage *reducedImage = previewImage;
    UIImage *thumbnailImage=[self createThumbnailFromImage:reducedImage withSize:PIC_SIZE_SMALL];
    
    //Elijo el tipo de subCategoria de la base de datos, elijo 0 por defecto
    PrendaSubCategoria *prendaSubCategoria = nil;
    NSFetchRequest *requestSubCategoria = [[NSFetchRequest alloc] init];
    requestSubCategoria.entity = [NSEntityDescription entityForName:@"PrendaSubCategoria" inManagedObjectContext:self.managedObjectContext];
    requestSubCategoria.predicate =[NSPredicate
                                    predicateWithFormat:@"(idSubcategoria == %@) AND (categoriaID == %@)",
                                    @"0", myPrendaCategoria.idCategoria];
    NSError *error = nil;
    prendaSubCategoria = [[self.managedObjectContext executeFetchRequest:requestSubCategoria error:&error] lastObject];
    
    
    //Elijo la marca de itemMarca de la base de datos, elijo Other por defecto, marca=0
    PrendaMarca *prendaMarca = nil;
    NSFetchRequest *requestMarca = [[NSFetchRequest alloc] init];
    requestMarca.entity = [NSEntityDescription entityForName:@"PrendaMarca" inManagedObjectContext:self.managedObjectContext];
   
        
    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        requestMarca.predicate =[NSPredicate predicateWithFormat:@"(idMarca == %@) AND (usuario == %@)",@"0", [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        requestMarca.predicate =[NSPredicate predicateWithFormat:@"(idMarca == %@) AND ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )",@"0", [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"] ];
    
        
    NSError *errorMarca = nil;
    prendaMarca = [[self.managedObjectContext executeFetchRequest:requestMarca error:&errorMarca] lastObject];
    
    
    //GET PrendaTemporada Array
    NSFetchRequest *requestTemporada = [[NSFetchRequest alloc] init];
	[requestTemporada setEntity:[NSEntityDescription entityForName:@"PrendaTemporada" inManagedObjectContext:self.managedObjectContext]];
    requestTemporada.predicate =[NSPredicate predicateWithFormat:@"idTemporada == %@",@"0"];
	NSError *errorTemporada = nil;
	PrendaTemporada *myPrendaTemporada = [[self.managedObjectContext executeFetchRequest:requestTemporada error:&errorTemporada] objectAtIndex:0];
    
    //GET PrendaEstado Array
    NSFetchRequest *requestEstado = [[NSFetchRequest alloc] init];
	[requestEstado setEntity:[NSEntityDescription entityForName:@"PrendaEstado" inManagedObjectContext:self.managedObjectContext]];
    requestEstado.predicate =[NSPredicate predicateWithFormat:@"idEstado == %@",@"0"];
 	NSError *errorEstado = nil;
	PrendaEstado *myPrendaEstado = [[self.managedObjectContext executeFetchRequest:requestEstado error:&errorEstado] objectAtIndex:0];
    
    //Genero un nombre para el item, basado en timeIntervalSince1970
    NSString *itemName= [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];

        
    NSString *idPrendaDispositivoSH1= [Authenticacion getSH1ForUser:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] andIdentifier:itemName];

    NSDictionary *prendaDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      
                                      [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"username",
                                      @"",@"descripcion",
                                      itemName,@"idPrenda",
                                      idPrendaDispositivoSH1,@"idPrendaDispositivo",
                                      itemName,@"urlPicture",
                                      @"",@"urlPictureServer",
                                      [NSDate date],@"fecha",
                                      @"",@"notas",
                                      [NSNumber numberWithFloat:0],@"precio",
                                      [NSNumber numberWithFloat:1],@"rating",
                                      [NSNumber numberWithInteger:0],@"talla1",
                                      [NSNumber numberWithInteger:0],@"talla2",
                                      [NSNumber numberWithInteger:0],@"talla3",
                                      [NSString stringWithFormat:@""],@"tag1",
                                      [NSString stringWithFormat:@""],@"tag2",
                                      [NSString stringWithFormat:@""],@"tag3",
                                      [NSNumber numberWithInteger:1],@"composicion",
                                      myPrendaCategoria, @"categoria",
                                      prendaSubCategoria,@"subcategoria",
                                      myPrendaTemporada,@"temporada",
                                      myPrendaEstado,@"estado",
                                      @"",@"color",
                                      @"",@"tienda",
                                      [NSNumber numberWithBool:YES],@"needsSynchronize",
                                      [NSNumber numberWithBool:YES],@"firstBackup",
                                      @"YES",@"restoreFinished",
                                      prendaMarca,@"marca", 
                                      nil] ;
    
        //Creo nuevo item en la base de datos
    Prenda *prenda= [Prenda prendaWithData:prendaDictionary inManagedObjectContext:self.managedObjectContext overwriteObject:NO];
    
    if (prenda!=nil) 
    {
        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",prenda.urlPicture] ]; 
        NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",prenda.urlPicture] ]; 

        NSData *data = [[NSData alloc] initWithData: UIImagePNGRepresentation(reducedImage) ];
        NSData *dataSmall = [[NSData alloc] initWithData: UIImagePNGRepresentation (thumbnailImage) ];
        
        //Si no existe la foto, la creo en el disco
        //Write original picture
        if ( ![fileManager fileExistsAtPath:imagePath] ) 
            [data writeToFile:imagePath atomically:YES];
        
        //Write Thumbnail
        if ( ![fileManager fileExistsAtPath:imagePathSmall] ) 
            [dataSmall writeToFile:imagePathSmall atomically:YES];
        
    }
    
    
    //Salvo datos en database
    NSError *errorSave = nil;
    if (![self.managedObjectContext save:&errorSave])
    	NSLog(@"Unresolved error %@, %@", errorSave, [errorSave userInfo]);
    
    [self updateScrollViews];
    
    //Si acabo la foto y estoy en conjunto, mantengo los checkboxes
    if (isChoosingPrendasForConjunto) 
        [self scrollTableViewsToBottom];
        
    
}


#pragma mark - PrendaDetailViewController delegates

 
-(void) prendaDetailVCDeletePrenda:(Prenda *)prenda
{
    [self updateScrollViews];
    
}

-(void) updateScrollViewsFromPrendaDetailAlbum
{
    [self updateScrollViews];
}

 
-(void) updateScrollViews
{
 
    [self.loadingView setHidden:NO];
    [self.loadingLabel setText:NSLocalizedString(@"loading",@"")];
    [self.loadingImageView setImage:[StyleDressApp imageWithStyleNamed:@"Activity"]]; 

    [self prendaRequest];
 
    [myActivityView stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    [self.loadingView setHidden:YES];

}
 


-(void)openAlbumWithCategory:(NSString*)currentCategoria andPrenda:(Prenda*)myPrenda
{
     
    NSMutableArray *thisArray;
    self.prendasAlbumVC= [[PrendasAlbumViewController alloc] initWithNibName:@"PrendasAlbumViewController" bundle:[NSBundle mainBundle]];
    self.prendasAlbumVC.isMultiselection=NO;
    self.prendasAlbumVC.delegate=self;
    self.prendasAlbumVC.managedObjectContext=self.managedObjectContext;
    
    if ( [currentCategoria isEqualToString:@"1"]) 
    {
        thisArray=[[NSMutableArray alloc] initWithArray:prendasTopsArray];
        self.prendasAlbumVC.currentPage=[prendasTopsArray indexOfObject:myPrenda];

    }else if ( [currentCategoria isEqualToString:@"2"]) 
    {
        thisArray=[[NSMutableArray alloc] initWithArray:prendasBottomsArray];
        self.prendasAlbumVC.currentPage=[prendasBottomsArray indexOfObject:myPrenda];
        
    }else if ( [currentCategoria isEqualToString:@"3"])
    {
        thisArray=[[NSMutableArray alloc] initWithArray:prendasShoesArray];
        self.prendasAlbumVC.currentPage=[prendasShoesArray indexOfObject:myPrenda];
        
    }else if ( [currentCategoria isEqualToString:@"4"]) 
    {
        thisArray=[[NSMutableArray alloc] initWithArray:prendasAccesoriesArray];
        self.prendasAlbumVC.currentPage=[prendasAccesoriesArray indexOfObject:myPrenda];
    }
    self.prendasAlbumVC.prendasArray=thisArray;
    [self.navigationController pushViewController:self.prendasAlbumVC animated:YES];

}


#pragma mark - Create coreData MainTables
-(void) createCoreDataMainTables
{
    //Define Marcas Master
    //Abro el plist de marcas
    NSString *marcasArrayBundle = [[NSBundle mainBundle]pathForResource:@"marcasMaster" ofType:@"plist"];
    NSMutableDictionary *dicMarcas = [[NSMutableDictionary alloc] initWithContentsOfFile: marcasArrayBundle];
    
    NSArray *marcasItemsArray= [[ NSArray alloc ] initWithArray:[dicMarcas objectForKey:@"Items"] ];
    
    for (int j=0; j<[marcasItemsArray count];j++) 
    {
        
        NSDictionary *attributesMarca = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          [[marcasItemsArray objectAtIndex:j] objectForKey:@"isAtletica"],@"isAtletica",
                                         [[marcasItemsArray objectAtIndex:j] objectForKey:@"isClasica"],@"isClasica",
                                         [[marcasItemsArray objectAtIndex:j] objectForKey:@"isFashion"],@"isFashion",
                                         [[marcasItemsArray objectAtIndex:j] objectForKey:@"isHippie"],@"isHippie",
                                         [[marcasItemsArray objectAtIndex:j] objectForKey:@"isVanguardista"],@"isVanguardista",
                                         [[marcasItemsArray objectAtIndex:j] objectForKey:@"isRomantica"],@"isRomantica",
                                         nil] ;

        
        Marcas *newMarca= [Marcas marcaWithID:[[marcasItemsArray objectAtIndex:j] objectForKey:@"id"] descripcion:[[marcasItemsArray objectAtIndex:j] objectForKey:@"name"] withAttributes:attributesMarca inManagedObjectContext:self.managedObjectContext];
        
    }
    
    
    //Define conjunto categories
    [ConjuntoCategoria conjuntoCategoriaWithID:@"0"  withDescripcion:NSLocalizedString(@"Casual","")  withOrder:0  inManagedObjectContext:self.managedObjectContext];
    [ConjuntoCategoria conjuntoCategoriaWithID:@"1"  withDescripcion:NSLocalizedString(@"Trabajo","")  withOrder:1  inManagedObjectContext:self.managedObjectContext];
    [ConjuntoCategoria conjuntoCategoriaWithID:@"2"  withDescripcion:NSLocalizedString(@"Fiesta","")  withOrder:2  inManagedObjectContext:self.managedObjectContext];
    [ConjuntoCategoria conjuntoCategoriaWithID:@"3"  withDescripcion:NSLocalizedString(@"Sport","")  withOrder:3  inManagedObjectContext:self.managedObjectContext];
    [ConjuntoCategoria conjuntoCategoriaWithID:@"4"  withDescripcion:NSLocalizedString(@"Otros","")  withOrder:4  inManagedObjectContext:self.managedObjectContext];
    
    
    //Define main Prendas categories
    [PrendaCategoria categoriaWithID:@"0" descripcion:NSLocalizedString(@"categoria0", @"") inManagedObjectContext:self.managedObjectContext];
    [PrendaCategoria categoriaWithID:@"1" descripcion:NSLocalizedString(@"categoria1", @"") inManagedObjectContext:self.managedObjectContext];
    [PrendaCategoria categoriaWithID:@"2" descripcion:NSLocalizedString(@"categoria2", @"") inManagedObjectContext:self.managedObjectContext];
    [PrendaCategoria categoriaWithID:@"3" descripcion:NSLocalizedString(@"categoria3", @"") inManagedObjectContext:self.managedObjectContext];
    [PrendaCategoria categoriaWithID:@"4" descripcion:NSLocalizedString(@"categoria4", @"") inManagedObjectContext:self.managedObjectContext];
    
    //GET PrendaCategoria Array
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"PrendaCategoria" inManagedObjectContext:self.managedObjectContext]];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idCategoria" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSError *error = nil;
	NSArray *PrendaCategoriaArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Define main subcategories for user
    int i,j;
    for (i=1;i<[PrendaCategoriaArray count];i++) 
    {
        
        PrendaCategoria *myCategoria=[PrendaCategoriaArray objectAtIndex:i];
        NSString *subCategoriasNumberKey= [NSString stringWithFormat:@"categoria%dCount",[myCategoria.idCategoria integerValue]];
        NSInteger subCategoriasNumber=[NSLocalizedString(subCategoriasNumberKey, @"") integerValue];
        
        for (j=0; j<subCategoriasNumber;j++) 
        {
            NSString *subCategoriaDescripcion=[NSString stringWithFormat:@"subCategoria%d_%d",i,j ];
            NSString *subCategoriaID=[NSString stringWithFormat:@"%d",j ];
            [PrendaSubCategoria subCategoriaWithID:subCategoriaID withDescripcion:NSLocalizedString(subCategoriaDescripcion, @"") andCategoria:myCategoria withOrder:j inManagedObjectContext:self.managedObjectContext];
        }
    }
    
    //Define main Temporada
    [PrendaTemporada temporadaWithID:@"0" descripcion:NSLocalizedString(@"invierno", @"") inManagedObjectContext:self.managedObjectContext ];
    [PrendaTemporada temporadaWithID:@"1" descripcion:NSLocalizedString(@"primavera", @"") inManagedObjectContext:self.managedObjectContext ];
    [PrendaTemporada temporadaWithID:@"2" descripcion:NSLocalizedString(@"verano", @"") inManagedObjectContext:self.managedObjectContext ];
    [PrendaTemporada temporadaWithID:@"3" descripcion:NSLocalizedString(@"otono", @"") inManagedObjectContext:self.managedObjectContext ];
    [PrendaTemporada temporadaWithID:@"4" descripcion:NSLocalizedString(@"ninguna", @"") inManagedObjectContext:self.managedObjectContext ];
    
    
    //Define main Estado
    [PrendaEstado estadoWithID:@"0" descripcion:NSLocalizedString(@"disponible", @"") inManagedObjectContext:self.managedObjectContext ];
    [PrendaEstado estadoWithID:@"1" descripcion:NSLocalizedString(@"prestada", @"") inManagedObjectContext:self.managedObjectContext ];
    [PrendaEstado estadoWithID:@"2" descripcion:NSLocalizedString(@"deseo", @"") inManagedObjectContext:self.managedObjectContext ];
    [PrendaEstado estadoWithID:@"3" descripcion:NSLocalizedString(@"lavanderia", @"") inManagedObjectContext:self.managedObjectContext ];
    [PrendaEstado estadoWithID:@"4" descripcion:NSLocalizedString(@"ninguno", @"") inManagedObjectContext:self.managedObjectContext ];
    
    
}

-(void)createCoreDataDefaultPrendas
{
    
    //Define main Mis Marcas
    [PrendaMarca prendaMarca_WithID:@"0" withDescripcion:NSLocalizedString(@"marca0", @"") urlPicture:nil  forUsuario:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] needsSynchronize:[NSNumber numberWithBool:YES] firstBackup:[NSNumber numberWithBool:YES]  inManagedObjectContext:self.managedObjectContext];
    
    
    //GET PrendaCategoria Array
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"PrendaCategoria" inManagedObjectContext:self.managedObjectContext]];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idCategoria" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSError *error = nil;
	NSArray *PrendaCategoriaArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //GET PrendaMarca Array
    fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"PrendaMarca" inManagedObjectContext:self.managedObjectContext]];

    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        fetchRequest.predicate =[NSPredicate  predicateWithFormat:@"(usuario == %@) ",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        fetchRequest.predicate =[NSPredicate  predicateWithFormat:@"(usuario == %@) OR (usuario == %@) OR (usuario == %@)",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"descripcion" ascending:YES];
    sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	error = nil;
	NSArray *PrendaMarcaArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //GET PrendaTemporada Array
    fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"PrendaTemporada" inManagedObjectContext:self.managedObjectContext]];
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idTemporada" ascending:YES];
    sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	error = nil;
	NSArray *PrendaTemporadaArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //GET PrendaEstado Array
    fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"PrendaEstado" inManagedObjectContext:self.managedObjectContext]];
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idEstado" ascending:YES];
    sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	error = nil;
	NSArray *PrendaEstadoArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //Abro el plist de prendas por defecto
    NSString *arrayBundle = [[NSBundle mainBundle]pathForResource:@"DefaultItems" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile: arrayBundle];
    
    NSArray *defaultItemsArray= [[ NSArray alloc ] initWithArray:[dic objectForKey:@"Items"] ];
    
    int i;
    //Add Prendas to database
    for (i=0;i<[defaultItemsArray count];i++) 
    {   
        
        NSInteger defaultCategoria=[ [ [defaultItemsArray objectAtIndex:i] objectForKey:@"categoria" ] intValue] ;
        PrendaCategoria *myPrendaCategoriaIni= [PrendaCategoriaArray objectAtIndex:defaultCategoria] ;
        
        //GET PrendaSubCategoria Array
        fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [NSEntityDescription entityForName:@"PrendaSubCategoria" inManagedObjectContext:self.managedObjectContext];
        fetchRequest.predicate =[NSPredicate predicateWithFormat:@"categoria == %@", myPrendaCategoriaIni ];
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idSubcategoria" ascending:YES];
        sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [fetchRequest setSortDescriptors:sortDescriptors];
        error = nil;
        NSArray *PrendaSubCategoriaArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        NSInteger defaultSubCategoria=[ [ [defaultItemsArray objectAtIndex:i] objectForKey:@"subcategoria" ] intValue] ;
        PrendaSubCategoria *myPrendaSubCategoria= [PrendaSubCategoriaArray objectAtIndex:defaultSubCategoria-1] ;
        
        PrendaMarca *myPrendaMarca= [PrendaMarcaArray objectAtIndex:0] ;
        
        
        PrendaTemporada *myPrendaTemporada= [PrendaTemporadaArray objectAtIndex:4] ; 
        
        PrendaEstado *myPrendaEstado= [PrendaEstadoArray objectAtIndex:0] ;
        NSString *itemName= [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];

        [self performSelector:@selector(methodForDelay) withObject:nil afterDelay:0.05];

        NSString *idPrendaDispositivoSH1= [Authenticacion getSH1ForUser:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] andIdentifier:itemName];

        
        NSDictionary *prendaDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"username",
                                          @"",@"descripcion",
                                          itemName,@"idPrenda",
                                          idPrendaDispositivoSH1,@"idPrendaDispositivo",
                                          [NSString stringWithFormat:@"picture%d",i+1],@"urlPicture",
                                          @"",@"urlPictureServer",
                                          [NSDate date],@"fecha",
                                          [NSString stringWithFormat:@""],@"notas",
                                          [NSNumber numberWithFloat:0],@"precio",
                                          [NSNumber numberWithFloat:1],@"rating",
                                          [NSNumber numberWithInteger:0],@"talla1",
                                          [NSNumber numberWithInteger:0],@"talla2",
                                          [NSNumber numberWithInteger:0],@"talla3",
                                          [NSString stringWithFormat:@""],@"tag1",
                                          [NSString stringWithFormat:@""],@"tag2",
                                          [NSString stringWithFormat:@""],@"tag3",
                                          [NSNumber numberWithInteger:1],@"composicion",
                                          myPrendaCategoriaIni, @"categoria",
                                          myPrendaSubCategoria,@"subcategoria",
                                          myPrendaTemporada,@"temporada",
                                          myPrendaEstado,@"estado",
                                          @"",@"color",
                                          @"",@"tienda",
                                          [NSNumber numberWithBool:YES],@"needsSynchronize",
                                          [NSNumber numberWithBool:YES],@"firstBackup",
                                          @"YES",@"restoreFinished",
                                          myPrendaMarca,@"marca",
                                          nil] ;
        
        Prenda *newPrenda= [Prenda prendaWithData:prendaDictionary inManagedObjectContext:self.managedObjectContext overwriteObject:NO];
        
        
        if (newPrenda!=nil) 
        {
            NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",newPrenda.urlPicture] ]; 
            
            NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",newPrenda.urlPicture] ]; 
            
            NSString *picName=[NSString stringWithFormat:@"defaultPrenda%.2d.png",i+1 ];
            UIImage *originalImage=[UIImage imageNamed: picName ];

            NSString *picNameSmall=[NSString stringWithFormat:@"defaultPrendaSmall%.2d.png",i+1 ];
            UIImage *originalImageSmall=[UIImage imageNamed: picNameSmall ];

            
            NSData *data = [[NSData alloc] initWithData: UIImagePNGRepresentation
                            ([self createThumbnailFromImage:originalImage withSize:PIC_SIZE_STANDARD]) ];
            
            NSData *dataSmall = [[NSData alloc] initWithData: UIImagePNGRepresentation
                                 (originalImageSmall) ];
            
            //Si no existe la foto, la creo en el disco
            //Write original size
            if ( ![fileManager fileExistsAtPath:imagePath] ) 
                [data writeToFile:imagePath atomically:YES];

            //Write Thumbnail
            if ( ![fileManager fileExistsAtPath:imagePathSmall] ) 
                [dataSmall writeToFile:imagePathSmall atomically:YES];
            
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"CreateDefaultPrendas"];
    
    
}

-(void) methodForDelay
{
    
    
}

-(void) addAttributesToMarcas
{
    //Define Marcas Master
    //Abro el plist de marcas
    NSString *marcasArrayBundle = [[NSBundle mainBundle]pathForResource:@"marcasMaster" ofType:@"plist"];
    NSMutableDictionary *dicMarcas = [[NSMutableDictionary alloc] initWithContentsOfFile: marcasArrayBundle];
    
    NSArray *marcasItemsArray= [[ NSArray alloc ] initWithArray:[dicMarcas objectForKey:@"Items"] ];
    
    //addAttributesToMarcas
    NSFetchRequest *fetchRequestMarcas = [[NSFetchRequest alloc] init];
	[fetchRequestMarcas setEntity:[NSEntityDescription entityForName:@"Marcas" inManagedObjectContext:self.managedObjectContext]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequestMarcas setSortDescriptors:sortDescriptors];

	NSError *errorFetchMarcas = nil;
	NSArray *marcasArrayFetched = [self.managedObjectContext executeFetchRequest:fetchRequestMarcas error:&errorFetchMarcas];
    
    for (Marcas* thisMarca in marcasArrayFetched) 
    {
        NSInteger idMarca=[thisMarca.idMarca intValue];
        
        NSArray *filteredArray= [marcasItemsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(id == %@)", thisMarca.idMarca ] ];
        
        if ([filteredArray count]>0) 
        {
            if (idMarca>0) 
            {
                thisMarca.isAtletica= [[filteredArray objectAtIndex:0] objectForKey:@"isAtletica"];
                thisMarca.isClasica= [[filteredArray objectAtIndex:0] objectForKey:@"isClasica"];
                thisMarca.isFashion= [[filteredArray objectAtIndex:0] objectForKey:@"isFashion"];
                thisMarca.isHippie= [[filteredArray objectAtIndex:0] objectForKey:@"isHippie"];
                thisMarca.isVanguardista= [[filteredArray objectAtIndex:0] objectForKey:@"isVanguardista"];
                thisMarca.isRomantica= [[filteredArray objectAtIndex:0] objectForKey:@"isRomantica"];
                
            }    
        }


    }

}



@end
