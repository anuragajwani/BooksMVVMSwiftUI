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
    let book: BookCellViewData
    
    var body: some View {
        VStack {
            HStack {
                Text(book.title)
                    .font(.title2)
                Spacer()
            }
            HStack {
                Text(book.substitle)
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

struct BookListView: View {
    @ObservedObject private var viewModel = ViewModel(booksRepository: DefaultBooksRepository())
    
    var body: some View {
        List(viewModel.books) { book in
            BookCell(book: book)
                .listRowSeparator(.hidden)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .padding()
        .onAppear(perform: {
            self.viewModel.fetchBooks()
        })
    }
}

struct ContentView: View {
    var body: some View {
        BookListView()
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

struct BookCellViewData: Identifiable {
    let id: String
    let title: String
    let substitle: String
}

extension BookListView {
    class ViewModel: ObservableObject {
        @Published var books: [BookCellViewData] = []

        private let booksRepository: BooksRepository

        init(booksRepository: BooksRepository) {
            self.booksRepository = booksRepository
        }

        func fetchBooks() {
            let books = self.booksRepository.get().map { book in
                let substitle = "\(book.authors.joined(separator: ", ")) ⚬ \(book.publicationDate.getYear())"
                return BookCellViewData(id: book.id,
                                        title: book.title,
                                        substitle: substitle)
            }
            self.books = books
        }
    }
}
