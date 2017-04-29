struct Energy {
  Double duration = 0 // in terms of hours
  Double current = 0  // in terms of mA
  Double voltage = 0 // in terms of V  (electromotive force)
  var modified = false
}



class Battery {
  var maximum_charge_rate = 0  //these are in terms of maximum_capacity: ex: 2
  var maximum_discharge_rate = 0 //these are in terms of maximum_capacity
  var current_charge_rate = 0 //in terms of maximum_capacity
  var current_discharge_rate = 0 //in terms of maximum_capacity
  var charge_voltage = 0 // V
  var discharge_voltage = 0 // V
  var maximum_capacity = 0 //units are mAh
  var capacity = 0 //units are mAh
  var charger_efficiency = 0
  var first_capacity_update = true
  var last_charge_timestamp = 0



  func init(maximum_capacity: Int, 
            capacity: Int, maximum_charge_rate: Double, 
            maximum_discharge_rate: Double,
          charge_voltage: Double, discharge_voltage: Double,
          charger_efficiency: Double) {
     self.capacity = capacity
     self.maximum_capacity = maximum_capacity
     self.maximum_charge_rate = maximum_charge_rate
     self.maximum_discharge_rate = maximum_discharge_rate
     self.charge_voltage = charge_voltage
     self.discharge_voltage = discharge_voltage
     self.charger_efficiency = charger_efficiency
  }
  
    func GetCapacity(timestamp: Int) -> Double {
      if first_capacity_update == true {
        return capacity
      }
      var charge_duration = (timestamp - last_charge_timestamp) / 3600.0 
      return capacity + charge_duration * current_charge_rate
    }
    
  //charge is in
  func CanCharge(charge: Energy) -> Energy {
    Energy result
    result.duration = 0
    result.voltage = 0
    result.current = 0
    result.wasVerified = false
      //if we don't provide enough voltage, no charge
      if charge.voltage < self.charge_voltage {
        return result
      }
      //battery was already full anyway
      else if(capacity == maximum_capacity) {
        return result
      }  //else, decrease duration so that battery fills to max
      else if charge.current * charge.duration * charger_efficiency + capacity 
              >= maximum_capacity {
                result.voltage = charge.voltage
                result.current = charge.current
                result.duration = (maximum_capacity - capacity) / 
                               (charger_efficiency * charge.current)
                result.wasVerified = true
        return result
      }
      else { // get all the charge!
        charge.wasVerified = true
        return charge
      }
  
  func AttemptCharge(charge: Energy, timestamp: Int) -> Boolean {
       result = CanCharge(charge:charge)
       if result.duration == 0 {
         return false
       } 
       else {
         if first_capacity_update != true {
           var charge_duration = (timestamp - last_charge_timestamp) / 3600.0 
           capacity = capacity + charge_duration * current_charge_rate
         }
         first_capacity_update = false
         last_charge_timestamp = timestamp
         current_charge_rate = result.current / maximum_capacity

         return true
       }
  }

  func CanDischarge(discharge: Energy) -> Energy {
    Energy result
    result.current = 0
    result.duration = 0
    result.voltage = 0
    if capacity == 0 { //is empty already
      return result
    }
    else if discharge.voltage != discharge_voltage { //can't discharge higher than this
      result.voltage = discharge_voltage
      result.duration = discharge.duration
      result.current = discharge.current
    }

//make sure we have enough capacity to give 
    if discharge.voltage * discharge.current * discharge.duration > capacity {
      result.duration = capacity / (discharge.voltage * discharge.current)
    }

      
  }

}
