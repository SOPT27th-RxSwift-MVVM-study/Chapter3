//
//  ViewController.swift
//  RxSwift_1
//
//  Created by 이윤진 on 2020/11/07.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pubSub()
        //behavSub()
        //replaySub()
        behavRelay()
    }
    
    
}

extension ViewController {
    
    // MARK: - PublishSubject
    func pubSub(){
        //        let publishSubject = PublishSubject<String>()
        //        publishSubject.debug().subscribe{print("first subscribe:\($0)")}.disposed(by: DisposeBag())
        //        publishSubject.on(.next("1")) // first subscribe : next(1)
        //        publishSubject.on(.next("2")) // first subscribe : next(2)
        //        publishSubject.debug().subscribe{print("second subscribe:\($0)")}.disposed(by: DisposeBag())
        //        publishSubject.on(.next("3")) // first subscribe : next(3), second subscribe : next(3)
        //        publishSubject.on(.completed)
        // completed 이후 dispose까지 완료, 종료
        let subject = PublishSubject<Int>()
        
        let subjectOne = subject
            .subscribe(onNext: { (num) in
                print("subjectOne :",num)
            })
        
        subject.onNext(1)
        subject.onNext(2)
        
        let subjectTwo = subject
            .subscribe(onNext: { (num) in
                print("subjectTwo :", num)
            }) // subscribe를 시작한 순간에는 아무것도 받지 않지만 데이터가 새로 발생하면 방출된다
        
        subject.onNext(3)
        subject.onNext(4)
        subject.onNext(5)
        
    }
    
    // MARK: - BehaviorSubject
    // 최근값 보여주는데 유용하게 쓰임
    // 최초 생성 시 설정한 값이 첫 번째 subscribe 이후 전달
    // PublishSubject와 다르게 직전의 값을 받는다
    // 따라서 최신의 값을 emit하므로 무조건 초기값 설정이 필요하다
    // 초기값이 없다면 PublishSubject 써야함
    func behavSub(){
        
         // 예시1
         let behaviorSubject = BehaviorSubject<String>(value: "tom")
         behaviorSubject.debug("behavior subject log1:").subscribe{print($0)}.disposed(by: DisposeBag())
         behaviorSubject.onNext("jack")
         behaviorSubject.onNext("wade") // 마지막 값이 wade가 전달된다
         behaviorSubject.debug("behavior subject log2:").subscribe{print($0)}.disposed(by: DisposeBag())
       
        //예시2
//        let subject = PublishSubject<Int>()
//
//        let subjectOne = subject
//            .subscribe(onNext: { (num) in
//                print("subjectOne :",num)
//            }, onError: { (error) in
//                print("subjectOne Erorr: ", error)
//            }, onCompleted: {
//                print("subjectOne onCompleted")
//            })
//
//        subject.onNext(1)
//        subject.onNext(2)
//
//        subject.onCompleted() // 추가
//
//        let subjectTwo = subject
//            .subscribe(onNext: { (num) in
//                print("subjectTwo :",num)
//            }, onError: { (error) in
//                print("subjectTwo Erorr: ", error)
//            }, onCompleted: {
//                print("subjectTwo onCompleted")
//            })
//
//        subject.onNext(3)
//        subject.onNext(4)
//        subject.onNext(5)
    }
    
    // MARK: - ReplaySubject
    func replaySub(){
        // 초기 값 없음
        // 처음 ReplaySubject 생성 시 특정크기만큼(buffersize지정) 일시적으로 캐시하거나 버퍼
        // 버퍼사이즈만큼의 최근 값 보여주므로 최신값 && 개수지정으로 보여주는 경우에 유용하게 사용 가능
        let subject = ReplaySubject<Int>.create(bufferSize: 3) // 버퍼사이즈3
        
        subject.onNext(1)
        subject.onNext(2)
        subject.onNext(3)
        subject.onNext(4)
        subject.onNext(5)
        subject.onNext(6)
        
        let subjectOne = subject.subscribe(onNext: { (value) in
            print("subjectOne :",value)
        })
        // 버퍼 사이즈 만큼의 최근 데이터 값들을 보여주게 된다
        // 따라서 4,5,6,7,8,9로 출력
        subject.onNext(7)
        subject.onNext(8)
        subject.onNext(9)
        
    }
    // MARK: - BehaviorRelay
    // Variables(deprecated).대신해서 BehaviorRelay 사용한다고 함
    // BehaviorSubject를 wrapping해서 가지고 있는 객체, .value를 사용해 현재의 값을 꺼낸다(r 전용)
    // Subject,Relay 객체와의 차이가 뭐길래?
    // 1. Subject는 .completed/.error 이벤트가 발생하면 subsribe 종료된다. 하지만 Relay는 dispose 되기 전까지 계속 작동된다는 특징
    // 2. accept()를 활용하여 새로운 이벤트를 전달
    // 3. subscribe 대신 asObservable을 사용한다
    
    
    func behavRelay(){
        
        let behaviorRelay = BehaviorRelay(value: 5)
        behaviorRelay.accept(6)
        behaviorRelay.subscribe { print($0) }
        behaviorRelay.accept(4)
        print(behaviorRelay.value) // 제일 최신의 값 보여줌
        // variables은 Observable의 가장 최신값 보여주는 역할을 담당함
    }
}
