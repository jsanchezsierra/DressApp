//
//  PrendasMisMarcasViewController.m
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


#import "PrendasMisMarcasViewController.h"
#import "PrendaMarca.h"
#import "Prenda.h"
#import "StyleDressApp.h"

@implementation PrendasMisMarcasViewController
@synthesize delegate,prendasDelegate;
@synthesize marcasTableView;
@synthesize fetchedResultsController,managedObjectContext;
@synthesize prenda,myActivity;
@synthesize prendasArray,multipleSelectionDictionary,isMultiselection;
@synthesize myNavigationTitle,myNavigationBar,myImageViewBackground;
@synthesize helpAddMarcaImageView,helpAddMarcaLabel,imageViewFrame,containerView;
@synthesize isChoosingMarcaForPrenda,isRight;
@synthesize leftLineView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    showHelpContextMenuAlready=NO;
    [super viewDidLoad];
    [leftLineView setHidden:YES];

    //Añado una marca tipo 0 para este usuario
    [PrendaMarca prendaMarca_WithID:@"0" withDescripcion:NSLocalizedString(@"marca0", @"") urlPicture:nil  forUsuario:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] needsSynchronize:[NSNumber numberWithBool:YES] firstBackup:[NSNumber numberWithBool:YES]  inManagedObjectContext:self.managedObjectContext];

    nullString=@"-------";
    [myActivity setHidden:YES];
    
    //Navigation Bar Color
    [self.myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
    
    //Create help menu
    [self.helpAddMarcaImageView setImage:[StyleDressApp imageWithStyleNamed:@"PRMarcasHelpFrame"]];
    
    [self.helpAddMarcaLabel setTextColor:[StyleDressApp colorWithStyleForObject:  StyleColorPRMisMarcasEmptySectionTitle]];
    
    [self.helpAddMarcaLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:17 ]];
    [self.helpAddMarcaLabel setText:NSLocalizedString(@"addMarcaHelp", @"")];
    
    
    //Table View settings
    [self.marcasTableView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRMisMarcasCellBackground]];
    [self.marcasTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.marcasTableView setSeparatorColor:[UIColor clearColor]];
    [self.marcasTableView setRowHeight:44];
    
    [self.myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"PRMisMarcasBackground"]];

    
    //set header title Frame and Label
    UIImageView *titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,3, 127,38)];
    [titleImageView setImage:[StyleDressApp imageWithStyleNamed:@"GEHeaderFrame"]];
    UILabel *headerTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 127, 31)];
    [headerTitleLabel setTextAlignment:UITextAlignmentCenter];
    [headerTitleLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:20]];
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [headerTitleLabel setText:NSLocalizedString(@"MisMarcasTitleHeader",@"")];
    [headerTitleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRMisMarcasHeader]]; 

    [titleImageView addSubview:headerTitleLabel];
    [self.myNavigationTitle setTitleView:titleImageView];

    if (isChoosingMarcaForPrenda==NO)  //Si no estoy añadiendo marca a la prenda
    {   
        isRight=NO;
        [self.myNavigationBar setHidden:YES];
   
        UIBarButtonItem *leftBarButtonItem= [[UIBarButtonItem alloc] init];
        [leftBarButtonItem setImage:[StyleDressApp imageWithStyleNamed:@"GEBtnMainMenu" ] ];
        [leftBarButtonItem setTarget:self];
        [leftBarButtonItem setStyle:UIBarButtonItemStyleBordered];
        [leftBarButtonItem setAction:@selector(popMainMenuViewController)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem; 

        //titulo central
        [self.navigationItem setTitleView:titleImageView];
        
        //Add Done Button
        UIBarButtonItem *addDoneButton = [ [UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMarcaToMyMarcas) ];
        self.navigationItem.rightBarButtonItem= addDoneButton; 
    }else
        isRight=YES;
    
    imageViewFrame.image = [StyleDressApp imageWithStyleNamed:@"PRDetailSubcategoriaCellFrame"];
    
    
    //Fetch ResultsController
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }		
    
    //AÑADIDA CONDICION, SOLO SE EJECUTA SI VIENE DE DETALLE DE PRENDA
    if (isChoosingMarcaForPrenda) 
        [marcasTableView scrollToRowAtIndexPath:[fetchedResultsController indexPathForObject:prenda.marca ] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

-(IBAction)addMarcaToMyMarcas

{
    PrendasMarcasViewController *newVC= [[PrendasMarcasViewController alloc] init];
    newVC.delegate=self;
    newVC.managedObjectContext=self.managedObjectContext;
    [self presentModalViewController:newVC animated:YES];
    
}

-(void) dismissMarcasVC
{
    [self dismissModalViewControllerAnimated:YES];
}


-(void) dismissMarcasVCWithMarcasArray:(NSMutableArray *)marcasArray
{

    //Create array of Marcas
    for (NSDictionary *marcasDict in marcasArray) 
    {
        [PrendaMarca prendaMarca_WithID:[marcasDict objectForKey:@"marcaID"] withDescripcion:[marcasDict objectForKey:@"marcaName"] urlPicture:nil  forUsuario:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] needsSynchronize:[NSNumber numberWithBool:YES] firstBackup:[NSNumber numberWithBool:YES] inManagedObjectContext:self.managedObjectContext];
    }
    
    // Save the context. 
    NSError *error;
    if (![self.managedObjectContext save:&error]) 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
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


#pragma mark cancel categorySelection
-(IBAction) cancelButton
{
    [self.prendasDelegate dismissMisMarcasVC];
}


-(void) showHelpContextMenu:(BOOL)showMenu
{
    
    if (!isChoosingMarcaForPrenda)  
        [self.navigationController.view layoutSubviews];
    
    NSInteger offset=0;
    
    [self.helpAddMarcaImageView setHidden:!showMenu];
    [self.helpAddMarcaLabel setHidden:!showMenu];
   
    NSInteger xOffset=0;
    NSInteger yOffset=0;
    NSInteger widthInc=0;
    NSInteger heightInc=0;
    
    if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        xOffset=-6;
        yOffset=-10;
        widthInc=12;
        heightInc=12;
    }

    NSInteger styleWidthInc;
    NSInteger styleHeightInc;
    NSInteger yOffsetModern;
     if ([StyleDressApp getStyle] == StyleTypeVintage ) 
     {
         [self.helpAddMarcaLabel setFrame:CGRectMake(31, 86, 257, 34)];
         styleWidthInc=0;
         styleHeightInc=0;
         yOffsetModern=0;
     }
     else if ([StyleDressApp getStyle] == StyleTypeModern ) 
     {
         [self.helpAddMarcaLabel setFrame:CGRectMake(31, 76, 257, 34)];
         styleWidthInc=7;
         styleHeightInc=7;
         yOffsetModern=-8;
     }
    
    
    if (showMenu)  //Muestra menú
    {
        if (isChoosingMarcaForPrenda) {
            [marcasTableView setFrame:CGRectMake(35+xOffset, 157+yOffset, 243+widthInc+styleWidthInc, 287+heightInc+styleHeightInc)];
            imageViewFrame.frame= CGRectMake(27,145,266,310);
            
        } else  ///ESTE ES EL CASO
        {
            [marcasTableView setFrame:CGRectMake(35+xOffset, 164-50+yOffset, 243+widthInc+styleWidthInc, 287+heightInc+offset+styleHeightInc)];
            imageViewFrame.frame= CGRectMake(27,152-50,266,310);
            helpAddMarcaImageView.frame= CGRectMake(7,51-45,306,78);
            helpAddMarcaLabel.frame= CGRectMake(31,86-45+yOffsetModern,257,34);
        }
    }
    else  //No muestra menú
    {        
        if (isChoosingMarcaForPrenda) {
            [marcasTableView setFrame:CGRectMake(35+xOffset, 102+yOffset, 243+widthInc+styleWidthInc, 287+heightInc+styleHeightInc)]; //33, 90, 254, 310
            imageViewFrame.frame= CGRectMake(27,90,266,310);
        } else
        {
            [marcasTableView setFrame:CGRectMake(35+xOffset, 102-40+yOffset, 243+widthInc+styleWidthInc, 287+heightInc+offset+styleHeightInc)];
            imageViewFrame.frame= CGRectMake(27,90-40,266,310);

        }
    }
    
    showHelpContextMenuAlready=YES;

}

 #pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger count = [[fetchedResultsController sections] count];
	if (count == 0) 
		count = 1;
	
    return count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    if (numberOfRows>1) 
        [self showHelpContextMenu:NO];
    else
        [self showHelpContextMenu:YES];

    return numberOfRows;
}   
 
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *PrendaMarcaCellIdentifier = @"PrendaMarcaCellIdentifier";
    
    UITableViewCell *prendaMarcaCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:PrendaMarcaCellIdentifier];
    if (prendaMarcaCell == nil) {
        prendaMarcaCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PrendaMarcaCellIdentifier] ;
		prendaMarcaCell.accessoryType = UITableViewCellAccessoryNone;
        [prendaMarcaCell setSelectionStyle:UITableViewCellSelectionStyleGray]; 
        [prendaMarcaCell setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRMisMarcasCellBackground]];

    }
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        UIView *myLineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,43,320,1)];
        [myLineViewBottom setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRMisMarcasCellSeparatorLine ]];
        [prendaMarcaCell.contentView addSubview:myLineViewBottom];
        
    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        UIView *myLineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,43,320,1)];
        [myLineViewBottom setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRMisMarcasCellSeparatorLine ]];
        [prendaMarcaCell.contentView addSubview:myLineViewBottom];
        
    }else
    {
        UIImageView *myLineViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,1)];
        [myLineViewBottom setImage:[StyleDressApp imageWithStyleNamed:@"CODetailCategoriaTableCellSeparator"] ];
        [prendaMarcaCell.contentView addSubview:myLineViewBottom];
        
    }
    
    //AÑADIDA CONDICION, SOLO SE EJECUTA SI VIENE DE DETALLE DE PRENDA
    if (isChoosingMarcaForPrenda) 
    {
        if (isMultiselection) 
        {
            //Si la seleccion no es "-", busco el checkmark en el tableView
            if ( ![(NSString*)[multipleSelectionDictionary objectForKey:@"multipleMarca"] isEqualToString:nullString]  ) 
            {
                //Busco el checkmark correspondiente a la marca
                if ( [(Prenda*)[prendasArray lastObject] marca] == [fetchedResultsController objectAtIndexPath:indexPath]) 
                {
                    currentMarcaIndex=indexPath.row;
                    prendaMarcaCell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else
                    prendaMarcaCell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else
        {
            if (prenda.marca == [fetchedResultsController objectAtIndexPath:indexPath]) 
            {
                currentMarcaIndex=indexPath.row;
                prendaMarcaCell.accessoryType = UITableViewCellAccessoryCheckmark;
                
            }else
                prendaMarcaCell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
    
    // Cojo datos de prendaMarca
    PrendaMarca *prendaMarca = (PrendaMarca *) [fetchedResultsController objectAtIndexPath:indexPath];

    
    //Cuento cuantas prendas hay asociadas a cada marca
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Prenda" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(marca == %@ ) AND (usuario == %@)", prendaMarca,[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]  ];
  
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(marca == %@ ) AND ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )", prendaMarca,[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ] ,DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"] ];

    NSError *error = nil;
    NSInteger prendasCount =[ [self.managedObjectContext executeFetchRequest:fetchRequest error:&error] count];

    //Si hay mas de una prenda, añado la cantidad entre parentesis. Si no hay prendas, no pondo nada
    if (prendasCount>0)
        prendaMarcaCell.textLabel.text=[NSString stringWithFormat:@" %@ (%d)", prendaMarca.descripcion,prendasCount ];
    else
        prendaMarcaCell.textLabel.text=[NSString stringWithFormat:@" %@", prendaMarca.descripcion ];

    return prendaMarcaCell;
    
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isChoosingMarcaForPrenda) 
    {
        [myActivity setHidden:NO];
        
        UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:currentMarcaIndex inSection:indexPath.section]];
        checkedCell.accessoryType = UITableViewCellAccessoryNone;
        
        currentMarcaIndex=indexPath.row;
        
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    
        
        [self performSelector:@selector(selectRowAtIndexPathWithDelay:) withObject:indexPath afterDelay:0.05];

    } else
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void) selectRowAtIndexPathWithDelay:(NSIndexPath *)indexPath
{
    
    NSString *analyticsString;
    NSString * trimmedAnalyticsString;
    
    if (isMultiselection) 
    {
        for (Prenda *myPrenda in prendasArray) 
        {
            myPrenda.marca=[fetchedResultsController objectAtIndexPath:indexPath];
            myPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
            analyticsString=myPrenda.marca.descripcion;
            trimmedAnalyticsString = [analyticsString stringByReplacingOccurrencesOfString:@" " withString:@""];

         }
        [multipleSelectionDictionary setObject: [ [(Prenda*)[prendasArray lastObject] marca] descripcion ] forKey:@"multipleMarca"];
    }
    else
    {

        self.prenda.marca= [fetchedResultsController objectAtIndexPath:indexPath];
        self.prenda.needsSynchronize=[NSNumber numberWithBool:YES];
        analyticsString=self.prenda.marca.descripcion;
        trimmedAnalyticsString = [analyticsString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    
    // Save the context. 
    NSError *error;
    if (![self.managedObjectContext save:&error]) 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    [self.prendasDelegate dismissMisMarcasVC];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return(YES);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrendaMarca *prendaMarcaToEdit = (PrendaMarca *) [fetchedResultsController objectAtIndexPath:indexPath];

    //Solamente devuelvo editStyleDelete si es diferente de 0
    if (![prendaMarcaToEdit.idMarca isEqualToString:@"0"])
        return (UITableViewCellEditingStyleDelete); 
}

//Asks the data source to commit the insertion or deletion of a specified row in the receiver.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If row is deleted, remove it from the list. 
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Selecciono la marca a borrar 
        PrendaMarca *prendaMarcaToRemove = (PrendaMarca *) [fetchedResultsController objectAtIndexPath:indexPath];

        //Recupero prendaMarca para idMarca=@"0"  -> otra
        PrendaMarca *prendaMarcaOther;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PrendaMarca" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];

        if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(idMarca==%@ ) AND (usuario==%@)", @"0",[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
        else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(idMarca==%@ ) AND  ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )", @"0",[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ], DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
        
        
        
         NSError *error = nil;
        NSArray     *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects != nil) 
            prendaMarcaOther=[fetchedObjects objectAtIndex:0];

        //Enumero las prendas que tienen la marca a borrar y las añado al array de prendas a cambiar marca
        NSEnumerator *enumerator = [prendaMarcaToRemove.prenda objectEnumerator];
        Prenda *prendaToChangeMarcaItem;
        NSMutableArray *prendasToChangeMarcaArray=[[NSMutableArray alloc] init];
        while ((prendaToChangeMarcaItem = [enumerator nextObject])) 
            [prendasToChangeMarcaArray addObject:prendaToChangeMarcaItem];


        //Replace en el Array de prendaToChangeMarca la marca a borrar por la marca prendaMarcaOther
        NSInteger numberOfPrendasToReplace = [prendasToChangeMarcaArray count];
         for (int i=0;i<numberOfPrendasToReplace;i++)
         {
             Prenda *prendaToChangeMarca = [prendasToChangeMarcaArray objectAtIndex:i];
             prendaToChangeMarca.marca=prendaMarcaOther;
         }

        
        //Borro la marca de la tabla PrendaMarca
        [self.managedObjectContext deleteObject:prendaMarcaToRemove];

        if (![self.managedObjectContext save:&error]) 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

    }
    
  
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PrendaMarca" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
       
        if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"usuario==%@",
                                      [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
        else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )", [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ], DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
        
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"descripcion" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
    
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
    }
	
	return fetchedResultsController;
}    


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.marcasTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
	UITableView *tableView = self.marcasTableView;
	
    
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
		break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
    
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    
    switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.marcasTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.marcasTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
    
    
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.marcasTableView endUpdates];
}

-(void) popMainMenuViewController
{
    
    if (!isRight) 
        [self.delegate moveMainViewToRight:YES];
    else
        [self.delegate moveMainViewToRight:NO];
    
    isRight = !isRight;
    
}


@end
