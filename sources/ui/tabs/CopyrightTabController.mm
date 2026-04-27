//
//  CopyrightTabController.m
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CopyrightTabController.h"

@implementation CopyrightTabController

static NSString *UTF8(const std::string &s) {
    return [[NSString alloc] initWithBytes:s.data()
                                     length:s.size()
                                   encoding:NSUTF8StringEncoding] ?: @"";
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return infoCollection.size();
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if (row < 0 || row >= infoCollection.size()) return 20.0;

    NSString *text = [self tableView:tableView objectValueForTableColumn:[tableView tableColumnWithIdentifier:@"info"] row:row];
    
    if (!text || text.length == 0) return 25.0;

    NSTableColumn *column = [tableView tableColumnWithIdentifier:@"info"];
    CGFloat width = column ? column.width : 300.0;

    NSFont *font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
    NSDictionary *attributes = @{NSFontAttributeName: font};

    NSRect rect = [text boundingRectWithSize:NSMakeSize(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes];

    return MAX(25.0, rect.size.height + 15.0);
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (row >= infoCollection.size()) return nil;
    
    TrackAndInfo &item = infoCollection[row];
    NSString *columnID = [tableColumn identifier];

    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    if ([currentLanguage hasPrefix:@"en"]) {
        if ([columnID isEqualToString:@"track"]) {
            
            return [NSString stringWithFormat:@"%@ - %@", UTF8(item.track.artist.c_str()), UTF8(item.track.track.c_str())];
        }
        
        else if ([columnID isEqualToString:@"info"]) {
            NSMutableString *resultString = [NSMutableString string];

            if (!item.info.MB_info.empty()) {
                [resultString appendString:@"--- MusicBrainz ---\n"];
                for (const auto& mb : item.info.MB_info) {
                    [resultString appendFormat:@"Status: %@\nISRC: %@\n",
                                  UTF8(mb.status.c_str()),
                                  UTF8(mb.isrc.c_str())];
                }
            }

            if (!item.info.DC_info.empty()) {
                // NSLog(@"записей Discogs: %lu", item.info.DC_info.size());
                if (resultString.length > 0) [resultString appendString:@"\n"];
                [resultString appendString:@"--- Discogs ---\n"];
                for (const auto& dc : item.info.DC_info) {
                    [resultString appendFormat:@"Label: %@\nBarcode: %@\n\n",
                                  UTF8(dc.label.c_str()),
                                  UTF8(dc.barcode.c_str())];
                }
            }

            if (resultString.length == 0) return @"No data found.";
            
            return [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    
    if ([currentLanguage hasPrefix:@"ru"]) {
        if ([columnID isEqualToString:@"track"]) {
            
            return [NSString stringWithFormat:@"%@ - %@", UTF8(item.track.artist.c_str()), UTF8(item.track.track.c_str())];
        }
        
        else if ([columnID isEqualToString:@"info"]) {
            NSMutableString *resultString = [NSMutableString string];

            if (!item.info.MB_info.empty()) {
                [resultString appendString:@"--- MusicBrainz ---\n"];
                for (const auto& mb : item.info.MB_info) {
                    [resultString appendFormat:@"Статус: %@\nISRC: %@\n",
                                  UTF8(mb.status.c_str()),
                                  UTF8(mb.isrc.c_str())];
                }
            }

            if (!item.info.DC_info.empty()) {
                // NSLog(@"записей Discogs: %lu", item.info.DC_info.size());
                if (resultString.length > 0) [resultString appendString:@"\n"];
                [resultString appendString:@"--- Discogs ---\n"];
                for (const auto& dc : item.info.DC_info) {
                    [resultString appendFormat:@"Лейбл: %@\nШтрихкод: %@\n\n",
                                  UTF8(dc.label.c_str()),
                                  UTF8(dc.barcode.c_str())];
                }
            }

            if (resultString.length == 0) return @"Информация не найдена.";
            
            return [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    
    return nil;
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSInteger movement = [[[obj userInfo] valueForKey:@"NSTextMovement"] integerValue];
    
    if (movement == NSReturnTextMovement) {
        NSString *artist = [self.artistField stringValue];
        NSString *track = [self.trackField stringValue];
        
        if (artist.length > 0 && track.length > 0) {
            __weak CopyrightTabController *weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                CopyrightTabController *strongSelf = weakSelf;
                if (!strongSelf) return;
                
                std::string result = strongSelf->networkManager.recordingSearcher([artist UTF8String], [track UTF8String]);
                
                std::cout << result << std::endl;
                
                strongSelf->infoCollection.clear();
                strongSelf->loader.JSON_sort(result, strongSelf->infoCollection);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.tableView reloadData];
                });
            });
        }
        
        
    }
}

- (void)copy:(id)sender {
    NSIndexSet *selectedRows = [self.tableView selectedRowIndexes];
    if (selectedRows.count == 0) return;

    NSMutableArray *allContent = [NSMutableArray array];
    NSArray *columns = [self.tableView tableColumns];

    [selectedRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        for (NSTableColumn *col in columns) {
            NSString *value = [self tableView:self.tableView objectValueForTableColumn:col row:idx];
            if (value && value.length > 0) {
                [allContent addObject:value];
            }
        }
    }];

    NSString *fullString = [allContent componentsJoinedByString:@"\n\n\n"];

    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard declareTypes:@[NSPasteboardTypeString] owner:nil];
    [pasteboard setString:fullString forType:NSPasteboardTypeString];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    if (menuItem.action == @selector(copy:)) {
        return [self.tableView numberOfSelectedRows] > 0;
    }
    return YES;
}

- (IBAction)openCopyrightHelpWindow:(id)sender {
    NSWindow *helpWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 450, 500)
                                                     styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable)
                                                       backing:NSBackingStoreBuffered
                                                         defer:NO];
    // [helpWindow center];
    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    if ([currentLanguage hasPrefix:@"en"]) {
        NSURL *rtfURL = [[NSBundle mainBundle] URLForResource:@"copyright-help" withExtension:@"rtf"];
        
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
            
        
        self.copyrightHelpWindowController = [[NSWindowController alloc] initWithWindow:helpWindow];
        [self.copyrightHelpWindowController showWindow:self];
        }
    }
    
    if ([currentLanguage hasPrefix:@"ru"]) {
        NSURL *rtfURL = [[NSBundle mainBundle] URLForResource:@"copyright-help-ru" withExtension:@"rtf"];
        
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
            
        
        self.copyrightHelpWindowController = [[NSWindowController alloc] initWithWindow:helpWindow];
        [self.copyrightHelpWindowController showWindow:self];
        }
    }
}
@end
