//
//  helpViewController.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 2/1/12.
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


#import "helpViewController.h"
#import "StyleDressApp.h"

#import "PrendaMarca.h"
#import "Conjunto.h"
#import "ConjuntoPrendas.h"
#import "CalendarConjunto.h"
#import "Prenda.h"
#import "AppDelegate.h"
#import "Authenticacion.h"
 
@implementation helpViewController
@synthesize delegate, isRight;
@synthesize helpViewFrame;
@synthesize containerView;
@synthesize leftLineView;
@synthesize helpTable,versionLabel;
@synthesize backgroundImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    //[versionLabel setText:[NSString stringWithFormat:@"DressApp v%@ (built %@)",version,build ]];
    [versionLabel setText:[NSString stringWithFormat:@"Copyright (c) 2012 Javier Sánchez Sierra"]];
    [versionLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorHelpVersion]];
    
     
    [self.backgroundImageView setImage:[StyleDressApp imageWithStyleNamed:@"PRHelpBackground"]];
    
    [leftLineView setHidden:YES];

    
    
    //Set navigation color
    [self.navigationController.navigationBar setTintColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];

    UIBarButtonItem *leftBarButtonItem= [[UIBarButtonItem alloc] init];
    [leftBarButtonItem setImage:[StyleDressApp imageWithStyleNamed:@"GEBtnMainMenu" ] ];
    [leftBarButtonItem setTarget:self];
    [leftBarButtonItem setStyle:UIBarButtonItemStyleBordered];
    [leftBarButtonItem setAction:@selector(popMainMenuViewController)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem; 


    //Add centerView
    UIButton *prendasButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prendasButton setFrame:CGRectMake(5, 5, 44, 30)];
    [prendasButton setImage:[StyleDressApp imageWithStyleNamed:@"HeaderIconPrendas"] forState:UIControlStateNormal];
    [prendasButton setTag:52];
    [prendasButton addTarget:self action:@selector(changeToPrendasVC) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *conjuntosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [conjuntosButton setFrame:CGRectMake(55, 5, 44, 30)];
    [conjuntosButton setImage:[StyleDressApp imageWithStyleNamed:@"HeaderIconConjuntos"] forState:UIControlStateNormal];
    [conjuntosButton setTag:53];
    [conjuntosButton addTarget:self action:@selector(changeToConjuntosVC) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarButton setFrame:CGRectMake(105, 5, 44, 30)];
    [calendarButton setImage:[StyleDressApp imageWithStyleNamed:@"HeaderIconCalendar"] forState:UIControlStateNormal];
    [calendarButton setTag:54];
    [calendarButton addTarget:self action:@selector(changeToCalendarVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *centerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150,40)]; 
    [centerView addSubview:prendasButton];
    [centerView addSubview:conjuntosButton];
    [centerView addSubview:calendarButton];

    self.navigationItem.titleView = centerView; 
    
    [self.helpTable setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorHelpCellBackground]];
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        
        helpTable.frame= CGRectMake(45, 55 ,228, 335);
    else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        helpTable.frame= CGRectMake(45, 55 ,228, 335);
    
  
    //SET imageView
    [helpViewFrame setImage:[StyleDressApp imageWithStyleNamed:@"PRHelpFrame"]];
    [helpTable flashScrollIndicators];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void) viewDidAppear:(BOOL)animated
{
    [helpTable flashScrollIndicators];

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


-(void) popMainMenuViewController
{
    [self.view setUserInteractionEnabled:YES];
    
    if (!isRight) 
        [self.delegate moveMainViewToRight:YES];
    else
        [self.delegate moveMainViewToRight:NO];
    
    isRight = !isRight;
    
}



-(void) changeToPrendasVC
{
    [self.view setUserInteractionEnabled:YES];
    [self.delegate changeToVC:1];
}


-(void) changeToConjuntosVC
{
    [self.view setUserInteractionEnabled:YES];
    [self.delegate changeToVC:2];
}


-(void) changeToCalendarVC
{
    [self.view setUserInteractionEnabled:YES];
    [self.delegate changeToVC:3];
}


-(void) changeToProfileVC
{
    [self.view setUserInteractionEnabled:YES];
    [self.delegate changeToVC:5];
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

 
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"menuItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
        
        UIImageView *iconoView=[[UIImageView alloc]initWithFrame:CGRectMake(5,10 ,34, 25)];
        iconoView.tag=1;
        [cell addSubview:iconoView];
        
        UILabel *labelView=[[UILabel alloc] initWithFrame:CGRectMake(45, 10, 140, 25)];
        UIFont *myFont =[StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:16];
        labelView.font=myFont;
        labelView.adjustsFontSizeToFitWidth=YES;
        labelView.backgroundColor=[UIColor clearColor];
        labelView.textColor=[StyleDressApp colorWithStyleForObject:StyleColorHelpCell];
        labelView.tag=2;
        [cell addSubview:labelView];

        UIImageView *flechaImageView=[[UIImageView alloc]initWithFrame:CGRectMake(192,12 ,22, 22)];
        flechaImageView.image=[StyleDressApp imageWithStyleNamed:@"PRHelpTableFlecha"];
        [cell addSubview:flechaImageView];

    }
    
    //Recover cell image
    UIImageView *thisCellImage= (UIImageView*)[cell viewWithTag:1];
    thisCellImage.frame= CGRectMake(5, 10 ,34, 25);

    //Recover cell label
    UILabel *thisCellLabel= (UILabel*)[cell viewWithTag:2];
    
    //Set Cell settings
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setBackgroundColor:[StyleDressApp colorWithStyleForObject:StyleColorHelpCellBackground]];
     
    //Get localized cell text content
    NSString *helpMenuString= [NSString stringWithFormat:@"helpMenuItem%d",indexPath.row+1];
    thisCellLabel.text=[NSString stringWithFormat:@" %@", NSLocalizedString(helpMenuString,@"")];
    
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        thisCellImage.frame= CGRectMake(5, 10 ,34, 25);
    else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        thisCellImage.frame= CGRectMake(0, 5 ,46, 34);
    
    //Fill cell image
    if (indexPath.row==0) 
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"MMIconPrendas"];
    else if (indexPath.row==1)
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"MMIconConjuntos"];
    else if (indexPath.row==2)
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"MMIconCalendar"];
    else if (indexPath.row==3)
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"MMIconMainMenu"];
    else if (indexPath.row==4)
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"MMIconMultiedicion"];
    else if (indexPath.row==5)
    {
        thisCellImage.frame= CGRectMake(5, 2 ,25, 37.5);
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"PR1AddAccessories"];
    }else if (indexPath.row==6)
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"MMIconPerfil"];
    else if (indexPath.row==7)
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"MMIconMisMarcas"];
    else if (indexPath.row==8)
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"MMIconConoceTuEstilo"];
    else if (indexPath.row==9)
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"MMIconApariencia"];
    else if (indexPath.row==10)
        thisCellImage.image=[StyleDressApp imageWithStyleNamed:@"MMIconOrdenar"];
    
    return cell;
    
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *helpMenuString= [NSString stringWithFormat:@"helpMenuItem%d",indexPath.row+1];
    NSString *helpMenuTitle = [NSString stringWithFormat:@" %@", NSLocalizedString(helpMenuString,@"")];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HelpDetalleViewController *myVC= [[HelpDetalleViewController alloc] initWithNibName:@"HelpDetalleViewController" bundle:nil];
    myVC.helpPage=indexPath.row+1;
    myVC.helpMenuTitle=helpMenuTitle;
    [self.navigationController pushViewController:myVC animated:YES];
    
}

 

@end
