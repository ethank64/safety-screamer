//
//  PastDrivesTable.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/9/24.
//

import SwiftUI

struct PastDrivesTable: View {
    var body: some View {
        VStack() {
            Divider()
                .background(Color.primary)
            
            HStack {
                Text("Past Drives")
                    .font(.system(size: 45, weight: .bold))
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
}

#Preview {
    PastDrivesTable()
}
