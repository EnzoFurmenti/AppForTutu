
//
//  JSONData.m
//  AppForTutu
//
//  Created by EnzoF on 18.02.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import "JSONData.h"

@interface JSONData()
// Название и тип файла ресурсов
#define  PATH_FOR_RESOURSE @"allStation"
#define  OF_TYPE_RESOURSE @"json"
// Адрес JSON-файла
#define URLstringFile @"https://raw.githubusercontent.com/tutu-ru/hire_ios-test/master/allStations.json"
//JSON-данные
@property(strong,nonatomic) NSDictionary *JSONDictionary;
@property(strong,nonatomic) NSData *data;
@property(strong,nonatomic) NSString *str;
@end

@implementation JSONData

- (NSData *)data{

    if(!_data)
        _data = [NSData new];
    return _data;
}

//Получить данных из файла ресурсов
//Возвращает nil или NSData
- (NSData *)getDataOfFileResource{
    //nil-указатель на объект NSError
    NSError *error = nil;
    //Указатель на NSData
    NSData *DatafromFileResource;
    
    //загрузка данных из сети
    //Возможно использовать данный способ загрузки файла при наличие сети
    //Не доработан индикатор прогресс-бар
    [self getDataOfInet];
    DatafromFileResource =  self.data;
    //если данных нет
    if([DatafromFileResource bytes] == NULL || DatafromFileResource == nil)
    {
        //загрзука данных из файла ресурсов
        //
        //Получение директории к файлу (json) ресурсов
        NSString *PathFile = [[NSBundle mainBundle] pathForResource:PATH_FOR_RESOURSE ofType:OF_TYPE_RESOURSE];
        // Дирректоря файла существует?
        if(PathFile)
        {
        // Получение данных из файла ресурсов
            DatafromFileResource = [NSData dataWithContentsOfFile:PathFile options:0 error:&error];
        //Ошибка  в получении данных?
            if(error)
            {
                
               DatafromFileResource = nil;
                //Вывод ошибки
                NSLog(@"[JSONData getDatafromFileResource]:%@",[error localizedDescription]);
            }
        }
        else
        {
            NSLog(@"[JSONData getDatafromFileResource]:Не найден файл");
        }
    }

    return DatafromFileResource;
}
// Получение данных из сети
// Доработать!!!
- (void) getDataOfInet{
   /* NSURL *nsURL = [NSURL URLWithString:URLstringFile];
    NSURLRequest *nsURLrequest = [NSURLRequest requestWithURL:nsURL
                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                           timeoutInterval:60.0];
    NSConnection *nsConnect = [NSURLConnection connectionWithRequest:nsURLrequest delegate:self];
    if (nsConnect)
    {
        self.data = [NSData data];*/
        self.data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLstringFile]];
    
    
      /* NSString *str;
        NSURLSessionConfiguration *Configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:Configuration];
        NSURLSessionDownloadTask *task;
        task = [session downloadTaskWithRequest:nsURLrequest completionHandler:^(NSURL * locationfile, NSURLResponse * response, NSError *  error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.data = [NSData dataWithContentsOfURL:locationfile];
            });
        }];
    [task resume];*/
   // }
   //  else
   //  {
   //     NSLog(@"Connection failed");
   // }
    
}


//Отложенная инициализация свойства "JSONDictionary"
- (NSDictionary *)JSONDictionary{
    //указатель на данные - nil?
    if(!_JSONDictionary)
    {
        //Создаем и иницилиазируем объект
        _JSONDictionary = [[NSDictionary alloc]init];
        // nil-указатель на NSError
        NSError *error = nil;
        //Данные из файла ресурсов
        NSData *DatafromFileResourse = [self getDataOfFileResource];
        //Если данных нет,
        if(!DatafromFileResourse)
        {
            _JSONDictionary = nil;
        }
        //иначе
        else
        {
            //Инициализуруем JSONDictionary
            _JSONDictionary = [NSJSONSerialization JSONObjectWithData:DatafromFileResourse options:0 error:&error];
            //Ошибка при NSJSONSerialization
            if(error)
            {
                _JSONDictionary = nil;
                NSLog(@"getJSONDictionary:%@",[error localizedDescription]);
            }
        }
    }
    return _JSONDictionary;
}

//Получение массива словарей городов-ИЗ/ДО
//По значению строки возвращает nil или NSArray
- (NSArray*)getCitiesOfJSONDictionary:(NSString *)citiesFromOrTo{
    //Объявление переменных
    NSArray *ArraycitiesFromOrTo;
    NSDictionary *JSONDictionary = self.JSONDictionary;
    //Если данных нет
    if(!JSONDictionary)
    {
        ArraycitiesFromOrTo = nil;
        NSLog(@"[JSONData getCitiesOfJSONDictionary]:Нет данных");
    }
    //иначе
    else
    {
        ArraycitiesFromOrTo = [JSONDictionary objectForKey:citiesFromOrTo];
    }
    return ArraycitiesFromOrTo;
}


// Отложенная инициализация.Массив городов-ИЗ
//Если нет данных возвращает пустой массив
- (NSArray*)citiesFrom{
    if(!_citiesFrom)
    {
        NSArray *array = [self getCitiesOfJSONDictionary:@"citiesFrom"];
        if(array)
        {
            _citiesFrom = array;
        }
        else
        {
            _citiesFrom = [[NSArray alloc]init];
        }
    }
    
    return _citiesFrom;
}

// Отложенная инициализация Массив городов-ДО
//Если нет данных возвращает пустой массив
- (NSArray*)citiesTo{
    if(!_citiesTo)
    {
        NSArray *array = [self getCitiesOfJSONDictionary:@"citiesTo"];
        if(array)
        {
            _citiesTo = array;
        }
        else
        {
            _citiesTo = [[NSArray alloc]init];
        }
    }
    
    return _citiesTo;
}


@end
