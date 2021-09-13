//
//  RepositoryEntity.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import Foundation

// https://docs.github.com/ja/rest/reference/search
struct Repository: Decodable {
    let id: Int
    let nodeID: String
    let name: String
    let fullName: String
    let owner: User
    let isPrivate: Bool
    let htmlURL: URL
    let contributorsURL: URL
    let description: String?
    let isFork: Bool
    let url: URL
    let createdAt: String
    let updatedAt: String
    let pushedAt: String?
    let homepage: String?
    let size: Int
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let forksCount: Int
    let openIssuesCount: Int
    let defaultBranch: String

    private enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case owner
        case isPrivate = "private"
        case htmlURL = "html_url"
        case contributorsURL = "contributors_url"
        case description
        case isFork = "fork"
        case url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case homepage
        case size
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case defaultBranch = "default_branch"
    }

    init(id: Int, nodeID: String, name: String, fullName: String,
         owner: User, isPrivate: Bool, htmlURL: URL, contributorsURL: URL,
         description: String?, isFork: Bool, url: URL, createdAt: String,
         updatedAt: String, pushedAt: String?, homepage: String?, size: Int,
         stargazersCount: Int, watchersCount: Int, language: String?, forksCount: Int,
         openIssuesCount: Int, defaultBranch: String) {
        self.id = id
        self.nodeID = nodeID
        self.name = name
        self.fullName = fullName
        self.owner = owner
        self.isPrivate = isPrivate
        self.htmlURL = htmlURL
        self.contributorsURL = contributorsURL
        self.description = description
        self.isFork = isFork
        self.url = url
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pushedAt = pushedAt
        self.homepage = homepage
        self.size = size
        self.stargazersCount = stargazersCount
        self.watchersCount = watchersCount
        self.language = language
        self.forksCount = forksCount
        self.openIssuesCount = openIssuesCount
        self.defaultBranch = defaultBranch
    }
}
