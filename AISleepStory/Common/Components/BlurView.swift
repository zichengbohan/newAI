//
//  BlurView.swift
//  AISleepStory
//
//  Created by xbm on 7/6/24.
//

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
	var style: UIBlurEffect.Style

		func makeUIView(context: Context) -> UIVisualEffectView {
			return UIVisualEffectView(effect: UIBlurEffect(style: style))
		}

		func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
			uiView.effect = UIBlurEffect(style: style)
		}
}

#Preview {
	BlurView(style: .regular)
}
