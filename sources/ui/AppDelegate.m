//
//  AppDelegate.m
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
    
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.windowControllers = [NSMutableArray array];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)newDocument:(id)sender {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *wc = [storyboard instantiateControllerWithIdentifier:@"MainWindow"];
    
    if (wc) {
        if (!self.windowControllers) self.windowControllers = [NSMutableArray array];
        
        NSWindow *window = wc.window;
        
        static NSPoint lastTopLeft = { 0, 0 };
        
        if (self.windowControllers.count > 0) {
            
            NSWindowController *lastWC = [self.windowControllers lastObject];
            NSPoint lastPoint = [lastWC.window cascadeTopLeftFromPoint:NSZeroPoint];
            [window setFrameTopLeftPoint:lastPoint];
        } else {
            
            [window center];
        }

        [self.windowControllers addObject:wc];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowWillClose:)
                                                     name:NSWindowWillCloseNotification
                                                   object:window];
        
        [wc showWindow:self];
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    NSWindow *closedWindow = notification.object;
    
    for (NSWindowController *wc in [self.windowControllers copy]) {
        if (wc.window == closedWindow) {
            [self.windowControllers removeObject:wc];
            break;
        }
    }
}
@end
