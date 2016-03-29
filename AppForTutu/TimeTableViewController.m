//
//  TimeTableViewController.m
//  AppForTutu
//
//  Created by EnzoF on 18.02.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import "TimeTableViewController.h"
#import "SearchData.h"
@interface TimeTableViewController ()
{
    SearchData *SData;
}
@property(strong,nonatomic) NSMutableArray *arrayStation;
@property(strong,nonatomic) NSArray *arraycityFrom;
@property(strong,nonatomic) NSArray *arraycityTo;
@property(strong,nonatomic) NSArray *arraycities;
@property(strong,nonatomic) NSString *FromOrTo;
@property(strong,nonatomic) NSOperation *CurrentOperation;
@property(strong,nonatomic) NSOperationQueue *CurrentOperationQueue;

@end

@implementation TimeTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //Установка делегатов
    [self.MyTableView setDelegate:self];
    [self.MyTableView setDataSource:self];
    [self.StationFromField setDelegate:self];
    [self.StationToField setDelegate:self];
    SData = [[SearchData alloc] init];
    self.DatePicker.hidden = YES;
    //Начальная дата в labelDate
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd.MM.yyyy"];
    self.labelDate.text = [dateformatter stringFromDate:[NSDate date]];
    //Начальная дата в labelDate
    
    self.StationFromField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    self.StationToField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [self.ActivityIndicator stopAnimating];
}

- (NSArray *)arraycityFrom{
    if(!_arraycityFrom)
        _arraycityFrom = [[NSArray alloc]init];
    return _arraycityFrom;
}
- (NSArray *)arraycityTo{
    if(!_arraycityTo)
        _arraycityTo = [[NSArray alloc]init];
    return _arraycityTo;
}

- (NSArray *)arraycities{
    if(!_arraycities)
        _arraycities = [[NSArray alloc]init];
    return _arraycities;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.arraycities count] == 0)
        return 0;
    NSDictionary *diction = [self.arraycities objectAtIndex:section];
    NSArray *stationarray =[diction objectForKey:@"stations"];
    //return [stationarray count];
    return [stationarray count];
}
//Обработка ссекций и строк в таблице
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self.arraycities count])
        return [self.arraycities count];
    return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([self.arraycities count] == 0)
        return @"";
    NSDictionary *Dictionarystation = [self.arraycities objectAtIndex:section];
    NSString *countryTitle = [Dictionarystation objectForKey:@"countryTitle"];
    NSString *cityTitle = [Dictionarystation objectForKey:@"cityTitle"];
    NSString *HeaderTitle = [NSString localizedStringWithFormat:@"%@-%@", cityTitle, countryTitle];
    return HeaderTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if([self.arraycities count] != 0)
    {
        NSDictionary *dictionary = [self.arraycities objectAtIndex:indexPath.section];
        NSArray *arraytations = [dictionary objectForKey:@"stations"];
        NSDictionary *currentstation = [arraytations objectAtIndex:indexPath.row];
        cell.textLabel.text = [currentstation objectForKey:@"stationTitle"];
    }
    return cell;
}



//Переоопеределение init для того, чтобы возращался объект класса к которому отправляется сообщение  init, а не его superclass
-(instancetype)init{
    self = [super init];
    return self;
}
// Обработка даты
- (void) UIDateCreate{
    if(self.DatePicker.hidden)
    {
        self.DatePicker.hidden = NO;
        self.labelDate.hidden = YES;
    }
    else
    {
        
        self.DatePicker.hidden = YES;
        self.labelDate.hidden = NO;
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"dd.MM.yyyy"];
        if([self.DatePicker.date timeIntervalSinceDate: [NSDate date]] < 0)
        {
            self.labelDate.text = [dateformatter stringFromDate:[NSDate date]];
            self.DatePicker.date = [NSDate date];
        }
        else
        {
            self.labelDate.text = [dateformatter stringFromDate:self.DatePicker.date];
        }

        NSLog(@"true");
    }

}
//Переделать название кнопки
- (IBAction)infoButton:(UIButton *)sender {
    [self UIDateCreate];
    }

//Обновление таблицы в многопоточном/обычном режиме
- (void)UIUpdate:(UITextField *)textField{
   [self.CurrentOperation cancel];
    [self.ActivityIndicator startAnimating];
    if(textField == self.StationFromField)
    {
        self.FromOrTo = @"citiesFrom";
       /* dispatch_queue_t queue = dispatch_queue_create("com.AppForTutu.queueUIUpdate", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            NSArray *array = [SData SearchStationCities:[SData citiesFrom] StringForSearch:self.StationFromField.text];
                self.arraycities = array;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.MyTableView reloadData];
            });
            [self.ActivityIndicator stopAnimating];
        });*/
                //self.CurrentOperation = nil;
        self.CurrentOperation = [NSBlockOperation blockOperationWithBlock:^{
            NSArray *array = [SData SearchStationCities:[SData citiesFrom] StringForSearch:self.StationFromField.text];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.arraycities = array;
                [self.MyTableView reloadData];
                self.CurrentOperation = nil;
                [self.ActivityIndicator stopAnimating];
            });
            NSLog(@"self.ActivityIndicator stopAnimating");
        }];
        dispatch_queue_t queue = dispatch_queue_create("com.AppForTutu.queueUIUpdate", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{[self.CurrentOperation start];});
        //dispatch_queue_t dispatch_queue_t_other = dispatch_queue_create("name", NULL);
        //dispatch_async(dispatch_queue_t_other, ^{[self.CurrentOperation start];});
    }
    if(textField == self.StationToField)
    {
         self.FromOrTo = @"citiesTo";
         self.arraycities = [SData SearchStationCities:[SData citiesTo] StringForSearch:self.StationToField.text];
        [self.MyTableView reloadData];
    }
   // [self.ActivityIndicator stopAnimating];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //[self.StationFromField returnKeyType];
    //[self textFieldShouldReturn:self.StationFromField];
    if(![textField.text isEqualToString:@""])
        [self UIUpdate:textField];
}

//Обработка Action полей ввода и кнопки
- (IBAction)StationFromActionField:(UITextField *)sender {
    [self UIUpdate:sender];
}

- (IBAction)StationToActionField:(UITextField *)sender {
    [self UIUpdate:sender];
}

- (IBAction)ReverseActionButton:(UIButton *)sender {
    NSString *stationFrom = self.StationFromField.text;
    NSString *stationTo = self.StationToField.text;
    self.StationFromField.text = stationTo;
    self.StationToField.text = stationFrom;
    if([self.FromOrTo isEqual: @"citiesFrom"])
    {
        [self UIUpdate:self.StationFromField];
    }
    else
    {
        [self UIUpdate:self.StationToField];
    }
}
//Обработка Action полей ввода и кнопки

//Получение словаря с данными станции по индекцу таблицы
- (NSDictionary *)getDataByStation:(NSIndexPath *)indexPath{
    if(indexPath)
    {
        if([self.arraycities count] != 0)
        {
            NSDictionary *StationDictionary;
            NSDictionary *city = [[NSDictionary alloc] initWithDictionary:[self.arraycities objectAtIndex:indexPath.section]];
            NSDictionary *station = [[NSDictionary alloc] initWithDictionary:[[city objectForKey:@"stations"] objectAtIndex:indexPath.row]];
            NSString *stationId = [station objectForKey:@"stationId"];
            if([self.FromOrTo isEqual: @"citiesFrom"])
                StationDictionary = [SData SearchDatabyStation:stationId Arraycities:[SData citiesFrom]];
            if([self.FromOrTo isEqual: @"citiesTo"])
                StationDictionary = [SData SearchDatabyStation:stationId Arraycities:[SData citiesTo]];
            if(StationDictionary)
                return StationDictionary;
        }
    }
    NSLog(@"getDataByStation:StationDictionary-nil");
    return nil;
}

//Обработка нажатия на строку таблицы
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *Dictionary;
    if([self.FromOrTo isEqual: @"citiesFrom"])
    {
        Dictionary = [[NSDictionary alloc] initWithDictionary:[self getDataByStation:indexPath]];
        NSDictionary *Station = [[NSDictionary alloc] initWithDictionary:[Dictionary objectForKey:@"station"]];
        self.StationFromField.text = [Station objectForKey:@"stationTitle"];
        [self UIUpdate:self.StationFromField];
    }
    if([self.FromOrTo isEqual: @"citiesTo"])
    {
        Dictionary = [[NSDictionary alloc] initWithDictionary:[self getDataByStation:indexPath]];
        NSDictionary *Station = [[NSDictionary alloc] initWithDictionary:[Dictionary objectForKey:@"station"]];
        self.StationToField.text = [Station objectForKey:@"stationTitle"];
        [self UIUpdate:self.StationToField];
    }
    
}

// Обработка кнопки информация в строках таблицы
// По нажатию кнопки появляется всплывающее окно с информацией о станции
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *Dictionary = [[NSDictionary alloc] initWithDictionary:[self getDataByStation:indexPath]];
    NSDictionary *station = [[NSDictionary alloc] initWithDictionary:[Dictionary objectForKey:@"station"]];
    
    NSString *CountryTitle = [station objectForKey:@"countryTitle"];
    NSString *CityTitle = [Dictionary objectForKey:@"cityTitle"];
    NSDictionary *point = [station objectForKey:@"point"];
    double latitude = [[point objectForKey:@"latitude"] doubleValue];
    double longitude = [[point objectForKey:@"longitude"] doubleValue];
    
    //доработать форматирование строки!!!
    NSString *StationParam = [NSString stringWithFormat:@"\rСтрана: %@\nГород: %@\nКоординаты:\n\t\t\t%.14f,\n\t\t\t%.14f",CountryTitle,CityTitle,latitude,longitude];
    NSString *stationTitle = [station objectForKey:@"stationTitle"];

    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Информация:\n%@",stationTitle] message:[NSString stringWithFormat:@"%@\n\r\rВыбрать станцию?",StationParam ] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultActionClose = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    UIAlertAction *defaultActionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self AllertAction:stationTitle];
    }];
    
    
    [alertViewController addAction:defaultActionClose];
    [alertViewController addAction:defaultActionOK];
    
    [self presentViewController:alertViewController animated:NO completion:^{

    }];
}
//Обработка  нажатия UIAlertAction "OK"
- (void)AllertAction:(NSString *)stationTitle{
    if([self.FromOrTo isEqual: @"citiesFrom"])
    {
        self.StationFromField.text = stationTitle;
        [self UIUpdate:self.StationFromField];
    }
    else
    {
        self.StationToField.text = stationTitle;
        [self UIUpdate:self.StationToField];
    }
}

//Обработка нажатия клавиши Return на клавиатуре
// Если выбраны "от" и "до" станции с одинаковым значением появляется сообщение
//"Выбраны одинаковые станции.Укажите другую станцию."
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self.StationFromField.text isEqualToString:self.StationToField.text])
    {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Внимание" message:@"Выбраны одинаковые станции. Укажите другую станцию."preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertViewController addAction:defaultAction];
        [self presentViewController:alertViewController animated:YES completion:^{
            textField.text = @"";
        }];
    }
    else
    {
    
        [textField resignFirstResponder];
    }
    return YES;
}
// По нажатию на пустое место на экране выбора станции убирается клавиатура
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for(UIView* view in self.view.subviews)
        [view resignFirstResponder];
}


@end
