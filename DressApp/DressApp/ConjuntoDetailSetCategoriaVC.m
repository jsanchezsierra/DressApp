//
//  ConjuntoDetailSetCategoriaVC.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 12/1/11.
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


#import "ConjuntoDetailSetCategoriaVC.h"
#import "ConjuntoCategoria.h"
#import "StyleDressApp.h"

@implementation ConjuntoDetailSetCategoriaVC
@synthesize delegate;
@synthesize fetchedResultsController,managedObjectContext;
@synthesize categoriaTableView,myNavigationTitle;
@synthesize conjunto;
@synthesize myNavigationBar;
@synthesize myTableFrame;
@synthesize myImageViewBackground;

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
    
    // Release any cached   data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    rowHeight=50;
        
    //set header title Frame and Label
    UIImageView *titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,3, 127,38)];
    [titleImageView setImage:[StyleDressApp imageWithStyleNamed:@"GEHeaderFrame"]];
    UILabel *headerTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 127, 31)];
    [headerTitleLabel setTextAlignment:UITextAlignmentCenter];
    [headerTitleLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:22]];
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [headerTitleLabel setText:NSLocalizedString(@"CategoriasTitleHeader",@"")];
    [headerTitleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCOCategoriaHeader]];

    [titleImageView addSubview:headerTitleLabel];
    [self.myNavigationTitle setTitleView:titleImageView];

    
    //Navigation Bar Color
    [self.myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
    
    //Table View settings
     [self.categoriaTableView setBackgroundColor:[UIColor clearColor]];
    [self.categoriaTableView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCOCategoriaCellBackground]];
    [self.categoriaTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.categoriaTableView setSeparatorColor:[UIColor clearColor]];
    [self.categoriaTableView setRowHeight:rowHeight];

    
    //Set image background
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"CODetailCategoriaBackground"]];

    //Frame Properties
    [self.myTableFrame setImage:[StyleDressApp imageWithStyleNamed:@"CODetailCategoriaFrame"]];
    
    //Fetch ResultsController
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}		
    
    [categoriaTableView scrollToRowAtIndexPath:[fetchedResultsController indexPathForObject:conjunto.categoria ] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        [self.categoriaTableView setFrame:CGRectMake(39 ,129,235,250)] ; 
        
    }
    else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        [self.categoriaTableView setFrame:CGRectMake(39+2 ,135-7,235+4,238+12)] ; 
    }
    else
    {
    }

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    [self.delegate dismissConjuntoDetailSetCategoriaVC];
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
    
    
    //Set Frame Size
    NSInteger xOffset=0;
    NSInteger yOffset=0;
    if ([StyleDressApp getStyle]==StyleTypeVintage) 
    {
        xOffset=5; //5  //2
        yOffset=38; //38  //5
    }
    [self.myTableFrame setFrame:CGRectMake( (320-240)/2 -xOffset, 44+ (416-rowHeight*numberOfRows )/2 -yOffset, 240 + 2*xOffset ,2+rowHeight*numberOfRows +2*yOffset)];

    //Retun number of rows
    return numberOfRows;
}   


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *ConjuntoCategoriaCellIdentifier = @"ConjuntoCategoriaCellIdentifier";
    
    UITableViewCell *conjuntoCategoriaCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConjuntoCategoriaCellIdentifier];
    if (conjuntoCategoriaCell == nil) {
        conjuntoCategoriaCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ConjuntoCategoriaCellIdentifier] ;
		conjuntoCategoriaCell.accessoryType = UITableViewCellAccessoryNone;
        [conjuntoCategoriaCell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
        [conjuntoCategoriaCell setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCOCategoriaCellBackground]];
        //Asigno font a label
        UIFont *myFont= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:20];
        conjuntoCategoriaCell.textLabel.font=myFont;
        
    }
    
    //Add cell line
    if (indexPath.row!=0) 
    {
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            UIView *myLineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,1)];
            [myLineViewBottom setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRCategoriaCellSeparatorLine ]];
            [conjuntoCategoriaCell.contentView addSubview:myLineViewBottom];
            
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            UIView *myLineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(-10,0,320,1)];
            [myLineViewBottom setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorPRCategoriaCellSeparatorLine ]];
            [conjuntoCategoriaCell.contentView addSubview:myLineViewBottom];
            
        }else
        {
            UIImageView *myLineViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,1)];
            [myLineViewBottom setImage:[StyleDressApp imageWithStyleNamed:@"CODetailCategoriaTableCellSeparator"] ];
            [conjuntoCategoriaCell.contentView addSubview:myLineViewBottom];
            
        }
        
    }

    
    //Añade checkmark a la categoría
    if (conjunto.categoria == [fetchedResultsController objectAtIndexPath:indexPath]) 
    {
        currentCategoriaIndex=indexPath.row;
        conjuntoCategoriaCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
        conjuntoCategoriaCell.accessoryType = UITableViewCellAccessoryNone;

    //Add cell image
    if (indexPath.row==0) 
        conjuntoCategoriaCell.imageView.image=[StyleDressApp imageWithStyleNamed:@"CO1IconCasual"];
    else if (indexPath.row==1) 
        conjuntoCategoriaCell.imageView.image=[StyleDressApp imageWithStyleNamed:@"CO1IconNegocio"];
    else if (indexPath.row==2) 
        conjuntoCategoriaCell.imageView.image=[StyleDressApp imageWithStyleNamed:@"CO1IconFiesta"];
    else if (indexPath.row==3) 
        conjuntoCategoriaCell.imageView.image=[StyleDressApp imageWithStyleNamed:@"CO1IconTarde"];
    else if (indexPath.row==4) 
        conjuntoCategoriaCell.imageView.image=[StyleDressApp imageWithStyleNamed:@"CO1IconOtros"];
    

    //Añado texto a la celda
    ConjuntoCategoria *conjuntoCategoria = (ConjuntoCategoria *) [fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *localizedCategoria= [NSString stringWithFormat:@"ConjuntoCategoria_%d",  [conjuntoCategoria.idCategoria integerValue] ];  
    
    conjuntoCategoriaCell.textLabel.text=[NSString stringWithFormat:@" %@", NSLocalizedString(localizedCategoria, @"")];
    
    return conjuntoCategoriaCell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:currentCategoriaIndex inSection:indexPath.section]];
    checkedCell.accessoryType = UITableViewCellAccessoryNone;
    
    currentCategoriaIndex=indexPath.row;
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    
    
    self.conjunto.categoria= [fetchedResultsController objectAtIndexPath:indexPath];
    
    self.conjunto.needsSynchronize=[NSNumber numberWithBool:YES];

    // Save the context. 
    NSError *error;
    if (![self.managedObjectContext save:&error]) 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    [self.delegate dismissConjuntoDetailSetCategoriaVC];
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {

    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) 
    {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ConjuntoCategoria" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"idCategoria" ascending:YES];
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"orden" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
    }

	return fetchedResultsController;
}    


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {

	[self.categoriaTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
	
    UITableView *tableView = self.categoriaTableView;
	
    
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
			[self.categoriaTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.categoriaTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
    
    
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
	[self.categoriaTableView endUpdates];
}




@end
