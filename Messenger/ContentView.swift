//
//  ContentView.swift
//  Messenger
//
//  Created by Yermek Sabyrzhan on 8/28/20.
//  Copyright © 2020 Yermek Sabyrzhan. All rights reserved.
//

import SwiftUI
import Firebase

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
                    
                    NavigationLink(destination: MsgPage(name: self.name)){
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
    @ObservedObject var msg = observer()
    @State var typedmsg = ""
    
    var body: some View {
        VStack{
            List(msg.msgs){ i in
                if(i.name == self.name){
                    MsgRow(msg:i.msg, myMsg: true, user: i.name)
                }
                else {
                    MsgRow(msg:i.msg, myMsg: false, user: i.name)

                }
            }.navigationBarTitle("Chats", displayMode: .large)
            HStack{
                TextField("Type message", text: $typedmsg)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    self.msg.addMsg(msg: self.typedmsg, user: self.name)
                    self.typedmsg = ""
                }) {
                    Text("Send")
                }
            }.padding()
        }
    }
}

class observer : ObservableObject {
    @Published var msgs = [dataType]()
    init(){
        let db = Firestore.firestore()
        db.collection("msgs").addSnapshotListener { (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                if i.type == .added{
                    let name = i.document.get("name") as! String
                    let msg = i.document.get("msg") as! String
                    let id = i.document.documentID
                    
                    self.msgs.append(dataType(id: id, name: name, msg: msg))
                }
            }
        }
    }
    func addMsg(msg: String, user : String) {
        let db = Firestore.firestore()
        db.collection("msgs").addDocument(data: ["msg":msg, "name": user]) { (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            print("success")
        }
        
    }
}
struct dataType : Identifiable{
    var id : String
    var name : String
    var msg : String
}

struct MsgRow : View {
    var msg = ""
    var myMsg = false
    var user = ""
    
    var body: some View{
        HStack{
            if myMsg{
                Spacer()
                Text(msg).padding(8).background(Color.red).cornerRadius(6)
                    .foregroundColor(.white)
            }
            else{
                VStack(alignment: .leading){
                    Text(msg).padding(8).background(Color.red).cornerRadius(6)
                                   .foregroundColor(.white)
                    Text(user)
                }
                Spacer()
            }
        }
    }
}
