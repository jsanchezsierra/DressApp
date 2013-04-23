//
//  YourStyleViewController.m
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


#import "YourStyleViewController.h"
#import "StyleDressApp.h"
#import "Prenda.h"
#import "PrendaMarca.h"
#import "Marcas.h"

@implementation YourStyleViewController
@synthesize delegate;
@synthesize managedObjectContext;
@synthesize isRight,mainMenuButton;
@synthesize containerView,myImageViewBackground;
@synthesize leftLineView;
@synthesize analysingFrame;
@synthesize labelFashionVictim,labelMyStyle;
@synthesize myNavigationViewBackground;
@synthesize yourStyleVC,fashionVictimVC;
@synthesize btnMyStyle,btnFashionVictim;

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
    
    
    [self.containerView setAlpha:1];
    [self.containerView setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setAlpha:1];

    [analysingFrame setHidden:YES];

    [leftLineView setHidden:YES];
    
    //Set image background
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"WhatMyProfileBackground"]];

    [btnMyStyle setImage:[StyleDressApp imageWithStyleNamed:@"STYLEFrame1"] forState:UIControlStateNormal];
    [btnFashionVictim setImage:[StyleDressApp imageWithStyleNamed:@"STYLEFrame2"] forState:UIControlStateNormal];
    
    
    UIFont *myFontTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:26];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,250,32)];
    titleLabel.font=myFontTitle;
    titleLabel.text=NSLocalizedString(@"tuEstilo", @"");
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorYourStyleHeader];
    [self.navigationItem setTitleView:titleLabel ];
    
    isRight=NO;
    
    self.mainMenuButton= [[UIBarButtonItem alloc] init];
    [self.mainMenuButton setImage:[StyleDressApp imageWithStyleNamed:@"GEBtnMainMenu" ] ];
    [self.mainMenuButton setTarget:self];
    [self.mainMenuButton setStyle:UIBarButtonItemStyleBordered];
    [self.mainMenuButton setAction:@selector(popMainMenuViewController)];
    self.navigationItem.leftBarButtonItem = self.mainMenuButton; 

    
    
    UIFont *labelsFont;
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        labelsFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:20];

        [labelMyStyle setFrame:CGRectMake(0,32+8,320,25)];
        [labelFashionVictim setFrame:CGRectMake(0,226+8, 320,25)];
        
    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        labelsFont= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:18];

        [labelMyStyle setFrame:CGRectMake(0,32+15-5,320,25)];
        [labelFashionVictim setFrame:CGRectMake(0,226+15-5, 320,25)];
        
    }    
    
    //Añado texto a las labels
    [labelMyStyle setText:NSLocalizedString(@"ConoceTuEstilo",@"")];
    labelMyStyle.font=labelsFont;
    labelMyStyle.textColor=[StyleDressApp colorWithStyleForObject:StyleColorYourStyleBtnTitle];
    
    [labelFashionVictim setText:NSLocalizedString(@"ConoceFashionVictim",@"")];
    labelFashionVictim.font=labelsFont;
    labelFashionVictim.textColor=[StyleDressApp colorWithStyleForObject:StyleColorYourStyleBtnTitle];

    //Add background view - opaque view para que el fondo quede oscuro al abrir el actionView
    myNavigationViewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -44,320,44)];
    [myNavigationViewBackground setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:myNavigationViewBackground];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(IBAction) calculateStyle
{
    [self calculate:CalculatingStyle];
}
-(IBAction) calculateFashionVictim
{
    [self calculate:CalculatingFashionVictim];
    
}

-(void) calculate:(CalculatingType)calType
{
    
    calculationType=calType;
    
    imageID=0;
    animationRepetitions=0;
    
    [self.containerView setAlpha:0.4];
    [self.containerView setUserInteractionEnabled:NO];
    self.navigationItem.leftBarButtonItem = nil;

    NSString *animationTitle;
    
    if (calculationType==CalculatingStyle)
        animationTitle=@"AnalysingStyleViewMovement";
    else if (calculationType==CalculatingFashionVictim)
        animationTitle=@"AnalysingFashionVictimViewMovement";
        
    
    [analysingFrame setImage:[StyleDressApp imageWithStyleNamed:[NSString stringWithFormat: @"STYCalculating%d",imageID] ]];
    [analysingFrame setAlpha:1];
    [analysingFrame setHidden:NO];
    [self startAnimationForImageID];
}

-(void) startAnimationForImageID
{
    [self.navigationController.navigationBar setAlpha:0.5];
    [analysingFrame setAlpha:1];
    [UIView beginAnimations:@"calculation" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [analysingFrame setAlpha:0.99];
    [UIView setAnimationDidStopSelector:@selector(animationViewFinished:finished:context:)];
    [UIView commitAnimations];

}

- (void)animationViewFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    if ([animationID isEqualToString:@"calculation"] ) 
    {
        imageID++;
        if (imageID>7)
        {
            imageID=2;
            animationRepetitions++;
        }
        
        
        if (animationRepetitions<=1)
        {
            [analysingFrame setImage:[StyleDressApp imageWithStyleNamed:[NSString stringWithFormat: @"STYCalculating%d",imageID] ]];
            [self startAnimationForImageID];
        }
        else
        {
            [UIView beginAnimations:@"AnalysingStyleFadeOut" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            [analysingFrame setAlpha:0];
            [self.navigationController.navigationBar setAlpha:1];

             [UIView setAnimationDidStopSelector:@selector(animationViewFinished:finished:context:)];
            [UIView commitAnimations];
            
            if (calculationType==CalculatingStyle) 
                [self openStyleVC];
            else if (calculationType==CalculatingFashionVictim)
                [self openFashionVictimVC];
        }
    } else if ([animationID isEqualToString:@"AnalysingStyleFadeOut"]) 
    {
        [analysingFrame setHidden:YES];
        [self.containerView setAlpha:1];
        [self.containerView setUserInteractionEnabled:YES];
        [self.navigationController.navigationBar setAlpha:1];

    }    
}


-(void) openStyleVC
{
    self.navigationItem.leftBarButtonItem=self.mainMenuButton;
    self.yourStyleVC=[[CalculateMyStyleViewController alloc] initWithNibName:@"CalculateMyStyleViewController" bundle:nil];  
    yourStyleVC.managedObjectContext=managedObjectContext;
    [self.navigationController pushViewController:yourStyleVC animated:YES];
}

-(IBAction) openFashionVictimVC
{
    self.navigationItem.leftBarButtonItem=self.mainMenuButton;
    self.fashionVictimVC=[[CalculateFashionVictimVC alloc] initWithNibName:@"CalculateFashionVictimVC" bundle:nil];  
    fashionVictimVC.managedObjectContext=managedObjectContext;
    [self.navigationController pushViewController:fashionVictimVC animated:YES];

}

-(void) popMainMenuViewController
{
    
    if (!isRight) 
        [self.delegate moveMainViewToRight:YES];
    else
        [self.delegate moveMainViewToRight:NO];
    
    isRight = !isRight;
    
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
