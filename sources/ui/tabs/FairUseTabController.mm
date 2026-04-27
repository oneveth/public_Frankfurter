//
//  FairUseTabController.m
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 22/04/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#import "FairUseTabConstoller.h"
#import "FairUseEngine.hpp"
#import "FairUseResult.hpp"

static NSString *const UsageTypeChangedNotification = @"UsageTypeChangedNotification";

@implementation FairUseTabConstoller

- (IBAction)getUsageType:(id)sender {
    NSInteger index = [self.usageTypePopUpButton indexOfSelectedItem];
    NSDictionary *userInfo = @{@"index": @(index)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UsageTypeChangedNotification
                                                        object:self
                                                      userInfo:userInfo];
}
- (void)viewDidLoad {[super viewDidLoad];

    [self.usageTypePopUpButton removeAllItems];

    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    if ([currentLanguage hasPrefix:@"en"]) {
        NSArray *menuItems = @[
            @"Video-essay",
            @"Reaction video",
            @"Podcast",
            @"Cover",
            @"Film",
            @"Live performance",
            @"Sampling"
        ];

        [self.usageTypePopUpButton addItemsWithTitles:menuItems];
        
        [self.usageTypePopUpButton selectItemAtIndex:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(handleUsageTypeChange:)
                                                    name:UsageTypeChangedNotification
                                                  object:nil];
    }
    
    if ([currentLanguage hasPrefix:@"ru"]) {
        NSArray *menuItems = @[
            @"Видео-эссе",
            @"Видео-реакция",
            @"Подкаст",
            @"Кавер",
            @"Фильм",
            @"Живое выступление",
            @"Сэмплирование"
        ];

        [self.usageTypePopUpButton addItemsWithTitles:menuItems];
        
        [self.usageTypePopUpButton selectItemAtIndex:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(handleUsageTypeChange:)
                                                    name:UsageTypeChangedNotification
                                                  object:nil];
    }
}

- (void)handleUsageTypeChange:(NSNotification *)notification {
    
    NSNumber *indexNumber = notification.userInfo[@"index"];
    if (indexNumber) {
        NSInteger index = [indexNumber integerValue];
        
        if (self.usageTypePopUpButton.indexOfSelectedItem != index) {
            [self.usageTypePopUpButton selectItemAtIndex:index];
        }
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)getAmount:(id)sender {
    int value = [self.amountScroll intValue];
    [self.percentageTextField setIntValue:value];
}

- (IBAction)getTransformative:(id)sender {
}

- (IBAction)getParody:(id)sender {
}

- (IBAction)getCommercial:(id)sender {
}

- (IBAction)applyButtonAction:(id)sender {

    int percentValue = [self.amountScroll intValue];
    
    NSInteger usageIndex = [self.usageTypePopUpButton indexOfSelectedItem];

    BOOL isTransformative = ([self.isTransformativeTickBox state] == NSControlStateValueOn);
    BOOL isParody = ([self.isAParodyTickBox state] == NSControlStateValueOn);
    BOOL isCommercial = ([self.isCommercialTickBox state] == NSControlStateValueOn);
    
    FairUseInput fairInput;
    
    fairInput.amount = percentValue;
    fairInput.purpose = usageIndex;
    fairInput.isCommercial = isCommercial;
    fairInput.isParody = isParody;
    fairInput.isTransformative = isTransformative;
    
    FairUseEngine engine;
    
    self.score = engine.calculateFairUseScore(fairInput, (UsageType)usageIndex);
    
    NSLog(@"%.2f", self.score);
    
    [self.scoreLabel setFloatValue:self.score];
}

//- (void)collectCurrentSettings {
//    NSString *usageType = [self.usageTypePopUpButton titleOfSelectedItem];
//    NSInteger amount = [self.amountScroll integerValue];
//    BOOL isTransformative = ([self.isTransformativeTickBox state] == NSControlStateValueOn);
//    BOOL isParody = ([self.isAParodyTickBox state] == NSControlStateValueOn);
//    BOOL isCommercial = ([self.isCommercialTickBox state] == NSControlStateValueOn);
//
//    NSString *selectedUsage = [[self.usageTypePopUpButton selectedItem] title];
//    NSInteger usageIndex = [self.usageTypePopUpButton indexOfSelectedItem];
//}

- (IBAction)getPercentage:(id)sender {
    int value = [self.percentageTextField intValue];
    
    if (value < 0) value = 0;
    if (value > 100) value = 100;
    
    [self.percentageTextField setIntValue:value];
    [self.amountScroll setIntValue:value];
}

- (IBAction)setUIScore:(id)sender {
    [self.scoreLabel setFloatValue:self.score];
}

- (IBAction)openFairUseHelpWindow:(id)sender {
    NSWindow *helpWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 400, 500)
                                                     styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable)
                                                       backing:NSBackingStoreBuffered
                                                         defer:NO];
    // [helpWindow center];
    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    if ([currentLanguage hasPrefix:@"en"]) {
        NSURL *rtfURL = [[NSBundle mainBundle] URLForResource:@"fair-use-help" withExtension:@"rtf"];
        
        if (rtfURL) {
            NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:((NSView*)helpWindow.contentView).bounds];
            scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
            scrollView.hasVerticalScroller = YES;

            NSTextView *textView = [[NSTextView alloc] initWithFrame:scrollView.bounds];
            textView.editable = NO;
            textView.selectable = YES;
            textView.autoresizingMask = NSViewWidthSizable;
            
            
            [textView readRTFDFromFile:[rtfURL path]];
            
            [textView setTextColor:[NSColor labelColor]];
            
            textView.backgroundColor = [NSColor clearColor];
            textView.drawsBackground = NO;

            scrollView.documentView = textView;
            helpWindow.contentView = scrollView;
            
        
        self.fairUseHelpWindowController = [[NSWindowController alloc] initWithWindow:helpWindow];
        [self.fairUseHelpWindowController showWindow:self];
        }
    }
    
    if ([currentLanguage hasPrefix:@"ru"]) {
        NSURL *rtfURL = [[NSBundle mainBundle] URLForResource:@"fair-use-help-ru" withExtension:@"rtf"];
        
        if (rtfURL) {
            NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:((NSView*)helpWindow.contentView).bounds];
            scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
            scrollView.hasVerticalScroller = YES;

            NSTextView *textView = [[NSTextView alloc] initWithFrame:scrollView.bounds];
            textView.editable = NO;
            textView.selectable = YES;
            textView.autoresizingMask = NSViewWidthSizable;
            
            
            [textView readRTFDFromFile:[rtfURL path]];
            
            [textView setTextColor:[NSColor labelColor]];
            
            textView.backgroundColor = [NSColor clearColor];
            textView.drawsBackground = NO;

            scrollView.documentView = textView;
            helpWindow.contentView = scrollView;
            
        
        self.fairUseHelpWindowController = [[NSWindowController alloc] initWithWindow:helpWindow];
        [self.fairUseHelpWindowController showWindow:self];
        }
    }
}

@end
