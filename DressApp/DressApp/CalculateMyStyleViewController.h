//
//  CalculateMyStyleViewController.h
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
#import "UIActionView.h"
#import <MessageUI/MessageUI.h>
#import "ShareFacebookTwitter.h"

@interface CalculateMyStyleViewController :UIViewController <UIActionViewDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate,ShareFacebookTwitterDelegate> 
{
    NSInteger isAtleticaCount;
    NSInteger isClasicaCount;
    NSInteger isFashionCount;
    NSInteger isHippieCount;
    NSInteger isVanguardistaCount;
    NSInteger isRomanticaCount;
    NSInteger maximunCount;
    NSInteger maximunIndex;
    
}

//Delegate
@property (nonatomic, assign) id<MenuProtocolDelegate>delegate;

//CoreData managedObjectContext
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

//Others
@property (nonatomic) BOOL isRight;

//Container View
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *myActionViewActivity;
@property (nonatomic, strong) IBOutlet UIImageView *myImageViewBackground;
@property (nonatomic, strong) IBOutlet UITextView *resultTitle;
@property (nonatomic, strong) IBOutlet UITextView *resultMsg1;
@property (nonatomic, strong) IBOutlet UITextView *resultMsg2;
@property (nonatomic, strong) IBOutlet UIImageView *resultStyleImage;
@property (nonatomic, strong) IBOutlet UIToolbar *mainToolbar;
@property (nonatomic, strong) IBOutlet UIButton *btnCompartir;

@property (nonatomic, strong) UIActionView *myActionViewCompartir;
@property (nonatomic, strong) UIView *myNavigationViewBackground;

-(void) calculateStyle;
-(void) updateMaximunWithIndex:(NSInteger)index;
-(IBAction)btnPressed:(UIButton*)sender;
-(void)openActionSheet;
-(void) sendStyleToFacebook;
-(void) sendStyleToTwitter;
-(void) sendStyleToEmail;
-(NSString *) getUrlEncoded:(NSString*)inputString;
-(void) accessFacebookAPIForPostingKnowYourStyle;
-(void) accessFacebookFailed;

 
@end
