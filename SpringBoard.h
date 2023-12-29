@interface SBLockScreenManager : NSObject
+(id)sharedInstance;
+(id)sharedInstanceIfExists;
-(BOOL)isUILocked;
-(BOOL)hasUIEverBeenLocked;
-(void)coverSheetPresentationManager:(id)arg1 unlockWithRequest:(id)arg2 completion:(/*^block*/id)arg3 ;
-(void)lockScreenViewControllerWillPresent;
-(void)lockScreenViewControllerDidPresent;
-(void)lockScreenViewControllerWillDismiss;
-(void)lockScreenViewControllerDidDismiss;
-(void)lockScreenViewControllerRequestsUnlock;
@end

@interface SBFLockScreenDateView : UIView
-(UIView*)view;
@end
