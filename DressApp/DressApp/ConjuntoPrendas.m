//
//  ConjuntoPrendas.m
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


#import "ConjuntoPrendas.h"
#import "Conjunto.h"
#import "Prenda.h"


@implementation ConjuntoPrendas

@dynamic descripcion;
@dynamic scale;
@dynamic usuario;
@dynamic x;
@dynamic y;
@dynamic conjunto;
@dynamic prenda;
@dynamic idConjuntoPrendas;
@dynamic orden;
@dynamic width;
@dynamic height;
@dynamic fechaLastUpdate;

+ (ConjuntoPrendas *)conjuntoPrendasWithData:(NSDictionary *)conjuntoPrendasData inManagedObjectContext:(NSManagedObjectContext *)context overwriteObject:(BOOL)overwrite
{
    ConjuntoPrendas *conjuntoPrendas = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"ConjuntoPrendas" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"idConjuntoPrendas == %@", [conjuntoPrendasData objectForKey:@"idConjuntoPrendas"]  ];
	
	NSError *error = nil;
	conjuntoPrendas = [[context executeFetchRequest:request error:&error] lastObject];
    
        
    if ( (!error && !conjuntoPrendas ) ||  ( !error && overwrite==YES )) 
    {
        if (!conjuntoPrendas)
            conjuntoPrendas = [NSEntityDescription insertNewObjectForEntityForName:@"ConjuntoPrendas" inManagedObjectContext:context];
		conjuntoPrendas.descripcion = [conjuntoPrendasData objectForKey:@"descripcion"];
		conjuntoPrendas.scale = [conjuntoPrendasData objectForKey:@"scale"];
		conjuntoPrendas.usuario = [conjuntoPrendasData objectForKey:@"usuario"];
		conjuntoPrendas.x = [conjuntoPrendasData objectForKey:@"x"];
		conjuntoPrendas.y = [conjuntoPrendasData objectForKey:@"y"];
		conjuntoPrendas.conjunto = [conjuntoPrendasData objectForKey:@"conjunto"];
		conjuntoPrendas.prenda = [conjuntoPrendasData objectForKey:@"prenda"];
		conjuntoPrendas.idConjuntoPrendas = [conjuntoPrendasData objectForKey:@"idConjuntoPrendas"];
        conjuntoPrendas.orden=[conjuntoPrendasData objectForKey:@"orden"];
        conjuntoPrendas.width=[conjuntoPrendasData objectForKey:@"width"];
        conjuntoPrendas.height=[conjuntoPrendasData objectForKey:@"height"];
        conjuntoPrendas.fechaLastUpdate=[NSDate date];
    }
    
	return conjuntoPrendas;
    
}


@end
