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
        // Load the predetermined comments
        self = [[[NSBundle mainBundle] loadNibNamed:@"ViewComment" owner:self options:nil] firstObject];
        [self setFrame:[[UIScreen mainScreen] bounds]];
        options = @[@"Awesome", @"Meh...", @"Suuuucks!!"];
        
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        // Set the comment to Awesome initially
        comment = [options objectAtIndex:[_pickerView selectedRowInComponent:0]];
        ratingChange = 0;
        
        [self setUpViews];
        [self registerForKeyboardNotifications];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFirstResponder)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}

- (void) removeFirstResponder {
    [_txtComment resignFirstResponder]; 
}

/*
 
 Set up the look and feel of the subviews, and set the necessary delegates and Input Accessory Views
 
 */
- (void) setUpViews {
    
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
    [_txtComment setDelegate:self];

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

- (void) incrementThumbsUpCount
{

    PFObject *myObject = [[[[DEPostManager sharedManager] posts] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"objectId = %@", post.objectId]] firstObject];
    NSInteger thumbsUpCount = [post.thumbsUpCount integerValue];
    thumbsUpCount ++;
    post.thumbsUpCount = [NSNumber numberWithInteger:thumbsUpCount];
    myObject[PARSE_CLASS_EVENT_THUMBS_UP_COUNT] = post.thumbsUpCount;
    
    NSNumber *loaded = myObject[@"loaded"];
    myObject[@"loaded"] = @NO;
    [DESyncManager saveUpdatedPFObjectToServer:myObject];
    myObject[@"loaded"] = loaded;
}

- (IBAction)submitComment:(id)sender {
    
    // Need to check and make sure that the user has picked thumbs up or down.  If not then prompt the user to do so.
    if (ratingChange != 0 && commentSelected == YES)
    {
        [DESyncManager saveCommentWithEventId:[post objectId] Comment:_txtComment.text Rating:ratingChange];
        [DEScreenManager hideCommentView];
        //Thumbs up
        if (ratingChange == 5)
        {
            [self incrementThumbsUpCount];
        }
        // If this post has not already been marked as prompted for comment, do so now
        if (![[[DEPostManager sharedManager] promptedForCommentEvents] containsObject:post.objectId])
        {
            [[[DEPostManager sharedManager] promptedForCommentEvents] addObject:post.objectId];
            DEAppDelegate *appDelegate = (DEAppDelegate *) [[UIApplication sharedApplication] delegate];
            [appDelegate saveAllCommentArrays];
        }
        
        if (![[[DEPostManager sharedManager] goingPostWithCommentInformation] containsObject:post.objectId])
        {
            [[[DEPostManager sharedManager] goingPostWithCommentInformation] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj[PARSE_CLASS_EVENT_OBJECT_ID] isEqual: post.objectId])
                {
                    [[[DEPostManager sharedManager] goingPostWithCommentInformation] removeObject:obj];
                }
            }];
        }
    }
    
    if (ratingChange == 0) { // If the user has not selected thumbs up or down then display to them that they need to do this by adding a red border to thumbs buttons
        [[_btnThumbsDown layer] setBorderColor:[UIColor redColor].CGColor];
        [[_btnThumbsDown layer] setBorderWidth:2.0f];
        [[_btnThumbsDown layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        
        [[_btnThumbsUp layer] setBorderColor:[UIColor redColor].CGColor];
        [[_btnThumbsUp layer] setBorderWidth:2.0f];
        [[_btnThumbsUp layer] setCornerRadius:BUTTON_CORNER_RADIUS];
        
        [_lblPromptEntry setHidden:NO];
    }
    if (commentSelected == NO)
    {
        for (UIButton *button in _commentButtons) {
            [[button layer] setBorderColor:[UIColor redColor].CGColor];
            [[button layer] setBorderWidth:2.0f];
        }
    }
}

- (void) setPost:(DEPost *)myPost
{
    post = myPost;
    
    NSString *header = [NSString stringWithFormat:@"%@ @ %@", myPost.title, myPost.address];
    _lblHeader.text = header;
}

/*
 
 When the user clicks one of the predermined comment buttons, then the comment is displayed accordingly
 
 */
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
    
    commentSelected = YES;
    
    
    for (UIButton *button in _commentButtons) {
        [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[button layer] setBorderWidth:1.5f];
    }
    
}

- (IBAction)cancel:(id)sender {
    [DEScreenManager hideCommentView];
}

- (IBAction)thumbsUp:(UIButton *)sender {
    ratingChange = 5;
    [_lblPromptEntry setHidden:YES];
    
    // Create a border around the button showing that its been clicked
    [[sender layer] setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:1.0].CGColor];
    [[sender layer] setBorderWidth:1.5f];
    [[sender layer] setCornerRadius:5.0f];
    // Set the other buttons border to nothing
    [[_btnThumbsDown layer] setBorderWidth:0.0f];
}

- (IBAction)thumbsDown:(UIButton *)sender {
    ratingChange = -5;
    [_lblPromptEntry setHidden:YES];
    
    // Create a border around the button showing that its been clicked
    [[sender layer] setBorderColor:[UIColor colorWithRed:151.0f/255.0f green:154.0f/255.0f blue:155.0f/255.0f alpha:1.0].CGColor];
    [[sender layer] setBorderWidth:1.5f];
    [[sender layer] setCornerRadius:5.0f];
    // Set the other buttons border to nothing
    [[_btnThumbsUp layer] setBorderWidth:0.0f];
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

#pragma mark - Text View Delegate

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    // Get how many characters are available to be entered after the data is pasted
    int targetLength = 75 - (int) newLength;
    
    if (targetLength > -1)
    {
        self.lblMinCharacters.text = [NSString stringWithFormat:@"%lu", 75 - newLength];
    }
    else
    {
        self.lblMinCharacters.text = @"0";
        return NO;
    }
    
    return  YES;
}


@end
