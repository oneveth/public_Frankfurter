//
//  MainBridge.mm
//  project_Frankfurter
//
//  Created by Ivan Batrakov on 13/03/2026.
//  Copyright © 2026 on_eveth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainBridge.h"
#import "iostream"
#import "JSONLoader.hpp"

std::string MainBridge::MBrespondGetter(const std::string& rawURLString){
    
    // converting string to appropriate format
    NSString *rawURL = [NSString stringWithUTF8String: rawURLString.c_str()];
    
    NSString *percentedURL = [rawURL stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString: percentedURL];
    
    NSMutableURLRequest *URLrequest = [NSMutableURLRequest requestWithURL: url];

    [URLrequest setValue:@"ProjectFrankfurter/0.0.1 ( ikanavin-25@miigaik.ru )"
      forHTTPHeaderField:@"User-Agent"];
    
    // exit if something is incorrect with url
    if (!URLrequest){
        return "{}";
    }
    
    
    __block std::string resultString; // __block is for resultString variable to be edited inside of the completionHandler block (^)
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    // sending request
    [[[NSURLSession sharedSession] dataTaskWithRequest: URLrequest
                                completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data && !error){
            NSString *temporal = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (temporal){
                resultString = [temporal UTF8String];
            }
        }
        dispatch_semaphore_signal(sem);

    }] resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    
    std::string result = "{";
    result += "\"musicbrainz\":" + (resultString.empty() ? "{}" : resultString);
    result += "}";
    return result;
}


std::string MainBridge::respondGetter(const std::string& rawMBURLString, const std::string& rawDCURLString){
    
    // converting string to appropriate format
    NSString *rawMBURL = [NSString stringWithUTF8String: rawMBURLString.c_str()];
    NSString *rawDCURL = [NSString stringWithUTF8String: rawDCURLString.c_str()];
    
    NSString *percentedMBURL = [rawMBURL stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *percentedDCURL = [rawDCURL stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *MBurl = [NSURL URLWithString: percentedMBURL];
    NSURL *DCurl = [NSURL URLWithString: percentedDCURL];
    
    NSMutableURLRequest *MBURLrequest = [NSMutableURLRequest requestWithURL: MBurl];
    NSMutableURLRequest *DCURLrequest = [NSMutableURLRequest requestWithURL: DCurl];

    [MBURLrequest setValue:@"ProjectFrankfurter/0.0.1 ( ikanavin-25@miigaik.ru )"
        forHTTPHeaderField:@"User-Agent"];
    
    // exit if something is incorrect with url
    if (!MBURLrequest){
        return "{}";
    }
    /*
    if (DCURLrequest){
        [DCURLrequest setValue:@"Discogs token=YOUR_TOKEN"
            forHTTPHeaderField:@"Authorization"];
    }*/
    
    __block std::string MBresultString; // __block is for resultString variable to be edited inside of the completionHandler block (^)
    __block std::string DCresultString;
    
    dispatch_group_t group = dispatch_group_create();
    NSURLSession *session = [NSURLSession sharedSession];
    
    // sending request
    // MB
    dispatch_group_enter(group);
    [[session dataTaskWithRequest:MBURLrequest
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (data && !error) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (str) MBresultString = [str UTF8String];
        }

        dispatch_group_leave(group);
    }] resume];
    
    // DC
    if (DCURLrequest) {
        dispatch_group_enter(group);

        [[session dataTaskWithRequest:DCURLrequest
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

            if (data && !error) {
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (str) DCresultString = [str UTF8String];
            }

            dispatch_group_leave(group);
        }] resume];
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    std::string result = "{";
    result += "\"musicbrainz\":" + (MBresultString.empty() ? "{}" : MBresultString);

    if (DCURLrequest) {
        result += ",\"discogs\":" + (DCresultString.empty() ? "{}" : DCresultString);
    }

    result += "}";

    return result;
}
