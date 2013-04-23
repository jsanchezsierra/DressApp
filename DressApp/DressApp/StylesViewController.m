//
//  StylesViewController.m
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


#import "StylesViewController.h"
#import "StyleDressApp.h"
#import "AppDelegate.h"

@implementation StylesViewController
@synthesize delegate;
@synthesize managedObjectContext;
@synthesize isRight;
@synthesize containerView,myImageViewBackground,scrollView;
@synthesize myConnection,myConnectionData;
@synthesize styleView1,styleView2;
@synthesize styleButton1,styleButton2;
@synthesize styleLabel1,styleLabel2;
@synthesize styleImageView1,styleImageView2;
@synthesize styleImageActiveStyle1,styleImageActiveStyle2;
@synthesize activityIndicator;
@synthesize isChangingStyle;
@synthesize leftLineView;
@synthesize styleFrame1,styleFrame2;
@synthesize loadingView,loadingLabel,loadingImageView,loadingActivityView;
@synthesize myActivity;

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
    [leftLineView setHidden:YES];
    
    [self.loadingView setHidden:YES];
    [self.loadingLabel setText:NSLocalizedString(@"unzippingStyle",@"")];
    [self.loadingImageView setImage:[StyleDressApp imageWithStyleNamed:@"Activity"]];
    [self.loadingActivityView startAnimating];
    
    [myActivity stopAnimating];
        
    //Set image background
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"StylesBackground"]];

    //Header Title
    UIFont *myFontTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:23];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,200,32)];
    titleLabel.font=myFontTitle;
    titleLabel.text=NSLocalizedString(@"SelectStyle", @"");
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[StyleDressApp colorWithStyleForObject:StyleColorStylesHeader];
    [self.navigationItem setTitleView:titleLabel ];
    
    isRight=NO;
 
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        [styleFrame1 setFrame:CGRectMake(0,21,110,170)];
        [styleFrame2 setFrame:CGRectMake(2,22,105,170)];
         
    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        [styleFrame1 setFrame:CGRectMake(0,21,110,170)];
        [styleFrame2 setFrame:CGRectMake(0,21,110,169)];
    }

    //Create LeftBarButtonItem -  MenuButton
    leftBarButtonItem= [[UIBarButtonItem alloc] init];
    [leftBarButtonItem setImage:[StyleDressApp imageWithStyleNamed:@"GEBtnMainMenu" ] ];
    [leftBarButtonItem setTarget:self];
    [leftBarButtonItem setStyle:UIBarButtonItemStyleBordered];
    [leftBarButtonItem setAction:@selector(popMainMenuViewController)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem; 

    //Set font style for labels
    UIFont *myFontLabels= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:16];
    styleLabel1.font=myFontLabels;
    styleLabel2.font=myFontLabels;
    styleLabel1.textColor=[StyleDressApp colorWithStyleForObject:StyleColorStylesTitle];
    styleLabel2.textColor=[StyleDressApp colorWithStyleForObject:StyleColorStylesTitle];
    
    //set images for buttons
    [styleButton1 setImage:[UIImage imageNamed:@"style1.png"] forState:UIControlStateNormal];
    [styleButton2 setImage:[UIImage imageNamed:@"style2.png"] forState:UIControlStateNormal];
    
    //set text for labels
    [styleLabel1 setText:NSLocalizedString(@"Vintage",@"")];
    [styleLabel2 setText:NSLocalizedString(@"Modern",@"")];
    
    //Set images for locks
    [styleImageView1 setImage:[StyleDressApp imageWithStyleNamed:@"AparienciaLock"]];
    [styleImageView2 setImage:[StyleDressApp imageWithStyleNamed:@"AparienciaLock"]];
    [styleImageView1 setImage:nil];
    [styleImageView2 setImage:nil];
    
    //Set images for checkBox OK
    [styleImageActiveStyle1 setImage:[StyleDressApp imageWithStyleNamed:@"AparienciaCheckBoxSelected"]];
    [styleImageActiveStyle2 setImage:[StyleDressApp imageWithStyleNamed:@"AparienciaCheckBoxSelected"]];

    //styleFrame1 images
    [styleFrame1 setImage:[StyleDressApp imageWithStyleNamed:@"AparienciaFrame"]];
    [styleFrame2 setImage:[StyleDressApp imageWithStyleNamed:@"AparienciaFrame"]];
    
    [self updateControlsAppareance];
    [super viewDidLoad];

}

 

-(void) updateControlsAppareance
{
    [self.containerView setUserInteractionEnabled:YES];
    isChangingStyle=NO;
    
    [styleImageActiveStyle1 setHidden:YES];
    [styleImageActiveStyle2 setHidden:YES];

    if ( [[[NSUserDefaults standardUserDefaults]  objectForKey:@"DressAppStyle"] intValue]==1 )
        [styleImageActiveStyle1 setHidden:NO];
    if ( [[[NSUserDefaults standardUserDefaults]  objectForKey:@"DressAppStyle"] intValue]==2 )
        [styleImageActiveStyle2 setHidden:NO];
 
    //hide locks according to value of "isStyle1Open"
    [styleImageView1 setHidden:[[[NSUserDefaults standardUserDefaults] objectForKey:@"isStyle1Open"] boolValue]];
    [styleImageView2 setHidden:[[[NSUserDefaults standardUserDefaults] objectForKey:@"isStyle2Open"] boolValue]];
    [styleImageView1 setHidden:YES];
    [styleImageView2 setHidden:YES];
    
    //Set AlphaValue according to "isStyleOpen2
    float alphaValue=0.7;
    [styleButton1 setAlpha:[[[NSUserDefaults standardUserDefaults] objectForKey:@"isStyle1Open"] boolValue]?1:alphaValue  ];
    [styleButton2 setAlpha:[[[NSUserDefaults standardUserDefaults] objectForKey:@"isStyle2Open"] boolValue]?1:alphaValue  ];
    
 
}

-(IBAction)chooseStyle:(UIButton*)thisButton
{
   
    //Button 1
    if (thisButton==styleButton1 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isStyle1Open"] boolValue]==YES )
        [self changeAppSkinToStyle:1];
    
    //Button 2
    if (thisButton==styleButton2 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isStyle2Open"] boolValue]==YES )
        [self changeAppSkinToStyle:2];
    
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

-(IBAction) exitApp
{
    exit(0);
}

  
-(void) changeAppSkinToStyle:(NSInteger)newStyle
{
    [self.loadingView setHidden:YES];

    if (isChangingStyle==NO && [[[NSUserDefaults standardUserDefaults] objectForKey:@"DressAppStyle"] intValue] !=newStyle ) 
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:newStyle ] forKey:@"DressAppStyle"];
        [activityIndicator startAnimating];
        [self updateControlsAppareance];
        isChangingStyle=YES;
        [self.containerView setUserInteractionEnabled:NO];
        [self performSelector:@selector(restartSkin) withObject:nil afterDelay:0.01];   
         
    }else if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"DressAppStyle"] intValue] ==newStyle )
        [self changeToPrendasVC];
    
}

-(void) restartSkin
{
    AppDelegate *delegateApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegateApp resetSyle];
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
