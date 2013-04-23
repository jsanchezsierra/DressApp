//
//  PrendasFechaViewController.m
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


#import "PrendasFechaViewController.h"
#import "PrendasFechaViewController.h"
#import "StyleDressApp.h"

@implementation PrendasFechaViewController
@synthesize managedObjectContext,delegate;
@synthesize myActivity,prenda,prendasArray,multipleSelectionDictionary,isMultiselection;
@synthesize myImageViewBackground,myNavigationBar,myNavigationTitle;
@synthesize date,datePicker,isViewOpenedFromProfile;
@synthesize initialDate;

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

- (void)viewDidLoad
{
    nullString=@"-------";
    
    [myActivity setHidden:YES];
    
    //set header title Frame and Label
    UIImageView *titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,3, 127,38)];
    [titleImageView setImage:[StyleDressApp imageWithStyleNamed:@"GEHeaderFrame"]];
    UILabel *headerTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 127, 30)];
    [headerTitleLabel setTextAlignment:UITextAlignmentCenter];
    [headerTitleLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:24]];
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [headerTitleLabel setText:NSLocalizedString(@"FechaTitleHeader",@"")];
    [headerTitleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorFechaHeader]];
    [titleImageView addSubview:headerTitleLabel];
    [self.myNavigationTitle setTitleView:titleImageView];
    
    
    //Navigation Bar Color
    [self.myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
    
    //Set image background
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"FechaBackground"]];
    
    
    //init datapicker
    datePicker.datePickerMode =  UIDatePickerModeDate;
    self.date = [datePicker date];
    datePicker.maximumDate=[NSDate date];
    
    //Add frame
    UIImageView *imageViewFrame1= [[UIImageView alloc] initWithFrame:CGRectMake(-5,140,325,216)];
    imageViewFrame1.image = [StyleDressApp imageWithStyleNamed:@"PRDetailPickerFrameFecha"];
    [imageViewFrame1 setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:imageViewFrame1];

    
    if (isViewOpenedFromProfile==NO) //Si abro desde prendas
    {
        if (isMultiselection) 
        {
            if ( [(NSDate*)[multipleSelectionDictionary objectForKey:@"multipleDate"] isEqualToDate:[NSDate dateWithTimeIntervalSince1970:123456789012345] ]  ) 
                [datePicker setDate:[NSDate date]];
            else
                [datePicker setDate: [(Prenda*)[prendasArray lastObject] fechaCompra] ];
        }
        else
            [datePicker setDate:prenda.fechaCompra];

    }else  //Si abro desde profile
        [datePicker setDate:initialDate];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(IBAction) doneButton
{
    
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"dd'/'MM'/'yyyy"];
     NSString *tempDate  = [formatter stringFromDate:self.date];
  
    if (isViewOpenedFromProfile==NO) 
    {
        if (isMultiselection) 
        {
            for (Prenda *myPrenda in prendasArray) 
            {
                myPrenda.fechaCompra= self.date;
                myPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
                            }
            
            [multipleSelectionDictionary setObject: self.date forKey:@"multipleFecha"];
        }
        else
        {
            self.prenda.fechaCompra= self.date;
            self.prenda.needsSynchronize=[NSNumber numberWithBool:YES];

        }
        
        // Save the context. 
        NSError *error;
        if (![self.managedObjectContext save:&error]) 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        
        [self.delegate dismissFechaVC];
    
    } else
    {
        [self.delegate dismissFechaVCWithDateString:tempDate];
    }

}



-(IBAction) cancelButton
{
    
    [self.delegate dismissFechaVC];
}

 


-(IBAction)dateChanged
{
    self.date = [datePicker date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd'/'MM'/'yyyy"];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
