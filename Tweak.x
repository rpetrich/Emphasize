#import <UIKit/UIKit2.h>

@interface UIWindow (iOS5)
+ (NSArray *)allWindowsIncludingInternalWindows:(BOOL)includingInternalWindows onlyVisibleWindows:(BOOL)onlyVisibleWindows;
@end

static char originalColorKey;
static char originalBackgroundKey;
static char originalBackgroundAlternateKey;

#define HEX_COLOR(val) [UIColor colorWithRed:((val >> 16) & 0xFF) / 255.0f green:((val >> 8) & 0xFF) / 255.0f blue:(val & 0xFF) / 255.0f alpha:1.0f]

static inline BOOL LoadColor(UIColor **newColor)
{
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.rpetrich.emphasize.plist"];
	NSInteger setting = [[settings objectForKey:[NSString stringWithFormat:@"AppColor-%@", [NSBundle mainBundle].bundleIdentifier]] integerValue] ?: [[settings objectForKey:@"DefaultColor"] integerValue];
	if (newColor) {
		switch (setting) {
			case 0:
			case 1:
			default:
				*newColor = nil;
				break;
			case 2:
				*newColor = HEX_COLOR(0x2e3436);
				break;
			case 3:
				*newColor = HEX_COLOR(0xc4a000);
				break;
			case 4:
				*newColor = HEX_COLOR(0xfa6800);
				break;
			case 5:
				*newColor = HEX_COLOR(0x8f5902);
				break;
			case 6:
				*newColor = HEX_COLOR(0x4e9a06);
				break;
			case 7:
				*newColor = HEX_COLOR(0x204a87);
				break;
			case 8:
				*newColor = HEX_COLOR(0x5c3566);
				break;
			case 9:
				*newColor = HEX_COLOR(0xa40000);
				break;
			case 10:
				*newColor = HEX_COLOR(0x008080);
				break;
			case 11:
				*newColor = HEX_COLOR(0x6d8764);
				break;
			case 12:
				*newColor = HEX_COLOR(0x647687);
				break;
			case 13:
				*newColor = HEX_COLOR(0x7a3b3f);
				break;
			case 14:
				*newColor = HEX_COLOR(0x3171d6);
				break;
			case 15:
				*newColor = HEX_COLOR(0xd80073);
				break;
			case 16:
				*newColor = HEX_COLOR(0xee573e);
				break;
		}
	}
	return setting != 0;
}

@implementation UIView (Emphasize)

- (void)applyEmphasizeSettings
{
}

@end

%hook UIView

- (UIColor *)emphasizeDefaultTintColor
{
	return [[objc_getAssociatedObject(self, &originalColorKey) retain] autorelease];
}

- (void)didMoveToWindow
{
	%orig();
	if (self.window) {
		[self applyEmphasizeSettings];
	}
}

%end


@implementation UINavigationBar (Emphasize)

- (void)applyEmphasizeSettings
{
	[UIView transitionWithView:self duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[self setTintColor:objc_getAssociatedObject(self, &originalColorKey)];
		[self setBackgroundImage:objc_getAssociatedObject(self, &originalBackgroundKey) forBarMetrics:UIBarMetricsDefault];
		[self setBackgroundImage:objc_getAssociatedObject(self, &originalBackgroundAlternateKey) forBarMetrics:UIBarMetricsLandscapePhone];
	} completion:NULL];
}

@end

%hook UINavigationBar

- (void)setTintColor:(UIColor *)color
{
	objc_setAssociatedObject(self, &originalColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	LoadColor(&color);
	%orig();
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics
{
	objc_setAssociatedObject(self, barMetrics == UIBarMetricsDefault ? &originalBackgroundKey : &originalBackgroundAlternateKey, backgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if (LoadColor(NULL))
		backgroundImage = nil;
	%orig();
}

%end


@implementation UINavigationButton (Emphasize)

- (void)applyEmphasizeSettings
{
	[self setTintColor:objc_getAssociatedObject(self, &originalColorKey)];
}

@end

%hook UINavigationButton

- (void)setTintColor:(UIColor *)color
{
	objc_setAssociatedObject(self, &originalColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	LoadColor(&color);
	%orig();
}

- (void)setBackButtonBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics
{
	if (LoadColor(NULL))
		backgroundImage = nil;
	%orig();
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics
{
	if (LoadColor(NULL))
		backgroundImage = nil;
	%orig();
}

%end


%hook UIToolbarButton

%new
- (void)applyEmphasizeSettings
{
	[self setTintColor:objc_getAssociatedObject(self, &originalColorKey)];
}

- (void)setTintColor:(UIColor *)color
{
	objc_setAssociatedObject(self, &originalColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	LoadColor(&color);
	%orig();
}

%end


@implementation UIButton (Emphasize)

- (void)applyEmphasizeSettings
{
	[UIView transitionWithView:self duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[self setTintColor:objc_getAssociatedObject(self, &originalColorKey)];
	} completion:NULL];
}

@end

%hook UIButton

- (void)setTintColor:(UIColor *)color
{
	objc_setAssociatedObject(self, &originalColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	LoadColor(&color);
	%orig();
}

%end


@implementation UISegmentedControl (Emphasize)

- (void)applyEmphasizeSettings
{
	[UIView transitionWithView:self duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[self setTintColor:objc_getAssociatedObject(self, &originalColorKey)];
	} completion:NULL];
}

@end

%hook UISegmentedControl

- (void)setTintColor:(UIColor *)color
{
	objc_setAssociatedObject(self, &originalColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	LoadColor(&color);
	%orig();
}

%end


@implementation UISwitch (Emphasize)

- (void)applyEmphasizeSettings
{
	[UIView transitionWithView:self duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[self setOnTintColor:objc_getAssociatedObject(self, &originalColorKey)];
	} completion:NULL];
}

@end

%hook UISwitch

- (void)setOnTintColor:(UIColor *)color
{
	objc_setAssociatedObject(self, &originalColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	LoadColor(&color);
	%orig();
}

%end


@implementation UIToolbar (Emphasize)

- (void)applyEmphasizeSettings
{
	[UIView transitionWithView:self duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		[self setTintColor:objc_getAssociatedObject(self, &originalColorKey)];
	} completion:NULL];
}

@end

%hook UIToolbar

- (void)setTintColor:(UIColor *)color
{
	objc_setAssociatedObject(self, &originalColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	LoadColor(&color);
	%orig();
}

%end

static void RecursivelyRefreshViews(NSArray *views)
{
	for (UIView *view in views) {
		[view applyEmphasizeSettings];
		RecursivelyRefreshViews(view.subviews);
	}
}

static void RefreshAllViews(void)
{
	RecursivelyRefreshViews([UIWindow allWindowsIncludingInternalWindows:YES onlyVisibleWindows:NO]);
}

%ctor
{
	%init();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (void *)RefreshAllViews, CFSTR("com.rpetrich.emphasize.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
