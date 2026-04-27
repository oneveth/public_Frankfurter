//
//  FairUseTabConstoller.h
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 22/04/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#ifndef FairUseTabConstoller_h
#define FairUseTabConstoller_h

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "LicenseTabController.h"

@interface FairUseTabConstoller : NSViewController{
}

@property (nonatomic, assign) float score;

@property (weak) IBOutlet NSButton *fairUseHelpButton;
@property (strong) NSWindowController *fairUseHelpWindow;
@property (strong) NSWindowController *fairUseHelpWindowController;

- (IBAction)openFairUseHelpWindow:(id)sender;


@property (weak) IBOutlet NSPopUpButton *usageTypePopUpButton;
@property (weak) IBOutlet NSSlider *amountScroll;
@property (weak) IBOutlet NSButton *isTransformativeTickBox;
@property (weak) IBOutlet NSButton *isAParodyTickBox;
@property (weak) IBOutlet NSButton *isCommercialTickBox;
@property (weak) IBOutlet NSButton *applyButton;
@property (weak) IBOutlet NSTextField *percentageTextField;
@property (weak) IBOutlet NSTextField *scoreLabel;

- (IBAction)getUsageType:(id)sender;
- (IBAction)getAmount:(id)sender;
- (IBAction)getTransformative:(id)sender;
- (IBAction)getParody:(id)sender;
- (IBAction)getCommercial:(id)sender;
- (IBAction)applyButtonAction:(id)sender;
- (IBAction)getPercentage:(id)sender;
- (IBAction)setUIScore:(id)sender;

@end

#endif /* FairUseTabConstoller_h */
