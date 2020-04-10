//
//  ViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/20.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Alamofire

class HomeFeedViewController: UIViewController {
  // MARK: Property
  
  let service = ServiceManager.shared
  private var url = "http://13.125.217.34/post/list/"
  var nextPageURL: String?
  var posts = [Post]() {
    didSet {
      print("output")
      self.homeTableView.reloadData()
    }
  }
  var userUpdateTimes = [DateComponents]()
  var isFirstAlert = true
  
  // MARK: Views
  
  private lazy var customNaviBar = CutomNavigationBar().then {
    $0.backgroundColor = .white
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.layer.borderWidth = 0.3
    $0.selectedTownButton.setTitle(AuthorizationManager.shared.selectedTown?.dong ?? "unknown", for: .normal)
  }

  private lazy var homeTableView = UITableView().then {
     $0.sectionHeaderHeight = 4
     $0.separatorStyle = .none
     $0.rowHeight = 136
     $0.register(HomeFeedTableViewCell.self, forCellReuseIdentifier: "GoodsCell")
   }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    homeTableView.dataSource = self
    homeTableView.delegate = self
    self.view.backgroundColor = .white
    self.tabBarController?.tabBar.isHidden = false
    requestPostData(url)
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if AuthorizationManager.shared.userInfo == nil {
      if isFirstAlert {
      doFirstViewPresent()
      }
    }
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.navigationController?.navigationBar.isHidden = true
    self.view.addSubview(customNaviBar)
    self.view.addSubview(homeTableView)
    setupConstraints()
  }
  
  private func setupConstraints() {
    customNaviBar.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(98)
    }
    homeTableView.snp.makeConstraints {
      $0.top.equalTo(customNaviBar.snp.bottom)
      $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: Request PostData
  
  func requestPostData(_ url: String) {
    service.requestPostData(URL(string: url)!) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let postInfoData):
        self.posts += postInfoData.results
        self.nextPageURL = postInfoData.next
        self.calculateDifferentTime()
      case .failure(let error):
        print(error.localizedDescription)
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.homeTableView.refreshControl?.endRefreshing()
      }
    }
  }
  
  // MARK: Method
  
  func cellPostGoodsImage(_ cell: HomeFeedTableViewCell, _ indexPath: IndexPath) {
    if posts[indexPath.row].postImageSet.isEmpty {
      cell.goodsImageView.image = UIImage(named: "DaanggnMascot")
    } else {
      cell.goodsImageView.kf.setImage(with: URL(string: posts[indexPath.row].postImageSet[0].photo))
    }
  }
    
  func removeNotNeededTimeUnit(_ address: String, _ userUpdateTimes: DateComponents) -> String {
    var updateTime = String()
    if userUpdateTimes.day != 0 {
      if userUpdateTimes.day == 1 {
        updateTime += "\(address) • 어제"
      } else {
        updateTime += "\(address) • \(userUpdateTimes.day!)일 전"
      }
    } else if userUpdateTimes.hour != 0 {
      updateTime += "\(address) • \(userUpdateTimes.hour!)시간 전"
    } else if userUpdateTimes.minute != 0 {
      updateTime += "\(address) • \(userUpdateTimes.minute!)분 전"
    } else if userUpdateTimes.second != 0 {
      updateTime += "\(address) • \(userUpdateTimes.second!)초 전"
    }
    return updateTime
  }
  
  func calculateDifferentTime() {
    let currentTime = Date()
    for idx in 0..<posts.count {
      let tempTime = posts[idx].updated.replacingOccurrences(of: "T", with: " ").components(separatedBy: ".")[0]
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      let updatedTime: Date = dateFormatter.date(from: tempTime) ?? currentTime
      let calculrate = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
      guard let compareTime = calculrate?.components([.day, .hour, .minute, .second], from: updatedTime, to: currentTime, options: [])
      else { fatalError("castin error") }
      userUpdateTimes.append(compareTime)
    }
  }
  
  // MARK: Present
  
  private func doFirstViewPresent() {
    isFirstAlert = false
    let firstVC = FirstAlertViewController()
    firstVC.modalPresentationStyle = .overFullScreen
    present(firstVC, animated: false)
  }
  
  static func popoverPresent(_ delegateVC: UIViewController, _ controller: UIViewController, _ sender: UIView) -> UIViewController {
    controller.preferredContentSize = CGSize(width: 300, height: 150)
    controller.modalPresentationStyle = .popover
    guard let presentationController = controller.popoverPresentationController else { fatalError("popOverPresent casting error") }
    presentationController.delegate = delegateVC as? UIPopoverPresentationControllerDelegate
    presentationController.sourceRect = sender.bounds
    presentationController.sourceView = sender
    presentationController.permittedArrowDirections = .up
    return controller
  }
}

// MARK: TableView DataSource

extension HomeFeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionView = UIView().then {
      $0.backgroundColor = .clear
      $0.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 10)
    }
    return sectionView
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as? HomeFeedTableViewCell else { fatalError("faile type casting") }
    cellPostGoodsImage(cell, indexPath)
    cell.goodsName.text = "\(posts[indexPath.row].title)"
//    cell.goodsName.text = "Post ID \(posts[indexPath.row].postId)"
    cell.goodsPrice.text = "\(posts[indexPath.row].price)"
    cell.sellerLoctionAndTime.text = removeNotNeededTimeUnit(posts[indexPath.row].address, userUpdateTimes[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == (posts.count - 2) {
      guard let pageURL = nextPageURL else { return }
      requestPostData(pageURL)
      self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
    }
  }
  
  @objc private func loadTable() {
    self.homeTableView.reloadData()
  }
}

// MARK: TableView Delegate

extension HomeFeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("\(posts[indexPath.row].postId)번 id")
  }
}

// MARK: PopoverPresent Delegate

extension HomeFeedViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}

// MARK: NavigationBarButton Delegate

extension HomeFeedViewController: NavigationBarButtonDelegate {
  func navigationBarButton(_ naviBarButton: UIButton) {
    let popoverVC = PopoverViewController()
    switch naviBarButton {
    case customNaviBar.selectedTownButton:
      let popPresent = HomeFeedViewController.popoverPresent(self, popoverVC, naviBarButton)
      present(popPresent, animated: true)
    case customNaviBar.searchButton:
      print("검색하기")
    case customNaviBar.categoryFilterButton:
      print("카테고리선택")
    case customNaviBar.notificationButton:
      print("알림")
    default: break
    }
  }
}
