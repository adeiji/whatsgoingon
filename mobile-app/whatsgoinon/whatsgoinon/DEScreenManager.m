//
//  DEScreenManager.m
//  whatsgoinon
//
//  Created by adeiji on 8/7/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEScreenManager.h"
#import "Constants.h"

@implementation DEScreenManager

+ (id)sharedManager {
    static DEScreenManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _overlayDisplayed = NO;
        _values = [NSMutableDictionary new];
    }
    return self;
}

+ (void) addToWindowView : (UIView *) view {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    NSArray *subviews = [window subviews];
    bool exist = NO;
    
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[view class]])
        {
            exist = YES;
        }
    }
    
    if (!exist)
    {
        [window addSubview:view];
    }
}

+ (void) setUpTextFields : (NSArray *) textFields
{
    for (UITextField *textField in textFields) {
        
        [textField.layer setCornerRadius:BUTTON_CORNER_RADIUS];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        [textField setLeftView:spacerView];
        [textField setKeyboardAppearance:UIKeyboardAppearanceDark];
        [textField setInputAccessoryView:[self createInputAccessoryView]];
        if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)])
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
        }
        else    // Prior to 6.0
        {
            
        }
    }
}

+ (UIView *) createInputAccessoryView {
    UIView *inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 60.0f)];
    [inputAccView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.8f]];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDone setFrame:CGRectMake(10, 10, 50.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [inputAccView addSubview:btnDone];
    return inputAccView;
}

+ (void) hideKeyboard
{
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [viewController.view endEditing:YES];
}

- (void) gotoNextScreen {
    UINavigationController *navController = (UINavigationController *) [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [navController popToRootViewControllerAnimated:NO];
    [navController pushViewController:_nextScreen animated:YES];
}


@end
