//
//  Genre.h
//  GenreGenius
//
//  Created by Matthew Sibson on 12/11/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import <Foundation/Foundation.h>

// Define some constants for handling genres, adding an 'all' and an 'invalid' constant.
// Instead of checking for a pre-validated list of genres, it is presumed that IDs produced
// by one API will be consistently accepted by the other API. Not always the best approach
// depending on application but it's a suitable enough simplification for this sample application.

// NB: Full list of genres available here:
// http://www.apple.com/itunes/affiliates/resources/documentation/genre-mapping.html

typedef NS_ENUM(NSInteger, Genre) {
    GenreAll     = -1,
    GenreInvalid = INT_MAX
};
