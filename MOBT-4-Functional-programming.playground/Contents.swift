import Foundation

//1. Given an array of integers, return a new array with each value doubled.
//Example: [1, 2, 3] --> [2, 4, 6]
func doubled(arr: [Int]) -> [Int] {
    return arr.map { $0 * 2 }
}

doubled(arr: [1,2,3])

//2. Write a program that finds the summation of every number from 1 to num. The number will always be a positive integer greater than 0.
//Example: summation(8) -> 36
func summation(num: Int) -> Int {
    return (num * (num+1)) / 2
}

summation(num: 8)

//3.Up to N (and including), this function should return the sum of all multiples of 3 and 5.
//Examples: findSum(5) --> 8 (3 + 5)
//findSum(10) --> 33 (3 + 5 + 6 + 9 + 10)
func findSum(num: Int) -> Int {
    return [Int](0...num).map{$0}.filter{$0 % 3 == 0 || $0 % 5 == 0}.sum()
}

findSum(num: 10)

//4.You get the start number and the end number of a range and should return the count of all numbers except numbers with a 5 in it. The start and the end number are both inclusive! The result may contain fives. The start number will always be smaller than the end number. Both numbers can be also negative!
//Examples: 1,9 -> 1,2,3,4,6,7,8,9 -> Result 8
//4,17 -> 4,6,7,8,9,10,11,12,13,14,16,17 -> Result 12
func dontGiveMeFive(_ start: Int, _ end: Int) -> Int {
    return [Int](start...end).map(String.init).filter{!$0.contains("5")}.count
}

dontGiveMeFive(4, 17)


extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +)}
}
