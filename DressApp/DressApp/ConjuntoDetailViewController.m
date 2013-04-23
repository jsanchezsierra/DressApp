//
//  ConjuntoDetailViewController.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 11/1/11.
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


#import "ConjuntoDetailViewController.h"
#import "Prenda.h"
#import "ConjuntoPrendas.h"
#import "ConjuntoPrendaView.h"
#import "PrendasViewController.h"
#import "ConjuntoDetailSetCategoriaVC.h"
#import "ConjuntoDetailNotes.h"
#import "StyleDressApp.h"

@implementation ConjuntoDetailViewController
@synthesize managedObjectContext,delegate,conjunto;
@synthesize drawingView;
@synthesize categoria;
@synthesize currentConjuntoPage;
@synthesize isSaveNeededForDetail;
@synthesize drawingViewControls;
@synthesize currentSelectedConjuntoPrendaView;
@synthesize myActionViewMoveToTrash;
@synthesize myNavigationViewBackground;
@synthesize imageViewSlider,imageViewSliderFinger;
 
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withConjunto:(Conjunto*)tempConjunto andPage:(NSInteger)page
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentConjuntoPage=page;
        self.conjunto=tempConjunto;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}    

#pragma mark - View lifecycle

 
-(void) saveDataBeforeClosing
{
   //Salvar solo si se ha modificado algun dato
    if (isSaveNeededForDetail==YES) 
    {
        NSError *errorSave = nil;
        if (![self.managedObjectContext save:&errorSave])
            NSLog(@"Unresolved error %@, %@", errorSave, [errorSave userInfo]);
        
        [self.drawingView setBackgroundColor:[UIColor clearColor]];
        [self deselectConjuntoPrendaViewsExceptThis:nil];
        [self saveImageThumbnail];
    }
  
}

 - (void)viewDidLoad
{
 
    self.view.layer.masksToBounds=YES;
    
    //Prepare file manager && cachesDirectory
    cachesDirectory= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    fileManager = [NSFileManager defaultManager];
    
    //set title
    [self.navigationItem setTitle:NSLocalizedString(@"Conjunto", @"")];
      
    [self.view  setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCODetailBackground]];

    [self.drawingView  setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCODetailBackground]];

    //Set drawing View Size
    [self.drawingView setFrame:CGRectMake(0,0,320,460)];
    [self addConjuntoViews]; 
    [self saveDataBeforeClosing];
    
    
    [imageViewSlider setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorCODetailBackground]];
    [imageViewSliderFinger setImage:[StyleDressApp imageWithStyleNamed:@"GESliderFinger"]];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"showConjuntosSlider"] isEqualToString:@"YES"]) 
    {
        [self.view setUserInteractionEnabled:NO];
        [imageViewSlider setAlpha:0.75];
        [imageViewSliderFinger setAlpha:0.75];
        [imageViewSlider setHidden:NO];
        [imageViewSliderFinger setHidden:NO];
        [UIView beginAnimations:@"FingerFadeOut" context:nil];
        [UIView setAnimationDelay:2.0];
        [UIView setAnimationDuration:1.25];
        [imageViewSlider setAlpha:0.0];
        [imageViewSliderFinger setAlpha:0.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationViewFinished:finished:context:)];
        [UIView commitAnimations];
        
    } else
    {
        [self.view setUserInteractionEnabled:YES];
        [imageViewSlider setHidden:YES];
        [imageViewSliderFinger setHidden:YES];
        
    }
    [super viewDidLoad];
    
}


- (void)animationViewFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    if ([animationID isEqualToString:@"FingerFadeOut"]) 
    {
        [self.view setUserInteractionEnabled:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"showConjuntosSlider"];
        [imageViewSlider setHidden:YES];
        [imageViewSliderFinger setHidden:YES];
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


-(void) addConjuntoViews
{
    //GET ConjuntosPrendas Array of a given Conjunto
    NSFetchRequest *fetchRequestConjuntoPrendas = [[NSFetchRequest alloc] init];
	[fetchRequestConjuntoPrendas setEntity:[NSEntityDescription entityForName:@"ConjuntoPrendas" inManagedObjectContext:self.managedObjectContext]];
    
    
    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        fetchRequestConjuntoPrendas.predicate =[NSPredicate predicateWithFormat:@"(conjunto == %@) AND (usuario==%@)",conjunto,[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        fetchRequestConjuntoPrendas.predicate =[NSPredicate predicateWithFormat:@"(conjunto == %@) AND ((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )",conjunto,[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ], DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orden" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequestConjuntoPrendas setSortDescriptors:sortDescriptors];
	NSError *errorConjuntoPrenda = nil;
	NSMutableArray *conjuntoPrendasArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequestConjuntoPrendas error:&errorConjuntoPrenda]];

    int i;
    //Remove previous subviews
    NSInteger numberOfSubviews=[self.drawingView.subviews count];
    for (i=0; i<numberOfSubviews;i++  ) 
    {
        UIView *theView= [self.drawingView.subviews objectAtIndex:0];
        [theView removeFromSuperview];
    }

    //Add subviews to drawingView
    for (ConjuntoPrendas *conjuntoPrenda  in conjuntoPrendasArray) 
    {
        ConjuntoPrendaView *myPrendaView = [ [ConjuntoPrendaView alloc] initWithFrame:CGRectMake([conjuntoPrenda.x intValue] , [conjuntoPrenda.y intValue],[conjuntoPrenda.width intValue],[conjuntoPrenda.height intValue]) ];
        
        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",conjuntoPrenda.prenda.urlPicture] ]; 
        if ( [fileManager fileExistsAtPath:imagePath] ) 
            [[myPrendaView prendaImageView] setImage: [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]] ];  

        [myPrendaView setConjuntoPrenda:conjuntoPrenda];
        [myPrendaView setDelegate:self];
        [myPrendaView setEscala:[conjuntoPrenda.scale floatValue ]];
        [myPrendaView setConjuntoPrenda:conjuntoPrenda];
        [self.drawingView addSubview:myPrendaView];
    }
    
    
    imageViewRemoveControl = [ [UIImageView alloc] initWithFrame:CGRectMake(10,10,28,28)];
    [imageViewRemoveControl setImage:[StyleDressApp imageWithStyleNamed:@"CODetailPrendaSelectedRemove"]]; 
    [imageViewRemoveControl setContentMode:UIViewContentModeScaleAspectFit];
    [imageViewRemoveControl setHidden:YES];
    [self.drawingViewControls addSubview:imageViewRemoveControl];
    
    imageViewMoveControl = [ [UIImageView alloc] initWithFrame:CGRectMake(50,50,28,28)];
    [imageViewMoveControl setImage:[StyleDressApp imageWithStyleNamed:@"CODetailPrendaSelectedMove"]];
    [imageViewMoveControl setContentMode:UIViewContentModeScaleAspectFit];
    [imageViewMoveControl setHidden:YES];
    [self.drawingViewControls addSubview:imageViewMoveControl];
    
    imageViewScaleControl = [ [UIImageView alloc] initWithFrame:CGRectMake(100,100,28,28)];
    [imageViewScaleControl setImage:[StyleDressApp imageWithStyleNamed:@"CODetailPrendaSelectedScale"]];
    [imageViewScaleControl setContentMode:UIViewContentModeScaleAspectFit];
    [imageViewScaleControl setHidden:YES];
    [self.drawingViewControls addSubview:imageViewScaleControl];

    if ([conjuntoPrendasArray count]<=0) 
        [self.delegate moveToTrash:nil];
        
}
  

-(void) updateConjuntoPrendaViewControlPositionFromView:(ConjuntoPrendaView*)selectedConjuntoPrendaView setHidden:(BOOL)hiddenMode
{
    [imageViewRemoveControl setHidden:hiddenMode];
    [imageViewMoveControl setHidden:hiddenMode];
    [imageViewScaleControl setHidden:hiddenMode];

    CGFloat x= selectedConjuntoPrendaView.frame.origin.x;
    CGFloat y=selectedConjuntoPrendaView.frame.origin.y;
    CGFloat w=selectedConjuntoPrendaView.frame.size.width;
    CGFloat h=selectedConjuntoPrendaView.frame.size.height;
    
    //Posiciono los controles
    [imageViewRemoveControl setFrame:CGRectMake(x-14,y-14, 28,28)];
    [imageViewMoveControl setFrame:CGRectMake(x+w/2 -14, y+h/2 -14, 28,28)];
    [imageViewScaleControl setFrame:CGRectMake(x+w-14,y+h-14, 28,28)];
     
    conjunto.needsSynchronize=[NSNumber numberWithBool:YES];
    conjunto.needsSynchronizeImage =[NSNumber numberWithBool:YES];

    if ([conjunto.calendarConjunto count]>0) 
        [self.delegate activateCalendarViewFlag];
    
}


#pragma mark - ConjuntoPrendaView delegate methods 

-(void) ConjuntoPrendaViewDelegate:(ConjuntoPrendaView *)conjuntoPrendaView didChangePrendaToPositionX:(NSInteger)positionX positionY:(NSInteger)positionY imageWidth:(NSInteger)width imageHeight:(NSInteger)height
{
    conjuntoPrendaView.conjuntoPrenda.x=[NSNumber numberWithInt:positionX];
    conjuntoPrendaView.conjuntoPrenda.y=[NSNumber numberWithInt:positionY];
    conjuntoPrendaView.conjuntoPrenda.width=[NSNumber numberWithInt:width];
    conjuntoPrendaView.conjuntoPrenda.height=[NSNumber numberWithInt:height];
    
    isSaveNeededForDetail=YES;
}

-(void) enableScroll:(BOOL)scrollEnabled 
{
    [self.delegate enableScrollInContainerView:scrollEnabled]; 
}


-(void) deselectConjuntoPrendaViewsExceptThis:(ConjuntoPrendaView *)selectedConjuntoPrendaView
{
    self.currentSelectedConjuntoPrendaView=selectedConjuntoPrendaView;
    
    //deselect prendas que no he seleccionado
    for (id mySubview in self.drawingView.subviews)
    {
        //En drawingView tengo vistas de tipo "ConjuntoPrendaView" y otras tipo "UIImageView"
        if ( [mySubview isKindOfClass: [ConjuntoPrendaView class]]) 
        {
            ConjuntoPrendaView *myPrenda=(ConjuntoPrendaView*)mySubview;
            if ( myPrenda!=selectedConjuntoPrendaView)
            {
                [myPrenda deselectConjuntoPrenda];
                myPrenda.isWaitingForDisappear=NO; //Para la cuenta atras del resto de prendas de drawingView
            }
        }
    }
    
    if (selectedConjuntoPrendaView!=nil) 
    {
        //Bring selected SubView to Front
        [self.drawingView bringSubviewToFront:selectedConjuntoPrendaView];
        
        //Reasigno valor de ORDER para los items de la base de datos
        for (int i=0; i<[self.drawingView.subviews count]; i++  ) 
        {
            ConjuntoPrendaView *theView= [self.drawingView.subviews objectAtIndex:i];
            theView.conjuntoPrenda.orden= [NSNumber numberWithInteger: i];
        }
        
        NSError *errorSave = nil;
        if (![self.managedObjectContext save:&errorSave])
            NSLog(@"Unresolved error %@, %@", errorSave, [errorSave userInfo]);
    }

}

-(void) removePrendaFromConjunto:(ConjuntoPrendas *)conjuntoPrenda withView:(ConjuntoPrendaView*)myView
{

    conjuntoPrendaToRemove=conjuntoPrenda;
    conjuntoPrendaViewToRemove=myView;
    [self.delegate moveConjuntoPrendaToTrash];
}

-(void) removePrendaFromContainerView
{
    
    //Esconde los controles de la prenda (escale, move, remove)
    [imageViewRemoveControl setHidden:YES];
    [imageViewMoveControl setHidden:YES];
    [imageViewScaleControl setHidden:YES];

    //Borro entrada de tabla ConjuntoPrendas en la base de datos
    [self.managedObjectContext deleteObject:conjuntoPrendaToRemove ];
    
    conjunto.needsSynchronize=[NSNumber numberWithBool:YES];
    conjunto.needsSynchronizeImage=[NSNumber numberWithBool:YES];

    // Save the context. 
    NSError *error;
    if (![self.managedObjectContext save:&error]) 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    isSaveNeededForDetail=YES;
        
    //Redibujo vistas
    [self addConjuntoViews];
    [self enableScroll:YES];
    
    //Lo salvo ahora, ya que puede pasar que borre algo y no dé al botón de volver
    [self saveDataBeforeClosing];

}

-(void) doNotRemovePrendaFromContainerView
{
    
    [conjuntoPrendaViewToRemove setPrendaDeleted:NO];
    [conjuntoPrendaViewToRemove setIsWaitingForDisappear:YES];

}

 
 

#pragma mark - saveThumbnailImage 

-(void) saveImageThumbnail
{

    UIGraphicsBeginImageContext(self.drawingView.bounds.size);
    [self.drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",conjunto.urlPicture] ]; 
    UIImage *thumbnailImage=[self createThumbnailFromImage:viewImage withSize:PIC_CONJUNTO];
    NSData *data = [[NSData alloc] initWithData: UIImagePNGRepresentation(thumbnailImage) ];

    NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",conjunto.urlPicture] ]; 
    UIImage *thumbnailImageSmall=[self createThumbnailFromImage:viewImage withSize:PIC_CONJUNTO_SMALL];
    NSData *dataSmall = [[NSData alloc] initWithData: UIImagePNGRepresentation(thumbnailImageSmall) ];

    [data writeToFile:imagePath atomically:YES];    
    [dataSmall writeToFile:imagePathSmall atomically:YES];    

    [self.delegate updateConjuntoDetailContainerView];
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


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint firstLocation;
    if (  [touches count] > 0) {
        for (UITouch *touch in touches) 
        {
            firstLocation = [touch locationInView: self.drawingView];
            if (self.currentSelectedConjuntoPrendaView!=nil) 
                [self.currentSelectedConjuntoPrendaView touchesBegan:touches withEvent:event ];
        }
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
            
{
    CGPoint firstLocation;
    if (  [touches count] > 0) {
        for (UITouch *touch in touches) 
        {
            firstLocation = [touch locationInView: self.drawingView];
            if (self.currentSelectedConjuntoPrendaView!=nil) 
                [self.currentSelectedConjuntoPrendaView touchesMoved:touches withEvent:event ];
            
        }
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint firstLocation;
    if (  [touches count] > 0) {
        for (UITouch *touch in touches) 
        {
            firstLocation = [touch locationInView: self.drawingView];
            if (self.currentSelectedConjuntoPrendaView!=nil) 
                [self.currentSelectedConjuntoPrendaView touchesCancelled:touches withEvent:event ];
        }
    }

}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint firstLocation;
    if (  [touches count] > 0) {
        for (UITouch *touch in touches) 
        {
            firstLocation = [touch locationInView: self.drawingView];
            if (self.currentSelectedConjuntoPrendaView!=nil) 
                [self.currentSelectedConjuntoPrendaView touchesEnded:touches withEvent:event ];
        }
    }

}

@end
