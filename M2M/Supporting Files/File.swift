//
//  File.swift
//  thePrototype
//
//  Created by Tran Sam on 11/12/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import Foundation

public struct Quaternion {
    public var w: Float = 0.0
    public var x: Float = 0.0
    public var y: Float = 0.0
    public var z: Float = 0.0
    
    public var norm: Float {
        get {
            return sqrt(pow(w,2) + pow(x,2) + pow(y,2) + pow(z,2))
        }
    }
    
    public func getUnitQuaternion() -> Quaternion {
        return Quaternion(w: w/norm, x: x/norm, y: y/norm, z: z/norm)
    }
    
    public func getConjugate() -> Quaternion {
        return Quaternion(w: w, x: (-x), y: (-y), z: (-z))
    }
    
    public func getDotProduct(q2: Quaternion) -> Float {
        let q1 = self
        let product = (q1.w * q2.w) + (q1.x * q2.x) + (q1.y * q2.y) + (q1.z * q2.z)
        return product
    }
}

final public class BodyJoint {
    public var orientation: Quaternion
    
    public init () {
        orientation = Quaternion()
    }
    
    public func getAngleBetweenJoints(otherJoint: BodyJoint) -> Float {
        var q1 = self.orientation
        var q2 = otherJoint.orientation
        
        q1 = q1.getUnitQuaternion()
        q2 = q2.getUnitQuaternion()
        
        let q2Conj = q2.getConjugate()
        let cosTheta = q1.getDotProduct(q2: q2Conj)
        
        return acos(cosTheta)
    }
}
