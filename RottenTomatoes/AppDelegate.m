//
//  AppDelegate.m
//  RottenTomatoes
//
//  Created by Miles Spielberg on 2/2/15.
//  Copyright (c) 2015 OrionNet. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"
#import "UIImage+SVG.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIColor *masterTint = [UIColor colorWithRed:0.7 green:0.1 blue:0.1 alpha:1.0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSURL *boxOfficeEndpoint = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=38sbnkdmjjn89daz4w2z6dtm"];
    MoviesViewController *boxOfficeVC = [[MoviesViewController alloc] initWithEndpoint:boxOfficeEndpoint];
    boxOfficeVC.title = @"Box Office";
    UINavigationController *boxOfficeNvc = [[UINavigationController alloc] initWithRootViewController:boxOfficeVC];
    boxOfficeNvc.navigationBar.barStyle = UIBarStyleBlackOpaque;
    boxOfficeNvc.navigationBar.tintColor = masterTint;
    boxOfficeNvc.navigationBar.titleTextAttributes = @{
                                                       NSForegroundColorAttributeName: masterTint,
                                                       NSFontAttributeName: [UIFont fontWithName:@"Marker Felt" size:24.0]
                                                       };
    UIImage *boxOfficeImage = [UIImage imageWithSVGNamed:@"ticket" targetSize:CGSizeMake(30.0, 30.0) fillColor:[UIColor blackColor] cache:YES];
    boxOfficeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Box Office" image:boxOfficeImage selectedImage:nil];
    
    
    NSURL *topRentalsEndpoint = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=38sbnkdmjjn89daz4w2z6dtm"];
    MoviesViewController *topRentalsVC = [[MoviesViewController alloc] initWithEndpoint:topRentalsEndpoint];
    topRentalsVC.title = @"Top Rentals";
    UINavigationController *topRentalsNvc = [[UINavigationController alloc] initWithRootViewController:topRentalsVC];
    topRentalsNvc.navigationBar.barStyle = UIBarStyleBlackOpaque;
    topRentalsNvc.navigationBar.tintColor = masterTint;
    topRentalsNvc.navigationBar.titleTextAttributes = @{
                                                        NSForegroundColorAttributeName: masterTint,
                                                        NSFontAttributeName: [UIFont fontWithName:@"Marker Felt" size:24.0]
                                                        };
    UIImage *topRentalsImage = [UIImage imageWithSVGNamed:@"dvd" targetSize:CGSizeMake(30.0, 30.0) fillColor:[UIColor blackColor] cache:YES];
    topRentalsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Top Rentals" image:topRentalsImage selectedImage:nil];
    

    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.tabBar.barStyle = UIBarStyleBlack;
    tbc.tabBar.tintColor = masterTint;
    tbc.viewControllers = @[boxOfficeNvc, topRentalsNvc];
    
    
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
