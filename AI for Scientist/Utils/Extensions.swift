//
//  Extensions.swift
//  AI for Scientist
//
//  Useful extensions for common operations
//

import Foundation
import SwiftUI

// MARK: - Date Extensions
extension Date {
    /// Returns a human-readable relative date string (e.g., "2 hours ago", "Yesterday")
    var relativeTimeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// Check if date is within the last N days
    func isWithinLast(days: Int) -> Bool {
        guard let daysAgo = Calendar.current.date(byAdding: .day, value: -days, to: Date()) else {
            return false
        }
        return self > daysAgo
    }
}

// MARK: - String Extensions
extension String {
    /// Truncate string to specified length with ellipsis
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count > length {
            let index = self.index(self.startIndex, offsetBy: length)
            return String(self[..<index]) + trailing
        }
        return self
    }

    /// Remove extra whitespaces and newlines
    var cleaned: String {
        return self
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    /// Check if string contains any of the given substrings (case-insensitive)
    func containsAny(of strings: [String]) -> Bool {
        let lowercased = self.lowercased()
        return strings.contains { lowercased.contains($0.lowercased()) }
    }
}

// MARK: - Array Extensions
extension Array where Element: Identifiable {
    /// Remove duplicates based on ID
    func removingDuplicates() -> [Element] {
        var seen = Set<Element.ID>()
        return filter { element in
            guard !seen.contains(element.id) else { return false }
            seen.insert(element.id)
            return true
        }
    }
}

// MARK: - URL Extensions
extension URL {
    /// Check if URL points to a PDF file
    var isPDF: Bool {
        return self.pathExtension.lowercased() == "pdf"
    }

    /// Get file size in bytes
    var fileSize: Int64? {
        let values = try? resourceValues(forKeys: [.fileSizeKey])
        return values?.fileSize.map { Int64($0) }
    }

    /// Get human-readable file size string
    var fileSizeString: String? {
        guard let size = fileSize else { return nil }
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
}

// MARK: - View Extensions
extension View {
    /// Apply conditional view modifier
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Hide keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Color Extensions
extension Color {
    /// Initialize color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
