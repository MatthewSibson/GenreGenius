//
//  FeedDataProvider.h
//  GenreGenius
//
//  Created by Matthew Sibson on 12/9/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Genre) {
    GenreAll = -1,
    GenreBlues = 2,
    GenreComedy = 3,
    GenreChildrensMusic = 4,
    GenreClassical = 5,
    GenreCountry = 6,
    GenreElectronic = 7,
    GenreHoliday = 8,
    GenreOpera = 9,
    GenreSingerSongwriter = 10,
    GenreJazz = 11,
    GenreLatino = 12,
    GenreNewAge = 13,
    GenrePop = 14,
    GenreRBSoul = 15,
    GenreSoundtrack = 16,
    GenreDance = 17,
    GenreHipHopRap = 18,
    GenreWorld = 19,
    GenreAlternative = 20,
    GenreRock = 21,
    GenreChristianGospel = 22,
    GenreVocal = 23,
    GenreReggae = 24,
    GenreEasyListening = 25,
    GenreJPop = 27,
    GenreEnka = 28,
    GenreAnime = 29,
    GenreKayokyoku = 30,
    GenreFitnessWorkout = 50,
    GenreKPop = 51,
    GenreKaraoke = 52,
    GenreInstrumental = 53,
    GenreBrazilian = 1122,
    GenreSpokenWord = 50000061,
    GenreDisney = 50000063,
    GenreFrenchPop = 50000064,
    GenreGermanPop = 50000066,
    GenreGermanFolk = 50000068,
};

@interface FeedDataProvider : NSObject

#pragma mark - Fetches

/**
* Convenience method to fetch top albums across all genres.
*
* @param limit `NSUInteger` maximum number of results to request.
*/
- (void)fetchTopAlbumsLimit:(NSUInteger)limit;

/**
* Fetch top albums in a given genre with maximum number of results.
*
* @param genre A genre specified by the `Genre` enumeration.
* @param limit `NSUInteger` maximum number of results to request.
*/
- (void)fetchTopAlbumsFromGenre:(Genre)genre limit:(NSUInteger)limit;

@end
