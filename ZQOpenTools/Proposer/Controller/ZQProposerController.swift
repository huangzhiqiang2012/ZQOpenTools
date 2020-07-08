//
//  ZQProposerController.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/7/8.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Proposer 控制器
class ZQProposerController: ZQBaseController {
    
    private lazy var photoButton:UIButton = getButton(title: "photo", action: #selector(actionForPhotoButton))
    
    private lazy var cameraButton:UIButton = getButton(title: "camera", action: #selector(actionForCameraButton))
    
    private lazy var microphoneButton:UIButton = getButton(title: "microphone", action: #selector(actionForMicrophoneButton))
    
    private lazy var contactsButton:UIButton = getButton(title: "contacts", action: #selector(actionForContactsButton))
    
    private lazy var remindersButton:UIButton = getButton(title: "reminders", action: #selector(actionForRemindersButton))
    
    private lazy var calendarButton:UIButton = getButton(title: "calendar", action: #selector(actionForCalendarButton))
    
    private lazy var locationButton:UIButton = getButton(title: "location", action: #selector(actionForLocationButton))
    
    private lazy var notificationsButton:UIButton = getButton(title: "notifications", action: #selector(actionForNotificationsButton))

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        let topGap = 30
        view.zq.addSubViews([photoButton, cameraButton, microphoneButton, contactsButton, remindersButton, calendarButton, locationButton, notificationsButton])
        photoButton.snp.makeConstraints { (m) in
            m.width.equalTo(100)
            m.height.equalTo(30)
            m.centerX.equalToSuperview()
            m.top.equalTo(80)
        }
        cameraButton.snp.makeConstraints { (m) in
            m.width.height.centerX.equalTo(photoButton)
            m.top.equalTo(photoButton.snp.bottom).offset(topGap)
        }
        microphoneButton.snp.makeConstraints { (m) in
            m.width.height.centerX.equalTo(photoButton)
            m.top.equalTo(cameraButton.snp.bottom).offset(topGap)
        }
        contactsButton.snp.makeConstraints { (m) in
            m.width.height.centerX.equalTo(photoButton)
            m.top.equalTo(microphoneButton.snp.bottom).offset(topGap)
        }
        remindersButton.snp.makeConstraints { (m) in
            m.width.height.centerX.equalTo(photoButton)
            m.top.equalTo(contactsButton.snp.bottom).offset(topGap)
        }
        calendarButton.snp.makeConstraints { (m) in
            m.width.height.centerX.equalTo(photoButton)
            m.top.equalTo(remindersButton.snp.bottom).offset(topGap)
        }
        locationButton.snp.makeConstraints { (m) in
            m.width.height.centerX.equalTo(photoButton)
            m.top.equalTo(calendarButton.snp.bottom).offset(topGap)
        }
        notificationsButton.snp.makeConstraints { (m) in
            m.width.height.centerX.equalTo(photoButton)
            m.top.equalTo(locationButton.snp.bottom).offset(topGap)
        }
    }
}

// MARK: private
extension ZQProposerController {
    private func getButton(title:String?, action:Selector) -> UIButton {
        return UIButton(type: .custom).then {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15)
            $0.backgroundColor = .brown
            $0.zq.addRadius(radius: 15)
            $0.addTarget(self, action: action, for: .touchUpInside)
        }
    }
    
    private func showProposeMessageIfNeedFor(_ resource: PrivateResource, andTryPropose propose: @escaping Propose) {
        if resource.isNotDeterminedAuthorization {
            showAlertWithTitle("Notice", message: resource.proposeMessage, cancelTitle: "Not now", confirmTitle: "OK", withCancelAction: nil) {
                propose()
            }
        }
        else {
            propose()
        }
    }
    
    private func showAlertWithTitle(_ title:String, message:String, cancelTitle:String, confirmTitle:String, withCancelAction cancelAction : (() -> Void)?, confirmAction: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelAction?()
            }
            alertController.addAction(cancelAction)
            let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
                confirmAction?()
            }
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func alertNoPermissionToAccess(_ resource: PrivateResource) {
        showAlertWithTitle("Sorry", message: resource.noPermissionMessage, cancelTitle: "Dismiss", confirmTitle: "Change it now", withCancelAction: nil) {
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
     }
}

// MARK: action
extension ZQProposerController {
    @objc private func actionForPhotoButton() {
        let photos: PrivateResource = .photos
        let propose:Propose = {
            proposeToAccess(photos, agreed: {
                print("--__--|| I can access Photos.")
                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .savedPhotosAlbum
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }, rejected: {
                self.alertNoPermissionToAccess(photos)
            })
        }
        showProposeMessageIfNeedFor(photos, andTryPropose: propose)
    }
    
    @objc private func actionForCameraButton() {
        let camera: PrivateResource = .camera
        let propose:Propose = {
            proposeToAccess(camera, agreed: {
                print("--__--|| I can access Camera.")
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }, rejected: {
                self.alertNoPermissionToAccess(camera)
            })
        }
        showProposeMessageIfNeedFor(camera, andTryPropose: propose)
    }
    
    @objc private func actionForMicrophoneButton() {
        let microphone: PrivateResource = .microphone
        let propose:Propose = {
            proposeToAccess(microphone, agreed: {
                print("--__--|| I can access Microphone.")
            }, rejected: {
                self.alertNoPermissionToAccess(microphone)
            })
        }
        showProposeMessageIfNeedFor(microphone, andTryPropose: propose)
    }
    
    @objc private func actionForContactsButton() {
        let contacts: PrivateResource = .contacts
        let propose:Propose = {
            proposeToAccess(contacts, agreed: {
                print("--__--|| I can access Contacts.")
            }, rejected: {
                self.alertNoPermissionToAccess(contacts)
            })
        }
        showProposeMessageIfNeedFor(contacts, andTryPropose: propose)
    }
    
    @objc private func actionForRemindersButton() {
        let reminders: PrivateResource = .reminders
        let propose:Propose = {
            proposeToAccess(reminders, agreed: {
                print("--__--|| I can access Reminders.")
            }, rejected: {
                self.alertNoPermissionToAccess(reminders)
            })
        }
        showProposeMessageIfNeedFor(reminders, andTryPropose: propose)
    }
    
    @objc private func actionForCalendarButton() {
        let calendar: PrivateResource = .calendar
        let propose:Propose = {
            proposeToAccess(calendar, agreed: {
                print("--__--|| I can access Calendar.")
            }, rejected: {
                self.alertNoPermissionToAccess(calendar)
            })
        }
        showProposeMessageIfNeedFor(calendar, andTryPropose: propose)
    }
    
    @objc private func actionForLocationButton() {
        let location: PrivateResource = .location(.whenInUse)
        let propose:Propose = {
            proposeToAccess(location, agreed: {
                print("--__--|| I can access Location.")
            }, rejected: {
                self.alertNoPermissionToAccess(location)
            })
        }
        showProposeMessageIfNeedFor(location, andTryPropose: propose)
    }
    
    @objc private func actionForNotificationsButton() {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        let notifications:PrivateResource = .notifications(settings)
        let propose: Propose = {
            proposeToAccess(notifications, agreed: {
                print("--__--|| I can send Notifications.")
            }, rejected: {
                self.alertNoPermissionToAccess(notifications)
            })
        }
        showProposeMessageIfNeedFor(notifications, andTryPropose: propose)
    }
}

// MARK: PrivateResource + Extension
extension PrivateResource {
    var proposeMessage: String {
        
        switch self {
        case .photos:
            return "Proposer need to access your Photos to choose photo."
            
        case .camera:
            return "Proposer need to access your Camera to take photo."
            
        case .microphone:
            return "Proposer need to access your Microphone to record audio."
            
        case .contacts:
            return "Proposer need to access your Contacts to match friends."
            
        case .reminders:
            return "Proposer need to access your Reminders to create reminder."
            
        case .calendar:
            return "Proposer need to access your Calendar to create event."
            
        case .location:
            return "Proposer need to get your Location to share to your friends."
            
        case .notifications:
            return "Proposer want to send you notifications."
        }
    }

    var noPermissionMessage: String {
        switch self {
        case .photos:
            return "Proposer can NOT access your Photos, but you can change it in iOS Settings."
            
        case .camera:
            return "Proposer can NOT access your Camera, but you can change it in iOS Settings."
            
        case .microphone:
            return "Proposer can NOT access your Microphone, but you can change it in iOS Settings."
            
        case .contacts:
            return "Proposer can NOT access your Contacts, but you can change it in iOS Settings."
            
        case .reminders:
            return "Proposer can NOT access your Reminders, but you can change it in iOS Settings."
            
        case .calendar:
            return "Proposer can NOT access your Calendar, but you can change it in iOS Settings."
            
        case .location:
            return "Proposer can NOT get your Location, but you can change it in iOS Settings."
            
        case .notifications:
            return "Proposer can NOT send you notifications, but you can change it in iOS Settings."
        }
    }
}
