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
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.5), lineWidth: 6)
                    .frame(width: 80, height: 100)
                
                Circle()
                    .trim(from: 0, to: rating.percentage/100)
                    .stroke(Color.white, lineWidth: 6)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 80, height: 100)
                
                Text(String(format: "%.1f%%", rating.percentage))
            }
               
            Text(rating.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
         
    }
}

#Preview {
    RatingView(rating: RatingDetails(title: "Rotten Tomato", percentage: 75)).preferredColorScheme(.dark)
}
