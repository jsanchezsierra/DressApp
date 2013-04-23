//
//  ShareFacebookTwitter.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 2/5/12.
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


#import "ShareFacebookTwitter.h"
#import "StyleDressApp.h"

@implementation ShareFacebookTwitter
@synthesize webUrl,delegate;
@synthesize myNavigationBar,myNavigationItem,myWebView,myActivity;

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

-(void) viewWillAppear:(BOOL)animated
{
    
    [self.view setBackgroundColor:[ StyleDressApp colorWithStyleForObject:StyleColorPRDetailBackground] ];

}

- (void)viewDidLoad
{
    
    [myActivity startAnimating];
    myWebView.delegate = self;
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar" style:UIBarButtonItemStyleBordered target:self action:@selector(closeCLick)];
    self.myNavigationItem.rightBarButtonItem = close;

    [myNavigationBar setTintColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];

    [myWebView setBackgroundColor:[ StyleDressApp colorWithStyleForObject:StyleColorPRDetailBackground] ];

    
    //Set font for tittle
    UIFont *myFontTitle= [StyleDressApp fontWithStyleNamed:StyleFontMainType AndSize:28];

    //set title
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 200,44)];
    [titleLabel setFont:myFontTitle];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[StyleDressApp colorWithStyleForObject:StyleColorPRDetailHeader]];
    [titleLabel setText:@"Twitter" ];
    [self.myNavigationItem setTitleView:titleLabel];

        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)closeCLick{
    [myActivity stopAnimating];

    [self.delegate dismissShareFacebookTwitterWebView];
 }

#pragma mark webview delegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [myActivity stopAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [myActivity stopAnimating];
}

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
