//
//  SearchService.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/10/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "SearchService.h"

@interface SearchService ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SearchService

- (instancetype)init
{
    if (self = [super init]) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }

    return self;
}

- (void)searchGenreForTerm:(NSString *)term
{
    NSURL *URL = [self URLForSearchTerm:term limit:1];

    NSURLSessionDataTask *task = [self.session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *sessionError) {
        if (nil == sessionError) {
            NSError *serializationError;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];

            NSLog(@"%@", dictionary);
            NSLog(@"%@", dictionary[@"results"][0][@"primaryGenreName"]);
        }
    }];

    [task resume];
}

#pragma mark - Helpers

/**
* Build URL for searching iTunes for a particular term.
*
* @param term `NSString` search term.
* @param limit `NSUInteger` maximum number of results to request.
*
* @return `NSURL` for specified feed.
*/
- (NSURL *)URLForSearchTerm:(NSString *)term limit:(NSUInteger)limit
{
    // Hard code to iTunes search for now.
    NSMutableString *path = [@"/search?media=music&entity=musicArtist" mutableCopy];

    // Add search term parameter.
    [path appendFormat:@"&term=%@", [term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    // Limit the results given back to a fixed number.
    [path appendFormat:@"&limit=%lu", (unsigned long)limit];

    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:@"https://itunes.apple.com"]];
}

@end
