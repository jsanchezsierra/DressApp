//
//  PrendasPrecioViewController.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 1/31/12.
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


#import "PrendasPrecioViewController.h"
#import "StyleDressApp.h"

@implementation PrendasPrecioViewController
@synthesize managedObjectContext,delegate;
@synthesize myActivity,prenda,prendasArray,multipleSelectionDictionary,isMultiselection;
@synthesize myImageViewBackground,myNavigationBar,myNavigationTitle,myPickerView;

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
    nullString=@"-------";
    
    [myActivity setHidden:YES];
    
    //set header title Frame and Label
    UIImageView *titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,3, 127,38)];
    [titleImageView setImage:[StyleDressApp imageWithStyleNamed:@"GEHeaderFrame"]];
    UILabel *headerTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 127, 30)];
    [headerTitleLabel setTextAlignment:UITextAlignmentCenter];
    [headerTitleLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:25]];
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [headerTitleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRPrecioHeader]];
    [headerTitleLabel setText:NSLocalizedString(@"PrecioTitleHeader",@"")];
    [titleImageView addSubview:headerTitleLabel];
    [self.myNavigationTitle setTitleView:titleImageView];
    
    
    //Navigation Bar Color
    [self.myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
    
    //Set image background
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"PRPrecioBackground"]]; 
    
    
    //Define UIpickerView
  	myPickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 140, 320, 216) ];
	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	myPickerView.showsSelectionIndicator = YES;	// note this is default to NO
	// this view controller is the data source and delegate
	myPickerView.delegate = self;
	myPickerView.dataSource = self;
    // add this picker to our view controller, initially hidden
	[self.view addSubview:myPickerView];
        
    
    //Add frame
    UIImageView *imageViewFrame1= [[UIImageView alloc] initWithFrame:CGRectMake(0,140,320,216)];
    imageViewFrame1.image = [StyleDressApp imageWithStyleNamed:@"PRDetailPickerFramePrecio"];
    [imageViewFrame1 setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:imageViewFrame1];
    
    
    if (isMultiselection) 
    {
        NSInteger precio=[ [multipleSelectionDictionary objectForKey:@"multiplePrecio"] integerValue];
        if (  precio ==-1  ) 
            [myPickerView selectRow:0 inComponent:0 animated:YES];
        else
            [myPickerView selectRow:precio/5 inComponent:0 animated:YES];
    }
    else
        [myPickerView selectRow:[prenda.precio integerValue]/5 inComponent:0 animated:YES];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


-(IBAction) doneButton
{
    
    NSInteger rowInComponent0 =  [myPickerView  selectedRowInComponent:0]*5;
    
    if (isMultiselection) 
    {
        for (Prenda *myPrenda in prendasArray) 
        {
            myPrenda.precio= [NSNumber numberWithInteger:rowInComponent0];
            myPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
        }
        
        [multipleSelectionDictionary setObject: [NSNumber numberWithInteger:rowInComponent0] forKey:@"multiplePrecio"];
    }
    else
    {
        self.prenda.precio= [NSNumber numberWithInteger:rowInComponent0];
        self.prenda.needsSynchronize=[NSNumber numberWithBool:YES];
        
    }
    
    // Save the context. 
    NSError *error;
    if (![self.managedObjectContext save:&error]) 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    
    [self.delegate dismissPrecioVC];
}

-(IBAction) cancelButton
{
    [self.delegate dismissPrecioVC];
}




#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr = @"";
    
	// note: custom picker doesn't care about titles, it uses custom views
	if (pickerView == myPickerView)
	    returnStr=[NSString stringWithFormat:@"                       %d", row*5];
    
	return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
	return 298;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 1000;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
