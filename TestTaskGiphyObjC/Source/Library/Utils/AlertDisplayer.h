//
//  AlertDisplayer.h
//  TestTaskAlarStudiosObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2019 varton. All rights reserved.
//

static inline void AlertDisplayer(UIViewController *view, NSString *reason)
{
    if (nil == view.presentedViewController)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:reason
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [view presentViewController:alert animated:YES completion:nil];
    }
}
