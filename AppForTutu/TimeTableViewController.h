//
//  TimeTableViewController.h
//  AppForTutu
//
//  Created by EnzoF on 18.02.16.
//  Copyright © 2016 EnzoF. All rights reserved.
//

#import <UIKit/UIKit.h>
//Добавление action,outlets,делегатов и протоколов таблицы и controls
@interface TimeTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;
- (IBAction)infoButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *StationFromField;
@property (weak, nonatomic) IBOutlet UITextField *StationToField;
- (IBAction)StationFromActionField:(UITextField *)sender;
- (IBAction)StationToActionField:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;

- (IBAction)ReverseActionButton:(UIButton *)sender;



@end
