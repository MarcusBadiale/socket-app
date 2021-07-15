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
    
    init(userNickname: String, isWriter: Bool) {
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
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .padding()
    }
}

struct UserList: View {
    @ObservedObject var viewModel: MuralViewModel
    
    var body: some View {
        List(viewModel.users) { user in
            VStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 20, height: 20)
                    Text(user.nickname ?? "")
                        .font(.system(size: 24))
                        .lineLimit(2)
                }.padding()
                Rectangle()
                    .frame(height: 1)
                    .background(Color(.black))
            }
        }.frame(width: UIScreen.main.bounds.width / 4)
    }
}

struct MessageList: View {
    @ObservedObject var viewModel: MuralViewModel
    
    var body: some View {
        VStack {
            ForEach(viewModel.messages, id: \.self) { message in
                MessageCell(message: message)
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}

struct MessageCell: View {
    var message: Message
    
    var body: some View {
        VStack {
            Text(message.message ?? "")
                .font(.body)
                .lineLimit(0)
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
