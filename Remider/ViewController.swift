//
//  ViewController.swift
//  Remider
//
//  Created by Vũ Linh on 14/04/2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    var models = [MyRemiders]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Remiders"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.blue]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(handleTest))

        table.delegate = self
        table.dataSource = self
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func handleAdd() {
        let vc = AddViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "New Remider"
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                let remider = MyRemiders(title: title, date: date, identifier: "id_\(title)")
                self.models.append(remider)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        return
                    }
                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Test Notification
    @objc func handleTest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if let error = error {
                print("Error")
            } else {
                self.scheduleTest()
            }
        }
    }
    
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Remider"
        content.sound = .default
        content.body = "You have job to do"
        
        let targetDate = Date().addingTimeInterval(5)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                return
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let model = models[indexPath.row]
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd, MMM, YYYY at hh:mm a"
        
        cell.textLabel?.text = model.title
        cell.detailTextLabel?.text = formatDate.string(from: model.date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
}

struct MyRemiders {
    let title: String
    let date: Date
    let identifier: String
}
