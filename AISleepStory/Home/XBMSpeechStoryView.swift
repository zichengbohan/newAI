//
//  ContentView.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/9.
//

import SwiftUI
import AVFoundation
import Combine
import StoreKit

struct XBMSpeechStoryView: View {
	@ObservedObject var viewModel: XBMSynthViewModel
	@State private var selectedVoice: AVSpeechSynthesisVoice
	init(viewModel: XBMSynthViewModel = XBMSynthViewModel(), selectedVoice: AVSpeechSynthesisVoice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.en-US.Samantha")!) {
		self.viewModel = viewModel
		self.selectedVoice = selectedVoice
	}
	var body: some View {
		@State var isListVisible = false
		
		NavigationView {
			
			VStack {
				GeometryReader { geometry in
					ZStack {
						Image("home_bg") // 替换为您的图像名称
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: geometry.size.width, height: geometry.size.height)
							.clipped()
						
						VStack {
							SpeakWordsList(viewModel: viewModel)
							if !viewModel.isSpeaking {
								NavigationLink(destination: SelectSpeakerView(selectedVoice: $selectedVoice)) {
									Text("选择喜欢的声音")
										.padding()
										.background(Color.blue)
										.foregroundColor(.white)
										.cornerRadius(10)
										.padding(.bottom, 20)
									
								}
							}
							if viewModel.speechTexts.count > 0 && viewModel.speakLocation == viewModel.speechTexts.count {
								Button {
									viewModel.reStartSpeak(voice: selectedVoice)
								} label: {
									Text("重听")
										.foregroundColor(.white)
										.font(.headline)
										.padding()
										.background(.blue)
										.cornerRadius(8)
								}
							}
							SpeakButton(viewModel: viewModel, selectedVoice: $selectedVoice) // 设置按钮与底部距离为 20 点
						}
					}
				}
				.edgesIgnoringSafeArea(.all)
			}
			.alert(isPresented: $viewModel.showUpdate, content: {
				Alert(
					title: Text("提示"),
					message: Text(viewModel.errorMessage),
					primaryButton: .default(Text("OK")) {
						// 处理点击“OK”按钮的操作
						let appStoreURLString = "https://apps.apple.com/app/6467557832"
						
						if let appStoreURL = URL(string: appStoreURLString) {
							UIApplication.shared.open(appStoreURL, options: [:]) { success in
								if success {
									//                                    print("Successfully opened App Store")
								} else {
									//                                    print("Failed to open App Store")
								}
							}
						}
					},
					secondaryButton: .cancel()
				)
			})
			
		}
	}
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		XBMSpeechStoryView()
    }
}

struct SpeakWordsList: View {
    @ObservedObject var viewModel: XBMSynthViewModel;

    var body: some View {
        ScrollViewReader { scrollView in
            List(viewModel.speechTexts, id: \.self) { (speechText) in
                Text(speechText.content)
					.foregroundColor((viewModel.willSpeakItem.content == speechText.content) ? .purple : .white)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .id(viewModel.speechTexts.firstIndex(of: speechText))
					.padding(10)
					.background(
						viewModel.willSpeakItem.content == speechText.content
						? AnyView(BlurView(style: .regular))
						: AnyView(Color.clear)
					)
					.cornerRadius(10)
				
            }
            .scrollContentBackground(.hidden)
            .padding(.top, 20)
            .onReceive(viewModel.$speakLocation) { index in
                withAnimation {
                    scrollView.scrollTo(index, anchor: .center)
                }
            }
        }
    }
}

struct SpeakButton: View {
    @ObservedObject var viewModel: XBMSynthViewModel;
    @Binding var selectedVoice: AVSpeechSynthesisVoice;
    @State private var buttonTitle = "开始讲个英语故事";


    var body: some View {
        HStack {
            if viewModel.isSpeaking {
                HStack{
                    Button {
                        if viewModel.isPausing {
                            viewModel.continueSpeak();
                        } else {
                            viewModel.pauseSpeak();
                        }
                    } label: {
                        Text(viewModel.isPausing ? "播放" : "暂停")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .background(.blue)
                            .cornerRadius(8)
                    }
                    .padding(.leading, 80)
                    Spacer()
                    Button {
                        viewModel.stopSpeak();
                    } label: {
                        Text("停止")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .background(.blue)
                            .cornerRadius(8)
                    }
                    .padding(.trailing, 80)
                    
                    
                }
            } else {
                Button {
                    viewModel.storyTapPublisher.send(selectedVoice);
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(16)
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text($buttonTitle.wrappedValue)
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20) // 设置按钮两边距离为 20 点
            }
            
        }
        .padding(.bottom, 40)
    }
}
