//  ConnectView.swift
//  DeepDive
//  Created on 10/29/26.
import CoreImage.CIFilterBuiltins
import SwiftData
import SwiftUI

struct ConnectView: View {
    @AppStorage("name") private var name: String = ""
    @AppStorage("emailAddress") private var emailAddress: String = ""
    @State private var qrCode = UIImage()
    @State private var showingQRCodeScanner = false
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .font(.title)
                    
                    TextField("Email Address", text: $emailAddress)
                        .textContentType(.emailAddress)
                        .font(.title)
                }
                
                Section("QR Code") {
                    Image(uiImage: qrCode)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .contextMenu {
                            ShareLink(item: Image(uiImage: qrCode), preview: SharePreview("My QR Code", image: Image(uiImage: qrCode)))
                        }
                }
            }
            .onAppear(perform: updateQRCode)
            .onChange(of: name, updateQRCode)
            .onChange(of: emailAddress, updateQRCode)
            .navigationTitle("My Information")
            .sheet(isPresented: $showingQRCodeScanner) {
                
            }
        }
    }
    
    func updateQRCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "x.mark.circle") ?? UIImage()
    }
}

#Preview {
    ConnectView()
}
