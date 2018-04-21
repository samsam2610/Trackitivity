//
//  RepCount.swift
//  M2M
//
//  Created by Tran Sam on 4/21/18.
//  Copyright © 2018 Tran Sam. All rights reserved.
//

import Foundation

class RepCount {
    
    private init() {}
    let manager = RepCount()
    
    var current_values = [0.0, 0.0, 0.0, 0.0]
    var pre_1st_value = [0.0, 0.0, 0.0, 0.0]
    var pre_2nd_value = [0.0, 0.0, 0.0, 0.0]
    var pre_3rd_value = [0.0, 0.0, 0.0, 0.0]
    
    var current_diff = [0.0, 0.0, 0.0, 0.0]
    var pre_1st_diff = [0.0, 0.0, 0.0, 0.0]
    var pre_2nd_diff = [0.0, 0.0, 0.0, 0.0]
    var pre_3rd_diff = [0.0, 0.0, 0.0, 0.0]
    
    var cycle_boo = 0
    var cycle_count = 0
    
    var new_peak = [0.0, 0.0, 0.0, 0.0]
    var new_high = [0.0, 0.0, 0.0, 0.0]
    var current_peak = [0.0, 0.0, 0.0, 0.0]
    
    var old_peak = [0.0, 0.0, 0.0, 0.0]
    var current_start_value = [0.0, 0.0, 0.0, 0.0]
    var prev_start_value = [0.0, 0.0, 0.0, 0.0]
    var end_value = [0.0, 0.0, 0.0, 0.0]
    var sign = [0.0, 0.0, 0.0, 0.0]
    var end_sign = [0.0, 0.0, 0.0, 0.0]
    var start_direction = [0.0, 0.0, 0.0, 0.0]
    
    var current_sign = [0.0, 0.0, 0.0, 0.0]
    var prev_sign = [0.0, 0.0, 0.0, 0.0]
    
    var start_sign = [0.0, 0.0, 0.0, 0.0]
    
    var mag = [0.0, 0.0, 0.0, 0.0]
    var peak_peak = [0.0, 0.0, 0.0, 0.0]
    var peak_boo = [0.0, 0.0, 0.0, 0.0]
    
    var current_loc = [0.0, 0.0, 0.0, 0.0]
    var high_loc = [0.0, 0.0, 0.0, 0.0]
    var loc = [0.0, 0.0, 0.0, 0.0]
    
    var current_marked_peak = [0.0, 0.0, 0.0, 0.0]
    
    var current_max_start_diff = 0.0
    var current_max_start_index = 0
    
    var end_time = 0
    
    func run() {
        current_values = [0.0, 0, 0, 0]
        current_loc = [0, 0, 0, 0]
        
        let current_time = 0
        
        current_diff = zip(current_values, pre_1st_value).map(+)
        current_sign = zip(current_diff, current_diff.map(abs)).map(/)
        
        peak_boo = [0.0, 0, 0, 0]
        
        var sum_diff: Double = 0
        
        for sum in current_diff {
            sum_diff += abs(sum)
        }
        
        var check_count = 0
        
        if prev_start_value.map(abs).min() != 0 && end_sign.map(abs).min() != 0 {
            for (k_index, _) in current_values.enumerated() {
                let temp_index = k_index
                if current_sign[temp_index] == end_sign[temp_index] * (-1) {
                    check_count += 1
                }
            }
        } else {
            check_count = 4
        }
        
        
        if cycle_boo == 0 && current_time - end_time > 500 {
            if check_count >= 3 {
                for (j_index, current_diff) in current_diff.enumerated() {
                    let index = j_index
                    if (abs(current_max_start_diff) < abs(current_diff) && abs(current_diff) > 1 && pre_1st_diff[index] != 0) {
                        current_max_start_diff = abs(current_diff)
                        current_max_start_index = index
                    }
                }
            }
        }
        
        
        for (j_index, current_value) in current_values.enumerated() {
            let index = j_index
            
            if current_sign[index] == prev_sign[index] {
                new_high[index] = current_value
                high_loc[index] = current_loc[index]
            } else if current_sign[index] != prev_sign[index] && cycle_boo > 0 {
                
                if current_sign[index] == -1 {
                    sign[index] = 1
                } else {
                    sign[index] = -1
                }
                
                
                if sign[index] * (current_value - new_high[index]) > 0 {
                    new_peak[index] = current_value
                    loc[index] = current_loc[index]
                    peak_boo[index] = 1
                } else {
                    new_peak[index] = new_high[index]
                    loc[index] = high_loc[index]
                    peak_boo[index] = 1
                }
                
                if new_peak[index] > current_peak[index] {
                    current_peak[index] = new_peak[index]
                }
                    
                mag[index] = current_peak[index] - current_start_value[index]
                if abs(mag[index]) > 30 && abs(current_peak[index] - current_marked_peak[index]) > 30 && current_sign[index] != prev_sign[index] {
                    peak_boo[index] = 1
                    current_marked_peak[index] = current_peak[index]
                    if cycle_boo == 1 {
                        cycle_boo = 2
                    }
                }
            }
            end_value[index] = current_peak[index] - current_value
            
            if index == current_max_start_index {
            
                if current_max_start_diff > 2 && cycle_boo == 0 && 0 < abs(pre_1st_diff[index]) && abs(pre_1st_diff[index]) < abs(current_diff[index]) {
            
                    check_count = 0
                    if prev_start_value[index] != 0 && end_sign[index] != 0 {
                        for k_index in 0...3 {
                            let temp_index = k_index
                            if current_sign[temp_index] == end_sign[temp_index] * (-1) {
                                check_count += 1
                            } else {
                                check_count = 4
                            }
                        }
                    
                            if check_count >= 3 {
                                if prev_start_value[index] != 0 && end_sign[index] != 0 {
                                    cycle_boo = 1
                                    for k_index in 0...3 {
                                        let temp_index = k_index
                                        start_sign[temp_index] = current_sign[temp_index]
                                        current_start_value[temp_index] = current_values[index]
                                        prev_start_value[temp_index] = current_start_value[temp_index]
                                    }
                                } else {
                                    cycle_boo = 1
                                    for k_index in 0...3 {
                                        let temp_index = k_index
                                        start_sign[temp_index] = current_sign[temp_index]
                                        current_start_value[temp_index] = current_values[temp_index]
                                        prev_start_value[temp_index] = current_start_value[temp_index]
                                    }
                                }
                            }
                        }
                    }
                    
                if cycle_boo == 2 {
                check_count = 0
                    for k_index in 0...3 {
                        let temp_index = k_index
                        if abs(end_value[temp_index]) >= 0.85 * abs(mag[temp_index]) && 0 < abs(pre_1st_diff[temp_index]) && abs(pre_1st_diff[temp_index]) < 15 && 0 < abs(current_diff[temp_index]) && abs(current_diff[temp_index]) < abs(pre_1st_diff[temp_index]) && current_sign[temp_index] == start_sign[temp_index] * (-1) {
                            check_count += 1
                        }
                    }
                
                    if check_count >= 3 {
                        cycle_boo = 0
                        cycle_count += 1
                        current_peak = [0.0, 0, 0, 0]
                        current_marked_peak = [0.0, 0, 0, 0]
                        current_max_start_diff = 0
                        
                        for k_index in 0...3 {
                            let temp_index = k_index
                            end_sign[temp_index] = current_sign[temp_index]
                            end_time = current_time
                        }
                    }
                }
            }
                    
                    
        prev_sign = current_sign
        pre_3rd_value = pre_2nd_value
        pre_2nd_value = pre_1st_value
        pre_1st_value = current_values
        
        pre_3rd_diff = pre_2nd_diff
        pre_2nd_diff = pre_1st_diff
        pre_1st_diff = current_diff

        }
    }
}
