//
//  ItemDetailViewController.m
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


#import "PrendaDetailViewController.h"
#import "PrendaMarca.h"
#import "PrendaCategoria.h"
#import "PrendaSubCategoria.h"
#import "PrendasMisMarcasViewController.h"
#import "PrendaCategoriasViewController.h"
#import "PrendaTienda.h"
#import "PrendaTemporada.h"
#import "PrendaEstado.h"
#import "StyleDressApp.h"

@implementation PrendaDetailViewController
@synthesize managedObjectContext;
@synthesize delegate;
@synthesize prendaCategoria;
@synthesize isMultiselection;
@synthesize prendasArray;
@synthesize multipleSelectionDictionary;
@synthesize currentPrendaPage;
@synthesize prenda;
@synthesize isFullScreen;
@synthesize myImageView,myBtnZoom;
@synthesize myScrollViewBackground;
@synthesize BtnOtono,BtnVerano,BtnInvierno,BtnPrimavera; 
@synthesize BtnDisponibilidad;
@synthesize detailsView,etiquetaView,notesView, etiquetaImageView,notesImageView;
@synthesize etiqTiendaTitle,etiqTiendaValue;
@synthesize etiqTallaTitle,etiqTallaValue,etiqColorTitle,etiqComposicionTitle,etiqComposicionValue;
@synthesize notesNotasTitle,notesEstadoTitle;
@synthesize etiquetasCloseView,notesCloseView;
@synthesize notesViewTitle;
@synthesize myBtnImageZoom;
@synthesize tempTitle;
@synthesize disponibilidadLabel;
@synthesize precioLabel,myScrollViewEtiqueta,etiqColorTextField;
@synthesize notesTextField,myNotesScrollView,datesUsedArray,notesDatesUsed;
@synthesize BtnCategoria;
@synthesize notesTableView;
@synthesize myBackgroundImage,myMarcoImage,myMarcoImageDetail,myEtiquetaBtn,myPrecioBtn;
@synthesize BtnMarca,marcaLabel;
@synthesize notasImageViewLine1;
@synthesize miEtiquetaImageViewLine1,miEtiquetaImageViewLine2,miEtiquetaImageViewLine3,miEtiquetaImageViewLine4;
@synthesize imageViewSlider,imageViewSliderFinger;
@synthesize mainView;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPrendasArray:(NSMutableArray*)tempPrendasArray andPage:(NSInteger)page
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.prendasArray= tempPrendasArray;
        currentPrendaPage=page;
        self.prenda=[prendasArray objectAtIndex:currentPrendaPage];
    }
    return self;
}




- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle
    

    

-(void) viewDidLoad
{    
    [etiquetaView setFrame:CGRectMake(0,40, 320, 372)];
    [self.mainView addSubview:etiquetaView]; 

    [notesView setFrame:CGRectMake(0, 0, 320, 416)];
    [self.mainView addSubview:notesView]; 
    
    isTemporadaChanging=NO;
    
    nullString=@"-------";
  
    isUpdatingToFullScreen=NO;
    
    self.datesUsedArray=[[NSMutableArray alloc] init];
    
    if (isMultiselection)    
    {
        [notesTableView setHidden:YES];
        [notesDatesUsed setHidden:YES];
    }else
    {
        [notesTableView setHidden:NO];
        [notesDatesUsed setHidden:NO];
        [self fetchDatesUsed];
    }
    
    tallas1=[NSArray arrayWithObjects:@"--",@"XXS",@"XS",@"S",@"M",@"L",@"XL",@"XXL", nil];
    tallas2=[NSArray arrayWithObjects:@"--",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];

    //BackgroundImage
    [myBackgroundImage setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailBackground"]];
    [myMarcoImage setImage:[StyleDressApp imageWithStyleNamed:@"PRDetalleMainFrame"]];
    [myMarcoImageDetail setImage:[StyleDressApp imageWithStyleNamed:@"PRDetalleMainFrameDetail"]];
    [self.myScrollViewBackground setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRDetailBackgroundPrenda]];

    
    [self.detailsView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRDetailBackground]];

//    [self.detailsView setBackgroundColor:[UIColor blueColor]];

    
        
    
    //Disponibilidad boton 
    [self.BtnDisponibilidad setImage:[StyleDressApp imageWithStyleNamed:@"PRNotesEstadoButton"] forState:UIControlStateNormal];
    //UIFont *myFontDisponibilidad= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:14];
    UIFont *myFontDisponibilidad= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:18];
    [BtnDisponibilidad addTarget:self action:@selector(openDisponibilidadAction) forControlEvents:UIControlEventTouchUpInside];

    self.disponibilidadLabel= [[UILabel alloc] initWithFrame:CGRectMake(0,0,239,36)];
    [self.disponibilidadLabel setAdjustsFontSizeToFitWidth:YES];
    [self.disponibilidadLabel setMinimumFontSize:8];
    //self.disponibilidadLabel.text=NSLocalizedString(@"NoDisponible",@"");
    self.disponibilidadLabel.adjustsFontSizeToFitWidth=YES;
    self.disponibilidadLabel.font=myFontDisponibilidad;
    self.disponibilidadLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorPRNotasBtnFont];
    self.disponibilidadLabel.textAlignment=UITextAlignmentCenter;
    self.disponibilidadLabel.backgroundColor=[UIColor clearColor];
    [self.BtnDisponibilidad addSubview:self.disponibilidadLabel];

    [notasImageViewLine1 setImage:[StyleDressApp imageWithStyleNamed:@"PRONotesTextFrame"] ];

    [miEtiquetaImageViewLine1 setImage:[StyleDressApp imageWithStyleNamed:@"PRONotesTextFrame"] ];
    [miEtiquetaImageViewLine2 setImage:[StyleDressApp imageWithStyleNamed:@"PRONotesTextFrame"] ];
    [miEtiquetaImageViewLine3 setImage:[StyleDressApp imageWithStyleNamed:@"PRONotesTextFrame"] ];
    [miEtiquetaImageViewLine4 setImage:[StyleDressApp imageWithStyleNamed:@"PRONotesTextFrame"] ];
//PROTextFrame
    
    //Botones etiqueta y notas
 //   UIFont *myFontEtiquetaNotas= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:17];
    UIFont *myFontEtiquetaNotas= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:21];
    [notesViewTitle setFont:myFontEtiquetaNotas];
    [notesViewTitle setText:NSLocalizedString(@"myEtiqueta",@"")];
    [notesViewTitle setTransform:CGAffineTransformMakeRotation( -0.044*M_PI  )]; 
    [notesViewTitle setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRDetailEtiqueta]];
    
    
    //Modifico posición de controles dependiendo del estilo
    NSInteger marcaTitleOfffset=0;
    NSInteger marcaOfffset=0;
    NSInteger precioLabelXOfffset=0;
    NSInteger precioLabelYOfffset=0;
    NSInteger btnPrecioXOfffset=0;
    NSInteger btnPrecioYOfffset=0;
    NSInteger myEtiquetaXOffset=0;
    NSInteger myEtiquetaYOffset=0;
    NSInteger btnEtiquetaXOfffset=0;
    NSInteger btnEtiquetaYOfffset=0;
    if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        marcaTitleOfffset=-5;
        marcaOfffset=-6;
        precioLabelXOfffset=-5;
        precioLabelYOfffset=-3;
        btnPrecioXOfffset=7;
        btnPrecioYOfffset=0;
        btnEtiquetaXOfffset=-5;
        btnEtiquetaYOfffset=-20;
        myEtiquetaXOffset=7;
        myEtiquetaYOffset=60;
        
    }
    
    //marcas Label and Boton
    [self.BtnMarca setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailMarcaFrame"] forState:UIControlStateNormal];
    UIFont *myMarcaFont= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:20];

    self.marcaLabel= [[UILabel alloc] initWithFrame:CGRectMake(20,50+marcaOfffset,265,25)];
    self.marcaLabel.font=myMarcaFont;
    [self.marcaLabel setAdjustsFontSizeToFitWidth:YES];
    self.marcaLabel.textAlignment=UITextAlignmentCenter;
    self.marcaLabel.backgroundColor=[UIColor clearColor];

    [self.BtnMarca addSubview:marcaLabel];

    UILabel *marcaTitleLabel= [[UILabel alloc] initWithFrame:CGRectMake(95,23+marcaTitleOfffset,112,20)];
    //UILabel *marcaTitleLabel= [[UILabel alloc] initWithFrame:CGRectMake(90,3,100,12)];
    //UIFont *myMarcaFont= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:14];
    //UIFont *myMarcaFontTitle= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:18];
    UIFont *myMarcaFontTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:23];
    marcaTitleLabel.font=myMarcaFontTitle ;
    marcaTitleLabel.textAlignment=UITextAlignmentCenter;
    marcaTitleLabel.textColor=[UIColor whiteColor];
    marcaTitleLabel.text=NSLocalizedString(@"EtiquetaMarca", @"");
    marcaTitleLabel.backgroundColor=[UIColor clearColor];
    [marcaTitleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRDetailMarcaTitle]];

    [self.BtnMarca addSubview:marcaTitleLabel];

    
    //PRECIO
    UIFont *myPrecioFont= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:18];
    [self.precioLabel setFont:myPrecioFont];
    [self.precioLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRDetailPrecio]];
    [self.precioLabel setTransform:CGAffineTransformMakeRotation( -0.044*M_PI  )]; 

    //Corrijo las posiciones de precio,BtnPrecio y etiqueta dependiendo del estilo
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        [self.notesViewTitle setFrame:CGRectMake(223+myEtiquetaXOffset, 205+myEtiquetaYOffset, 80, 28)];
        [self.precioLabel setFrame:CGRectMake (242+precioLabelXOfffset,118+precioLabelYOfffset,41,28) ];
        [self.myPrecioBtn setFrame:CGRectMake (217+btnPrecioXOfffset,110+btnPrecioYOfffset,71,41) ];
        [self.myEtiquetaBtn setFrame:CGRectMake (228+btnEtiquetaXOfffset,180+btnEtiquetaYOfffset,84,155) ];

    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        [self.notesViewTitle setFrame:CGRectMake(223+myEtiquetaXOffset, 205+myEtiquetaYOffset, 80, 28)];
        [self.precioLabel setFrame:CGRectMake (242+precioLabelXOfffset,118+precioLabelYOfffset,41,28) ];
        [self.myPrecioBtn setFrame:CGRectMake (217+btnPrecioXOfffset,110+btnPrecioYOfffset,71,41) ];
        [self.myEtiquetaBtn setFrame:CGRectMake (228+btnEtiquetaXOfffset,180+btnEtiquetaYOfffset,84,155) ];

 
    }
        
       
    
    //Etiqueta View
    UIFont *myFontEtiqueta= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:18];
    
    NSInteger fontSizeEtiquetaTitle;
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        fontSizeEtiquetaTitle=23; 
        [etiqTallaTitle setFrame:CGRectMake(51, 200, 68, 31)];
        [etiqColorTitle setFrame:CGRectMake(51, 250, 68, 31)];
        [etiqComposicionTitle setFrame:CGRectMake(51, 300, 68, 31)];

    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        fontSizeEtiquetaTitle=20; 
        [etiqTallaTitle setFrame:CGRectMake(51, 200, 68, 31)];
        [etiqColorTitle setFrame:CGRectMake(51, 250, 68, 31)];
        [etiqComposicionTitle setFrame:CGRectMake(51, 300, 68, 31)];

    }
    
    UIFont *myFontEtiquetaTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:fontSizeEtiquetaTitle];
    
    [etiquetaView setBackgroundColor:[UIColor clearColor]];
    [etiquetaView setHidden:YES];
    [etiquetaView setAlpha:0.0];
    [etiquetaImageView setImage:[StyleDressApp imageWithStyleNamed:@"PRDetalleViewEtiqueta"] ];
    [tempTitle setFont:myFontEtiquetaTitle];
    [etiqTallaTitle setFont:myFontEtiquetaTitle];
    [etiqColorTitle setFont:myFontEtiquetaTitle];
    [etiqComposicionTitle setFont:myFontEtiquetaTitle];
    [etiqTiendaValue setFont:myFontEtiqueta];
    [etiqTallaValue setFont:myFontEtiqueta];


    [tempTitle setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREtiquetasSectionTitle]];
    [etiqTallaTitle setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREtiquetasSectionTitle]];
    [etiqColorTitle setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREtiquetasSectionTitle]];
    [etiqComposicionTitle setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREtiquetasSectionTitle]];
    
    
    [etiqColorTextField setFont:myFontEtiqueta];
    [etiqComposicionValue setFont:myFontEtiqueta];
    [etiqTiendaValue setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREtiquetasCell]];
    [etiqTallaValue setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREtiquetasCell]];
    
    [etiqColorTextField setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREtiquetasCell]];
    [etiqComposicionValue setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPREtiquetasCell]];
    [etiqTiendaTitle setFont:myFontEtiquetaTitle];
    [etiquetasCloseView setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailButtonSaveNotesEtiqueta"] forState:UIControlStateNormal];
    
    
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        [myMarcoImage setFrame:CGRectMake(16, 106, 303, 257)];
        [myMarcoImageDetail setFrame:CGRectMake(149, 106, 66, 44)];
       // [BtnCategoria setFrame:CGRectMake(89, 89, 41, 41  )];
        //temporada view
        [self.BtnVerano setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempVeranoOFF"] forState:UIControlStateNormal];
        [self.BtnVerano setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempVeranoON"] forState:UIControlStateSelected];
        [self.BtnPrimavera setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempPrimaveraOFF"] forState:UIControlStateNormal];
        [self.BtnPrimavera setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempPrimaveraON"] forState:UIControlStateSelected];
        [self.BtnOtono setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempOtonoOFF"] forState:UIControlStateNormal];
        [self.BtnOtono setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempOtonoON"] forState:UIControlStateSelected];
        [self.BtnInvierno setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempInviernoOFF"] forState:UIControlStateNormal];
        [self.BtnInvierno setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempInviernoON"] forState:UIControlStateSelected];
        
    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        [myMarcoImage setFrame:CGRectMake(8, 106, 303, 257)];
        [myMarcoImageDetail setFrame:CGRectMake(144, 106, 66, 44)];

        //[myMarcoImageDetail setFrame:CGRectMake(110, 106, 66, 44)];

        //[BtnCategoria setFrame:CGRectMake(89, 89, 41, 41  )];

        //temporada view
        [self.BtnVerano setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempVeranoOFF"] forState:UIControlStateNormal];
        [self.BtnVerano setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempVeranoON"] forState:UIControlStateSelected];
        [self.BtnPrimavera setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempPrimaveraOFF"] forState:UIControlStateNormal];
        [self.BtnPrimavera setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempPrimaveraON"] forState:UIControlStateSelected];
        [self.BtnOtono setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempOtonoOFF"] forState:UIControlStateNormal];
        [self.BtnOtono setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempOtonoON"] forState:UIControlStateSelected];
        [self.BtnInvierno setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempInviernoOFF"] forState:UIControlStateNormal];
        [self.BtnInvierno setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempInviernoON"] forState:UIControlStateSelected];

/*        
        
        [self.BtnVerano setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempOFF"] forState:UIControlStateNormal];
        [self.BtnVerano setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempON"] forState:UIControlStateSelected];
        [self.BtnPrimavera setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempOFF"] forState:UIControlStateNormal];
        [self.BtnPrimavera setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempON"] forState:UIControlStateSelected];
        [self.BtnOtono setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempOFF"] forState:UIControlStateNormal];
        [self.BtnOtono setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempON"] forState:UIControlStateSelected];
        [self.BtnInvierno setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempOFF"] forState:UIControlStateNormal];
        [self.BtnInvierno setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTempON"] forState:UIControlStateSelected];
        
        UILabel *labelPrimavera = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        UILabel *labelVerano = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        UILabel *labelOtono = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        UILabel *labelInvierno = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        
        labelPrimavera.backgroundColor=[UIColor clearColor];
        labelVerano.backgroundColor=[UIColor clearColor];
        labelOtono.backgroundColor=[UIColor clearColor];
        labelInvierno.backgroundColor=[UIColor clearColor];
        
        [labelPrimavera setTextAlignment:UITextAlignmentCenter];
        [labelVerano setTextAlignment:UITextAlignmentCenter];
        [labelOtono setTextAlignment:UITextAlignmentCenter];
        [labelInvierno setTextAlignment:UITextAlignmentCenter];
        
        UIFont *myFontTemporada= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:17];

        labelPrimavera.font=myFontTemporada;
        labelVerano.font=myFontTemporada;
        labelOtono.font=myFontTemporada;
        labelInvierno.font=myFontTemporada;
        
        labelPrimavera.text=NSLocalizedString(@"primaveraShort",@"");
        labelVerano.text=NSLocalizedString(@"veranoShort",@"");
        labelOtono.text=NSLocalizedString(@"otonoShort",@"");
        labelInvierno.text=NSLocalizedString(@"inviernoShort",@"");
        
        [self.BtnPrimavera addSubview:labelPrimavera];
        [self.BtnVerano addSubview:labelVerano];
        [self.BtnOtono addSubview:labelOtono];
        [self.BtnInvierno addSubview:labelInvierno];
        */
        
    }
    
    
    //Notes View
    UIFont *myFontNotes= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:18];
    //UIFont *myFontNotesTitle= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:18];
    UIFont *myFontNotesTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:22];
    [notesView setBackgroundColor:[UIColor clearColor]];
    [notesView setHidden:YES];
    [notesView setAlpha:0.0];
    [notesImageView setImage:[StyleDressApp imageWithStyleNamed:@"CODetailNotesFrame"] ];
    [notesCloseView setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailButtonSaveNotesEtiqueta"] forState:UIControlStateNormal];
    
    [notesNotasTitle setFont:myFontNotesTitle];
    [notesEstadoTitle setFont:myFontNotesTitle];
    [notesTextField setFont:myFontNotes];
    [notesDatesUsed setFont:myFontNotesTitle];
    
    [notesTextField setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRNotasCell]];
    [notesNotasTitle setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRNotasSectionTitle]];
    [notesEstadoTitle setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRNotasSectionTitle]];

    [notesDatesUsed setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"FechasTitle", @"")]];

    //Table View settings
    rowHeight=40;
    [self.notesTableView setBackgroundColor:[UIColor clearColor]];
    [self.notesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.notesTableView setSeparatorColor:[UIColor clearColor]];
    [self.notesTableView setRowHeight:rowHeight];

    
    if (self.isFullScreen) 
    {
        self.myImageView.frame  =CGRectMake(0,0,320,372); 
        self.myScrollViewBackground.frame  =CGRectMake(0,0,320,372); 
        self.myBtnImageZoom.frame  =CGRectMake(0,0,320,372); 
        self.myBtnZoom.frame =CGRectMake(273,325,40,40); 
        [self.myBtnZoom setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailZoom"] forState:UIControlStateNormal];
        [self.BtnCategoria setHidden:YES];
        [self.myMarcoImageDetail setHidden:YES];
    }else
    {
        self.myImageView.frame =CGRectMake(35,130,150,213); 
        self.myBtnImageZoom.frame =CGRectMake(45,72,130,173); 
        self.myScrollViewBackground.frame =CGRectMake(35,130,160,215); 
         self.myBtnZoom.frame =CGRectMake(185,320,40,40); 
        [self.myBtnZoom setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailZoom"] forState:UIControlStateNormal];
        [self.BtnCategoria setHidden:NO];
        [self.myMarcoImageDetail setHidden:NO];
    }

    //Prepare file manager && cachesDirectory
    cachesDirectory= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    fileManager = [NSFileManager defaultManager];
    
    
    
    //NSLog(@"viewWillAppear- isMultiselection:%d",isMultiselection);
    if (isMultiselection)  //change multiple parameters at the same time
    {
        //NSLog(@"inside isMultiselection");
        [self checkMultiselectionFields];
        
    
    }
    else   //No multiple selection
    {
        [self.myImageView setHidden:NO];
        self.prenda=[prendasArray objectAtIndex:currentPrendaPage];
        //NSLog(@"\ncurrentPrendaPage:%d",currentPrendaPage);
        
        //Carga imagen de la prenda, dependiendo si estoy o no en modo fullscreen
        if (self.isFullScreen) 
        {
            NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",prenda.urlPicture] ]; 
            if ( [fileManager fileExistsAtPath:imagePath] ) 
                [self.myImageView setImage: [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]  ] ];

        }
        else
        {
            NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",prenda.urlPicture] ]; 
            if ( [fileManager fileExistsAtPath:imagePathSmall] ) 
                [self.myImageView setImage: [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePathSmall]  ] ];
        }

        [self updateLabels];
    }
    
    
    [imageViewSlider setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRDetailBackground]];
    [imageViewSliderFinger setImage:[StyleDressApp imageWithStyleNamed:@"GESliderFinger"]];

    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"showPrendasSlider"] isEqualToString:@"YES"]) 
    {
        [self.view setUserInteractionEnabled:NO];
        [imageViewSlider setAlpha:0.75];
        [imageViewSliderFinger setAlpha:0.75];
        [imageViewSlider setHidden:NO];
        [imageViewSliderFinger setHidden:NO];
        [UIView beginAnimations:@"FingerFadeOut" context:nil];
        [UIView setAnimationDelay:2.0];
        [UIView setAnimationDuration:1.25];
        [imageViewSlider setAlpha:0.0];
        [imageViewSliderFinger setAlpha:0.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationViewFinished:finished:context:)];
        [UIView commitAnimations];
  
    } else
    {
        [self.view setUserInteractionEnabled:YES];
        [imageViewSlider setHidden:YES];
        [imageViewSliderFinger setHidden:YES];
    
    }

    [super viewDidLoad];

}

- (void)animationViewFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    //NSLog(@"animationID:%@",animationID);
    if ([animationID isEqualToString:@"FingerFadeOut"]) 
    {
        [self.view setUserInteractionEnabled:YES];

          [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"showPrendasSlider"];
          [imageViewSlider setHidden:YES];
          [imageViewSliderFinger setHidden:YES];
    }
    
}



-(void) fetchDatesUsed
{
    
    //Chequo todos los conjuntos que contienen esta prenda
    for (ConjuntoPrendas *thisConjuntoPrenda in prenda.conjuntoPrenda) 
    {
        //Para cada conjunto que contiene la prenda, busca las notas de calendario asociadas a el
        for (CalendarConjunto *thisCalendarConjunto in thisConjuntoPrenda.conjunto.calendarConjunto)
        {
            [datesUsedArray addObject:thisCalendarConjunto];
        }
    }
    
     NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fecha" ascending:NO];
     NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
     [datesUsedArray sortUsingDescriptors:sortDescriptors];
     
    if ([datesUsedArray count]>0) 
        [notesDatesUsed setHidden:NO];
    else
        [notesDatesUsed setHidden:YES];
}

-(void) updateAllInDetailsVC
{
    
    if (isMultiselection)  //change multiple parameters at the same time
    {
        [self checkMultiselectionFields];
    } else
        [self updateLabels];

}

-(void) checkMultiselectionFields
{
    NSString *multipleCategoria= [[(Prenda*)[prendasArray objectAtIndex:0] categoria] idCategoria];
    NSString *multipleSubCategoria= [[(Prenda*)[prendasArray objectAtIndex:0] subcategoria] idSubcategoria];
    NSString *multipleMarca= [[(Prenda*)[prendasArray objectAtIndex:0] marca] descripcion]  ;

    NSNumber *multipleTalla1= [(Prenda*)[prendasArray objectAtIndex:0] talla1];
    NSNumber *multipleTalla2= [(Prenda*)[prendasArray objectAtIndex:0] talla2];
    NSNumber *multipleTalla3= [(Prenda*)[prendasArray objectAtIndex:0] talla3];

    NSNumber *multiplePrecio= [(Prenda*)[prendasArray objectAtIndex:0] precio];

    NSString *multipleColor= [(Prenda*)[prendasArray objectAtIndex:0] color] ;
    NSString *multipleTienda= [[(Prenda*)[prendasArray objectAtIndex:0] tienda] descripcion];
    NSString *multipleTemporada= [[(Prenda*)[prendasArray objectAtIndex:0] temporada] idTemporada];
    NSString *multipleEstado= [[(Prenda*)[prendasArray objectAtIndex:0] estado] idEstado];
    NSNumber *multipleRating= [ (Prenda*)[prendasArray objectAtIndex:0] rating] ;
    
    NSNumber *multipleComposicion= [(Prenda*)[prendasArray objectAtIndex:0] composicion];
    NSString *multipleNotas= [(Prenda*)[prendasArray objectAtIndex:0] notas] ;
    NSString *multipleTag1= [(Prenda*)[prendasArray objectAtIndex:0] tag1] ;
    NSString *multipleTag2= [(Prenda*)[prendasArray objectAtIndex:0] tag2] ;
    NSString *multipleTag3= [(Prenda*)[prendasArray objectAtIndex:0] tag3] ;

    NSDate *multipleDate= [(Prenda*)[prendasArray objectAtIndex:0] fechaCompra] ;

      
    
    for (Prenda *myPrenda in prendasArray) 
    {
        //NSLog(@"Multiselect prenda:%@",myPrenda);
        if ( ![multipleCategoria isEqualToString:myPrenda.categoria.idCategoria])
            multipleCategoria=nullString;
        if ( ![multipleSubCategoria isEqualToString:myPrenda.subcategoria.idSubcategoria])
            multipleSubCategoria=nullString;
        if ( ![multipleMarca isEqualToString:myPrenda.marca.descripcion])
            multipleMarca=nullString;
        if ( ![multipleColor isEqualToString:myPrenda.color])
            multipleColor=nullString;
        if ( ![multipleTienda isEqualToString:myPrenda.tienda.descripcion])
            multipleTienda=nullString;
        if ( ![multipleTemporada isEqualToString:myPrenda.temporada.idTemporada])
            multipleTemporada=nullString;
        if ( ![multipleEstado isEqualToString:myPrenda.estado.idEstado])
            multipleEstado=nullString;
        if ( !([multipleRating integerValue]== [myPrenda.rating integerValue] ) )
            multipleRating=[NSNumber numberWithInteger:-1];
        if ( !([multipleComposicion integerValue]== [myPrenda.composicion integerValue] ) )
            multipleComposicion=[NSNumber numberWithInteger:-1];
        
        NSLog(@"multipleTalla1:%d myPrenda.talla1:%d",[multipleTalla1 integerValue],[myPrenda.talla1 integerValue]);
        NSLog(@"multipleTalla2:%d myPrenda.talla2:%d",[multipleTalla2 integerValue],[myPrenda.talla2 integerValue]);
        NSLog(@"multipleTalla3:%d myPrenda.talla3:%d",[multipleTalla3 integerValue],[myPrenda.talla3 integerValue]);
        if ( [multipleTalla1 integerValue] != [myPrenda.talla1 integerValue]  )
            multipleTalla1=[NSNumber numberWithInteger:-1];
        
        if ( [multipleTalla2 integerValue] != [myPrenda.talla2 integerValue]  )
            multipleTalla2=[NSNumber numberWithInteger:-1];
    
        if ( [multipleTalla3 integerValue] != [myPrenda.talla3 integerValue]  )
            multipleTalla3=[NSNumber numberWithInteger:-1];
        
        if ( [multiplePrecio floatValue]!= [myPrenda.precio floatValue]  )
            multiplePrecio=[NSNumber numberWithFloat:-1];

        if ( ![multipleNotas isEqualToString:myPrenda.notas])
            multipleNotas=nullString;
        
        if ( ![multipleTag1 isEqualToString:myPrenda.tag1])
            multipleTag1=nullString;
        if ( ![multipleTag2 isEqualToString:myPrenda.tag2])
            multipleTag2=nullString;
        if ( ![multipleTag3 isEqualToString:myPrenda.tag3])
            multipleTag3=nullString;

        if ( ![multipleDate isEqualToDate:myPrenda.fechaCompra])
            multipleDate=[NSDate dateWithTimeIntervalSince1970:123456789012345];

        
        
    }
    
    //NSLog(@"multipleCategoria:%@",multipleCategoria);
    //NSLog(@"multipleSubCategoria:%@",multipleSubCategoria);
    //NSLog(@"multipleMarca:%@",multipleMarca);
    
    //NSLog(@"multipleColor:%@",multipleColor);
    //NSLog(@"multipleTienda:%@",multipleTienda);
    //NSLog(@"multipleTemporada:%@",multipleTemporada);
    //NSLog(@"multipleEstado:%@",multipleEstado);
    
    
    [multipleSelectionDictionary setObject:multipleCategoria forKey:@"multipleCategoria"];
    [multipleSelectionDictionary setObject:multipleSubCategoria forKey:@"multipleSubCategoria"];
    [multipleSelectionDictionary setObject:multipleMarca forKey:@"multipleMarca"];
    [multipleSelectionDictionary setObject:multipleColor forKey:@"multipleColor"];
    [multipleSelectionDictionary setObject:multipleTienda forKey:@"multipleTienda"];
    [multipleSelectionDictionary setObject:multipleTemporada forKey:@"multipleTemporada"];
    [multipleSelectionDictionary setObject:multipleEstado forKey:@"multipleEstado"];
    [multipleSelectionDictionary setObject:multipleRating forKey:@"multipleRating"];
    [multipleSelectionDictionary setObject:multipleTalla1 forKey:@"multipleTalla1"];
    [multipleSelectionDictionary setObject:multipleTalla2 forKey:@"multipleTalla2"];
    [multipleSelectionDictionary setObject:multipleTalla3 forKey:@"multipleTalla3"];
    [multipleSelectionDictionary setObject:multiplePrecio forKey:@"multiplePrecio"];
    [multipleSelectionDictionary setObject:multipleComposicion forKey:@"multipleComposicion"];
    [multipleSelectionDictionary setObject:multipleNotas forKey:@"multipleNotas"];
    [multipleSelectionDictionary setObject:multipleTag1 forKey:@"multipleTag1"];
    [multipleSelectionDictionary setObject:multipleTag2 forKey:@"multipleTag2"];
    [multipleSelectionDictionary setObject:multipleTag3 forKey:@"multipleTag3"];
    [multipleSelectionDictionary setObject:multipleDate forKey:@"multipleDate"];
    
    NSLog(@"multiple rating value:%d",[multipleRating intValue] );
    
    [self.myBtnZoom setHidden:YES];
    [self.myBtnImageZoom setHidden:YES];
    
    [self updateMultipleSelectionLabelsWithDictionary];
    //[self.myImageView setImage: [UIImage imageNamed:@"dressApp.png"]];
    [self.myImageView setHidden:YES];
    
    int i;
    //Remove previous subviews of scrollView
    NSInteger numberOfSubviews=[self.myScrollViewBackground.subviews count];
    for (i=0; i<numberOfSubviews;i++  ) 
    {
        //NSLog(@"removingFromSuperview- view %d of %d",0, numberOfSubviews);
        UIImageView *theView= [self.myScrollViewBackground.subviews objectAtIndex:0];
        [theView removeFromSuperview];
    }

    //Place small Views on ScrollView
    //CGFloat thumbnailWidth=PIC_MULTIPRENDA_SCROLL;   //37x49
    //CGFloat thumbnailHeight=thumbnailWidth*800./600.;
    
    CGFloat thumbnailHeight=PIC_MULTIPRENDA_SCROLL; //37x49
    CGFloat thumbnailWidth=thumbnailHeight*600/800;   
    
    int j;
    int x,y;
    int xIni=(MULTISELECTION_SCROLLVIEW_WIDTH-thumbnailWidth*3)/4;
    int yIni=5;
    
    NSLog(@"xIni:%d",xIni);
    NSLog(@"MULTISELECTION_SCROLLVIEW_WIDTH:%d",MULTISELECTION_SCROLLVIEW_WIDTH);
    NSLog(@"thumbnailWidth:%f",thumbnailWidth);
    NSInteger numberOfPrendas = [ prendasArray count];
    NSLog(@"numberOfPrendas:%d",numberOfPrendas);
    for (j=0;j<numberOfPrendas;j++)
    {
        x=xIni+j%3 *(thumbnailWidth+xIni);
        y=yIni+(yIni+ thumbnailHeight)* (int)(j/3);
        //NSLog(@"x:%d y:%d w:%f h:%f",x,y,thumbnailWidth,thumbnailHeight);
        
        Prenda *thumbnailPrenda= [ prendasArray  objectAtIndex:j];
        NSString *thumbnailPath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",thumbnailPrenda.urlPicture] ]; 
        UIImage *thumbnailImage= [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:thumbnailPath] ];
        
        UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y,thumbnailWidth,thumbnailHeight)];
        [thumbnailImageView setImage:thumbnailImage];
        [self.myScrollViewBackground addSubview:thumbnailImageView];
        
    }
    [self.myScrollViewBackground setContentSize:CGSizeMake(MULTISELECTION_SCROLLVIEW_WIDTH, y+100)];
}


#pragma mark - UITextViewDelegate
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==etiqColorTextField)     
    {
        //etiqColorTextField.text=@"";
        [self.myScrollViewEtiqueta setContentOffset:CGPointMake(0 , 180) animated:YES];
    }
    if (textField==notesTextField)  
    {
        [self.myNotesScrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
    }
        

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldUpdate:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self textFieldUpdate:textField];
    return YES;

}

-(void) textFieldUpdate:(UITextField *)textField
{
    
    if (textField==etiqColorTextField)     
    {
        [etiqColorTextField resignFirstResponder];
        
        if (isMultiselection) 
        {
            for (Prenda *myPrenda in prendasArray) 
            {
                myPrenda.color= etiqColorTextField.text ;
                myPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
            }
            [multipleSelectionDictionary setObject:[(Prenda*)[prendasArray lastObject] color] forKey:@"multipleColor"];
        }
        else
        {

            NSLog(@"asigning color");
            self.prenda.color=etiqColorTextField.text ;
            self.prenda.needsSynchronize=[NSNumber numberWithBool:YES];
            
        }

        // Save the context. 
        NSError *error;
        if (![self.managedObjectContext save:&error]) 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        //update ScrollView on Main PrendaViewController
        [self.delegate updateScrollViewsFromPrendaDetail];

        
    }

    //Store notes text
    if (textField==notesTextField)     
    {
        [notesTextField resignFirstResponder];
        if (isMultiselection) 
        {
            for (Prenda *myPrenda in prendasArray) 
            {
                myPrenda.notas= notesTextField.text ;
                myPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
            }

            [multipleSelectionDictionary setObject:[(Prenda*)[prendasArray lastObject] color] forKey:@"multipleNotas"];
        }
        else
        {

            self.prenda.notas=notesTextField.text ;
            self.prenda.needsSynchronize=[NSNumber numberWithBool:YES];
        }
        // Save the context. 
        NSError *error;
        if (![self.managedObjectContext save:&error]) 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        //update ScrollView on Main PrendaViewController
        [self.delegate updateScrollViewsFromPrendaDetail];

    }

    
    
    [self.myScrollViewEtiqueta setContentOffset:CGPointMake(0 , 0) animated:YES];
    [self.myNotesScrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
    
    //return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
    
}

 
-(IBAction)changeBtnTemporada:(UIButton*)sender;
{
    //Utilizo este parámetro para saber que estoy modificando la temporada, no mostrandola!
    isTemporadaChanging=YES;
    if (sender==BtnInvierno) 
        [self selectBtnTemporada:PrendaTemporadaInvierno];
    if (sender==BtnPrimavera) 
        [self selectBtnTemporada:PrendaTemporadaPrimavera];
    if (sender==BtnVerano) 
        [self selectBtnTemporada:PrendaTemporadaVerano];
    if (sender==BtnOtono) 
        [self selectBtnTemporada:PrendaTemporadaOtono];
    
}

-(void) selectBtnTemporada:(NSInteger) temporadaIndex
{
    BtnInvierno.selected=false;
    BtnPrimavera.selected=false;
    BtnVerano.selected=false;
    BtnOtono.selected=false;
    
    if (temporadaIndex==PrendaTemporadaInvierno) 
    {
        BtnInvierno.selected=true;
    }
    if (temporadaIndex==PrendaTemporadaPrimavera) 
    {
        BtnPrimavera.selected=true;
    }
    if (temporadaIndex==PrendaTemporadaVerano) 
    {
        BtnVerano.selected=true;
    }
    if (temporadaIndex==PrendaTemporadaOtono) 
    {
        BtnOtono.selected=true;
    }

    
    if ( temporadaIndex!=PrendaTemporadaNO  ) 
    {
        //GET PrendaTemporada Array
        NSFetchRequest *requestTemporada = [[NSFetchRequest alloc] init];
        [requestTemporada setEntity:[NSEntityDescription entityForName:@"PrendaTemporada" inManagedObjectContext:self.managedObjectContext]];
        NSString *strTemporada= [NSString stringWithFormat:@"%d",temporadaIndex];
        requestTemporada.predicate =[NSPredicate predicateWithFormat:@"idTemporada == %@",strTemporada];
        NSError *errorTemporada = nil;
        PrendaTemporada *myPrendaTemporada = [[self.managedObjectContext executeFetchRequest:requestTemporada error:&errorTemporada] objectAtIndex:0];
        
        if (isMultiselection)
        {
            for (Prenda *myPrenda in prendasArray) 
            {
                myPrenda.temporada=myPrendaTemporada;
                if (isTemporadaChanging==YES)
                    myPrenda.needsSynchronize=[NSNumber numberWithBool:YES];

            }
        }
        else    
        {

            self.prenda.temporada=myPrendaTemporada;
            if (isTemporadaChanging==YES)
                self.prenda.needsSynchronize=[NSNumber numberWithBool:YES];

        }
        
        NSLog(@"nuevo temporada:%@",prenda.temporada.descripcion);
        

        //Salvo datos en database
        NSError *errorSave = nil;
        if (![self.managedObjectContext save:&errorSave])
            NSLog(@"Unresolved error %@, %@", errorSave, [errorSave userInfo]);

        //update ScrollView on Main PrendaViewController
        [self.delegate updateScrollViewsFromPrendaDetail];

        isTemporadaChanging=NO;
        //[self btnTemporadaClosePressed];
 
    }


    

}




-(void) setDisponibilidadLabelForIndex:(NSInteger) disponibilidadIndex
{
    
    NSString *disponibilidadTitle=NSLocalizedString(@"btnDisponibilidad",@"");
    
    if (disponibilidadIndex==PrendaDisponibilidadDisponible) 
        disponibilidadTitle=NSLocalizedString(@"btnDisponibilidadDisponible",@"");
    if (disponibilidadIndex==PrendaDisponibilidadPrestada) 
        disponibilidadTitle=NSLocalizedString(@"btnDisponibilidadPrestada",@"");
    if (disponibilidadIndex==PrendaDisponibilidadDeseo) 
        disponibilidadTitle=NSLocalizedString(@"btnDisponibilidadDeseo",@"");
    if (disponibilidadIndex==PrendaDisponibilidadColada) 
        disponibilidadTitle=NSLocalizedString(@"btnDisponibilidadColada",@"");

    currentDisponibilidadState=disponibilidadIndex;
    self.disponibilidadLabel.text=disponibilidadTitle;

    
}


-(IBAction)btnPrecioPressed;
{
    
    [self.delegate openPrecioModalView];

}

-(IBAction)btnEtiquetaPressed
{
    
    [self.etiquetaView becomeFirstResponder];
    [self activateView:etiquetaView andShow:YES];

}

-(IBAction)btnEtiquetaClosePressed
{
    [self activateView:etiquetaView andShow:NO];

}


-(void)btnNotesPressed
{
    [self activateView:notesView andShow:YES];

}

-(IBAction)btnNotesClosePressed
{
    
    [self activateView:notesView andShow:NO];

}



-(void) activateView:(UIView*)thisView andShow:(BOOL)activateView
{
    
    if (activateView==YES) 
    {
        [thisView setUserInteractionEnabled:YES];
        [detailsView setUserInteractionEnabled:NO];
        [thisView setHidden:NO];
        
        [self.delegate enableToolBarButtons:NO];
        
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [detailsView setAlpha:0.5];
        [thisView setAlpha:1.0];
        [UIView commitAnimations];

        
    }else
    {

        [thisView setUserInteractionEnabled:NO];
        [detailsView setUserInteractionEnabled:YES];
        [thisView setHidden:NO];
        
        [self.delegate enableToolBarButtons:YES];


        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [detailsView setAlpha:1.0];
        [thisView setAlpha:0.0];
        [UIView commitAnimations];

        
    }
}

 

//Zoom
-(void) swithToFullScreen
{
    
    if (!isMultiselection && isUpdatingToFullScreen==NO ) 
    {
        isUpdatingToFullScreen=YES;
        CGRect frame;
        CGRect frameBackground;
        CGRect frameZoom;
        
        if (self.isFullScreen) 
        {
            NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",prenda.urlPicture] ]; 
            if ( [fileManager fileExistsAtPath:imagePathSmall] ) 
                [self.myImageView setImage: [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePathSmall]  ] ];
            frame =CGRectMake(35,130,160,213); 
            frameBackground =CGRectMake(35,130,160,215); 
            frameZoom =CGRectMake(185,320,40,40); 
            [self.myBtnZoom setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailZoom"] forState:UIControlStateNormal];

        }
        else
        {
            
            NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",prenda.urlPicture] ]; 
            if ( [fileManager fileExistsAtPath:imagePath] ) 
                [self.myImageView setImage: [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]  ] ];
            [self.myBtnZoom setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailZoom"] forState:UIControlStateNormal];

            frame =CGRectMake(0,0,320,372); 
            frameBackground =CGRectMake(0,0,320,372); 
            frameZoom =CGRectMake(273,325,40,40); 
            [self.BtnCategoria setHidden:YES];
            [self.myMarcoImageDetail setHidden:YES];


        }

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDidStopSelector:@selector(finishSwitchToFullScreen:finished:context:)];
        self.myImageView.frame = frame;
        self.myScrollViewBackground.frame = frameBackground;
        self.myBtnImageZoom.frame = frame;
        self.myBtnZoom.frame=frameZoom;

        [UIView commitAnimations];
        
        self.isFullScreen=!self.isFullScreen;
        
        [self.delegate changeImageViewToFullScreen:self.isFullScreen];
    }

}

-(void) ImageViewHasChangedToFullScreen
{
    if (isUpdatingToFullScreen==NO) 
    {

        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",prenda.urlPicture] ]; 
        // UIImage *myImage;
        
        if ( [fileManager fileExistsAtPath:imagePath] ) 
            [self.myImageView setImage: [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]  ] ];
  
        self.myImageView.frame  =CGRectMake(0,0,320,372); 
        self.myScrollViewBackground.frame  =CGRectMake(0,0,320,372); 
        self.myBtnImageZoom.frame  =CGRectMake(0,0,320,372); 
        self.myBtnZoom.frame =CGRectMake(273,325,40,40); 
        [self.myBtnZoom setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailZoom"] forState:UIControlStateNormal];

        [self.BtnCategoria setHidden:YES];
        [self.myMarcoImageDetail setHidden:YES];

        [self btnEtiquetaClosePressed];
        [self btnNotesClosePressed];

    }
}

-(void) ImageViewHasChangedFromFullScreen
{
    if (isUpdatingToFullScreen==NO) 
    {
        NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",prenda.urlPicture] ]; 
        
        if ( [fileManager fileExistsAtPath:imagePathSmall] ) 
            [self.myImageView setImage: [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePathSmall]  ] ];

        
        self.myImageView.frame =CGRectMake(35,130,150,213); 
        self.myScrollViewBackground.frame =CGRectMake(35,130,160,215); 
        self.myBtnImageZoom.frame =CGRectMake(45,72,130,179); 
        self.myBtnZoom.frame =CGRectMake(185,320,40,40); 
        [self.myBtnZoom setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailZoom"] forState:UIControlStateNormal];


        [self.BtnCategoria setHidden:NO];
        [self.myMarcoImageDetail setHidden:NO];
    }
}



- (void)finishSwitchToFullScreen:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    if (!self.isFullScreen) 
    {
        NSLog(@"inside setHidden:NO");

        [self.BtnCategoria setHidden:NO];
        [self.myMarcoImageDetail setHidden:NO];
    }
    NSLog(@"inside finishSwitchToFullScreen");
    isUpdatingToFullScreen=NO;

}

- (void) updateLabels
{
    
    self.prenda=[prendasArray objectAtIndex:currentPrendaPage];
    //NSLog(@"tempPrenda:%@",prenda);
    
    //Temporada View
    [self selectBtnTemporada:[prenda.temporada.idTemporada intValue]];
    //[self selectBtnDisponibilidad:[prenda.estado.idEstado intValue]];
    [self setDisponibilidadLabelForIndex:[prenda.estado.idEstado intValue]];

    //Etiqueta View - Contenido
    
    [tempTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Temporada", @"") ] ];

    [etiqTiendaTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"EtiquetaTienda", @"") ] ];
    [etiqTallaTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"EtiquetaTalla", @"") ] ];
    [etiqColorTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"EtiquetaColor", @"") ] ];
    [etiqComposicionTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"EtiquetaComposicion", @"") ] ];
    
    
    
    //NSLog(@"prenda.marca.descripcion:%@",prenda.marca.descripcion);
    //NSLog(@"prenda.marca:%@",prenda.marca);
    
    [marcaLabel setText:[NSString stringWithFormat:@"%@", prenda.marca.descripcion ] ];
    [etiqTiendaValue setText:[NSString stringWithFormat:@"%@",prenda.tienda.descripcion ] ];
    
    NSString *moneda=@"€";
    [precioLabel setText:[NSString stringWithFormat:@"%0.0f%@",[prenda.precio floatValue],moneda  ] ];
    [etiqColorTextField setText:[NSString stringWithFormat:@"%@",prenda.color ] ];
    NSString *composicionLocalizedKey= [NSString stringWithFormat:@"composition%d",[prenda.composicion integerValue]]; 
    [etiqComposicionValue setText:[NSString stringWithFormat:@"%@",NSLocalizedString(composicionLocalizedKey, @"")]];
    
    //[NSString stringWithFormat:@"%@",prenda.composicion ] ];

    
    //Set Talla Label
    NSInteger talla1= [prenda.talla1 integerValue];
    NSInteger talla2= [prenda.talla2 integerValue];
    NSInteger talla3= [prenda.talla3 integerValue];
    
    NSString *talla1String=@"";
    NSString *talla2String=@"";
    NSString *talla3String=@"";
    NSString *talla12String=@"";
    NSString *talla23String=@"";
    
    if (talla1>0 && (talla2>0 || talla3>0))
        talla12String=@"-";
    if (talla2>0 && talla3>0) 
        talla23String=@"-";

    
    if (talla1>0) 
        talla1String= [NSString stringWithFormat:@"%@", [tallas1 objectAtIndex:talla1] ]; 
    if (talla2>0) 
        talla2String=  [NSString stringWithFormat:@"%.1f", talla2/2.0];
    if (talla3>0) 
        talla3String=  [NSString stringWithFormat:@"%@", [tallas2 objectAtIndex:talla3] ];
    
    if (talla1<=0 && talla2<=0 && talla3<=0) 
        talla1String=NSLocalizedString(@"SinTalla",@"");
    
    [etiqTallaValue setText:[NSString stringWithFormat:@"%@%@%@%@%@",talla1String,talla12String,talla2String,talla23String,talla3String]];

    
    //NotasView - Contenido
    [notesNotasTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"NotesNotas", @"") ] ];
    
    [notesEstadoTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"EstadoTitle", @"") ] ];
    
    //Set Date Format to String - para titleView
    NSDateFormatter *myDateFormat= [[NSDateFormatter alloc] init] ;
    [myDateFormat setDateStyle:NSDateFormatterMediumStyle];
    NSString *myDateString = [myDateFormat stringFromDate:prenda.fechaCompra];    
    [notesTextField setText:[NSString stringWithFormat:@"%@", prenda.notas ] ];

    
    //Set categoria imageView
    if ([prenda.categoria.idCategoria isEqualToString:@"1"]) 
        [self.BtnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"PR1DetailCategoriaTop"] forState:UIControlStateNormal ];
    if ([prenda.categoria.idCategoria isEqualToString:@"2"]) 
        [self.BtnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"PR1DetailCategoriaBotton"] forState:UIControlStateNormal];
    if ([prenda.categoria.idCategoria isEqualToString:@"3"]) 
        [self.BtnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"PR1DetailCategoriaShoes"] forState:UIControlStateNormal];
    if ([prenda.categoria.idCategoria isEqualToString:@"4"]) 
        [self.BtnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"PR1DetailCategoriaAccesssories"] forState:UIControlStateNormal];

    /*//Subcategoria label
    NSString *localizedSubcategoria= [NSString stringWithFormat:@"subCategoria%d_%d", [prenda.categoria.idCategoria integerValue ], [prenda.subcategoria.idSubcategoria integerValue] ];  //NSLocalizedString(@"", @"");
    [subCategoriaLabel setText:NSLocalizedString(localizedSubcategoria,@"")];
    */
    
    
    //[tiendaLabel setText:prenda.tienda.descripcion];
    
}
 

- (void) updateMultipleSelectionLabelsWithDictionary
{
    //[tiendaLabel setText:[multipleSelectionDictionary objectForKey:@"multipleTienda"] ];
    [etiqTiendaValue setText:[multipleSelectionDictionary objectForKey:@"multipleTienda"] ];

    
   /* //Set subcategoria
    if ( [[multipleSelectionDictionary objectForKey:@"multipleCategoria"] isEqualToString:nullString]) 
        [subCategoriaLabel setText:NSLocalizedString(@"CategoryNotValid",@"")];
    else if ([[multipleSelectionDictionary objectForKey:@"multipleSubCategoria"] isEqualToString:nullString])
        [subCategoriaLabel setText:NSLocalizedString(@"NoCategory",@"")];
    else
    {
        //Subcategoria label
        NSString *localizedSubcategoria= [NSString stringWithFormat:@"subCategoria%d_%d", [[multipleSelectionDictionary objectForKey:@"multipleCategoria"] integerValue ], [[multipleSelectionDictionary objectForKey:@"multipleSubCategoria"] integerValue] ];  //
        [subCategoriaLabel setText:NSLocalizedString(localizedSubcategoria,@"")];
        NSLog(@"localizedSubcategoria:%@",localizedSubcategoria);
    }*/

    //Set marca
    if ([[multipleSelectionDictionary objectForKey:@"multipleMarca"] isEqualToString:nullString]) 
        [marcaLabel setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"NullMarca", @"")]];
    else
        [marcaLabel setText:[NSString stringWithFormat:@"%@", prenda.marca.descripcion ] ];

    //set Temporada ImageView
    if ([[multipleSelectionDictionary objectForKey:@"multipleTemporada"] isEqualToString:nullString]) 
        [self selectBtnTemporada:PrendaTemporadaNO];
    else
        [self selectBtnTemporada:[[multipleSelectionDictionary objectForKey:@"multipleTemporada"] intValue]];
    
    //set Disponibilidad Label
    if ([[multipleSelectionDictionary objectForKey:@"multipleEstado"] isEqualToString:nullString]) 
        [self setDisponibilidadLabelForIndex:PrendaDisponibilidadNO];
    else
        [self setDisponibilidadLabelForIndex:[[multipleSelectionDictionary objectForKey:@"multipleEstado"] intValue]];


    //Set categoria imageView
    if ([[multipleSelectionDictionary objectForKey:@"multipleCategoria"] isEqualToString:nullString]) 
        [self.BtnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"PR1DetailCategoriaEmpty"] forState:UIControlStateNormal ];
    else
    {
        NSString *categoriaStr=[multipleSelectionDictionary objectForKey:@"multipleCategoria"];
        NSLog(@"categoriaStr:%@",categoriaStr);
        if ([categoriaStr isEqualToString:@"1"]) 
            [self.BtnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"PR1DetailCategoriaTop"] forState:UIControlStateNormal ];
        if ([categoriaStr isEqualToString:@"2"]) 
            [self.BtnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"PR1DetailCategoriaBotton"] forState:UIControlStateNormal];
        if ([categoriaStr isEqualToString:@"3"]) 
            [self.BtnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"PR1DetailCategoriaShoes"] forState:UIControlStateNormal];
        if ([categoriaStr isEqualToString:@"4"]) 
            [self.BtnCategoria setImage:[StyleDressApp imageWithStyleNamed:@"PR1DetailCategoriaAccesssories"] forState:UIControlStateNormal];

    }
    
    
    //Etiqueta View - Contenido
    [tempTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"Temporada", @"") ] ];

    [etiqTiendaTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"EtiquetaTienda", @"") ] ];
    [etiqTallaTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"EtiquetaTalla", @"") ] ];
    [etiqColorTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"EtiquetaColor", @"") ] ];
    [etiqComposicionTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"EtiquetaComposicion", @"") ] ];

    //NotasView - Contenido
    [notesNotasTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"NotesNotas", @"") ] ];
    [notesEstadoTitle setText:[NSString stringWithFormat:@"%@:",NSLocalizedString(@"EstadoTitle", @"") ] ];

    NSString *moneda=@"€";

    //Set Precio
    if ([  [multipleSelectionDictionary objectForKey:@"multiplePrecio"] floatValue] == -1.0  ) 
        [precioLabel setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"NullPrecio", @"")]];
    else
        [precioLabel setText:[NSString stringWithFormat:@"%.0f%@",[[multipleSelectionDictionary objectForKey:@"multiplePrecio"] floatValue  ],moneda ] ];
    
    
    //Set Talla Label
    NSInteger talla1= [[multipleSelectionDictionary objectForKey:@"multipleTalla1"] integerValue];
    NSInteger talla2= [[multipleSelectionDictionary objectForKey:@"multipleTalla2"] intValue];
    NSInteger talla3= [[multipleSelectionDictionary objectForKey:@"multipleTalla3"] intValue];

    NSString *talla1String=@"";
    NSString *talla2String=@"";
    NSString *talla3String=@"";
    NSString *talla12String=@"";
    NSString *talla23String=@"";
    
    if (talla1>0 && (talla2>0 || talla3>0))
        talla12String=@"-";
    if (talla2>0 && talla3>0) 
            talla23String=@"-";

    if (talla1>0) 
        talla1String=  [NSString stringWithFormat:@"%@", [tallas1 objectAtIndex:talla1] ];
    if (talla2>0) 
        talla2String=  [NSString stringWithFormat:@"%.1f", talla2/2.0];
    if (talla3>0) 
        talla3String=  [NSString stringWithFormat:@"%@", [tallas2 objectAtIndex:talla3] ];

    if (talla1<=0 && talla2<=0 && talla3<=0) 
        talla1String=NSLocalizedString(@"NullTalla",@"");

    [etiqTallaValue setText:[NSString stringWithFormat:@"%@%@%@%@%@",talla1String,talla12String,talla2String,talla23String,talla3String]];

    
    //Set color
    if ([[multipleSelectionDictionary objectForKey:@"multipleColor"] isEqualToString:nullString]) 
        [etiqColorTextField setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"NullColor", @"")]];
    else
        [etiqColorTextField setText:[NSString stringWithFormat:@"%@", [multipleSelectionDictionary objectForKey:@"multipleColor"]] ];

    
    //Set Composición
    if ([  [multipleSelectionDictionary objectForKey:@"multipleComposicion"] integerValue] == -1 ) 
        [etiqComposicionValue setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"NullComposicion", @"")]];
    else
    {
        NSString *composicionLocalizedKey= [NSString stringWithFormat:@"composition%d",[[multipleSelectionDictionary objectForKey:@"multipleComposicion"] integerValue]]; 
        [etiqComposicionValue setText:[NSString stringWithFormat:@"%@", NSLocalizedString(composicionLocalizedKey, @"")]];
    }
    
    //Set Notas
    if ([[multipleSelectionDictionary objectForKey:@"multipleNotas"] isEqualToString:nullString]) 
        [notesTextField   setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"NullNotas",@"") ]];
    else
        [notesTextField setText:[NSString stringWithFormat:@"%@", [multipleSelectionDictionary objectForKey:@"multipleNotas"] ]];
    
    
}


-(void) openDisponibilidadAction
{
    [self.delegate openDisponibilidadActionWithSelectedIndex:currentDisponibilidadState];
}


 
-(IBAction)openCategoriaModalView
{
    if (isMultiselection ) 
    {
        
        if ([[multipleSelectionDictionary objectForKey:@"multipleCategoria"] isEqualToString:nullString]) 
            [self.delegate openCategoryActionWithSelectedIndex:4 ]; //Boton de cancelar

        else
        {
            NSInteger categoriaIndex=[[multipleSelectionDictionary objectForKey:@"multipleCategoria"] integerValue];
             [self.delegate openCategoryActionWithSelectedIndex:categoriaIndex-1 ];
        }
        
    }else
    {
        self.prenda=[prendasArray objectAtIndex:currentPrendaPage];
        [self.delegate openCategoryActionWithSelectedIndex:[prenda.categoria.idCategoria integerValue]-1 ];
    }
}


-(IBAction)openMarcaModalView
{
    
    [self.delegate openMarcasModalView];
}

-(IBAction)openTallaModalView
{
    [self.delegate openTallasModalView];

}


-(IBAction)openComposicionModalView
{
    [self.delegate openComposicionModalView];
    
}
    
-(IBAction)openFechaModalView
{
    [self.delegate openFechaModalView];

    
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger count = [datesUsedArray count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
     
}   
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"section:%d row:%d",indexPath.section,indexPath.row);
    static NSString *ConjuntoDetailCellIdentifier = @"ConjuntoDetailCellIdentifier";
    
    
    UITableViewCell *conjuntoDetailCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConjuntoDetailCellIdentifier];
    if (conjuntoDetailCell == nil) {
        conjuntoDetailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ConjuntoDetailCellIdentifier] ;
		conjuntoDetailCell.accessoryType = UITableViewCellAccessoryNone;
        [conjuntoDetailCell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
        [conjuntoDetailCell setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *cellFrameImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,230,34)];
        [cellFrameImageView setTag:10];
        [cellFrameImageView setImage:[StyleDressApp imageWithStyleNamed:@"PRONotesTextFrame"]];
        [conjuntoDetailCell.contentView addSubview:cellFrameImageView];
        //CODetailNotesTableFrame
        
        
        UILabel *cellTextLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 5, 75,24)];
        [cellTextLabel setTag:11];
        [cellTextLabel setFont:[UIFont systemFontOfSize:18]];
        [cellTextLabel setTextColor:[UIColor blackColor]];
        [cellTextLabel setBackgroundColor:[UIColor clearColor]];
        [conjuntoDetailCell.contentView addSubview:cellTextLabel];
        
        UILabel *cellDetailTextLabel=[[UILabel alloc] initWithFrame:CGRectMake(83, 5, 110,24)];
        [cellDetailTextLabel setTag:12];
        [cellDetailTextLabel setFont:[UIFont systemFontOfSize:12]];
        [cellDetailTextLabel setTextColor:[UIColor blackColor]];
        [cellDetailTextLabel setBackgroundColor:[UIColor clearColor]];
        [cellDetailTextLabel setAlpha:0.5];
        [conjuntoDetailCell.contentView addSubview:cellDetailTextLabel];
        
        
        UIImageView *conjuntoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(195,1,30,30)];
        [conjuntoImageView setTag:13];
      //  [conjuntoImageView setImage:[StyleDressApp imageWithStyleNamed:@"CODetailNotesTableFrame"]];
        [conjuntoDetailCell.contentView addSubview:conjuntoImageView];

        //    conjuntoDetailCell.detailTextLabel.font=myFont;
        
    }
    
    //Get Current Calendar Conjunto
    CalendarConjunto *thisCalendarConjunto =(CalendarConjunto*)[datesUsedArray objectAtIndex:indexPath.section];
    
    //Set Date Format to String
    NSDateFormatter *myDateFormat= [[NSDateFormatter alloc] init] ;
    NSLocale *myLocale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"locale", @"")];
    [myDateFormat setLocale: myLocale] ;
    [myDateFormat setDateStyle:NSDateFormatterShortStyle]; //
    NSString *myDateString = [myDateFormat stringFromDate:thisCalendarConjunto.fecha];    
    
    
    //Get table TextCellLabel
    UILabel *cellTextLabel= (UILabel*) [conjuntoDetailCell.contentView viewWithTag:11];
    cellTextLabel.text=myDateString;
    
    //Get table DetailTextCellLabel
    UILabel *cellDetailTextLabel= (UILabel*) [conjuntoDetailCell.contentView viewWithTag:12];
    cellDetailTextLabel.text=thisCalendarConjunto.nota;

    
    //Get conjunto image from disk   
    NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",thisCalendarConjunto.conjunto.urlPicture] ]; 
    UIImage *myImage= [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePathSmall] ];

    //Set conjuntoImage on TableCel ImageView
    UIImageView *conjuntoImageView= (UIImageView*) [ conjuntoDetailCell.contentView viewWithTag:13];
    conjuntoImageView.image=myImage;
    
    

    
    //NSLog(@"calendarConjunto.nota:%@",calendarConjunto.nota);
    
    return conjuntoDetailCell;
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




