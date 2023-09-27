//
//  SelectSpeakerView.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/15.
//

import SwiftUI
import Combine
import AVFAudio

struct SelectSpeakerView: View {
    @ObservedObject var viewModel = SelectSpeakerViewModel()
    let speechSynthesizer = AVSpeechSynthesizer() // 创建语音合成器
    @State private var selectedItem: Speaker? = nil
    
    @Binding var selectedVoice: AVSpeechSynthesisVoice;
    @Environment(\.presentationMode) var presentationMode // 访问presentationMode
    var body: some View {
        NavigationView{
            List(selection: $selectedItem){
                Text("所有声音都是通过自动获取系统支持的声音，请选择自己喜欢的语音,清空将使用您系统设置内“辅助功能”声音的默认项")
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                ForEach(viewModel.items) { item in
                    HStack {
                        Button {
                            tryListion(name: item.name, voice: item.voice);
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.blue)
                                .font(.largeTitle)
                        }
                        HStack {
                            Text(item.name)
                                .onTapGesture {
                                    selectedItem = item // 更新选中的项目
                                }
                            Spacer()
                            if selectedItem == item {
                                Image(systemName: "checkmark") // 显示对号
                            }
                        }
                        .tag(item)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedItem = item; // 更新选中的项目
                            selectedVoice = item.voice;
                        }
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .listRowBackground(Color(UIColor.systemBackground))
//            .listRowBackground(Color.clear)
        }
        .navigationBarTitle("选择声音", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
            // 在此处添加你的自定义返回按钮操作
            presentationMode.wrappedValue.dismiss()
            
        }) {
            Image(systemName: "chevron.backward");
            Text("返回");
        }, trailing:
                                Button(action: {
            // 在此处添加你的自定义返回按钮操作
            selectedVoice = AVSpeechSynthesisVoice();
            presentationMode.wrappedValue.dismiss();
        }) {
            Text("清空")
        })
        .onAppear {
            selectedItem = viewModel.items.first;
            selectedVoice = selectedItem!.voice;
        }
    }
    
    func tryListion(name: String, voice: AVSpeechSynthesisVoice)  {
        self.speechSynthesizer.stopSpeaking(at: .word);
        let speechUtterance = AVSpeechUtterance(string: "Hello, my name is \(name)");
        speechUtterance.voice = voice;
        self.speechSynthesizer.speak(speechUtterance);
    }
}

struct SelectSpeakerView_Previews: PreviewProvider {
    @State static var selectedVoice = AVSpeechSynthesisVoice();
    static var previews: some View {
        let viewmModel = SelectSpeakerViewModel();
        SelectSpeakerView(selectedVoice: $selectedVoice);
    }
}
