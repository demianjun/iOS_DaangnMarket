//
//  WelcomeView.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/08.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
 // MARK: - Protocol
protocol WelcomeViewInButtonsDelegate: class {
  func welcomeViewInButton(_ button: UIButton)
}

class WelcomeView: UIView {
  // MARK: UIViews
  
  weak var delegate: WelcomeViewInButtonsDelegate?
  
  private let mascotImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "DaanggnMascot")
  }
  private let startViewTopLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "가입하고 군자동"
    $0.contentMode = .center
    $0.font = .systemFont(ofSize: 20, weight: .bold)
  }
  private let startViewBottomLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "중고 상품을 구경하세요!"
    $0.contentMode = .center
    $0.font = .systemFont(ofSize: 20, weight: .bold)
  }
  private let signUpAndWatchButton = UIButton().then {
    $0.setTitle("가입하고 구경하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = UIColor(named: "symbolColor")
    $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    $0.layer.cornerRadius = 5.0
    $0.addTarget(self, action: #selector(didTapButtonsAction(_:)), for: .touchUpInside)
  }
  private let signUpButton = UIButton().then {
    $0.setTitle("로그인하기", for: .normal)
    $0.setTitleColor(UIColor(named: "symbolColor"), for: .normal)
    $0.backgroundColor = .white
    $0.layer.borderWidth = 2.0
    $0.layer.borderColor = UIColor(named: ColorReference.daangnMain.rawValue)?.cgColor
    $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    $0.layer.cornerRadius = 5.0
    $0.addTarget(self, action: #selector(didTapButtonsAction(_:)), for: .touchUpInside)
  }
  let lookAroundButton = UIButton().then {
    $0.setTitle("둘러보기", for: .normal)
    $0.setTitleColor(UIColor(named: ColorReference.subText.rawValue), for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15)
    $0.addTarget(self, action: #selector(didTapButtonsAction(_:)), for: .touchUpInside)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  private func setupUI() {
    let uiViews = [mascotImage, startViewTopLabel, startViewBottomLabel, signUpAndWatchButton, signUpButton, lookAroundButton]
    uiViews.forEach { self.addSubview($0) }
    setupConstrains()
  }
  
  private func setupConstrains() {
    lookAroundButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.trailing.equalToSuperview().offset(-16)
    }
    mascotImage.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(lookAroundButton.snp.bottom)
      $0.width.equalTo(UIScreen.main.bounds.width * 0.5)
      $0.height.equalTo(UIScreen.main.bounds.width * 0.5)
    }
    startViewTopLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(mascotImage.snp.bottom).offset(20)
    }
    startViewBottomLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(startViewTopLabel.snp.bottom).offset(3)
    }
    signUpAndWatchButton.snp.makeConstraints {
      $0.top.equalTo(startViewBottomLabel.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
    signUpButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(signUpAndWatchButton.snp.bottom).offset(15)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
  }
  
  @objc func didTapButtonsAction(_ button: UIButton) {
    self.delegate?.welcomeViewInButton(button)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

