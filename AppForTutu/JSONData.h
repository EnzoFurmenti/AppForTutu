//
//  JSONData.h
//  AppForTutu
//
//  Created by EnzoF on 18.02.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

// Получение JSON-данных из файла ресурсов

#import <Foundation/Foundation.h>

@interface JSONData : NSObject
//Массив словарей станций Городов-ИЗ/ДО
@property(strong,nonatomic) NSArray *citiesFrom;
@property(strong,nonatomic) NSArray *citiesTo;
@end
