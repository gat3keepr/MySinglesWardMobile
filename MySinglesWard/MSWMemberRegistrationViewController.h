//
//  MSWMemberRegistrationViewController.h
//  MySinglesWard
//
//  Created by Porter Hoskins on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWRegistrationViewController.h"

@interface MSWMemberRegistrationViewController : MSWRegistrationViewController
@property (weak, nonatomic) IBOutlet UISwitch *agreeToTermsSwitch;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *emailConfirmField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
