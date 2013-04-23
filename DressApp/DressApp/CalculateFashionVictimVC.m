//
//  CalculateFashionVictimVC.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 5/21/12.
//  Copyright (c) 2012 Javier Sanchez Sierra. All rights reserved.
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


#import "CalculateFashionVictimVC.h"
#import "StyleDressApp.h"
#import "Prenda.h"
#import "PrendaMarca.h"
#import "Marcas.h"
#import "AppDelegate.h"

@implementation CalculateFashionVictimVC
@synthesize delegate;
@synthesize managedObjectContext;
@synthesize isRight;
@synthesize containerView,myImageViewBackground;
@synthesize resultTitle,resultMsg;
@synthesize myActionViewCompartir,myNavigationViewBackground;
@synthesize resultFashionImage;
@synthesize mainToolbar,btnCompartir;
@synthesize myActionViewActivity,myScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{    
 
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"WhatMyProfileFashionBackground"]];
    [containerView  setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorYourStyleFashionBackground]];

    
    //Header Title
    UIFont *myHeaderFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:21];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,210,32)];
    titleLabel.font=myHeaderFont;
    titleLabel.text=NSLocalizedString(@"ConoceFashionVictim", @"");
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorYourStyleFashionHeader];
    [self.navigationItem setTitleView:titleLabel ];
    
    //Tint Toolbar
    [self.mainToolbar setTintColor: [ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];
    
    //BtnCompartir
    UILabel *btnCompartirLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 33)];
    [btnCompartirLabel setText:NSLocalizedString(@"ConjuntoCompartir",@"")];
    [btnCompartirLabel setBackgroundColor:[UIColor clearColor]];
    [btnCompartirLabel setTextAlignment:UITextAlignmentCenter];
    [btnCompartirLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:12]];
    [self.btnCompartir addSubview:btnCompartirLabel];
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        
        [btnCompartirLabel setText:NSLocalizedString(@"ConjuntoCompartir",@"")];
        [self.btnCompartir setImage:[StyleDressApp imageWithStyleNamed:@"CODetailBtnOFF" ] forState:UIControlStateNormal]; 
        [self.btnCompartir setImage:[StyleDressApp imageWithStyleNamed:@"CODetailBtnON" ] forState:UIControlStateHighlighted]; 
        
    }else  if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        [btnCompartirLabel setText:@""];
        [self.btnCompartir setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailBtnShareOFF" ] forState:UIControlStateNormal]; 
        [self.btnCompartir setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailBtnShareON" ] forState:UIControlStateHighlighted]; 
    }

    UIFont *myTitleFont;
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        myTitleFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:24];
    else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        myTitleFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:22];
    
    [resultTitle setFont:myTitleFont];
    resultTitle.textColor=[StyleDressApp colorWithStyleForObject:StyleColorYourStyleFashionTitle];

    resultMsg.textColor=[StyleDressApp colorWithStyleForObject:StyleColorYourStyleFashionText];
    resultMsg.font=[UIFont systemFontOfSize:14];
    isRight=NO;
 
    [self calculateFashionVictim];
    [super viewDidLoad];
}


-(void) calculateFashionVictim
{
 
    //FetchRequest Prendas 
    NSFetchRequest *fetchPrendaRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *prendaEntity = [NSEntityDescription entityForName:@"Prenda"
                                                    inManagedObjectContext:self.managedObjectContext];
    [fetchPrendaRequest setEntity:prendaEntity];

    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        fetchPrendaRequest.predicate = [NSPredicate predicateWithFormat:@"(usuario == %@) ",[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
    
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        fetchPrendaRequest.predicate = [NSPredicate predicateWithFormat:@"((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )  ) ",[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
    
    NSError *prendaError = nil;
    NSArray *fetchedPrendaObjectsArray = [self.managedObjectContext executeFetchRequest:fetchPrendaRequest error:&prendaError];
    numeroDePrendas=[fetchedPrendaObjectsArray count];
    
    //Calculo el coste total de las prendas
    valorDelArmario=0;
    for (Prenda *thisPrenda in fetchedPrendaObjectsArray) 
        valorDelArmario+=[thisPrenda.precio intValue];
     
    //FetchRequest Conjuntos 
    NSFetchRequest *fetchConjuntoRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *thisConjuntoEntity = [NSEntityDescription entityForName:@"Conjunto"
                                                    inManagedObjectContext:self.managedObjectContext];
    [fetchConjuntoRequest setEntity:thisConjuntoEntity];
    
    if ( [ [ [NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck" ] isEqualToString:@"LOGGEDUSER_ONLY"]) 
        fetchConjuntoRequest.predicate = [NSPredicate predicateWithFormat:@"(usuario == %@) ",[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ]];
    
    else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToCheck"] isEqualToString:@"LOGGEDUSER_AND_DEFAULT"]) 
        fetchConjuntoRequest.predicate = [NSPredicate predicateWithFormat:@"((usuario == %@) OR (usuario == %@) OR (usuario == %@)  )  ) ",[[NSUserDefaults standardUserDefaults] objectForKey:@"username" ],DRESSAPP_DEFAULT_USER,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
    
    NSError *conjuntoError = nil;
    NSArray *fetchedConjuntoObjectsArray = [self.managedObjectContext executeFetchRequest:fetchConjuntoRequest error:&conjuntoError];
    numeroDeConjuntos=[fetchedConjuntoObjectsArray count];
 

    if ( (numeroDePrendas>20 && numeroDeConjuntos>8) || valorDelArmario>2000 )  //SI fashion Victim
    {
        fashionVictimType=fashionVictimTypeYES;
        [btnCompartir setHidden:NO];
        [mainToolbar setHidden:NO];
        resultTitle.text=NSLocalizedString(@"fashionVictimYESTitle", @"");
        resultMsg.text=NSLocalizedString(@"fashionVictimYES", @"");
        [resultFashionImage setImage:[StyleDressApp imageWithStyleNamed:@"STYFashionYes"]];
        [myScrollView setContentSize:CGSizeMake(320, 610)];

    }
    else if (numeroDePrendas<10 && valorDelArmario==0 ) //No tienes datos suficientes
    {
        fashionVictimType=fashionVictimTypeNoData;
        [btnCompartir setHidden:YES];
        [mainToolbar setHidden:YES];
        resultTitle.text=NSLocalizedString(@"fashionVictimNODATATitle", @"");
        resultMsg.text=NSLocalizedString(@"fashionVictimNODATA", @"");
        //[resultMsg setFrame:CGRectMake(10, 250, 300, 300)];
        [resultFashionImage setImage:[StyleDressApp imageWithStyleNamed:@"STYSoyStyle00"]];
        //[resultFashionImage setFrame:CGRectMake(10, 255-40, 300, 300)];
        [myScrollView setContentSize:CGSizeMake(320, 490)];
        
    }else  //No fashion Victim
    {
        fashionVictimType=fashionVictimTypeNO;
        [btnCompartir setHidden:NO];
        [mainToolbar setHidden:NO];
        resultTitle.text=NSLocalizedString(@"fashionVictimNOTitle", @"");
        resultMsg.text=NSLocalizedString(@"fashionVictimNO", @"");
        [resultFashionImage setImage:[StyleDressApp imageWithStyleNamed:@"STYFashionNo"]];
        //[resultFashionImage setFrame:CGRectMake(10, 230, 300, 300)];
        [myScrollView setContentSize:CGSizeMake(320, 590)];

    }
    [resultMsg flashScrollIndicators];
    [myScrollView setContentOffset:CGPointMake(0, 0)];
}

-(IBAction)btnPressed:(UIButton*)sender
{
    [self openActionSheet];
}



#pragma mark - UIActionSheet Compartir View
- (void)openActionSheet
{
    
    //Cancel userInteraction
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    
    //Open ActionView
    self.myActionViewCompartir = [[UIActionView alloc] initWithFrame:CGRectMake(0,480,320,416)];
    [self.myActionViewCompartir setMyFontSize:20];
    [self.myActionViewCompartir setDelegate:self];
    [self.myActionViewCompartir setButtonsTextArray:[NSMutableArray arrayWithObjects:  NSLocalizedString(@"facebook", @""), NSLocalizedString(@"twitter", @""),NSLocalizedString(@"email", @""), NSLocalizedString(@"cancelar", @""),  nil]];
    [self.myActionViewCompartir setSelectedIndex:3];
    [self.myActionViewCompartir setActionViewTitle: NSLocalizedString(@"actionViewConjuntoTitle", @"")];
    [self.myActionViewCompartir initView];
    [self.view addSubview:myActionViewCompartir];
    
    //Add background view - opaque view para que el fondo quede oscuro al abrir el actionView
    myNavigationViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -44,320,44)];
    [myNavigationViewBackground setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:myNavigationViewBackground];
    
}


-(void) actionView:(UIActionView *)actionView changeAlpha:(CGFloat)newAlpha toState:(MainViewState)newState
{
    //[scrollView setAlpha:newAlpha];
    if (newState==MainViewStateBegin) 
        [self.navigationController.navigationBar setAlpha:newAlpha];
    else if (newState==MainViewStateEnd) 
        [self.navigationController.navigationBar  setAlpha:1.0];
    
}


#pragma mark - actionView delegate methods

-(void) actionView:(UIActionView *)actionView didSelectIndex:(NSInteger)actionIndex
{
    
    //Remove views from superview
    [actionView removeFromSuperview];
    [self.myNavigationViewBackground removeFromSuperview];
    
    //User interaction enabled
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    
    if (actionView==myActionViewCompartir) //Do album, facebook, etc,etc
    {
        if(actionIndex==0)  //Facebook
            [self sendStyleToFacebook];  //using authorization dialog
        else if(actionIndex==1)  //Twitter
            [self sendStyleToTwitter];
         else if(actionIndex==2)  //Email
            [self sendStyleToEmail];
        
    }
    
}


#pragma mark - POST Style to Twitter

-(void) sendStyleToTwitter
{
    [myActionViewActivity startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    ShareFacebookTwitter *myVC = [[ShareFacebookTwitter alloc] initWithNibName:@"ShareFacebookTwitter" bundle:nil];
    myVC.delegate=self;
    
    NSMutableString *twitterMsg= [[NSMutableString alloc] init];
    NSString *yourTwitterFashionVictim;// =[NSString stringWithFormat:@"twitterFashionVictimResult%d",maximunIndex];
    
    if (fashionVictimType==fashionVictimTypeYES) yourTwitterFashionVictim=@"twitterFashionVictimResult1";
    if (fashionVictimType==fashionVictimTypeNO) yourTwitterFashionVictim=@"twitterFashionVictimResult2";
    [twitterMsg appendString:NSLocalizedString(@"twitterFashionVictimTitle1", @"")];
    [twitterMsg appendString:NSLocalizedString(yourTwitterFashionVictim, @"")];
    [twitterMsg appendString:NSLocalizedString(@"twitterFashionVictimTitle2", @"")];
    
    
    NSString *webURL=[ NSString stringWithFormat: @"https://mobile.twitter.com/home?status=%@",[self getUrlEncoded:twitterMsg]  ];
    
    myVC.webUrl=webURL;
    [myVC.view setBackgroundColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];
    [myVC.myWebView setBackgroundColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];
    
    [self presentModalViewController:myVC animated:YES];
    
}

-(NSString *) getUrlEncoded:(NSString*)inputString
{
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    NULL,
                                                                    (__bridge CFStringRef)inputString,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                    kCFStringEncodingUTF8 );
    return (__bridge NSString *)urlString ;
}


-(void) dismissShareFacebookTwitterWebView
{
    [myActionViewActivity stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}




#pragma mark - POST Style To Facebook

-(void) sendStyleToFacebook
{
    
       
}


 
#pragma mark - POST TO Email

-(void) sendStyleToEmail
{
    
    if ([MFMailComposeViewController canSendMail]) 
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:NSLocalizedString(@"emailFashionSubject", @"") ];
        NSMutableString *emailBody= [[NSMutableString alloc] init];

        NSData *imageData = UIImagePNGRepresentation([resultFashionImage image ] );

        [emailBody appendString:NSLocalizedString(@"emailFashionParagraph1", @"")];
        [emailBody appendString:[NSString stringWithFormat:@"<p> <b>%@ </b> </p>",resultTitle.text]];
        [emailBody appendString:[NSString stringWithFormat:@"<p> <i>%@ </i> </p>",resultMsg.text]];
        
        
        [emailBody appendString:[NSMutableString stringWithFormat:@" <a href = '%@'> %@ </a>",DRESSAPP_ITUNESLINK,NSLocalizedString(@"emailBodyPrenda2", @"")]]; 

        [emailBody appendString:[NSMutableString stringWithFormat:@"<p> <a href = '%@'> %@ </a></p>",DRESSAPP_GOOGLEPLAY,NSLocalizedString(@"emailBodyPrenda3", @"")]]; 

        [picker setMessageBody:emailBody isHTML:YES];
        [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"DressAppFashionVictim"];

        [self presentModalViewController:picker animated:YES];
        
    }
    else
    {
        UIAlertView *emailNotExistAlert=[[ UIAlertView alloc] initWithTitle:NSLocalizedString(@"emailNotExistTitle", "") message:NSLocalizedString(@"emailNotExistMsg", "") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", "") otherButtonTitles:nil  , nil];
        [emailNotExistAlert show];
    }


    
    
}


#pragma mark -  sendEmail delegates
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
    
    [self.view setUserInteractionEnabled:YES];
	[self dismissModalViewControllerAnimated:YES];
    
    if (result==MFMailComposeResultSent)
    {
        UIAlertView *alertViewSendEmail = [[UIAlertView alloc] initWithTitle:
                                           NSLocalizedString(@"SendFashionEmailOKTittle", @"")
                                                                     message:NSLocalizedString(@"SendFashionEmailOKMsg", @"")                                                           delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
        [alertViewSendEmail show];
    }
    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


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




@end
