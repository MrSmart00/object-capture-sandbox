//
//  CaptureView.swift
//
//
//  Created by 日野森寛也 on 2024/04/09.
//

import SwiftUI
import RealityKit
import Common

public struct CaptureView: View {
    @State var model: CapturingModel
    
    public init(model: CapturingModel) {
        self.model = model
    }

    public var body: some View {
        ZStack {
            ObjectCaptureView(session: model.objectCaptureSession)
                .ignoresSafeArea()
                .id(model.objectCaptureSession.id)
                .overlay {
                    if model.isShowOverlay {
                        switch model.state {
                        case .start:
                            ReadyingOverlayView { await model.startDetection() }
                        case .detecting:
                            DetectingOverlayView { await model.startCapture() } cancelHandler: { await model.cancel() }
                        case .capturing:
                            CapturingOverlayView { await model.cancel() }
                        case .completad:
                            CompletedOverlayView { await model.cancel() }
                        default:
                            EmptyView()
                        }
                    }
                }
        }
        .alert(isPresented: .init(get: {
            model.state == .failed
        }, set: { _ in }), content: {
            Alert(
                title: .init("Something Error!!!!"),
                message: .init("please re-install the app."),
                dismissButton: .destructive(.init("OK"))
            )
        })
    }
}
