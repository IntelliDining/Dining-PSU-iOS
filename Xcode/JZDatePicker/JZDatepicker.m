//
//  Created by Dmitry Ivanenko on 14.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "JZDatepicker.h"
#import "JZDatepickerDateView.h"
#import "JZDatepickerMonthView.h"
#import "StickyHeaderFlowLayout.h"

const CGFloat kJZDatepickerHeight = 50.;
const CGFloat kJZDatepickerSpaceBetweenItems = 0.;
const CGFloat kJZDatepickerHeaderWidth = 30.;
NSString * const kJZDatepickerCellIndentifier = @"kJZDatepickerCellIndentifier";
NSString * const kJZDatepickerHeaderIdentifier = @"kJZDatepickerHeaderIndentifier";

@interface JZDatepicker ()

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic, readwrite) NSDate *selectedDate;
// map dates into an array so that we can group them into sections
@property (strong, nonatomic) NSMutableArray *monthDaysArray;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) UICollectionView *datesCollectionView;

@end


@implementation JZDatepicker

- (void)awakeFromNib
{
    [self setupViews];
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark Setters | Getters

- (NSDateFormatter *)dateFormatter
{
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _dateFormatter;
}

- (NSMutableArray *)monthDaysArray
{
    if (!_monthDaysArray) {
        _monthDaysArray = [[NSMutableArray alloc] init];
    }
    return _monthDaysArray;
}

- (void)setDates:(NSArray *)dates
{
    _dates = dates;
    
    self.monthDaysArray = [self mapDatesIntoArray:dates];
    
    [self.datesCollectionView reloadData];
    
    self.selectedDate = nil;
}

- (NSMutableArray *)mapDatesIntoArray:(NSArray *)dates
{
    NSMutableArray *resultDict = [[NSMutableArray alloc] init];
    // use month sequence as key to the dictionary
    NSString *prevYearMonth = @"";
    for (NSDate *date in dates) {
        [self.dateFormatter setDateFormat:@"yyyy-MM"];
        NSString *yearMonth = [self.dateFormatter stringFromDate:date];
        // if this date's month is different from previous date's month, add an array entry
        if ( [yearMonth isEqualToString:prevYearMonth] == NO) {
            [resultDict addObject: [[NSMutableArray alloc] init]];
        }
        // add the date into the entry
        NSMutableArray *daysInMonth = resultDict.lastObject;
        [daysInMonth addObject:date];
        
        prevYearMonth = yearMonth;
    }
        return resultDict;
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    
    NSIndexPath *selectedCellIndexPath;
    for (int i = 0; i < [self.monthDaysArray count]; i++) {
        NSMutableArray *arr = self.monthDaysArray[i];
        for (int j = 0; j < [arr count]; j++) {
            if ([selectedDate isEqualToDate: arr[j]]) {
                selectedCellIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            }
        }
    }
    
    [self.datesCollectionView deselectItemAtIndexPath:self.selectedIndexPath animated:YES];
    [self.datesCollectionView selectItemAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    self.selectedIndexPath = selectedCellIndexPath;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (UICollectionView *)datesCollectionView
{
    if (!_datesCollectionView) {
        UICollectionViewFlowLayout *collectionViewLayout = [[StickyHeaderFlowLayout alloc] init];
        [collectionViewLayout setItemSize:CGSizeMake(kJZDatepickerItemWidth, CGRectGetHeight(self.bounds))];
        [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [collectionViewLayout setSectionInset:UIEdgeInsetsMake(0, kJZDatepickerSpaceBetweenItems, 0, kJZDatepickerSpaceBetweenItems)];
        [collectionViewLayout setMinimumLineSpacing:kJZDatepickerSpaceBetweenItems];
        [collectionViewLayout setHeaderReferenceSize:CGSizeMake(kJZDatepickerHeaderWidth, self.bounds.size.height)];
        
        _datesCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
        [_datesCollectionView registerClass:[JZDatepickerCell class] forCellWithReuseIdentifier:kJZDatepickerCellIndentifier];
        [_datesCollectionView registerClass:[JZDatepickerMonthView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kJZDatepickerHeaderIdentifier];
        [_datesCollectionView setBackgroundColor:[UIColor clearColor]];
        [_datesCollectionView setShowsHorizontalScrollIndicator:NO];
        [_datesCollectionView setAllowsMultipleSelection:YES];
        _datesCollectionView.dataSource = self;
        _datesCollectionView.delegate = self;
        _datesCollectionView.scrollsToTop = NO;
        _datesCollectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_datesCollectionView];
    }
    return _datesCollectionView;
}

- (void)updateConstraints
{
    self.datesCollectionView.frame = self.bounds;
    [super updateConstraints];
}

#pragma mark Public methods

- (void)resetSelectedDate
{
    self.selectedDate = nil;
}

- (void)selectDate:(NSDate *)date
{
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&date interval:NULL forDate:date];
    
    NSAssert([self.dates indexOfObject:date] != NSNotFound, @"Date not found in dates array");
    
    self.selectedDate = date;
}

- (void)selectDateAtIndex:(NSUInteger)index
{
    NSAssert(index < self.dates.count, @"Index too big");
    
    self.selectedDate = self.dates[index];
}

// -

- (void)fillDatesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSAssert(([fromDate compare:toDate] == NSOrderedAscending) || ([fromDate compare:toDate] == NSOrderedSame), @"toDate must be after or equal to fromDate");
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger dayCount = 0;
    while(YES){
        [days setDay:dayCount++];
        NSDate *date = [calendar dateByAddingComponents:days toDate:fromDate options:0];
        
        if([date compare:toDate] == NSOrderedDescending) break;
        [dates addObject:date];
    }
    
    self.dates = dates;
}

- (void)fillDatesFromDate:(NSDate *)fromDate numberOfDays:(NSInteger)numberOfDays
{
    NSDateComponents *days = [[NSDateComponents alloc] init];
    [days setDay:numberOfDays];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [self fillDatesFromDate:fromDate toDate:[calendar dateByAddingComponents:days toDate:fromDate options:0]];
}

- (void)fillCurrentWeek
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:today];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([weekdayComponents weekday] - [calendar firstWeekday]) + 7 ) % 7)];
    NSDate *beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:6];
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:beginningOfWeek options:0];
    
    [self fillDatesFromDate:beginningOfWeek toDate:endOfWeek];
}

- (void)fillCurrentMonth
{
    [self fillDatesWithCalendarUnit:NSCalendarUnitMonth];
}

- (void)fillCurrentYear
{
    [self fillDatesWithCalendarUnit:NSCalendarUnitYear];
}

#pragma mark Private methods

- (void)fillDatesWithCalendarUnit:(NSCalendarUnit)unit
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *beginning;
    NSTimeInterval length;
    [calendar rangeOfUnit:unit startDate:&beginning interval:&length forDate:today];
    NSDate *end = [beginning dateByAddingTimeInterval:length-1];
    
    [self fillDatesFromDate:beginning toDate:end];
}

#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.monthDaysArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = self.monthDaysArray[section];
    return [arr count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JZDatepickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJZDatepickerCellIndentifier forIndexPath:indexPath];
    cell.date = [self dateAtIndexPath:indexPath];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    JZDatepickerMonthView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kJZDatepickerHeaderIdentifier forIndexPath:indexPath];
    // use first date's month
    NSArray *arr = self.monthDaysArray[indexPath.section];
    NSDate *date = arr.firstObject;
    view.date = date;
    return view;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ![indexPath isEqual:self.selectedIndexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ![indexPath isEqual:self.selectedIndexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.datesCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _selectedDate = [self dateAtIndexPath:indexPath];
    
    [collectionView deselectItemAtIndexPath:self.selectedIndexPath animated:YES];
    self.selectedIndexPath = indexPath;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - helper methods

- (NSDate *)dateAtIndexPath: (NSIndexPath *)indexPath
{
    NSMutableArray *arr = self.monthDaysArray[indexPath.section];
    return arr[indexPath.row];
}

@end
