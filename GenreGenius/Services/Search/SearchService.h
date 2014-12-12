//
//  SearchService.h
//  GenreGenius
//
//  Created by Matthew Sibson on 12/10/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Genre.h"

@interface SearchService : NSObject

/**
* Find the genre associated with the search term. Takes a required block.
*
* @param term `NSString` with search term.
* @param block Required block that takes a `Genre` and `NSError` if any occurred.
*/
- (void)searchGenreForTerm:(NSString *)term onCompletion:(void (^)(Genre genre, NSError *error))block;

@end
