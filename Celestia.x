#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <SpringBoard/SpringBoard.h>
#import <os/log.h>
#import "VoiceOver.h"
#import "SpringBoard.h"
#import <notify.h>
#import <UIKit/UIKit.h>
#import <GameController/GameController.h>
#import <Cephei/Cephei.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <spawn.h>

os_log_t logger(){
  return os_log_create("com.panyolsoft.celestia", "Log");
}

#define CASE(str) if ([__s__ isEqualToString:(str)])
#define SWITCH(s) for (NSString *__s__ = (s); ; )
#define DEFAULT

BOOL hasDeviceNotch(void)
{
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        return NO;
    }
    else {
        LAContext* context = [[LAContext alloc] init];
        [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                             error:nil];

        return [context biometryType] == LABiometryTypeFaceID;
    }
}
void invokeLockScreen(void)
{
  id lockscreen = [%c(SBLockScreenManager) sharedInstanceIfExists];
  if (lockscreen == nil){
    //Nothing here
  } else if ([lockscreen isUILocked]) {
    [lockscreen lockScreenViewControllerRequestsUnlock];
  } else {
    //Nothing here
  }
}

%hook SpringBoard
NSTimer* timer;
int button;
%new
- (void)onTimerFire {
    timer = nil;
  switch (button){
    case 0:
      notify_post("com.panyolsoft.celestia-down-long");
      break;
    case 1:
      notify_post("com.panyolsoft.celestia-up-long");
      break;
    case 2:
      notify_post("com.panyolsoft.celestia-lock-long");
      invokeLockScreen();
      break;
    default:
      os_log(logger(), "invalid input!");
      break;
  }
}
-(_Bool)_handlePhysicalButtonEvent:(UIPressesEvent *)arg1 {
	// type = 101 -> Home button
	// force = 0 -> button released
	// force = 1 -> button pressed
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.panyolsoft.celestia"];
  if (([preferences boolForKey:@"isTweakEnabled"])||(preferences==nil)){
  int type = arg1.allPresses.allObjects[0].type;
   int force = arg1.allPresses.allObjects[0].force;
   if (type == 101){
     return %orig;
   }
	if (force == 1) {
    if(timer) {
   [timer invalidate];
 }
 timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimerFire) userInfo:nil repeats:NO];
		if (type == 103){
      button = 0;

}
		else if (type == 102) {
      button = 1;

    }
		else if (type == 104){
      notify_post("com.panyolsoft.celestia-lock");
      button = 2;

    }
	} else if (force == 0) {
    [timer invalidate];
    if (type == 103){
      //volumedown
    notify_post("com.panyolsoft.celestia-down");

}
  else if (type == 102) {
    //volumeup
    notify_post("com.panyolsoft.celestia-up");
  }
  else if (type == 104){
    notify_post("com.panyolsoft.celestia-lock-r");

  }
  }
  return NO;
} else {
  return %orig;
}
}
-(void)applicationDidFinishLaunching:(id)arg1{
  %orig;
  pid_t pid;
  const char* args[] = {"killall", "-9", "vot", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
%end
%hook UIViewController
-(void)viewDidLoad{
  %orig;
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(controllerWasConnected:) name:GCControllerDidConnectNotification object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(controllerWasDisconnected:) name:GCControllerDidDisconnectNotification object:nil];
  [GCController startWirelessControllerDiscoveryWithCompletionHandler:nil];
}


GCController *mainController;
%new
- (void)controllerWasConnected:(NSNotification *)notification {
    // a controller was connected
    GCController *controller = (GCController *)notification.object;
    os_log(logger(), "controller Connected : %{public}@", controller.vendorName);
    //mainController = controller;
  //  GCExtendedGamepad *profile = mainController.extendedGamepad;
  //  [self performSelector:@selector(setupController:) withObject:controller];
  GCExtendedGamepad *profile = controller.extendedGamepad;
profile.dpad.valueChangedHandler = ^(GCControllerDirectionPad * _Nonnull dpad, float xValue, float yValue) {
//os_log(logger(), "valueChangedHandler : %{public}f", xValue);

     if (dpad.down.isPressed){
       notify_post("com.panyolsoft.celestia-dpad-down");
     }
     if (dpad.up.isPressed){
       notify_post("com.panyolsoft.celestia-dpad-up");
     }

     if (dpad.left.isPressed){
       notify_post("com.panyolsoft.celestia-dpad-left");
     }
     if (dpad.right.isPressed){
       notify_post("com.panyolsoft.celestia-dpad-right");
     }
 };

 profile.leftThumbstick.valueChangedHandler = ^(GCControllerDirectionPad * _Nonnull ltb, float xValue, float yValue) {
 //os_log(logger(), "valueChangedHandler : %{public}f", xValue);

      if (ltb.down.isPressed){
        notify_post("com.panyolsoft.celestia-ltb-down");
      }
      if (ltb.up.isPressed){
        notify_post("com.panyolsoft.celestia-ltb-up");
      }

      if (ltb.left.isPressed){
        notify_post("com.panyolsoft.celestia-ltb-left");
      }
      if (ltb.right.isPressed){
        notify_post("com.panyolsoft.celestia-ltb-right");
      }
  };
  profile.rightThumbstick.valueChangedHandler = ^(GCControllerDirectionPad * _Nonnull rtb, float xValue, float yValue) {
  //os_log(logger(), "valueChangedHandler : %{public}f", xValue);

       if (rtb.down.isPressed){
         notify_post("com.panyolsoft.celestia-rtb-down");
       }
       if (rtb.up.isPressed){
         notify_post("com.panyolsoft.celestia-rtb-up");
       }
       if (rtb.left.isPressed){
         notify_post("com.panyolsoft.celestia-rtb-left");
       }
       if (rtb.right.isPressed){
         notify_post("com.panyolsoft.celestia-rtb-right");
       }
   };

   profile.leftThumbstickButton.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
   {
       if (pressed)
       {
         notify_post("com.panyolsoft.celestia-ltb-button");
       }
   };
   profile.rightThumbstickButton.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
   {
       if (pressed)
       {
         notify_post("com.panyolsoft.celestia-rtb-button");
       }
   };
 profile.buttonA.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-button-a");
       invokeLockScreen();
     }
 };

 profile.buttonB.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-button-b");
     }
 };

 profile.buttonY.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-button-y");
     }
 };
 profile.buttonX.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-button-x");
     }
 };


 profile.leftShoulder.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-shoulder-l");
     }
 };

 profile.rightShoulder.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-shoulder-r");
     }
 };

 profile.leftTrigger.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-trigger-l");
     }
 };

 profile.rightTrigger.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-trigger-r");
     }
 };
 if (@available(iOS 13.0, *)) {
 profile.buttonOptions.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-button-options");
     }
 };

 profile.buttonMenu.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-button-menu");
     }
 };


}
if (@available(iOS 14.0, *)) {
 profile.buttonHome.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
 {
     if (pressed)
     {
       notify_post("com.panyolsoft.celestia-button-home");
     }
 };
}

}
 %new
- (void)controllerWasDisconnected:(NSNotification *)notification {
    GCController *controller = (GCController *)notification.object;
    os_log(logger(), "controller Disconnected : %{public}@", controller.vendorName);
    mainController = nil;
}
%end
void VOTCommand(NSString* command){
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

  id touchEvent = [[%c(VOTEvent) touchEventWithCommand:command info:NULL]initWithType:2];
//[touchEvent ;
  id workspace = [%c(VOTWorkspace) sharedWorkspace];
    [workspace dispatchCommand:touchEvent];
  os_log(logger(), "VOTCommand processed event ");
});
}
/*
%hook SBAssistantController
-(BOOL)activateIgnoringTouches{
  os_log(logger(), "SBAssistantController activateIgnoringTouches : %{public}@", %orig?@"YES":@"NO");
  return %orig;
}
%end

%hook VOTConfiguration
-(void)setPreference:(id)arg1 forKey:(id)arg2{
  os_log(logger(), "VOTConfiguration setPreference : %{public}@ forKey:%{public}@", arg1, arg2);
  return %orig;

}
-(id)preferenceForKey:(id)arg1{
  os_log(logger(), "VOTConfiguration Preference : %{public}@ forKey:%{public}@", %orig, arg1);
  return %orig;
}
%end
*/


static void NotificationReceivedCallback(CFNotificationCenterRef center,void *observer, CFStringRef name,const void *object, CFDictionaryRef userInfo)
{

  if (CFStringCompare(CFSTR("com.panyolsoft.celestia-down"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandNextElement");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-up"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandPreviousElement");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-lock"), name, 0) == 0){
    VOTCommand(@"VOTEventCommandSimpleTap");

  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-down-long"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandScrollDownPage");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-up-long"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandScrollUpPage");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-lock-long"), name, 0) == 0){
    VOTCommand(@"VOTEventCommandBottomEdgePanLong");
  }
//Events
/*
VOTEventCommandSystemTakeScreenshot
VOTEventCommandElementAbove
VOTEventCommandPreviousElement
VOTEventCommandScrollLeftPage
VOTEventCommandScrollRightPage
*/
//Game Controller VOTEventCommandScrollLeftPage
  if (CFStringCompare(CFSTR("com.panyolsoft.celestia-dpad-down"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandElementBelow");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-dpad-up"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandElementAbove");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-dpad-left"), name, 0) == 0)
    {
      VOTCommand(@"VOTEventCommandPreviousElement");
    } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-dpad-right"), name, 0) == 0)
    {
      VOTCommand(@"VOTEventCommandNextElement");
    } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-button-a"), name, 0) == 0){
    VOTCommand(@"VOTEventCommandSimpleTap");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-button-b"), name, 0) == 0){
  VOTCommand(@"VOTEventCommandEscape");
}else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-button-x"), name, 0) == 0){
    VOTCommand(@"VOTEventCommandBottomEdgePanShort");
  }
 else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-button-y"), name, 0) == 0){
    VOTCommand(@"VOTEventCommandBottomEdgePanLong");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-shoulder-l"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandFirstElement");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-shoulder-r"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandLastElement");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-trigger-l"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandScrollDownPage");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-trigger-r"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandScrollUpPage");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-button-home"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandTopEdgePanLong");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-button-options"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandTopEdgePanShort");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-button-menu"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandTopEdgePanLong");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-ltb-button"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandSystemTakeScreenshot");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-ltb-left"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandScrollLeftPage");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-ltb-right"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandScrollRightPage");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-ltb-up"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandScrollUpPage");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-ltb-down"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandScrollDownPage");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-rtb-button"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandSystemTakeScreenshot");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-rtb-left"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandSystemSwitchToPreviousApp");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-rtb-right"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandSystemSwitchToNextApp");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-rtb-up"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandMoveToStatusBar");
  } else if (CFStringCompare(CFSTR("com.panyolsoft.celestia-rtb-down"), name, 0) == 0)
  {
    VOTCommand(@"VOTEventCommandScrollDownPage");
  }

//VOTEventCommandSystemSwitchToPreviousApp


}
/*
%hook VOTOutputAction
-(void)setString:(NSString *)arg1 {
  os_log(logger(), "VOTOutputAction speak%{public}@", arg1);
  return %orig(@"");
//  return %orig;
}
%end
*/
%hook VOTWorkspace
-(BOOL)outputDisabled{
//  os_log(logger(), "VOTWorkspace outputDisabled : %{public}@", %orig?@"YES":@"NO");
  return true;
}
-(void)dispatchCommand:(id)arg1{
// os_log(logger(), "VOTWorkspace dispatchCommand : %{public}@", arg1);
  return %orig;
}
%end


%hook VOTEventFactory
-(void)processEvent:(id)arg1{
//  os_log(logger(), "VOTEventFactory processEvent : %{public}@", arg1);
  return %orig;
}
%end


%hook CFPrefsPlistSource
-(void*)copyValueForKey:(CFStringRef)arg1 {
  if (CFStringCompare(arg1, CFSTR("VoiceOverTouchEnabled"), 0) == 0){
    return CFBridgingRetain(@YES);
} else {
  return %orig;
}
}
%end

%group disabled
%hook VOTWorkspace
-(BOOL)isAccessibilityEnabled{
  //os_log(logger(), "VOTWorkspace isAccessibilityEnabled : %{public}@", %orig?@"YES":@"NO");
  return false;
}
%end
%end

%ctor{
  NSString* processname = [[NSProcessInfo processInfo] processName];
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.panyolsoft.celestia"];

  [preferences registerDefaults:@{
    @"isTweakEnabled": @YES,
    @"isControllerEnabled": @YES
}];
  if ([processname containsString:@"vot"])
  {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia/reload-prefs"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    if ( [preferences boolForKey:@"isTweakEnabled"] ){
    //Hardware Buttons
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-down"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-up"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-lock"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-down-long"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-up-long"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-lock-long"),NULL,CFNotificationSuspensionBehaviorCoalesce);
  } else {
    %init(disabled)
  }
if ( [preferences boolForKey:@"isControllerEnabled"] ){
    //Controller Buttons
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-dpad-down"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-dpad-up"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-dpad-left"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-dpad-right"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    //leftThumbstick
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-ltb-down"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-ltb-up"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-ltb-left"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-ltb-right"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-ltb-button"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    //rightThumbstick
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-rtb-down"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-rtb-up"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-rtb-left"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-rtb-right"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-rtb-button"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    //Rest of buttons
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-button-a"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-button-b"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-button-x"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-button-y"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-button-home"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-button-options"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-button-menu"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-trigger-l"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-trigger-r"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-shoulder-l"),NULL,CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&NotificationReceivedCallback,CFSTR("com.panyolsoft.celestia-shoulder-r"),NULL,CFNotificationSuspensionBehaviorCoalesce);
}
  }
  if ( [preferences boolForKey:@"isTweakEnabled"] ){%init;}
}
