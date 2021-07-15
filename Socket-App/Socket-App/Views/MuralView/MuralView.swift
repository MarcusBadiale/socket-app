//
//  MuralView.swift
//  Socket-App
//
//  Created by Marcus Vinicius Vieira Badiale on 15/07/21.
//

import SwiftUI

struct MuralView: View {
    @ObservedObject var viewModel: MuralViewModel
    @State var writerText: String = ""
    @State var navigationTitle: String = ""
    
    init(userNickname: String, isWriter: Bool) {
        self.navigationTitle = userNickname
        viewModel = MuralViewModel(userNickname: userNickname, isWriter: isWriter)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                MessageList(viewModel: viewModel)
                Rectangle()
                    .frame(width: 1)
                    .background(Color(.black))
                UserList(viewModel: viewModel)
            }
            if viewModel.isWriter {
                TextField("Mande uma mensagem no mural", text: $writerText, onCommit:  {
                    SocketHelper.shared.sendMessage(message: writerText, withNickname: "Escritor")
                })
                .font(Font.system(size: 40, design: .default))
                .multilineTextAlignment(.leading)
            }
        }
        .navigationTitle(navigationTitle)
        .padding()
        .onAppear {
            SocketHelper.shared.getAllMessages(nickname: "") {}
        }
    }
}

struct UserList: View {
    @ObservedObject var viewModel: MuralViewModel
    
    var body: some View {
        List(viewModel.users) { user in
            VStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(user.isConnected ?? true ? Color.green : Color.red)
                        .frame(width: 20, height: 20)
                    Text(user.nickname ?? "")
                        .font(.system(size: 24))
                        .lineLimit(2)
                }.padding()
                Rectangle()
                    .frame(height: 1)
                    .background(Color(.black))
            }
        }
    }
}

struct MessageList: View {
    @ObservedObject var viewModel: MuralViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(viewModel.messages, id: \.self) { message in
                    MessageCell(message: message)
                }
                Spacer()
            }.frame(width: UIScreen.main.bounds.width / 1.5)
        }
    }
}

struct MessageCell: View {
    var message: Message
    
    var body: some View {
        VStack {
            Text(message.message ?? "")
                .frame(minWidth: 0, maxWidth: .infinity)//, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 100)
                .font(.body)
                .lineLimit(nil)
                .padding()
                .foregroundColor(.black)
                .background(Color(#colorLiteral(red: 0.6549019608, green: 0.9215686275, blue: 0.9764705882, alpha: 1)))
                .cornerRadius(20)
            HStack {
                Spacer()
                Text(message.date ?? "")
                    .font(.caption)
            }
            Rectangle()
                .frame(height: 1)
                .background(Color(.black))
        }.padding()
    }
}

struct MuralView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MuralView(userNickname: "Marcus", isWriter: true)
                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
                .landscape()
        }
    }
}
