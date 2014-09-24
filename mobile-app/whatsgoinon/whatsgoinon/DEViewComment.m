//
//  DEViewComment.m
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//

#import "DEViewComment.h"
#import "Constants.h"

@implementation DEViewComment

#define AWESOME 0
#define MEH 1
#define SUCKS 2

- (id) init {
    self = [super init];
    
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewComment" owner:self options:nil] firstObject];
        options = @[@"Awesome", @"Meh...", @"Suuuucks!!"];
        
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        comment = [options objectAtIndex:[_pickerView selectedRowInComponent:0]];
        ratingChange = 0;
        
        for (UIView *view in _buttons) {
            [[view layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        }
        
        for (UIView *view in _commentButtons) {
            [[view layer] setCornerRadius:view.frame.size.height / 2];
            [[view layer] setBorderColor:[UIColor whiteColor].CGColor];
            [[view layer] setBorderWidth:1.5f];
        }
        [_txtComment setInputAccessoryView:[DEScreenManager createInputAccessoryView]];
        [[_txtComment layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        [_txtComment setDelegate:self];
        [[_txtComment layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[_txtComment layer] setBorderWidth:1.5f];
        [self registerForKeyboardNotifications];
        ratingChange = 0;
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [options objectAtIndex:row];
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 50.0f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(myView.center.x - 35, myView.center.y - 25, 200, 50)];
    
    [label setFont:[UIFont fontWithName:@"Avenir Roman" size:14.0f]];
    [label setTextColor:[UIColor whiteColor]];
    
    [label setText:@"Yo Mama"];
    [myView addSubview:label];
    
    return myView;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [options count];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - Delegate Methods

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     //[comment appendString:[options objectAtIndex:row]];
}

- (IBAction)submitComment:(id)sender {
    
    // Need to check and make sure that the user has picked thumbs up or down.  If not then prompt the user to do so.
    if (ratingChange != 0)
    {
        NSMutableArray *comments = [NSMutableArray arrayWithArray:post.comments];
        [comments addObject:_txtComment.text];
        NSNumber *rating = post.rating;
        rating = [NSNumber numberWithInteger:rating.integerValue + ratingChange ];
        post.rating = rating;
        NSDictionary *dictionary = @{ PARSE_CLASS_EVENT_COMMENTS : comments, PARSE_CLASS_EVENT_RATING : rating };
        
        [DESyncManager updateObjectWithId:post.objectId UpdateValues:dictionary ParseClassName:PARSE_CLASS_NAME_EVENT];
        
        [DEScreenManager hideCommentView];
    }
    else {
        [_lblPromptEntry setHidden:NO];
    }
}

- (void) setPost:(DEPost *)myPost
{
    post = myPost;
    
    NSString *header = [NSString stringWithFormat:@"%@ @ %@", myPost.title, myPost.address];
    _lblHeader.text = header;
}


- (IBAction)setComment:(UIButton *)sender {
    
    switch (sender.tag) {
        case AWESOME:
            _txtComment.text = @"Awesome!";
            break;
        case MEH:
            _txtComment.text = @"Meh...";
            break;
        case SUCKS:
            _txtComment.text = @"Sucks!";
            break;
        default:
            break;
    }
}

- (IBAction)cancel:(id)sender {
    [DEScreenManager hideCommentView];
}

- (IBAction)thumbsUp:(UIButton *)sender {
    ratingChange = 5;
    [_lblPromptEntry setHidden:YES];
    
    [[sender layer] setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0].CGColor];
    [[sender layer] setBorderWidth:1.5f];
    [[sender layer] setCornerRadius:5.0f];
    
}

- (IBAction)thumbsDown:(UIButton *)sender {
    ratingChange = -5;
    [_lblPromptEntry setHidden:YES];
}

#pragma mark - Keyboard Methods
- (void) removeFromSuperview
{
    [super removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) keyboardWillShow : (NSNotification *) aNotification {
    [self scrollViewToTopOfKeyboard:(UIScrollView *)[self superview] Notification:aNotification View:self TextFieldOrView:_txtComment];
}

- (void) keyboardWillBeHidden : (NSNotification *) aNotification {
    [self scrollViewToBottom:(UIScrollView *)[self superview] Notification:aNotification];
}

@end
