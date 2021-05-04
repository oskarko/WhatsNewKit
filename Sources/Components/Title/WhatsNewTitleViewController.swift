//
//  WhatsNewTitleViewController.swift
//  WhatsNewKit-iOS
//
//  Created by Sven Tiigi on 02.02.19.
//  Copyright © 2019 WhatsNewKit. All rights reserved.
//

import UIKit

// MARK: - WhatsNewTitleViewController

/// The WhatsNewTitleViewController
final class WhatsNewTitleViewController: UIViewController {

    // MARK: Properties

    /// The WhatsNew Title
    let titleText: String

    /// The Configuration
    var configuration: WhatsNewViewController.Configuration

    /// The title label
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = self.configuration.titleView.titleAlignment
        label.font = self.configuration.titleView.titleFont
        label.textColor = self.configuration.titleView.titleColor
        label.setDimensions(width: 275, height: 60)
        // Check if a secondary color is available
        if let secondaryColor = self.configuration.titleView.secondaryColor {
            // Set attributed text
            label.attributedText = .init(
                text: self.titleText,
                colorConfiguration: secondaryColor
            )
        } else {
            // No secondary color available simply set text
            label.text = self.titleText
        }
        return label
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Vega")
        imageView.setDimensions(width: 90, height: 90)

        return imageView
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4

        return stackView
    }()

    // MARK: Initializer

    /// Default initializer
    ///
    /// - Parameters:
    ///   - title: The Title
    ///   - configuration: The Configuration
    init(
        title: String,
        configuration: WhatsNewViewController.Configuration
    ) {
        // Set title
        self.titleText = title
        // Set configuration
        self.configuration = configuration
        // Super init
        super.init(nibName: nil, bundle: nil)
        // Set background color
        self.view.backgroundColor = self.configuration.backgroundColor
        // Hide View if an animation is available
        self.view.isHidden = self.configuration.titleView.animation != nil
    }

    /// Initializer with Coder always return nil
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    // MARK: View-Lifecycle

    /// Load View
    override func loadView() {
        self.view = self.stackView
    }

    /// View did appear
    ///
    /// - Parameter animated: If should be animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Disable isHidden
        self.view.isHidden = false
        // Perform animation if available
          self.configuration.titleView.animation?.rawValue(
              self.titleLabel,
              .init(
                  preferredDuration: 0.5,
                  preferredDelay: 0.2
              )
          )
          // Clear Animation
          self.configuration.titleView.animation = nil
    }

}

// MARK: - NSAttributedString+Init

private extension NSAttributedString {

    /// Convenience Initializer with Text and SecondaryColor Configuration
    ///
    /// - Parameters:
    ///   - text: The Text
    ///   - colorConfiguration: The SecondaryColor Configuration
    convenience init(
        text: String,
        colorConfiguration: WhatsNewViewController.TitleView.SecondaryColor
    ) {
        // Initialize NSMutableAttributedString with text
        let attributedString = NSMutableAttributedString(string: text)
        // Check if start index and length matches the string
        if text.dropFirst(colorConfiguration.startIndex).count >= colorConfiguration.length {
            // Add foreground color attribute
            attributedString.addAttributes(
                [.foregroundColor: colorConfiguration.color],
                range: .init(
                    location: colorConfiguration.startIndex,
                    length: colorConfiguration.length
                )
            )
        }
        // Init with AttributedString
        self.init(attributedString: attributedString)
    }

}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }

    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }

    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false

        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true

        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }

    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}
