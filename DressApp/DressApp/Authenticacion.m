//
//  Authenticacion.m
//  DressApp
//
//  Created by Javier Sanchez Sierra on 1/1/12.
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


#import "Authenticacion.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation Authenticacion
 
+ (NSString *)getSH1ForUser:(NSString *)username andIdentifier:(NSString*)identifier 
{
    NSString *result = nil;
    NSString *stringToConvert = [NSString stringWithFormat:@"%@ %@",username,identifier ];       
    
    if(stringToConvert) 
    {
        unsigned char digest[CC_SHA1_DIGEST_LENGTH];
        NSData *stringBytes = [stringToConvert dataUsingEncoding: NSUTF8StringEncoding]; 
        if (CC_SHA1([stringBytes bytes], [stringBytes length], digest)) 
        {
            result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      digest[0], digest[1],
                      digest[2], digest[3],
                      digest[4], digest[5],
                      digest[6], digest[7],
                      digest[8], digest[9],
                      digest[10], digest[11],
                      digest[12], digest[13],
                      digest[14], digest[15],
                      digest[16], digest[17],
                      digest[18], digest[19]];
        }
    }
    
    return result;
}

    
+(void) removeFromCachesDirectoryImageWithName:(NSString*) imageName
{
    NSString *cachesDirectory;
    cachesDirectory= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    //Remove prenda pictures from cachesDirectory
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png",imageName] ]; 
    NSString *imagePathSmall = [cachesDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@_small.png",imageName] ]; 

    NSError * removeError;
    if ( [fileManager fileExistsAtPath:imagePath] ) 
        [fileManager  removeItemAtPath:imagePath error:&removeError];
    
    if ( [fileManager fileExistsAtPath:imagePathSmall] ) 
        [fileManager  removeItemAtPath:imagePathSmall error:&removeError];
}


@end
