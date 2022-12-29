import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBAction func requestNotificationPermissionTapped(_ sender: UIButton) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .providesAppNotificationSettings]) { granted, error in
            print(granted, String(describing: error), #file)
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButtton = UIAlertAction(title: "Ok", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okButtton)
        present(alertController, animated: true, completion: nil)
    }
}

