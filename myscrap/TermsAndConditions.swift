//
//  TermsAndConditions.swift
//  myscrap
//
//  Created by MS1 on 10/26/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//



import Foundation
struct TermsAndConditions {
    let termsofServices: NSAttributedString = NSAttributedString(string: "Terms of Use", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
    let termsofServicesContent: NSAttributedString = NSAttributedString(string: "\n\nPlease read these terms of use carefully (“Terms”). These Terms govern and apply to your access and use of www.myscrap.com and MyScrap’s social networking services available via MyScrap’s site and MyScrap’s mobile apps (collectively, the “Service”). By accessing or using our Service, you agree to be bound all of the terms and conditions described in these Terms. If you do not agree to all of these terms and conditions, do not use our service.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
    
    let useOfTheService: NSAttributedString = NSAttributedString(string: "Use of the Service", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
    let useOfTheServiceContent: NSAttributedString = NSAttributedString(string: "\n\nMyScrap allows you to access, view and share moments with your contacts through our mobile and web-based apps and our site (each an “App”). As long as you comply with these Terms, you have the right to download and install a copy of the App to your mobile device, and to access and use the Service, for your own personal use. You may not: (i) copy, modify or distribute the App for any purpose; (ii) transfer, sublicense, lease, lend, rent or otherwise distribute the App or the Service to any third party; (iii) decompile, reverse-engineer, disassemble, or create derivative works of the App or the Service; (iv) make the functionality of the App or the Service available to multiple users through any means; or (v) use the Service in any unlawful manner, for any unlawful purpose, or in any manner inconsistent with these Terms.\nThe following terms apply to any App accessed through or downloaded from any app store or distribution platform (like the Apple App Store or Google Play) where the App is made available (each an “App Provider”). You acknowledge and agree that:\nThese Terms are concluded between you and MyScrap, and not with the App Provider, and that MyScrap (not the App Provider), is solely responsible for the App.\nThe App Provider has no obligation to furnish any maintenance and support services with respect to the App.\nThe App Provider is not responsible for addressing any claims you have or any claims of any third party relating to the App or your possession and use of the App, including, but not limited to: (i) product liability claims; (ii) any claim that the App fails to conform to any applicable legal or regulatory requirement; and (iii) claims arising under consumer protection or similar legislation.\nIn the event of any third party claim that the App or your possession and use of that App infringes that third party’s intellectual property rights, MyScrap will be solely responsible for the investigation, defense, settlement and discharge of any such intellectual property infringement claim to the extent required by these Terms.\nThe App Provider, and its subsidiaries, are third party beneficiaries of these Terms as related to your license of the App, and that, upon your acceptance of the terms and conditions of these Terms, the App Provider will have the right (and will be deemed to have accepted the right) to enforce these Terms as related to your license of the App against you as a third party beneficiary thereof.\nYou must also comply with all applicable third party terms of service when using the App.\nOur Service may change from time to time and/or we may stop (permanently or temporarily) providing MyScrap (or features within the Service), possibly without prior notice to you. Our Service may, at some point, include advertisements, which may be targeted to the content or information on the Service, queries made through the Service, or from other information. The types and extent of advertising on the Service are also subject to change over time. In consideration for providing you MyScrap, you agree that we and our third party providers and partners may place advertising on our Service or in connection with the display of content or information on our Service. Certain features of our Service may be subject to additional terms or conditions, which will be posted with those features.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
    let creatingAccount: NSAttributedString = NSAttributedString(string: "Creating a MyScrap Account", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
    let creatingAccountContent: NSAttributedString = NSAttributedString(string: "\n\nIn order to access and use MyScrap, you will need to register and create an account (your “Account”). By creating an Account, you represent that you are of legal age to form a binding contract. When creating an Account, you may be required to provide certain personal information about yourself. You agree to provide accurate, current and complete information about your Account.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
        let falseAccount : NSAttributedString = NSAttributedString(string: "When creating an Account, don’t:", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
    let falseAccountContent: NSAttributedString = NSAttributedString(string: "\n\nprovide any false personal information to us (including a false username) or create any account for anyone other than yourself without such other person's permission;\nuse a username that is the name of another person with the intent to impersonate that person;\nuse a username that is subject to rights of another person without appropriate authorization; or\nuse a username that is offensive, vulgar or obscene or otherwise in bad taste.\nWe reserve the right to suspend or terminate your Account if any information provided during the registration process or thereafter proves to be inaccurate, false or misleading or to reclaim any username that you create through the Service that violates our Terms. You are responsible for maintaining the confidentiality of your password and Account, and agree to notify us if your password is lost, stolen, or disclosed to an unauthorized third party, or otherwise may have been compromised. You are responsible for activities that occur under your Account.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
    
        let claimingCompany : NSAttributedString = NSAttributedString(string: "Claiming or Creating a company", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
    let claimingCompanyContent: NSAttributedString = NSAttributedString(string: "\n\nClaiming or creating a company you acknowledge that you are legally permitted to act as a representative of that company. It is not allowed to claim or create a fake company or a company that you are not an official representation of.\nThe company administrator in MyScrap is responsible for the information about that company in MyScrap.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
        let privacyPolicy: NSAttributedString = NSAttributedString(string: "Privacy Policy", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
            let privacyPolicyContent: NSAttributedString = NSAttributedString(string: "\n\nPlease refer to our Privacy Policy for information on how we collect, use and disclose information from our users.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
    let contentSubmission: NSAttributedString = NSAttributedString(string: "Content Submissions", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
    
    let contentSubmissionContent: NSAttributedString = NSAttributedString(string: "\n\nOur Service allows you and other users to post, link, store, share and otherwise make available certain information, images,  text and/or other content (“Content”). You are responsible for the Content that you post to MyScrap, including its legality, reliability, and appropriateness. By posting Content to MyScrap, you grant us the right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such Content on and through MyScrap. You agree that this license includes the right for us to make your Content available to other users of MyScrap, who may also use your Content subject to these Terms. You retain any and all of your rights to any Content you submit, post or display on or through MyScrap and you are responsible for protecting those rights.\nYou represent and warrant that: (i) the Content is yours (you own it) or you have the right to use it and grant us the rights and license as provided in these Terms, and (ii) the posting of your Content on or through MyScrap does not violate the privacy rights, publicity rights, copyrights, contract rights or any other rights of any person.\nWe ask that you respect our on-line community and other users when posting Content and using MyScrap. When submitting Content to or otherwise using MyScrap, you agree not to:\nsubmit material that violates a third party’s proprietary rights, including privacy and publicity rights, or that otherwise violates any applicable law;\nsystematic retrieval of data or other content to create or compile, directly or indirectly, a collection, compilation, database or directory without written permission from MyScrap;\nmaking any unauthorized use of the Platform, including collecting usernames and/or email addresses of users by electronic or other means for the purpose of sending unsolicited email, or creating user accounts by automated means or under false pretences;\ntricking, defrauding or misleading MyScrap or other persons, especially in any attempt to learn sensitive account information such as identities and passwords;\nusing the Platform in a manner inconsistent with the Purpose or any and all applicable laws and regulations.\nattempting to impersonate another user or person or using the username of another user;\npublish falsehoods or misrepresentations that could damage us, our users or any third party;\nusing the Platform as part of any effort to compete with MyScrap or to provide services as a service bureau;\npublish any private information of someone, like their address, phone number, email address, and similar information without their permission;\nuploading or transmitting (or attempt to upload or to transmit) viruses, Trojan horses or other material that interferes with any party's uninterrupted use and enjoyment of the Platform or modifies, impairs, disrupts, alters or interferes with the use, features, functions, operation or maintenance of the Platform;\nsubmit material that is unlawful, obscene, defamatory, libelous, threatening, pornographic, harassing, hateful, racially or ethnically offensive, or encourages conduct that would be considered a criminal offense, give rise to civil liability, violate any law, or is otherwise inappropriate;\nimpersonate another person or represent yourself as affiliated with us, our staff or other industry professionals;\nsolicit a user's password or other account information; or\nharvest company names, user names, addresses, or email addresses for any purpose.\nThis list is an example and is not intended to be complete or exclusive. We don’t have an obligation to monitor your access to or use of the Service or to review or edit any Content, but we have the right to do so for the purpose of operating the Service, to ensure your compliance with these Terms, or to comply with applicable law or the order or requirement of a court, administrative agency or other governmental body. We reserve the right, at any time and without prior notice, to remove or disable access to any Content, that we consider, in our sole discretion, to be in violation of these Terms or otherwise harmful to MyScrap.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
    
        let contentMyScrap: NSAttributedString = NSAttributedString(string: "Content on MyScrap", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let contentMyScrapContent: NSAttributedString = NSAttributedString(string: "\n\nThe Content available through MyScrap has not been reviewed, verified or authenticated by us, and may include inaccuracies or false information. We make no representations, warranties, or guarantees in connection with our Service or any Content on MyScrap, relating to the quality, suitability, truth, accuracy or completeness of any content contained in the Service. You acknowledge sole responsibility for and assume all risk arising from your use or reliance of any Content.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
        let Copyright: NSAttributedString = NSAttributedString(string: "Copyright Policy", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let CopyrightContent: NSAttributedString = NSAttributedString(string: "\n\nMyScrap is the owner or licensee of various trademarks associated with the Platform, including, without limitation, MyScrap™ (the “Marks”). All Marks are and will remain the exclusive property of MyScrap and/or its licensors, whether or not specifically recognized or perfected under the laws of the jurisdiction where Member opera tes. Member will not register the Marks (or any mark that is identical or confusingly similar to the Marks) or take any action that jeopardizes MyScrap’s or its licensors’ proprietary rights in the Marks. Any proprietary rights in the Marks which Member may acquire through use or otherwise are hereby assigned to MyScrap and or its licensors and Member agrees to execute any documents which may be required to perfect such rights in MyScrap and/or its licensors. Member is only granted the limited use rights specified herein.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
        let Unauthorized: NSAttributedString = NSAttributedString(string: "Unauthorized Activities", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let UnauthorizedContent: NSAttributedString = NSAttributedString(string: "\n\nOur Service may be used and accessed for lawful purposes only. You agree that you will not do any of the following while using or accessing the Service: (i) attempt to access or search the Service or download Content from the Service through the use of any engine, software, tool, agent, device or mechanism (including spiders, robots, crawlers, data mining tools or the like) other than the software and/or search agents provided by us or other generally available third party web browsers; (ii) access, tamper with, or use non-public areas of the Service, our computer systems, or the technical delivery systems of our providers; (iii) gather and use information, such as other users’ names, real names, email addresses, available through the Service to transmit any unsolicited advertising, junk mail, spam or other form of solicitation; (iv) use the Service for any commercial purpose or for the benefit of any third party or in any manner not by these Terms; (v) violate any applicable law or regulation; or (vi) encourage or enable any other individual to do any of the foregoing. We reserve the right to investigate and prosecute violations of any of the above and/or involve and cooperate with law enforcement authorities in prosecuting users who violate these Terms.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
        let Indemnity: NSAttributedString = NSAttributedString(string: "Indemnity", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let IndemnityContent: NSAttributedString = NSAttributedString(string: "\n\nMember shall indemnify, defend and hold harmless MyScrap, its employees, officers, directors, representatives, and agents, from and against any loss, expense or liability (including reasonable attorneys’ fees)  arising from or related in whole or in part to: (i) a breach of these Terms by Member or (ii)  Member’s use of the Platform. MyScrap shall promptly notify Member of an indemnified claim, render to Member reasonable assistance (at Member’s expense) as required, and permit Member to direct the defence or settlement negotiations.  In no event shall Member settle any such claim, lawsuit or proceeding in a manner that would cause MyScrap to incur liability, without MyScrap prior written approval.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
        let thirdParty: NSAttributedString = NSAttributedString(string: "Links to Third Party Sites", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let thirdPartyContent: NSAttributedString = NSAttributedString(string: "\n\nThe Service may include links to other sites and services that are not operated by us. We are providing these links to you only as a convenience and are not responsible for the content or links displayed on such sites. You are responsible for and assume all risk arising from your use or reliance of any third party sites.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
        let Ownership: NSAttributedString = NSAttributedString(string: "Ownership", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let OwnershipContent: NSAttributedString = NSAttributedString(string: "\n\nOur App and Service is protected by copyright, trademark, and other ____. Except as expressly provided in these Terms, we (or our licensors) exclusively own all right, title and interest in and to the App and the Service, including all associated intellectual property rights. You may not remove, alter or obscure any copyright, trademark, service mark or other proprietary rights notices incorporated in or accompanying the App or the Service, including in any Content.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
        let Termination: NSAttributedString = NSAttributedString(string: "Termination", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let TerminationContent: NSAttributedString = NSAttributedString(string: "\n\nIf you breach any of the terms of these Terms, we have the right to suspend or disable your access to or use of the App and/or Service.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
        let Disclaimer: NSAttributedString = NSAttributedString(string: "Disclaimer", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let DisclaimerContent: NSAttributedString = NSAttributedString(string: "\n\nYou understand and agree that the App and the Service are provided to you “AS IS” and on an “AS AVAILABLE” basis. Without limiting the foregoing, WE EXPLICITLY DISCLAIM ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT, AND ANY WARRANTIES ARISING OUT OF COURSE OF DEALING OR USAGE OF TRADE. We make no warranty that the App or the Service will meet your requirements or be available on an uninterrupted, secure, or error-free basis.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
        let liability: NSAttributedString = NSAttributedString(string: "Limitation of Liability", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let liabilityContent: NSAttributedString = NSAttributedString(string: "\n\nUNDER NO CIRCUMSTANCES WILL MYSCRAP OR ANY OF ITS OFFICERS, DIRECTORS, EMPLOYEES, SHAREHOLDERS, AGENTS OR REPRESENTATIVES HAVE ANY LIABILITY HEREUNDER FOR ANY CONSEQUENTIAL, EXEMPLARY, INCIDENTAL, INDIRECT, PUNITIVE OR SPECIAL DAMAGES OR COSTS (INCLUDING ATTORNEYS’ FEES), OR LOSS OF PROFITS, REVENUE OR GOODWILL, IN ANY WAY RELATING TO THESE TERMS OR RESULTING FROM THE USE OR INABILITY TO USE, OR PERFORMANCE OR NONPERFORMANCE OF, THE PLATFORM OR ANY OTHER SERVICES PROVIDED BY MYSCRAP, EVEN IF MYSCRAP HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH LIABILITY, AND WHETHER SUCH LIABILITY IS BASED UPON CONTRACT, WARRANTY, TORT, NEGLIGENCE, STRICT LIABILITY, PRODUCTS LIABILITY OR OTHERWISE. FURTHERMORE, MYSCRAP SHALL HAVE NO LIABILITY FOR ANY DAMAGES RESULTING OR ARISING FROM MEMBER’S RELIANCE ON THE PLATFORM, OR THE MISTAKES, OMISSIONS, INTERRUPTIONS, ERRORS, DEFECTS, DELAYS IN OPERATION OF THE PLATFORM, ACTS OR OMISSIONS OF ANY OTHER MEMBER, METAL-PAGES LTD OR ANY OTHER THIRD PARTY, UNAUTHORIZED ACCESS TO THE PLATFORM BY ANY PARTY, THE TERMINATION OF MEMBER’S MEMBERSHIP BY MYSCRAP PURSUANT TO THESE TERMS,  THE FAILURE OF ANY PARTIES TO PERFORM ANY TRANSACTION CONCLUDED ON THE PLATFORM, THE FAILURE, OR ALLEGED FAILURE, OF ANY MATERIAL OR OTHER ITEM PURCHASED OR TRANSFERRED USING OR INVOLVING THE PLATFORM TO CONFORM TO ANY SPECIFICATIONS OR TERMS, WHETHER POSTED ON THE PLATFORM OR NOT, OR THE BREACH, OR ALLEGED BREACH, OF ANY WARRANTY, EXPRESS OR IMPLIED, RELATING TO ANY SUCH ITEM OR SHIPMENT.\nCAP ON LIABILITY.  IN NO EVENT WILL MYSCRAP’S AGGREGATE LIABILITY TO MEMBER FOR ANY CAUSE, AND REGARDLESS OF THE FORM OF ACTION. MYSCRAP SHALL HAVE NO LIABILITY FOR ANY DAMAGES WHATSOEVER RELATING TO ANY MATERIALS OR SERVICES NOT PROVIDED TO MEMBER BY MYSCRAP.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
        let modifications: NSAttributedString = NSAttributedString(string: "Modifications", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let modificationsContent: NSAttributedString = NSAttributedString(string: "\n\nMyScrap may modify these Terms from time to time. Any and all changes to these Terms will be posted on the Platform and revisions will be indicated by date. Members agree to be bound to any changes to these Terms when accessing or using the Platform after any such modification becomes effective. MyScrap may also, in its discretion, alert all Members with whom it maintains email information of such modifications by means of an email to their most recently provided email address. It is therefore important that Members regularly review these Terms and keep contact information current in the account settings to ensure that Members are informed of changes. Members agree to periodically check the Platform for updates to these Terms. Modifications to these Terms shall be effective as of the revision date posted.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
        let exclusions: NSAttributedString = NSAttributedString(string: "Exclusions", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let exclusionsContent: NSAttributedString = NSAttributedString(string: "\n\nSome jurisdictions do not allow the exclusion of certain warranties or the exclusion or limitation of liability for consequential or incidental damages, so the limitations above may not apply to you.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
        let questions: NSAttributedString = NSAttributedString(string: "Questions &amp; Contact Information", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let questionsContent: NSAttributedString = NSAttributedString(string: "\n\nIf you have questions about our Terms &amp; Conditions, please contact us.", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
        // Privacy URLS
    
        let privacyTitle :NSAttributedString = NSAttributedString(string: "Privacy Policy General\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.privacyTitleFont])
    
    let protectInfo: NSAttributedString = NSAttributedString(string: "How do we protect your information?", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
    let protectInfoContent: NSAttributedString = NSAttributedString(string: "\n\nWe implement a variety of security measures to maintain the safety of your personal information when you enter, submit, or access your personal information. We will not share personal information we have collected from you, except as described below:\n·  With your friends on MyScrap with whom you want to stay in contact on MyScrap, and according to the preferences set in your account.\n·  When we believe in good faith that we are lawfully authorized or required to do so or that doing so is reasonably necessary or appropriate to comply with the law or legal processes or respond to lawful request or legal authorities, including responding to lawful subpoenas, warrants or court orders.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
    
    
    let cookies: NSAttributedString = NSAttributedString(string: "Do we use cookies?", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
    let cookiesContent: NSAttributedString = NSAttributedString(string: "\n\nYes, we use cookies, but only to improve user experience.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
//
//

    let disclose : NSAttributedString = NSAttributedString(string: "Do we disclose any information to outside parties?", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
    let discloseContent: NSAttributedString = NSAttributedString(string: "\n\nWe do not sell, trade, or otherwise transfer to outside parties your personally identifiable information. This does not include trusted third parties who assist us in operating our website, conducting our business, or servicing you, so long as those parties agree to keep this information confidential. We may also release your information when we believe release is appropriate to comply with the law, enforce our site policies, or protect ours or others rights, property, or safety. However, non-personally identifiable visitor information may be provided to other parties for marketing, advertising, or other use.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])

//

    let information: NSAttributedString = NSAttributedString(string: "What information do we collect?", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let informationContent: NSAttributedString = NSAttributedString(string: "\n\nWe collect information from you when you register on our site.\nWhen ordering or registering on our site, as appropriate, you may be asked to enter your: name and e-mail address. You may, however, visit our site anonymously. We collect certain information you provide to us when using MyScrap, such as when you create an account and profile or send us an email or other content to MyScrap. We collect certain information like your name, picture, email address and phone number.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
//
    
    let useInformation: NSAttributedString = NSAttributedString(string: "What do we use your information for?", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let useInformationContent: NSAttributedString = NSAttributedString(string: "\n\nAny of the information we collect from you may be used in one of the following ways:\n·  The email address you provide may be used to send you information, respond to inquiries, and/or other requests or questions.\n·  To send periodic emails.\n·  To find and connect with your friends (when instructed by you)\n·  To send you confirmations, updates, security alerts, and support and administrative messages and otherwise facilitate your use of, and our administration and operation of, our services.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
        let postings: NSAttributedString = NSAttributedString(string: "Postings", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let postingsContent: NSAttributedString = NSAttributedString(string: "\n\nCertain Personally-Identifying Information collected from users is disclosed as a matter of course as a result of their use of the Website. We may provide areas on our Website where you may be able to post reviews and other information relating to your activities on the Website. Such postings are governed by our Terms and Conditions. Whenever you voluntarily disclose personal information on publicly-viewable web pages, that information will be publicly available and can be collected and used by others. For example, if you post your email address, you may receive unsolicited messages. We cannot control who reads your posting or what other users may do with the information you voluntarily post, so we encourage you to exercise discretion and caution with respect to your personal information. Users assume all responsibility for any loss of privacy or other harm resulting from their voluntary disclosure of personally identifying information.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
        let security: NSAttributedString = NSAttributedString(string: "Security", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let securityContent: NSAttributedString = NSAttributedString(string: "\n\nWe take security of your Personally-Identifying Information seriously and use reasonable electronic, personnel, and physical measures to protect it from loss, theft, alteration, or misuse. However, please be advised that even the best security measures cannot fully eliminate all risks. We cannot guarantee that only authorized persons will view your information. We are not responsible for third party circumvention of any privacy settings or security measures.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
        let marketing: NSAttributedString = NSAttributedString(string: "Marketing Communications", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let marketingContent: NSAttributedString = NSAttributedString(string: "\n\nFrom time to time, MyScrap may offer its users the opportunity to participate in contests, and other promotions. Any information submitted in connection with such activities will be treated in accordance with this Privacy Policy. From time to time, MyScrap may also ask users to participate in surveys designed to help MyScrap improve the platform. Any Personally-Identifying Information provided to MyScrap in connection with any survey will be used only in relation to that survey, and will be disclosed to third parties not bound by this Privacy Policy only in non-personally-identifying, aggregated form.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
    
        let children: NSAttributedString = NSAttributedString(string: "Children Online Privacy Protection Act Compliance", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let childrenContent: NSAttributedString = NSAttributedString(string: "\n\nWe are in compliance with the requirements of COPPA (Childrens Online Privacy Protection Act), we do not collect any information from anyone under 13 years of age. Our website, products and services are all directed to people who are at least 13 years old or older.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
    
        let onlinePrivacy: NSAttributedString = NSAttributedString(string: "Online Privacy Policy Only", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let onlinePrivacyContent: NSAttributedString = NSAttributedString(string: "\n\nThis online privacy policy applies only to information collected through our website and mobile apps but not to information collected offline.\nChanging Personally-Identifying Information; Account Termination\nYou may at any time review or change your Personally-Identifying Information by going to your account settings. Upon your request, we will deactivate or delete your account and contact information from our active databases. Such information will be deactivated or deleted as soon as practicable based on your account activity and in accordance with our deactivation policy and applicable law. To make this request, either go to your account settings (if applicable) or contact us as provided below. We will retain in our files some personal information to prevent fraud, to troubleshoot problems, to assist with any investigations, to enforce our Terms and Conditions and to comply with legal requirements as is permitted by law. Therefore, you should not expect that all your personal information will be completely removed from our databases in response to your requests. Additionally, we keep a history of changed information to investigate suspected fraud with your account.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
            let consent: NSAttributedString = NSAttributedString(string: "Your Consent", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let consentContent: NSAttributedString = NSAttributedString(string: "\n\nBy using our site, you consent to our online privacy policy.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
            let changePrivacy: NSAttributedString = NSAttributedString(string: "Changes to our Privacy Policy", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let changePrivacyContent: NSAttributedString = NSAttributedString(string: "\n\nIf we decide to change our privacy policy, MyScrap may, in its sole discretion, change this Privacy Policy from time to time. Any and all changes to MyScrap’s users platform will be reflected on this page and the date new versions are posted will be stated at the top of this Privacy Policy. Unless stated otherwise, our current Privacy Policy applies to all information that we have about you and your account. Users should regularly check this page for any changes to its Privacy Policy. MyScrap will always post new versions of the Privacy Policy on the Website. However, MyScrap may, in its discretion, notify users of changes made to this Privacy Policy via email or otherwise. Accordingly, it is important that users always maintain and update their contact information.\n\n", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
            let contactingUs: NSAttributedString = NSAttributedString(string: "Contacting Us", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
        let contactingUsContent: NSAttributedString = NSAttributedString(string: "\n\nIf there are any questions regarding our privacy policy, please contact us on support@myscrap.com.", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
    let disclaimer: NSAttributedString = NSAttributedString(string: "Disclaimer", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsHedingFont])
    let disclaimerContent: NSAttributedString = NSAttributedString(string: "\n\nThe information contained in this website is for general purposes only. Every effort is make to keep the website up and running smoothly, however MyScrap takes no responsibility for and will not be liable for the website being temporarily unavailable due to technical issues beyond our control.\nMyScrap collect information with consent from the user information that is necessary to fulfill the purpose of smooth interaction. MyScrap is giving an assurance that the information will be protected, to do that MyScrap set up procedures to ensure that your information is handled responsibly in accordance with applicable data protection and privacy.", attributes: [.foregroundColor : UIColor.BLACK_ALPHA , .font : Fonts.termsSubHedingFont])
    
    
    
    
   var attributedString: NSMutableAttributedString{
        let result = NSMutableAttributedString()
        result.append(termsofServices)
        result.append(termsofServicesContent)
        result.append(useOfTheService)
        result.append(useOfTheServiceContent)
        result.append(creatingAccount)
        result.append(creatingAccountContent)
        result.append(falseAccount)
        result.append(falseAccountContent)
        result.append(claimingCompany)
        result.append(claimingCompanyContent)
        result.append(privacyPolicy)
        result.append(privacyPolicyContent)
        result.append(contentSubmission)
        result.append(contentSubmissionContent)
        result.append(contentMyScrap)
        result.append(contentMyScrapContent)
        result.append(Copyright)
        result.append(CopyrightContent)
        result.append(Unauthorized)
        result.append(UnauthorizedContent)
        result.append(Indemnity)
        result.append(IndemnityContent)
        result.append(Ownership)
        result.append(OwnershipContent)
        result.append(Termination)
        result.append(TerminationContent)
        result.append(Disclaimer)
        result.append(DisclaimerContent)
        result.append(liability)
        result.append(liabilityContent)
        result.append(modifications)
        result.append(modificationsContent)
        result.append(exclusions)
        result.append(exclusionsContent)
        result.append(questions)
        result.append(questionsContent)
        return result
    }
    
    var privacyAttributedString: NSMutableAttributedString{
        let result = NSMutableAttributedString()
        result.append(privacyTitle)
        result.append(protectInfo)
        result.append(protectInfoContent)
        result.append(cookies)
        result.append(cookiesContent)
        result.append(disclose)
        result.append(discloseContent)
        result.append(information)
        result.append(informationContent)
        result.append(useInformation)
        result.append(useInformationContent)
        result.append(postings)
        result.append(postingsContent)
        result.append(security)
        result.append(securityContent)
        result.append(marketing)
        result.append(marketingContent)
        result.append(children)
        result.append(childrenContent)
        result.append(onlinePrivacy)
        result.append(onlinePrivacyContent)
        result.append(consent)
        result.append(consentContent)
        result.append(changePrivacy)
        result.append(changePrivacyContent)
        result.append(contactingUs)
        result.append(contactingUsContent)
        
        return result
    }
    
    var disclaimerString : NSMutableAttributedString{
        let result = NSMutableAttributedString()
        result.append(disclaimer)
        result.append(disclaimerContent)
        return result
        
    }
    
}
