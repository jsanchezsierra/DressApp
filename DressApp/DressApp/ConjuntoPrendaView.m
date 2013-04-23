//
//  ConjuntoPrendaView.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 11/2/11.
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


#import "ConjuntoPrendaView.h"
#import "StyleDressApp.h"

@implementation ConjuntoPrendaView
@synthesize delegate;
@synthesize prendaImageView;
@synthesize conjuntoPrenda;
@synthesize escala;
@synthesize prendaDeleted,isWaitingForDisappear;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void) initView
{
    
    initialTouchType=InitialTouchOfTypeNone;
    isCapturingFirstTouching=NO;
    isWaitingForDisappear=NO;
    isSelected=NO;
    isVibrating=NO;
    isScaled=NO;
    previousScale=0;
    prendaDeleted=NO;
 
    initialFrame=self.frame;

    prendaImageViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)  ];
    [prendaImageViewBackground setContentMode:UIViewContentModeScaleAspectFit];
    [prendaImageViewBackground setImage:[StyleDressApp imageWithStyleNamed:@"CODetailPrendaSelectedFrame"]];
    [prendaImageViewBackground setHidden:YES];
    [self addSubview:prendaImageViewBackground];
    
    
    prendaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)  ];
    [prendaImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:prendaImageView];
    
    [self updateImageViewsPosition];
    
    //NSTimer 
    NSTimeInterval timeInterval=0.01;
    timeCounterEnter=0;
    timeCounterExit=0;
    [myTimer invalidate];
    myTimer = nil;
    myTimer = [NSTimer timerWithTimeInterval:timeInterval  target:self selector:@selector(timeCounterCallBack) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];

    
}

-(void) updateImageViewsPosition
{
    //Actualiza posición de los controles de la vista (move,scale,remove)
    [self.delegate updateConjuntoPrendaViewControlPositionFromView:self setHidden:NO];

    prendaImageViewBackground.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [prendaImageView setFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)  ];
    
}


-(void) timeCounterCallBack
{
    if (prendaDeleted==NO) 
    {
        //CONTROL ENTER
        if (isCapturingFirstTouching==YES) {
            timeCounterEnter++;
        }
        
        if (timeCounterEnter>4)  //selecciona la prenda despues de 0.06 segundos
        {
            isCapturingFirstTouching=NO;
            timeCounterEnter=0;
            [self selectConjuntoPrenda];
        }   
        
        if (isWaitingForDisappear==YES) 
            timeCounterExit++;
        
        if (timeCounterExit>100) //100 //deseleciona la prenda despues de X segundos
        {
            [self.delegate enableScroll:YES ];
            [self.delegate updateConjuntoPrendaViewControlPositionFromView:self setHidden:YES];

            [self deselectConjuntoPrenda];
            timeCounterExit=0;
            isWaitingForDisappear=NO;
        }
 
    }    
}



-(void) selectConjuntoPrenda
{
    [self checkInitialTochType];
    [self.delegate enableScroll:NO ];
    [prendaImageViewBackground setHidden:NO];
    isSelected=YES;
    [self.delegate updateConjuntoPrendaViewControlPositionFromView:self setHidden:NO];
    
    if (prendaDeleted==NO) 
        [self.delegate deselectConjuntoPrendaViewsExceptThis:self];
}
 
-(void) deselectConjuntoPrenda
{
    [prendaImageViewBackground setHidden:YES];
    isSelected=NO;
}

  
-(void) checkInitialTochType
{
    
    CGFloat controlSizeWidth=25;
    if (   firstLocation.x <controlSizeWidth && firstLocation.x>-controlSizeWidth 
        && firstLocation.y <controlSizeWidth && firstLocation.y>-controlSizeWidth) 
    
        initialTouchType=InitialTouchOfTypeRemove;
    
    else if ( firstLocation.x >self.frame.size.width -controlSizeWidth && firstLocation.x <self.frame.size.width +controlSizeWidth 
             && firstLocation.y > self.frame.size.height- controlSizeWidth &&firstLocation.y <self.frame.size.height +controlSizeWidth) 
        initialTouchType=InitialTouchOfTypeScale;
    
    else if ( firstLocation.x >0 && firstLocation.x <=self.frame.size.width  
             && firstLocation.y > 0 &&firstLocation.y <=self.frame.size.height ) 
        initialTouchType=InitialTouchOfTypeMove;
    else
        initialTouchType=InitialTouchOfTypeNone;

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (  [touches count] > 0) {
        for (UITouch *touch in touches) 
        {
            
            if (prendaDeleted==NO) 
            {
                if (isCapturingFirstTouching==NO && isSelected==NO) 
                {
                    timeCounterEnter=0;
                    isCapturingFirstTouching=YES;
                    initialTouch=touch;
                    isWaitingForDisappear=NO;
                    firstLocation = [touch locationInView: self];

                }
                
                if ( isSelected==YES ) 
                {
                    isWaitingForDisappear=NO;
                    timeCounterExit=0;
                    [self.delegate enableScroll:NO ];
                    firstLocation = [touch locationInView: self];
                    initialTouch=touch;
                    
                    [self checkInitialTochType];
                    
                    if (initialTouchType==InitialTouchOfTypeRemove) 
                    {
                        prendaDeleted=YES;
                        [self.delegate removePrendaFromConjunto:conjuntoPrenda withView:self];
                    } 
                }
            }
 
            
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
            
            location = [touch locationInView: self];
            previouslocation = [touch previousLocationInView: self];
            float deltax= location.x-previouslocation.x;
            float deltay= location.y-previouslocation.y;

            if (prendaDeleted==NO) 
            {
                if (isSelected==YES && initialTouchType==InitialTouchOfTypeMove) 
                {
                    if ( (self.frame.origin.x +self.frame.size.width/2.0) >= 0 && (self.frame.origin.x + self.frame.size.width/2) <= 320  &&  (self.frame.origin.y +self.frame.size.height/2.0) >= 0 && (self.frame.origin.y +self.frame.size.height/2.0) <= 372)
                    {
                        
                        self.frame= CGRectMake(self.frame.origin.x+deltax , self.frame.origin.y+deltay, self.frame.size.width, self.frame.size.height);
                        [self updateImageViewsPosition];
                        [self.delegate ConjuntoPrendaViewDelegate:self didChangePrendaToPositionX:self.frame.origin.x positionY:self.frame.origin.y imageWidth:self.frame.size.width imageHeight:self.frame.size.height];
                    }  
                    if ( (self.frame.origin.x +self.frame.size.width/2) <= 0 ) 
                    {
                        
                        self.frame= CGRectMake(-self.frame.size.width/2 , self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                    }
                    if ( (self.frame.origin.x +self.frame.size.width/2) >=320 ) 
                    {
                        
                        self.frame= CGRectMake(318-self.frame.size.width/2 , self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                        
                    }
                    if ( (self.frame.origin.y +self.frame.size.height/2) <=0 ) 
                    {
                        
                        self.frame= CGRectMake(self.frame.origin.x, -self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
                    }
                    if ( (self.frame.origin.y +self.frame.size.height/2) >=372 ) 
                    {
                        
                        self.frame= CGRectMake(self.frame.origin.x, 370-self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
                    }
                    
                }else  if (isSelected==YES && initialTouchType==InitialTouchOfTypeScale) 
                {

                    float ratio= self.frame.size.width/self.frame.size.height;

                  
                    if ( (self.frame.origin.x +self.frame.size.width/2.0) >= 0 && (self.frame.origin.x + self.frame.size.width/2) <= 320  &&  (self.frame.origin.y +self.frame.size.height/2.0) >= 0 && (self.frame.origin.y +self.frame.size.height/2.0) <= 372)
                    {
                        //El zoom minimo está limitado a un ancho de 60 píxeles
                        if (self.frame.size.width+ deltax>60) 
                        {
                            self.frame= CGRectMake(self.frame.origin.x , self.frame.origin.y, self.frame.size.width+ deltax, self.frame.size.height+deltax/ratio);
                            [self updateImageViewsPosition];
                            [self.delegate ConjuntoPrendaViewDelegate:self didChangePrendaToPositionX:self.frame.origin.x positionY:self.frame.origin.y imageWidth:self.frame.size.width imageHeight:self.frame.size.height];
                            
                        }

                                               
                    }  
                    if ( (self.frame.origin.x +self.frame.size.width/2) <= 0 ) 
                    {
                        
                        self.frame= CGRectMake(-self.frame.size.width/2 , self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                    }
                    if ( (self.frame.origin.x +self.frame.size.width/2) >=320 ) 
                    {
                        
                        self.frame= CGRectMake(320-self.frame.size.width/2 , self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                    }
                    if ( (self.frame.origin.y +self.frame.size.height/2) <=0 ) 
                    {
                        
                        self.frame= CGRectMake(self.frame.origin.x, -self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
                    }
                    if ( (self.frame.origin.y +self.frame.size.height/2) >=372 ) 
                    {
                        
                        self.frame= CGRectMake(self.frame.origin.x, 372-self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
                    }
                }
                
                
            }
        }
    }
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    if (isCapturingFirstTouching) 
        isCapturingFirstTouching=NO;
    
    timeCounterExit=0;
    isWaitingForDisappear=YES;

}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
