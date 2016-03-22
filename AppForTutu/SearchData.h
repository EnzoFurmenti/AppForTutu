//
//  SearchData.h
//  AppForTutu
//
//  Created by EnzoF on 27.02.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import "JSONData.h"

@interface SearchData : JSONData
- (NSArray *)SearchStationCities:(NSArray *)Arraycities StringForSearch:(NSString *)StringForSearch;

- (NSDictionary *)SearchDatabyStation:(NSString *)StationId Arraycities:(NSArray *)Arraycities;
@end
