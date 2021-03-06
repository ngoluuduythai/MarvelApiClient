//
//  BaseApiClientTests.swift
//  MarvelApiClient
//
//  Created by Pedro Vicente on 14/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import XCTest
import Nocilla
import Nimble
import BrightFutures
import Result
@testable import MarvelApiClient

class BaseApiClientTests: NocillaTestCase {

    private let anyBaseEndpoint = "http://gateway.marvel.com/v1/public/"
    private let anyPath = "path"
    private let anyPublicKey = "1234"
    private let anyTimestamp = 1
    private let anyPrivateKey = "abcd"
    private var timeProvider: MockTimeProvider!
    private var httpClient: HTTPClient!

    override func setUp() {
        super.setUp()
        timeProvider = MockTimeProvider(time: anyTimestamp)
        httpClient = AlamofireHTTPClient()
    }

    override func tearDown() {
        MarvelApiClient.configureCredentials("", privateKey: "")
        super.tearDown()
    }

    func testSendsAuthParamsByDefault() {
        let apiClient = givenABaseApiClient()
        givenCredentialsConfigured(anyPublicKey, privateKey: anyPrivateKey)
        givenCurrentTimeIs(1)
        stubRequest("GET",
                    "http://gateway.marvel.com/v1/public/path?apikey=1234&hash=ffd275c5130566a2916217b101f26150&ts=1")

        let result = apiClient.sendRequest(.GET, path: anyPath)

        expect(result).toEventually(beSuccess())
    }

    func testSendsAuthParamsByDefaultPlusTheConfiguredOnes() {
        let apiClient = givenABaseApiClient()
        givenCredentialsConfigured(anyPublicKey, privateKey: anyPrivateKey)
        givenCurrentTimeIs(1)
        stubRequest("GET",
            "http://gateway.marvel.com/v1/public/path?apikey=1234&hash=ffd275c5130566a2916217b101f26150&k=v&ts=1")

        let result = apiClient.sendRequest(.GET, path: anyPath, params: ["k":"v"])

        expect(result).toEventually(beSuccess())
    }

    private func givenCredentialsConfigured(publicKey: String, privateKey: String) {
        MarvelApiClient.configureCredentials(publicKey, privateKey: privateKey)
    }

    private func givenCurrentTimeIs(currentTimeMillis: Int) {
        timeProvider.time = currentTimeMillis
    }

    private func givenABaseApiClient() -> MarvelBaseApiClient {
        return MarvelBaseApiClient(baseEndpoint: anyBaseEndpoint,
            timeProvider: timeProvider,
            httpClient: httpClient)
    }

}