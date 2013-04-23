//
//  HelpDetalleViewController.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 2/3/12.
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


#import "HelpDetalleViewController.h"
#import "StyleDressApp.h"

@implementation HelpDetalleViewController
@synthesize helpPage,helpViewFrame;
@synthesize myScroolView;
@synthesize helpMenuTitle,titleLabel,helpText,myImageView,helpTitle;
@synthesize backgroundImageView;
@synthesize helpViewImage;

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
    
    //Set navigation color
    [self.navigationController.navigationBar setTintColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];
    [self.backgroundImageView setImage:[StyleDressApp imageWithStyleNamed:@"PRHelpDetailBackground"]];

    //add header Icon Image
    NSString *helpTitleIcon=[NSString stringWithFormat:@"PRHelpDetalleIcon%d",helpPage];
    UIImageView *titleImageView =[[UIImageView alloc] initWithFrame:CGRectMake(100,0, 84,90)];  //120,135
    titleImageView.image=[StyleDressApp imageWithStyleNamed:helpTitleIcon];
    self.navigationItem.titleView=titleImageView;

    //add help Image Frame
    NSString *helpImageViewName=[NSString stringWithFormat:@"PRHelpDetalleImageView%d",helpPage];
    [helpViewImage setImage:[StyleDressApp imageWithStyleNamed:helpImageViewName]];

    [helpViewFrame setImage:[StyleDressApp imageWithStyleNamed:@"PRHelpDetalleImageFrame"]];
    
    //Titulo
    UIFont *myFontTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:30];
    [helpTitle setFont:myFontTitle];
    [helpTitle setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorHelpDetailTitle]];
    [helpTitle setText:helpMenuTitle];

    //add textLabel
    NSString *helpTextName=[NSString stringWithFormat:@"helpText%d",helpPage];
    [helpText setBackgroundColor:[UIColor clearColor]];
    [helpText setText:NSLocalizedString(helpTextName, @"")];
    [helpText setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorHelpDetailText]];

    [self.myScroolView setContentSize:CGSizeMake(320, 700)]; 
    [self.myScroolView flashScrollIndicators];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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



@end
