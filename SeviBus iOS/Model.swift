//
// Created by Rafa Vázquez on 09/06/2017.
// Copyright (c) 2017 Rafa Vázquez. All rights reserved.
//

import Foundation

class ArrivalTimes {

    let busLineName: String
    let busStopNumber: Int

    let nextBus: Bus
    let secondBus: Bus

    init(busLineName: String, busStopNumber: Int, nextBus: Bus, secondBus: Bus) {
        self.busLineName = busLineName
        self.nextBus = nextBus
        self.secondBus = secondBus
        self.busStopNumber = busStopNumber
    }


}


class Bus {

    let time: Int
    let distance: Int

    init(time: Int, distance: Int) {
        self.time = time;
        self.distance = distance;
    }

    init(json: [AnyHashable: Any]){
        self.time = json["timeInMinutes"] as! Int
        self.distance = json["distanceInMeters"] as! Int
    }

}

