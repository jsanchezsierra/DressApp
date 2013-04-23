//
//  PrendaMarca.m
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


#import "PrendaMarca.h"
#import "Prenda.h"


@implementation PrendaMarca

@dynamic descripcion;
@dynamic idMarca;
@dynamic urlPicture;
@dynamic usuario;
@dynamic prenda;
@dynamic fechaLastUpdate;
@dynamic needsSynchronize;
@dynamic firstBackup;

+ (PrendaMarca *) prendaMarca_WithID:(NSString*)_marcaID withDescripcion:(NSString *)_marcaDescripcion urlPicture:(NSString*)_urlPicture  forUsuario:(NSString*)_usuario needsSynchronize:(NSNumber*)needsSync firstBackup:(NSNumber*)firstBackup inManagedObjectContext:(NSManagedObjectContext *)context
{
    PrendaMarca *marca = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"PrendaMarca" inManagedObjectContext:context];

    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        request.predicate =[NSPredicate
                            predicateWithFormat:@"(idMarca == %@) AND (usuario == %@) ",_marcaID,_usuario];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
            request.predicate = [ NSPredicate predicateWithFormat:@"(idMarca == %@) AND ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )", _marcaID,_usuario,DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]  ];
    
	NSError *error = nil;
	marca = [[context executeFetchRequest:request error:&error] lastObject];

	if (!error && !marca) {
		marca = [NSEntityDescription insertNewObjectForEntityForName:@"PrendaMarca" inManagedObjectContext:context];
		marca.idMarca =_marcaID;
		marca.descripcion =_marcaDescripcion;
        marca.usuario=_usuario;
        marca.urlPicture=_urlPicture;
        marca.fechaLastUpdate=nil;
		marca.needsSynchronize = needsSync;
		marca.firstBackup = firstBackup;
	}
    
	return marca;
    
}


@end
