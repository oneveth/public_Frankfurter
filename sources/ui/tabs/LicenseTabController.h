//
//  LicenseTabController.h
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//
#ifndef LicenseTabController_h
#define LicenseTabController_h

#import <AppKit/AppKit.h>

#import "FairUseTabConstoller.h"
#import "LicenseTypeDetermination.hpp"

@interface LicenseTabConstoller : NSViewController  {
    
}
@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;

@property (weak) IBOutlet NSPopUpButton *usageTypePopUpButton;
@property (weak) IBOutlet NSButton *applyButton;


@property (weak) IBOutlet NSButton *licenseHelpButton;
@property (strong) NSWindowController *helpWindow;
@property (strong) NSWindowController *helpWindowController;


- (IBAction)applyButtonPressed:(id)sender;
- (IBAction)popUpButtonAction:(id)sender;

- (IBAction)openHelpWindow:(id)sender;


@end

#endif /* LicenseTabController_h */
