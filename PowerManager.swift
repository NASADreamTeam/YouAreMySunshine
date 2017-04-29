
class PowerManager {
     // get location
     // computer average monthly insolation values
     // 
     // get cloud coverage estimate
     // get dust coverage estimate
     // get expected values from history
     // estimate overall solar power for the day
     // for the list of appliances in our database
     var lat = 32.229
     var lon = -76.0704
     let url = "https://power.larc.nasa.gov/cgi-bin/agro.cgi?email=&step=1&lat=\(lat)&lon=\(lon)&ms=1&ds=1&ys=2017&me=12&de=31&ye=2017&submit=Submit"
     guard let myURL = URL(string: url) else {
         print("Error: \(url) doesn't seem to be a valid URL")
     }
     do {
        let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
        print("HTML : \(myHTMLString)")
      } catch let error {
          print("Error: \(error)")
    }   
}

func PowerConsumption(wattage: Double, time: Double) {
   return wattage * time;
}

func UpperBound(wattage: Double, capacity_remaining: Double) -> Double  {
    return capacity_remaining /  wattage 
}
