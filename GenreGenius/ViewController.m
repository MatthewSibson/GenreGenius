//
//  ViewController.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/9/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "ViewController.h"
#import "FeedDataProvider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    FeedDataProvider *feedDataProvider = [[FeedDataProvider alloc] init];
    [feedDataProvider fetchTopAlbumsFromGenre:GenreGermanFolk limit:15];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
