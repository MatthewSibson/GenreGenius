//
//  ResultsViewController.h
//  GenreGenius
//
//  Created by Matthew Sibson on 12/11/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Genre.h"

@interface ResultsViewController : UIViewController

/**
* Prime the view controller with the genre to display results for, ready for when the
* view controller is entered into to the hierarchy and the view loads.
*
* @param genre `Genre` to fetch albums for.
*/
- (void)displayResultsForGenre:(Genre)genre;

@end
