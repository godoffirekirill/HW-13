//
//  ViewController.swift
//  HW-13-2
//
//  Created by Кирилл Курочкин on 30.05.2024.
//

import UIKit

class ViewController: UIViewController {
    private var circles: [CirclePinch] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let addCircleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addCircleTapHandler(_:)))
        view.addGestureRecognizer(addCircleTapGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        view.addGestureRecognizer(panGestureRecognizer)

        addCircleTapGestureRecognizer.delegate = self
        panGestureRecognizer.delegate = self
    }

    @objc func addCircleTapHandler(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let point = sender.location(in: view)
            if canAddCircle(at: point) {
                addNewCircle(at: point)
            }
        }
    }

    private var trackedCircleView: CirclePinch?
    private var originalCirclePosition: CGPoint?

    @objc func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            guard let circleView = findCircle(at: sender.location(in: view)) else { break }
            trackedCircleView = circleView
            circleView.alpha = 0.5
            originalCirclePosition = circleView.currentPosition
        case .changed:
            let translation = sender.translation(in: view)
            guard let trackedCircleView = trackedCircleView else { break }
            let newPosition = CGPoint(
                x: originalCirclePosition!.x + translation.x,
                y: originalCirclePosition!.y + translation.y
            )
            trackedCircleView.currentPosition = newPosition
        case .cancelled, .ended, .failed:
            if let trackedCircleView = trackedCircleView {
                trackedCircleView.alpha = 1.0
                if sender.state == .ended {
                    let newPosition = trackedCircleView.currentPosition
                    if let idx = circles.firstIndex(of: trackedCircleView) {
                        circles[idx].currentPosition = newPosition
                    }
                }
            }
            trackedCircleView = nil
            originalCirclePosition = nil
        default:
            break
        }
    }

    private func findCircle(at point: CGPoint) -> CirclePinch? {
        return circles.first { $0.frame.contains(point) }
    }

    private func canAddCircle(at point: CGPoint) -> Bool {
        let newCircleFrame = CGRect(x: point.x - 50, y: point.y - 50, width: 100, height: 100)
        for circle in circles {
            if circle.frame.intersects(newCircleFrame) {
                return false
            }
        }
        return true
    }

    private func addNewCircle(at point: CGPoint) {
        let initialSize: CGFloat = 100
        let circlePinch = CirclePinch(initialSize: initialSize)
        view.addSubview(circlePinch)

        NSLayoutConstraint.deactivate([circlePinch.centerXConstraint, circlePinch.centerYConstraint])

        circlePinch.centerXConstraint = circlePinch.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: point.x)
        circlePinch.centerYConstraint = circlePinch.centerYAnchor.constraint(equalTo: view.topAnchor, constant: point.y)

        NSLayoutConstraint.activate([
            circlePinch.centerXConstraint,
            circlePinch.centerYConstraint
        ])

        circlePinch.currentPosition = point
        circles.append(circlePinch)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

