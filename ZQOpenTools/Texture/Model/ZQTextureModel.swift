//
//  ZQTextureModel.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/31.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// 列表模型
class ZQTextureListResModel: ZQBaseResModel {
    var datas:ZQTextureListDatasModel?
}

class ZQTextureListDatasModel: ZQBaseResModel {
    var content:[ZQTextureArticleModel]?
    var page:ZQPageModel?
}

/// 详情模型
class ZQTextureDetailResModel: ZQBaseResModel {
    var datas:ZQTextureDetailModel?
}

class ZQTextureDetailModel: ZQBaseModel {
    var name:String?
    var userType: String?
    var visitNum: Int = 0
    var id: Int = 0
    var content: String?
    var commentsNum: Int = 0
    var nickname: String?
    var photo: String?
    var title: String?
    var likesNum: Int = 0
    var islikes: Bool = false
    var headimg: String?
    var createTime: String?
}

/// 推荐文章模型
class ZQTextureRecommendArticleResModel: ZQBaseResModel {
    var datas:[ZQTextureArticleModel]?
}

class ZQTextureArticleModel: ZQBaseModel {
    var id: Int = 0
    var title: String?
    var photo: String?
    var createTime: String?
    var visitNum: Int = 0
    var commentsNum: Int = 0
    var likesNum: Int = 0
    
    /// 自添加属性, 用于排序
    var timeMark:String = ""
}

/// 文章评论模型
class ZQTextureArticleCommentResModel: ZQBaseResModel {
    var datas:ZQTextureArticleCommentDatasModel?
}

class ZQTextureArticleCommentDatasModel: ZQBaseResModel {
    var content:[ZQTextureArticleCommentModel]?
    var page:ZQPageModel?
}

class ZQTextureArticleCommentModel: ZQBaseModel {
    var id: String?
    var formUserInfo:ZQTextureArticleCommentUserModel?
    var isLike: Bool = false
    var like:Int = 0
    var aid: String?
    var comment: String?
    var parentIds: String?
    var createTime: String?
    var childComment:[ZQTextureArticleChildCommentModel]?
}

class ZQPageModel: ZQBaseModel {
    var page: Int = 0
    var totalCount: Int = 0
    var pageSize: Int = 0
}

class ZQTextureArticleCommentUserModel: ZQBaseModel {
    var userId: String?
    var nickname: String?
    var headimg: String?
}

class ZQTextureArticleChildCommentModel: ZQBaseModel {
    var id: String?
    var formUserInfo:ZQTextureArticleCommentUserModel?
    var aid: String?
    var comment: String?
    var parentId: String?
    var toUserInfo:ZQTextureArticleCommentUserModel?
}
