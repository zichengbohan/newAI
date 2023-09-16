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
    let speechSynthesizer = AVSpeechSynthesizer() // 创建语音合成器
    @State private var selectedItem: Speaker? = nil
    
    @Binding var selectedSpeaker: String;
    @Environment(\.presentationMode) var presentationMode // 访问presentationMode
    var viewModel: SelectSpeakerViewModel;
    var body: some View {
        NavigationView{
            List(selection: $selectedItem){
                ForEach(viewModel.items) { item in
                    HStack {
                        Button {
                            tryListion(name: item.name, speaker: item.identifier);
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
                            selectedItem = item // 更新选中的项目
                        }
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .listRowBackground(Color(UIColor.systemBackground))
//            .listRowBackground(Color.clear)
        }
        
        .navigationBarTitle("选择人物", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
            // 在此处添加你的自定义返回按钮操作
            presentationMode.wrappedValue.dismiss()
            
        }) {
            Image(systemName: "chevron.backward")
            Text("返回")
        }
        )
    }
    
    func tryListion(name: String, speaker: String)  {
        self.speechSynthesizer.stopSpeaking(at: .word);
        let speechUtterance = AVSpeechUtterance(string: "Hello, my name is \(name)");
        let voice = AVSpeechSynthesisVoice(identifier: speaker);
        
        
        speechUtterance.voice = voice;
        self.speechSynthesizer.speak(speechUtterance);
    }
}

struct SelectSpeakerView_Previews: PreviewProvider {
    @State static var selectedSpeaker = "预览数据";
    static var previews: some View {
        let viewmModel = SelectSpeakerViewModel();
        SelectSpeakerView(selectedSpeaker: $selectedSpeaker, viewModel: viewmModel);
    }
}
