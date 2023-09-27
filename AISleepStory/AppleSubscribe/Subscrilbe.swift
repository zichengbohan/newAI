//
//  Subscrilbe.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/25.
//

import SwiftUI
import StoreKit

struct Subscrilbe: View {
    @ObservedObject var viewModel = SubscribeViewModel();
    @Environment(\.presentationMode) var presentationMode // 访问presentationMode
    var body: some View {
        NavigationView {
            VStack {
                Image("app_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .padding(.top, 30)
                Text("选择订阅方案")
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                    .frame(height: 40)
                VStack  {
                    HStack{
                        VStack{
                            Image("vip_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .cornerRadius(4)
                            Spacer()
                                .frame(height: 20)
                            Text(viewModel.displayName)
                                .foregroundColor(.white)
                        }
                        Spacer()
                            .frame(width: 20)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("现价：")
                                Text(viewModel.selectedPrice)
                                    .foregroundColor(.red)
                                    .font(.title)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            Spacer()
                                .frame(width: 200, height: 20)
                            HStack {
                                Text("原价：")
                                Text(viewModel.selectedOriginPrice)
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.white)
                    }
                    
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                .background(Color(red: 49/255, green: 65/255, blue: 87/255))
                .cornerRadius(10)
                Spacer()
                    .frame(height: 40)
                List(viewModel.appProducts, id: \.self) { product in
                    HStack {
                        Text(product.displayName)
                            .frame(height: 50)
                        Spacer()
                        if viewModel.selectedItem == product {
                            Image(systemName: "checkmark") // 显示对号
                                .foregroundColor(.green)
                        }
                    }
                    .background(.white)
                    .onTapGesture {
                        viewModel.selectedPublisher.send(product)
                        viewModel.selectedItem = product;
                    }
                }
                .frame(height: 220)
                .cornerRadius(10)
                
            }
            .padding(.horizontal, 35)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color(red: 34/255, green: 49/255, blue: 68/255))
        }
        .navigationBarTitle("AISleepStory", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:  Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.white) // 设置返回箭头的颜色为白色
        })
    }
}

#Preview {
    Subscrilbe()
}
