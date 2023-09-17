//
//  ContentView.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/9.
//

import SwiftUI
import AVFoundation
import Combine

struct XBMSpeechStoryView: View {
    @ObservedObject var viewModel = XBMSynthViewModel();
    @State private var buttonTitle = "开始讲个英语故事";
    @State private var selectedVoice = AVSpeechSynthesisVoice();
    
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
                            NavigationLink(destination: SelectSpeakerView(selectedVoice: $selectedVoice)) {
                                Text("选择喜欢的声音")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 20)

                            }
                            HStack {
                                Button {
                                    viewModel.storyTapPublisher.send(selectedVoice);
                                } label: {
                                    Text($buttonTitle.wrappedValue)
                                        .frame(maxWidth: .infinity)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(.blue)
                                        .cornerRadius(16)
                                }
                                .padding(.horizontal, 20) // 设置按钮两边距离为 20 点
                            }
                            .padding(.bottom, 40) // 设置按钮与底部距离为 20 点
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        XBMSpeechStoryView()
    }
}

struct SpeakWordsList: View {
    @ObservedObject var viewModel = XBMSynthViewModel();

    var body: some View {
        ScrollViewReader { scrollView in
            List(viewModel.speechTexts, id: \.self) { speechText in
                Text(speechText.content)
                    .foregroundColor((viewModel.willSpeakItem.content == speechText.content) ? .red : .white)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .id(viewModel.speechTexts.firstIndex(of: speechText))
            }
            .scrollContentBackground(.hidden)
            .background(.clear)
            .padding(.top, 20)
            .onReceive(viewModel.$speakLocation) { index in
                withAnimation {
                    scrollView.scrollTo(index, anchor: .center)
                }
            }
        }
    }
}
