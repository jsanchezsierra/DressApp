//
//  PreviewImagePicker.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 1/30/12.
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


#import "PreviewImagePicker.h"

@implementation PreviewImagePicker
@synthesize delegate;
@synthesize previewCameraImage,previewCameraImageView;
@synthesize cropImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [UIApplication sharedApplication].statusBarHidden=YES;

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
 
    initialCropTouchType=InitialCropTouchOfTypeNone;
    
    //Init cropimage Size
    self.cropImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30,45,260,346)];
    cropImageView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:cropImageView];
    
    //Ini cropImage Views
    cropBackgroundColor=[UIColor colorWithRed:0. green:0 blue:0 alpha:0.75];
    
    topCropView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [topCropView setBackgroundColor:cropBackgroundColor];
    
    bottonCropView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [bottonCropView setBackgroundColor:cropBackgroundColor];
    
    leftCropView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [leftCropView setBackgroundColor:cropBackgroundColor];
    
    rightCropView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [rightCropView setBackgroundColor:cropBackgroundColor];
    
    [self.view addSubview:topCropView];
    [self.view addSubview:bottonCropView];
    [self.view addSubview:leftCropView];
    [self.view addSubview:rightCropView];
 
    //Zoom ImageView
    zoomImageView = [ [UIImageView alloc] initWithImage:[StyleDressApp imageWithStyleNamed:@"CODetailPrendaSelectedScale"]];
    [self.view addSubview:zoomImageView];
    //Move ImageView
    moveImageView = [ [UIImageView alloc] initWithImage:[StyleDressApp imageWithStyleNamed:@"CODetailPrendaSelectedMove"]];
    [self.view addSubview:moveImageView];
    
    [self checkAndDrawCropArea];
    
    [UIApplication sharedApplication].statusBarHidden=YES;
    
    self.wantsFullScreenLayout=YES;
    
    previewScale=1;   // 320x435
    
    //Asigno imagen original a la imagen, para ser modificada.
    self.previewCameraImage=[self createThumbnailFromImage:previewCameraImage withSize: PIC_SIZE_STANDARD_CROP]; //Height //PIC_SIZE_STANDARD
    [self.previewCameraImageView setImage:previewCameraImage];


    //Add UIActivityView Indicator
    cameraActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [cameraActivityView setFrame:CGRectMake(141,180,31,31)];
    [cameraActivityView setHidesWhenStopped:YES];
    [cameraActivityView stopAnimating];
    [self.view addSubview:cameraActivityView];
    
    
    //My Camera Toolbar
    UIToolbar *previewCameraToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,436,320,44)];
    [previewCameraToolBar  setTintColor:[ StyleDressApp colorWithStyleForObject:StyleColorMainNavigationBar] ];

    //My Camera Toolbar repeat
    UIBarButtonItem *previewRepeatBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"RepeatPicture", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(repeatPicturePressed) ];

    UIBarButtonItem *previewUseBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"UsePicture", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(usePicturePressed) ];

    //My Camera Toolbar addItems to Toolbar  
    NSArray *items=[NSArray arrayWithObjects:
                    previewRepeatBarButton,
					[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil] ,
					previewUseBarButton ,
					nil];
    [previewCameraToolBar setItems:items];
    
    //My Camera View addToolbar  
    [self.view addSubview:previewCameraToolBar];

    //ToolbarText
    UILabel *moveLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 445, 200,22)];
    moveLabel.font=[UIFont boldSystemFontOfSize:18];
    moveLabel.backgroundColor=[UIColor clearColor];
    moveLabel.textColor=[UIColor whiteColor];
    moveLabel.textAlignment=UITextAlignmentCenter;
     moveLabel.text=NSLocalizedString(@"ResizePicture",@"");
    [self.view addSubview:moveLabel];

   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)repeatPicturePressed
{
    [self.delegate previewRetakePicture];
}

-(void)usePicturePressed
{
    
    [cameraActivityView startAnimating];
    cropImageView.frame=CGRectMake(cropImageView.frame.origin.x*previewScale, cropImageView.frame.origin.y*previewScale, cropImageView.frame.size.width*previewScale, cropImageView.frame.size.height*previewScale);
    CGImageRef sourceImageRef=[[previewCameraImageView image] CGImage];
	CGImageRef newImageRef=CGImageCreateWithImageInRect(sourceImageRef,cropImageView.frame);
	UIImage *newImage=[UIImage imageWithCGImage:newImageRef];
	CGImageRelease(newImageRef);

    [self performSelector:@selector(sendImageToDelegate:) withObject:newImage afterDelay:0.05];

}


-(void) sendImageToDelegate:(UIImage*)newImage
{
    [self.delegate previewDidFinishWithImage:newImage];
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


-(void)checkAndDrawCropArea
{
 
    if (cropImageView.frame.origin.x<0) 
        [cropImageView setFrame:CGRectMake(0,cropImageView.frame.origin.y,cropImageView.frame.size.width,cropImageView.frame.size.height)];
    else if (cropImageView.frame.origin.y<0) 
        [cropImageView setFrame:CGRectMake(cropImageView.frame.origin.x,0,cropImageView.frame.size.width,cropImageView.frame.size.height)];
    else if ( (cropImageView.frame.origin.x+ cropImageView.frame.size.width) > self.previewCameraImageView.frame.size.width) 
        
        [cropImageView setFrame:CGRectMake(self.previewCameraImageView.frame.size.width- cropImageView.frame.size.width,cropImageView.frame.origin.y,cropImageView.frame.size.width,cropImageView.frame.size.height)];
    
    else if ( (cropImageView.frame.origin.y+ cropImageView.frame.size.height) > self.previewCameraImageView.frame.size.height) 

        [cropImageView setFrame:CGRectMake( cropImageView.frame.origin.x    , self.previewCameraImageView.frame.size.height-cropImageView.frame.size.height,cropImageView.frame.size.width,cropImageView.frame.size.height)];


    [topCropView setFrame:CGRectMake(0,0,320,self.cropImageView.frame.origin.y)];
    [bottonCropView setFrame:CGRectMake(0,self.cropImageView.frame.origin.y+self.cropImageView.frame.size.height,320, self.previewCameraImageView.frame.size.height -  self.cropImageView.frame.origin.y - self.cropImageView.frame.size.height)];
    
    [leftCropView setFrame:CGRectMake(0,self.cropImageView.frame.origin.y,self.cropImageView.frame.origin.x,self.cropImageView.frame.size.height)];

    [rightCropView setFrame:CGRectMake(self.cropImageView.frame.origin.x+self.cropImageView.frame.size.width,self.cropImageView.frame.origin.y,self.previewCameraImageView.frame.size.width- cropImageView.frame.size.width-cropImageView.frame.origin.x,self.cropImageView.frame.size.height)];

    [moveImageView setFrame:CGRectMake(self.cropImageView.frame.origin.x+self.cropImageView.frame.size.width/2-14, self.cropImageView.frame.origin.y+self.cropImageView.frame.size.height/2-14, 28,28)];

    [zoomImageView setFrame:CGRectMake(self.cropImageView.frame.origin.x+self.cropImageView.frame.size.width-14, self.cropImageView.frame.origin.y+self.cropImageView.frame.size.height-14, 28,28)];
    
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (  [touches count] > 0) {
        for (UITouch *touch in touches) 
        {
            firstLocation = [touch locationInView: self.view];

            NSInteger zoomSize=25;
            NSInteger zoomFrameX=self.cropImageView.frame.origin.x+self.cropImageView.frame.size.width;
            NSInteger zoomFrameY=self.cropImageView.frame.origin.y+self.cropImageView.frame.size.height;
            
            CGRect zoomFrame= CGRectMake(zoomFrameX-zoomSize,zoomFrameY-zoomSize,zoomFrameX+zoomSize,zoomFrameY+zoomSize);
            
            initialCropTouchType=InitialCropTouchOfTypeNone;

            if (CGRectContainsPoint(zoomFrame, firstLocation)) 
                initialCropTouchType=InitialCropTouchOfTypeScale;
            else if (CGRectContainsPoint(self.cropImageView.frame, firstLocation)) 
                initialCropTouchType=InitialCropTouchOfTypeMove;
            
         }
        
    }
}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location, previouslocation;
    
    
    if (  [touches count] > 0) 
    {
        for (UITouch *touch in touches) 
        {
            
            location = [touch locationInView: self.view];
            previouslocation = [touch previousLocationInView: self.view];
            float deltax= location.x-previouslocation.x;
            float deltay= location.y-previouslocation.y;
          
            if (initialCropTouchType==InitialCropTouchOfTypeMove) 
            {
                    
                self.cropImageView.frame= CGRectMake(self.cropImageView.frame.origin.x+deltax , self.cropImageView.frame.origin.y+deltay, self.cropImageView.frame.size.width, self.cropImageView.frame.size.height);
                
                [self checkAndDrawCropArea];
                    
            }else  if (initialCropTouchType==InitialCropTouchOfTypeScale) 
            {
                                        
                self.cropImageView.frame= CGRectMake(self.cropImageView.frame.origin.x , self.cropImageView.frame.origin.y, self.cropImageView.frame.size.width+ deltax, self.cropImageView.frame.size.height+deltay);
                [self checkAndDrawCropArea];
                    
            }
                
               
        }
    }
}


-(UIImage*) createThumbnailFromImage:(UIImage*)imageToThumbnail withSize:(NSInteger)thumbnailSize
{
    // Create a thumbnail version of the image for the recipe object.
    CGSize size = imageToThumbnail.size;
    CGFloat ratio = 0;
    if (size.width > size.height) 
        ratio = thumbnailSize / size.width;
    else 
        ratio = thumbnailSize / size.height;
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
    UIGraphicsBeginImageContext(rect.size);
    [imageToThumbnail drawInRect:rect];
    UIImage *thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnailImage;
}

@end
