//
//  ChartView.swift
//  CoinTestResenchuk
//
//  Created by Roman R. on 3/18/22.
//

import UIKit

class ChartView: UIView {
    
    var values = [Double]()
    
    override func draw(_ rect: CGRect) {
        guard values.count > 0 else {
            return
        }
        let offsetY = 25.0
        let rectHeight = rect.height - offsetY*2
        let line = UIBezierPath()
        line.move(to: CGPoint(x: -1, y:rectHeight))
        let min = values.min()!
        let max = values.max()!
        var xValue = 0.0
        for value in values {
            let percentage = ((value - min) * 100) / (max - min)
            let yValue = rectHeight-(rectHeight*percentage/100) + offsetY
            // Line
            line.addLine(to: CGPoint(x: xValue, y: yValue))
            // Label
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
                         NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let string = String(value).toUSCurrencyFormat()
            
            if value == max {
                string.draw(with: CGRect(x: xValue-50, y: yValue-offsetY, width: 100, height: offsetY),
                            options: .usesLineFragmentOrigin,
                            attributes: attrs,
                            context: nil)
            }
            else if value == min {
                string.draw(with: CGRect(x: xValue-50, y: yValue+offsetY/4, width: 100, height: offsetY),
                            options: .usesLineFragmentOrigin,
                            attributes: attrs,
                            context: nil)
            }
            //
            xValue+=rect.width/Double(values.count-1)
        }
        line.lineWidth = 1
        UIColor.black.set()
        line.stroke()
        
        
    }
}
