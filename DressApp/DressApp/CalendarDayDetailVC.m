//
//  CalendarDayDetailVC.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 12/9/11.
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


#import "CalendarDayDetailVC.h"
#import "Conjunto.h"
#import "Prenda.h"
#import "ConjuntoPrendas.h"
#import "StyleDressApp.h"

@implementation CalendarDayDetailVC
@synthesize managedObjectContext,dayDate;
@synthesize delegate;
@synthesize drawingView;
@synthesize myScrollView;
@synthesize calendarConjuntoItem;
@synthesize myTextField;
@synthesize myBackgroundImage,myFrameImage,myNotesImage;

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
    self.view.frame=CGRectMake(0,0,320,416);
    
    //Fijo color transparente para el background de la vista que muestra el conjunto -  drawingView
    self.drawingView.backgroundColor=[UIColor clearColor];
    
    //Navigation Bar Color
    [self.navigationController.navigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];

    //Prepare file manager && cachesDirectory
    cachesDirectory= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    
    fileManager = [NSFileManager defaultManager];

    //Add Trahs Button
    UIBarButtonItem *addTrashButton = [ [UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonPressed) ];
    self.navigationItem.leftBarButtonItem= addTrashButton; 

    //Add Done Button
    UIBarButtonItem *addDoneButton = [ [UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed) ];
    self.navigationItem.rightBarButtonItem= addDoneButton; 


    //ScrollView
    [myScrollView setFrame:CGRectMake(0, 0, 320, 416)];
    [myScrollView setContentSize:CGSizeMake(320, 416)];
    
    //Request urlPicture
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"CalendarConjunto" inManagedObjectContext:self.managedObjectContext];
	
    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        request.predicate = [NSPredicate predicateWithFormat:@" (fecha == %@) AND (usuario == %@)",dayDate,[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]  ];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        request.predicate = [NSPredicate predicateWithFormat:@" (fecha == %@) AND ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )",dayDate,[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]  ];
    
	NSError *error = nil;
    NSArray *fetchResults= [self.managedObjectContext executeFetchRequest:request error:&error] ;
	self.calendarConjuntoItem = [fetchResults lastObject];
    
    //Set Date Format to String - para titleView
    NSDateFormatter *myDateFormat= [[NSDateFormatter alloc] init] ;
    [myDateFormat setDateStyle:NSDateFormatterMediumStyle];
    NSString *myDateString = [myDateFormat stringFromDate:dayDate];    
    
    
    //Set Title View
    UIFont *myFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:22];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,140,44)];
    titleLabel.font=myFont;
    titleLabel.text=myDateString;
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorCalendarDetailHeader];

    self.navigationItem.titleView=titleLabel;
    
    //add style imageViews
    [myBackgroundImage setImage:[StyleDressApp imageWithStyleNamed:@"CalendarDetailBackground"]]; 
    [myFrameImage setImage:[StyleDressApp imageWithStyleNamed:@"CADetailMarco"]];
    [myNotesImage setImage:[StyleDressApp imageWithStyleNamed:@"CADetailNotes"]];
    
    [self addConjuntoViews];

    //set textView Text
    [self.myTextField setFont:[StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:14]];
    [self.myTextField setText:self.calendarConjuntoItem.nota ];
    [self.myTextField setPlaceholder:NSLocalizedString(@"introNote", @"")];
    
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

#pragma mark - UITextViewDelegate

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.myScrollView setContentOffset:CGPointMake(0 , 210) animated:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self textFieldUpdate:textField];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldUpdate:textField];
    
}


- (void)textFieldUpdate:(UITextField *)textField
{
    self.calendarConjuntoItem.needsSynchronize=[NSNumber numberWithBool:YES];
    [textField resignFirstResponder];
    [self.myScrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
    

}

#pragma mark -  Done/Trash Buttons

-(void) doneButtonPressed
{
    
    [self.calendarConjuntoItem setNota:self.myTextField.text];

    NSError *error;
    if (![self.managedObjectContext save:&error]) 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

    [self.delegate didFinishEditingCalendarDay];
    
}

-(void) addTrashButton
{
    
    [self.delegate didFinishEditingCalendarDay];

}



-(void) addConjuntoViews
{
        
    //GET ConjuntosPrendas Array in a given Category
    NSFetchRequest *fetchRequestConjuntoPrendas = [[NSFetchRequest alloc] init];
	[fetchRequestConjuntoPrendas setEntity:[NSEntityDescription entityForName:@"ConjuntoPrendas" inManagedObjectContext:self.managedObjectContext]];
    
    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        fetchRequestConjuntoPrendas.predicate =[NSPredicate predicateWithFormat:@"(conjunto == %@) AND (usuario==%@)",calendarConjuntoItem.conjunto,[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        fetchRequestConjuntoPrendas.predicate =[NSPredicate predicateWithFormat:@"(conjunto == %@) AND ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )",calendarConjuntoItem.conjunto,[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ], DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orden" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequestConjuntoPrendas setSortDescriptors:sortDescriptors];
	NSError *errorConjuntoPrenda = nil;
	NSMutableArray *conjuntoPrendasArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequestConjuntoPrendas error:&errorConjuntoPrenda]];
    
    int i;
    //Remove previous views
    for (i=0; i<[self.drawingView.subviews count];i++  ) 
    {
        UIView *theView= [self.drawingView.subviews objectAtIndex:i];
        if ( [theView isKindOfClass: [ConjuntoPrendaView class]] ) 
            [theView removeFromSuperview];
    }
    

    float scale= 210./320.;  //La escala es el ancho de la imageView(210) entre en ancho total(320)
    
    for (ConjuntoPrendas *conjuntoPrenda  in conjuntoPrendasArray) {
        
        
        ConjuntoPrendaView *myPrendaView = [ [ConjuntoPrendaView alloc] initWithFrame:CGRectMake(scale*[conjuntoPrenda.x floatValue] , scale*[conjuntoPrenda.y floatValue],scale*[conjuntoPrenda.width floatValue],scale*[conjuntoPrenda.height floatValue]) ];
        
        
        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",conjuntoPrenda.prenda.urlPicture] ]; 
        if ( [fileManager fileExistsAtPath:imagePath] ) 
            [[myPrendaView prendaImageView] setImage: [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]] ];  
        
        [myPrendaView setUserInteractionEnabled:NO];
        [myPrendaView setConjuntoPrenda:conjuntoPrenda];
        [myPrendaView setDelegate:self];
        //[myPrendaView setEscala:[conjuntoPrenda.scale floatValue ]];
        [myPrendaView setConjuntoPrenda:conjuntoPrenda];
        [self.drawingView addSubview:myPrendaView];
    }

    
    
    
    
    
}


#pragma mark - moveToTrash - remove item from dataBase 
-(void) trashButtonPressed
{
    
    alertViewMoveToTrash = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MoveCalendarItemToTrashTitle", @"")
                                                      message:NSLocalizedString(@"MoveCalendarItemToTrashMsg", @"")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"SI", @"")
                                            otherButtonTitles:NSLocalizedString(@"NO", @""),                                            
                            nil];
    [alertViewMoveToTrash show];
    
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet==alertViewMoveToTrash && buttonIndex==0) 
    {
        [self.managedObjectContext deleteObject: calendarConjuntoItem ];
		
        if ([calendarConjuntoItem.firstBackup boolValue]==NO) 
        {
             
            //Añado conjunto a borrar al historico de prendas
            NSDictionary *calendarDictionaryHistorico = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                         
                                                         [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],@"username",
                                                         calendarConjuntoItem.conjunto.idConjunto,@"idConjunto",
                                                         calendarConjuntoItem.idCalendar,@"idCalendar",
                                                         nil] ;
            //Creo nuevo item en la base de datos
            [CalendarHistoricoRemove  calendarHistoricoWithData:calendarDictionaryHistorico inManagedObjectContext:self.managedObjectContext  ];
        }

        // Save the context. 
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }   
        [delegate didMoveCalendarItemToTrash];
    }
    
}

 
@end
