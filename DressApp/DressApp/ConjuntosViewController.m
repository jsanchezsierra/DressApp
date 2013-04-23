//
//  ConjuntosViewController.m
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


#import "ConjuntosViewController.h"
#import "Conjunto.h"
#import "ConjuntoCategoria.h"
#import "StyleDressApp.h"
#import "Authenticacion.h"
#import "AppDelegate.h"
 
@implementation ConjuntosViewController
@synthesize managedObjectContext;
@synthesize delegate,isRight;
@synthesize containerView;
@synthesize delegateCalendar;
@synthesize isChoosingConjuntoForCalendar;
@synthesize myScroolView;
@synthesize conjuntosArray;//,categoria;
@synthesize helpAddConjuntoLabel,helpAddConjuntoImageView;
@synthesize conjuntoDetailContainerVC;
@synthesize myViewActivity;
@synthesize leftLineView;
@synthesize backgroundImageView;

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

    [leftLineView setHidden:YES];
    [myViewActivity stopAnimating];
    self.title=NSLocalizedString(@"Conjuntos",@"");

    //Set background colors
    [self.containerView setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCOBackground] ];
    [self.view setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCOBackground]];
    [myScroolView setBackgroundColor:[UIColor clearColor]];
    [myScroolView showsVerticalScrollIndicator]; 
    [myScroolView flashScrollIndicators];
    
    [self.containerView setFrame:CGRectMake(0,0,320,416)]; //416
 [self.backgroundImageView setImage:[StyleDressApp imageWithStyleNamed:@"COBackground"]];
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        [self.helpAddConjuntoLabel setFrame:CGRectMake(0, 42, 320, 30)]; 
    else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        [self.helpAddConjuntoLabel setFrame:CGRectMake(0, 35, 320, 30)]; 
    
    
    //Create help menu
    [self.helpAddConjuntoImageView setImage:[StyleDressApp imageWithStyleNamed:@"COHelpFrame"]];
    
    [self.helpAddConjuntoLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:16]];
    [self.helpAddConjuntoLabel setText:NSLocalizedString(@"helpAddingConjunto", @"")];
    [self.helpAddConjuntoLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorCOEmptyConjunto]];
    [self.helpAddConjuntoImageView setHidden:YES];
    [self.helpAddConjuntoLabel setHidden:YES];
    
    
    if (isChoosingConjuntoForCalendar==NO) 
    {
        isRight=NO;
        
        //Create RightBarButtonItem -  MenuButton
        UIBarButtonItem *addConjuntoButton = [ [UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addConjuntoToCurrentCategory) ];
        self.navigationItem.rightBarButtonItem= addConjuntoButton; 

        UIBarButtonItem *leftBarButtonItem= [[UIBarButtonItem alloc] init];
        [leftBarButtonItem setImage:[StyleDressApp imageWithStyleNamed:@"GEBtnMainMenu" ] ];
        [leftBarButtonItem setTarget:self];
        [leftBarButtonItem setStyle:UIBarButtonItemStyleBordered];
        [leftBarButtonItem setAction:@selector(popMainMenuViewController)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem; 
   
        [self addHeaderCenterView];
    }
    else   //Choosing conjunto calendar
    {
        UIFont *myFontTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:26];
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,180,32)];
        titleLabel.font=myFontTitle;
        titleLabel.text=NSLocalizedString(@"AddConjunto", @"");
        titleLabel.textAlignment=UITextAlignmentCenter;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorCOHeader];
        [self.navigationItem setTitleView:titleLabel ];

        
        UIBarButtonItem *cancelButton=[ [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChoosingConjuntoForCalendar)];
        [self.navigationController.navigationBar setTintColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];
        [self.navigationItem setLeftBarButtonItem:cancelButton];
     }

    //Prepare file manager && cachesDirectory
    cachesDirectory= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    
    fileManager = [NSFileManager defaultManager];

    [self conjuntoRequest];
    [self createConjuntoViews];    
    [self.myScroolView setFrame:CGRectMake(0,0, 320,416)]; //367
    
    [super viewDidLoad];
}


-(void)addHeaderCenterView
{
    
    //Add centerView
    UIButton *prendasButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prendasButton setFrame:CGRectMake(5, 5, 44, 30)];
    [prendasButton addTarget:self action:@selector(changeToPrendasVC) forControlEvents:UIControlEventTouchUpInside];
    [prendasButton setImage:[StyleDressApp imageWithStyleNamed:@"HeaderIconPrendas"] forState:UIControlStateNormal];
    [prendasButton setTitle:@"Pre" forState:UIControlStateNormal];
    
    UIButton *conjuntosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [conjuntosButton setFrame:CGRectMake(55, 5, 44, 30)];
    [conjuntosButton setImage:[StyleDressApp imageWithStyleNamed:@"HeaderIconConjuntos"] forState:UIControlStateNormal];
    [conjuntosButton setTitle:@"Con" forState:UIControlStateNormal];
    [conjuntosButton setHighlighted:YES];
    [conjuntosButton setUserInteractionEnabled:NO];

    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarButton setFrame:CGRectMake(105, 5, 44, 30)];
    [calendarButton addTarget:self action:@selector(changeToCalendarVC) forControlEvents:UIControlEventTouchUpInside];
    [calendarButton setImage:[StyleDressApp imageWithStyleNamed:@"HeaderIconCalendar"] forState:UIControlStateNormal];
    [calendarButton setTitle:@"Cal" forState:UIControlStateNormal];
    
    UIView *centerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150,40)];
    [centerView addSubview:prendasButton];
    [centerView addSubview:conjuntosButton];
    [centerView addSubview:calendarButton];
    
    self.navigationItem.titleView = centerView; 
    
}

#pragma mark - ConjuntoDetail delegates 
-(void) updateConjuntoView
{
    [self conjuntoRequest];
    [self createConjuntoViews];
    [self checkConjuntosEmpty];

}

-(void) updateCalendarView:(BOOL)updateCalendar
{

}

#pragma mark - Update ConjuntoViews Methods 

-(void) conjuntoRequest
{
    self.conjuntosArray = [[NSMutableArray alloc] init];
    
    //GET ConjuntosArray in a given Category
    NSFetchRequest *fetchRequestPrenda = [[NSFetchRequest alloc] init];
	[fetchRequestPrenda setEntity:[NSEntityDescription entityForName:@"Conjunto" inManagedObjectContext:self.managedObjectContext]];
    
    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        fetchRequestPrenda.predicate = [NSPredicate predicateWithFormat:@"usuario==%@",
                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        fetchRequestPrenda.predicate = [NSPredicate predicateWithFormat:@"((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )", [[NSUserDefaults standardUserDefaults] objectForKey:@"username" ],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
 
    
    //fetchRequestPrenda.predicate =[NSPredicate predicateWithFormat:@"categoria == %@",categoria];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idConjunto" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequestPrenda setSortDescriptors:sortDescriptors];
	NSError *errorPrenda = nil;
	self.conjuntosArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequestPrenda error:&errorPrenda]];
    [self checkConjuntosEmpty];
    
}

-(void) checkConjuntosEmpty
{
    if ([conjuntosArray count]<=0 && isChoosingConjuntoForCalendar==NO) 
    {
        [self.helpAddConjuntoImageView setHidden:NO];
        [self.helpAddConjuntoLabel setHidden:NO];
    }
    else
    {       
        [self.helpAddConjuntoImageView setHidden:YES];
        [self.helpAddConjuntoLabel setHidden:YES];
    }
}

-(void) createConjuntoViews
{
    
    //Remove previous views
    int i;
    NSInteger numberOfSubviews=[self.myScroolView.subviews count];
    for (i=0; i<numberOfSubviews;i++  ) 
    {
        UIView *theView= [self.myScroolView.subviews objectAtIndex:0];
        [theView removeFromSuperview];
    }
    
    
    CGFloat conjuntoViewWidth=92;  //
    CGFloat conjuntoViewHeight=conjuntoViewWidth*372./320.;
    
    int j;    
    int x,y;
    int xIni=(320-conjuntoViewWidth*3)/4;
    int yIni=10; //5
    int offset=0;
    
    //Row count
    NSInteger numberOfRows;
    numberOfRows = [ self.conjuntosArray count];
    for (j=0;j<numberOfRows;j++)
    {
        Conjunto *conjunto = (Conjunto *)[ self.conjuntosArray objectAtIndex:j];
        x=xIni+j%3 *(conjuntoViewWidth+xIni);
        y=yIni+ 120* (int)(j/3);
        ConjuntoView *myConjuntoView = [[ConjuntoView alloc] initWithFrame:CGRectMake(x, y,conjuntoViewWidth,conjuntoViewHeight) andOffset:offset];
        [myConjuntoView initView];
        // [myConjuntoView setOffset:offset];
        NSString *urlPicture= conjunto.urlPicture;
        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",urlPicture] ]; 
        NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",urlPicture] ]; 
        if ( [fileManager fileExistsAtPath:imagePathSmall] ) 
        {
            UIImage *myImage= [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePathSmall] ];
            [[myConjuntoView itemImageView] setImage:myImage  ];  
        }
       else  if ( [fileManager fileExistsAtPath:imagePath] ) 
        {
            UIImage *myImage= [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath] ];
            UIImage *thumbnailImageSmall=[self createThumbnailFromImage:myImage withSize:PIC_CONJUNTO_SMALL];
            NSData *dataSmall = [[NSData alloc] initWithData: UIImagePNGRepresentation(thumbnailImageSmall) ];
            [dataSmall writeToFile:imagePathSmall atomically:YES];    
            [[myConjuntoView itemImageView] setImage:myImage  ];  
    }
       
        [myConjuntoView setDelegate:self];
        [myConjuntoView setConjunto:conjunto];
        [self.myScroolView addSubview:myConjuntoView];
        [myConjuntoView setNeedsDisplay];
    }
    yIni=y+125;
    [self.myScroolView setContentSize:CGSizeMake(320, y+130)];
}


#pragma mark - ConjuntoView delegates
- (void)ConjuntoViewControlDelegate:(ConjuntoView*)conjuntoView  didChooseItem:(Conjunto*)conjunto;
{
    if (isChoosingConjuntoForCalendar==NO) 
    {
        NSInteger currentConjuntoPage=0;
        if (conjunto !=nil) 
            currentConjuntoPage= [self.conjuntosArray indexOfObject:conjunto];
        self.conjuntoDetailContainerVC= [[ConjuntoDetailContainerVC alloc] initWithNibName:@"ConjuntoDetailContainerVC" bundle:[NSBundle mainBundle]];

        if (conjuntoView==nil)
            self.conjuntoDetailContainerVC.isSaveNeededForNewConjunto=YES;
        else
            self.conjuntoDetailContainerVC.isSaveNeededForNewConjunto=NO;
        self.conjuntoDetailContainerVC.currentPage=currentConjuntoPage;
        self.conjuntoDetailContainerVC.conjuntosArray=self.conjuntosArray;
        
        self.conjuntoDetailContainerVC.delegate=self;
        self.conjuntoDetailContainerVC.managedObjectContext=self.managedObjectContext;
        [self.navigationController pushViewController:conjuntoDetailContainerVC animated:YES];
        
    }
    else
        [self.delegateCalendar finishChoosingConjuntoForCalendar:conjunto ];
    
}
- (void)ConjuntoViewPauseScrolling:(ConjuntoView*)conjuntoView;
{
    [myScroolView setScrollEnabled:NO];
    
}
- (void)ConjuntoViewResumeScrolling:(ConjuntoView*)conjuntoView;
{
    [myScroolView setScrollEnabled:YES];
    
}


#pragma mark - Add new Item

-(void) addConjuntoToCurrentCategory
{
    [myViewActivity startAnimating];
    [self performSelector:@selector(addingNewConjunto) withObject:nil afterDelay:0.05];
}

-(void) addingNewConjunto
{
    PrendasViewController *newVC= [[PrendasViewController alloc] initWithNibName:@"PrendasViewController" bundle:[NSBundle mainBundle]];
    [newVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [newVC setManagedObjectContext:self.managedObjectContext];
    [newVC setIsChoosingPrendasForConjunto:YES];
    [newVC setDelegateConjunto:self];
    [self presentModalViewController:newVC animated:YES];
}



#pragma mark - PrendasViewController delegate

-(void) cancelChoosingPrendasForConjunto
{
    [myViewActivity stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) finishChoosingPrendasForConjunto:(NSMutableArray *)prendasForConjuntoArray
{
    [myViewActivity stopAnimating];

    //Dissmiss ModalVC
    [self dismissModalViewControllerAnimated:YES];
    
    //GET PrendaCategoria Array
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"ConjuntoCategoria" inManagedObjectContext:self.managedObjectContext]];
        
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idCategoria" ascending:YES];
    fetchRequest.predicate =[NSPredicate
                        predicateWithFormat:@"idCategoria == %@ ",@"4"];  //COJO CATEGORIA OTROS!
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];

    NSError *error = nil;
    ConjuntoCategoria *conjuntoCategoria = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];

    
    //Genero un nombre para el item, basado en timeIntervalSince1970
    NSString *conjuntoName= [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];

    NSString *idConjuntoDispositivoSH1= [Authenticacion getSH1ForUser:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] andIdentifier:conjuntoName];

    
    //preparo los campos para crear el conjunto
    NSDictionary *conjuntoDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        conjuntoName,@"descripcion",
                                        conjuntoName,@"idConjunto",
                                        idConjuntoDispositivoSH1,@"idConjuntoDispositivo",
                                        [NSNumber numberWithInteger:1],@"rating",
                                        conjuntoName,@"urlPicture",
                                        [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], @"usuario",
                                        conjuntoCategoria, @"categoria",
                                        @"",@"nota",
                                        @"",@"urlPictureServer",
                                        [NSDate date],@"fecha",
                                        [NSNumber numberWithBool:YES],@"needsSynchronize",
                                        [NSNumber numberWithBool:YES],@"firstBackup",
                                        [NSNumber numberWithBool:YES],@"needsSynchronizeImage",
                                        @"YES",@"restoreFinished",
                                        nil] ;
    
    
    //Creo nuevo conjunto en la base de datos
    Conjunto *addedConjunto= [Conjunto conjuntoWithData:conjuntoDictionary inManagedObjectContext:self.managedObjectContext overwriteObject:NO];
    
    //Añado prendas al conjunto (a tabla ConjuntoPrendas)
    [self crearConjuntoPrendas:prendasForConjuntoArray forConjunto:addedConjunto];
    
    //Actualizo vistas en ConjuntosCategoria
    [self updateConjuntoView];
    
    //Abro ConjuntoDetailContainer para editar el conjunto que acabo de crear
    [self ConjuntoViewControlDelegate:nil didChooseItem:addedConjunto];
    
}

-(void) crearConjuntoPrendas:(NSMutableArray*)prendasForConjuntoArray forConjunto:(Conjunto*)thisConjunto
{
    if ([prendasForConjuntoArray count]>0) 
    {
        NSInteger offsetCategoria1=0;
        NSInteger offsetCategoria2=0;
        NSInteger offsetCategoria3=0;
        NSInteger offsetCategoria4=0;

        NSInteger centerX=160; 
        NSInteger centerY=180; 
        NSInteger x,y;
        NSInteger x1=10,y1=10;
        NSInteger x2=centerX+10,y2=10;
        NSInteger x3=10,y3=centerY+10;
        NSInteger x4=centerX+10,y4=centerY+10;
        float scale=1;
        float width=135; //160  170
        float height=180; //180  226
        
        NSInteger orden=0;
        if ([[thisConjunto prendas] count]>0) 
            orden=[[thisConjunto prendas] count];
        
        
        //Extreigo inicialmente el número de prendas en cada categorías
        NSInteger numberOfPrendasCategoria1=0;
        NSInteger numberOfPrendasCategoria2=0;
        NSInteger numberOfPrendasCategoria3=0;
        NSInteger numberOfPrendasCategoria4=0;
        for (Prenda  *newConjuntoPrenda in prendasForConjuntoArray) 
        {
            NSInteger categoriaPrenda=[newConjuntoPrenda.categoria.idCategoria intValue];
            if (categoriaPrenda==1)
                numberOfPrendasCategoria1++;
            if (categoriaPrenda==2)
                numberOfPrendasCategoria2++;
            if (categoriaPrenda==3)
                numberOfPrendasCategoria3++;
            if (categoriaPrenda==4)
                numberOfPrendasCategoria4++;
        }
        
        if (numberOfPrendasCategoria1>0)
            offsetCategoria1=(width/2) /numberOfPrendasCategoria1;
        
        if (numberOfPrendasCategoria2>0)
            offsetCategoria2=(width/2) /numberOfPrendasCategoria2;
        
        if (numberOfPrendasCategoria3>0)
            offsetCategoria3=(width/2) /numberOfPrendasCategoria3;
        
        if (numberOfPrendasCategoria4>0)
            offsetCategoria4=(width/2) /numberOfPrendasCategoria4;
        
        for (Prenda  *newConjuntoPrenda in prendasForConjuntoArray) 
        {
            NSInteger categoriaPrenda=[newConjuntoPrenda.categoria.idCategoria intValue];
            
            if (categoriaPrenda==4) {
                x=x1;
                y=y1;
                x1+=offsetCategoria4;
                y1+=offsetCategoria4;
            }
            
            if (categoriaPrenda==1) {
                x=x2;
                y=y2;
                x2+=offsetCategoria1;
                y2+=offsetCategoria1;
            }
            
            if (categoriaPrenda==3) {
                x=x3;
                y=y3;
                x3+=offsetCategoria3;
                y3+=offsetCategoria3;
            }
            
            if (categoriaPrenda==2) {
                x=x4;
                y=y4;
                x4+=offsetCategoria2;
                y4+=offsetCategoria2;
            }
            
            //Genero un nombre para el item, basado en timeIntervalSince1970
            NSString *conjuntoPrendaName= [NSString stringWithFormat:@"%f-%@",[[NSDate date] timeIntervalSince1970],newConjuntoPrenda.idPrenda];
            NSDictionary *conjuntoPrendasDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                       conjuntoPrendaName,@"descripcion", 
                                                       [NSNumber numberWithFloat:scale],@"scale", 
                                                       [NSNumber numberWithFloat:x],@"x", 
                                                       [NSNumber numberWithFloat:y],@"y",
                                                       [NSNumber numberWithFloat:width],@"width", 
                                                       [NSNumber numberWithFloat:height],@"height", 
                                                       conjuntoPrendaName,@"idConjuntoPrendas",
                                                       thisConjunto,@"conjunto",
                                                       newConjuntoPrenda,@"prenda",
                                                       [NSNumber numberWithInteger:orden],@"orden",
                                                       [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] ,@"usuario",
                                                       nil] ;
            
            //Creo nuevo conjuntoPrenda en la base de datos
            //ConjuntoPrendas *tempConjuntoPrenda=  
            [ConjuntoPrendas conjuntoPrendasWithData:conjuntoPrendasDictionary inManagedObjectContext:self.managedObjectContext overwriteObject:NO];
            orden++;
        }       
        //Salvo datos en database
        NSError *errorSave = nil;
        if (![self.managedObjectContext save:&errorSave])
            NSLog(@"Unresolved error %@, %@", errorSave, [errorSave userInfo]);
        
    }
}


-(UIImage*) createThumbnailFromImage:(UIImage*)imageToThumbnail withSize:(NSInteger)thumbnailSize
{
    // Create a thumbnail version of the image for the recipe object.
    CGSize size = imageToThumbnail.size;
    CGFloat ratio = 0;
    if (size.width > size.height) 
        ratio = thumbnailSize / size.width;
    else 
        ratio = thumbnailSize / size.height;
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
    UIGraphicsBeginImageContext(rect.size);
    [imageToThumbnail drawInRect:rect];
    UIImage *thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnailImage;
}



-(void)cancelChoosingConjuntoForCalendar
{
    [self.delegateCalendar cancelChoosingConjuntoForCalendar ];
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

#pragma mark - Change to other VC's

-(void) changeToPrendasVC
{
    [self.delegate changeToVC:1];
}


-(void) changeToConjuntosVC
{
    [self.delegate changeToVC:2];
}


-(void) changeToCalendarVC
{
    
    [self.delegate changeToVC:3];
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
