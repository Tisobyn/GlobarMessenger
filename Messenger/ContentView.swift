//
//  ContentView.swift
//  Messenger
//
//  Created by Yermek Sabyrzhan on 8/28/20.
//  Copyright © 2020 Yermek Sabyrzhan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var name = ""
    var body: some View {
        NavigationView{
            ZStack{
                Color.orange
                VStack{
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.top, 12)
                    
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    NavigationLink(destination: MsgPage()){
                        HStack{
                            Text("Join")
                            Image(systemName: "arrow.right.circle.fill").resizable().frame(width: 20, height: 20)
                        }
                    }.frame(width: 100, height: 52)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(27)
                        .padding(.bottom, 15)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MsgPage : View {
    var name = ""
    var body: some View {
        Text("Hello")
    }
}
