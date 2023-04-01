import SwiftUI

struct Book: Identifiable {
    var id: String { isbn }
    
    let isbn: String
    let title: String
    let authors: [String]
    let pages: Int
    let publicationDate: Date
}

extension Date {
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    static func getDateFromString(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: dateString)!
    }
}

struct BookCell: View {
    let book: Book
    
    var body: some View {
        VStack {
            HStack {
                Text(book.title)
                    .font(.title2)
                Spacer()
            }
            HStack {
                Text("\(book.authors.joined(separator: ", ")) ⚬ \(book.publicationDate.getYear())")
                    .font(.caption)
                Spacer()
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(uiColor: UIColor.lightGray)))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
    }
}

struct ContentView: View {
    @State private var books: [Book] = []
    
    private let booksRepository: BooksRepository = DefaultBooksRepository()
    
    var body: some View {
        List(books) { book in
            BookCell(book: book)
                .listRowSeparator(.hidden)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .padding()
        .onAppear(perform: {
            self.books = self.booksRepository.get()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

protocol BooksRepository {
    func get() -> [Book]
}

class DefaultBooksRepository: BooksRepository {
    private let books = [
        Book(isbn: "0804139296",
             title: "Zero to One",
             authors: ["Peter Thiel", "Blake Masters"],
             pages: 224,
             publicationDate: Date.getDateFromString("04/06/2015")),
        Book(isbn: "0307887898",
             title: "The Lean Startup",
             authors: ["Eric Ries"],
             pages: 336,
             publicationDate: Date.getDateFromString("06/10/2011")),
    ]
    
    func get() -> [Book] {
        return books
    }
}
