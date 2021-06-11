//
//  InfoController.swift
//  hrvdemo
//
//  Created by Prasenjit on 27/5/2021.
//

import UIKit
import Charts

class InfoController: UIViewController, BleSingletonDelegate {
    
    @IBOutlet weak var hr_field: UITextField!
    @IBOutlet weak var temp_field: UITextField!
    @IBOutlet weak var device_name: UILabel!
    @IBOutlet weak var resp_rate_field: UITextField!
    
//    @IBOutlet weak var lineChartView: LineChartView!
//    var dataEntries = [ChartDataEntry]()
//    var xValue = 0
    
    var temp_disp: Double?
    var temp_in_fahrenheit: Bool?
    var temp_in_fah_ctrl_state: Bool = false // state of the segmented control button
    
    @IBOutlet weak var disconnect_button: UIButton!
    @IBAction func disconnect(_ sender: UIButton) {
        BleSingleton.shared.disconnect()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if BleSingleton.shared.numDevicesFound <= 0 {
            let alert = UIAlertController(title: "No Devices Found", message: "No HLT devices were found nearby. Please search again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  { action in
                    self.disconnect(self.disconnect_button)
                }))
            self.present(alert, animated: true, completion: nil)
        }
        UIApplication.shared.isIdleTimerDisabled = true
        
        device_name.text = BleSingleton.shared.activeDevice?.name
        
//        lineChartView.xAxis.drawGridLinesEnabled = false
//        lineChartView.xAxis.drawAxisLineEnabled = false
//        lineChartView.leftAxis.drawAxisLineEnabled = false
//        lineChartView.xAxis.drawLabelsEnabled = false
//        lineChartView.chartDescription?.enabled = false
//        lineChartView.rightAxis.enabled = false
//        lineChartView.drawBordersEnabled = false
//        lineChartView.legend.enabled = false
//        lineChartView.leftAxis.enabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        BleSingleton.shared.delegate = self

    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        let selection = sender.selectedSegmentIndex
        
        switch selection {
        case 0:
            temp_in_fah_ctrl_state = false
            break
        case 1:
            temp_in_fah_ctrl_state = true
            break
        default:
            break
        }
    }
    func hrDidChange(newVariableValue value: UInt8) {
        if value > 0 && value <= 200 {
            hr_field.text = String(value)
//            updateChart(hrValue: value)
        
        }
        else{
            hr_field.text=""
        }
    }
    
//    func updateChart(hrValue value: UInt8){
//        let chartValue = ChartDataEntry(x: Double(xValue), y: Double(value))
//        xValue+=1
//        dataEntries.append(chartValue)
//        let hrLine = LineChartDataSet(entries: dataEntries, label: "heart rate")
//        hrLine.setColor(.gray)
//        hrLine.lineWidth = 2
//        hrLine.drawCirclesEnabled = false
//        hrLine.drawValuesEnabled = false
//
//        let data = LineChartData()
//        data.addDataSet(hrLine)
//        lineChartView.data = data
//    }
    
    func tempDidChange(newVariableValue value: Double) {
        temp_disp = value
        if temp_in_fah_ctrl_state && !temp_in_fahrenheit!{
            // convert to Fahrenheit
            temp_disp = temp_disp! * 9.0 / 5.0 + 32.0
        }
        if !temp_in_fah_ctrl_state && temp_in_fahrenheit! {
            //convert to Celsius
            temp_disp = (temp_disp! - 32.0) * 5.0 / 9.0
        }
        if temp_disp! >= 0 && Int(hr_field.text ?? "") ?? 0 != 0{
            let text: String = String(format: "%.2f", temp_disp!) // change text in UI
//            print("temp: ", text)
            temp_field.text = String(text)
        }
        else{
            temp_field.text = ""
        }
        
    }
    func tempInFarhrenheitDidChange(newVariableValue value: Bool){
        temp_in_fahrenheit = value
    }
    func respRateDidChange(newVariableValue value: UInt8) {
        if Int(hr_field.text ?? "") ?? 0 != 0 {
            resp_rate_field.text = String(value)
        }
        else{
            resp_rate_field.text = ""
        }
    }
    
}
