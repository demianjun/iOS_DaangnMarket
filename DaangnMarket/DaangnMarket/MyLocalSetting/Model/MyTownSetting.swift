//
//  MyTowns.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyTownSetting {
  // MARK: Shared
  
  static var shared = MyTownSetting()
  
  // MARK: TownSelectView Property
  
  var isFirstTown = Bool()

  var firstSelectTown = String()
  var secondSelectTown = String()

  var towns = [String: String]()
  
  // MARK: MyTownAroundView Property
  
  var firstTownByDistance: [Town]? {
    return UserDefaults.standard.object([Town].self, forKey: .firstTownByDistance)
  }
  
  var secondTownByDistance: [Town]? {
    return UserDefaults.standard.object([Town].self, forKey: .secondTownByDistance)
  }
  
  func register(townInfo: [Town]) {
    if self.firstTownByDistance == nil {
      UserDefaults.standard.set(townInfo, forKey: .firstTownByDistance)
    } else if self.secondTownByDistance == nil {
      UserDefaults.standard.set(townInfo, forKey: .secondTownByDistance)
    } else {
      return
    }
  }
  
  var slideValue = Float()
  var numberOfAroundTownByFirst = (Int(), Int())
  var numberOfAroundTownBySecond = (Int(), Int())
  
  enum DeleteTown {
    case oneTown
    case towTown
  }
  
  enum UpperAlerCallBtn {
    case firstBtn
    case secondBtn
  }
}
