import Foundation

extension Date {
  var day: Date { // 날짜를 day로
    let component = Calendar.current.dateComponents([.year, .month, .day], from: self)
    return Calendar.current.date(from: component) ?? Date()
  }
}

extension Calendar {
  // to - from = N-day
  func getDateGap(from: Date, to: Date) -> Int {
    let fromDateOnly = from.day
    let toDateOnly = to.day
    return self.dateComponents([.day], from: fromDateOnly, to: toDateOnly).day ?? 0
  }
}
