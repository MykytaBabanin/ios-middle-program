//
//  ViewController.swift
//  MOBT-9-Concurrency
//
//  Created by Mykyta Babanin on 30.05.2022.
//

import UIKit

class ViewController: UIViewController {
    private let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
    private let readerWriter = ReaderWriter <Int> (data: [1])
    private let semaphore = DispatchSemaphore(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insert()
    }
    
    func insert() {
        for i in 1...100 {
            concurrentQueue.async {
                if i % 10 == 0 {
                    self.readerWriter.insert(i + 100)
                }
                self.semaphore.wait()
                self.readerWriter.getData()
                if i % 20 == 0 {
                    self.readerWriter.insert(i + 5)
                }
                self.semaphore.signal()
            }
        }
    }
}

class ReaderWriter <T> {
    private var data: [T]
    private let queue = DispatchQueue(label: "concurrent", attributes: .concurrent)
    
    func getData() {
        queue.async {
            print("read into \(String(describing: self.data.last))")
        }
    }
    
    func insert(_ value: T) {
        queue.async(flags: .barrier) { [unowned self] in
            print("Insert \(value)")
            self.data.append(value)
            print("Insert \(value) completed")
        }
    }
    
    init(data: [T]) {
        self.data = data
    }
}

