//
//  LicenseTabController.m
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LicenseTabController.h"

static NSString *const UsageTypeChangedNotification = @"UsageTypeChangedNotification";

@implementation LicenseTabConstoller{
}

- (void)viewDidLoad {
    [super viewDidLoad];

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

- (IBAction)applyButtonPressed:(id)sender {
    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    if ([currentLanguage hasPrefix:@"en"]) {
        NSInteger usageIndex = [self.usageTypePopUpButton indexOfSelectedItem];
        
        LicenseResult result = determineRequiredLicenses((UsageType)usageIndex);
        
        NSMutableString *displayText = [NSMutableString stringWithString:@"Required licenses:\n\n"];
        
        for (auto& i : result.licenses){
            [displayText appendFormat:@"• %@\n", [NSString stringWithUTF8String:i.name.c_str()]];
            [displayText appendFormat:@"  Method: %@\n", [self stringFromMethod:i.method]];
            [displayText appendFormat:@"  Note: %@\n\n", [NSString stringWithUTF8String:i.description.c_str()]];
        }
        
        [self.outputTextView setString:displayText];
    }
    
    if ([currentLanguage hasPrefix:@"ru"]) {
        NSInteger usageIndex = [self.usageTypePopUpButton indexOfSelectedItem];
        
        LicenseResult result = determineRequiredLicenses_ru((UsageType)usageIndex);
        
        NSMutableString *displayText = [NSMutableString stringWithString:@"Требуемые лицензии:\n\n"];
        
        for (auto& i : result.licenses){
            [displayText appendFormat:@"• %@\n", [NSString stringWithUTF8String:i.name.c_str()]];
            [displayText appendFormat:@"  Способ: %@\n", [self stringFromMethod:i.method]];
            [displayText appendFormat:@"  Примечание: %@\n\n", [NSString stringWithUTF8String:i.description.c_str()]];
        }
        
        [self.outputTextView setString:displayText];
    }
}

- (IBAction)popUpButtonAction:(id)sender {
    NSInteger index = [self.usageTypePopUpButton indexOfSelectedItem];
    NSDictionary *userInfo = @{@"index": @(index)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UsageTypeChangedNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (NSString *)stringFromMethod:(AcquisitionMethod)method {
    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    if ([currentLanguage hasPrefix:@"en"]) {
        switch (method) {
            case AcquisitionMethod::AUTOMATIC:   return @"Automatic (DistroKid/HFA)";
            case AcquisitionMethod::COMPULSORY:  return @"Compulsory (mechanical, at fixed rate)";
            case AcquisitionMethod::NEGOTIATION: return @"Direct negotiation";
            case AcquisitionMethod::PRO_ADMIN:   return @"Managed by PRO (ASCAP/BMI/РАО)";
            default: return @"Unknown";
        }
    }
    
    if ([currentLanguage hasPrefix:@"ru"]) {
        switch (method) {
            case AcquisitionMethod::AUTOMATIC:   return @"Автоматически (DistroKid/HFA)";
            case AcquisitionMethod::COMPULSORY:  return @"Compulsory (автоматически, по фиксированной ставке)";
            case AcquisitionMethod::NEGOTIATION: return @"Прямые переговоры";
            case AcquisitionMethod::PRO_ADMIN:   return @"Обеспечивается площадкой через PRO (ASCAP/BMI/РАО)";
            default: return @"Неизвестно";
        }
    }
    return @"Unknown";
}

- (IBAction)openHelpWindow:(id)sender {
    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    if ([currentLanguage hasPrefix:@"en"]) {
        NSWindow *helpWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 450, 500)
                                                         styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable)
                                                           backing:NSBackingStoreBuffered
                                                             defer:NO];
        // [helpWindow center];
        
        NSURL *rtfURL = [[NSBundle mainBundle] URLForResource:@"license-help" withExtension:@"rtf"];
        
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
            
        
        self.helpWindowController = [[NSWindowController alloc] initWithWindow:helpWindow];
        [self.helpWindowController showWindow:self];
        }
    }
    
    if ([currentLanguage hasPrefix:@"ru"]) {
        NSWindow *helpWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 450, 500)
                                                         styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable)
                                                           backing:NSBackingStoreBuffered
                                                             defer:NO];
        // [helpWindow center];
        
        NSURL *rtfURL = [[NSBundle mainBundle] URLForResource:@"license-help-ru" withExtension:@"rtf"];
        
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
            
        
        self.helpWindowController = [[NSWindowController alloc] initWithWindow:helpWindow];
        [self.helpWindowController showWindow:self];
        }
    }
}


@end
