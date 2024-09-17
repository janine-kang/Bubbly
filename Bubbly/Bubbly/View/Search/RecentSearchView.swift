//
//  RecentSearchView.swift
//  GPTChat
//
//  Created by Janine on 9/9/24.
//

import SwiftUI

struct RecentSearchView: View {
    
    @Environment(\.managedObjectContext) var objectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var results: FetchedResults<SearchResult>
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .padding(.bottom, 20)
            
            if results.isEmpty {
            Text("검색 내역이 없습니다")
                .font(.system(size: 10))
                .foregroundStyle(Color.greyDeep)
                .padding(.vertical, 54)
            Spacer()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(results, id:\.self) { result in
                            HStack {
                                Text(result.name ?? "")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.bkText)
                                
                                Spacer()
                                
                                Button {
                                    objectContext.delete(result)
                                    
                                    // 디스크 저장
                                    try? objectContext.save()
                                } label: {
                                    Image("close_search")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                }

                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 30)
    }
    
    var titleView: some View {
        HStack {
            Text("최근 검색어")
                .font(.system(size: 10, weight: .bold))
            Spacer()
        }
    }
}

#Preview {
    RecentSearchView()
}
