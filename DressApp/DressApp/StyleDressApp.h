//
//  StyleDressApp.h
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


#import <Foundation/Foundation.h>

typedef enum {
    StyleTypeVintage = 1,    
    StyleTypeModern =2,  
} StyleType;

typedef enum {
    
    StyleColorMainNavigationBar,
    StyleColorMainToolBar,
    
    StyleColorPREmptyCategoria,
    StyleColorPRHeader,
    StyleColorPRBackground,
    StyleColorPRSectionSeparator,
    
    StyleColorPRDetailHeader,
    StyleColorPRDetailMarcaTitle,
    StyleColorPRDetailMarcaName,
    StyleColorPRDetailPrecio,
    StyleColorPRDetailEtiqueta,
    StyleColorPRDetailBackground,
    StyleColorPRDetailBackgroundPrenda,
    
    StyleColorPRNotasSectionTitle,
    StyleColorPRNotasCell,
    StyleColorPRNotasBtnFont,

    StyleColorPREtiquetasSectionTitle,
    StyleColorPREtiquetasCell,

    StyleColorPRCategoriaHeader,
    StyleColorPRCategoriaSectionTitle,
    StyleColorPRCategoriaCell,
    StyleColorPRCategoriaCellBackground,
    StyleColorPRCategoriaCellSeparatorLine,
    
    StyleColorPRPrecioHeader,
    StyleColorPRPrecioCell,

    StyleColorPRTallaHeader,
    StyleColorPRTallaSectionTitle,
    StyleColorPRTallaCell,
    StyleColorPRTallaResetBtn,

    StyleColorPRCompHeader,
    StyleColorPRCompCell,
    
    StyleColorPRMisMarcasHeader, 
    StyleColorPRMisMarcasEmptySectionTitle,
    StyleColorPRMisMarcasCell,
    StyleColorPRMisMarcasCellBackground,
    StyleColorPRMisMarcasCellSeparatorLine,
    
    StyleColorPRMarcasHeader,
    StyleColorPRMarcasCell,
    StyleColorPRMarcasCellBackground,
    StyleColorPRMarcasCellSeparatorLine,
    
    StyleColorMainMenuBackground,
    StyleColorMainMenuHeader,
    StyleColorMainMenuSection,
    StyleColorMainMenuSectionBackground,
    StyleColorMainMenuCell,
    StyleColorMainMenuCellBackground,
    StyleColorMainMenuCellForegroundView,
    
    StyleColorCOEmptyConjunto,
    StyleColorCOHeader,
    StyleColorCOBackground,
    
    StyleColorCODetailHeader,
    StyleColorCODetailBackground,
    StyleColorCODetailTollBarButtons,

    StyleColorCOCategoriaHeader,
    StyleColorCOCategoriaCell,
    StyleColorCOCategoriaCellBackground,
    StyleColorCOCategoriaCellSeparatorLine,

    StyleColorCONotasHeader,
    StyleColorCONotasSectionTitle,
    StyleColorCONotasCell,

    StyleColorActionViewBackground,
    StyleColorActionViewTitle,
    StyleColorActionViewCell,
    StyleColorActionViewCellSelected,
    
    StyleColorHelpCell,
    StyleColorHelpCellBackground,
    StyleColorHelpCellSeparatorLine,
    StyleColorHelpVersion,
    StyleColorHelpDetailTitle,
    StyleColorHelpDetailText,

    StyleColorProfileBtnTitle,
    StyleColorProfileBtnRecoverPwdTitle,
    StyleColorProfileBtnRecoverPwdTitleInverse,

    StyleColorProfileDetailBtnTitle,
    StyleColorProfileDetailTextView,
    StyleColorRegisterWelcomeTitle,
    StyleColorRegisterWelcomeBtn,
    
    StyleColorFechaHeader,

    StyleColorYourStyleHeader,
    StyleColorYourStyleBtnTitle,

    StyleColorYourStyleCualEsBackground,
    StyleColorYourStyleCualEsHeader,
    StyleColorYourStyleCualEsTitle,
    StyleColorYourStyleCualEsText,

    StyleColorYourStyleFashionBackground,
    StyleColorYourStyleFashionHeader,
    StyleColorYourStyleFashionTitle,
    StyleColorYourStyleFashionText,

    StyleColorCalendarBackground,
    StyleColorCalendarMonthTitle,
    StyleColorCalendarWeekDayTitle,
    StyleColorCalendarDay,
    StyleColorCalendarOtherMonthDay,
    StyleColorCalendarWeekendDay,
    StyleColorCalendarFillToday,
    StyleColorCalendarFillNormalDay,
    StyleColorCalendarFillOtherMonthDay,
    StyleColorCalendarSelectedDay,
    
    StyleColorCalendarDetailHeader,
    StyleColorCalendarDetailBackground,
 
    StyleColorStylesHeader,
    StyleColorStylesTitle,

    StyleColorStylesDetailHeader,
    StyleColorStyleST01DetailInAppHeaderColor,
    StyleColorStyleST02DetailInAppHeaderColor,
    StyleColorStyleST01DetailInAppHeaderTextColor,
    StyleColorStyleST02DetailInAppHeaderTextColor,
    StyleColorStyleST01DetailInAppText,
    StyleColorStyleST02DetailInAppText,

    StyleColorSortBackground,
    StyleColorSortTitleColor,
    StyleColorSortCellText,
    StyleColorSortCellBackground,
    
    StyleColorSortNotesBackground,
	StyleColorSortNotesCellText
    
  
} StyleColorType;


typedef enum {
    StyleFontMainType,    
    StyleFontFlat,         
    StyleFontBottomBtns,  
    StyleFontActionView,  
    StyleFontAparienciaST01,
    StyleFontAparienciaST02,
} StyleFontType;



@interface StyleDressApp : NSObject

+(void) setStyle:(StyleType)newAppStyle;
+(StyleType) getStyle;
+(UIImage*) imageWithStyleNamed:(NSString*)imageName;
+(UIColor*) colorWithStyleForObject:(StyleColorType)styleColor;
+(UIFont*) fontWithStyleNamed:(StyleFontType)newFontType AndSize:(CGFloat)newFontSize;  
 

@end
