//
//  PrendasMarcasViewController.m
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


#import "PrendasMarcasViewController.h"
#import "Marcas.h"
#import "StyleDressApp.h"

@implementation PrendasMarcasViewController
@synthesize delegate;
@synthesize marcasTableView;
@synthesize fetchedResultsController,managedObjectContext;
@synthesize myActivity;
@synthesize myNavigationTitle,myNavigationBar,myImageViewBackground;
@synthesize marcasArray,fetchedResultsChecked;

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

- (void)viewDidLoad
{
    
    nullString=@"-------";
    [myActivity setHidden:YES];
    createCheckArray=YES;
    
        
    UILabel *headerTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 160, 31)];
    [headerTitleLabel setTextAlignment:UITextAlignmentCenter];
    [headerTitleLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:20]];
    [headerTitleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRMarcasHeader]];
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [headerTitleLabel setText:NSLocalizedString(@"addMarca",@"")];
 
   // [titleImageView addSubview:headerTitleLabel];
    [self.myNavigationTitle setTitleView:headerTitleLabel];


    
    //Navigation Bar Color
    [self.myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];

    
    //Table View settings
    [self.marcasTableView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRMarcasCellBackground]];
    [self.marcasTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.marcasTableView setSeparatorColor:[UIColor clearColor]];
    [self.marcasTableView setRowHeight:44];
 
    [self.myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];

    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        
    }
    else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        [marcasTableView setFrame:CGRectMake(40-10-2 ,102-10-1,238+15+7+4,287+12+8)] ; 
    else
        [marcasTableView setFrame:CGRectMake(40-10 ,102-10,238+15,287+12)] ; 
    
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"PRMarcasBackground"]];

    UIImageView *imageViewFrame1= [[UIImageView alloc] initWithFrame:CGRectMake(27,90,266,310)];
    imageViewFrame1.image = [StyleDressApp imageWithStyleNamed:@"PRDetailSubcategoriaCellFrame"];
    [self.view addSubview:imageViewFrame1];

    
    //Fetch ResultsController
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}		
    
    self.marcasArray = [[NSMutableArray alloc] init]; 

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
    [self.delegate dismissMarcasVC];
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
    
    //Creo array de cheked solamente la primera vez 
    if (createCheckArray==YES) 
    {
        //Creo un array para guardar si los elementos están cheked o no
        self.fetchedResultsChecked=[[NSMutableArray alloc] init ];
        
        for (int i=0; i<numberOfRows;i++)
            [fetchedResultsChecked addObject:[NSNumber numberWithBool:NO]];
        
        createCheckArray=NO; 
    }

    
    return numberOfRows;
}   



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *PrendaMarcaCellIdentifier = @"PrendaMarcaCellIdentifier";
    
    UITableViewCell *prendaMarcaCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:PrendaMarcaCellIdentifier];
    if (prendaMarcaCell == nil) {
        prendaMarcaCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PrendaMarcaCellIdentifier] ;
		prendaMarcaCell.accessoryType = UITableViewCellAccessoryNone;
        [prendaMarcaCell setSelectionStyle:UITableViewCellSelectionStyleGray]; 
        [prendaMarcaCell setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRMarcasCellBackground]];
    }
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        UIView *myLineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,43,320,1)];
        [myLineViewBottom setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRMarcasCellSeparatorLine ]];
        [prendaMarcaCell.contentView addSubview:myLineViewBottom];
        
    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        UIView *myLineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,43,320,1)];
        [myLineViewBottom setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRMarcasCellSeparatorLine ]];
        [prendaMarcaCell.contentView addSubview:myLineViewBottom];
        
    }else
    {
        UIImageView *myLineViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,1)];
        [myLineViewBottom setImage:[StyleDressApp imageWithStyleNamed:@"CODetailCategoriaTableCellSeparator"] ];
        [prendaMarcaCell.contentView addSubview:myLineViewBottom];
        
    }

    
    Marcas  *marca = (Marcas *) [fetchedResultsController objectAtIndexPath:indexPath];
    prendaMarcaCell.textLabel.text=marca.name;
    
    //Si el elemento del arraychecked es YES, pongo el checked, si no pongo el NONE
    if ([[fetchedResultsChecked objectAtIndex:indexPath.row] boolValue]==YES) 
        [prendaMarcaCell setAccessoryType:UITableViewCellAccessoryCheckmark];    
    else if ([[fetchedResultsChecked objectAtIndex:indexPath.row] boolValue]==NO) 
        [prendaMarcaCell setAccessoryType:UITableViewCellAccessoryNone];    
    
    return prendaMarcaCell;
    
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [fetchedResultsChecked replaceObjectAtIndex:indexPath.row withObject: [NSNumber numberWithBool: ! [[fetchedResultsChecked objectAtIndex:indexPath.row] boolValue]]   ];
      
    Marcas *marca= [fetchedResultsController objectAtIndexPath:indexPath];
    NSDictionary *marcaDic=[NSDictionary dictionaryWithObjectsAndKeys:marca.idMarca,@"marcaID",marca.name,@"marcaName", nil];
    
    if ([[fetchedResultsChecked objectAtIndex:indexPath.row] boolValue]) 
        [self.marcasArray addObject:marcaDic];
    else
        [self.marcasArray removeObject:marcaDic];
    
    [marcasTableView reloadData];
    
    
}
 
- (IBAction) marcasDoneButton
{
    
    [self.delegate dismissMarcasVCWithMarcasArray:marcasArray];    

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
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Marcas" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat: @" idMarca!=%@ ", @"0"  ] ];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
    }

	return fetchedResultsController;
}    


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

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


@end
