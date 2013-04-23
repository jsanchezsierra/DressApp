//
//  StylesViewController.h
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


#import <UIKit/UIKit.h>
#import "MenuProtocolDelegate.h"
 
@interface StylesViewController : UIViewController 
{
     
    UIBarButtonItem *leftBarButtonItem;
}

//Delegate
@property (nonatomic, assign) id<MenuProtocolDelegate>delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSURLConnection    *myConnection;
@property (nonatomic, strong) NSMutableData      *myConnectionData;
@property (nonatomic, assign) BOOL isRight;
@property (nonatomic, assign) BOOL isChangingStyle;

//Container View
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *myImageViewBackground;
@property (nonatomic, strong) IBOutlet UIView *styleView1;
@property (nonatomic, strong) IBOutlet UIView *styleView2;
@property (nonatomic, strong) IBOutlet UIButton *styleButton1;
@property (nonatomic, strong) IBOutlet UIButton *styleButton2;
@property (nonatomic, strong) IBOutlet UIImageView *styleFrame1;
@property (nonatomic, strong) IBOutlet UIImageView *styleFrame2;
@property (nonatomic, strong) IBOutlet UILabel *styleLabel1;
@property (nonatomic, strong) IBOutlet UILabel *styleLabel2;
@property (nonatomic, strong) IBOutlet UIImageView *styleImageView1;
@property (nonatomic, strong) IBOutlet UIImageView *styleImageView2;
@property (nonatomic, strong) IBOutlet UIImageView *styleImageActiveStyle1;
@property (nonatomic, strong) IBOutlet UIImageView *styleImageActiveStyle2;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) IBOutlet UIImageView *loadingImageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivityView;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *myActivity;
@property (nonatomic, strong) IBOutlet UIView *leftLineView;

-(void) updateControlsAppareance;
-(IBAction)chooseStyle:(UIButton*)thisButton;
-(IBAction)cancelStyle:(UIButton*)thisButton;
-(IBAction)downloadStyle:(UIButton*)thisButton;
-(void)downloadFileForStyle:(NSInteger)styleToDownload;
-(void) changeAppSkinToStyle:(NSInteger)newStyle;
-(void) unzipFile; 
-(void) startDownloadingStyle;
-(void) restartSkin;
-(void) showLoadingView;

@end
