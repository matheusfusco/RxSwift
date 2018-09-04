//: Please build the scheme 'RxSwiftPlayground' first
import RxSwift


example(of: "creating observables") {
  let mostPopular: Observable<String> = Observable<String>.just(episodeV)
  let originalTrilogy = Observable.of(episodeIV, episodeV, episodeVI)
  let prequelTrilogy = Observable.of([episodeI, episodeII, episodeIII])
  let sequelTrilogy = Observable.from([episodeVII, episodeVIII, episodeIX])
}

example(of: "subscribe") {
  let observable = Observable.of(episodeIV, episodeV, episodeVI)
  //  observable.subscribe { event in
  ////    print(event)
  //    print(event.element ?? event)
  //  }
  
  observable.subscribe(onNext: { element in
    print(element)
  })
  
}

example(of: "empty") {
  let observable = Observable<Void>.empty()
  
  observable
    .subscribe(onNext: { element in
      print(element)
    },
               onCompleted: {
                print("Completed")
    })
}

example(of: "never") {
  let observable = Observable<Any>.never()
  observable
    .subscribe(onNext: { element in
      print(element)
    },
               onCompleted: {
                print("Completed")
    })
}


example(of: "dispose") {
  let observable = Observable.of(episodeV, episodeIV, episodeVI)
  let subscription = observable
    .subscribe({ event in
      print(event)
    })
  
  subscription.dispose()
}

example(of: "DisposeBag") {
  let disposeBag = DisposeBag()
  Observable.of(episodeVII, episodeI, rogueOne)
    .subscribe({
      print($0)
    })
    .disposed(by: disposeBag)
}

example(of: "create") {
  enum Droid: Error {
    case OU812
  }
  let disposeBag = DisposeBag()
  
  Observable<String>.create { observer in
    
    observer.onNext("R2-D2")
    //    observer.onError(Droid.OU812)
    observer.onNext("C-3PO")
    observer.onNext("K-2SO")
    observer.onCompleted()
    return Disposables.create()
    }
    .subscribe(onNext: { print($0) },
               onError: { print("Error: ", $0) },
               onCompleted: { print("Completed") },
               onDisposed: { print("Disposed") }
    ).disposed(by: disposeBag)
}


example(of: "Single") {
  let disposeBag = DisposeBag()
  
  enum FileReadError: Error {
    case fileNotFound, unreadable, encodingFailed
  }
  
  func loadText(from filename: String) -> Single<String> {
    return Single.create { single in
      let disposable = Disposables.create()
      
      guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
        single(.error(FileReadError.fileNotFound))
        return disposable
      }
      
      guard let data = FileManager.default.contents(atPath: path) else {
        single(.error(FileReadError.unreadable))
        return disposable
      }
      
      guard let contents = String(data: data, encoding: .utf8) else {
        single(.error(FileReadError.encodingFailed))
        return disposable
      }
      
      single(.success(contents))
      
      return disposable
    }
  }
  
  loadText(from: "ANewHope")
    .subscribe {
      switch $0 {
      case .success (let string):
        print(string)
      case .error (let error):
        print(error)
      }
    }
    .disposed(by: disposeBag)
}



example(of: "Never - Do") {
  let observable = Observable<Any>.never()
  let disposeBag = DisposeBag()
  
  observable
    .do(onNext: { element in
      print(element)
    },  onError: { error in
      print(error)
    }, onCompleted: {
      print("Do: Completed")
    }, onSubscribe: {
      print("Do:  Subscribe")
    }, onSubscribed: {
      print("Do: Subscribed")
    }, onDispose: {
      print("Do: Dispose")
    })
    .subscribe(onNext: { element in
      print(element)
    }, onError: { error in
      print(error)
    }, onCompleted: {
      print("Completed")
    }, onDisposed: {
      print("Disposed")
    })
    .disposed(by: disposeBag)
}

example(of: "PublishSubject") {
  let quotes = PublishSubject<String>()
  quotes.onNext(itsNotMyFault)
  
  let subscriptionOne = quotes
    .subscribe {
      print(label: "1)", event: $0)
  }
  quotes.on(.next(doOrDoNot))
  
  let subscriptionTwo = quotes
    .subscribe {
      print(label: "2)", event: $0)
  }
  
  quotes.onNext(lackOfFaith)
  
  subscriptionOne.dispose()
  
  quotes.onNext(eyesCanDeceive)
  
  quotes.onCompleted()
  
  let subscriptionThree = quotes
    .subscribe {
      print("3)", $0)
  }
  
  quotes.onNext(stayOnTarget)
  
  subscriptionOne.dispose()
  subscriptionTwo.dispose()
  subscriptionThree.dispose()
  
}

example(of: "BehaviorSubject") {
  let disposeBag = DisposeBag()
  
  let quotes = BehaviorSubject(value: iAmYourFather)
  
  let subscriptionOne = quotes
    .subscribe {
      print(label: "1)", event: $0)
  }
  quotes.onError(Quote.neverSaidThat)
  
  let subscriptionTwo = quotes
    .subscribe {
      print(label: "2)", event: $0)
    }
    .disposed(by: disposeBag)
}

example(of: "ReplaySubject") {
  let disposeBag = DisposeBag()
  
  let subject = ReplaySubject<String>.create(bufferSize: 2)
  
  subject.onNext(useTheForce)
  
  subject
    .subscribe {
      print(label: "1)", event: $0)
    }
    .disposed(by: disposeBag)
  
  subject.onNext(theForceIsStrong)
  
  subject
    .subscribe {
      print(label: "2)", event: $0)
    }
    .disposed(by: disposeBag)
}


example(of: "Variable") {
  let disposeBag = DisposeBag()
  
  let variable = Variable(iAmYourFather)
  
  print(variable.value)
  
  variable.asObservable()
    .subscribe {
      print(label: "1)", event: $0)
    }
    .disposed(by: disposeBag)
  
  variable.value = mayThe4thBeWithYou
  
  //não é possivel - erros não podem ser atribuidos a variables
  //  variable.value = MyError.anError
  //  variable.asObservable().onError(MyError.anError)
  //  variable.asObservable().onCompleted()
}

example(of: "ignoreElements") {
  let disposeBag = DisposeBag()
  
  let cannedProjects = PublishSubject<String>()
  
  cannedProjects
    .ignoreElements()
    .subscribe {
      print($0)
    }
    .disposed(by: disposeBag)
  
  cannedProjects.onNext(landOfDroids)
  cannedProjects.onNext(wookieWorld)
  cannedProjects.onNext(detours)
  
  cannedProjects.onCompleted()
}

example(of: "elementAt") {
  let disposeBag = DisposeBag()
  
  let quotes = PublishSubject<String>()
  
  quotes
    .elementAt(2)
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: disposeBag)
  
  quotes.onNext(mayTheOdds)
  quotes.onNext(liveLongAndProsper)
  quotes.onNext(mayTheForce)
}

example(of: "filter") {
  let disposeBag = DisposeBag()
  
  Observable.from(tomatometerRatings)
    .filter{ movie in
      movie.rating >= 90
    }
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: disposeBag)
  
}

example(of: "skipWhile") {
  let disposeBag = DisposeBag()
  
  Observable.from(tomatometerRatings)
    .skipWhile { movie in
      movie.rating < 90
    }
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: disposeBag)
}


example(of: "skipUntil") {
  let disposeBag = DisposeBag()
  
  let subject = PublishSubject<(title: String, rating: Int)>()
  let trigger = PublishSubject<Void>()
  
  subject
    .skipUntil(trigger)
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: disposeBag)
  
  subject.onNext(_episodeI)
  subject.onNext(_episodeII)
  subject.onNext(_episodeIII)
  trigger.onNext(())
  subject.onNext(_episodeIV)
}


example(of: "distinctUntilChanged") {
  let disposeBag = DisposeBag()
  
  Observable<Droid>.of(.R2D2, .C3PO, .C3PO, .R2D2)
    .distinctUntilChanged()
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: disposeBag)
}


example(of: "map") {
  let disposeBag = DisposeBag()
  Observable.from(episodes)
    .map {
      var components = $0.components(separatedBy: " ")
      let number = NSNumber(value: try! components[1].romanNumeralIntValue())
      let numberString = String(describing: number)
      components[1] = numberString
      
      return components.joined(separator: " ")
    }
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: disposeBag)
}

example(of: "flatmap") {
  let disposeBag = DisposeBag()
  
  let ryan = Jedi(rank: BehaviorSubject(value: .youngling))
  let charlotte = Jedi(rank: BehaviorSubject(value: .youngling))
  
  let student = PublishSubject<Jedi>()
  
  student
    .flatMap {
      $0.rank
    }
    .subscribe(onNext: {
      print($0.rawValue)
    })
    .disposed(by: disposeBag)
  
  student.onNext(ryan)
  ryan.rank.onNext(.padawan)
  student.onNext(charlotte)
  ryan.rank.onNext(.jediKnight)
  charlotte.rank.onNext(.jediMaster)
}

example(of: "flatmap latest") {
  let disposeBag = DisposeBag()
  
  let ryan = Jedi(rank: BehaviorSubject(value: .youngling))
  let charlotte = Jedi(rank: BehaviorSubject(value: .youngling))
  
  let student = PublishSubject<Jedi>()
  
  student
    .flatMapLatest {
      $0.rank
    }
    .subscribe(onNext: {
      print($0.rawValue)
    })
    .disposed(by: disposeBag)
  
  student.onNext(ryan)
  ryan.rank.onNext(.padawan)
  student.onNext(charlotte)
  ryan.rank.onNext(.jediKnight)
  charlotte.rank.onNext(.jediMaster)
}


example(of: "startWith") {
  let disposeBag = DisposeBag()
  let prequelEpisodes = Observable.of(episodeI, episodeII, episodeIII)
  let flashback = prequelEpisodes.startWith(episodeIV, episodeV)
  
  flashback.subscribe(onNext: { episode in
    print(episode)
  })
    .disposed(by: disposeBag)
}

example(of: "concat") {
  let disposeBag = DisposeBag()
  
  let prequelTrilogy = Observable.of(episodeI, episodeII, episodeIII)
  let originalTrilogy = Observable.of(episodeIV, episodeV, episodeVI)
  
  prequelTrilogy.concat(originalTrilogy)
    .subscribe(onNext: { episode in
      print(episode)
    })
    .disposed(by: disposeBag)
}

example(of: "merge") {
  let disposeBag = DisposeBag()
  
  let filmTrilogies = PublishSubject<String>()
  let standAloneFilms = PublishSubject<String>()
  let storyOrder = Observable.of(filmTrilogies, standAloneFilms)
  
  storyOrder.asObservable()
    .merge()
    .subscribe(onNext: { film in
      print(film)
    })
    .disposed(by: disposeBag)
  
  filmTrilogies.onNext(__episodeI)
  filmTrilogies.onNext(__episodeII)
  
  standAloneFilms.onNext(theCloneWars)
  
  filmTrilogies.onNext(__episodeIII)
  standAloneFilms.onNext(solo)
  standAloneFilms.onNext(rogueOne)
  
  filmTrilogies.onNext(__episodeIV)
  filmTrilogies.onNext(__episodeV)
  filmTrilogies.onNext(__episodeVI)
}


example(of: "combineLatest") {
  let disposeBag = DisposeBag()
  
  let characters = Observable.of(luke, hanSolo, leia, chewbacca)
  let primaryWeapons = Observable.of(lightsaber, dl44, defender, bowcaster)
  
  Observable.combineLatest(characters, primaryWeapons) { character, weapon in
    "\(character): \(weapon)"
    }
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: disposeBag)
}


example(of: "zip") {
  let disposeBag = DisposeBag()
  
  let characters = Observable.of(luke, hanSolo, leia, chewbacca)
  let primaryWeapons = Observable.of(lightsaber, dl44, defender, bowcaster)
  
  Observable.zip(characters, primaryWeapons) { character, weapon in
    "\(character): \(weapon)"
    }
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: disposeBag)
}


example(of: "amb") {
  let disposeBag = DisposeBag()
  
  let prequelEpisodes = PublishSubject<String>()
  let originalEpisodes = PublishSubject<String>()
  
  prequelEpisodes.amb(originalEpisodes)
    .subscribe(onNext: {
      print($0)
    })
    .disposed(by: disposeBag)
  
  originalEpisodes.onNext(__episodeIV)
  
  prequelEpisodes.onNext(__episodeI)
  prequelEpisodes.onNext(__episodeII)
  
  originalEpisodes.onNext(__episodeV)
}


example(of: "reduce") {
  let disposeBag = DisposeBag()
  
  Observable.from(runtimes.values)
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
      print(stringFrom($0))
    })
    .disposed(by: disposeBag)
}


example(of: "scan") {
  let disposeBag = DisposeBag()
  
  Observable.from(runtimes.values)
    .scan(0, accumulator: +)
    .subscribe(onNext: {
      print(stringFrom($0))
    })
    .disposed(by: disposeBag)
}


example(of: "challenge: zip + scan") {
  let disposeBag = DisposeBag()
  
  let runTimeKeyValues = Observable.from(runtimes)
  
  let scanTotal = runTimeKeyValues.scan(0) { total, movie in
    total + movie.value
  }
  
  let results = Observable.zip(runTimeKeyValues, scanTotal) {
    ($0.key, $0.value, $1)
  }
  
  results.subscribe(onNext: {
    print("Filme: \($0) - Duração do filme: \(stringFrom($1)) - Tempo total da maratona: \(stringFrom($2))")
  })
    .disposed(by: disposeBag)
}
