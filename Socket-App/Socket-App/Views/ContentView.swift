//
//  ContentView.swift
//  Socket-App
//
//  Created by Marcus Vinicius Vieira Badiale on 12/07/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showingWriterAlert = false
    @State private var shouldNavigate = false
    @State private var userNickname = ""
    @State var isWriter = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                NavigationLink("", destination: MuralView(userNickname: userNickname, isWriter: isWriter),
                    isActive: $shouldNavigate)
                Button("Entrar como escritor") {
                    showingWriterAlert = true
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Color(.red))
                .foregroundColor(.white)
                
                Button("Entrar como leitor") {
                    alertView()
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Color(.red))
                .foregroundColor(.white)
            
            }.padding(.horizontal)
            .alert(isPresented: $showingWriterAlert, content: {
                Alert(title: Text("Entrar"), message: Text("Tem certeza que deseja entrar como escritor?"), primaryButton: .default(Text("Confirmar"), action: {
                    SocketHelper.shared.joinChatRoom(nickname: "Escritor", completion: {
                        self.isWriter = true
                        self.shouldNavigate = true
                    })
                }), secondaryButton: .cancel(Text("Cancelar"), action: {
                    showingWriterAlert = false
                }))
            })
            .navigationTitle("Mural App")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func alertView() {
        let alert = UIAlertController(title: "Nickname", message: "Seu nickname vai aparecer para os outros usuarios", preferredStyle: .alert)
        
        alert.addTextField { pass in
            pass.placeholder = "Ex: Marcus..."
        }
        
        let done = UIAlertAction(title: "Confirmar", style: .default) { _ in
            guard let typedNickname = alert.textFields?[0].text else {
                return
            }
            SocketHelper.shared.joinChatRoom(nickname: typedNickname, completion: {
                self.userNickname = typedNickname
                self.shouldNavigate = true
            })
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .destructive) { _ in
            return
        }
        
        alert.addAction(done)
        alert.addAction(cancel)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: { })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
