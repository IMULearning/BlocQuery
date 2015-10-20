//
//  AppDelegate.m
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ParseErrorHandler.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self setupParse];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn) name:BQUserLoggedInNotification object:nil];
    
    if ([PFUser currentUser]) {
        self.window.rootViewController = [self questionController];
    } else {
        self.window.rootViewController = [self loginViewController];
    }
    
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

#pragma mark - Setup Parse

- (void) setupParse {
    NSDictionary *parseInfo = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Parse"];
    [Parse setApplicationId:parseInfo[@"ApplicationId"] clientKey:parseInfo[@"ClientKey"]];
}

#pragma mark - UI

- (UIViewController *) loginViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    return loginVC;
}

- (UIViewController *) mainController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UISplitViewController *splitVC = [storyboard instantiateViewControllerWithIdentifier:@"MainSplitViewController"];
    return splitVC;
    
}

- (UIViewController *) questionController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Question" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"QuestionViewController"];
}

- (void) userLoggedIn {
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        self.window.rootViewController = [self questionController];
        [UIView setAnimationsEnabled:oldState];
    } completion:nil];
}

@end
