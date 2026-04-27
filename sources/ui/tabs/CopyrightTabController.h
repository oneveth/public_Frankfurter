//
//  CopyrightTabController.h
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#ifndef CopyrightTabController_h
#define CopyrightTabController_h

#import <Cocoa/Cocoa.h>
#import "NetworkManager.hpp"
#import "Track.hpp"
#import "JSONLoader.hpp"

@interface CopyrightTabController : NSViewController <NSTableViewDataSource> {
    NetworkManager networkManager;
    
    JSONLoader loader;
    
    std::vector<TrackAndInfo> infoCollection;
    
}

@property (weak) IBOutlet NSTextField *artistField;
@property (weak) IBOutlet NSTextField *trackField;
@property (weak) IBOutlet NSTableView *tableView;


@property (weak) IBOutlet NSButton *copyrightHelpButton;
@property (strong) NSWindowController *copyrightHelpWindow;
@property (strong) NSWindowController *copyrightHelpWindowController;

- (IBAction)openCopyrightHelpWindow:(id)sender;

@end

#endif /* CopyrightTabController_h */
