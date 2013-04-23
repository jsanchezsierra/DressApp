//
//  CalculateMyStyleViewController.m
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


#import "CalculateMyStyleViewController.h"
#import "StyleDressApp.h"
#import "Prenda.h"
#import "PrendaMarca.h"
#import "Marcas.h"
#import "AppDelegate.h"

 
@implementation CalculateMyStyleViewController
@synthesize delegate;
@synthesize managedObjectContext;
@synthesize isRight;
@synthesize containerView,myImageViewBackground;
@synthesize resultTitle,resultMsg1,resultMsg2;
@synthesize myActionViewCompartir,myNavigationViewBackground,resultStyleImage;
@synthesize mainToolbar,btnCompartir;
@synthesize myActionViewActivity;
@synthesize myScrollView;

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

    //Set image background
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"WhatMyProfileCalculateBackground"]];

    [myActionViewActivity stopAnimating];
    [containerView  setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorYourStyleCualEsBackground]];

    //Tint Toolbar
    [self.mainToolbar setTintColor: [ StyleDressApp colorWithStyleForObject:StyleColorMainToolBar] ];
    
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

    //Titulo de Header
    UIFont *myFontTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:26];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,200,32)];
    titleLabel.font=myFontTitle;
    titleLabel.text=NSLocalizedString(@"ConoceTuEstilo", @"");
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor clearColor];
     titleLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorYourStyleCualEsHeader];
    [self.navigationItem setTitleView:titleLabel ];
    
    UIFont *myTitleFont;
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        myTitleFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:24];
    else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        myTitleFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:22];
        
    
    [resultTitle setFont:myTitleFont];
    resultTitle.textColor=[StyleDressApp colorWithStyleForObject:StyleColorYourStyleCualEsTitle];
    
    resultMsg1.textColor=[StyleDressApp colorWithStyleForObject:StyleColorYourStyleCualEsText];
    resultMsg1.font=[UIFont systemFontOfSize:14];

    resultMsg2.textColor=[StyleDressApp colorWithStyleForObject:StyleColorYourStyleCualEsText];
    resultMsg2.font=[UIFont systemFontOfSize:14];
    
    isRight=NO;
 
    [super viewDidLoad];
    [self calculateStyle];
    
}


-(void) calculateStyle
{
    
    isAtleticaCount=0;
    isClasicaCount=0;
    isFashionCount=0;
    isHippieCount=0;
    isVanguardistaCount=0;
    isRomanticaCount=0;
    maximunCount=0;
    maximunIndex=0;

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
    NSInteger numeroDePrendas=[fetchedPrendaObjectsArray count];
    NSInteger numeroDeMarcas=0;
    
    
    for (Prenda *thisPrenda in fetchedPrendaObjectsArray) 
    {

        NSFetchRequest *fetchMarcaRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *marcaEntity = [NSEntityDescription entityForName:@"Marcas"
                                                        inManagedObjectContext:self.managedObjectContext];
        [fetchMarcaRequest setEntity:marcaEntity];
        
         fetchMarcaRequest.predicate = [NSPredicate predicateWithFormat:@"(idMarca == %@)  ",thisPrenda.marca.idMarca ];
                
        NSError *marcaError = nil;
        NSArray *fetchedMarcaArray = [self.managedObjectContext executeFetchRequest:fetchMarcaRequest error:&marcaError];

        Marcas *thisMarca=[fetchedMarcaArray lastObject];

        if (thisMarca.idMarca!=nil && ![thisMarca.idMarca isEqualToString:@"0"])
            numeroDeMarcas++;

        if ([thisMarca.isAtletica intValue]==1)
        {
            isAtleticaCount++;
            [self updateMaximunWithIndex:1];
        }
        if ([thisMarca.isClasica intValue]==1)
        {
            isClasicaCount++;
            [self updateMaximunWithIndex:2];
        }
        if ([thisMarca.isFashion intValue]==1)
        {
            isFashionCount++;
            [self updateMaximunWithIndex:3];
        }
        if ([thisMarca.isHippie intValue]==1)
        {
            isHippieCount++;
            [self updateMaximunWithIndex:4];
        }
        if ([thisMarca.isVanguardista intValue]==1)
        {
            isVanguardistaCount++;
            [self updateMaximunWithIndex:5];
        }
        if ([thisMarca.isRomantica intValue]==1)
        {    
            isRomanticaCount++;        
            [self updateMaximunWithIndex:6];
        }
    }

    NSInteger index= 100 * numeroDeMarcas/numeroDePrendas;
    NSInteger yOffset=0;
    
    if (maximunIndex==0) yOffset=-100-35;
    if (maximunIndex==1) yOffset=-30-50;
    if (maximunIndex==2) yOffset=-30-50;
    if (maximunIndex==3) yOffset=-10-50;
    if (maximunIndex==4) yOffset=10-50;
    if (maximunIndex==5) yOffset=-25-50;
    if (maximunIndex==6) yOffset=-10-50;

    
    if ( index< 15 || maximunIndex==0) 
    {
        [btnCompartir setHidden:YES];
        [mainToolbar setHidden:YES];
        [resultMsg2 setFrame:CGRectMake(15, 580+yOffset, 290, 60)];

        resultTitle.text=NSLocalizedString(@"minimunMarcasForCalculatingStyleTitle",@"");
        resultMsg1.text=[NSString stringWithFormat:@"%@ %d%@ %@",NSLocalizedString(@"minimunMarcasForCalculatingStyleMsg1",@""),index,@"%",NSLocalizedString(@"minimunMarcasForCalculatingStyleMsg2",@"") ];

        resultMsg2.text=[NSString stringWithFormat:@"%@",NSLocalizedString(@"minimunMarcasForCalculatingStyleMsg3",@"") ];
        
        [resultStyleImage setImage:[StyleDressApp imageWithStyleNamed:@"STYSoyStyle00" ]];
        

    }else
    {
        [btnCompartir setHidden:NO];
        [mainToolbar setHidden:NO];
        [resultMsg2 setFrame:CGRectMake(15, 590+yOffset, 290, 60)];

        NSString *resultTitleString =[NSString stringWithFormat:@"estiloTitulo%02d",maximunIndex];
        NSString *resultMsgString1 =[NSString stringWithFormat:@"estiloMsgIni%02d",maximunIndex];
        NSString *resultMsgString2 =[NSString stringWithFormat:@"estiloMsgEnd%02d",maximunIndex];
        NSString *resultImageString =[NSString stringWithFormat:@"STYSoyStyle%02d",maximunIndex];

        resultMsg2.text=NSLocalizedString(resultMsgString2, @"");
        resultMsg1.text=NSLocalizedString(resultMsgString1, @"");
        resultTitle.text=NSLocalizedString(resultTitleString, @"");
        
        [resultStyleImage setImage:[StyleDressApp imageWithStyleNamed:resultImageString ]];
     
    }


    [myScrollView setContentSize:CGSizeMake(320, 660+yOffset+45)];

    
}


-(void) updateMaximunWithIndex:(NSInteger)index
{
    NSInteger comparisonValue=0;
    if (index==1) comparisonValue=isAtleticaCount;
    if (index==2) comparisonValue=isClasicaCount;
    if (index==3) comparisonValue=isFashionCount;
    if (index==4) comparisonValue=isHippieCount;
    if (index==5) comparisonValue=isVanguardistaCount;
    if (index==6) comparisonValue=isRomanticaCount;

    if (comparisonValue>maximunCount)
    {
        maximunCount=comparisonValue;
        maximunIndex=index;
    }

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


#pragma mark - POST Style To Facebook

-(void) sendStyleToFacebook
{
  
    
}


 

#pragma mark - POST Style to Twitter

-(void) sendStyleToTwitter
{
    [myActionViewActivity startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    ShareFacebookTwitter *myVC = [[ShareFacebookTwitter alloc] initWithNibName:@"ShareFacebookTwitter" bundle:nil];
    myVC.delegate=self;
    
    
    NSMutableString *twitterMsg= [[NSMutableString alloc] init];
    NSString *yourTwitterStyle =[NSString stringWithFormat:@"twitterYourStyle%d",maximunIndex];
     
    [twitterMsg appendString:NSLocalizedString(@"twitterYourStyleTitle1", @"")];
    [twitterMsg appendString:NSLocalizedString(yourTwitterStyle, @"")];
    [twitterMsg appendString:NSLocalizedString(@"twitterYourStyleTitle2", @"")];

    
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


#pragma mark - POST to Email

-(void) sendStyleToEmail
{
    if ([MFMailComposeViewController canSendMail]) 
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:NSLocalizedString(@"emailEstiloSubject", @"") ];
        NSMutableString *emailBody= [[NSMutableString alloc] init];
        
        NSData *imageData = UIImagePNGRepresentation([resultStyleImage image ] );

        [emailBody appendString:NSLocalizedString(@"emailEstiloParagraph1", @"")];
        [emailBody appendString:[NSString stringWithFormat:@"<p> <b>%@ </b> </p>",resultTitle.text]];
        [emailBody appendString:[NSString stringWithFormat:@"<p> <i>%@ </i> </p>",resultMsg1.text]];
        [emailBody appendString:[NSString stringWithFormat:@"<p> <i>%@ </i> </p>",resultMsg2.text]];
        
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


#pragma mark - sendEmail delegates
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
    [self.view setUserInteractionEnabled:YES];
	[self dismissModalViewControllerAnimated:YES];
    
    if (result==MFMailComposeResultSent)
    {
        UIAlertView *alertViewSendEmail = [[UIAlertView alloc] initWithTitle:
                                           NSLocalizedString(@"SendEstiloEmailOKTittle", @"")
                                                                     message:NSLocalizedString(@"SendEstiloEmailOKMsg", @"")                                                           delegate:self
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

