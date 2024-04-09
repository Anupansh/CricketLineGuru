//
//  LGUserModel.swift
//  Created by Girijesh Kumar on 18/12/17.
//  Copyright © 2017 Girijesh Kumar. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK:CLG Home View Api models

class HomeApiResponseV3:CLGBaseModel
{
    var responseData:CLGHomeResponseDataV3?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        responseData <- map["responseData"]
    }
}
class CLGHomeResponseDataV3 : CLGBaseModel {
    var message:String?
    var accessToken:String?
    var result:CLGHomeResponseResultData?
    var prediction_stats:CLGPredictionPollsResponse?
    var polls:[CLGPollsModel]?//
    var totalPoll:Int?
    var correctPoll:Double?
    var incorrectPoll:Double?
    var pendingPoll:Double?
    var userProfile:CLGUserProfile?
    var vers : CLGHomeResponseDataVersV3? //
    var api : CLGHomeResponseDataApiV3? //
    var news : [CLGHomeResponseDataNewsV3]? //
    var newsPath : String? //
    var series : [CLGHomeResponseDataSeriesV3]? //
    var fbPath : String? //
    var match : [CLGRecentMatchModelV3]?
    var teamsPath : String?//n
    var playerPath: String?
    var pP : String?
    var pageNo : Int?
    var placeHolder : String?//n
    var info:CLGMatchInfo?//n
    var team:[CLGTeamNameModel]?
    var totalCount:Int?
    var players:[CLGTeamNameModel]?
    var plrs:[CLGTeamNameModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        pageNo <- map["pageNo"]
        teamsPath <- map["teamsPath"]
        match <- map["match"]
        userProfile <- map["userProfile"]
        result <- map["result"]
        message <- map["message"]
        accessToken <- map["accessToken"]
        prediction_stats <- map["prediction_stats"]
        polls <- map["polls"]
        totalPoll <- map["totalPoll"]
        correctPoll <- map["correctPoll"]
        incorrectPoll <- map["incorrectPoll"]
        pendingPoll <- map["pendingPoll"]
        vers <- map["vers"]
        api <- map["api"]
        news <- map["news"]
        newsPath <- map["newsPath"]
        series <- map["series"]
        fbPath <- map["fbPath"]
        placeHolder <- map["placeHolder"]
        info <- map["info"]
        team <- map["team"]
        totalCount <- map["totalCount"]
        players <- map["players"]
        playerPath <- map["playerPath"]
        plrs <- map["plrs"]
        pP <- map["pP"]
    }
    
}
class CLGHomeResponseDataApiV3 : CLGBaseModel {
    var rec_t20 : String?
    var rec_test : String?
    var match : String?
    var rec_odi : String?
    var ranking : String?
    var series : String?
    var team : String?
    var player : String?
    var news : String?
    var home : String?
    var trend_team : String?
    var trend_plr : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        rec_t20 <- map["rec_t20"]
        rec_test <- map["rec_test"]
        match <- map["match"]
        rec_odi <- map["rec_odi"]
        ranking <- map["ranking"]
        series <- map["series"]
        team <- map["team"]
        player <- map["player"]
        news <- map["news"]
        home <- map["home"]
        trend_team <- map["trend_team"]
        trend_plr <- map["trend_plr"]
    }
    
}
class CLGHomeResponseDataSeriesV3 : CLGBaseModel {
    var _id : String?
    var key : String?
    var name : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        _id <- map["_id"]
        key <- map["key"]
        name <- map["name"]
    }
    
}

class CLGHomeResponseDataNewsV3 : CLGBaseModel {
    var _id : String?
    var title : String?
    var created : String?
    var image : String?
    var description : String?
    var is_link : Bool? //
    var url_link : String? //
    var img_lnk : String?
    var type: Int?
    var an_url: String?
    var ios_url: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        _id <- map["_id"]
        title <- map["title"]
        created <- map["created"]
        image <- map["image"]
        description <- map["description"]
        is_link <- map["is_link"]
        url_link <- map["url_link"]
        img_lnk <- map["img_lnk"]
        type <- map["type"]
        an_url <- map["an_url"]
        ios_url <- map["ios_url"]
    }
    
}
class CLGHomeResponseDataVersV3 : CLGBaseModel {
    var aLV : Double?
    var aMV : Double?
    var iLV : Double?
    var iMV : Double?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        aLV <- map["aLV"]
        aMV <- map["aMV"]
        iLV <- map["iLV"]
        iMV <- map["iMV"]
    }
    
}
class HomeApiResponse:CLGBaseModel
{
    var responseData:CLGHomeResponseData?
    
   override func mapping(map: Map)
   {
        super.mapping(map: map)
        responseData <- map["responseData"]
    }
}

class CLGHomeResponseData:CLGBaseModel
{
    var message:String?
    var accessToken:String?
    var result:CLGHomeResponseResultData?
    var prediction_stats:CLGPredictionPollsResponse?
    var polls:[CLGPollsModel]?
    var totalPoll:Int?
    var correctPoll:Double?
    var incorrectPoll:Double?
    var pendingPoll:Double?
    var userProfile:CLGUserProfile?
    var msg:String?
    var points:CLGPointsInfo?//
    var series:CLGHomeResponseResultSeriesData?//
    var teamsPath:String?
    var matches:[CLGRecentMatchModel]?//
    var team:[CLGTeamNameModel]?
    var totalCount:Int?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        userProfile <- map["userProfile"]
        result <- map["result"]
        message <- map["message"]
        accessToken <- map["accessToken"]
        prediction_stats <- map["prediction_stats"]
        polls <- map["polls"]        
        totalPoll <- map["totalPoll"]
        correctPoll <- map["correctPoll"]
        incorrectPoll <- map["incorrectPoll"]
        pendingPoll <- map["pendingPoll"]
        msg <- map["msg"]
        points <- map["points"]
        series <- map["series"]
        teamsPath <- map["teamsPath"]
        matches <- map["matches"]
        team <- map["team"]
        totalCount <- map["totalCount"]

    }
}

class CLGUserProfile : CLGBaseModel{
    var _id:String?
    
    override func mapping(map: Map)
    {
        _id <- map["_id"]
    }
}

class CLGPollsModel : CLGBaseModel{
    
    var _id : String?//n
    var matchStatus : Int?
    var matchDate : Int64?//n
    var teamId1 : TeamId1?//
    var t1 : TeamId1?//n
    var teamId2 : TeamId1?//
    var t2 : TeamId1?//n
    var matchType : String?//n
    var pollQuestion : String?//n
    var totalVotes : Int?//n
    var tieCount : Int?//n
    var tieCnt : Int?//
    var teamCount1 : Int?//n
    var teamCnt1 : Int?//
    var teamCount2 : Int?//n
    var teamCnt2 : Int?//
    var status : Int?//
    var isPollSubmitted : Bool?
    var isPollSub : Bool?//
    var poll_options : [Poll_options]?
    var pollOpt : [Poll_options]?
    var myPoll:String?
    var winTeam:String?
    var user_match_res:Int?
    var teams:String?
    var match_date:Int?
    var date:Int?//
    var ques:String?//
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        _id <- map["_id"]
        matchStatus <- map["matchStatus"]
        matchDate <- map["matchDate"]
        teamId1 <- map["teamId1"]
        teamId2 <- map["teamId2"]
        matchType <- map["mType"]
        pollQuestion <- map["pollQuestion"]
        totalVotes <- map["totalVotes"]
        tieCount <- map["tieCount"]
        teamCount1 <- map["teamCount1"]
        teamCount2 <- map["teamCount2"]
        status <- map["status"]
        isPollSubmitted <- map["isPollSubmitted"]
        poll_options <- map["poll_options"]
        myPoll <- map["myPoll"]
        winTeam <- map["winTeam"]
        user_match_res <- map["user_match_res"]
        teams <- map["teams"]
        match_date <- map["match_date"]
        date <- map["date"]
        ques <- map["ques"]
        tieCnt <- map["tieCnt"]
        teamCnt1 <- map["teamCnt1"]
        teamCnt2 <- map["teamCnt2"]
        isPollSub <- map["isPollSub"]
        pollOpt <- map["pollOpt"]
        t1 <- map["t1"]
        t2 <- map["t2"]
    }
}

class TeamId1:CLGBaseModel{
    
    var _id : String?
    var key : String?
    var _v : Int?
    var board_team_key : String?
    var created : String?
    var name : String?//n
    var season : String?
    var updated : String?
    var players : [String]?
    var logo:String?//n
    var bkey:String?//n

    override func mapping(map: Map)
    {
        super.mapping(map: map)
        _id <- map["_id"]
        key <- map["key"]
        _v <- map["_v"]
        board_team_key <- map["board_team_key"]
        created <- map["created"]
        name <- map["name"]
        season <- map["season"]
        updated <- map["updated"]
        players <- map["players"]
        logo <- map["logo"]
        bkey <- map["bkey"]
    }
}

class Poll_options:CLGBaseModel{
    
    var option_id : Int?
    var option_text : String?
    var id : Int?
    var txt : String?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        option_id <- map["option_id"]
        option_text <- map["option_text"]
        id <- map["id"]
        txt <- map["txt"]
    }
}

class CLGPredictionPollsResponse:CLGBaseModel{
    
    var total_polls:Int?
    var correct_count:Int?
    var incorrect_count:Int?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        total_polls <- map["total_polls"]
        correct_count <- map["correct_count"]
        incorrect_count <- map["incorrect_count"]
    }
}

class CLGPlayerDetailApiResponse:CLGBaseModel
{
    var responseData:CLGPlayerDetailResponseData?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        responseData <- map["responseData"]
    }
}

class CLGPlayerDetailResponseData:CLGBaseModel
{
    var message:String?
    var result:CLGPlayerDetailModel?
    var player:CLGTeamNameModel?

    override func mapping(map: Map)
    {
        super.mapping(map: map)
        result <- map["result"]
        message <- map["message"]
        player <- map["player"]
    }
}

class CLGPlayerDetailModel:CLGBaseModel
{
    var player:CLGTeamNameModel?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        player <- map["player"]
    }
}
class CLGPointsInfoTeams : CLGBaseModel
{
    var _id : String?
    var name : String?
    var lost : Int?
    var played : Int?
    var net_run_rate : Double?
    var no_result : Int?
    var short_name : String?
    var tied : Int?
    var won : Int?
    var points : Int?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        _id <- map["_id"]
        name <- map["name"]
        lost <- map["lost"]
        played <- map["played"]
        net_run_rate <- map["net_run_rate"]
        no_result <- map["no_result"]
        short_name <- map["short_name"]
        tied <- map["tied"]
        won <- map["won"]
        points <- map["points"]

    }
}

class CLGPointsInfo : CLGBaseModel {
    var _id : String?
    var key : String?
    var __v : Int?
    var name : String?
    var short_name : String?
    var teams : [CLGPointsInfoTeams]?
    var updated : String?
    
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        _id <- map["_id"]
        key <- map["key"]
        __v <- map["__v"]
        name <- map["name"]
        short_name <- map["short_name"]
        teams <- map["teams"]
        updated <- map["updated"]
    }
    
}
class CLGHomeResponseResultData:CLGBaseModel
{
    var texts:CLGHomeResponseResultDisclamer?
    var versionInfo:CLGHomeResponseResultversionInfoData?
    var apiInfo:CLGHomeResponseResultapiInfoData?
    var series:[CLGHomeResponseResultSeriesData]?
    var news:[CLGHomeResponseResultNewsData]?
    var match:[CLGRecentMatchModel]?
    var totalCount:Int?
    var odiTeams:[CLGRankingResponseModel]?
    var testTeams:[CLGRankingResponseModel]?
    var t20Teams:[CLGRankingResponseModel]?
    var odiBatsman:[CLGRankingResponseModel]?
    var odiBowler:[CLGRankingResponseModel]?
    var odiAllRounder:[CLGRankingResponseModel]?
    var testBatsman:[CLGRankingResponseModel]?
    var testBowler:[CLGRankingResponseModel]?
    var testAllRounder:[CLGRankingResponseModel]?
    var t20Batsman:[CLGRankingResponseModel]?
    var t20Bowler:[CLGRankingResponseModel]?
    var t20AllRounder:[CLGRankingResponseModel]?
    var pointInfo:CLGPointsInfo?
    var seriesInfo:CLGHomeResponseResultSeriesData?
    var team:[CLGTeamNameModel]?
    var matchUpcomming:[CLGRecentMatchModel]?
    var matchRecent:[CLGRecentMatchModel]?
    var player:[CLGTeamNameModel]?
    var currentRanking:[CLGUserModel]?
    var pastRanking:[CLGUserModel]?

    override func mapping(map: Map)
    {
        super.mapping(map: map)
        texts <- map["texts"]
        pointInfo <- map["pointInfo"]
        currentRanking <- map["currentRanking"]
        pastRanking <- map["pastRanking"]
        news <- map["news"]
        series <- map["series"]
        apiInfo <- map["apiInfo"]
        versionInfo <- map["versionInfo"]
        match <- map["match"]
        totalCount <- map["totalCount"]
        odiTeams <- map["odiTeams"]
        testTeams <- map["testTeams"]
        t20Teams <- map["t20Teams"]
        odiBatsman <- map["odiBatsman"]
        odiBowler <- map["odiBowler"]
        odiAllRounder <- map["odiAllRounder"]
        testBatsman <- map["testBatsman"]
        testBowler <- map["testBowler"]
        testAllRounder <- map["testAllRounder"]
        t20Batsman <- map["t20Batsman"]
        t20Bowler <- map["t20Bowler"]
        t20AllRounder <- map["t20AllRounder"]
        seriesInfo <- map["seriesInfo"]
        team <- map["team"]
        matchUpcomming <- map["matchUpcomming"]
        matchRecent <- map["matchRecent"]
        player <- map["player"]
    }
}
class CLGUserModel:CLGBaseModel{
    
    var _id : String?
    var userPhone : String?
    var gender : Int?
    var name : String?
    var username : String?
    var dob : String?
    var profileImage : String?
    var deviceTypeId : Int?
    var totalPred : Int?
    var wonPred : Int?
    var lostPred : Int?
    var status : Int?
    var isGuest : Int?
    var isVarified : Int?
    var isPaid : Int?
    var userRank : Int?
    var isMyRank : Int?
    var prize : String?
    var userInfo : CLGUserModel?
    
    override func mapping(map: Map)
    {
        prize <- map["prize"]
        isPaid <- map["isPaid"]
        userRank <- map["userRank"]
        isMyRank <- map["isMyRank"]
        userInfo <- map["userInfo"]
        _id <- map["_id"]
        gender <- map["gender"]
        name <- map["name"]
        username <- map["username"]
        dob <- map["dob"]
        profileImage <- map["profileImage"]
        deviceTypeId <- map["deviceTypeId"]
        totalPred <- map["totalPred"]
        wonPred <- map["wonPred"]
        lostPred <- map["lostPred"]
        status <- map["status"]
        isGuest <- map["isGuest"]
        isVarified <- map["isVarified"]
        userPhone <- map["userPhone"]
    }
}
class CLGHomeResponseResultDisclamer:CLGBaseModel{
    var disclaimerParagraphs:String?

    override func mapping(map: Map){
        super.mapping(map: map)
        disclaimerParagraphs <- map["disclaimerParagraphs"]
    }
}
class CLGTeamNameModel:CLGBaseModel{
    
    var _id:String?
    var key:String?
    var board_team_key:String?
    var name:String?
    var season:String?
    var logo:String?
    var full_name:String?
    var playerImage:String?
    var batting_styles:[String]?
    var bowling_styles:[String]?
    var created:String?
    var identified_roles:CLGPlayerDetailRoleModel?
    var updated:String?
    var stats:CLGPlayerDetailStatsModel?
    var t_key: String?
    var cntry : String?
    var teams: String?
    var desc: String?
    var roles:CLGPlayerDetailRoleModel?
    var btng:[String]?
    var bwl:[String]?
    var f_name:String?
    
    override func mapping(map: Map){
        super.mapping(map: map)
        _id <- map["_id"]
        key <- map["key"]
        board_team_key <- map["board_team_key"]
        name <- map["name"]
        season <- map["season"]
        logo <- map["logo"]
        full_name <- map["full_name"]
        playerImage <- map["playerImage"]
        batting_styles <- map["batting_styles"]
        bowling_styles <- map["bowling_styles"]
        created <- map["created"]
        identified_roles <- map["identified_roles"]
        updated <- map["updated"]
        created <- map["created"]
        stats <- map["stats"]
        t_key <- map["t_key"]
        cntry <- map["cntry"]
        teams <- map["teams"]
        desc <- map["desc"]
        roles <- map["roles"]
        btng <- map["btng"]
        bwl <- map["bwl"]
        f_name <- map["f_name"]
    }
}

class CLGPlayerDetailStatsModel:CLGBaseModel{
    
    var one_day:CLGPlayerDetailStatsTypeModel?
    var t20:CLGPlayerDetailStatsTypeModel?
    var test:CLGPlayerDetailStatsTypeModel?
    
    override func mapping(map: Map){
        super.mapping(map: map)
        one_day <- map["one_day"]
        t20 <- map["t20"]
        test <- map["test"]
    }
}

class CLGPlayerDetailStatsTypeModel:CLGBaseModel{
    
    var batting:CLGPlayerDetailStatsTypeBattingModel?
    var bowling:CLGPlayerDetailStatsTypeBowlingModel?
    var fielding:CLGPlayerDetailStatsTypeFieldingModel?
    var last_match_date:String?
    var last_match_key:String?
    var last_update_time:String?
    
    override func mapping(map: Map){
        super.mapping(map: map)
        batting <- map["batting"]
        bowling <- map["bowling"]
        fielding <- map["fielding"]
        last_match_date <- map["last_match_date"]
        last_match_key <- map["last_match_key"]
        last_update_time <- map["last_update_time"]
    }
}

class CLGPlayerDetailStatsTypeBattingModel:CLGBaseModel{
    
    var average:Double?
    var balls:Int?
    var fifties:Int?
    var fours:Int?
    var high_score:String?
    var hundreds:Int?
    var innings:Int?
    var matches:Int?
    var not_outs:Int?
    var runs:Int?
    var sixes:Int?
    var strike_rate:Double?
    
    override func mapping(map: Map){
        super.mapping(map: map)
        average <- map["average"]
        balls <- map["balls"]
        fifties <- map["fifties"]
        fours <- map["fours"]
        high_score <- map["high_score"]
        hundreds <- map["hundreds"]
        innings <- map["innings"]
        matches <- map["matches"]
        not_outs <- map["not_outs"]
        runs <- map["runs"]
        strike_rate <- map["strike_rate"]
        sixes <- map["sixes"]
    }
}

class CLGPlayerDetailStatsTypeBowlingModel:CLGBaseModel{
    
    var average:Double?
    var balls:Int?
    var best_innings_bowling:String?
    var economy:Double?
    var five_wickets:Int?
    var four_wickets:Int?
    var innings:Int?
    var matches:Int?
    var runs:Int?
    var ten_wickets:Int?
    var wickets:Int?
    var strike_rate:Double?
    
    override func mapping(map: Map){
        super.mapping(map: map)
        average <- map["average"]
        balls <- map["balls"]
        best_innings_bowling <- map["best_innings_bowling"]
        economy <- map["economy"]
        five_wickets <- map["five_wickets"]
        four_wickets <- map["four_wickets"]
        innings <- map["innings"]
        matches <- map["matches"]
        runs <- map["runs"]
        strike_rate <- map["strike_rate"]
        ten_wickets <- map["ten_wickets"]
        strike_rate <- map["strike_rate"]
    }
}

class CLGPlayerDetailStatsTypeFieldingModel:CLGBaseModel{
    
    var catches:Int?
    var stumpings:Int?
    
    override func mapping(map: Map){
        super.mapping(map: map)
        catches <- map["catches"]
        stumpings <- map["stumpings"]
    }
}

class CLGPlayerDetailRoleModel:CLGBaseModel{
    
    var batsman:Bool?
    var bowler:Bool?
    var keeper:Bool?
    
    override func mapping(map: Map){
        super.mapping(map: map)
        batsman <- map["batsman"]
        bowler <- map["bowler"]
        keeper <- map["keeper"]
    }
}

class CLGRankingResponseModel:CLGBaseModel{
    
    var player_name:String?
    var team:String?
    var player_type:Int?
    var team_name:String?
    var position:Int?
    var points:Int?
    var rating:Int?
    var matches:Int?
    var match_type:Int?
    var status:Int?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        player_name <- map["player_name"]
        team <- map["team"]
        player_type <- map["player_type"]
        team_name <- map["team_name"]
        position <- map["position"]
        points <- map["points"]
        rating <- map["rating"]
        matches <- map["matches"]
        match_type <- map["match_type"]
        status <- map["status"]
    }
}

class CLGRecentMatchModelV3:CLGBaseModel{
    
    var _id:String?
    var key:String?
    var format:String?
    var name:String?
    var rel_name:String?
    var sh_name:String?
    var status:String?
    var venue:String?
    var st_date:String?
    var is_score:Int?
    var is_comm:Int?
    var season:CLGHomeResponseResultSeriesData?
    var teams:CLGRecentMatchTeamModel?
    var msgs:CLGRecentMatchMsgModel?
    var info:String?
    var s_name:String?
    
    override func mapping(map: Map){
        super.mapping(map: map)
        _id <- map["_id"]
        key <- map["key"]
        is_score <- map["is_score"]
        is_comm <- map["is_comm"]
        format <- map["format"]
        name <- map["name"]
        rel_name <- map["rel_name"]
        sh_name <- map["sh_name"]
        status <- map["status"]
        venue <- map["venue"]
        st_date <- map["st_date"]
        season <- map["season"]
        teams <- map["teams"]
        msgs <- map["msgs"]
        info <- map["info"]
        s_name <- map["s_name"]
    }
}
class CLGRecentMatchModel:CLGBaseModel{
    
    var _id:String?
    var key:String?
    var format:String?
    var name:String?
    var related_name:String?
    var short_name:String?
    var status:String?
    var venue:String?
    var start_date:String?
    var score_card_available:Int?
    var commentary_available:Int?
    var season:CLGHomeResponseResultSeriesData?
    var teams:CLGRecentMatchTeamModel?
    var msgs:CLGRecentMatchMsgModel?
    var rel_name:String?//
    var sh_name:String?//
    var st_date:String?//
    var win_team:String?//
    
    override func mapping(map: Map){
        super.mapping(map: map)
        _id <- map["_id"]
        key <- map["key"]
        score_card_available <- map["score_card_available"]
        commentary_available <- map["commentary_available"]
        format <- map["format"]
        name <- map["name"]
        related_name <- map["related_name"]
        short_name <- map["short_name"]
        status <- map["status"]
        venue <- map["venue"]
        start_date <- map["start_date"]
        season <- map["season"]
        teams <- map["teams"]
        msgs <- map["msgs"]
        rel_name <- map["rel_name"]
        sh_name <- map["sh_name"]
        st_date <- map["st_date"]
        win_team <- map["win_team"]
    }
}

class CLGRecentMatchMsgModel:CLGBaseModel{
    
    var info:String?
    var completed:String?
    var result:String?
    
    override func mapping(map: Map){
        super.mapping(map: map)
        info <- map["info"]
        completed <- map["completed"]
        result <- map["result"]
    }
}

class CLGRecentMatchTeamModel:CLGBaseModel{
    
    var a:CLGHomeResponseResultSeriesData?
    var b:CLGHomeResponseResultSeriesData?
    
    override func mapping(map: Map){
        super.mapping(map: map)
        a <- map["a"]
        b <- map["b"]
    }
}

class CLGHomeResponseResultSeriesDictData:CLGBaseModel
{
    var totalCount:Int?
    var series:[CLGHomeResponseResultSeriesData]?
    
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        totalCount <- map["totalCount"]
        series <- map["series"]
    }
}

class CLGHomeResponseResultversionInfoData:CLGBaseModel
{
    var iosLatestVersion:Double?
    var iosMinimumVersion:Double?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        iosMinimumVersion <- map["iosMinimumVersion"]
        iosLatestVersion <- map["iosLatestVersion"]
    }
}

class CLGHomeResponseResultapiInfoData:CLGBaseModel
{
    var match:String?
    var ranking:String?
    var news:String?
    var series:String?
    var team:String?
    var player:String?
    var home_change:String?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        home_change <- map["home_change"]
        match <- map["match"]
        ranking <- map["ranking"]
        news <- map["news"]
        series <- map["series"]
        team <- map["team"]
        player <- map["player"]
    }
}
class CLGSeriesApiResponse:CLGBaseModel
{
    var responseData:CLGSeriesApiResponseData?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        responseData <- map["responseData"]
    }
}
class CLGSeriesApiResponseData:CLGBaseModel
{
    var message:String?
    var result:CLGSeriesApiResponseResult?
    var series:[CLGHomeResponseResultSeriesArrData]?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        message <- map["message"]
        result <- map["result"]
        series <- map["series"]
    }
}
class CLGSeriesApiResponseResult:CLGBaseModel
{
    var series:[CLGHomeResponseResultSeriesArrData]?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        series <- map["series"]
    }
}
class CLGHomeResponseResultSeriesArrData:CLGBaseModel
{
    var year:String?
    var data:[CLGHomeResponseResultSeriesData]?

    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        year <- map["year"]
        data <- map["data"]
    }
}
class CLGHomeResponseResultSeriesData:CLGBaseModel
{
    var _id:String?
    var venue:String?
    var series:String?
    var short_name:String?
    var card_name:String?
    var isHome:Int?
    var isComp:Int?//
    var start_date:CLGHomeResponseResultSeriesDateData?
    //var end_date:CLGHomeResponseResultSeriesDateData?
    var status:Int?
    var key:String?
    var name:String?
    var logo:String?
    var matches:[CLGHomeResponseResultSeriesMatchesData]?
    var st_date:Int64?//
    var st_iso:String?//
    var end_date:Int64?//
    
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        key <- map["key"]
        name <- map["name"]
        logo <- map["logo"]
        _id <- map["_id"]
        venue <- map["venue"]
        series <- map["series"]
        short_name <- map["short_name"]
        card_name <- map["card_name"]
        isHome <- map["isHome"]
        start_date <- map["start_date"]
        status <- map["status"]
        matches <- map["matches"]
        //end_date <- map["end_date"]
        isComp <- map["isComp"]
        st_date <- map["st_date"]
        st_iso <- map["st_iso"]
        end_date <- map["end_date"]
        
    }
}

class CLGHomeResponseResultSeriesMatchesData:CLGBaseModel
{
    var _id:String?
    var key:String?
    var format:String?
    var name:String?
    var venue:String?
    var score_card_available:Int?
    var commentary_available:Int?
    var title:String?
    var related_name:String?
    var status:String?
    var start_date:CLGHomeResponseResultSeriesDateData?
    var teams:CLGRecentMatchTeamModel?
    var season:CLGHomeResponseResultSeriesData?
    var msgs:CLGRecentMatchMsgModel?
    var st_date:String?//iso
    var rel_name:String?//
    var is_score:Int?//
    var is_comm:Int?//
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        score_card_available <- map["score_card_available"]
        commentary_available <- map["commentary_available"]
        _id <- map["_id"]
        key <- map["key"]
        format <- map["format"]
        name <- map["name"]
        venue <- map["venue"]
        title <- map["title"]
        related_name <- map["related_name"]
        status <- map["status"]
        start_date <- map["start_date"]
        teams <- map["teams"]
        season <- map["season"]
        msgs <- map["msgs"]
        st_date <- map["st_date"]
        rel_name <- map["rel_name"]
        is_score <- map["is_score"]
        is_comm <- map["is_comm"]
    }
}

class CLGHomeResponseResultSeriesDateData:CLGBaseModel{
    
    var timestamp:Int64?
    var iso:String?
    var str:String?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        timestamp <- map["timestamp"]
        iso <- map["iso"]
        str <- map["str"]
    }
}


class CLGHomeResponseResultNewsData:CLGBaseModel
{
    var _id:String?
    var created:String?
    var image:String?
    var description:String?
    var title:String?
    var status:String?
    var thumb_url:String?
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        _id <- map["_id"]
        created <- map["created"]
        image <- map["image"]
        description <- map["description"]
        title <- map["title"]
        status <- map["status"]
        thumb_url <- map["thumb_url"]
    }
}
//MARK: Live Line Info Model
class CLGInfoModel : Mappable
{
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
    
}

//MARK:-Firebase All Matches New Keys Model

class CLGFirbaseArrModel : Mappable
{
    var ao:String?
    var br:String?
    //var bwl:CLGFirbaseTeamModel?
    var bw:String? //
    var con:CLGFirbaseConfigModel?
    var cs:CLGFirbaseCurrentStatusModel?
    var day:String?
    //var ft:String?
    var hms:String?
    var i:String?
    var iov:String? //
    var i1b:String? //
    var i3b:String? //
    var i1:CLGFirbaseInningModel?
    var i2:CLGFirbaseInningModel?
    var i3:CLGFirbaseInningModel?
    var i4:CLGFirbaseInningModel?
    var mi:CLGMatchInfo?
    var rm:String?
    var md:String?
    var mk:String?
    //var mkt:CLGFirbaseMarkrtModel?
    var os:String?
    //var p:CLGFirbasePartnership?
    var pt:String? //
    var p1:String?
    //var p1s:CLGFirbasePlayerStatusModel?
    var b1s:String? //
    var p2:String?
    //var p2s:CLGFirbasePlayerStatusModel?
    var b2s:String? //
    var pb:String?
    //var ssn:CLGFirbaseTeamModel?
    var ssns:String?
    var t1:CLGFirbaseTeamModel?
    var t2:CLGFirbaseTeamModel?
    var matchKey:String?
    //var ls:String?
    var to:String?
    //var lb:CLGFirbaseTestLambi?
    var lw:String?
    //var mit:Int64?
    var mit:String?
    var rt:String?
    var sn:String?
    
    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        //lb <- map["lb"]
        to <- map["to"]
        //ls <- map["ls"]
        pt <- map["pt"]
        mi <- map["mi"]
        matchKey <- map["matchKey"]
        ao <- map["ao"]
        rm <- map["rm"]
        br <- map["br"]
        //bwl <- map["bwl"]
        bw <- map["bw"] //
        con <- map["con"]
        cs <- map["cs"]
        day <- map["day"]
        //ft <- map["ft"]
        hms <- map["hms"]
        iov <- map["iov"] //
        i1b <- map["i1b"] //
        i3b <- map["i3b"] //
        i <- map["i"]
        i1 <- map["i1"]
        i2 <- map["i2"]
        i3 <- map["i3"]
        i4 <- map["i4"]
        md <- map["md"]
        mk <- map["mk"]
        //mkt <- map["mkt"]
        os <- map["os"]
        p1 <- map["p1"]
        p2 <- map["p2"]
        //p2s <- map["p2s"]
        //p1s <- map["p1s"]
        b1s <- map["b1s"]
        b2s <- map["b2s"]
        pb <- map["pb"]
        //ssn <- map["ssn"]
        ssns <- map["ssns"]
        t1 <- map["t1"]
        t2 <- map["t2"]
        lw <- map["lw"]
        mit <- map["mit"]
        rt <- map["rt"]
        sn <- map["sn"]
        
    }
}

class CLGFirbaseTestLambi : Mappable
{
    var l1:String?
    var l2:String?
    
    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        l1 <- map["l1"]
        l2 <- map["l2"]
    }
}
class CLGFirbasePartnership : Mappable
{
    var b:String?
    var r:String?
    
    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        b <- map["b"]
        r <- map["r"]
    }
}
class CLGChatArrModel : Mappable
{
    var group:String?
    var msg:String?
    var username:String?
    var msgTime:String?
    var userType:Int?
    
    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        userType <- map["userType"]
        group <- map["group"]
        msg <- map["msg"]
        username <- map["username"]
        msgTime <- map["msgTime"]
    }
}
class CLGMatchInfo : Mappable
{
    var a1s:String?
    var a2s:String?
    var mn:String?
    var mnd:String?
    var mx:String?
    var mxc:String?
    var t1p:String?
    var t2p:String?
    var tw:String?
    var m:String?

    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        m <- map["m"]
        a1s <- map["a1s"]
        a2s <- map["a2s"]
        mn <- map["mn"]
        mnd <- map["mnd"]
        mx <- map["mx"]
        mxc <- map["mxc"]
        t1p <- map["t1p"]
        t2p <- map["t2p"]
        tw <- map["tw"]

    }
}
class CLGFirbaseTeamModel : Mappable
{
    var n:String?
    var ov:String?
    var y:String?
    var r:String?
    var w:String?
    var ic:String?
    var f:String?
    
    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        n <- map["n"]
        f <- map["f"]
        ic <- map["ic"]
        ov <- map["ov"]
        y <- map["y"]
        r <- map["r"]
        w <- map["w"]
    }
}
class CLGFirbasePlayerStatusModel : Mappable
{
    var b:String?
    var f:String?
    var r:String?
    var s:String?

    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        b <- map["b"]
        f <- map["f"]
        r <- map["r"]
        s <- map["s"]
    }
}
class CLGFirbaseMarkrtModel : Mappable
{
    var r1:String?
    var r2:String?
    var r3:String?
    var r4:String?
    var r5:String?
    var r6:String?

    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        r1 <- map["r1"]
        r2 <- map["r2"]
        r3 <- map["r3"]
        r4 <- map["r4"]
        r5 <- map["r5"]
        r6 <- map["r6"]
    }
}
class CLGFirbaseInningModel : Mappable
{
    //var bt:String?
    //var bwlt:String?
    //var iov:String?
    var ov:String?
    var sc:String?
    var tr:String?
    var wk:String?
    
    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        //bt <- map["bt"]
        //bwlt <- map["bwlt"]
        //iov <- map["iov"]
        ov <- map["ov"]
        sc <- map["sc"]
        tr <- map["tr"]
        wk <- map["wk"]
    }
}
class CLGFirbaseConfigModel : Mappable
{
    var lt:String?
    var mf:String?
    var mstus:String?
    var mtm:String?
    var g:String?
    var sr:String?
    var m:String?
    var mn:String?
    var ostus:String?
    
    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        mtm <- map["mtm"]
        mn <- map["mn"]
        mstus <- map["mstus"]
        ostus <- map["ostus"]
        mf <- map["mf"]
        lt <- map["lt"]
        g <- map["g"]
        sr <- map["sr"]
        m <- map["m"]
        
    }
}
class CLGFirbaseCurrentStatusModel : Mappable
{
    var msg:String?
    var ts:String?
    
    required init?(map: Map)
    {
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        msg <- map["msg"]
        ts <- map["ts"]
    }
}
class TeamDetail : CLGBaseModel {
    var key : String?
    var name : String?
    var short_name : String?
    var logo : String?
    var all_players : [All_players]?
    var sh_name : String?
    var xi : [XI]?
    var kpr : String?
    var capt : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        key <- map["key"]
        name <- map["name"]
        short_name <- map["short_name"]
        logo <- map["logo"]
        all_players <- map["all_players"]
        sh_name <- map["sh_name"]
        xi <- map["xi"]
        kpr <- map["kpr"]
        capt <- map["capt"]
    }
    
}

class Innings_batting_order : CLGBaseModel {
    var team_info : Team_info?
    var batting : [Batting]?
    var bowling : [Bowling]?
    var fow : [Fow]?
    var no_bat : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        bowling <- map["bowling"]
        batting <- map["batting"]
        team_info <- map["team_info"]
        fow <- map["fow"]
        no_bat <- map["no_bat"]
    }
    
}


class Match : CLGBaseModel {
    var _id : String?
    var key : String?
    var format : String?
    var msgs : Msgs?
    var name : String?
    var related_name : String?
    var season : Season?
    var short_name : String?
    var start_date : Start_date?
    var status : String?
    var teams : Teams?
    var title : String?
    var venue : String?
    var winner_team : String?
    var batting_order : [[String]]?
    var description : String?
    var first_batting : String?
    var man_of_match : String?
    var match_overs : Int?
    //var toss : Toss?//v3
    var toss : String?//v4
    var innings_batting_order : [Innings_batting_order]?
    var inn_order : [Innings_batting_order]?//
    var st_date: String?//v4
    var rel_name: String?//v4
    var sh_name: String?//v4
    var s_name: String?//v4
    var result: String?//v4
    var mom : Mom?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        _id <- map["_id"]
        key <- map["key"]
        format <- map["format"]
        msgs <- map["msgs"]
        name <- map["name"]
        related_name <- map["related_name"]
        season <- map["season"]
        short_name <- map["short_name"]
        start_date <- map["start_date"]
        status <- map["status"]
        teams <- map["teams"]
        title <- map["title"]
        venue <- map["venue"]
        winner_team <- map["winner_team"]
        batting_order <- map["batting_order"]
        description <- map["description"]
        first_batting <- map["first_batting"]
        man_of_match <- map["man_of_match"]
        match_overs <- map["match_overs"]
        toss <- map["toss"]
        innings_batting_order <- map["innings_batting_order"]
        inn_order <- map["inn_order"]
        st_date <- map["st_date"]
        rel_name <- map["rel_name"]
        sh_name <- map["sh_name"]
        s_name <- map["s_name"]
        result <- map["result"]
        mom <- map["mom"]
    }
    
}
class Mom : CLGBaseModel {
    var name : String?
    var key : String?
    var logo : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        key <- map["key"]
        logo <- map["logo"]
    }
}
class Msgs : CLGBaseModel {
    var info : String?
    var completed : String?
    var result : String?
    var others : [String]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        info <- map["info"]
        completed <- map["completed"]
        result <- map["result"]
        others <- map["others"]
    }
}
class CLGScorcardApi : CLGBaseModel {
    var responseData : ResponseData?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        responseData <- map["responseData"]
    }
    
}
class ResponseData : CLGBaseModel {
    var message : String?
    var imageBaseUrl : String?
    var result : Result?
    var playerPath : String?//
    var teamsPath : String?//
    var match : Match?//
    var pP : String?//v4
    var tP : String?//v4
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        imageBaseUrl <- map["imageBaseUrl"]
        message <- map["message"]
        result <- map["result"]
        playerPath <- map["playerPath"]
        teamsPath <- map["teamsPath"]
        match <- map["match"]
        pP <- map["pP"]
        tP <- map["tP"]

    }
    
}

class Result : CLGBaseModel {
    var match : Match?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        match <- map["match"]
    }
    
}
class Season : CLGBaseModel {
    var name : String?
    var key : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        name <- map["name"]
        key <- map["key"]
    }
    
}

class Start_date : CLGBaseModel {
    var timestamp : Int?
    var iso : String?
    var str : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        timestamp <- map["timestamp"]
        iso <- map["iso"]
        str <- map["str"]
    }
    
}

class Team_info : CLGBaseModel {
    var team_key : String?
    var name : String?
    var key : String?
    var short_name : String?
    var batting_order : [String]?
    var wicket_order : [String]?
    var runs : Int?
    var balls : Int?
    var fall_of_wickets : [String]?
    var wide : Int?
    var run_rate : String?
    var fours : Int?
    var run_str : String?
    var wickets : Int?
    var extras : Int?
    var noball : Int?
    var sixes : Int?
    var legbye : Int?
    var bye : Int?
    var overs : String?
    var dotballs : String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        team_key <- map["team_key"]
        name <- map["name"]
        key <- map["key"]
        short_name <- map["short_name"]
        batting_order <- map["batting_order"]
        wicket_order <- map["wicket_order"]
        runs <- map["runs"]
        balls <- map["balls"]
        fall_of_wickets <- map["fall_of_wickets"]
        wide <- map["wide"]
        run_rate <- map["run_rate"]
        fours <- map["fours"]
        run_str <- map["run_str"]
        wickets <- map["wickets"]
        extras <- map["extras"]
        noball <- map["noball"]
        sixes <- map["sixes"]
        legbye <- map["legbye"]
        bye <- map["bye"]
        overs <- map["overs"]
        dotballs <- map["dotballs"]
    }
    
}
class Toss : CLGBaseModel {
    var decision : String?
    var won : String?
    var str : String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        decision <- map["decision"]
        won <- map["won"]
        str <- map["str"]
    }
    
}
class Teams : CLGBaseModel {
    var a : TeamDetail?
    var b : TeamDetail?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        a <- map["a"]
        b <- map["b"]
    }
    
}
class All_players : CLGBaseModel {
    var _id : String?
    var fullname : String?
    var name : String?
    var seasonal_role : String?
    var key : String?
    var playerId : CLGScorcardApiPlayerId?
    var pId : String?
    var logo : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        _id <- map["_id"]
        fullname <- map["fullname"]
        name <- map["name"]
        seasonal_role <- map["seasonal_role"]
        key <- map["key"]
        playerId <- map["playerId"]
        pId <- map["pId"]
        logo <- map["logo"]
    }
    
}
class XI : CLGBaseModel {
    var _id : String?
    var fullname : String?
    var name : String?
    var seasonal_role : String?
    var key : String?
    var playerId : CLGScorcardApiPlayerId?
    var pId : String?
    var logo : String?
    var role : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        _id <- map["_id"]
        fullname <- map["fullname"]
        name <- map["name"]
        seasonal_role <- map["seasonal_role"]
        key <- map["key"]
        playerId <- map["playerId"]
        pId <- map["pId"]
        logo <- map["logo"]
        role <- map["role"]
    }
    
}
class CLGScorcardApiPlayerId : CLGBaseModel
{
    var _id : String?
    var playerImage : String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        _id <- map["_id"]
        playerImage <- map["playerImage"]
    }
}
class Batting : CLGBaseModel {
    var _id : String?
    var fullname : String?
    var name : String?
    var seasonal_role : String?
    var key : String?
    var playerId : String?
    var batting : BattingDetail?
    var logo : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        _id <- map["_id"]
        fullname <- map["fullname"]
        name <- map["name"]
        seasonal_role <- map["seasonal_role"]
        key <- map["key"]
        playerId <- map["playerId"]
        batting <- map["batting"]
        logo <- map["logo"]
    }
    
}
class Bowling : CLGBaseModel {
    var _id : String?
    var fullname : String?
    var name : String?
    var seasonal_role : String?
    var key : String?
    var playerId : String?
    var bowling : BowlingDetail?
    var logo : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        _id <- map["_id"]
        fullname <- map["fullname"]
        name <- map["name"]
        seasonal_role <- map["seasonal_role"]
        key <- map["key"]
        playerId <- map["playerId"]
        bowling <- map["bowling"]
        logo <- map["logo"]
    }
    
}
class Fow : CLGBaseModel {
    var k : String?
    var n : String?
    var s : String?
    var o : String?
    var logo : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        k <- map["k"]
        n <- map["n"]
        s <- map["s"]
        o <- map["o"]
        logo <- map["logo"]
    }
    
}
class BowlingDetail : CLGBaseModel {
    var dots : Int?
    var runs : Int?
    var balls : Int?
    var maiden_overs : Int?
    var wickets : Int?
    var extras : Int?
    var overs : String?
    var economy : Double?
    var m_overs : Int?
    var name: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        dots <- map["dots"]
        runs <- map["runs"]
        balls <- map["balls"]
        maiden_overs <- map["maiden_overs"]
        wickets <- map["wickets"]
        extras <- map["extras"]
        overs <- map["overs"]
        economy <- map["economy"]
        m_overs <- map["m_overs"]
        name <- map["name"]
    }
    
}

class BattingDetail : CLGBaseModel {
    var dots : Int?
    var sixes : Int?
    var runs : Int?
    var balls : Int?
    var fours : Int?
    var strike_rate : Double?
    var dismissed : Bool?
    var out_str : String?
    var name: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        dots <- map["dots"]
        sixes <- map["sixes"]
        runs <- map["runs"]
        balls <- map["balls"]
        fours <- map["fours"]
        strike_rate <- map["strike_rate"]
        dismissed <- map["dismissed"]
        out_str <- map["out_str"]
        name <- map["name"]
    }
    
}
class CLGCommentryResponseData : CLGBaseModel {
    var responseData : CLGCommentryResponseResultData?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        responseData <- map["responseData"]
    }
}
class CLGCommentryResponseResultData : CLGBaseModel {
    var message : String?
    var result : CLGCommentryResult?
    var score : CLGCommentryScore?
    var ballByBall : [CLGCommentryBallByBall]?
    var total_ball : Int?
    var total : Int?
    var tP : String?
    var pP : String?
    var balls : [CLGCommentryBallByBall]?
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        message <- map["message"]
        result <- map["result"]
        score <- map["score"]
        total_ball <- map["total_ball"]
        total <- map["total"]
        tP <- map["tP"]
        ballByBall <- map["ballByBall"]
        balls <- map["balls"]
        pP <- map["pP"]
    }
}

class CLGCommentryResult : CLGBaseModel {
    var score : CLGCommentryScore?
    var ballByBall : [CLGCommentryBallByBall]?
    var total_ball : Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        score <- map["score"]
        total_ball <- map["total_ball"]
        ballByBall <- map["ballByBall"]
    }
    
}
class CLGCommentryScore : CLGBaseModel {
    var _id : String?
    var key : String?
    var msgs : Msgs?
    var status : String?
    var teams : Teams?
    var winner_team : String?
    var win_team : String? //
    var batting_order : [[String]]?
    var innings_score_order : [CLGCommentryB_1]?
    var inn_order : [CLGCommentryB_1]?//
    var result : String?
    var mom : Mom?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        _id <- map["_id"]
        key <- map["key"]
        msgs <- map["msgs"]
        status <- map["status"]
        teams <- map["teams"]
        winner_team <- map["winner_team"]
        batting_order <- map["batting_order"]
        innings_score_order <- map["innings_score_order"]
        win_team <- map["win_team"]
        inn_order <- map["inn_order"]
        result <- map["result"]
        mom <- map["mom"]
    }
    
}

class CLGCommentryB_1 : CLGBaseModel {
    var team_key : String?
    var name : String?
    var key : String?
    var short_name : String?
    var runs : Int?
    var balls : Int?
    var wide : Int?
    var run_rate : String?
    var fours : Int?
    var run_str : String?
    var wickets : Int?
    var extras : Int?
    var noball : Int?
    var sixes : Int?
    var legbye : Int?
    var bye : Int?
    var overs : String?
    var dotballs : String?
    var innings : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        team_key <- map["team_key"]
        name <- map["name"]
        key <- map["key"]
        short_name <- map["short_name"]
        runs <- map["runs"]
        balls <- map["balls"]
        wide <- map["wide"]
        run_rate <- map["run_rate"]
        fours <- map["fours"]
        run_str <- map["run_str"]
        wickets <- map["wickets"]
        extras <- map["extras"]
        noball <- map["noball"]
        sixes <- map["sixes"]
        legbye <- map["legbye"]
        bye <- map["bye"]
        overs <- map["overs"]
        dotballs <- map["dotballs"]
        innings <- map["innings"]
    }
    
}

class CLGCommentryBallByBall : CLGBaseModel {
    var _id : String?
    var ball_id : String?
    var ball : String?
    var ball_count : Int?
    var ball_type : String?
    var batsman : CLGCommentryBallByBallBatsman?
    var batting_team : String?
    var bowler : CLGCommentryBallByBallBowler?
    var comment : String?
    var extras : String?
    var innings : String?
    var match : String?
    var nonstriker : CLGCommentryNonstriker?
    var over : Int?
    var over_str : Double?
    var runs : String?
    var status : String?
    var striker : CLGCommentryNonstriker?
    var wicket : CLGCommentryNonstriker?
    var wicket_type : String?
    var summary : CLGCommentrySummary?
    var inn : String?//v4
    var bat_team : String?//v4
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        _id <- map["_id"]
        ball_id <- map["ball_id"]
        ball <- map["ball"]
        ball_count <- map["ball_count"]
        ball_type <- map["ball_type"]
        batsman <- map["batsman"]
        batting_team <- map["batting_team"]
        bowler <- map["bowler"]
        comment <- map["comment"]
        extras <- map["extras"]
        innings <- map["innings"]
        match <- map["match"]
        nonstriker <- map["nonstriker"]
        over <- map["over"]
        over_str <- map["over_str"]
        runs <- map["runs"]
        status <- map["status"]
        striker <- map["striker"]
        wicket <- map["wicket"]
        wicket_type <- map["wicket_type"]
        summary <- map["summary"]
        inn <- map["inn"]
        bat_team <- map["bat_team"]
    }
    
}
class CLGCommentryNonstriker : CLGBaseModel {
    var _id : String?
    var full_name : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        _id <- map["_id"]
        full_name <- map["full_name"]
    }
}
class CLGCommentryBallByBallBatsman : CLGBaseModel {
    var runs : Int?
    var dotball : Int?
    var six : Int?
    var four : Int?
    var ball_count : Int?
    var key : String?
    var name : CLGCommentryNonstriker?

    override func mapping(map: Map) {
        super.mapping(map: map)
        runs <- map["runs"]
        dotball <- map["dotball"]
        six <- map["six"]
        four <- map["four"]
        ball_count <- map["ball_count"]
        key <- map["key"]
        name <- map["name"]
    }
}
class CLGCommentryBallByBallBowler : CLGBaseModel {
    var runs : Int?
    var extras : Int?
    var wicket : Int?
    var ball_count : Int?
    var key : String?
    var name : CLGCommentryNonstriker?

    override func mapping(map: Map) {
        super.mapping(map: map)
        runs <- map["runs"]
        extras <- map["extras"]
        wicket <- map["wicket"]
        ball_count <- map["ball_count"]
        key <- map["key"]
        name <- map["name"]
    }
}

class CLGCommentrySummary : CLGBaseModel {
    var _id : String?
    var batting_team : String?
    var innings : String?
    var key : String?
    var over : Int?
    var match : CLGCommentrySummeryMatch?
    var matchId : String?
    var runs : Int?
    var wicket : Int?
    var bowler : [CLGCommentrySummaryBowler]?
    var batsman : [CLGCommentrySummaryBatsman]?
    var bat_team: String?
    var bwl : [BowlingDetail]?
    var bat : [BattingDetail]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        _id <- map["_id"]
        batting_team <- map["batting_team"]
        innings <- map["innings"]
        key <- map["key"]
        over <- map["over"]
        match <- map["match"]
        matchId <- map["matchId"]
        runs <- map["runs"]
        wicket <- map["wicket"]
        bowler <- map["bowler"]
        batsman <- map["batsman"]
        bat_team <- map["bat_team"]
        bwl <- map["bwl"]
        bat <- map["bat"]
    }
    
}

class CLGCommentrySummeryMatch : CLGBaseModel {
    var req_runs : Int?
    var runs : Int?
    var score : String?
    var current_run_rate : Double?
    var wicket : Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        req_runs <- map["req_runs"]
        runs <- map["runs"]
        score <- map["score"]
        current_run_rate <- map["current_run_rate"]
        wicket <- map["wicket"]
    }
    
}
class CLGCommentrySummaryBatsman : CLGBaseModel {
    var batting : BattingDetail?
    var key : String?
    var info : CLGCommentrySummaryInfo?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        batting <- map["batting"]
        key <- map["key"]
        info <- map["info"]
    }
    
}
class CLGCommentrySummaryBowler : CLGBaseModel {
    var bowling : BowlingDetail?
    var key : String?
    var info : CLGCommentrySummaryInfo?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        bowling <- map["bowling"]
        key <- map["key"]
        info <- map["info"]
    }
    
}
class CLGCommentrySummaryInfo : CLGBaseModel {
    var seasonal_role : String?
    var fullname : String?
    var name : String?
    var key : String?
    var playerId : String?

    
    override func mapping(map: Map) {
        super.mapping(map: map)

        seasonal_role <- map["seasonal_role"]
        fullname <- map["fullname"]
        name <- map["name"]
        key <- map["key"]
        playerId <- map["playerId"]
    }
    
}
