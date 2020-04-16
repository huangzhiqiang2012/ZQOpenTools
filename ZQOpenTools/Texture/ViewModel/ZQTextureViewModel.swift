//
//  ZQTextureViewModel.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/3/31.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

/// Texture 模块 viewModel
class ZQTextureViewModel: ZQBaseViewModel {
    
    static let imageDownloadBaseUrl:String = "https://sami-1256315447.picgz.myqcloud.com"
    
    var articleListDic:[(key:String, value:[ZQTextureArticleModel])] = []
        
    var detailModel:ZQTextureDetailModel?
    
    var recommendArticleArr:[ZQTextureArticleModel] = [ZQTextureArticleModel]()
    
    var commentArr:[ZQTextureArticleCommentModel] = [ZQTextureArticleCommentModel]()
}

// MARK: public
extension ZQTextureViewModel {
    
    /// 请求列表数据
    /// - Parameters:
    ///   - uid: 用户id
    ///   - completion: 回调
    func requestListData(isFirstFetch: Bool, uid:String, scrollView:UIScrollView, completion:@escaping (() -> ())) {
        ZQMoyaManager.callTextureApiMapObject(.list(uid:uid, page: caculatePage(isFirstFetch), perPage: perPage), type: ZQTextureListResModel.self).done { (model) in
            
            if model.datas?.content?.count == 0 {
                
                /// 测试数据
                let model0 = ZQTextureArticleModel()
                model0.id = 626248
                model0.title = "听说马可波罗很帅"
                model0.photo = "/newImage/article/202004/be8aa1259c13457ca15fc9533cd66dd5.jpeg"
                model0.createTime = "2020-04-10 10:43:29"
                model0.visitNum = 8
                model0.commentsNum = 0
                model0.likesNum = 0
                
                let model1 = ZQTextureArticleModel()
                model1.id = 610050
                model1.title = "就是个帅哥"
                model1.photo = "/newImage/article/202004/90a7acaa8ef84beda159c7af6c62d5e2.jpeg"
                model1.createTime = "2020-04-01 11:07:29"
                model1.visitNum = 129
                model1.commentsNum = 4
                model1.likesNum = 1
                
                let datas = ZQTextureListDatasModel()
                datas.content = [model0, model1]
                
                let page = ZQPageModel()
                page.totalCount = 12
                datas.page = page
                model.datas = datas
            }
            let articleArr = model.datas?.content ?? [ZQTextureArticleModel]()
            self.handleData(articleArr, scrollView: scrollView, isFirstFetch: isFirstFetch, totalCount: model.datas?.page?.totalCount ?? 0)
            
            completion()
        }.catch { (error) in
            print("--__--|| error___\(error)")
            
            /// 测试数据
            let model0 = ZQTextureArticleModel()
            model0.id = 626248
            model0.title = "听说马可波罗很帅"
            model0.photo = "/newImage/article/202004/be8aa1259c13457ca15fc9533cd66dd5.jpeg"
            model0.createTime = "2020-04-10 10:43:29"
            model0.visitNum = 8
            model0.commentsNum = 0
            model0.likesNum = 0
            
            let model1 = ZQTextureArticleModel()
            model1.id = 610050
            model1.title = "就是个帅哥"
            model1.photo = "/newImage/article/202004/90a7acaa8ef84beda159c7af6c62d5e2.jpeg"
            model1.createTime = "2020-04-01 11:07:29"
            model1.visitNum = 129
            model1.commentsNum = 4
            model1.likesNum = 1
            
            let datas = ZQTextureListDatasModel()
            datas.content = [model0, model1]
            
            let page = ZQPageModel()
            page.totalCount = 12
            datas.page = page
            
            let model = ZQTextureListResModel()
            model.datas = datas
            let articleArr = model.datas?.content ?? [ZQTextureArticleModel]()
            self.handleData(articleArr, scrollView: scrollView, isFirstFetch: isFirstFetch, totalCount: model.datas?.page?.totalCount ?? 0)
            
            completion()
        }
    }
    
    /// 请求详情数据
    /// - Parameters:
    ///   - id: id
    ///   - completion: 回调
    func requestDetailData(id:String, completion:@escaping (() -> ())) {
        ZQMoyaManager.callTextureApiMapObject(.detail(id: id), type: ZQTextureDetailResModel.self).done { (model) in
            self.detailModel = model.datas
            completion()
        }.catch { (error) in
            print("--__--|| error___\(error)")
            
            /// 测试数据
            let model = ZQTextureDetailModel()
            model.id = 610050
            model.photo = "/newImage/article/202004/90a7acaa8ef84beda159c7af6c62d5e2.jpeg"
            model.headimg = "/product/201912/a8323d1593a843f59f3982ac0e4354ee.jpeg"
            model.nickname = "渣渣蛙"
            model.createTime = "2020-04-01 11:07:29"
            model.title = "就是个帅哥"
            model.visitNum = 9
            model.commentsNum = 4
            model.likesNum = 1
            model.islikes = true
            model.content = "送你红想日先票也软用我一样上下坡魔攻哦米西米西明年<img src=\"https://sami-1256315447.picgz.myqcloud.com/newImage/text/202004/3fbd62a2ae5b496e993bcaddfe61e3db_750.jpeg\"alt=\"\">回信息嘻嘻嘻嘻嘻嘻嘻嘻网易云一直一直<img src=\"https://sami-1256315447.picgz.myqcloud.com/newImage/text/202004/00230b991695462f8f3643665640037a_750.jpeg\"alt=\"\">送送闽宁镇信息系职工吸吸引嘻嘻嘻嘻嘻我一直在哦哟啥又日在自有一人之用易烊千玺哦哟上下坡买一送一弄破没什么送你女人<img src=\"https://sami-1256315447.picgz.myqcloud.com/newImage/text/202004/146c3504a23348dbae42c4782c5dacc6_750.jpeg\"alt=\"\">送你在真日为企业嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻致命哦嘻嘻益智游戏嘻嘻嘻嘻嘻实习医院用肉也软中啥又日在哦嘻嘻嘻嘻哦嘻嘻嘻嘻吸引只有OMG移民你仔细哦以为上下坡orz婆婆哦哟啥又日在哦哟啥又日在某一种你是想让我哦哟啥又日在哦哟啥又日在哦哟啥又日为莫斯外婆"
            self.detailModel = model
            completion()
        }
    }
    
    /// 请求推荐文章数据
    /// - Parameters:
    ///   - id: id
    ///   - completion: 回调
    func requestRecommendArticleData(id:String, completion:@escaping (() -> ())) {
        ZQMoyaManager.callTextureApiMapObject(.recommendArticle(id: id), type: ZQTextureRecommendArticleResModel.self).done { (model) in
            self.recommendArticleArr = model.datas ?? [ZQTextureArticleModel]()
            completion()
        }.catch { (error) in
            print("--__--|| error___\(error)")
            
            /// 测试数据
            let model0 = ZQTextureArticleModel()
            model0.id = 204477
            model0.title = "种草+干货  | 十元以内手帐好物分享（内含隐形胶带使用教程）"
            model0.createTime = "2019-07-08 10:08:52"
            model0.photo = "/article/201907/a54c68b2cc6043b5924b3aaf8a371774.jpg"
            
            let model1 = ZQTextureArticleModel()
            model1.id = 89570
            model1.title = "教你30分钟内完成9张超美拼贴！"
            model1.createTime = "2019-03-11 11:32:20"
            model1.photo = "/article/201903/a49b2ec190664cbf90f9c3542ae13f28.jpg"
            
            let model2 = ZQTextureArticleModel()
            model2.id = 559520
            model2.title = "关于肉球，一些构图技巧分享"
            model2.createTime = "2020-03-03 16:33:23"
            model2.photo = "/newImage/ad/202003/f10cf0f54a754c98ba2d26fcc51b33ff.jpeg"
            
            let model3 = ZQTextureArticleModel()
            model3.id = 262462
            model3.title = "干货  |  盐系手帐排版拼贴教程"
            model3.createTime = "2019-08-12 15:41:44"
            model3.photo = "/article/201908/4e7090cfa2a4494db88ed4ce8e945cae.jpg"
            
            let model4 = ZQTextureArticleModel()
            model4.id = 460655
            model4.title = "目前圈内最好的造景干货合集（上）"
            model4.createTime = "2019-12-27 15:14:32"
            model4.photo = "/newImage/ad/201912/c6683e025783432f8051bdf762f6cbc7.jpg"
            self.recommendArticleArr = [model0, model1, model2, model3, model4]
            completion()
        }
    }
    
    /// 请求评论数据
    /// - Parameters:
    ///   - id: id
    ///   - scrollView: 滚动视图
    ///   - completion: 回调
    func requestCommentData(isFirstFetch: Bool, id:String, scrollView:UIScrollView, completion:@escaping (() -> ())) {
        ZQMoyaManager.callTextureApiMapObject(.articleComment(id: id, page: caculatePage(isFirstFetch), perPage: perPage), type: ZQTextureArticleCommentResModel.self).done { (model) in
            
//            let commentArr = model.datas?.content ?? [ZQTextureArticleCommentModel]()
//            self.handleData(commentArr, scrollView: scrollView, isFirstFetch: isFirstFetch, totalCount: model.datas?.page?.totalCount ?? 0)
            
            /// 测试数据
            var commentArr = [ZQTextureArticleCommentModel]()
            for i in 0..<10 {
                let comment = ZQTextureArticleCommentModel()
                comment.id = "83761"
                let formUserInfo = ZQTextureArticleCommentUserModel()
                formUserInfo.userId = "300763"
                formUserInfo.nickname = "渣渣蛙"
                formUserInfo.headimg = "/product/201912/a8323d1593a843f59f3982ac0e4354ee.jpeg"
                comment.formUserInfo = formUserInfo
                comment.isLike = false
                comment.like = 0
                comment.aid = "610050"
                comment.comment = "你再皮笑肉一肉\(i)"
                comment.parentIds = "0"
                comment.createTime = "2020-04-01 11:08:03"
                
                let toUserInfo = ZQTextureArticleCommentUserModel()
                toUserInfo.userId = "300764"
                toUserInfo.nickname = "兜兜卖"
                toUserInfo.headimg = "/product/201912/a8323d1593a843f59f3982ac0e4354ee.jpeg"
                
                var childCommentArr = [ZQTextureArticleChildCommentModel]()
                for j in 0..<4 {
                    let childComment = ZQTextureArticleChildCommentModel()
                    childComment.id = "\(83762 + j)"
                    childComment.formUserInfo = formUserInfo
                    childComment.toUserInfo = j % 2 == 0 ? formUserInfo : toUserInfo
                    childComment.comment = "地方的看法京东快递防静电东方季道减肥的解放军东方季道科技发快递积分大富科技点击辅导费对方就看见的解放军打飞机东方健康的减肥的减肥的房价的看法京东方对方就看到房价地方加大富科技"
                    childCommentArr.append(childComment)
                }
                comment.childComment = childCommentArr
                commentArr.append(comment)
            }
            self.handleData(commentArr, scrollView: scrollView, isFirstFetch: isFirstFetch, totalCount: 20)
            
            completion()
        }.catch { (error) in
            print("--__--|| error___\(error)")
            
            /// 测试数据
                        var commentArr = [ZQTextureArticleCommentModel]()
            for i in 0..<10 {
                let comment = ZQTextureArticleCommentModel()
                comment.id = "83761"
                let formUserInfo = ZQTextureArticleCommentUserModel()
                formUserInfo.userId = "300763"
                formUserInfo.nickname = "渣渣蛙"
                formUserInfo.headimg = "/product/201912/a8323d1593a843f59f3982ac0e4354ee.jpeg"
                comment.formUserInfo = formUserInfo
                comment.isLike = false
                comment.like = 0
                comment.aid = "610050"
                comment.comment = "你再皮笑肉一肉\(i)"
                comment.parentIds = "0"
                comment.createTime = "2020-04-01 11:08:03"
                
                let toUserInfo = ZQTextureArticleCommentUserModel()
                toUserInfo.userId = "300764"
                toUserInfo.nickname = "兜兜卖"
                toUserInfo.headimg = "/product/201912/a8323d1593a843f59f3982ac0e4354ee.jpeg"
                
                var childCommentArr = [ZQTextureArticleChildCommentModel]()
                for j in 0..<4 {
                    let childComment = ZQTextureArticleChildCommentModel()
                    childComment.id = "\(83762 + j)"
                    childComment.formUserInfo = formUserInfo
                    childComment.toUserInfo = j % 2 == 0 ? formUserInfo : toUserInfo
                    childComment.comment = "地方的看法京东快递防静电东方季道减肥的解放军东方季道科技发快递积分大富科技点击辅导费对方就看见的解放军打飞机东方健康的减肥的减肥的房价的看法京东方对方就看到房价地方加大富科技"
                    childCommentArr.append(childComment)
                }
                comment.childComment = childCommentArr
                commentArr.append(comment)
            }
            self.handleData(commentArr, scrollView: scrollView, isFirstFetch: isFirstFetch, totalCount: 20)
            completion()
        }
    }
}

// MARK: ZQPageFetchProtocol
extension ZQTextureViewModel {
     override func injectData(_ datas: [AnyObject], isFirstFetch: Bool) {
        guard let first = datas.first else { return }
        if first.isKind(of: ZQTextureArticleModel.self) {
            var articleArr = datas as! [ZQTextureArticleModel]
            articleArr = articleArr.map({ (item) -> ZQTextureArticleModel in
                if let date = item.createTime?.toDate() {
                    item.timeMark = "\(date.year)-\(date.month)-\(date.day)"
                }
                return item
            })
            let groupedDictionary = Dictionary(grouping: articleArr, by: {$0.timeMark})
            let sortedGroupedDictionary = groupedDictionary.sorted { (item1, item2) -> Bool in
                if let date1 = item1.key.toDate()?.date, let date2 = item2.key.toDate()?.date {
                    return date1 > date2
                }
                else {
                    return true
                }
            }
            if isFirstFetch {
                articleListDic.removeAll()
            }
            articleListDic += sortedGroupedDictionary
        }
        else if first.isKind(of: ZQTextureArticleCommentModel.self) {
            if isFirstFetch {
                commentArr = datas as! [ZQTextureArticleCommentModel]
            }
            else {
                commentArr += datas as! [ZQTextureArticleCommentModel]
            }
        }
    }
}
