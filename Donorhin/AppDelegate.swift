//
//  AppDelegate.swift
//  Donorhin
//
//  Created by Patrick Leonardus on 05/11/19.
//  Copyright © 2019 Donorhin. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      UNUserNotificationCenter.current().delegate = self
      
        // Override point for customization after application launch.
      let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
      if launchOptions == nil {
        if launchedBefore  {
            print("Not first launch.")
        } else {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Onboarding")
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
      }
      else {
        self.checkNotification(launchOptions)
      }
                
      self.getNotificationSettings()
      self.window?.tintColor = Colors.red
      return true
    }
  
  func checkNotification(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    if let options = launchOptions {
      let storyboard = UIStoryboard(name: "RootTabBarController", bundle: nil)
      let viewController = storyboard.instantiateViewController(withIdentifier: "rootStoryboard") as? MainViewController
      viewController?.selectedIndex = 2
      self.window?.rootViewController = viewController
    }
  }
  
  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      guard settings.authorizationStatus == .authorized else {return}
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
  

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
      print("disini")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Donorhin")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    if let currentUser = UserDefaults.standard.value(forKey: "currentUser") as? String {
      let recordID = CKRecord.ID(recordName: currentUser)
      Helper.updateToDatabase(keyValuePair: ["device_token":token], recordID: recordID)
    }
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register: \(error)")
  }
  
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    print(userInfo)
    if let idRequest = userInfo["id_request"] as? String,
			let sender = userInfo["sender"] as? String,
      let tabBarIndex = userInfo["tab_bar_index"] as? Int{
			let storyboard = UIStoryboard(name: "RootTabBarController", bundle: nil)
			let viewController = storyboard.instantiateViewController(withIdentifier: "rootStoryboard") as? MainViewController
			
			var query: CKQuery?
			if tabBarIndex == 0 {
				query = CKQuery(recordType: "Tracker", predicate: NSPredicate(format: "id_request == %@ AND id_pendonor == %@", CKRecord.ID(recordName: idRequest), CKRecord.ID(recordName: sender)))
			}
			else if tabBarIndex == 1 {
				query = CKQuery(recordType: "Tracker", predicate: NSPredicate(format: "id_request == %@ AND id_pendonor == %@", CKRecord.ID(recordName: idRequest), CKRecord.ID(recordName: "0")))
			}
			guard let newQuery = query else {return}
			Helper.getAllData(newQuery) {[weak self] (results) in
				if let results = results {
					if results.count > 0 {
						viewController?.barSelected = tabBarIndex
						viewController?.tracker = results.last?.convertTrackerToTrackerModel()
						DispatchQueue.main.async {
							self?.window?.rootViewController = viewController
							completionHandler()
						}
					}
					else {
						completionHandler()
					}
				}
			}
    }
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.badge,.alert,.sound])
  }
}

