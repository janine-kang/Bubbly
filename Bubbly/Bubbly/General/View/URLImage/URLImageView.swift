//
//  URLImageView.swift
//  GPTChat
//
//  Created by Janine on 8/27/24.
//

import SwiftUI

struct URLImageView: View {
    @EnvironmentObject var container: DIContainer
    
    let urlString: String?
    let placeholderName: String
    
    init(urlString: String?, placeholderName: String? = nil) {
        self.urlString = urlString
        self.placeholderName = placeholderName ?? "placeholder"
    }
    
    var body: some View {
        if let urlString, !urlString.isEmpty {
            URLInnerImageView(viewModel: .init(container: container, urlString: urlString), placeholderName: placeholderName)
                .id(urlString) // url 변경 시 innerview의 stateobject도 변경되어야하므로
        } else {
            Image(placeholderName)
                .resizable()
        }
    }
}

fileprivate struct URLInnerImageView: View {
    // ImageView 부를 때마다 VM 세팅해주는게 번거로울 수 있으므로 wrapper 생성하여 하위뷰로 만들어줌
    @StateObject var viewModel: URLImageViewModel
    
    let placeholderName: String
    var placeholderImage: UIImage {
        UIImage(named: placeholderName) ?? UIImage()
    }
    
    var body: some View {
        Image(uiImage: viewModel.loadedImage ?? placeholderImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onAppear {
                if !viewModel.loadingOrSuccess {
                    viewModel.start()
                }
            }
    }
}

#Preview {
    URLImageView(urlString: nil)
}
