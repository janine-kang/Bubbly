//
//  MyProfileViewModel.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class MyProfileViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var userInfo: User?
    @Published var isEdited: Bool = false
    @Published var isPresentedDescEditView: Bool = false
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            // TODO: - image picker service
            Task {
                await updateProfileImage(pickerItem:imageSelection)
            }
            
        }
    }
    
    private var container: DIContainer
    private var userId: String
    
    
    // MARK: - life cycle
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    // MARK: - Methods
    
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
            
            print(user)
        }
    }
    
    func updateDescription(_ description: String) async {
        do {
        try await container.services.userService.updateUserDescription(userId: userId, description: description)
            userInfo?.description = description
            isEdited = true
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateProfileImage(pickerItem: PhotosPickerItem?) async {
        guard let pickerItem else { return }
        
        do {
            let data = try await container.services.photoPickerService.loadTransferable(from: pickerItem)
            let url = try await container.services.uploadService.uploadImage(source: .profile(userId:  userId), data: data)
            // TODO: db update
            try await container.services.userService.updateProfileURL(userId: userId, urlString: url.absoluteString)
            
            userInfo?.profileURL = url.absoluteString
            isEdited = true
        } catch {
            print(error.localizedDescription)
        }
    }
}
