//
//  Interests.swift
//  myscrap
//
//  Created by MS1 on 1/16/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

struct  Interests {
    
    let companyCommodityData = ["Non-Ferrous", "Ferrous", "Glass", "Paper", "Plastic", "Electronics", "Rubber", "Textile", "Others"]
    
    let companyIndustryData = ["Processor", "Broker", "Consumer" ,"Trader", "Institution", "Equipment", "Media", "Others"]
    
    let companyAffiliationData = ["ISRI", "BIR", "CMRA", "BMR", "Others"]
    
    /*let companyCommodityData = ["Non-Ferrous Metals",
                                   "Ferrous Metals",
                                   "Stainless Steel",
                                   "Tyres",
                                   "Paper",
                                   "Textiles",
                                   "Plastic",
                                   "E-Scrap",
                                   "Red Metals",
                                   "Aluminum",
                                   "Zinc",
                                   "Magnesium",
                                   "Lead",
                                   "Nickel/Stainless/Hi Temp",
                                   "Mixed Metals",
                                   "Electric Furnace Casting and Foundry",
                                   "Specially Processed Grades",
                                   "Cast Iron Grades",
                                   "Special Boring Grades",
                                   "Steel From Scrap Tiles",
                                   "Railroad Ferrous Scrap",
                                   "Stainless Alloy",
                                   "Special Alloy",
                                   "Copper",
                                   "Finance",
                                   "Insurance",
                                   "Shipping",
                                   "Equipments",
                                   "Others"
      ]*/
    
    /*let companyIndustryData = [ "Trader",
                                 "Indentor",
                                 "Recycler",
                                 "Exporter",
                                 "Stocker",
                                 "Equipment",
                                 "Service",
                                 "Consumer",
                                 "Consultant",
                                 "Importer",
                                 "Press",
                                 "Supplier",
                                 "Media",
                                 "Other"
    ]*/
    
    
    
    /*let companyAffiliationData = [
                                "BIR",
                                "ISRI",
                                "BMR",
                                "CMRA",
                                "MRAI"
    ]*/
    
    let userCommodityDictionary = [
                            "Non-Ferrous Metals",
                            "Ferrous Metals",
                            "Stainless Steel",
                            "Tyres",
                            "Paper",
                            "Textiles",
                            "Plastic",
                            "E-Scrap",
                            "Red Metals",
                            "Aluminum",
                            "Zinc",
                            "Magnesium",
                            "Lead",
                            "Nickel/Stainless/Hi Temp",
                            "Mixed Metals",
                            "Electric Furnace Casting and Foundry",
                            "Specially Processed Grades",
                            "Cast Iron Grades",
                            "Special Boring Grades",
                            "Steel From Scrap Tiles",
                            "Railroad Ferrous Scrap",
                            "Stainless Alloy",
                            "Special Alloy",
                            "Copper",
                            "Finance",
                            "Insurance",
                            "Shipping",
                            "Equipments",
                            "Others"
    ]

    
    let usersRoleData = [
                        "Trader",
                        "Agent",
                        "Recycler",
                        "Exporter",
                        "Stocker",
                        "Equipment",
                        "Service",
                        "Consumer",
                        "Consultant",
                        "Press",
                        "Importer",
                        "Supplier",
                        "Other"
        
    ]
    
    
    func getUsersCommodities() -> [String]{
        return userCommodityDictionary
    }
    
    func getUsersRoles() -> [String]{
        return usersRoleData
    }
    
    // Commodity
    func getCompanyCommodities(input: [String]) -> [String]{
       /* var returnArray = [String]()
        if !input.isEmpty {
            for i in input{
                returnArray.append(companyCommodityData[Int(i)!])
            }
        }
        return returnArray */
        
        let getValues = self.setUpInterestsArray(inputArray: input, indexArray: companyCommodityData)
        return getValues

    }
    // Business Type
    func getCompanyIndustries(input: [String])-> [String]{
      /*  var returnArray = [String]()
        if !input.isEmpty {
            for i in input{
                returnArray.append(companyIndustryData[Int(i)!])
            }
        }
        return returnArray */
     
        let getValues = self.setUpInterestsArray(inputArray: input, indexArray: companyIndustryData)
        return getValues
    }
    // Affiliation
   func getCompanyAffiliation(input: [String]) -> [String]{
    /* var returnArray = [String]()
        if !input.isEmpty {
            for i in input{
                returnArray.append(companyAffiliationData[Int(i)!])
            }
        }
        return returnArray */
    
        let getValues = self.setUpInterestsArray(inputArray: input, indexArray: companyAffiliationData)
        return getValues

    }
    
    func getUserCommodities(input: [String]) -> [String]{
        var returnArray = [String]()
        
        if !input.isEmpty {
            for i in input{
                returnArray.append(userCommodityDictionary[Int(i) ?? 0])
            }
        }
        return returnArray
    }
    
    func getUserRoles(input: [String]) -> [String]{
        var returnArray = [String]()
        if !input.isEmpty {
            for i in input{
                returnArray.append(usersRoleData[Int(i)!])
            }
        }
        return returnArray
    }
    
    
    //MARK:- setUpInterestsArray
    func setUpInterestsArray(inputArray: [String], indexArray: [String]) -> [String] {
        
        var returnArray = [String]()

        if inputArray.count > 0 {
            let splitStr = inputArray[0]
            let splitArr = splitStr.split(separator: ",")
            
            if !inputArray.isEmpty {
                
                for value in splitArr {
                    let obj = Int(value)!
                    returnArray.append(indexArray[obj])
                }
            }
        }
        return returnArray
    }
}
