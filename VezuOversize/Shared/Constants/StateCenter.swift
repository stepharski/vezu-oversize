import Foundation

struct StateCenter {
    let name: String
    let code: String
    let latitude: Double
    let longitude: Double

    init(_ name: String, _ code: String, _ latitude: Double, _ longitude: Double) {
        self.name = name
        self.code = code
        self.latitude = latitude
        self.longitude = longitude
    }

    static let all: [StateCenter] = [
        .init("ALABAMA", "AL", 32.8, -86.8), .init("ARIZONA", "AZ", 34.3, -111.7), .init("ARKANSAS", "AR", 34.9, -92.4),
        .init("CALIFORNIA", "CA", 37.2, -119.5), .init("COLORADO", "CO", 39.0, -105.5), .init("CONNECTICUT", "CT", 41.6, -72.7),
        .init("DELAWARE", "DE", 39.0, -75.5), .init("FLORIDA", "FL", 28.6, -82.4), .init("GEORGIA", "GA", 32.7, -83.4),
        .init("IDAHO", "ID", 44.4, -114.6), .init("ILLINOIS", "IL", 40.0, -89.2), .init("INDIANA", "IN", 39.9, -86.3),
        .init("IOWA", "IA", 42.1, -93.5), .init("KANSAS", "KS", 38.5, -98.4), .init("KENTUCKY", "KY", 37.5, -85.3),
        .init("LOUISIANA", "LA", 31.1, -92.0), .init("MAINE", "ME", 45.4, -69.2), .init("MARYLAND", "MD", 39.0, -76.8),
        .init("MASSACHUSETTS", "MA", 42.3, -71.8), .init("MICHIGAN", "MI", 44.3, -85.4), .init("MINNESOTA", "MN", 46.3, -94.3),
        .init("MISSISSIPPI", "MS", 32.7, -89.7), .init("MISSOURI", "MO", 38.4, -92.5), .init("MONTANA", "MT", 47.0, -109.6),
        .init("NEBRASKA", "NE", 41.5, -99.8), .init("NEVADA", "NV", 39.3, -116.6), .init("NEW HAMPSHIRE", "NH", 43.7, -71.6),
        .init("NEW JERSEY", "NJ", 40.2, -74.7), .init("NEW MEXICO", "NM", 34.4, -106.1), .init("NEW YORK", "NY", 42.9, -75.5),
        .init("NORTH CAROLINA", "NC", 35.6, -79.4), .init("NORTH DAKOTA", "ND", 47.5, -100.5), .init("OHIO", "OH", 40.3, -82.8),
        .init("OKLAHOMA", "OK", 35.6, -97.5), .init("OREGON", "OR", 43.9, -120.6), .init("PENNSYLVANIA", "PA", 40.9, -77.8),
        .init("RHODE ISLAND", "RI", 41.7, -71.5), .init("SOUTH CAROLINA", "SC", 33.9, -80.9), .init("SOUTH DAKOTA", "SD", 44.4, -100.2),
        .init("TENNESSEE", "TN", 35.9, -86.4), .init("TEXAS", "TX", 31.5, -99.3), .init("UTAH", "UT", 39.3, -111.7),
        .init("VERMONT", "VT", 44.1, -72.7), .init("VIRGINIA", "VA", 37.5, -78.8), .init("WASHINGTON", "WA", 47.4, -120.5),
        .init("WEST VIRGINIA", "WV", 38.6, -80.6), .init("WISCONSIN", "WI", 44.6, -89.9), .init("WYOMING", "WY", 43.0, -107.6),
    ]
}
