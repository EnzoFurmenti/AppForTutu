//
//  SearchData.m
//  AppForTutu
//
//  Created by EnzoF on 27.02.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import "SearchData.h"

@interface SearchData()

@end


@implementation SearchData

-(instancetype)init
{
    self = [super init];
    return self;
}

//Поиск станции-ИЗ/ДО
//Возвращается nil, если массив входных данных пуст
- (NSArray *)SearchStationCities:(NSArray *)Arraycities StringForSearch:(NSString *)StringForSearch
{
    NSMutableArray *ArrayTotalcities;
    if(!Arraycities)
    {
        NSLog(@"[SearchData SearchStationCitiesFrom]:Входной массив городов-пуст");
        ArrayTotalcities = nil;
    }
    else
    {
        if(!ArrayTotalcities)
            ArrayTotalcities = [[NSMutableArray alloc] init];
        for (NSDictionary *citiesDictionary in Arraycities)
        {
            NSArray *ArrayStationByCity = [citiesDictionary objectForKey:@"stations"];
            NSMutableArray *array = nil;
            NSString *StationTitle = nil;
            NSDictionary *DictionaryStationByCity = nil;
            for (DictionaryStationByCity in ArrayStationByCity)
            {
                StationTitle = [DictionaryStationByCity objectForKey:@"stationTitle"];
                NSRange r = [StationTitle rangeOfString:StringForSearch options:NSCaseInsensitiveSearch];
                if(r.location != NSNotFound)
                {
                    if(!array)
                        array =[[NSMutableArray alloc]init];
                    [array addObject:DictionaryStationByCity];
                }
            }
            if(array)
            {
                NSDictionary *Dictionary = nil;
                /*if(!ArrayTotalcities)
                    ArrayTotalcities = [[NSMutableArray alloc]init];*/
                NSString *countryTitle = [citiesDictionary objectForKey:@"countryTitle"];
                NSString *cityTitle = [citiesDictionary objectForKey:@"cityTitle"];
                NSString *cityID = [citiesDictionary objectForKey:@"cityId"];
                if(!Dictionary)
                    Dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:countryTitle,@"countryTitle",cityTitle,@"cityTitle",cityID,@"cityId",array,@"stations",nil];
                [ArrayTotalcities addObject:Dictionary];
            }
        }
    }
        return ArrayTotalcities;
}


// Поиск словаря данных станции по StationId
// Если данные не найдены, то возвращается nil
- (NSDictionary *)SearchDatabyStation:(NSString *)StationId Arraycities:(NSArray *)Arraycities{
    if(Arraycities)
    {
        NSDictionary *dictionary;
        for (dictionary in Arraycities)
        {
            NSArray *ArrayStationsbyCity  = [dictionary objectForKey:@"stations"];
            NSDictionary *Station;
            
            NSDictionary *TotalDictionary;
            for (Station in ArrayStationsbyCity)
            {
                NSString *StationbyCityID = [Station objectForKey:@"stationId"];
                if(StationbyCityID == StationId)
                {
                    NSString *cityTitle = [dictionary objectForKey:@"cityTitle"];
                    TotalDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:cityTitle,@"cityTitle",Station,@"station",nil];
                    return TotalDictionary;
                }
            }
        }
    }
    NSLog(@"[SearchData SearchDatabyStation]: Входной массив -пуст");
    return nil;
}


@end
