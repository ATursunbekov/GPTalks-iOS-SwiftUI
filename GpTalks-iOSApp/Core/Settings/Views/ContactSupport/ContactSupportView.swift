//
//  ContactSupportView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 24/8/23.
//

import SwiftUI

struct ContactSupportView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var textMessage = ""
    @State private var textEmail = ""
    @State private var showImagePicker: Bool = false
    @State private var image: UIImage? = nil
    @State private var isImageViewerPresented = false
    @State private var showEmail = false
    @State private var email = SupportEmailModel(toAddress: "toc@advb.tech",
                                      subject: "Contact Support",
                                      messageHeader: "")
    @State private var disabledButton = false
    
    private let model = UIDevice.current.model
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                .frame(width: 36, height: 4)
                .padding(.top, 7)
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                        .foregroundColor(Colors.DefaultColors.blue.swiftUIColor)
                }
                
                Spacer()
                
                Text("Contact Support")
                    .font(.custom(FontFamily.SFProDisplay.semibold, size: 17))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    disabledButton = true
                    email.data = image
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if MailView.canSendMail {
                            showEmail.toggle()
                            disabledButton = false
                        } else {
                            print("""
                                This device does not support email \(email.body)
                                """
                            )
                        }
                    }
                } label: {
                    Text("Send")
                        .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                        .foregroundColor(Colors.DefaultColors.blue.swiftUIColor)
                }
                .disabled(disabledButton)
            }
            .padding(.top, 13)
            .padding(.horizontal, 19)
            
            List {
                
                Section(header: Text("TOPIC").foregroundColor(Colors.LabelColor.label03.swiftUIColor)) {
                    TextEditor(text: $textMessage)
                        .foregroundColor(.white)
                        .background (
                            Text("Describe your question")
                                .foregroundColor(.white)
                                .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 2)
                                .opacity(textMessage.isEmpty ? 1 : 0)
                        )
                }
                .listRowBackground(Colors.FillColor.fill03.swiftUIColor)
                
                Section(header: Text("ATTACHMENT").foregroundColor(Colors.LabelColor.label03.swiftUIColor)) {
                    Button {
                        self.showImagePicker.toggle()
                    } label: {
                        HStack {
                            Text("Attach photo")
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image("chevron.right")
                                .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                        }
                    }
                    
                    if let image = self.image {
                        Button(action: {
                            self.isImageViewerPresented.toggle()
                        }) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        }
                        
                        Button(action: {
                            self.image = nil
                        }) {
                            Text("Delete Photo")
                                .foregroundColor(.red)
                        }
                    }
                }
                .listRowBackground(Colors.FillColor.fill03.swiftUIColor)
                
                Section(header: Text("DEVICE INFO").foregroundColor(Colors.LabelColor.label03.swiftUIColor)) {
                    HStack {
                        Text("Device")
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(UIDevice.current.modelName)
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                            .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                    }
                    .listRowBackground(Colors.FillColor.fill03.swiftUIColor)
                    
                    HStack {
                        Text("iOS")
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(UIDevice.current.systemVersion)
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                            .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                    }
                    .listRowBackground(Colors.FillColor.fill03.swiftUIColor)
                    
                }
                
                Section(header: Text("APP INFO").foregroundColor(Colors.LabelColor.label03.swiftUIColor)) {
                    HStack {
                        Text("App name")
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("GPTalks")
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                            .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                    }
                    .listRowBackground(Colors.FillColor.fill03.swiftUIColor)
                    
                    HStack {
                        Text("Version")
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(Bundle.main.appVersion)
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                            .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                    }
                    .listRowBackground(Colors.FillColor.fill03.swiftUIColor)
                    
                }
            }
            .dismissKeyboardOnDrag()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            .sheet(isPresented: $isImageViewerPresented) {
                ImageViewer(image: self.image!, isPresented: self.$isImageViewerPresented)
            }
            .sheet(isPresented: $showEmail) {
                MailView(supportEmail: $email) { result in
                    switch result {
                    case .success:
                        print("SENT")
                        presentationMode.wrappedValue.dismiss()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .onChange(of: textMessage) { newValue in
            email.messageHeader = newValue
        }
        .background(Colors.SystemBackgrounds.background01.swiftUIColor)
        .edgesIgnoringSafeArea(.all)
    }

}

struct ContactSupportView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
