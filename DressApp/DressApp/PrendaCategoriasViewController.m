//
//  ItemTiposViewController.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 10/28/11.
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


#import "PrendaCategoriasViewController.h"
#import "PrendaSubCategoria.h"
#import "Prenda.h"
#import "PrendaCategoria.h"
#import "StyleDressApp.h"

@implementation PrendaCategoriasViewController
@synthesize tiposTableView;
@synthesize fetchedResultsController,managedObjectContext;
@synthesize prenda;
@synthesize currentTipoIndexPath;
@synthesize delegate;
@synthesize prendasArray,multipleSelectionDictionary,isMultiselection;
@synthesize myNavigationTitle,myNavigationBar;
@synthesize myImageViewBackground,myActivity;
@synthesize prendaSubCategoriaArray;

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
  
- (void)viewDidLoad
{
    
    [myActivity setHidden:YES];

    nullString=@"-------";

    //set header title Frame and Label
    UIImageView *titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,3, 127,38)];
    [titleImageView setImage:[StyleDressApp imageWithStyleNamed:@"GEHeaderFrame"]];
    UILabel *headerTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 127, 31)];
    [headerTitleLabel setTextAlignment:UITextAlignmentCenter];
    [headerTitleLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:22]];
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [headerTitleLabel setText:NSLocalizedString(@"CategoriasTitleHeader",@"")];
    [headerTitleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRCategoriaHeader]]; 
    [titleImageView addSubview:headerTitleLabel];
    [self.myNavigationTitle setTitleView:titleImageView];

    
    //Navigation Bar Color
    [self.myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
    
    //Table View settings
    [self.tiposTableView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRCategoriaCellBackground]];
    [self.tiposTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tiposTableView setSeparatorColor:[UIColor clearColor]];
    [self.tiposTableView setRowHeight:44];

     
    //GET PrendaSubCategoria Array
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"PrendaSubCategoria" inManagedObjectContext:self.managedObjectContext];
    if (isMultiselection) 
    {
        if ( ![(NSString*)[multipleSelectionDictionary objectForKey:@"multipleCategoria"] isEqualToString:nullString]  ) 
        {
            
            fetchRequest.predicate =[NSPredicate
                                     predicateWithFormat:@"(categoriaID == %@) ", (NSString*)[multipleSelectionDictionary objectForKey:@"multipleCategoria"] ];
        }
    }
    else
        fetchRequest.predicate =[NSPredicate predicateWithFormat:@"(categoriaID == %@) ", prenda.categoria.idCategoria ];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"descripcion" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    prendaSubCategoriaArray = (NSMutableArray*) [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Set image background
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"PRCategoriasBackground"]];

    //category tittle
    NSString *localizedCategoria;
    NSString *localizedCategoriaShort;
    if (isMultiselection) 
    {        
        localizedCategoria=[NSString stringWithFormat:@"categoria%@", [multipleSelectionDictionary objectForKey:@"multipleCategoria"]];
        localizedCategoriaShort=[NSString stringWithFormat:@"categoria%@short", [multipleSelectionDictionary objectForKey:@"multipleCategoria"]];
    }else
    {    
        localizedCategoria=[NSString stringWithFormat:@"categoria%@", prenda.categoria.idCategoria];
        localizedCategoriaShort=[NSString stringWithFormat:@"categoria%@short", prenda.categoria.idCategoria];
        
    }   
    
    //Titulo con categoría
    NSString *sectionTitle =NSLocalizedString(localizedCategoria, @"");
    
    sectionTitleShort =NSLocalizedString(localizedCategoriaShort, @"");
    
    UIView *myView =[ [UIView alloc] initWithFrame:CGRectMake(25,50,270,50) ] ;
    myView.backgroundColor=[UIColor clearColor];
    
    UIImageView *headerImage= [[UIImageView alloc] initWithFrame:CGRectMake(35,12,200,39)];
    [headerImage setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailSubcategoriaHeaderImage"]];
    [myView addSubview:headerImage];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4., 200, 20.0)] ; //7
    [headerLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:16]];
    headerLabel.textAlignment = UITextAlignmentCenter; 
    headerLabel.backgroundColor = [UIColor clearColor]; 
    headerLabel.text=sectionTitle;
    [headerLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRCategoriaSectionTitle]];
    [headerImage addSubview:headerLabel];


    if ([StyleDressApp getStyle] == StyleTypeVintage )     
        [headerTitleLabel setFrame: CGRectMake(0, 3, 127, 31)];
    else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        [headerTitleLabel setFrame: CGRectMake(0, 3, 127, 31)];
        [headerLabel setFrame:CGRectMake(0, 4+4, 200, 20.0)] ; 
        [tiposTableView setFrame:CGRectMake(40-12 ,120-9,237+28,310+6)] ; 
    }

    [self.view addSubview:myView];
    
    //Cell Frame
    UIImageView *imageViewFrame1= [[UIImageView alloc] initWithFrame:CGRectMake(27,110,266,318)];
    imageViewFrame1.image = [StyleDressApp imageWithStyleNamed:@"PRDetailSubcategoriaCellFrame"];
    [self.view addSubview:imageViewFrame1];

    NSInteger indexOfObject=[prendaSubCategoriaArray indexOfObject:prenda.subcategoria ];
    NSIndexPath *selectedIndexPath=[NSIndexPath indexPathForRow:indexOfObject inSection:0];
    [tiposTableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark cancel categorySelection
-(IBAction) cancelButton
{
    [self.delegate dismissCategoryVC];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = [prendaSubCategoriaArray count];
    return numberOfRows;
}   

 
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *PrendaCategoriasCellIdentifier = @"PrendaCategoriasCellIdentifier";
    
    UITableViewCell *prendaCategoriasCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:PrendaCategoriasCellIdentifier];
    if (prendaCategoriasCell == nil) {
        prendaCategoriasCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PrendaCategoriasCellIdentifier] ;
		prendaCategoriasCell.accessoryType = UITableViewCellAccessoryNone;
        [prendaCategoriasCell setSelectionStyle:UITableViewCellSelectionStyleGray]; 
        [prendaCategoriasCell setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRCategoriaCellBackground]];

    }
    
    if (indexPath.row!=0) 
    {

        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            UIView *myLineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,1)];
            [myLineViewBottom setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRCategoriaCellSeparatorLine ]];
            [prendaCategoriasCell.contentView addSubview:myLineViewBottom];
            
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            UIView *myLineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,1)];
            [myLineViewBottom setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRCategoriaCellSeparatorLine ]];
            [prendaCategoriasCell.contentView addSubview:myLineViewBottom];

        }else
        {
            UIImageView *myLineViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,1)];
            [myLineViewBottom setImage:[StyleDressApp imageWithStyleNamed:@"CODetailCategoriaTableCellSeparator"] ];
            [prendaCategoriasCell.contentView addSubview:myLineViewBottom];
            
        }
        
    }

    
    if (isMultiselection) 
    {
        //Si la seleccion no es "-", busco el checkmark en el tableView
        if ( ! (  [(NSString*)[multipleSelectionDictionary objectForKey:@"multipleCategoria"] isEqualToString:nullString]  
              || [(NSString*)[multipleSelectionDictionary objectForKey:@"multipleSubCategoria"] isEqualToString:nullString] )  
             ) 
        {
            //Busco el checkmark correspondiente a la marca
            if ( [(Prenda*)[prendasArray lastObject] subcategoria] == [prendaSubCategoriaArray objectAtIndex:indexPath.row]) 
            {
                currentTipoIndexPath=indexPath;
                prendaCategoriasCell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else
                prendaCategoriasCell.accessoryType = UITableViewCellAccessoryNone;
        
          
        }
    }
    else
    {
        if (prenda.subcategoria == [prendaSubCategoriaArray objectAtIndex:indexPath.row]) 
        {
            self.currentTipoIndexPath=indexPath;
            prendaCategoriasCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else
            prendaCategoriasCell.accessoryType = UITableViewCellAccessoryNone;

    }
    
    
    PrendaSubCategoria *prendaSubCategoria = (PrendaSubCategoria *)[prendaSubCategoriaArray objectAtIndex:indexPath.row];
    
    
    NSString *localizedSubcategoria= [NSString stringWithFormat:@"subCategoria%d_%d", [prendaSubCategoria.categoriaID integerValue ], [prendaSubCategoria.idSubcategoria integerValue] ];  //NSLocalizedString(@"", @"");
    [prendaCategoriasCell.textLabel setText:NSLocalizedString(localizedSubcategoria,@"")];

    
    return prendaCategoriasCell;
    
    
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    
    [myActivity setHidden:NO];

    //Esto lo que hace es deseleccionar el indexPath que estaba elegido anteriormente
    UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath: self.currentTipoIndexPath];
    checkedCell.accessoryType = UITableViewCellAccessoryNone;
    
    self.currentTipoIndexPath=indexPath;
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    
    
    
    [self performSelector:@selector(selectRowAtIndexPathWithDelay:) withObject:indexPath afterDelay:0.05];
    
}

-(void) selectRowAtIndexPathWithDelay:(NSIndexPath *)indexPath
{
    
    //Get cell textLabel for analytics
    UITableViewCell *thisCell= [tiposTableView cellForRowAtIndexPath:indexPath];
    
    if (isMultiselection) 
    {
        for (Prenda *myPrenda in prendasArray) 
        {
            myPrenda.subcategoria= [prendaSubCategoriaArray objectAtIndex:indexPath.row];
            myPrenda.categoria=myPrenda.subcategoria.categoria;
            myPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
        }
        [multipleSelectionDictionary setObject: [ [(Prenda*)[prendasArray lastObject] subcategoria] descripcion ] forKey:@"multipleSubCategoria"];
        [multipleSelectionDictionary setObject: [ [(Prenda*)[prendasArray lastObject] categoria]descripcion ] forKey:@"multipleCategoria"];
         
    }
    else
    {
        self.prenda.subcategoria= [prendaSubCategoriaArray objectAtIndex:indexPath.row];
        self.prenda.categoria=self.prenda.subcategoria.categoria;
        self.prenda.needsSynchronize=[NSNumber numberWithBool:YES];
    }
    
    // Save the context. 
    NSError *error;
    if (![self.managedObjectContext save:&error]) 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    [self.delegate categoriaChangedForPrenda:self.prenda];
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
 
@end
