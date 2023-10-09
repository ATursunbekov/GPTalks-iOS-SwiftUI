import SwiftUI

struct HighlightedText: View {
    var text: String
    var searchText: String
    var highlightColor: Color = .yellow

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(segments(text: text, searchText: searchText), id: \.self) { segment in
                if segment.lowercased() == searchText.lowercased() {
                    Text(segment).foregroundColor(.blue)
                        .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                } else {
                    Text(segment).foregroundColor(.white)
                        .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                }
            }
        }
    }

    private func segments(text: String, searchText: String) -> [String] {
        var segments: [String] = []
        var lastEnd = text.startIndex
        
        while let range = text.range(of: searchText, options: .caseInsensitive, range: lastEnd..<text.endIndex) {
            let prefix = String(text[lastEnd..<range.lowerBound])
            if !prefix.isEmpty {
                segments.append(prefix)
            }
            segments.append(String(text[range]))
            lastEnd = range.upperBound
        }
        
        if lastEnd != text.endIndex {
            segments.append(String(text[lastEnd..<text.endIndex]))
        }
        
        return segments
    }
}

struct HighlightedText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HighlightedText(text: "Ali Khan", searchText: "Ali")
            HighlightedText(text: "Ali and Ali are friends", searchText: "Ali")
            HighlightedText(text: "Create a social media post", searchText: "media")
        }
        .padding()
    }
}
