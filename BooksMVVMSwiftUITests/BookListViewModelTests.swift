import Combine
import Foundation
import XCTest
@testable import BooksMVVMSwiftUI

class StubBooksRepository: BooksRepository {
    var getCount = 0
    func get() -> [BooksMVVMSwiftUI.Book] {
        self.getCount += 1
        return [
            Book(isbn: "0804139296",
                 title: "Zero to One",
                 authors: ["Peter Thiel", "Blake Masters"],
                 pages: 224,
                 publicationDate: Date.getDateFromString("04/06/2015"))
        ]
    }
}

class BookListViewModel: XCTestCase {
    private var sut: BookListView.ViewModel!
    private var booksRepository: StubBooksRepository!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        self.booksRepository = StubBooksRepository()
        self.sut = BookListView.ViewModel(booksRepository: self.booksRepository)
    }
    
    func testFetchBooksReturnsCorrectViewData() {
        let expectation = self.expectation(description: "books_view_data")
        let expectedBooksViewData = [
            BookCellViewData(
                id: "0804139296",
                title: "Zero to One",
                substitle: "Peter Thiel, Blake Masters ⚬ 2015")
        ]
        self.sut.fetchBooks()
        self.sut.$books.sink { booksViewData in
            XCTAssertEqual(booksViewData, expectedBooksViewData)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 5)
    }
}
