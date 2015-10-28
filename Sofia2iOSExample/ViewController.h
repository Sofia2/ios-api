//
//  ViewController.h
//  Sofia2iOSExample
//
//  Created by Adrián on 21/11/14.
//  Copyright (c) 2014 Indra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sofia2iOS.h"

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *KPTextField;
@property (strong, nonatomic) IBOutlet UITextField *ontologyTextField;
@property (strong, nonatomic) IBOutlet UITextField *tokenTextField;
@property (strong, nonatomic) IBOutlet UITextView *queryTextField;
@property (strong, nonatomic) IBOutlet UITextView *responseTextField;
@property (strong, nonatomic) IBOutlet UITextView *insertTextField;
@property (strong, nonatomic) IBOutlet UITextView *updateTextField;
@property (strong, nonatomic) IBOutlet UITextView *subscribeTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *queryTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *insertTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *updateTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *subscribeTypeButton;

- (IBAction)queryTypeButtonSelected:(UIButton *)sender;
- (IBAction)insertTypeButtonSelected:(UIButton *)sender;
- (IBAction)updateTypeButtonSelected:(UIButton *)sender;
- (IBAction)subscribeTypeButtonSelected:(UIButton *)sender;


- (IBAction)joinButtonPressed:(UIButton *)sender;
- (IBAction)reJoinButtonPressed:(UIButton *)sender;
- (IBAction)leaveButtonPressed:(UIButton *)sender;
- (IBAction)queryButtonPressed:(UIButton *)sender;
- (IBAction)subscribeButtonPressed:(UIButton *)sender;
- (IBAction)unsubscribeButtonPressed:(UIButton *)sender;
- (IBAction)clearButtonPressed:(UIButton *)sender;
- (IBAction)reConnectButtonPressed:(UIButton *)sender;
- (IBAction)insertButtonPressed:(UIButton *)sender;
- (IBAction)updateButtonPressed:(UIButton *)sender;



@end
