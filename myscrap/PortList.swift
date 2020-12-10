import Foundation

struct PortList: Decodable{
 
    
    var country_id : String
    //    let port_name : String
    private let country_name:String
    
    let flagcode: String
    
    let port_list : [MSPortList]
    
    var country: String{
        return country_name.capitalized
    }
    
    
    static func getportList() -> [PortList]? {
        //Maha Code (replaced JSON file with API https://myscrap.com/ios/getportWithCon)
        let service = APIService()
        service.endPoint = Endpoints.PORT_LIST
        
        print("End point", service.endPoint)
        let url = URL(string: service.endPoint)
        
        do {
            let data = try Data(contentsOf: url!)
            let jsonData = try JSONDecoder().decode([PortList].self, from: data)
            print("Port list data :\(jsonData)")
            return jsonData
        } catch {
            print("Port list error",error.localizedDescription)
        }
        
        /*if let url = Bundle.main.url(forResource: "ms_country_list", withExtension: "json"){
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONDecoder().decode([PortList].self, from: data)
                return jsonData
            } catch {
                print(error.localizedDescription)
            }
        }*/
      return nil
    }
    
    /*static func handleAuthDetails(json: [PortList]){
        
        let cou_code = json["country_code"] as? String
        
        
        var userid = ""
        var colorcode = ""
        var firstname = ""
        var lastname = ""
        var mail = ""
        var passw = ""
        var profile = ""
        var userjid = ""
        
        if let error = json["error"] as? Bool{
            
            
            if !error{
                if port_list = json["userData"] as? [String:AnyObject]{
                    if let uid = userdict["userId"] as? String{
                        userid = uid
                    }
                    if let fname = userdict["firstName"] as? String{
                        firstname = fname
                    }
                    if let lname = userdict["lastName"] as? String{
                        lastname = lname
                    }
                    if let email = userdict["email"] as? String{
                        mail = email
                    }
                    if let pwd = userdict["password"] as? String{
                        passw = pwd
                    }
                    if let pro = userdict["profilePic"] as? String{
                        profile = pro
                    }
                    if let color = userdict["colorCode"] as? String{
                        colorcode = color
                    }
                    if let jId = userdict["jId"] as? String{
                        userjid = jId
                    }
                    
                    
                    self.updateRegistrationDetails(email: mail, firstName: firstname, lastName: lastname, password: passw, profilePic: profile, userId: userid, colorCode: colorcode, loggedIn: true, userJID: userjid)
                    
                    if let isShared = userdict["isShared"] as? String {
                        AuthStatus.instance.isShared = isShared == "1"
                    }
                    
                    if let lmesubscription = userdict["lmeSubscription"] as? String , let intValue = Int(lmesubscription) {
                        AuthStatus.instance.setLMEStatus = intValue
                    }
                    
                    //delegate?.didSuccessAuthService(status: true)
                }
            } else {
                delegate?.didSuccessAuthService(status: false)
            }
        } else {
            delegate?.didSuccessAuthService(status: false)
        }
    }*/
    
}

struct MSPortList: Decodable{
    let port_id: String
    let port_name: String
}



//[{"country_id":"2","country_name":"ALBANIA","flagcode":"099","port_list":[{"port_id":"22","port_name":"Sarande Port"}
