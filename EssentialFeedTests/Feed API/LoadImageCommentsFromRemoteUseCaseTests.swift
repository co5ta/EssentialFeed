//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Costa Monzili on 01/10/2023.
//

import XCTest
import EssentialFeed

final class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }

    func test_load_deliversErrorOnNon2xxHTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 150, 300, 400, 500]

        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }

    func test_load_deliversErrorOn2xxHTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        let samples = [200, 201, 250, 280, 299]

        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let invalidJSON = Data("invalide JSON".utf8)
                client.complete(withStatusCode: code, data: invalidJSON, at: index)
            }
        }
    }

    func test_load_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        let samples = [200, 201, 250, 280, 299]

        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWith: .success([])) {
                let emptyJSONList = makeItemJSON([])
                client.complete(withStatusCode: code, data: emptyJSONList, at: index)
            }
        }
    }

    func test_load_deliversItemsOn2xxHTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            username: "a username")

        let item2 = makeItem(
            id: UUID(),
            message: "another message",
            createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
            username: "another username")

        let items = [item1.model, item2.model]

        let samples = [200, 201, 250, 280, 299]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .success(items), when: {
                let json = makeItemJSON([item1.json, item2.json])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_doesNotDeliverResultAfterSutInstanceHasBeenDeallocated() {
        let url = URL(string: "anyurl")!
        let client = HTTPClientSpy()
        var nullableSut: RemoteImageCommentsLoader? = RemoteImageCommentsLoader(url: url, client: client)

        var capturedResults = [RemoteImageCommentsLoader.Result]()
        nullableSut?.load { capturedResults.append($0) }

        nullableSut = nil
        client.complete(withStatusCode: 200, data: makeItemJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://any-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteImageCommentsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentsLoader(url: url, client: client)
        trackForMemoryLeaks(element: sut, file: file, line: line)
        trackForMemoryLeaks(element: client, file: file, line: line)
        return (sut, client)
    }

    private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
        return  .failure(error)
    }

    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), username: String) -> (model: ImageComment, json: [String: Any]) {
        let item = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)

        let json: [String: Any] = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.iso8601String,
            "author": [
                "username": username
            ]
        ]

        return (item, json)
    }

    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items" : items]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func expect(_ sut: RemoteImageCommentsLoader, toCompleteWith expectedResult: RemoteImageCommentsLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {

        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteImageCommentsLoader.Error), .failure(expectedError as RemoteImageCommentsLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
          exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }

}
