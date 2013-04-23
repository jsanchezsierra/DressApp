//
//  AppDelegate.m
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


#import "AppDelegate.h"
#import "Authenticacion.h"
#import "ProfileViewController.h"
#import "PrendasViewController.h"
#import "PrendasAlbumViewController.h"
#import "StyleDressApp.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
 

#pragma mark - Application didFinishLaunchingWithOptions

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self setUserDefaults];

    //Add MainView View controller. Side Menu
    MainMenuViewController *mainMenuVB = [[MainMenuViewController alloc] 
                                          initWithNibName:@"MainMenuViewController" bundle:nil];
    mainMenuVB.managedObjectContext=self.managedObjectContext;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = mainMenuVB;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;

}

#pragma mark - Application UserDefaults init

//call didFinishLaunchingWithOptions when the user change the app style
-(void) resetSyle
{
    [self application:nil didFinishLaunchingWithOptions:nil];
    
}

//set initial NSUserdefaults
-(void) setUserDefaults
{
    
    //Check App Version. CHECK IF THE USER HAS UPDATED THE APP FROM THE APPLE STORE
    //La primera vez que se instala la App, no existe "DressAppVersion". Se crea y se asigna isVersionUpdatedForRestore=YES   
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DressAppVersion"]==nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"DressAppVersion"] isEqualToString:@""] ) 
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isVersionUpdatedForRestore"];
        [[NSUserDefaults standardUserDefaults] setObject:[ [[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"DressAppVersion"];
        
        [StyleDressApp setStyle:StyleTypeVintage];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[StyleDressApp getStyle] ] forKey:@"DressAppStyle"];
        
    }else //Si ha habido un cambio de version
    {
        //Si el numero de versión no coincide con el último -> 
        //isVersionUpdatedForRestore=YES    
        if ( ![[[NSUserDefaults standardUserDefaults] objectForKey:@"DressAppVersion"] isEqualToString:[ [[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]) 
        {
            [[NSUserDefaults standardUserDefaults] setObject:[ [[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"DressAppVersion"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isVersionUpdatedForRestore"];
            
            [StyleDressApp setStyle:StyleTypeVintage];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[StyleDressApp getStyle] ] forKey:@"DressAppStyle"];
            
        }
    }
    
    
    //App Skin Styles
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DressAppStyle"]==nil )
    {
        [StyleDressApp setStyle:StyleTypeVintage];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[StyleDressApp getStyle] ] forKey:@"DressAppStyle"];
    }else
    {
        [StyleDressApp setStyle:[[[NSUserDefaults standardUserDefaults] objectForKey:@"DressAppStyle"] intValue]  ];
    }
    
    //App Styles. Están abiertos los dos primeros por defecto
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isStyle1Open"]==nil )
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isStyle1Open"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isStyle2Open"]==nil )
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isStyle2Open"];
    
    
    //Flag para mostrar/ocultar icono de slider en prendas
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showPrendasSliderCounter"]==nil )
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"showPrendasSliderCounter"];
    
    //Flag para mostrar/ocultar icono de slider en conjuntos
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showConjuntosSliderCounter"]==nil )
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"showConjuntosSliderCounter"];
    
    
    
    //variable userToCheck
    //LOGGEDUSER_ONLY: Las peticiones de usuario solo se refieren al USUARIO LOGEADO
    //LOGGEDUSER_AND_DEFAULT: Las peticiones de usuario se refieren al USUARIO LOGEADO y al usuario DEFAULT
    //[[NSUserDefaults standardUserDefaults] setObject:@"LOGGEDUSER_AND_DEFAULT" forKey:@"userToCheck"];
    [[NSUserDefaults standardUserDefaults] setObject:@"LOGGEDUSER_ONLY" forKey:@"userToCheck"];
    
    
    //SORTING DEFAULT OPTIONS
    //SORT TYPE INIT --> SortType=2 corresponde a ordenar por fecha de creacción
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sortType"]==nil  ) 
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:2] forKey:@"sortType"];
    }
    
    //SORT SHOW FIELDS INIT
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showSortNotes"]==nil  ) 
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"showSortNotes"];
    }
    
    //SORT ASCENDING
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sortAscending"]==nil  ) 
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"sortAscending"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:DRESSAPP_DEFAULT_USER forKey:@"username" ];

    [UIApplication sharedApplication].statusBarHidden=NO;

}

 #pragma mark - Application lifeclycle

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}



#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DressApp" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    //Añadir dictionary options de migracion
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
        [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    if (__persistentStoreCoordinator != nil)
        return __persistentStoreCoordinator;
    
    NSURL *storeURL = [[self applicationCachesDirectory] URLByAppendingPathComponent:@"DressApp.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    //migration options are included 
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
     
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

//save managedObjectContext
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            abort();
        } 
    }
}

#pragma mark - Application's Documents directory


// Returns the URL to the application's Caches directory.
// The database is stored in caches directory. No copied to iCloud
- (NSURL *)applicationCachesDirectory 
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
