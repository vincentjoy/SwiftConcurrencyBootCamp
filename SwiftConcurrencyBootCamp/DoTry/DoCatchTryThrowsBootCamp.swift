//
//  DoCatchTryThrowsBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Vincent Joy on 01/12/24.
//

import SwiftUI

struct DoCatchTryThrowsBootCamp: View {
    
    private var viewModel: DoCatchTryThrowsBootCampViewModel = .init()
    
    var body: some View {
        Text(viewModel.startingText)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootCamp()
}
