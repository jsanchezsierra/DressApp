//
//  MainMenuViewController.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 11/21/11.
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


#import "MainMenuViewController.h"
#import "PrendaCategoria.h"
#import "PrendaSubCategoria.h"
#import "PrendaMarca.h"
#import "PrendaTienda.h"
#import "PrendaTemporada.h"
#import "PrendaEstado.h"
#import "Prenda.h"
#import "ConjuntoCategoria.h"
#import "StyleDressApp.h"
#import "Marcas.h"
#import "Authenticacion.h"

@implementation MainMenuViewController
@synthesize managedObjectContext;
@synthesize prendasViewController,conjuntosViewController,calendarViewController,profileViewController;
@synthesize menuTableView;
@synthesize currentNavController;
@synthesize menuView,myNavigationBar,myNavigationItem;
@synthesize stylesViewController;
@synthesize yourStyleViewController;
@synthesize showConoceTuEstiloOnMainMenu,showAparienciaOnMainMenu;
@synthesize myHelpViewController,mainMenuBackground;
@synthesize misMarcasViewController;

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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad
{
    
    //SHOW/HIDE SECTIONS EN MAIN MENU
    showConoceTuEstiloOnMainMenu=YES;
    showAparienciaOnMainMenu=YES;
    
    //Chequeo si existe la key @"CreateDefaultPrendas"
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"CreateDefaultPrendas"] ) 
        [defaults setObject:@"YES" forKey:@"CreateDefaultPrendas"];

    //La primera vez que entro ejecuto ViewDidLoad de PrendasViewController
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"LoadPreloadData"];

    [self.mainMenuBackground setImage:[StyleDressApp imageWithStyleNamed:@"MainMenuBackground"]];
    
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        //table background Color
        [menuTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0 )];
        [menuTableView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorMainMenuBackground]]; 
        //View background Color
        [self.view setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorMainMenuBackground]]; 
        //Table View background Color & separator line
        [menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [menuTableView setSeparatorColor:[UIColor blackColor]];

    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        [menuTableView setContentInset:UIEdgeInsetsMake(5, 0, 15, 0 )];
        [menuTableView setBackgroundColor:[UIColor clearColor]]; 
        [self.view setBackgroundColor:[UIColor clearColor]]; 
        [menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }    

    [myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
    
    //Add DressApp Header
    UIFont *titleHeaderFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:26];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,130,40)];
    titleLabel.font=titleHeaderFont;
    titleLabel.text=NSLocalizedString(@"DressApp", @"");
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorMainMenuHeader];
    myNavigationItem.titleView=titleLabel;
     
    
    [self clearAllViewControllers];
    
    //Define Main Menu CurrentNavigator
    self.currentNavController =[[CustomNavigationController alloc] init ];
    self.currentNavController.delegate=self;
    self.currentNavController.view.frame=CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height);
    self.currentNavController.view.tag=1;
    [self.view addSubview: self.currentNavController.view];

    
    //Create Prendas CurrentNavigator
    self.prendasViewController = [[PrendasViewController alloc] initWithNibName:@"PrendasViewController" bundle:nil] ;
    prendasViewController.delegate=self;
    prendasViewController.managedObjectContext=self.managedObjectContext;
        
    //Add prendasViewController to navViewControllers array
    [self.currentNavController setViewControllers:[NSArray arrayWithObject:prendasViewController]];
    
    //SET TODAY DATE TO CALENDER MONTH & YEAR
    NSCalendar *myCalendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsToday=[[NSDateComponents alloc] init];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
    compsToday= [myCalendar components:unitFlags fromDate:[NSDate date]];
    NSInteger currentMonth= [compsToday month];
    NSInteger currentYear= [compsToday year];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:currentMonth] forKey:@"calendarCurrentMonth"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:currentYear] forKey:@"calendarCurrentYear"];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)clearAllViewControllers
{
    conjuntosViewController=nil;
    calendarViewController=nil;
    profileViewController=nil;
    stylesViewController=nil;
    misMarcasViewController=nil;
    yourStyleViewController=nil;
    myHelpViewController=nil;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([[navigationController viewControllers] count]==1 && [[[navigationController viewControllers] objectAtIndex:0] isEqual: prendasViewController] ) 
    {
        [[[navigationController viewControllers] objectAtIndex:0] setDidSelectRow:NO];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UIImage*) createThumbnailFromImage:(UIImage*)imageToThumbnail withSize:(NSInteger)thumbnailSize
{
    CGSize size = imageToThumbnail.size;
    CGFloat ratio = 0;
    if (size.width > size.height) {
        ratio = thumbnailSize / size.width;
    } else {
        ratio = thumbnailSize / size.height;
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
    UIGraphicsBeginImageContext(rect.size);
    [imageToThumbnail drawInRect:rect];
    UIImage *thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnailImage;    
}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (showConoceTuEstiloOnMainMenu==NO && indexPath.row==7) 
        return 0;

    if (showAparienciaOnMainMenu==NO && indexPath.row==9) 
        return 0;

    //MAIN MENU HEADERS
    if (indexPath.row==0 || indexPath.row==4 || indexPath.row==8) 
        return 30; 
    else
    {
        //EACH STYLE HAS DIFFERENT CELL HEIGHTS 
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
            return 41;
        else if ([StyleDressApp getStyle] == StyleTypeModern )
            return 38; 
    }
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   static NSString *cellIdentifier = @"menuItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) 
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
        
        UIView *foregroundView= [[UIView alloc] initWithFrame:CGRectMake(10, 17-10, 280, 26)]; 
        [foregroundView setTag:1];
        [cell addSubview:foregroundView];
    
        UIImageView *iconView= [[UIImageView alloc] initWithFrame:CGRectMake(10, 12-10, 47, 35)]; 
        [iconView setTag:2];
        [cell addSubview:iconView];
   
        UILabel *labelMenu= [[UILabel alloc] initWithFrame:CGRectMake(75, 14-10, 200, 30)];  
        [labelMenu setBackgroundColor:[UIColor clearColor]];
        [labelMenu setTag:3];
        [cell addSubview:labelMenu];
        
    }
    
    
    UIImageView *iconView= (UIImageView*) [cell viewWithTag:2];
    UILabel *labelMenu= (UILabel*) [cell viewWithTag:3];

    //HEADER ROWS
    if (indexPath.row==0 || indexPath.row==4 || indexPath.row==8) 
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorMainMenuSection]];
        UIView *foregroundView =[cell viewWithTag:1];
        [foregroundView setBackgroundColor:[UIColor clearColor]];


    }else //OTHER ROWS
    {
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        else if ([StyleDressApp getStyle] == StyleTypeModern ) 
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        [cell.textLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorMainMenuCell]];
        UIView *foregroundView =[cell viewWithTag:1];
        [foregroundView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorMainMenuCellForegroundView]];
    }   
    
    UIFont *fontCellHeaders= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:21];
    UIFont *myFont= [UIFont systemFontOfSize:20];

    cell.textLabel.font=myFont;
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    
    NSError *error = nil;

    if (indexPath.row==0) // MI ARMARIO
    {
        cell.textLabel.font=fontCellHeaders;
        cell.textLabel.text=[NSString stringWithFormat:@"%@", NSLocalizedString(@"MiArmario", @"")];
        labelMenu.text=@"";
        iconView.image=nil;
    }
    else if (indexPath.row==1)  //PRENDAS
    {
        NSFetchRequest *fetchRequestPrenda = [[NSFetchRequest alloc] init];
        [fetchRequestPrenda setEntity:[NSEntityDescription entityForName:@"Prenda" inManagedObjectContext:self.managedObjectContext]];

        if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
            fetchRequestPrenda.predicate = [NSPredicate predicateWithFormat:@"usuario==%@",
                                            [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
        else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
                fetchRequestPrenda.predicate = [NSPredicate predicateWithFormat:@"(usuario = %@) OR (usuario = %@) OR (usuario = %@) ",[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"] ];
        
        NSArray *misPrendasAll=[self.managedObjectContext executeFetchRequest:fetchRequestPrenda error:&error];
        NSInteger prendasCount =[ misPrendasAll count];
        
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            cell.textLabel.text=[NSString stringWithFormat:@" %@ (%d)", NSLocalizedString(@"Prendas", @""),prendasCount ];
            cell.imageView.image=[StyleDressApp imageWithStyleNamed:@"MMIconPrendas"];
   
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            labelMenu.text=[NSString stringWithFormat:@" %@ (%d)", NSLocalizedString(@"Prendas", @""),prendasCount ];
            iconView.image=[StyleDressApp imageWithStyleNamed:@"MMIconPrendas"];

        }
        
    }
    else if (indexPath.row==2) //CONJUNTO
    {
        NSFetchRequest *fetchRequestConjunto = [[NSFetchRequest alloc] init];
        [fetchRequestConjunto setEntity:[NSEntityDescription entityForName:@"Conjunto" inManagedObjectContext:self.managedObjectContext]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"usuario==%@",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
        [fetchRequestConjunto setPredicate:predicate];

        NSArray *conjuntosArray= [self.managedObjectContext executeFetchRequest:fetchRequestConjunto error:&error];
        NSInteger conjuntosCount =[conjuntosArray  count];
        
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            cell.textLabel.text=[NSString stringWithFormat:@" %@ (%d)", NSLocalizedString(@"Conjuntos", @""),conjuntosCount ];
            cell.imageView.image=[StyleDressApp imageWithStyleNamed:@"MMIconConjuntos"]; 
            
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            labelMenu.text=[NSString stringWithFormat:@" %@ (%d)", NSLocalizedString(@"Conjuntos", @""),conjuntosCount ];
            iconView.image=[StyleDressApp imageWithStyleNamed:@"MMIconConjuntos"]; 
            
        }
    }
    else if (indexPath.row==3)  //CALENDAR
    {
        NSFetchRequest *fetchRequestCalendar = [[NSFetchRequest alloc] init];
        [fetchRequestCalendar setEntity:[NSEntityDescription entityForName:@"CalendarConjunto" inManagedObjectContext:self.managedObjectContext]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"usuario==%@",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
        [fetchRequestCalendar setPredicate:predicate];
        
        NSArray *calendarArray=[self.managedObjectContext executeFetchRequest:fetchRequestCalendar error:&error];
        NSInteger calendarCount =[calendarArray  count];
        
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            cell.textLabel.text=[NSString stringWithFormat:@" %@ (%d)", NSLocalizedString(@"Calendario", @""),calendarCount ];
            cell.imageView.image=[StyleDressApp imageWithStyleNamed:@"MMIconCalendar"];
            
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            labelMenu.text=[NSString stringWithFormat:@" %@ (%d)", NSLocalizedString(@"Calendario", @""),calendarCount ];
            iconView.image=[StyleDressApp imageWithStyleNamed:@"MMIconCalendar"];
            
        }
         
        
    }else if (indexPath.row==4)  // MI PERFIL
    {
        cell.textLabel.font=fontCellHeaders;
        cell.textLabel.text=[NSString stringWithFormat:@"%@", NSLocalizedString(@"MiPerfil", @"")];
        
        labelMenu.text=@"";
        iconView.image=nil;

    }
    else if (indexPath.row==5)  //PROFILE
    {
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            cell.imageView.image=[StyleDressApp imageWithStyleNamed:@"MMIconPerfil"];
            cell.textLabel.text=[NSString stringWithFormat:@" %@", NSLocalizedString(@"Perfil", @"")];
            
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            iconView.image=[StyleDressApp imageWithStyleNamed:@"MMIconPerfil"];
            labelMenu.text=[NSString stringWithFormat:@" %@", NSLocalizedString(@"Perfil", @"")];
            
        }
    }else if (indexPath.row==6) //Mis marcas
    {
        //Cuento las marcas de este usuario
        NSFetchRequest *fetchRequestPrendaMarca = [[NSFetchRequest alloc] init];
        [fetchRequestPrendaMarca setEntity:[NSEntityDescription entityForName:@"PrendaMarca" inManagedObjectContext:self.managedObjectContext]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"usuario==%@",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
        [fetchRequestPrendaMarca setPredicate:predicate];
        NSArray *misMarcasArray=[self.managedObjectContext executeFetchRequest:fetchRequestPrendaMarca error:&error];
        NSInteger misMarcasCount =[misMarcasArray count];
        
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            cell.imageView.image=[StyleDressApp imageWithStyleNamed:@"MMIconMisMarcas"];
            cell.textLabel.text=[NSString stringWithFormat:@" %@ (%d)", NSLocalizedString(@"MisMarcas", @""),misMarcasCount ];
            
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            iconView.image=[StyleDressApp imageWithStyleNamed:@"MMIconMisMarcas"];
            labelMenu.text=[NSString stringWithFormat:@" %@ (%d)", NSLocalizedString(@"MisMarcas", @""),misMarcasCount ];
            
        }
        
      
    }
    else if (indexPath.row==7)  //CONOCE TU ESTILO
    {
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            cell.imageView.image=[StyleDressApp imageWithStyleNamed:@"MMIconConoceTuEstilo"];
            cell.textLabel.text=[NSString stringWithFormat:@" %@", NSLocalizedString(@"tuEstiloShort", @"")];
            
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            iconView.image=[StyleDressApp imageWithStyleNamed:@"MMIconConoceTuEstilo"];
            labelMenu.text=[NSString stringWithFormat:@" %@", NSLocalizedString(@"tuEstiloShort", @"")];
            
        }
    }
       
    else if (indexPath.row==8)   // AJUSTES
    {
        cell.textLabel.font=fontCellHeaders;
        cell.textLabel.text=[NSString stringWithFormat:@"%@", NSLocalizedString(@"Ajustes", @"")];
        labelMenu.text=@"";
        iconView.image=nil;

    } else if (indexPath.row==9)  //APARIENCIA
    {
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            cell.imageView.image=[StyleDressApp imageWithStyleNamed:@"MMIconApariencia"];
            cell.textLabel.text=[NSString stringWithFormat:@" %@", NSLocalizedString(@"apariencia", @"")];
            
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            iconView.image=[StyleDressApp imageWithStyleNamed:@"MMIconApariencia"];
            labelMenu.text=[NSString stringWithFormat:@" %@", NSLocalizedString(@"apariencia", @"")];
            
        }
    } else if (indexPath.row==10)  //HELP
    {
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            cell.imageView.image=[StyleDressApp imageWithStyleNamed:@"MMIconHelp"];
            cell.textLabel.text=[NSString stringWithFormat:@" %@", NSLocalizedString(@"Ayuda", @"")];
 
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            iconView.image=[StyleDressApp imageWithStyleNamed:@"MMIconHelp"];
            labelMenu.text=[NSString stringWithFormat:@" %@", NSLocalizedString(@"Ayuda", @"")];
            cell.textLabel.text=@"";
        }
    }
    
    
    else
    {
        cell.textLabel.text=@"";
        cell.imageView.image=nil;
        
    }
    return cell;
    
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row<=10)
        [self changeToVC:indexPath.row];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        if (indexPath.row==0 || indexPath.row==4 || indexPath.row==8) 
            [cell setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorMainMenuSectionBackground]]; 
        else
            [cell setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorMainMenuCellBackground]]; 
        
    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        [cell setBackgroundColor:[UIColor clearColor]]; 

}



-(void) changeToVC:(NSInteger)indexVC
{
    if (indexVC==1) //Prendas 
    {
        [self clearAllViewControllers];

        [self.currentNavController setViewControllers:[NSArray arrayWithObject:prendasViewController]];
        
        [[self.currentNavController.viewControllers objectAtIndex:0] setIsChoosingPrendasForConjunto:NO];
        
        [self moveMainViewToRight:NO];
    }
    else if (indexVC==2) //Conjuntos 
    {
        [self clearAllViewControllers];

        self.conjuntosViewController = [[ConjuntosViewController alloc] initWithNibName:@"ConjuntosViewController" bundle:nil];
        conjuntosViewController.delegate=self;
        conjuntosViewController.managedObjectContext=self.managedObjectContext;
        [self.currentNavController setViewControllers:[NSArray arrayWithObject:conjuntosViewController]];
        
        [[self.currentNavController.viewControllers objectAtIndex:0] setIsChoosingConjuntoForCalendar:NO];
        [self moveMainViewToRight:NO];
    }
    else if (indexVC==3)  //Calendar 
    {
        [self clearAllViewControllers];

        self.calendarViewController  = [[CalendarViewController alloc]  initWithNibName:@"CalendarViewController"  bundle:nil];
        calendarViewController.delegate=self;
        calendarViewController.managedObjectContext=self.managedObjectContext;
        [self.currentNavController setViewControllers:[NSArray arrayWithObject:calendarViewController]];

        [calendarViewController viewInitCalendar];
        [self moveMainViewToRight:NO];
    }
    else if (indexVC==5)  //Profile 
    {
        [self clearAllViewControllers];

        self.profileViewController  = [[ProfileViewController alloc]  initWithNibName:@"ProfileViewController"  bundle:nil];
        profileViewController.delegate=self;
        profileViewController.managedObjectContext=self.managedObjectContext;
        
        [self.currentNavController setViewControllers:[NSArray arrayWithObject:profileViewController]];
        [self moveMainViewToRight:NO];
    } else if (indexVC==6)  //mis marcas 
    {
        [self clearAllViewControllers];

        self.misMarcasViewController  = [ [PrendasMisMarcasViewController alloc]  initWithNibName:@"PrendasMisMarcasViewController"  bundle:nil];
        misMarcasViewController.delegate=self;
        misMarcasViewController.isChoosingMarcaForPrenda=NO;
        misMarcasViewController.managedObjectContext=self.managedObjectContext;
        
        [self.currentNavController setViewControllers:[NSArray arrayWithObject:misMarcasViewController]];
        [self moveMainViewToRight:NO];
    }
    else if (indexVC==7)  //Your Style 
    {
        [self clearAllViewControllers];

        self.yourStyleViewController = [[YourStyleViewController alloc] initWithNibName:@"YourStyleViewController" bundle:nil];
        yourStyleViewController.delegate=self;
        yourStyleViewController.managedObjectContext=self.managedObjectContext;
        
        [self.currentNavController setViewControllers:[NSArray arrayWithObject:yourStyleViewController]];
        [self moveMainViewToRight:NO];
    }
    else if (indexVC==9)  //Apariencia 
    {
        [self clearAllViewControllers];

        self.stylesViewController = [[StylesViewController alloc] initWithNibName:@"StylesViewController" bundle:nil];   
        stylesViewController.delegate=self;
        stylesViewController.managedObjectContext=self.managedObjectContext;

        [self.currentNavController setViewControllers:[NSArray arrayWithObject:stylesViewController]];
        [stylesViewController updateControlsAppareance];
        [self moveMainViewToRight:NO];
    }else if (indexVC==10)  //Help 
    {
        [self clearAllViewControllers];

        self.myHelpViewController = [[helpViewController alloc] initWithNibName:@"helpViewController" bundle:nil];
        myHelpViewController.delegate=self;

        [self.currentNavController setViewControllers:[NSArray arrayWithObject:myHelpViewController]];
        [self moveMainViewToRight:NO];
    }
    
    [[self.currentNavController.viewControllers objectAtIndex:0] setIsRight:NO];
    
}


#pragma mark - Delegate methods

-(void)moveMainViewToRight:(BOOL)move{  
    
    //Reload table
    [self.menuTableView reloadData];
    
    CGRect frame = self.currentNavController.view.frame;
 
    if (move) 
    {
        [[[self.currentNavController.viewControllers objectAtIndex:0] containerView] setUserInteractionEnabled:NO] ;
        [[[self.currentNavController.viewControllers objectAtIndex:0] leftLineView] setHidden:NO] ;
        frame.origin.x = 270;
    }else{
        [[[self.currentNavController.viewControllers objectAtIndex:0] containerView] setUserInteractionEnabled:YES] ;
        [[[self.currentNavController.viewControllers objectAtIndex:0] leftLineView] setHidden:YES] ;
        frame.origin.x = 0;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.currentNavController.view.frame = frame;
    [UIView commitAnimations];
    
}

-(void)moveMainViewToFullRight:(BOOL)move{
    
    //Reload table
    [self.menuTableView reloadData];
    
    CGRect frame = self.currentNavController.view.frame;
    
    if (move) 
        frame.origin.x = 320;
    else
        frame.origin.x = 240;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.currentNavController.view.frame = frame;
    [UIView commitAnimations];    
}

- (void) dismissMisMarcasVC
{
    
}

@end
