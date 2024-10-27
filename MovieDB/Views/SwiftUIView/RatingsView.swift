//
//  RatingsView.swift
//  MovieDB
//
//  Created by Ritika Gupta on 27/10/24.
//

import SwiftUI
struct RatingDetails {
    let title: String
    let percentage: Double
}

struct RatingView: View {
    let rating: RatingDetails
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.primary.opacity(0.5), lineWidth: 6)
                    .frame(width: 80, height: 100)
                
                Circle()
                    .trim(from: 0, to: rating.percentage/100)
                    .stroke(Color.primary, lineWidth: 6)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 80, height: 100)
                
                Text(String(format: "%.1f%%", rating.percentage))
            }
            .frame(height: 100)
            Text(rating.title)
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 100, height: 40) // Fixed height for text
                .minimumScaleFactor(0.8)
        }.frame(width: 100, height: 140)
         
    }
}

#Preview {
    RatingView(rating: RatingDetails(title: "Rotten Tomato", percentage: 75)).preferredColorScheme(.dark)
}
