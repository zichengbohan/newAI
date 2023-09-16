//
//  SelectSpeakerView.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/15.
//

import SwiftUI
import Combine

struct SelectSpeakerView: View {
    var viewModel: SelectSpeakerViewModel;
    var body: some View {
        NavigationView{
            List(viewModel.items, id: \.self) { item in
                Text(item.name)
            }
        }
        .navigationBarTitle("List", displayMode: .inline)
    }
}

struct SelectSpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        let viewmModel = SelectSpeakerViewModel();
        SelectSpeakerView(viewModel: viewmModel);
    }
}
