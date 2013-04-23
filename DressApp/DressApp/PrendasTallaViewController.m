//
//  PrendasTallaViewController.m
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


#import "PrendasTallaViewController.h"
#import "StyleDressApp.h"

@implementation PrendasTallaViewController
@synthesize managedObjectContext,delegate;
@synthesize myActivity,prenda,prendasArray,multipleSelectionDictionary,isMultiselection;
@synthesize myImageViewBackground,myNavigationBar,myNavigationTitle,myPickerView;
@synthesize helpTallaLabel,helpTallaImageView;

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
    nullString=@"-------";
    [myActivity setHidden:YES];

    //set header title Frame and Label
    UIImageView *titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,3, 127,38)];
    [titleImageView setImage:[StyleDressApp imageWithStyleNamed:@"GEHeaderFrame"]];
    UILabel *headerTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 127, 30)];
    [headerTitleLabel setTextAlignment:UITextAlignmentCenter];
    [headerTitleLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:24]];
    [headerTitleLabel setBackgroundColor:[UIColor clearColor]];
    [headerTitleLabel setText:NSLocalizedString(@"TallaTitleHeader",@"")];
    [headerTitleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRTallaHeader]]; 

    [titleImageView addSubview:headerTitleLabel];
    [self.myNavigationTitle setTitleView:titleImageView];
    
    
    //Navigation Bar Color
    [self.myNavigationBar setTintColor:[StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar]];
    
    //Set image background
    [self.myImageViewBackground  setImage:[StyleDressApp imageWithStyleNamed:@"PRTallaBackground"]];  
    
    
    //Define UIpickerView
  	myPickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 180, 320, 216) ];
	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	myPickerView.showsSelectionIndicator = YES;	// note this is default to NO
	// this view controller is the data source and delegate
	myPickerView.delegate = self;
	myPickerView.dataSource = self;
    // add this picker to our view controller, initially hidden
	[self.view addSubview:myPickerView];
    
    tallas1=[NSArray arrayWithObjects:@"--",@"XXS",@"XS",@"S",@"M",@"L",@"XL",@"XXL", nil];
    tallas2=[NSArray arrayWithObjects:@"--",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    
    //Add frame
    UIImageView *imageViewFrame1= [[UIImageView alloc] initWithFrame:CGRectMake(-4,180,325,216)];
    imageViewFrame1.image = [StyleDressApp imageWithStyleNamed:@"PRDetailPickerFrameTalla"];
    [imageViewFrame1 setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:imageViewFrame1];
    
    //Añade texto explicativo
    [self.helpTallaImageView setImage:[StyleDressApp imageWithStyleNamed:@"PRDetailTallaFrame"]];
    
    [self.helpTallaLabel setFont:[StyleDressApp fontWithStyleNamed:StyleFontFlat AndSize:14]];
    [self.helpTallaLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRTallaSectionTitle]];
    [self.helpTallaLabel setText:NSLocalizedString(@"helpTallaText", @"")];
    
    //Añade los componentes de la PickerView para las tallas  
    if (isMultiselection) 
    {
        //Componente 1
        NSInteger talla1=[ [multipleSelectionDictionary objectForKey:@"multipleTalla1"] integerValue];
        //Si es -1, significa que no hay ningun valor, asigno el primero por defecto
        if (  talla1 ==-1  ) 
            [myPickerView selectRow:0 inComponent:0 animated:YES];
        else
            [myPickerView selectRow:talla1 inComponent:0 animated:YES];
        
        //Componente 2
        NSInteger talla2=[ [multipleSelectionDictionary objectForKey:@"multipleTalla2"] integerValue];
        //Si es -1, significa que no hay ningun valor, asigno el primero por defecto
        if (  talla2 ==-1  ) 
            [myPickerView selectRow:0 inComponent:1 animated:YES];
        else
            [myPickerView selectRow:talla2 inComponent:1 animated:YES];
        
        //Componente 3
        NSInteger talla3=[ [multipleSelectionDictionary objectForKey:@"multipleTalla3"] integerValue];
        //Si es -1, significa que no hay ningun valor, asigno el primero por defecto
        if (  talla3 ==-1  ) 
            [myPickerView selectRow:0 inComponent:2 animated:YES];
        else
            [myPickerView selectRow:talla3 inComponent:2 animated:YES];
    }
    else
    {
        NSInteger talla1=[prenda.talla1 integerValue];
        NSInteger talla2=[prenda.talla2 integerValue];
        NSInteger talla3=[prenda.talla3 integerValue];
        
        if (talla1>0)
            [myPickerView selectRow:talla1 inComponent:0 animated:YES];
        if (talla2>0)
            [myPickerView selectRow:talla2 inComponent:1 animated:YES];
        if (talla3>0)
            [myPickerView selectRow:talla3 inComponent:2 animated:YES];
    }
    
    
    //botones de Reset
    UIImage *newImage;
    UIImage *newPressedImage;
    
    if ([StyleDressApp getStyle] == StyleTypeVintage ) 
    {
        [self.helpTallaImageView setFrame:CGRectMake(27, 51, 271, 125)];
        [self.helpTallaLabel setFrame:CGRectMake(59,61, 212,69)];

        newImage = [[StyleDressApp imageWithStyleNamed:@"GEBtnType1"] stretchableImageWithLeftCapWidth:20 topCapHeight:0.0];
        newPressedImage = [[StyleDressApp imageWithStyleNamed:@"GEBtnType1"] stretchableImageWithLeftCapWidth:20 topCapHeight:0.0];
        
    }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
    {
        [self.helpTallaImageView setFrame:CGRectMake(5, 51, 310, 125)];
        [self.helpTallaLabel setFrame:CGRectMake(65,68, 212,69)];

        newImage = [[StyleDressApp imageWithStyleNamed:@"GEBtnType1"] stretchableImageWithLeftCapWidth:20 topCapHeight:0.0];
        newPressedImage = [[StyleDressApp imageWithStyleNamed:@"GEBtnType1"] stretchableImageWithLeftCapWidth:20 topCapHeight:0.0];
        
    }
    
    NSInteger PositionX=20;
    NSInteger PositionY=410;
    NSInteger offsetX=100;
    for (int i=0;i<3;i++) 
    {
        UIButton *botonReset= [[UIButton alloc] initWithFrame:CGRectMake(PositionX, PositionY, 80, 30)];
        
        if ([StyleDressApp getStyle] == StyleTypeVintage ) 
        {
            [botonReset setFrame:CGRectMake(PositionX, PositionY, 80, 30)];
            [botonReset setTitle:NSLocalizedString(@"btnResetTitle", @"") forState:UIControlStateNormal];	
        }else if ([StyleDressApp getStyle] == StyleTypeModern ) 
        {
            [botonReset setFrame:CGRectMake(PositionX, PositionY, 80, 30)];
            [botonReset setTitle:NSLocalizedString(@"btnResetTitle", @"") forState:UIControlStateNormal];	
            
        }else
        {
            [botonReset setFrame:CGRectMake(PositionX, PositionY-5, 80, 42)];
            [botonReset setTitle:@"" forState:UIControlStateNormal];	
            
        }
        
        [botonReset setTitleColor:[StyleDressApp colorWithStyleForObject:StyleColorPRTallaResetBtn] forState:UIControlStateNormal];
        [botonReset setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [[botonReset titleLabel] setFont:[UIFont systemFontOfSize:20]];
        [botonReset setTag:100+i];
        [botonReset addTarget:self action:@selector(resetComponent:) forControlEvents:UIControlEventTouchUpInside];
        [botonReset setBackgroundImage:newImage forState:UIControlStateNormal];
        [botonReset setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
        botonReset.backgroundColor = [UIColor clearColor];
        [self.view addSubview:botonReset];
        PositionX+=offsetX;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) resetComponent:(UIButton*)thisButton
{
    NSInteger buttonIndex=[thisButton tag]-100;
    [myPickerView selectRow:0 inComponent:buttonIndex animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any stronged subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(IBAction) doneButton
{
    NSInteger rowInComponent0 =  [myPickerView  selectedRowInComponent:0];
    NSInteger rowInComponent1 =  [myPickerView  selectedRowInComponent:1];
    NSInteger rowInComponent2 =  [myPickerView  selectedRowInComponent:2];
    
    if (isMultiselection) 
    {
        for (Prenda *myPrenda in prendasArray) 
        {
            myPrenda.talla1= [NSNumber numberWithInteger:rowInComponent0];
            myPrenda.talla2= [NSNumber numberWithInteger:rowInComponent1];
            myPrenda.talla3= [NSNumber numberWithInteger:rowInComponent2];
            myPrenda.needsSynchronize=[NSNumber numberWithBool:YES];
        }
        
        [multipleSelectionDictionary setObject: [NSNumber numberWithInteger:rowInComponent0] forKey:@"multipleTalla1"];
        [multipleSelectionDictionary setObject: [NSNumber numberWithInteger:rowInComponent1] forKey:@"multipleTalla2"];
        [multipleSelectionDictionary setObject: [NSNumber numberWithInteger:rowInComponent2] forKey:@"multipleTalla3"];
    }
    else
    {
        self.prenda.talla1= [NSNumber numberWithInteger:rowInComponent0];
        self.prenda.talla2= [NSNumber numberWithInteger:rowInComponent1];
        self.prenda.talla3= [NSNumber numberWithInteger:rowInComponent2];
        self.prenda.needsSynchronize=[NSNumber numberWithBool:YES];
        
    }
    
    // Save the context. 
    NSError *error;
    if (![self.managedObjectContext save:&error]) 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    
    [self.delegate dismissTallasVC];
}

-(IBAction) cancelButton
{
    
    [self.delegate dismissTallasVC];
    
}




#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr = @"";
    
	// note: custom picker doesn't care about titles, it uses custom views
	if (pickerView == myPickerView)
	{
		if (component == 0)
		{
            returnStr= [NSString stringWithFormat:@"    %@", [tallas1 objectAtIndex:row] ];
        }
		else if (component == 1)
		{
            if (row==0) 
                returnStr=@"   --";
            else
                returnStr= [NSString stringWithFormat:@"   %.1f", row/2.0];
        }
		else if (component == 2)
        {
            returnStr= [NSString stringWithFormat:@"     %@", [tallas2 objectAtIndex:row] ];
        }
        
    }
	
	return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat componentWidth = 0.0;
    
	if (component == 0)
		componentWidth = 95;//65	// first column size is wider to hold names
	else if (component == 1)
    	componentWidth = 100; //70	// second column is narrower to show numbers
    else        
        componentWidth = 95;//55	// second column is narrower to show numbers
    
    
	return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	
    if (component == 0)
        return [tallas1 count]; //Talla XXS- XS-S- M-L-XL-XXL
	else if (component == 1)
        return 301; //Talla numerica cada 0.5, de 0 a 150
	else if (component == 2)
       return [tallas2 count]; //Talla de letra A-Z
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
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
