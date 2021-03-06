//
//  AppDelegate.m
//  SelectorBlock
//
//  Created by Jobs on 2021/2/18.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    ViewController *f = ViewController.new;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:f];
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
