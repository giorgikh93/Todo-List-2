//
//  NotificationManager.swift
//  Todo-List-2
//
//  Created by giorgi on 08.07.22.
//

import Foundation
import UserNotifications

class NotificationManager:ObservableObject {
    @Published private(set) var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    
    
    func reloadAuthorizationStatus(){
        UNUserNotificationCenter.current().getNotificationSettings{ settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All Set")
                DispatchQueue.main.async {
                    self.authorizationStatus = success ? .authorized : .denied
                }
            }else if let error = error {
                print(error.localizedDescription)
            }
    }
    
}
    
    func reloadLocalNotifications(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
            
        }
    }
    
    func createLocalNotification( hour:Int, minute:Int, day:Int, month:Int, year:Int) {
        var dateComponents = DateComponents()
        
        dateComponents.hour = 14
        dateComponents.minute = minute
        dateComponents.day = day + 1
        dateComponents.month = month
        dateComponents.year = year
      
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Your tasks need your attention!"
        notificationContent.subtitle = "Please have a look"
        notificationContent.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }

}
