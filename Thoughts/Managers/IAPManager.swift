//
//  IAPManager.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import Foundation
import Purchases /* 37 */
import StoreKit /* 249 */

final class IAPManager { /* 31 */
    static let shared = IAPManager() /* 32 */
    
    static let formatter = ISO8601DateFormatter() /* 907 */
    
    private var postEligibleViewDate: Date? { /* 870 */
        get { /* 905 */
            guard let string = UserDefaults.standard.string(forKey: "postEligibleViewDate") else { /* 912 */
                return nil /* 913 */
            }
            return IAPManager.formatter.date(from: string) /* 914 */
        }
        set { /* 906 */
            guard let date = newValue else { /* 909 */
                return /* 910 */
            }
            let string = IAPManager.formatter.string(from: date) /* 908 */
            UserDefaults.standard.set(string, forKey: "postEligibleViewDate") /* 911 */
        }
    }
    //9eb0501030a848b2bcd519ef0c3941c0
    
    private init() {} /* 33 */
    
    func isPremium() -> Bool { /* 34 */ /* 118 add -> Bool */
//        return false /* 119 */
        return UserDefaults.standard.bool(forKey: "premium") /* 234 */
    }
    
    public func getSubscriptionStatus(completion: ((Bool) -> Void)?) { /* 235 */ /* 266 add completion and () */
        Purchases.shared.purchaserInfo { info, error in /* 238 */
            guard let entitlements = info?.entitlements,
                  error == nil else { /* 239 */
                return /* 240 */
            }
            
            if entitlements.all["Premium"]?.isActive == true { /* 267 */
                print("Got updated status of subscribed") /* 281 */
                UserDefaults.standard.set(true, forKey: "premium") /* 271 */
                completion?(true) /* 268 */
            } else { /* 269 */
                print("Got updated status of NOT subscribed") /* 282 */
                UserDefaults.standard.set(false, forKey: "premium") /* 272 */
                completion?(false) /* 270 */
            }
//            print(entitlements) /* 241 */
        }
    }
    
    public func fetchPackages(completion: @escaping (Purchases.Package?) -> Void) { /* 237 */
        Purchases.shared.offerings { offerings, error in /* 242 */
            guard let package = offerings?.offering(identifier: "default")?.availablePackages.first, /* 243 */
                  error == nil else {
                completion(nil) /* 244 */
                return
            }
            
            completion(package) /* 245 */
        }
    }
    
    public func subscribe(
        package: Purchases.Package,
        completion: @escaping (Bool) -> Void
    ) { /* 35 */ /* 236 add package: */ /* 273 add completion */
        guard !isPremium() else { /* 263 */
            print("User already subscribed") /* 264 */
            completion(true) /* 274 */
            return /* 265 */
        }
        
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCancelled in /* 246 */
            guard let transaction = transaction,
                  let entitlements = info?.entitlements,
                  error == nil,
                  !userCancelled else { /* 247 */
                return /* 248 */
            }
            
            switch transaction.transactionState { /* 250 */
            case .purchasing: /* 251 */
                print("purchasing") /* 252 */
            case .purchased: /* 251 */
//                UserDefaults.standard.set(true, forKey: "premium") /* 257 */
                if entitlements.all["Premium"]?.isActive == true { /* 275 copy from 267 and paste */
                    print("Purchased!") /* 252 */
                    UserDefaults.standard.set(true, forKey: "premium") /* 275 */
                    completion(true) /* 275 */
                } else { /* 275 */
                    print("Purchased failed") /* 276 */
                    UserDefaults.standard.set(false, forKey: "premium") /* 275 */
                    completion(false) /* 275 */
                }
            case .failed: /* 251 */
                print("failed") /* 252 */
            case .restored: /* 251 */
                print("restore") /* 252 */
            case .deferred: /* 251 */
                print("deferred") /* 252 */
            @unknown default: /* 251 */
                print("default case") /* 252 */
            }
        }
    }
    
    public func restorePurchases(completion: @escaping (Bool) -> Void) { /* 36 */ /* 278 add completion handler */ 
        Purchases.shared.restoreTransactions { info, error in /* 253 */
            guard let entitlements = info?.entitlements,
                  error == nil else { /* 254 */
                return /* 255 */
            }
//            print("Restored: \(entitlements)") /* 256 */
            if entitlements.all["Premium"]?.isActive == true { /* 277 copy from 267 */
                print("Restored success") /* 283 */
                UserDefaults.standard.set(true, forKey: "premium") /* 277 */
                completion(true) /* 277 */
            } else { /* 277 */
                print("Restored failure") /* 284 */
                UserDefaults.standard.set(false, forKey: "premium") /* 277 */
                completion(false) /* 277 */
            }
        }
    }
}

//MARK: - Track Post Views
extension IAPManager { /* 867 */
    var canViewPost: Bool { /* 868 */
        if isPremium() { /* 901 */
            return true /* 902 */
        }
        guard let date = postEligibleViewDate else { /* 871 */
            return true /* 872 */
        }
        UserDefaults.standard.set(0, forKey: "post_views") /* 880 */
        return Date() >= date /* 869 */
    }
    
    public func logPostViewed() { /* 873 */
        let total = UserDefaults.standard.integer(forKey: "post_views")  /* 874 */
            //            total = count + 1 /* 876 */
            UserDefaults.standard.set(total+1, forKey: "post_views") /* 875 */
            
            if total == 2 { /* 877 */
                let hour: TimeInterval = 60 * 60 /* 878 */
                postEligibleViewDate = Date().addingTimeInterval(hour * 24) /* 879 */
            }
        }
    }

