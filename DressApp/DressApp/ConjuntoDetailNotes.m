//
//  ConjuntoDetailNotes.m
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


#import "ConjuntoDetailNotes.h"
#import "ConjuntoCategoria.h"
#import "CalendarConjunto.h"
#import "StyleDressApp.h"
#import "CalendarViewController.h"
#import "Authenticacion.h"
#import "AppDelegate.h"

@implementation ConjuntoDetailNotes
@synthesize delegate,managedObjectContext, fetchedResultsController,conjunto;
@synthesize notesTableView,myNavigationTitle;
@synthesize myTextField;
@synthesize myNavigationBar;
@synthesize myMainFrame,myImageViewBackground;
@synthesize notesTitle,fechaTitle,myNotesImageViewFrame;
@synthesize calendarDateBtn;

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
    saveBeforeExit=NO;

    [self.myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
    
    //Fetch ResultsController
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}		
    

    //set title
    //set header title Frame and Label
    UIImageView *titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,3, 127,38)];
    [titleImageView setImage:[StyleDressApp imageWithStyleNamed:@"GEHeaderFrame"]];
    UILabel *headerTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 127, 31)];
    [headerTitleLabel setTextAlignment:UITextAlignmentCenter];
    [headerTitleLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:25]];
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [headerTitleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCONotasHeader]];
    [headerTitleLabel setText:NSLocalizedString(@"NotasTitle",@"")];
    [titleImageView addSubview:headerTitleLabel];
    [self.myNavigationTitle setTitleView:titleImageView];
    
    //CalendarButton
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarButton setFrame:CGRectMake(245,155,43,30)];
    [calendarButton setImage:[StyleDressApp imageWithStyleNamed:@"CODetailBtnAddToCalendar"] forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(openCalendarViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:calendarButton];

    
    //title labels setting
    UIFont *myFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:22];
    [self.notesTitle setFont:myFont];
    [self.notesTitle setText:[NSString stringWithFormat:@" %@",NSLocalizedString(@"NotasTitle", @"")]];
    [self.notesTitle setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCONotasSectionTitle]];
    [self.fechaTitle setFont:myFont];
    [self.fechaTitle setText:[NSString stringWithFormat:@" %@",NSLocalizedString(@"FechasTitle", @"")]];
    [self.fechaTitle setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCONotasSectionTitle]];

    //Inserta nota del conjunto    
    self.myTextField.text=conjunto.nota;
    
    
    //Table View settings
    rowHeight=52;
    [self.notesTableView setBackgroundColor:[UIColor clearColor]];
    [self.notesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.notesTableView setSeparatorColor:[UIColor clearColor]];
    [self.notesTableView setRowHeight:rowHeight];

    
    //Set image background
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"CODetailNotasBackground"]];
    
    //Main Frame Properties
    [self.myMainFrame setImage:[StyleDressApp imageWithStyleNamed:@"CODetailNotesFrame"]];

    //TextField Frame  //CODetailNotesTableFrame
    [self.myNotesImageViewFrame setImage:[StyleDressApp imageWithStyleNamed:@"PRONotesTextFrame"]];

    //TextField Frame  //CODetailNotesTableFrame
    [self.calendarDateBtn setImage:[StyleDressApp imageWithStyleNamed:@"CODetailNotesAddCalendar"] forState:UIControlStateNormal];
    

    [self.notesTableView reloadData];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark -


#pragma mark open calendarForConjuntoVC

//Open calendarForConjuntoVC
-(void) openCalendarViewController
{
     
    CalendarForConjuntoVC *calendarForConjuntoVC  = [[CalendarForConjuntoVC alloc]  initWithNibName:@"CalendarForConjuntoVC"  bundle:nil];
    calendarForConjuntoVC.delegate=self;
    calendarForConjuntoVC.managedObjectContext=self.managedObjectContext;
 
    UINavigationController *thisNavController= [[UINavigationController alloc] initWithRootViewController:calendarForConjuntoVC];

    [thisNavController.navigationBar setTintColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];

    [self presentModalViewController:thisNavController animated:YES];

 }

#pragma mark -

#pragma mark calendarForConjuntoVC delegate

-(void) calendarDidCancelSelection
{
    [self dismissModalViewControllerAnimated:YES];
}


-(void) calendarDidChooseDayForConjunto:(NSDate *)thisDate
{
    
    
    conjunto.needsSynchronize=[NSNumber numberWithBool:YES];
    
    NSString *calendarConjuntoName= [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];

    NSString *idCalendarDispositivoSH1= [Authenticacion getSH1ForUser:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] andIdentifier:calendarConjuntoName];

    
    NSDictionary *calendarData= [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"calDescription", @"descripcion", 
                                 thisDate, @"fecha", 
                                 [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] ,@"usuario",
                                 conjunto, @"conjunto", 
                                 calendarConjuntoName, @"idCalendar", 
                                 idCalendarDispositivoSH1,@"idCalendarDispositivo",
                                 [NSNumber numberWithInt:1], @"valoracion",
                                 @"", @"urlPictureServer",
                                 @"", @"nota", 
                                 [NSNumber numberWithBool:YES],@"needsSynchronize",
                                 [NSNumber numberWithBool:YES],@"firstBackup",
                                 @"YES",@"restoreFinished",
                                 nil];
    
    CalendarConjunto *newCalendarEntry= [CalendarConjunto calendarConjuntoWithData:calendarData inManagedObjectContext:self.managedObjectContext overwriteObject:NO];
    
    
    NSError *errorSave = nil;
    if (![self.managedObjectContext save:&errorSave])
        NSLog(@"Unresolved error %@, %@", errorSave, [errorSave userInfo]);
   
    [self viewDidLoad];
    
    [self dismissModalViewControllerAnimated:YES];

    
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

#pragma mark -

#pragma mark cancel categorySelection
-(IBAction) doneButton
{
    if (saveBeforeExit) 
    {
        conjunto.needsSynchronize=[NSNumber numberWithBool:YES];
        NSError *error;
        if (![self.managedObjectContext save:&error]) 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
 
    conjunto.nota=myTextField.text;
    [self.delegate dismissConjuntoDetailNotesVCDelegate];    
}

#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    saveBeforeExit=YES;
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    NSInteger count = [[fetchedResultsController sections] count];
    
	if (count == 0) 
		count = 1;
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    
    NSInteger numberOfRows = 0;
    if ([[fetchedResultsController sections] count] > 0) 
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }

    return numberOfRows; 
}   
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *ConjuntoDetailCellIdentifier = @"ConjuntoDetailCellIdentifier";
    

    UITableViewCell *conjuntoDetailCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ConjuntoDetailCellIdentifier];
    if (conjuntoDetailCell == nil) 
    {
        conjuntoDetailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ConjuntoDetailCellIdentifier] ;
		conjuntoDetailCell.accessoryType = UITableViewCellAccessoryNone;
        [conjuntoDetailCell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
        [conjuntoDetailCell setBackgroundColor:[UIColor clearColor]];

        UIImageView *cellFrameImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,-2+5,230,44)]; //33
        [cellFrameImageView setTag:10];
        [cellFrameImageView setImage:[StyleDressApp imageWithStyleNamed:@"PRONotesTextFrame"]];
        [cellFrameImageView setContentMode:UIViewContentModeScaleToFill];
        [conjuntoDetailCell.contentView addSubview:cellFrameImageView];
        
        UILabel *cellTextLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10+5, 95-15,24)];
        [cellTextLabel setTag:11];
        [cellTextLabel setFont:[UIFont systemFontOfSize:18]];
        [cellTextLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCONotasCell]];
        [cellTextLabel setBackgroundColor:[UIColor clearColor]];
        [conjuntoDetailCell.contentView addSubview:cellTextLabel];

        UILabel *cellDetailTextLabel=[[UILabel alloc] initWithFrame:CGRectMake(105-15, 10+5, 120+15,24)];
        [cellDetailTextLabel setTag:12];
        [cellDetailTextLabel setFont:[UIFont systemFontOfSize:12]];
        [cellDetailTextLabel setTextColor:[UIColor blackColor]];
        [cellDetailTextLabel setBackgroundColor:[UIColor clearColor]];
        [cellDetailTextLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCONotasCell]];
        [cellDetailTextLabel setAlpha:0.5];
        [conjuntoDetailCell.contentView addSubview:cellDetailTextLabel];
    }
    
    //Get table frame
    UIImageView *cellFrameImageView= (UIImageView*) [conjuntoDetailCell.contentView viewWithTag:10];
    [cellFrameImageView setFrame:CGRectMake(0,-2+5,230,44)];
    
    //Get Current Calendar Conjunto
    CalendarConjunto *calendarConjunto = (CalendarConjunto *) [fetchedResultsController objectAtIndexPath:indexPath];
    
    //Set Date Format to String
    NSDateFormatter *myDateFormat= [[NSDateFormatter alloc] init] ;
    NSLocale *myLocale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"locale", @"")];
    [myDateFormat setLocale: myLocale] ;
    [myDateFormat setDateStyle:NSDateFormatterShortStyle]; //
    NSString *myDateString = [myDateFormat stringFromDate:calendarConjunto.fecha];    
    
    //Get table TextCellLabel
    UILabel *cellTextLabel= (UILabel*) [conjuntoDetailCell.contentView viewWithTag:11];
    cellTextLabel.text=myDateString;
    
    //Get table DetailTextCellLabel
    UILabel *cellDetailTextLabel= (UILabel*) [conjuntoDetailCell.contentView viewWithTag:12];
    cellDetailTextLabel.text=calendarConjunto.nota;
    
    return conjuntoDetailCell;
}



#pragma mark -
#pragma mark Table view delegate


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return(YES);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=0)
        return (UITableViewCellEditingStyleDelete); 
}

//Asks the data source to commit the insertion or deletion of a specified row in the receiver.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If row is deleted, remove it from the list. 
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        CalendarConjunto *calendarConjunto = (CalendarConjunto *) [fetchedResultsController objectAtIndexPath:indexPath];
 
        //Borro CalendarConjunto de la tabla
        [self.managedObjectContext deleteObject:calendarConjunto];

        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    }
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
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CalendarConjunto" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
            [fetchRequest setPredicate:  [NSPredicate predicateWithFormat:@"(conjunto == %@) AND (usuario == %@)", conjunto,[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]  ] ];
        else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
            
            [fetchRequest setPredicate:  [NSPredicate predicateWithFormat:@"(conjunto == %@) AND ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )", conjunto, [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ] ,DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"] ]];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fecha" ascending:NO];
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


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.notesTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.notesTableView;
	
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


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type 
{
    switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.notesTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.notesTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
	[self.notesTableView endUpdates];
}


@end
