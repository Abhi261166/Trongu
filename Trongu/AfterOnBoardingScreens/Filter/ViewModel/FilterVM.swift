//
//  FilterVM.swift
//  Trongu
//
//  Created by apple on 07/10/23.
//

import UIKit
protocol FilterVMObserver: NSObjectProtocol {

    func observeGetCategoriesListSucessfull()
    
}

class FilterVM: NSObject {

    var observer: FilterVMObserver?
    var arrNoOfDays:[Category] = []
    var arrTripComplexity:[Category] = []
    var arrTripCategory:[Category] = []
    var arrEthnicity:[SignUpCatItem] = []
    
    init(observer: FilterVMObserver?) {
        self.observer = observer
    }
    
    //MARK: - Get Categories -
    
    func apiGetCategoriesList(type:Int) {
        var params = JSON()
        params["type"] = type
        print("params : ", params)
        
        arrNoOfDays = []
        arrTripComplexity = []
        arrTripCategory = []
        
        ApiHandler.callWithMultipartForm(apiName: API.Name.getCategories, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                if succeeded == true, let data {
                    let decoder = JSONDecoder()
                    do {
                        let decoded = try decoder.decode(CategoriesModel.self, from: data)
                        
                        self.arrNoOfDays.append(contentsOf: decoded.numberOfDays)
                        
                        let tripCategoryFirstValue = Category(id: "", noOfDays: "", status: "", createdAt: "", name: "Select trip category")
                        self.arrTripCategory.append(tripCategoryFirstValue)
                        let tripComplexityFirstValue = Category(id: "", noOfDays: "", status: "", createdAt: "", name: "Select trip complexity") //complexity
                        self.arrTripComplexity.append(tripComplexityFirstValue)
                        
                        self.arrTripCategory.append(contentsOf: decoded.tripCategory)
                        self.arrTripComplexity.append(contentsOf: decoded.tripComplexity)
                        self.observer?.observeGetCategoriesListSucessfull()
                    } catch {
                        print("error", error)
                    }
                }
            }
        }
    }
    
    func apiGetEthnicityCategoriesList(type:Int) {
        var params = JSON()
        params["type"] = type
        print("params : ", params)
        
        ApiHandler.callWithMultipartForm(apiName: API.Name.getCategories, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                if succeeded == true, let data {
                    let decoder = JSONDecoder()
                    do {
                        let decoded = try decoder.decode(SignUpCatModel.self, from: data)
                        
                        let ethnicityFirstValue = SignUpCatItem(id: "", name: "Select trip ethnicity", status: "", createdAt: "", genderName: "")
                        self.arrEthnicity.append(ethnicityFirstValue)
                        self.arrEthnicity.append(contentsOf: decoded.ethnicity)
                        self.observer?.observeGetCategoriesListSucessfull()
                    } catch {
                        print("error", error)
                    }
                }
            }
        }
    }
    
}
