import Foundation
func test(){
	let url = "http://api.solcast.com.au/radiation/forecasts?longitude=-76.07&latitude=32.229&capacity=1000&api_key=uos_eam6ozSnecTk5pTerz5ow-r916Uc"
	//let url = "http://echolynx.com"
	guard let myURL = URL(string: url) else{
		print("error")
		return
	}
	do {
		let CSV = try String(contentsOf: myURL, encoding: .ascii)
		print(CSV)
	} catch let error {
		print("Error \(error)")
	}
}
test()
