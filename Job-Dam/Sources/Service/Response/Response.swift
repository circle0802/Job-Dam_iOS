import Foundation

struct PostResponse: Codable {
    let author: String
    let id: Int
    let title: String
    let content: String
    let createdAt: String
    let commentsCnt: Int
}
struct SimplePost {
    let id: Int
    let title: String
    let username: String
    let commentCount: Int
}
extension SimplePost {
    init(from response: PostResponse) {
        self.id = response.id
        self.username = response.author
        self.title = response.title
        self.commentCount = response.commentsCnt
    }
}


struct PostDetailResponse: Codable {
    let author: String
    let id: Int
    let title: String
    let content: String
    let createdAt: String
    let commentList: CommentList
}

struct CommentList: Codable {
    let comments: [Comment]
    let commentsCnt: Int
}

struct Comment: Codable {
    let author: String
    let id: Int
    let content: String
    let createdAt: String
    let isRated: Bool
}

struct AccessToken: Codable {
    let accessToken: String
}

struct UserResponse: Codable {
    let id: String
    let jobType: String
    let posts: [Post]
}

struct Post: Codable {
    let id: Int
    let title: String
    let content: String
}

struct IdCheck: Codable {
    let exists: Bool
}

