//
//  StyleDressApp.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 12/24/11.
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


#import "StyleDressApp.h"

@implementation StyleDressApp

static StyleType AppStyle;


+(void) setStyle:(StyleType)newAppStyle
{
    AppStyle=newAppStyle;
}

+(StyleType) getStyle
{
    return AppStyle;
}

//Devuelve el FONT correspondiente al estilo actual (ST01... ST02...)
+(UIFont*) fontWithStyleNamed:(StyleFontType)newFontType AndSize:(CGFloat)newFontSize  
{
    if (AppStyle==StyleTypeVintage) 
    {
        //DancingScript-Bold 
        if (newFontType==StyleFontMainType) 
            return[UIFont fontWithName:@"DancingScript-Bold" size:newFontSize];
        if (newFontType==StyleFontFlat) 
            return[UIFont systemFontOfSize: newFontSize];
        if (newFontType==StyleFontBottomBtns) 
            return[UIFont systemFontOfSize: newFontSize];
        if (newFontType==StyleFontActionView) 
            return[UIFont systemFontOfSize: newFontSize];
        if (newFontType==StyleFontAparienciaST02)
        {
            float fontFactor=0.9;
            return[UIFont fontWithName:@"Opificio" size:newFontSize*fontFactor];
        }
        
    }
    else if (AppStyle==StyleTypeModern) 
    {
        //Opificio Font
        float fontFactor=0.9;
        if (newFontType==StyleFontMainType) 
            return[UIFont fontWithName:@"Opificio" size:newFontSize*fontFactor];
        if (newFontType==StyleFontFlat) 
            return[UIFont systemFontOfSize: newFontSize];
        if (newFontType==StyleFontBottomBtns) 
            return[UIFont systemFontOfSize: newFontSize];
        if (newFontType==StyleFontActionView) 
            return[UIFont systemFontOfSize: newFontSize];
        if (newFontType==StyleFontAparienciaST01)
            return[UIFont fontWithName:@"DancingScript-Bold" size:newFontSize];
        
    }    
    return[UIFont systemFontOfSize: newFontSize];
}

//Devuelve la imagen correspondiente al estilo actual (ST01... ST02...)
+(UIImage*) imageWithStyleNamed:(NSString*)imageName
{
    NSString *imageNameWithStyle;
    NSString *thisPath;
        
    imageNameWithStyle=[NSString stringWithFormat:@"ST%02d%@",AppStyle, imageName];
    thisPath=[ [NSBundle mainBundle] pathForResource:imageNameWithStyle ofType:@"png"];
    
    UIImage *thisImage= [UIImage imageWithContentsOfFile:thisPath];
    return thisImage;
}


 +(UIColor*) colorWithStyleForObject:(StyleColorType)styleColor
{
    
    UIColor *white= [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1.0]; 

    if (styleColor==StyleColorStyleST01DetailInAppText)
        return white;
    if (styleColor==StyleColorStyleST02DetailInAppText)
        return white;

    UIColor *ST01Header= [UIColor colorWithRed:126./255. green:80./255. blue:56./255. alpha:1];  //darkBrown
    UIColor *ST02Header= [UIColor colorWithRed:190/255. green:205/255. blue:40./255. alpha:1];  //greenHeader
    UIColor *ST01HeadetText= [UIColor colorWithRed:247./255. green:236./255. blue:216./255. alpha:1.0]; //cream
    UIColor *ST02HeadetText= [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:1.0];  //black

    if (styleColor==StyleColorStyleST01DetailInAppHeaderColor)
        return ST01Header;
    if (styleColor==StyleColorStyleST02DetailInAppHeaderColor)
        return ST02Header;
    if (styleColor==StyleColorStyleST01DetailInAppHeaderTextColor)
        return ST01HeadetText;
    if (styleColor==StyleColorStyleST02DetailInAppHeaderTextColor)
        return ST02HeadetText;
    
    if (AppStyle==StyleTypeVintage) 
    {
        UIColor *darkBrown= [UIColor colorWithRed:126./255. green:80./255. blue:56./255. alpha:1]; 
        UIColor *lightBrown= [UIColor colorWithRed:66./255. green:40./255. blue:23./255. alpha:1];

        UIColor *green= [UIColor colorWithRed:133./255. green:178./255. blue:184./255. alpha:1.0]; 
        UIColor *black= [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:1.0];
        UIColor *cream= [UIColor colorWithRed:247./255. green:236./255. blue:216./255. alpha:1.0];
        UIColor *white= [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1.0]; 
        UIColor *red= [UIColor colorWithRed:255./255. green:0/255. blue:0/255. alpha:1.0]; 

        UIColor *clear= [UIColor clearColor]; 
        UIColor *whiteDimmed= [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.4]; 
        UIColor *creamDimmed= [UIColor colorWithRed:247./255. green:236./255. blue:216./255. alpha:0.4];

        if (styleColor==StyleColorMainNavigationBar)   
            return darkBrown;

        if (styleColor==StyleColorMainToolBar)    
            return darkBrown;

        //Prendas Main View
        if (styleColor==StyleColorPRBackground)  
            return green;
        if (styleColor==StyleColorPRSectionSeparator)  
            return black;
        if (styleColor==StyleColorPREmptyCategoria)  
            return cream;
        if (styleColor==StyleColorPRHeader) 
            return cream;
        
        //Prendas Detail
        if (styleColor==StyleColorPRDetailBackground)  
            return green;
        if (styleColor==StyleColorPRDetailHeader)   
            return cream;
        if (styleColor==StyleColorPRDetailBackgroundPrenda) 
            return cream;
        if (styleColor==StyleColorPRDetailMarcaTitle)     
            return cream;
        if (styleColor==StyleColorPRDetailPrecio)  
            return lightBrown;
        if (styleColor==StyleColorPRDetailEtiqueta)  
            return lightBrown;

        //Prendas Detail - Seccion Notas
        if (styleColor==StyleColorPRNotasBtnFont)     
            return cream;
        if (styleColor==StyleColorPRNotasSectionTitle)  
            return lightBrown;
        if (styleColor==StyleColorPRNotasCell)  
            return lightBrown;
        
        //Prendas Detail - Seccion Etiqueta
        if (styleColor==StyleColorPREtiquetasSectionTitle) 
            return lightBrown;
        if (styleColor==StyleColorPREtiquetasCell)  
            return lightBrown;

        //Prendas Detail - Seccion Categorias
        if (styleColor==StyleColorPRCategoriaHeader)  
            return lightBrown;
        if (styleColor==StyleColorPRCategoriaSectionTitle)  
            return lightBrown;
        if (styleColor==StyleColorPRCategoriaCell)   
            return black;
        if (styleColor==StyleColorPRCategoriaCellBackground) 
            return cream;
        if (styleColor==StyleColorPRCategoriaCellSeparatorLine)   
            return darkBrown;

        //Prendas Detail - Seccion Talla
        if (styleColor==StyleColorPRTallaHeader)  
            return lightBrown;
        if (styleColor==StyleColorPRTallaSectionTitle) 
            return lightBrown;
        if (styleColor==StyleColorPRTallaCell)   
            return black;
        if (styleColor==StyleColorPRTallaResetBtn)
            return white;
        
        //Prendas Detail - Seccion Mis Marcas
        if (styleColor==StyleColorPRMisMarcasHeader)
            return lightBrown;
        if (styleColor==StyleColorPRMisMarcasEmptySectionTitle)  
            return lightBrown;
        if (styleColor==StyleColorPRMisMarcasCell)   
            return black;
        if (styleColor==StyleColorPRMisMarcasCellBackground)   
            return cream;
        if (styleColor==StyleColorPRMisMarcasCellSeparatorLine) 
            return darkBrown;

        //Prendas Detail - Seccion Marcas
        if (styleColor==StyleColorPRMarcasHeader)   
            return cream;
        if (styleColor==StyleColorPRMarcasCell)   
            return black;
        if (styleColor==StyleColorPRMarcasCellBackground)
            return cream;
        if (styleColor==StyleColorPRMarcasCellSeparatorLine) 
            return darkBrown;

        //Prendas Detail - Seccion Composicion
        if (styleColor==StyleColorPRCompHeader)   
            return lightBrown;
        if (styleColor==StyleColorPRCompCell)   
            return black;
        
        //Prendas Detail - Seccion Precio
        if (styleColor==StyleColorPRPrecioHeader)  
            return lightBrown;
        if (styleColor==StyleColorPRPrecioCell)   
            return black;
        
        //Main Menu
        if (styleColor==StyleColorMainMenuBackground)    
            return cream;
        if (styleColor==StyleColorMainMenuHeader)    
            return cream;
        if (styleColor==StyleColorMainMenuSection)   
            return lightBrown;
        if (styleColor==StyleColorMainMenuSectionBackground) 
            return green;
        if (styleColor==StyleColorMainMenuCell)    
            return lightBrown;
        if (styleColor==StyleColorMainMenuCellBackground)  
            return cream;
        if (styleColor==StyleColorMainMenuCellForegroundView)  
            return clear;

        //Conjuntos
        if (styleColor==StyleColorCOBackground)   
            return green;
        if (styleColor==StyleColorCOEmptyConjunto)  
            return lightBrown;
        if (styleColor==StyleColorCOHeader)    
            return cream;
      
        //Conjuntos Detail
        if (styleColor==StyleColorCODetailBackground)    
            return green;
        if (styleColor==StyleColorCODetailHeader)   
            return cream;
        if (styleColor==StyleColorCODetailTollBarButtons)  
            return lightBrown;

        //Conjuntos Detail - Seccion Categorias
        if (styleColor==StyleColorCOCategoriaHeader)    
            return lightBrown;
        if (styleColor==StyleColorCOCategoriaCell)   
            return black;
        if (styleColor==StyleColorCOCategoriaCellBackground)
            return cream;
        if (styleColor==StyleColorCOCategoriaCellSeparatorLine)   
            return darkBrown;

        //Conjuntos Detail - Seccion Notas
        if (styleColor==StyleColorCONotasHeader)    
            return lightBrown;
        if (styleColor==StyleColorCONotasSectionTitle)  
            return lightBrown;
        if (styleColor==StyleColorCONotasCell)  
            return lightBrown;

        //Action View Controller
        if (styleColor==StyleColorActionViewBackground)   
            return green;
        if (styleColor==StyleColorActionViewTitle)  
            return black;
        if (styleColor==StyleColorActionViewCell)  
            return lightBrown;
        if (styleColor==StyleColorActionViewCellSelected) 
            return green;

        //Help
        if (styleColor==StyleColorHelpCell) 
            return black;
        if (styleColor==StyleColorHelpCellBackground)   
            return green;
        if (styleColor==StyleColorHelpCellSeparatorLine) 
            return darkBrown;
        if (styleColor==StyleColorHelpVersion)  
            return lightBrown;
        if (styleColor==StyleColorHelpDetailTitle) 
            return lightBrown;
        if (styleColor==StyleColorHelpDetailText)  
            return lightBrown;
           
        //Profile
        if (styleColor==StyleColorProfileBtnTitle)    
            return white;
        if (styleColor==StyleColorProfileBtnRecoverPwdTitle)    
            return white;
        if (styleColor==StyleColorProfileBtnRecoverPwdTitleInverse)
            return black;
        
        if (styleColor==StyleColorProfileDetailBtnTitle)     
            return white;
        if (styleColor==StyleColorProfileDetailTextView)     
            return lightBrown;

        if (styleColor==StyleColorRegisterWelcomeTitle)     
            return black;
        if (styleColor==StyleColorRegisterWelcomeBtn)     
            return white;
        
        //Fecha view controller
        if (styleColor==StyleColorFechaHeader)     
            return cream;
        
        //Your Style
        if (styleColor==StyleColorYourStyleHeader)     
            return cream;
        if (styleColor==StyleColorYourStyleBtnTitle)    
            return white;
        
        //Your Style - Cual es tu estilo
        if (styleColor==StyleColorYourStyleCualEsBackground)   
            return green;
        if (styleColor==StyleColorYourStyleCualEsHeader)     
            return cream;
        if (styleColor==StyleColorYourStyleCualEsTitle)     
            return lightBrown;
        if (styleColor==StyleColorYourStyleCualEsText)     
            return lightBrown;
        
        //Your Style - Fashion Victim
        if (styleColor==StyleColorYourStyleFashionBackground)   
            return green;
        if (styleColor==StyleColorYourStyleFashionHeader)     
            return cream;
        if (styleColor==StyleColorYourStyleFashionTitle)     
            return lightBrown;
        if (styleColor==StyleColorYourStyleFashionText)     
            return lightBrown;
        
        // Calendar
        if (styleColor==StyleColorCalendarBackground)     
            return green;
        if (styleColor==StyleColorCalendarMonthTitle)     
            return black;
        if (styleColor==StyleColorCalendarWeekDayTitle)     
            return black;
        if (styleColor==StyleColorCalendarDay)     
            return black;
        if (styleColor==StyleColorCalendarOtherMonthDay)   
            return black;
        if (styleColor==StyleColorCalendarWeekendDay)     
            return red;
        if (styleColor==StyleColorCalendarFillToday) //StyleColorCalendarToday     
            return darkBrown;
        if (styleColor==StyleColorCalendarFillNormalDay)     
            return cream;
        if (styleColor==StyleColorCalendarFillOtherMonthDay)   
            return creamDimmed;
        if (styleColor==StyleColorCalendarSelectedDay)     
            return green;
        
        // Calendar - Calendar detail
        if (styleColor==StyleColorCalendarDetailBackground)  
            return green;
        if (styleColor==StyleColorCalendarDetailHeader)     
            return cream;
        
        //Styles
        if (styleColor==StyleColorStylesHeader)     
            return cream;
        if (styleColor==StyleColorStylesTitle)     
            return cream;
        
        if (styleColor==StyleColorStylesDetailHeader)     
            return cream;

        //Sort View
        if (styleColor==StyleColorSortBackground)   
            return green;
        if (styleColor==StyleColorSortTitleColor)   
            return white;
        if (styleColor==StyleColorSortCellText)   
            return black;
        if (styleColor==StyleColorSortCellBackground)   
            return cream;

        //Sort Notes
        if (styleColor==StyleColorSortNotesBackground)   
            return whiteDimmed;
        if (styleColor==StyleColorSortNotesCellText)   
            return black;
    }else if (AppStyle==StyleTypeModern)
    {
    
        UIColor *greenHeader= [UIColor colorWithRed:190/255. green:205/255. blue:40./255. alpha:1]; 
        UIColor *lightBrown= [UIColor colorWithRed:66./255. green:40./255. blue:23./255. alpha:1];
        
        UIColor *orangeBkg= [UIColor colorWithRed:243./255. green:147./255. blue:0./255. alpha:1.0]; 
        UIColor *redBkg= [UIColor colorWithRed:206/255. green:54./255. blue:105./255. alpha:1.0]; 

        UIColor *lightGray= [UIColor colorWithRed:215./255. green:216./255. blue:220./255. alpha:1.0];
        UIColor *lightGreenDimmed= [UIColor colorWithRed:148/255. green:179./255. blue:138/255. alpha:0.75];
        
        UIColor *black= [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:1.0]; 
        UIColor *white= [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1.0]; 
        UIColor *red= [UIColor colorWithRed:255./255. green:0/255. blue:0/255. alpha:1.0]; 
        UIColor *redCalendar= [UIColor colorWithRed:206./255. green:54./255. blue:105./255. alpha:1.0];
        
        UIColor *violet= [UIColor colorWithRed:152/255. green:15/255. blue:110/255. alpha:1.0]; 
        UIColor *yellow= [UIColor colorWithRed:255/255. green:234/255. blue:0/255. alpha:1.0]; 
        
        UIColor *whiteAlpha= [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.75]; 
        UIColor *whiteDimmed= [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:.4]; 

        if (styleColor==StyleColorMainNavigationBar)   
            return greenHeader;
        
        if (styleColor==StyleColorMainToolBar)    
            return greenHeader;
        
        //Prendas Main View
        if (styleColor==StyleColorPRBackground)  
            return orangeBkg;
        if (styleColor==StyleColorPRSectionSeparator)  
            return [UIColor clearColor];
        if (styleColor==StyleColorPREmptyCategoria)  
            return black;
        if (styleColor==StyleColorPRHeader) 
            return black;
        
        //Prendas Detail
        if (styleColor==StyleColorPRDetailBackground)  
            return orangeBkg;
        if (styleColor==StyleColorPRDetailHeader)   
            return black;
        if (styleColor==StyleColorPRDetailBackgroundPrenda) 
            return white;
        if (styleColor==StyleColorPRDetailMarcaTitle)     
            return black;
        if (styleColor==StyleColorPRDetailPrecio)  
            return lightBrown;
        if (styleColor==StyleColorPRDetailEtiqueta)  
            return lightBrown;
        
        //Prendas Detail - Seccion Notas
        if (styleColor==StyleColorPRNotasBtnFont)     
            return white;
        if (styleColor==StyleColorPRNotasSectionTitle)  
            return lightBrown;
        if (styleColor==StyleColorPRNotasCell)  
            return lightBrown;
        
        //Prendas Detail - Seccion Etiqueta
        if (styleColor==StyleColorPREtiquetasSectionTitle) 
            return lightBrown;
        if (styleColor==StyleColorPREtiquetasCell)  
            return lightBrown;
        
        //Prendas Detail - Seccion Categorias
        if (styleColor==StyleColorPRCategoriaHeader)  
            return lightBrown;
        if (styleColor==StyleColorPRCategoriaSectionTitle)  
            return white;
        if (styleColor==StyleColorPRCategoriaCell)   
            return black;
        if (styleColor==StyleColorPRCategoriaCellBackground) 
            return white;
        if (styleColor==StyleColorPRCategoriaCellSeparatorLine)   
            return greenHeader;
        
        //Prendas Detail - Seccion Talla
        if (styleColor==StyleColorPRTallaHeader)  
            return lightBrown;
        if (styleColor==StyleColorPRTallaSectionTitle) 
            return white;
        if (styleColor==StyleColorPRTallaCell)   
            return black;
        if (styleColor==StyleColorPRTallaResetBtn)
            return black;
        
        //Prendas Detail - Seccion Mis Marcas
        if (styleColor==StyleColorPRMisMarcasHeader)
            return lightBrown;
        if (styleColor==StyleColorPRMisMarcasEmptySectionTitle)  
            return white;
        if (styleColor==StyleColorPRMisMarcasCell)   
            return black;
        if (styleColor==StyleColorPRMisMarcasCellBackground)   
            return white;
        if (styleColor==StyleColorPRMisMarcasCellSeparatorLine) 
            return greenHeader;
        
        //Prendas Detail - Seccion Marcas
        if (styleColor==StyleColorPRMarcasHeader)   
            return black;
        if (styleColor==StyleColorPRMarcasCell)   
            return black;
        if (styleColor==StyleColorPRMarcasCellBackground)
            return white;
        if (styleColor==StyleColorPRMarcasCellSeparatorLine) 
            return greenHeader;
        
        //Prendas Detail - Seccion Composicion
        if (styleColor==StyleColorPRCompHeader)   
            return lightBrown;
        if (styleColor==StyleColorPRCompCell)   
            return black;
        
        //Prendas Detail - Seccion Precio
        if (styleColor==StyleColorPRPrecioHeader)  
            return lightBrown;
        if (styleColor==StyleColorPRPrecioCell)   
            return black;
        
        //Main Menu
        if (styleColor==StyleColorMainMenuBackground)    
            return redBkg;
        if (styleColor==StyleColorMainMenuHeader)    
            return black;
        if (styleColor==StyleColorMainMenuSection)   
            return white;
        if (styleColor==StyleColorMainMenuSectionBackground) 
            return orangeBkg;
        if (styleColor==StyleColorMainMenuCell)    
            return lightBrown;
        if (styleColor==StyleColorMainMenuCellBackground)  
            return white;
        if (styleColor==StyleColorMainMenuCellForegroundView)  
            return whiteAlpha;
        
        //Conjuntos
        if (styleColor==StyleColorCOBackground)   
            return orangeBkg;
        if (styleColor==StyleColorCOEmptyConjunto)  
            return white;
        if (styleColor==StyleColorCOHeader)    
            return black;
        
        //Conjuntos Detail
        if (styleColor==StyleColorCODetailBackground)    
            return yellow;
        if (styleColor==StyleColorCODetailHeader)   
            return black;
        if (styleColor==StyleColorCODetailTollBarButtons)  
            return lightBrown;
        
        //Conjuntos Detail - Seccion Categorias
        if (styleColor==StyleColorCOCategoriaHeader)    
            return lightBrown;
        if (styleColor==StyleColorCOCategoriaCell)   
            return black;
        if (styleColor==StyleColorCOCategoriaCellBackground)
            return white;
        if (styleColor==StyleColorCOCategoriaCellSeparatorLine)   
            return greenHeader;
        
        //Conjuntos Detail - Seccion Notas
        if (styleColor==StyleColorCONotasHeader)    
            return lightBrown;
        if (styleColor==StyleColorCONotasSectionTitle)  
            return lightBrown;
        if (styleColor==StyleColorCONotasCell)  
            return lightBrown;
        
        //Action View Controller
        if (styleColor==StyleColorActionViewBackground)   
            return orangeBkg;
        if (styleColor==StyleColorActionViewTitle)  
            return black;
        if (styleColor==StyleColorActionViewCell)  
            return lightBrown;
        if (styleColor==StyleColorActionViewCellSelected) 
            return white;
        
        //Help
        if (styleColor==StyleColorHelpCell) 
            return white;
        if (styleColor==StyleColorHelpCellBackground)   
            return violet;
        if (styleColor==StyleColorHelpCellSeparatorLine) 
            return greenHeader;
        if (styleColor==StyleColorHelpVersion)  
            return white;
        if (styleColor==StyleColorHelpDetailTitle) 
            return white;
        if (styleColor==StyleColorHelpDetailText)  
            return white;
        
        //Profile
        if (styleColor==StyleColorProfileBtnTitle)    
            return white;
        if (styleColor==StyleColorProfileBtnRecoverPwdTitle)    
            return black;
        if (styleColor==StyleColorProfileBtnRecoverPwdTitleInverse)
            return white;
        if (styleColor==StyleColorProfileDetailBtnTitle)     
            return white;
        if (styleColor==StyleColorProfileDetailTextView)     
            return lightBrown;
        
        if (styleColor==StyleColorRegisterWelcomeTitle)     
            return black;
        if (styleColor==StyleColorRegisterWelcomeBtn)     
            return white;
        
        //Fecha view controller
        if (styleColor==StyleColorFechaHeader)     
            return black;
        
        //Your Style
        if (styleColor==StyleColorYourStyleHeader)     
            return black;
        if (styleColor==StyleColorYourStyleBtnTitle)    
            return white;
        
        //Your Style - Cual es tu estilo
        if (styleColor==StyleColorYourStyleCualEsBackground)   
            return orangeBkg;
        if (styleColor==StyleColorYourStyleCualEsHeader)     
            return black;
        if (styleColor==StyleColorYourStyleCualEsTitle)     
            return lightBrown;
        if (styleColor==StyleColorYourStyleCualEsText)     
            return lightBrown;
        
        //Your Style - Fashion Victim
        if (styleColor==StyleColorYourStyleFashionBackground)   
            return orangeBkg;
        if (styleColor==StyleColorYourStyleFashionHeader)     
            return black;
        if (styleColor==StyleColorYourStyleFashionTitle)     
            return lightBrown;
        if (styleColor==StyleColorYourStyleFashionText)     
            return lightBrown;
        
        // Calendar
        if (styleColor==StyleColorCalendarBackground)     
            return redCalendar;
        if (styleColor==StyleColorCalendarMonthTitle)     
            return white;
        if (styleColor==StyleColorCalendarWeekDayTitle)     
            return white;
        if (styleColor==StyleColorCalendarDay)     
            return black;
        if (styleColor==StyleColorCalendarOtherMonthDay)   
            return black;
        if (styleColor==StyleColorCalendarWeekendDay)     
            return red;
        if (styleColor==StyleColorCalendarFillToday)      
            return orangeBkg;
        if (styleColor==StyleColorCalendarFillNormalDay)     
            return lightGray;
        if (styleColor==StyleColorCalendarFillOtherMonthDay)   
            return lightGreenDimmed;
        if (styleColor==StyleColorCalendarSelectedDay)     
            return orangeBkg;
        
        // Calendar - Calendar detail
        if (styleColor==StyleColorCalendarDetailBackground)  
            return orangeBkg;
        if (styleColor==StyleColorCalendarDetailHeader)     
            return black;
        
        //Styles
        if (styleColor==StyleColorStylesHeader)     
            return black;
        if (styleColor==StyleColorStylesTitle)     
            return white;
        
        //Styles - Detail
        if (styleColor==StyleColorStylesDetailHeader)     
            return black;
        //Sort View
        if (styleColor==StyleColorSortBackground)   
            return orangeBkg;
        if (styleColor==StyleColorSortTitleColor)   
            return white;
        if (styleColor==StyleColorSortCellText)   
            return black;
        if (styleColor==StyleColorSortCellBackground)   
            return white;

        //Sort Notes
        if (styleColor==StyleColorSortNotesBackground)   
            return whiteDimmed;
        if (styleColor==StyleColorSortNotesCellText)   
            return black;

    }     

    return nil;
}

@end
