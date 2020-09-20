//
//  AppDelegate.m
//  TestTaskAlarStudiosObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2019 varton. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    MainViewController *vc = [[MainViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
}

@end
