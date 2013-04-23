//
//  ProfileViewController.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 1/1/12.
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


#import "ProfileViewController.h"
#import "StyleDressApp.h"
#import "AppDelegate.h"
#import "ConjuntoPrendas.h"
#import "PrendaMarca.h"
#import "Authenticacion.h"

@implementation ProfileViewController
@synthesize managedObjectContext;
@synthesize delegate,isRight;
@synthesize containerView,myScrollView;
@synthesize myImageViewBackground;
@synthesize txtEmail,txtPassword;
@synthesize btnConnect,btnRegistrar;
@synthesize textFieldImageViewEmail, textFieldImageViewPassword;
@synthesize leftLineView;

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
  
    //The view Controller is not in Right position
    isRight=NO;
    
    [self.navigationController.navigationBar setTintColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];

    self.navigationController.navigationBarHidden=NO;

    [self updateLeftBarButtonItem];
    
    [textFieldImageViewEmail setImage:[StyleDressApp imageWithStyleNamed:@"PROTextField"]];
    [textFieldImageViewPassword setImage:[StyleDressApp imageWithStyleNamed:@"PROTextField"]];
    
    
    //Título del navigation Controller 
    //No aparece, pero se utiliza en el backbutton de la siguiente vista de navegación
    self.navigationItem.title=NSLocalizedString(@"Perfil", @"");
    
    //Addd titleView to navigation Controller    
    UIImageView *myImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0,0,53,40)]; //(0,0,45,34)
    myImageView.image=[StyleDressApp imageWithStyleNamed:@"MMIconPerfil"];
    self.navigationItem.titleView=myImageView;

    //Load background Image
    [self.myImageViewBackground setImage:[StyleDressApp imageWithStyleNamed:@"ProfileBackground"]];
    
    //Define textField
    UIFont *myFont= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:16];
    self.txtEmail.font=myFont;
    self.txtEmail.placeholder = NSLocalizedString(@"IntroduceEmail", @"");
    self.txtEmail.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"user_email" ];
    self.txtEmail.keyboardType=UIKeyboardTypeEmailAddress;
    
    self.txtPassword.font=myFont;
    self.txtPassword.placeholder = NSLocalizedString(@"IntroducePassword", @"");
    self.txtPassword.secureTextEntry=YES;

    
    //botón connect
    UIFont *myFontButton= [StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:16];
    [btnConnect setTitle:NSLocalizedString(@"Entra", @"") forState:UIControlStateNormal];	
    [btnConnect setTitleColor:[StyleDressApp colorWithStyleForObject:StyleColorProfileBtnTitle] forState:UIControlStateNormal];
    [btnConnect setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	[[btnConnect titleLabel] setFont:myFontButton];
  	UIImage *newImageConnect = [[StyleDressApp imageWithStyleNamed:@"PROBtnConnect"] stretchableImageWithLeftCapWidth:20 topCapHeight:0.0];
	[btnConnect setBackgroundImage:newImageConnect forState:UIControlStateNormal];
  	UIImage *newPressedImageConnect = [[StyleDressApp imageWithStyleNamed:@"PROBtnConnect"] stretchableImageWithLeftCapWidth:20 topCapHeight:0.0];
	[btnConnect setBackgroundImage:newPressedImageConnect forState:UIControlStateHighlighted];
    btnConnect.backgroundColor = [UIColor clearColor];

    //botón registrar
     [btnRegistrar setTitle:NSLocalizedString(@"Registrar", @"") forState:UIControlStateNormal];	
    [btnRegistrar setTitleColor:[StyleDressApp colorWithStyleForObject:StyleColorProfileBtnTitle ] forState:UIControlStateNormal];
    [btnRegistrar setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	[[btnRegistrar titleLabel] setFont:myFontButton];
	[btnRegistrar setBackgroundImage:newImageConnect forState:UIControlStateNormal];
	[btnRegistrar setBackgroundImage:newPressedImageConnect forState:UIControlStateHighlighted];
    btnRegistrar.backgroundColor = [UIColor clearColor];
    

    [super viewDidLoad];
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        [txtEmail setFrame:CGRectMake(40, 74, 240, 31)];
        [txtPassword setFrame:CGRectMake(40, 124, 240, 31)];
        
    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        [txtEmail setFrame:CGRectMake(20, 74, 260, 31)];
        [txtPassword setFrame:CGRectMake(20, 124, 260, 31)];
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void) updateLeftBarButtonItem
{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"appRequiresLogin"] isEqualToString:@"YES"] )
    {
        //boton "atras" vacio
        UIView *emptyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIBarButtonItem *leftBarButton = [  [UIBarButtonItem alloc] initWithCustomView:emptyView ];
        self.navigationItem.leftBarButtonItem= leftBarButton; 
    }else
    {
        UIBarButtonItem *leftBarButtonItem= [[UIBarButtonItem alloc] init];
        [leftBarButtonItem setImage:[StyleDressApp imageWithStyleNamed:@"GEBtnMainMenu" ] ];
        [leftBarButtonItem setTarget:self];
        [leftBarButtonItem setStyle:UIBarButtonItemStyleBordered];
        [leftBarButtonItem setAction:@selector(popMainMenuViewController)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem; 
    }
    
}

 

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any stronged subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) popMainMenuViewController
{
    
    if (!isRight) 
        [self.delegate moveMainViewToRight:YES];
    else
        [self.delegate moveMainViewToRight:NO];
    
    isRight = !isRight;
    
}

#pragma mark BackupAndRestoreVC Delegate


-(void) closeProfileAndOpenPrendas
{
    
    [self.delegate changeToVC:1];

}



#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==txtEmail)
        [txtPassword becomeFirstResponder];
    if (textField==txtPassword)
    {
        [txtPassword resignFirstResponder];
        [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
 	return NO;  
}


-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.myScrollView setContentOffset:CGPointMake(0, 20) animated:YES];
 
    
}



-(IBAction) btnLoginPressed
{
    [self showMessage]; 
}


-(IBAction) btnRegisterPressed
{
    [self showMessage]; 
    
}

   
-(void) showMessage
{
    UIAlertView *noProfile=[[ UIAlertView alloc] initWithTitle:NSLocalizedString(@"noProfileTitle", "") message:NSLocalizedString(@"noProfileMsg", "") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", "") otherButtonTitles:nil  , nil];
    [noProfile show];

}

 
 



@end
