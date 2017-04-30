//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"
print(str)

func test(){
    let url = "http://api.solcast.com.au/radiation/forecasts?longitude=-76.07&latitude=32.229&capacity=10&api_key=uos_eam6ozSnecTk5pTerz5ow-r916Uc&format=csv"
    //let url = "http://echolynx.com"
    guard let myURL = URL(string: url) else{
        print("error")
        return
    }
    do {
        let CSV = try String(contentsOf: myURL, encoding: .ascii)
        let lines = CSV.components(separatedBy: "\n")
        var sum = 0.0
        var first = 0
        for index in stride(from: 1, through:48, by: 1) {
            let element = lines[index]
            let values = element.components(separatedBy: ",")
            print(values)
            sum = sum + Double(values[0])!
            first = first + 1
        }
        sum = sum * 0.5
        print(sum)
        print(first)
        //print(CSV)
    } catch let error {
        print("Error \(error)")
    }
}


test()
