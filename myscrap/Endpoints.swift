//
//  Endpoint.swift
//  myscrap
//
//  Created by MS1 on 10/15/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//
import Foundation
struct Endpoints {
    static let BASE_URL = "https://myscrap.com/ios/"
    static let BASE_URL_Common = "https://myscrap.com/android/"
    //static let BASE_URL = "http://216.172.171.51/~papiunit/ios/"
    static let PORT_LIST = "\(BASE_URL)getportWithCon"
    static let MOBILE_SECURITY_URL = "\(BASE_URL)myScrapMobileSecurity/"
    
    //OLD LOGIN API
    static let LOGIN_URL = "\(BASE_URL)myScrapUserLogin/"
    
    /*Updated LOGIN using phone or email*/
    static let LOGIN_URL_UPDATED = "https://myscrap.com/api/v1/msLoginnew"
    
    //OLD SIGNUP API
    static let REGISTER_URL = "\(BASE_URL)register"
    
    /*Updated SIGNUP API*/
    static let SIGNUP_USER_UPDATED = "https://myscrap.com/api/registerNew"
    static let SIGNUP_COMPANY_LIST = "https://myscrap.com/api/msSignUpCompanyDetails"
    
    /*Version 1.0 SIGNUP API UPDATED*/
    //Verification with Phone number or email(*Phone number is primary & email is secondary)
    static let SIGNUP_V1_UPDATED = "https://myscrap.com/api/v1/signup"
    
    static let SIGNUP_EMAIL_GET_CODE = "https://myscrap.com/api/v1/msEmailCodeVerification"
    
    /*Forgot Password before Login/SignUp*/
    static let SEND_PASSWORD_CODE = "https://myscrap.com/android/msForgotPassword"
    static let VERIFY_CODE_EMAIL = "https://myscrap.com/android/verify_code"
    static let SEND_PASSWORD_CODE_AGAIN = "https://myscrap.com/android/msForgotPassword"
    static let RECREATE_PASSWORD = "https://myscrap.com/android/change_password"
    static let VERIFY_EMAIL_OR_PHONE = "https://myscrap.com/api/v1/msEmailPhoneValidation"
    
//    static let USERFEEDS_URL = "\(BASE_URL)msUserFeeds/"
    //https://216.172.171.51/~papiunit
    //static let USERFEEDS_URL = "https://216.172.171.51/~papiunit/"
    static let INSERT_LIKE_URL = "\(BASE_URL)msInsertLike/"
    static let INSERT_VIDEO_VIEWS = "https://myscrap.com/video/numberofview"
    static let VIDEO_VIEW_LISTS = "https://myscrap.com/api/msVideoViewersList"
    static let LIKE_COUNT_URL = "\(BASE_URL)msLike/"
    static let COMMENT_COUNT_URL = "\(BASE_URL)msComment/"
    static let COMMENT_INSERT_URL = "\(BASE_URL)msInsertComment/"
    static let OLD_ADD_CONTACTS_URL = "\(BASE_URL)msAddContacts/"
    static let TAG_USER_CONTACTS_URL = "https://myscrap.com/api/msAddContactsTag"
    static let TAG_USER_LIST_V2 = "https://myscrap.com/Members/tagsUsersFeedNew"
    static let ADD_CONTACTS_URL = "https://myscrap.com/api/msAddContacts"
    static let FAVOURITES_URL = "\(BASE_URL)msFavouriteDetails/"
    static let CONNECT_PEOPLE_URL = "\(BASE_URL)msConnectPeople/"
    static let COMPANY_LIST = "https://myscrap.com/api/msCompanyList"
    static let DISCOVER_URL = "https://myscrap.com/api/msDiscoverPage"
    static let NEWS_URL = "\(BASE_URL)msNews"
    static let SEARCH_URL = "\(BASE_URL)msSearch" // not using
    static let SINGLE_NEWS_URL = "\(BASE_URL)msSingleNews"
    static let FRIEND_PROFILE_FEEDS_URL = "\(BASE_URL)msFriendProfileFeeds"
    static let USER_PROFILE_FEEDS_URL = "\(BASE_URL)msUserProfileFeeds"
    static let USER_PROFILE_FEEDS_URL_V2 = "\(BASE_URL)msUserProfileFeedsv2"
    static let MY_PROFILE_FEEDS_URL = "\(BASE_URL)msUserProfileFeedsv4"

//    userfeeds
  //  https://myscrap.com/ios/msUserProfileFeedsv2
    static let NOTIFICATION_URL = "\(BASE_URL)msNotifications/"
    static let NOTIFICATION_V1_URL = "\(BASE_URL)v1/msNotifications"
    static let NOTIFICATION_V2_URL = "\(BASE_URL_Common)msNotificationsnew"

    static let MESSAGECHATROOM_URL = "\(BASE_URL)msChatRooms/" // not using
    static let CHATLASTMESSAGES_URL = "\(BASE_URL)msChatLastMessages/"
    static let ADD_MESSAGE_URL = "\(BASE_URL)msAddChatMessage"
    static let MS_NEAR_FRIENDS_URL = "\(BASE_URL)msNearFriends/"
    static let USER_PROFILE_INSERT_URL = "\(BASE_URL)msUserPostInsert/"
    
    static let USER_PROFILE_INSERT_URL_V2 = "\(BASE_URL_Common)msUserPostInsertV2/"
    static let USER_Image_Upload = "https://test.myscrap.com/android/add_attachment"

    static let SHAKE_URL = "\(BASE_URL)msShake" // not using
    static let INSERT_FAVOURITE_POST_URL = "\(BASE_URL)msInsertFavouritePost"
    static let INSERT_FAVOURITE_COMPANY_URL = "\(BASE_URL)msInsertFavouriteCompany"
    static let INSERT_FAVOURITE_LISTING = "\(BASE_URL)msInsertFavouriteListings"
    //static let REPORT_POST_URL = "\(BASE_URL)msReport"
    static let REPORT_POST_URL = "\(BASE_URL_Common)msReport"
    
    static let DELETE_POST_URL = "\(BASE_URL)msPostDelete"
    static let DETAILS_POST_URL = "\(BASE_URL)msPostDetails"
    static let DETAILS_POST_URL_V2 = "\(BASE_URL_Common)msPostDetailsNew"

//    https://myscrap.com/android/msPostDetailsNew
    static let FAVOURITE_POST_URL = "\(BASE_URL)msFavouritePosts"
    static let COMPANYFEEDS_URL = "https://myscrap.com/api/msCompanyDetails"
    static let COMPANY_DETAILS = "https://myscrap.com/company/msCompanydetailsv1"

    static let COMPANY_LIKES_URL = "\(BASE_URL)msCompanyLike"
    static let EDIT_PROFILE_URL = "\(BASE_URL_Common)msEditProfilev2"
    static let EDIT_PROFILE_PIC_URL = "\(BASE_URL)msEditProfilePic"
    static let COMPANY_EDIT_PROFILE = "\(BASE_URL)msCompanyEditProfile"
    static let COMPANY_EDIT_PROFILE_PIC = "\(BASE_URL)msEditCompanyProfilePic"
    static let VISITORS_URL = "\(BASE_URL)msViewers"
    static let UPDATE_VIEWERS_URL = "\(BASE_URL)msUpdateViewers"
    static let FCM_UPDATE_URL = "\(BASE_URL)msGcmUpdate"
    static let UNREPORT_URL = "\(BASE_URL)msUnReport"
    static let PRICES_URL = "\(BASE_URL)priceShare"
    static let COMPANY_LIKE_DETAILS_URL = "\(BASE_URL)msCompanyLikesDetails"
    static let USER_DESIG_FOR_CHAT = "\(BASE_URL)msUserOnlineStatus"            ///FOR GETTING FRIEND DESIGNATION IN CHAT
   // static let USER_ONLINE_STATUS_URL = "https://myscrap.com/api/getUserOnlineStatusXMPP"
    static let USER_ONLINE_STATUS_URL = "https://myscrap.com/api/getUserOnlineStatusXMPPv2"
    static let USER_LIVE_INSERT_URL = "https://myscrap.com/android/insertLiveUserDetailDual"
    static let USER_LIVE_Status_URL = "https://myscrap.com/android/countliveview"
    static let USER_LIVE_VIEWS_URL = "https://myscrap.com/android/insert_live_views"
   
    // websocket User Live
    static let LiveUser = "wss://sayed.net:5443/WebRTCAppEE/websocket"
    
    static let FavouriteCompany = "\(BASE_URL)msFavouriteCompany"
    static let ModeratorsURL = "\(BASE_URL)msModerators"
    static let EMPLOYEE_DETAILS_URL = "\(BASE_URL)msEmployeeDetails"
    static let COMMENT_DELETE_URL = "\(BASE_URL)msCommentDelete"
    static let EXCHANGE_URL = "\(BASE_URL_Common)msExchange"
    static let LME_EXCHANGE_URL = "\(BASE_URL)msLmeExchange"
    
    static let LME_SUBSCRIPTION_SEND_URL = "https://myscrap.com/api/v1/msEmailCodeVerification"
    
    static let SUBSCRIBE_LME_URL = "\(BASE_URL)msLmeSubscribe"
    static let GET_UPDATED_PRICES = "https://myscrap.com/api/v3/lme_data"
    static let GET_Commodity_Avg_Price = "\(BASE_URL_Common)show_commodity_avg_price"
    
    static let GET_Commodity_Price = "\(BASE_URL_Common)price_commodity"
    static let GET_Commodity_Price_Edit = "\(BASE_URL_Common)edit_price_commodity"
    static let GET_Confirm_Value_Page = "\(BASE_URL_Common)confirm_value_page"
    static let GET_Submit_Commodity_Price = "\(BASE_URL_Common)submit_commodity_price"
    static let GET_Commodity_Detail_Page = "\(BASE_URL_Common)commodity_detail_page"


    static let NEW_VERSION_URL = "\(BASE_URL)msNewVersion"
   // static let REPORTED_POST_URL = "\(BASE_URL)msReportedPosts"
    static let REPORTED_POST_URL = "https://myscrap.com/android/msReportedPostsv2"
    static let REPORTED_POST_URL_V2 = "\(BASE_URL_Common)msReportedPostsv2"

  
    static let UPDATE_LOCATION_URL  = "\(BASE_URL)msUpdateUserLocation"
    static let MENTIONS_SEARCH_URL  = "\(BASE_URL)msSearch"
    static let BUMPED_POSTS_URL  = "\(BASE_URL)msBumpPosts"
    static let DELETE_BUMPED_POSTS_URL  = "\(BASE_URL)msBumpPostRemove"
    static let UPDATE_BUMP_URL = "\(BASE_URL)msUpdateBumpers"
    static let CALENDAR_EVENTS_URL  = "\(BASE_URL)msEvents"
    static let CALENDAR_INVITES_URL =  "\(BASE_URL)msEventInvites"
    static let MS_CONNECTED_URL = "\(BASE_URL)msConnected"
    static let NOTIFICATION_COUNT_URL = "\(BASE_URL_Common)msNotificationCounts"
    static let LOGOUT_USER = "\(BASE_URL)msLogout"
    static let VOIP_MESSAGES_URL = "\(Endpoints.BASE_URL)msChatRoomMessages"
    static let CLEAR_NOTIFICATION_URL = "\(BASE_URL)msClearNotifications"
    static let CHANGE_PASSWORD_URL = "\(BASE_URL)msChangePassword"
    static let EVENT_DETAILS_URL = "\(BASE_URL)msEventDetails"
    static let EVENT_GOING_URL = "\(BASE_URL)msGoing"
    static let EVENT_INTERESTED_URL = "\(BASE_URL)msInterested"
    static let CREATE_EVENT_URL = "\(BASE_URL)msCreateEvents"
    static let PRICE_SHARE_URL = "\(BASE_URL)priceShare"
    static let CHATROOMS_URL = "\(BASE_URL)msChatsRooms"
    
    static let ACTIVE_USERS_URL = "\(BASE_URL)msActiveUsers"
    static let ACTIVE_FRIENDS_URL = "https://myscrap.com/api/msOnlineUsersSlider"
    
    static let CONVERSATION_URL = "\(BASE_URL)msChatsLastMessages"
    
    //Sharing app link for INVITING
    static let APP_LINK_SHARE = "\(BASE_URL)/shareApp"
    
    //Sharing post link for FEEDS
    static let POST_LINK_SHARE =  "https://myscrap.com/api/pointsSharePost"
    
    //Market Module
    static let INSERT_MARKET_URL = "msAddListings"
    
    static let MARKET_LISTING_URL = "msListingCountryWise"
    static let MARKET_REQUEST_CHAT_URL = "msRequestListingChat"
    static let NOTIFICATION_ACKNOWLADGE_URL = "msAcknowledgeChat"
    
    static let MY_MARKET_LISTINGS = "\(BASE_URL)msMyListing"                   //Get the Market list posted by me
    static let UPDATE_VIEW_LISTING_URL = "msViewListing"
    static let VIEW_LISTINGS = "\(BASE_URL)msViewListing"
    static let DELETE_LISTING_URL = "msDeleteListing"
    //If user send as anonymous, email
    static let ANONYM_EMAIL = "\(BASE_URL)sendListingMail"                      //Anonymous email
    static let GET_MY_MAILS = "\(BASE_URL)getMyMails"
    static let GET_MAIL_DETAIL = "\(BASE_URL)mailDetail"
    
    //Member's Profile
    static let GET_FRIEND_PHOTOS = "\(BASE_URL)msProfileDetails"                //Friends Profile
    static let POST_PROFILE_LIKE = "\(BASE_URL)msLikeProfile"
    static let POST_PROFILE_FAV = "\(BASE_URL)msFavouriteProfile"
    
    //Updated Members/Friends Profile splitted as 4 api's
    static let GET_MAINPAGE_FRIEND_PROFILE = "\(BASE_URL)msProfileDetails/mainv2" // HAJA Changed
    
    //static let GET_ABOUTPAGE_FRIEND_PROFILE = "\(BASE_URL)msProfileDetails/about"
    static let GET_ABOUTPAGE_FRIEND_PROFILE = "\(BASE_URL)msProfileDetails/aboutv2"

    static let GET_USERFEEDS_FRIEND_PROFILE = "\(BASE_URL)msProfileDetails/userfeeds"
     static let GET_USERFEEDS_FRIEND_PROFILE_V2 = "\(BASE_URL)msProfileDetails/userfeedsv2"
    //static let GET_USERFEEDS_FRIEND_PROFILE = //"https://test.myscrap.com/ios/msProfileDetails/userfeeds"
    static let GET_IMAGES_FRIEND_PROFILE = "\(BASE_URL)msProfileDetails/userImages"
    static let Send_ShowRequest_Friend = "https://myscrap.com/api/sendRequest"
    static let Send_Accept_Request = "https://myscrap.com/api/acceptRequest"
    static let Send_Reject_Request = "https://myscrap.com/api/declineRequest"


    static let CHECK_COUPON_CODE = "https://myscrap.com/android/msCheckCoupon"              //Used the android api
    //Livechat Message
    static let GRP_MSG_FETCH = "\(BASE_URL)getmyliveroommessage"               //Getting live group Message(NotUsing)
    static let SEND_PRESENCE = "\(BASE_URL)getUserDetailBuXMPP"                 //Group chat user Presence
    static let BG_WALL_SET = "https://myscrap.com/api/setLiveBackgroupImage"    //Setting up LiveBackground
    static let BG_WALL_GET = "https://myscrap.com/api/getLiveBackgroupImage"    //Getting the uploaded Live Background Wall
    
    
    //FeedsStories
    static let RECENT_STORIES = "\(BASE_URL)recentnews/"
    
    //Roater Private Message history
    static let GET_ROASTER = "https://myscrap.com/api/getUserInitialRosterConversation"
    //Nearby updated
    static let PEOPLE_NEAR_BY_URL = "https://myscrap.com/api/msPeopleNearBy"
    
    
    //Company new design Updated api
    static let COMPANY_DATA_FETCH = "https://myscrap.com/api/companyDetails"
    //Version 2.0
    static let COMPANY_DATA_FETCH_V2 = "https://myscrap.com/v1/api/companyDetails"
    //Get company data for Admin View
    static let COMPANY_GET_ADMIN_VIEW = "https://myscrap.com/api/v1/adminViewGet"
    //Save/Update the company Details
    static let COMPANY_UPDATE_ADMIN_VIEW = "https://www.myscrap.com/api/SaveOrUpdateCompanyAdminData"
    //Get Employee Feeds
   // static let  COMPANY_EMPLOYEE_FEEDS = "https://myscrap.com/api/v1/getCompanyEmployeeFeeds"
    static let  COMPANY_EMPLOYEE_FEEDS = "https://myscrap.com/company/employeefeedsv1"

   
    //Post Review and Rating for companies
    static let POST_REVIEW = "https://myscrap.com/api/submitCompanyReview"
    //Fetch Reviews for company
    static let FETCH_REVIEW = "https://myscrap.com/api/companyReview"
    
    /*Awards API*/
    /*Company of the Month*/
    //Get Details of Company Month
    static let FETCH_DETAIL_CM_URL = "https://myscrap.com/api/CompnayOfMonthDetailPage"
    
    //Insert or Edit comment
    static let INSERT_COM_MONTH_COMMENT = "https://myscrap.com/api/postCommentForCompnayOfMonth"
    //Get Comments
    static let GET_COM_MONTH_COMMENT = "https://myscrap.com/api/getCommentForCompnayOfMonth"
    //Delete
    static let DELETE_COM_MONTH_COMMENT = "https://myscrap.com/api/deleteCommentCompanyofTheMonth"
    //Insert like/dislike for Company of the Month
    static let INSERT_COM_MONTH_LIKE_URL = "https://myscrap.com/api/likeCompnayOfMonth"
    //Get Like Count Members
    static let GET_LIKE_MEMBERS_CM = "https://myscrap.com/api/getLikedUsersCompnayOfMonth"
    //Insert Favorite for Company of the Month
    static let INSERT_COM_MONTH_FAV = "https://myscrap.com/api/favCompnayOfMonth"
    
    /*Person of the Week*/
    //Insert like/dislike for POW
    static let INSERT_POW_LIKE_URL = "https://myscrap.com/api/likePersonOfWeek"
    //Get Like count Members for POW
    static let GET_LIKE_MEMBERS_POW = "https://myscrap.com/api/getLikedUsersPersonOfTheWeek"
    //Get Details of POW
    static let FETCH_DETAIL_POW_URL = "https://myscrap.com/api/personOfTheWeekDetailPage"
    //Insert/Edit Comment of POW
    static let INSERT_POW_COMMENT_URL = "https://myscrap.com/api/postCommentForPersonOfWeek"
    //Delete Comment of POW
    static let DELETE_POW_COMMENT_URL = "https://myscrap.com/api/deleteCommentPersonOfTheWeek"
    //Insert Favorite for POW
    static let INSERT_POW_FAV_URL = "https://myscrap.com/api/favPersonOfTheWeek"
    
    /*Voter Lists*/
    //Get BIO of voter (ViewBio)
    static let GET_BIO_VOTER = "https://myscrap.com/api/getviewBio"
    //Get Voters List
    static let GET_VOTERS_LIST = "https://myscrap.com/api/getVoterList"
    //Update Voter Lists
    static let GET_VOTER_LIST_REM_POLL = "https://myscrap.com/api/getVoterListNew"
    //Vote Nominee
    static let VOTE_NOMINEE = "https://myscrap.com/api/getviewVotingResult"
    //Updated Vote nominee for sending lat & long
    static let VOTE_NOMINEE_LATLONG = "https://www.myscrap.com/api/getviewVotingResultNew"
    //Vote Results
    static let VIEW_VOTING_RESULT = "https://myscrap.com/api/viewVotingResult"
    //Updated Voters Result with isPollingClosed
    static let VIEW_VOTING_RESULT_POLL = "https://myscrap.com/api/viewVotingResultNew"
    
    /*Covid POLL API's*/
    //Send Poll answer
    static let UPDATE_COVID_POLL = "https://myscrap.com/api/covid19/updatePoll"
    static let GET_CPOLL_STATUS = "https://myscrap.com/api/covid19/getPollStatus"
    
    /*Get own user PROFILE*/
    static let GET_USER_PROFILE = "https://myscrap.com/api/getUserProfile"
    
    static let GET_USER_FOLLOWERS = "https://myscrap.com/profile/userfollowersv2"

    //static let SEND_FOLLOW_REQUEST = "https://myscrap.com/android/sendfollowrequest"
    static let SEND_FOLLOW_REQUEST = "https://myscrap.com/android/sendfollowrequestv2"

    static let SEND_UNFOLLOW_REQUEST = "https://myscrap.com/android/unFollowUser"

    static let ACCEPT_FOLLOW_REQUEST = "https://myscrap.com/android/acceptfollowrequest"
    
    static let REJECT_FOLLOW_REQUEST = "https://myscrap.com/android/rejectfollowrequest"

    
    static let MAKE_ADMIN_OF_COMPANY = "https://myscrap.com/android/makeAdminOfCompany"
 
    static let MAKE_EMPLOYEES_AS_ADMIN = "https://myscrap.com/android/makecompanyadmin"
    
    static let REPORT_ABOUT_COMPANY = "https://myscrap.com/company/reportAboutCompany"

    static let UN_REPORT_ABOUT_COMPANY = "https://myscrap.com/company/unreportAboutCompany"
    static let DELETE_COMPANY_PHOTOS = "https://myscrap.com/company/deleteCompanyPhotos"
    
    //This API is only for Moderator
    static let DELETE_COMPANY_REPORT = "https://myscrap.com/android/deleteCompanyReport"
    static let ACCEPT_OR_REJECT_ADMIN_REQUEST = "https://myscrap.com/android/add_admin"
    
    static let ADD_OR_DECLINE_EMPLOYEE_REQUEST = "https://myscrap.com/android/add_employee"

}

struct V2EndPoints {
    
    /* API VERSION 2.0 */
    
    static let BASE_URL = "https://myscrap.com/api/"
    //static let USERFEEDS_URL = "\(BASE_URL)msUserFeedsNew/"
    
    /* API with Company of Month & Person of Week + Voting */
    static let USERFEEDS_URL = "\(BASE_URL)v2/msUserFeeds"
    
    /*API without Company of Month & Voting */
    static let NEW_USERFEEDS_URL = "\(BASE_URL)v3/msUserFeeds"
    
    /*API with Voting included*/
    static let VOTE_FEEDS_URL = "\(BASE_URL)v4/msUserFeeds"
    
    /*FEEDS API with OPTIMIZATION FROM BACKEND*/
//    static let FEEDS_V5_URL = "\(BASE_URL)v5/msUserFeeds"
    static let FEEDS_V5_URL = "https://myscrap.com/feeds/msFeedPageV10"
    
    /*FEEDS API with COVID-19 POLL*/
    static let FEEDS_V6_URL = "\(BASE_URL)v6/msUserFeeds"
}
struct LandingEndPoints {
    static let BASE_URL = "https://myscrap.com/api/"
    static let LANDING_PAGE_URL = "\(BASE_URL)v5/landingPage"
    
    /*Version 2.0*/
    static let LANDING_PAGE_URL_V2 = "\(BASE_URL)v6/landingPage"
}
