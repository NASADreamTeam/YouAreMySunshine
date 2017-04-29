struct Energy { // Default values match what we should be returning if the requested charge or discharge Energy is not possible.
	Double duration = 0 // in terms of hours
	Double current = 0  // in terms of mA
	Double voltage = 0 // in terms of V  (electromotive force)
	var modified = true
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
		updateCapacity(timestamp:timestamp)
		return self.capacity
	}

	//update the capacity based on current charge and discharge rates
	//and according to how much time has passed since the last time stamp
	//was set
	func UpdateCapacity(timestamp: Int) {
		if self.first_capacity_update == false {
			self.duration = (self.timestamp - self.last_charge_timestamp) / 3600.0
			self.capacity = self.capacity + self.current_charge_rate * self.duration - self.current_discharge_rate * self.duration
		}
		self.first_capacity_update = false
		self.last_charge_timestamp = self.timestamp
	}
	//charge is in
	func CanCharge(charge: Energy) -> Energy {
		Energy result
		//if we don't provide enough voltage, no charge
		if charge.voltage < self.charge_voltage {
			return result
		}
		//battery was already full anyway
		else if capacity == self.maximum_capacity {
			return result
		}  //else, decrease duration so that battery fills to max
		else if charge.current * charge.duration * charger_efficiency + capacity
				>= maximum_capacity {
			result.modified = true
			result.duration = (maximum_capacity - capacity) 
					(charger_efficiency * charge.current)
			
			result.voltage = charge.voltage
			result.current = charge.current
			return result
		}
		else { // get all the charge!
			return charge
		}
	}

	func AttemptCharge(charge: Energy, timestamp: Int) -> Boolean {
		Energy result = CanCharge(charge:charge)
		if result.modified == true {
			return false
		}
		else {
			UpdateCapacity(timestamp: timestamp)
			self.current_charge_rate = result.current / self.maximum_capacity
			return true
		}
	}

	func CanDischarge(discharge: Energy) -> Energy {
		Energy result
		if capacity == 0 { //is empty already
			return result
		}
		else if discharge.voltage != discharge_voltage { //can't discharge anything other than the battery's rated voltage (simplification)
			result.modified = true
			result.voltage = self.discharge_voltage //key change here, setting voltage to discharge_voltage of the battery

			result.current = discharge.current
			result.duration = discharge.duration
		}
		
		//discharge for as long as you can
		if discharge.current * discharge.duration > capacity { //can't give full amount
			result.modified = true
			result.duration = capacity / discharge.current

			result.current = discharge.current
			result.voltage = discharge.voltage
			return result
		}
		else { //can discharge for entire time
			return discharge
		}
	}

	func AttemptDischarge(timestamp: Int, discharge: Energy) -> Boolean {
		Energy result = CanDischarge(discharge:discharge)
		if result.modified == true {// then we can't discharge
			return false
		}
		UpdateCapacity(timestamp:timestamp)
		current_discharge_rate = result.current / self.maximum_capacity
		return true
	}
}
