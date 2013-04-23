//
//  Prenda.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 11/22/11.
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


#import "Prenda.h"
#import "ConjuntoPrendas.h"
#import "PrendaCategoria.h"
#import "PrendaEstado.h"
#import "PrendaMarca.h"
#import "PrendaSubCategoria.h"
#import "PrendaTemporada.h"
#import "PrendaTienda.h"


@implementation Prenda

@dynamic fechaCompra;
@dynamic idPrenda;
@dynamic notas;
@dynamic precio;
@dynamic rating;
@dynamic talla1,talla2,talla3;
@dynamic urlPicture;
@dynamic urlPictureServer;
@dynamic usuario;
@dynamic categoria;
@dynamic color;
@dynamic conjuntoPrenda;
@dynamic estado;
@dynamic marca;
@dynamic subcategoria;
@dynamic temporada;
@dynamic tienda;
@dynamic composicion;
@dynamic tag1,tag2,tag3;
@dynamic descripcion;
@dynamic needsSynchronize;
@dynamic firstBackup;
@dynamic restoreFinished;
@dynamic idPrendaDispositivo;

+ (Prenda *)prendaWithData:(NSDictionary *)prendaData inManagedObjectContext:(NSManagedObjectContext *)context overwriteObject:(BOOL)overwrite
{
    Prenda *prenda = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Prenda" inManagedObjectContext:context];

    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        request.predicate = [NSPredicate predicateWithFormat:@"(idPrenda == %@) AND (usuario == %@)", [prendaData objectForKey:@"idPrenda"],[prendaData objectForKey:@"username"]  ];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        request.predicate = [NSPredicate predicateWithFormat:@"(idPrenda == %@) AND ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )", [prendaData objectForKey:@"idPrenda"],[prendaData objectForKey:@"username"],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]  ];

	
	NSError *error = nil;
	prenda = [[context executeFetchRequest:request error:&error] lastObject];

	if ( ( !error && !prenda )||  ( !error && overwrite==YES )   ) {
        if (!prenda)
            prenda = [NSEntityDescription insertNewObjectForEntityForName:@"Prenda" inManagedObjectContext:context];
        
        prenda.usuario = [prendaData objectForKey:@"username"];
        prenda.descripcion = [prendaData objectForKey:@"descripcion"];
        prenda.idPrenda = [prendaData objectForKey:@"idPrenda"];
        prenda.urlPicture = [prendaData objectForKey:@"urlPicture"];
        prenda.urlPictureServer = [prendaData objectForKey:@"urlPictureServer"];
        prenda.fechaCompra = [prendaData objectForKey:@"fecha"];
        prenda.notas = [prendaData objectForKey:@"notas"];
        prenda.precio = [prendaData objectForKey:@"precio"];
        prenda.rating = [prendaData objectForKey:@"rating"];
        prenda.talla1 = [prendaData objectForKey:@"talla1"];
        prenda.talla2 = [prendaData objectForKey:@"talla2"];
        prenda.talla3 = [prendaData objectForKey:@"talla3"];
        prenda.tag1 = [prendaData objectForKey:@"tag1"];
        prenda.tag2 = [prendaData objectForKey:@"tag2"];
        prenda.tag3 = [prendaData objectForKey:@"tag3"];
        prenda.composicion = [prendaData objectForKey:@"composicion"];
        prenda.categoria = [prendaData objectForKey:@"categoria"];
        prenda.subcategoria = [prendaData objectForKey:@"subcategoria"];
        prenda.temporada = [prendaData objectForKey:@"temporada"];
        prenda.estado = [prendaData objectForKey:@"estado"];
        prenda.marca = [prendaData objectForKey:@"marca"];
        prenda.color = [prendaData objectForKey:@"color"];        
        prenda.tienda = nil;//[prendaData objectForKey:@"tienda"];
        prenda.needsSynchronize = [prendaData objectForKey:@"needsSynchronize"];
		prenda.firstBackup = [prendaData objectForKey:@"firstBackup"];
        prenda.restoreFinished=[prendaData objectForKey:@"restoreFinished"];
        prenda.idPrendaDispositivo=[prendaData objectForKey:@"idPrendaDispositivo"];
        return prenda;

	} else
        return nil;
	
	return prenda;
    
}




@end
