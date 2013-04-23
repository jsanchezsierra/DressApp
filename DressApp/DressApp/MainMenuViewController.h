//
//  MainMenuViewController.h
//  DressApp
//
//  Created by Javier Sanchez Sierra on 11/21/11.
//  Copyright (c) 2011 Javier Sanchez Sierra. All rights reserved.
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
#import "PrendasViewController.h"
#import "ConjuntosViewController.h"
#import "CalendarViewController.h"
#import "ProfileViewController.h"
#import "StylesViewController.h"
#import "YourStyleViewController.h"
#import "helpViewController.h"

#import "MenuProtocolDelegate.h"
#import "PrendasMisMarcasViewController.h"
#import "CustomNavigationController.h"

@interface MainMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MenuProtocolDelegate, UISearchBarDelegate,PrendasMisMarcasVCDelegate,UINavigationControllerDelegate>
{
    
}

@property (nonatomic, strong) IBOutlet UIView *menuView;
@property (nonatomic, strong) IBOutlet UINavigationBar *myNavigationBar;
@property (nonatomic, strong) IBOutlet UINavigationItem *myNavigationItem;
@property (nonatomic, strong) IBOutlet UIImageView *mainMenuBackground;
@property (nonatomic, strong)  IBOutlet UITableView *menuTableView;

@property (nonatomic, assign) BOOL showConoceTuEstiloOnMainMenu;
@property (nonatomic, assign) BOOL showAparienciaOnMainMenu;

//CoreData managedObjectContext
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

//mainMenus ViewControllers
@property (nonatomic, strong)  PrendasViewController *prendasViewController;
@property (nonatomic, strong)  ConjuntosViewController *conjuntosViewController;
@property (nonatomic, strong)  CalendarViewController *calendarViewController;
@property (nonatomic, strong)  ProfileViewController *profileViewController;
@property (nonatomic, strong)  StylesViewController *stylesViewController;
@property (nonatomic, strong)  YourStyleViewController *yourStyleViewController;
@property (nonatomic, strong)  helpViewController *myHelpViewController;
@property (nonatomic, strong)  PrendasMisMarcasViewController *misMarcasViewController;
@property (nonatomic, strong)  CustomNavigationController *currentNavController;


-(UIImage*) createThumbnailFromImage:(UIImage*)imageToThumbnail withSize:(NSInteger)thumbnailSize;


#pragma mark - Delegate methods
-(void)moveMainViewToRight:(BOOL)move;
-(void)moveMainViewToFullRight:(BOOL)move;
-(void) changeToVC:(NSInteger)indexVC;
-(void)clearAllViewControllers;


@end
